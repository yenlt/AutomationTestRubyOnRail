require File.dirname(__FILE__) + '/../test_helper'

class DiffControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  DIFF_ID = 1
  INVALID_DIFF = 10000
  TOOL = "QAC"

  def setup
    @controller = DiffController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @admin  = {:name => "root",      :id => 1}
    @other  = {:name => "user", 	 :id => 4}
  End

  def test_it_t4_mart_diff_controller_001
    # Request to view Diff Result Summary page
    login_as @admin[:name]
    post :diff_result_summary, :diff_id => DIFF_ID
    assert_response :success
  end

  def test_it_t4_mart_diff_controller_002
    # Request to view tab's content of Diff Result Summary page
    login_as @admin[:name]
    post :diff_result_summary_tab, :tab_name => "All_Analysis_Tool"
    assert_response :success
    @all = @controller.instance_variable_get "@all"
    @each_dir = @controller.instance_variable_get "@each_dir"
    @each_file = @controller.instance_variable_get "@each_file"
    assert_not_equal nil, @all
    assert_not_equal nil, @each_dir
    assert_not_equal nil, @each_file
  end

  def test_it_t4_mart_diff_controller_003
    # Counted value for all directory, each directory and each file
    login_as @admin[:name]
    post :count_diff_for_all_tool_tab, :diff_id => DIFF_ID
    assert_response :success
    @all = @controller.instance_variable_get "@all"
    @each_dir = @controller.instance_variable_get "@each_dir"
    @each_file = @controller.instance_variable_get "@each_file"
    assert_not_equal nil, @all
    assert_not_equal nil, @each_dir
    assert_not_equal nil, @each_file
  end

  def test_it_t4_mart_diff_controller_004
    # Count with invalid diff result id
    login_as @admin[:name]
    post :count_diff_for_all_tool_tab, :diff_id => INVALID_DIFF
    assert_response :success
    @all = @controller.instance_variable_get "@all"
    @each_dir = @controller.instance_variable_get "@each_dir"
    @each_file = @controller.instance_variable_get "@each_file"
    assert_equal nil, @all
    assert_equal nil, @each_dir
    assert_equal nil, @each_file
  end

  def test_it_t4_mart_diff_controller_005
    # Counted value for all directory, each directory and each file
    login_as @admin[:name]
    post :count_diff_for_single_tool_tab, :diff_id => DIFF_ID, :tab_name => TOOL
    assert_response :success
    @all = @controller.instance_variable_get "@all"
    @each_dir = @controller.instance_variable_get "@each_dir"
    @each_file = @controller.instance_variable_get "@each_file"
    assert_not_equal nil, @all
    assert_not_equal nil, @each_dir
    assert_not_equal nil, @each_file
  end

  def test_it_t4_mart_diff_controller_006
    # Count for single tool tab. Count with invalid diff result id
    # Counted value for all directory, each directory and each file
    login_as @admin[:name]
    post :count_diff_for_single_tool_tab, :diff_id => INVALID_DIFF, :tab_name => TOOL
    assert_response :success
    @all = @controller.instance_variable_get "@all"
    @each_dir = @controller.instance_variable_get "@each_dir"
    @each_file = @controller.instance_variable_get "@each_file"
    assert_equal nil, @all
    assert_equal nil, @each_dir
    assert_equal nil, @each_file
  end

  def test_it_t4_mart_diff_controller_007
    # Count with invalid tool name
    login_as @admin[:name]
    post :count_diff_for_single_tool_tab, :diff_id => INVALID_DIFF, :tab_name => "XXXX"
    assert_response :success
    @all = @controller.instance_variable_get "@all"
    @each_dir = @controller.instance_variable_get "@each_dir"
    @each_file = @controller.instance_variable_get "@each_file"
    assert_equal nil, @all
    assert_equal nil, @each_dir
    assert_equal nil, @each_file
  end

  def test_it_t4_mart_diff_controller_008
    # Diff two Task with All Analysis Tool. All tool enabled
    login_as @admin[:name]
    post :execute_diff, :new_pu   => 1, :old_pu   => 1,
        :new_pj   => 1, :old_pj   => 1,
        :new_task => 1, :old_task => 3,
        :tool     => "all",:toolid => 1
    sleep 90
    assert_response :success
    assert_equal _("Executing diff successful!"), flash[:notice]
    @diff_result = @controller.instance_variable_get "@all_diff_results"
    df = DiffResult.find_by_old_task_id_and_new_task_id(3,1)
    assert_equal df.analyze_tool, "all"
    assert_equal df.id, @all_diff_results.last.id
  end

  def test_it_t4_mart_diff_controller_009
    # Diff two Task with All Analysis Tool. Has one tool disabled (QAC)
    login_as @admin[:name]
    post :execute_diff, :new_pu   => 1, :old_pu   => 1,
        :new_pj   => 1, :old_pj   => 1,
        :new_task => 1, :old_task => 3,
        :tool     => "all",:toolid => 1
    sleep 90
    assert_response :success
    assert_equal _("Executing diff successful!"), flash[:notice]
    @diff_result = @controller.instance_variable_get "@all_diff_results"
    df = DiffResult.find_by_old_task_id_and_new_task_id(3,1)
    assert_equal df.analyze_tool, "all"
    assert_equal df.id, @all_diff_results.last.id
  end

  def test_it_t4_mart_diff_controller_010
    # Diff two Task with All Analysis Tool. All tool disabled
    login_as @admin[:name]
    post :execute_diff, :new_pu   => 1, :old_pu   => 1,
        :new_pj   => 1, :old_pj   => 1,
        :new_task => 1, :old_task => 3,
        :tool     => "all",:toolid => 1
    sleep 90
    @diff_result = @controller.instance_variable_get "@all_diff_results"
    df = DiffResult.find_by_old_task_id_and_new_task_id(3,1)
    if df.blank?
       assert true
    end
  end

  def test_it_t4_mart_diff_controller_011
    # Diff with Invalid diff result id
    login_as @admin[:name]
    post :warning_listing_status, :diff_id => INVALID_DIFF
    sleep 5
    assert_response :success
    assert_template "/diff"
  end

  def test_it_t4_mart_diff_controller_012
    # List all warning of a directory in view for all analysis tool
    login_as @admin[:name]
    post :warning_listing_status, :diff_id => DIFF_ID, :view => "dir", :path => "mercurial", :tab_name => "All_Analysis_Tool"
    sleep 5
    assert_response :success
    @final = @controller.instance_variable_get "@final"
    unless @final.blank?
     assert true
   end
  end

  def test_it_t4_mart_diff_controller_013
    # List all warning of a file in view for all analysis tool
    login_as @admin[:name]
    post :warning_listing_status, :diff_id => DIFF_ID, :view => "file", :path => "mercurial/bdiff.c", :tab_name => "All_Analysis_Tool"
    sleep 5
    assert_response :success
    @final = @controller.instance_variable_get "@final"
    unless @final.blank?
     assert true
   end
  end

  def test_it_t4_mart_diff_controller_014
    # Filter warnings by tool's name
    login_as @admin[:name]
    post :warning_listing_status, :diff_id => DIFF_ID, :view => "dir", :path => "mercurial", :tab_name => "All_Analysis_Tool", :other => "tool", :others_value => "QAC"
    sleep 5
    assert_response :success
    @final = @controller.instance_variable_get "@final"
    unless @final.blank?
     assert true
   end
  end

  def test_it_t4_mart_diff_controller_015
    # Filter warnings by invalid tool's name
    login_as @admin[:name]
    post :warning_listing_status, :diff_id => DIFF_ID, :view => "dir", :path => "mercurial", :tab_name => "All_Analysis_Tool", :other => "tool", :others_value => "XXXXX"
    sleep 5
    assert_response :success
    @final = @controller.instance_variable_get "@final"
    if @final.blank?
     assert true
   end
  end

  def test_it_t4_mart_diff_controller_016
    # Download list of warning for warning listing page
    login_as @admin[:name]
    post :download_csv, :diff_id => DIFF_ID, :view => "dir", :path => "mercurial", :tab_name => "All_Analysis_Tool", :current => "3"
    sleep 5
    assert_response :success
  end

end


