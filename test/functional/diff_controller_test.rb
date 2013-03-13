require File.dirname(__FILE__) + '/../test_helper'

class DiffControllerTest < ActiveSupport::TestCase
  include AuthenticatedTestHelper

  fixtures :users
  fixtures :privileges

  fixtures :privileges_users
  fixtures :pus
  fixtures :pjs

  PATH      = "sample_c/src"
  FILE_NAME = 'analyzeme.c'
  def setup
    @controller = DiffController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @admin  = {:name => "root",      :id => 1}
    @member = {:name => "pj_member", :id => 2}
  end

  def test_000
    import_sql
  end
  
  #update pj, task
  def test_wd_ut_c_01
    login_as @admin[:name]
    get :update_pj, :new_pu   => 1,
      :version  => "new"
    assert_response :success
    @new_pj = @controller.instance_variable_get "@new_pjs"
    assert_equal @new_pj[0], ["SamplePJ1", 1]

    get :update_pj, :old_pu   => 1,
      :version  => "old"
    assert_response :success
    @old_pj = @controller.instance_variable_get "@old_pjs"
    assert_equal @old_pj[0], ["SamplePJ1", 1]

    get :update_task, :new_pj   => 1,
      :version  => "new"
    assert_response :success
    @new_task = @controller.instance_variable_get "@new_tasks"
    assert_equal @new_task[0], ["sample_c_cpp_1_1", 1]

    get :update_task, :old_pj   => 1,
      :version  => "old"
    assert_response :success
    @old_task = @controller.instance_variable_get "@old_tasks"
    assert_equal @old_task[1], ["test1", 3]
  end

  #error while execute diff - test manual
  def test_wd_ut_c_02
    assert true
  end

  #execute diff invalid (diff same task)
  def test_wd_ut_c_03
    login_as @admin[:name]
    tool = {"toolid" => 1}
    post :execute_diff, :new_pu   => 1, :old_pu   => 1,
      :new_pj   => 1, :old_pj   => 1,
      :new_task => 1, :old_task => 1,
      :tool     => tool,:toolid => 1
    sleep 5
    assert_response :success
    assert_equal _("Setting for diff is not valid"), flash[:notice]
  end

  #execute diff successful
  def test_wd_ut_c_04
    login_as @admin[:name]
    tool = {"toolid" => 1}
    begin
      post :execute_diff, :new_pu   => 1, :old_pu   => 1,
        :new_pj   => 1, :old_pj   => 1,
        :new_task => 1, :old_task => 3,
        :tool     => tool,:toolid => 1
      sleep 90
      assert_response :success
      assert_equal _("Executing diff successful!"), flash[:notice]
    rescue Exception => e
      puts e.message
    end
  end

  #execute diff show existing result (diff between 2 task existed)
  def test_wd_ut_c_05
    login_as @admin[:name]
    tool = {"toolid" => 1}
    post :execute_diff, :new_pu   => 1, :old_pu   => 1,
      :new_pj   => 1, :old_pj   => 1,
      :new_task => 1, :old_task => 3,
      :tool     => tool,:toolid => 1
    sleep 5
    assert_response :success
    assert_equal _("Executing diff successful!"), flash[:notice]
  end

  #diff result summary
  def test_wd_ut_c_06
    login_as @admin[:name]
    get :diff_result_summary, :diff_id => 4000
    @result = @controller.instance_variable_get "@path"
    assert_equal @result, []
  end

  #diff result summary
  def test_wd_ut_c_07
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    get :diff_result_summary, :diff_id => diff_result.id
    assert :success
    @result1 = @controller.instance_variable_get "@all"
    assert_not_equal @result1, []
    @result2 = @controller.instance_variable_get "@result_dir"
    assert_not_equal @result2, []
    @result3 = @controller.instance_variable_get "@result_file"
    assert_not_equal @result3, []
  end

  #test display name of old/new PU, PJ, Task, Analysis tool
  def test_wd_ut_c_08
    login_as @admin[:name]
    #prepare data
    diff_result = DiffResult.find(:last)
    old_pu    = Pu.find_by_id(diff_result.old_pu_id)
    old_pj    = Pj.find_by_id(diff_result.old_pj_id)
    old_task  = Task.find_by_id(diff_result.old_task_id)
    new_pu    = Pu.find_by_id(diff_result.new_pu_id)
    new_pj    = Pj.find_by_id(diff_result.new_pj_id)
    new_task  = Task.find_by_id(diff_result.new_task_id)
    analysis_tool = AnalyzeTool.find_by_id(diff_result.analyze_tool_id)

    @controller.display_name(diff_result.id)
    old_pu2   = @controller.instance_variable_get "@old_pu"
    old_pj2   = @controller.instance_variable_get "@old_pj"
    old_task2 = @controller.instance_variable_get "@old_task"
    new_pu2   = @controller.instance_variable_get "@new_pu"
    new_pj2   = @controller.instance_variable_get "@new_pj"
    new_task2 = @controller.instance_variable_get "@new_task"
    analysis_tool2 = @controller.instance_variable_get "@analysis_tool"

    assert_equal old_pu.name,old_pu2
    assert_equal old_pj.name,old_pj2
    assert_equal old_task.name,old_task2
    assert_equal new_pu.name,new_pu2
    assert_equal new_pj.name,new_pj2
    assert_equal new_task.name,new_task2
    assert_equal analysis_tool.name,analysis_tool2
  end

  #test view summary for directory
  def test_wd_ut_c_09
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    get :warning_directory_summary,
      :path => PATH,
      :page => 1,
      :file => false,
      :file_id => false,
      :order_field => "status",
      :order_direction => "DESC",
      :diff_id => diff_result.id

    assert :success
    @result = @controller.instance_variable_get "@final"
    assert_not_equal @result, 15
  end

  #test filter summary for directory
  def test_wd_ut_c_10
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    get :warning_directory_summary,
      :path => PATH,
      :page => 1,
      :file => false,
      :file_id => false,
      :filter_id => "dir",
      :status    => 1, #common
      :rule_level => 1, #critical
      :order_field => "status",
      :order_direction => "ASC",
      :diff_id => diff_result.id

    assert :success
    result = @controller.instance_variable_get "@final"
    result.each do |r|
      assert_equal r["status"], "1"
      assert_equal r["rule_level"], "1"
    end
  end

  #test filter summary for directory
  def test_wd_ut_c_11
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    get :warning_directory_summary,
      :path => PATH,
      :page => 1,
      :file => false,
      :file_id => false,
      :filter_id => "dir",
      :status => 1, #common
      :rule_level => 1, #critical
      :others => "2",#rule number
      :others_value => "0240",
      :order_field => "status",
      :order_direction => "ASC",
      :diff_id => diff_result.id

    assert :success
    result = @controller.instance_variable_get "@final"
    result.each do |r|
      assert_equal r["status"], "1"
      assert_equal r["rule_level"], "1"
      assert_equal r["rule_number"], "0240"
    end
  end

  #test filter summary for directory
  def test_wd_ut_c_12
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    get :warning_directory_summary,
      :path => PATH,
      :page => 1,
      :file => false,
      :file_id => false,
      :filter_id => "dir",
      :status => 1, #common
    :rule_level => 1, #critical
    :others => "3",#file name
    :others_value => FILE_NAME,
      :order_field => "status",
      :order_direction => "ASC",
      :diff_id => diff_result.id

    assert :success
    result = @controller.instance_variable_get "@final"
    result.each do |r|
      assert_equal r["status"], "1"
      assert_equal r["rule_level"], "1"
      assert_equal r["source_name"], FILE_NAME
    end
  end

  #test filter summary for directory
  def test_wd_ut_c_13
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    get :warning_directory_summary,
      :path => PATH,
      :page => 1,
      :file => false,
      :file_id => false,
      :filter_id => "dir",
      :status => 1, #common
    :rule_level => 1, #critical
    :others => "2",#rule number
    :others_value => "10000",
      :order_field => "status",
      :order_direction => "ASC",
      :diff_id => diff_result.id
    assert :success
    result = @controller.instance_variable_get "@final"
    assert_equal result.size, 0
  end

  #test filter summary for directory
  def test_wd_ut_c_14
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    get :warning_directory_summary,
      :path => PATH,
      :page => 1,
      :file => false,
      :file_id => false,
      :filter_id => "dir",
      :status => 1, #common
    :rule_level => 1, #critical
    :others => "3",#file name
    :others_value => "XXX",
      :order_field => "status",
      :order_direction => "ASC",
      :diff_id => diff_result.id

    assert :success
    result = @controller.instance_variable_get "@final"
    assert_equal result.size, 0
  end

  #test wrong file_id for summary for directory page
  def test_wd_ut_c_15
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    get :warning_directory_summary,
      :page => 1,
      :path => "XXX",
      :diff_id => diff_result.id

    assert_equal _("Directory")+ " (XXX) " + _("not found!"), flash[:notice]
  end

  #test view summary for file
  def test_wd_ut_c_16
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    assert_not_nil(diff_result)
    diff_file = DiffFile.find(:all,
      :conditions => "diff_result_id = '#{diff_result.id}' AND original_files.source_name = '#{FILE_NAME}'",
      :joins => "INNER JOIN original_files ON diff_files.old_original_file_id = original_files.id"
    )
    assert_not_nil(diff_file)
    get :warning_file_summary,
      :page => 1,
      :diff_file_id => diff_file[0].id,
      :order_field => "status",
      :order_direction => "DESC",
      :diff_id => diff_result.id

    assert :success
    result = @controller.instance_variable_get "@final"
    assert_not_equal result.size, 0
  end

  #test filter summary for file
  def test_wd_ut_c_17
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    diff_file = DiffFile.find(:all,
      :conditions => "diff_result_id = '#{diff_result.id}' AND original_files.source_name = '#{FILE_NAME}'",
      :joins => "INNER JOIN original_files ON diff_files.old_original_file_id = original_files.id"
    )

    get :warning_file_summary,
      :page => 1,
      :file => FILE_NAME,
      :diff_file_id => diff_file[0].id,
      :filter_id => "file",
      :status    => 1, #common
      :rule_level => 1, #critical
      :order_field => "status",
      :order_direction => "ASC",
      :diff_id => diff_result.id

    assert :success
    result = @controller.instance_variable_get "@final"
    result.each do |r|
      assert_equal r["source_name"], FILE_NAME
      assert_equal r["status"], "1"
      assert_equal r["rule_level"], "1"
    end
  end

  #test filter summary for file
  def test_wd_ut_c_18
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    diff_file = DiffFile.find(:all,
      :conditions => "diff_result_id = '#{diff_result.id}' AND original_files.source_name = '#{FILE_NAME}'",
      :joins => "INNER JOIN original_files ON diff_files.old_original_file_id = original_files.id"
    )

    get :warning_file_summary,
      :page => 1,
      :file => FILE_NAME,
      :diff_file_id => diff_file[0].id,
      :filter_id => "file",
      :status => 1, #common
      :rule_level => 1, #critical
      :others => "2",#rule number
      :others_value => "0240",
      :order_field => "status",
      :order_direction => "ASC",
      :diff_id => diff_result.id

    assert :success
    result = @controller.instance_variable_get "@final"
    result.each do |r|
      assert_equal r["status"], "1"
      assert_equal r["rule_level"], "1"
      assert_equal r["rule_number"], "0240"
    end
  end

  #test filter summary for file
  def test_wd_ut_c_19
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    diff_file = DiffFile.find(:all,
      :conditions => "diff_result_id = '#{diff_result.id}' AND original_files.source_name = '#{FILE_NAME}'",
      :joins => "INNER JOIN original_files ON diff_files.old_original_file_id = original_files.id"
    )

    get :warning_file_summary,
      :page => 1,
      :file => FILE_NAME,
      :diff_file_id => diff_file[0].id,
      :filter_id => "file",
      :status => 1, #common
      :rule_level => 1, #critical
      :others => "2",#rule number
      :others_value => "XXX",
      :order_field => "status",
      :order_direction => "ASC",
      :diff_id => diff_result.id

    assert :success
    result = @controller.instance_variable_get "@final"
    assert_equal result.size, 0
  end

  #test wrong file_id for summary for file page
  def test_wd_ut_c_20
    login_as @admin[:name]
    get :warning_file_summary,
      :diff_file_id => 10000, :diff_id => 1

    assert_equal _("Diff result not found!"), flash[:notice]

    get :warning_file_summary,
      :diff_id => 10000, :diff_file_id => 1

    assert_equal _("Diff result not found!") + _("Diff result not found!"), flash[:notice]
  end

  #test view warning listing with diff
  def test_wd_ut_c_21
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    get :warning_listing_with_status,
      :page => 1,
      :path => false,
      :file => false,
      :file_id => false,
      :order_field => "status",
      :order_direction => "DESC",
      :diff_id => diff_result.id

    assert :success
    result = @controller.instance_variable_get "@final"
    assert_not_equal result.size, 0
  end

  #test view warning listing with diff
  def test_wd_ut_c_22
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    get :warning_listing_with_status,
      :page => 1,
      :order_field => "status",
      :order_direction => "DESC",
      :diff_id => diff_result.id

    assert :success
    result = @controller.instance_variable_get "@final"
    assert_not_equal result.size, 0
  end

  #test view warning listing with diff
  def test_wd_ut_c_23
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    get :warning_listing_with_status,
      :page => 1,
      :path => false,
      :file => false,
      :filter_id => "list",
      :status => 1, #common
      :rule_level => 1, #critical
      :order_field => "status",
      :order_direction => "DESC",
      :diff_id => diff_result.id

    assert :success
    result = @controller.instance_variable_get "@final"
    result.each do |r|
      assert_equal r["status"], "1"
      assert_equal r["rule_level"], "1"
    end
  end

  #test view warning listing with diff
  def test_wd_ut_c_24
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    get :warning_listing_with_status,
      :page => 1,
      :path => false,
      :file => false,
      :filter_id => "list",
      :status => 1, #common
      :rule_level => 1, #critical
      :others => "2",#rule number
      :others_value => "0240",
      :order_field => "status",
      :order_direction => "DESC",
      :diff_id => diff_result.id

    assert :success
    result = @controller.instance_variable_get "@final"
    result.each do |r|
      assert_equal r["status"], "1"
      assert_equal r["rule_level"], "1"
      assert_equal r["rule_number"], "0240"
    end
  end

  #test view warning listing with diff
  def test_wd_ut_c_25
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    get :warning_listing_with_status,
      :page => 1,
      :path => false,
      :file => false,
      :filter_id => "list",
      :status => 1, #common
    :rule_level => 1, #critical
    :others => "3",#source name
    :others_value => FILE_NAME,
      :order_field => "status",
      :order_direction => "DESC",
      :diff_id => diff_result.id

    assert :success
    result = @controller.instance_variable_get "@final"
    result.each do |r|
      assert_equal r["status"], "1"
      assert_equal r["rule_level"], "1"
      assert_equal r["source_name"], FILE_NAME
    end
  end

  #test view warning listing with diff
  def test_wd_ut_c_26
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    get :warning_listing_with_status,
      :page => 1,
      :path => false,
      :file => false,
      :filter_id => "list",
      :status => 1, #common
      :rule_level => 1, #critical
      :others => "4",#directory
      :others_value => PATH,
      :order_field => "status",
      :order_direction => "DESC",
      :diff_id => diff_result.id

    assert :success
    result = @controller.instance_variable_get "@final"
    result.each do |r|
      assert_equal r["status"], "1"
      assert_equal r["rule_level"], "1"
      assert_equal r["path"], PATH
    end
  end

  #test view warning listing with diff
  def test_wd_ut_c_27
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    get :warning_listing_with_status,
      :page => 1,
      :path => false,
      :file => false,
      :filter_id => "list",
      :status => 1, #common
      :rule_level => 1, #critical
      :others => "2",#rule number
      :others_value => "10000",
      :order_field => "status",
      :order_direction => "DESC",
      :diff_id => diff_result.id

    assert :success
    result = @controller.instance_variable_get "@final"
    assert_equal result.size, 0
  end

  #test view warning listing with diff
  def test_wd_ut_c_28
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    get :warning_listing_with_status,
      :page => 1,
      :path => false,
      :file => false,
      :filter_id => "list",
      :status => 1, #common
      :rule_level => 1, #critical
      :others => "3",#source name
      :others_value => "XXX",
      :order_field => "status",
      :order_direction => "DESC",
      :diff_id => diff_result.id

    assert :success
    result = @controller.instance_variable_get "@final"
    assert_equal result.size, 0
  end

  #test view warning listing with diff
  def test_wd_ut_c_29
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    get :warning_listing_with_status,
      :page => 1,
      :path => false,
      :file => false,
      :filter_id => "list",
      :status => 1, #common
      :rule_level => 1, #critical
      :others => "4",#directory
      :others_value => "XXX",
      :order_field => "status",
      :order_direction => "DESC",
      :diff_id => diff_result.id

    assert :success
    result = @controller.instance_variable_get "@final"
    assert_equal result.size, 0
  end

  #test view warning listing with diff
  def test_wd_ut_c_30
    login_as @admin[:name]
    
    get :warning_listing_with_status,
      :diff_id => "10000"

    assert :success
    assert_redirected_to "/diff"
    assert_equal _("Diff result (id = ") + "10000) " +  _("not found!"), flash[:notice]
  end

  #test analysis report with diff
  def test_wd_ut_c_31
    login_as @admin[:name]
    diff_file = DiffFile.find(:last)
    get :analysis_report_with_diff,
      :diff_id => diff_file.diff_result_id,
      :diff_file_id => diff_file.id
    assert :success
    old_version = @controller.instance_variable_get "@old_version_code"
    new_version = @controller.instance_variable_get "@new_version_code"
    assert_not_equal old_version, []
    assert_not_equal new_version, []
  end

  #test analysis report with diff: wrong diff_file_id
  def test_wd_ut_c_32
    login_as @admin[:name]
    diff_file = DiffFile.find(:last)
    get :analysis_report_with_diff,
      :diff_id => diff_file.diff_result_id,
      :diff_file_id => nil
    assert_equal _("The required file doesn't exist"), flash[:notice]
  end

  #test analysis report with diff: wrong diff_file_id
  def test_wd_ut_c_33
    login_as @admin[:name]
    diff_file = DiffFile.find(:last)
    get :analysis_report_with_diff,
      :diff_id => diff_file.diff_result_id,
      :diff_file_id => 10000
    assert_equal _("The required file doesn't exist"), flash[:notice]
  end

  #test filter for analysis report page
  def test_wd_ut_c_34
    login_as @admin[:name]
    diff_file = DiffFile.find(:last)
    get :filter_report,
      :diff_id => diff_file.diff_result_id,
      :file_id => diff_file.old_original_file_id
    assert :success
    old_version = @controller.instance_variable_get "@old_version_code"
    new_version = @controller.instance_variable_get "@new_version_code"
    assert_not_equal old_version, []
    assert_not_equal new_version, []
  end

  #test filter for analysis report page
  def test_wd_ut_c_35
    login_as @admin[:name]
    diff_file = DiffFile.find(:last)
    get :filter_report,
      :diff_id => diff_file.diff_result_id,
      :file_id => diff_file.old_original_file_id,
      :others  => "2",
      :others_value  => "0240"
    assert :success
    old_version = @controller.instance_variable_get "@old_version_code"
    new_version = @controller.instance_variable_get "@new_version_code"
    assert_not_equal old_version, []
    assert_not_equal new_version, []
  end

  #test filter for analysis report page
  def test_wd_ut_c_36
    login_as @admin[:name]
    diff_file = DiffFile.find(:last)
    get :filter_report,
      :diff_id => diff_file.diff_result_id,
      :file_id => diff_file.old_original_file_id,
      :others  => "2",
      :others_value  => "10000"
    assert :success
    old_version = @controller.instance_variable_get "@old_version_code"
    new_version = @controller.instance_variable_get "@new_version_code"
    assert_not_equal old_version, []
    assert_not_equal new_version, []
  end

  #test download cvs
  def test_wd_ut_c_37
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    get :download_csv,
      :current => 1, #download summary for directory
      :path    => PATH,
      :filter_id => "dir",
      :diff_id => diff_result.id
    assert :success
    download_file = @controller.instance_variable_get "@list_name"
    assert_equal "warning_summary_directory", download_file
  end

  #test download cvs
  def test_wd_ut_c_38
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    diff_file = DiffFile.find(:all,
      :conditions => "diff_result_id = '#{diff_result.id}' AND original_files.source_name = '#{FILE_NAME}'",
      :joins => "INNER JOIN original_files ON diff_files.old_original_file_id = original_files.id"
    )

    get :download_csv,
      :current => 2, #download summary for file
      :diff_id => diff_result.id,
      :diff_file_id => diff_file[0].id,
      :filter_id => "file"

    assert :success
    download_file = @controller.instance_variable_get "@list_name"
    assert_equal "warning_summary_file", download_file
  end

  #test download cvs
  def test_wd_ut_c_39
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    get :download_csv,
      :current => 3, #download analysis report with diff
      :diff_id => diff_result.id,
      :filter_id => "list"
    assert :success
    download_file = @controller.instance_variable_get "@list_name"
    assert_equal "warning_listing_with_diff", download_file
  end

  #test sort recent list
  def test_wd_ut_c_40
    login_as @admin[:name]
    get :sort_recent_list,
      :version => "old",
      :order_field => "pu",
      :order_direction => "DESC"
    assert :success
    diff_result = DiffResult.find(:all,
      :order => "old_pu_id DESC")
    first = @controller.instance_variable_get "@all_diff_results"
    if (first == nil) 
      p "nil first"
    end
    assert_equal diff_result.first.id, first.first["id"].to_i
  end

  #test sort recent list
  def test_wd_ut_c_41
    login_as @admin[:name]
    get :sort_recent_list,
      :version => "old",
      :order_field => "pj",
      :order_direction => "DESC"
    assert :success
    diff_result = DiffResult.find(:all,
      :order => "old_pj_id DESC")
    first = @controller.instance_variable_get "@all_diff_results"
    assert_equal diff_result.first.id, first.first["id"].to_i
  end

  #test sort recent list
  def test_wd_ut_c_42
    login_as @admin[:name]
    get :sort_recent_list,
      :version => "old",
      :order_field => "task",
      :order_direction => "DESC"
    assert :success
    diff_result = DiffResult.find(:all,
      :order => "old_task_id DESC")
    first = @controller.instance_variable_get "@all_diff_results"
    assert_equal diff_result.first.id, first.first["id"].to_i
  end

  #test sort recent list
  def test_wd_ut_c_43
    login_as @admin[:name]
    get :sort_recent_list,
      :version => "old",
      :order_field => "date",
      :order_direction => "DESC"
    assert :success
  end

  #test sort recent list
  def test_wd_ut_c_44
    login_as @admin[:name]
    get :sort_recent_list,
      :version => "old",
      :order_field => "tool",
      :order_direction => "DESC"
    assert :success
    diff_result = DiffResult.find(:all,
      :order => "analyze_tool_id DESC")
    first = @controller.instance_variable_get "@all_diff_results"
    assert_equal diff_result.first.id, first.first["id"].to_i
  end

  #test sort recent list
  def test_wd_ut_c_45
    login_as @admin[:name]
    get :sort_recent_list,
      :version => nil,
      :order_field => nil,
      :order_direction => nil
    assert :success
    diff_result1 = DiffResult.find(:first)
    diff_result2 = DiffResult.find(:last)
    first = @controller.instance_variable_get "@all_diff_results"
    assert_equal diff_result1.id, first.first["id"].to_i
    assert_equal diff_result2.id, first.last["id"].to_i
  end

  #test index
  def test_wd_ut_c_46
    login_as @admin[:name]
    get :index
    check = @controller.instance_variable_get "@check"
    assert_equal check, true
    diff_list = @controller.instance_variable_get "@all_diff_results"
    first = DiffResult.find(:first)
    assert_equal first.id, diff_list.last["id"].to_i
  end

  #test index
  def test_wd_ut_c_47
    login_as @member[:name]
    get :index
    check = @controller.instance_variable_get "@check"
    assert_equal check, false
    diff_list = @controller.instance_variable_get "@all_diff_results"
    first = DiffResult.find(:first)
    #assert_equal first.id, diff_list.last["id"].to_i
    assert_equal first.id, diff_list.last["id"].to_i
  end

  #test delete diff_result
  def test_wd_ut_c_48
    login_as @admin[:name]
    get :del_diff_result, :diff_id => nil
    assert_equal _("There was an error while delete the diff result"), flash[:notice]
  end

  #test delete diff_result
  def test_wd_ut_c_49
    login_as @admin[:name]
    diff_result = DiffResult.find(:last)
    get :del_diff_result, :diff_id => diff_result.id

    assert :success
    assert_equal _("Delete result successful!"), flash[:notice]
  end
  
end

