require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/setup'

class DiffAdministrationTest < ActionController::IntegrationTest
  # fixtures 
  fixtures :users
  
  Admin_login = "root"
  Admin_pass  = "root"
  DIFF_ADMINISTRATION       = "diff"
  DIFF_RESULT_SUMMARY       = "diff/diff_result_summary"
  SUMMARY_FOR_DIRECTORY     = "diff/warning_directory_summary"
  SUMMARY_FOR_FILE          = "diff/warning_file_summary"
  WARNING_LISTING_WITH_DIFF = "diff/warning_listing_with_status"
  ANALYSIS_RESULT_REPORT    = "diff/analysis_report_with_diff"
  DOWNLOAD_CSV_FORMAT       = "diff/download_csv"
  PATH                      = "sample_cpp/Base/src"
  FILTER                    = "diff/filter_report"
  Tool = {"toolid" => 2}

  def test_000
    import_sql
  end
  
  def test_it_wd_001
    #Access right
    #login as pj member
    login("pj_member", "pj_member")
    get DIFF_ADMINISTRATION
    assert_response :success
  end

  def test_it_wd_002
    #Access right
    #login as pu admin
    login("pu_admin", "pu_admin")
    get DIFF_ADMINISTRATION
    assert_response :success
    assert_select "div#execute_diff"
    assert_select "input[type = 'button'][value = '#{_('Execute Diff')}']"
    assert_select "div#recent_table"
    assert_select "tbody#result_list"
  end

  def test_it_wd_003
    #Access right
    #login as pj admin
    login("pj_admin", "pj_admin")
    get DIFF_ADMINISTRATION
    assert_response :success
    assert_select "div#execute_diff"
    assert_select "input[type = 'button'][value = '#{_('Execute Diff')}']"
    assert_select "div#recent_table"
    assert_select "tbody#result_list"
  end

  ##DIFF ADMINISTRATION
  #
  def test_it_wd_004
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    assert_select "div#execute_diff"
    assert_select "input[type = 'button'][value = '#{_('Execute Diff')}']"
    assert_select "div#recent_table"
    assert_select "tbody#result_list"
  end
  
  def test_it_wd_005
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    get url_for(:controller => DIFF_ADMINISTRATION, :action => "execute_diff",
      :new_pu   => 1, :old_pu   => 1,
      :new_pj   => 2, :old_pj   => 2,
      :new_task => 1, :old_task => 1,
      :tool     => Tool,:toolid => 2)
    assert_equal _("Setting for diff is not valid"), flash[:notice]
  end
  
  def test_it_wd_006
    #user Execute diff
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    get url_for(:controller => DIFF_ADMINISTRATION, :action => "execute_diff",
      :new_pu   => 1, :old_pu   => 1,
      :new_pj   => 2, :old_pj   => 2,
      :new_task => 4, :old_task => 5,
      :tool     => Tool,:toolid => 2)
    sleep 60
    assert_equal _("Executing diff successful!"), flash[:notice]
  end
  
  def test_it_wd_007
    #user click Diff link in Recent Diff Result table
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    get url_for(:controller => DIFF_ADMINISTRATION, :action => "diff_result_summary",
      :diff_id => diff_result.id)
    assert_template "#{DIFF_ADMINISTRATION}/diff_result_summary"
  end
  
  def test_it_wd_008
    #user sort by PU
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    get url_for(:controller => DIFF_ADMINISTRATION, :action => "sort_recent_list",
      :version => "old",
      :order_field => "pu",
      :order_direction => "DESC")
    assert :success
  end
  
  def test_it_wd_09
    #user sort by PJ
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    get url_for(:controller => DIFF_ADMINISTRATION, :action => "sort_recent_list",
      :version => "old",
      :order_field => "pj",
      :order_direction => "DESC")
    assert :success
  end
  
  def test_it_wd_010
    #user sort by Task Name
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    get url_for(:controller => DIFF_ADMINISTRATION, :action => "sort_recent_list",
      :version => "old",
      :order_field => "task",
      :order_direction => "DESC")
    assert :success
  end
  
  def test_it_wd_011
    #user sort by Analysis tool
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    get url_for(:controller => DIFF_ADMINISTRATION, :action => "sort_recent_list",
      :version => "old",
      :order_field => "tool",
      :order_direction => "DESC")
    assert :success
  end
  
  def test_it_wd_012
    #user sort by Date
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    get url_for(:controller => DIFF_ADMINISTRATION, :action => "sort_recent_list",
      :version => "old",
      :order_field => "date",
      :order_direction => "DESC")
    assert :success
  end
  #DIFF RESULT SUMMARY
  #
  def test_it_wd_013
    #display of All, Each Modules, Each Files table
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    get DIFF_RESULT_SUMMARY, :diff_id => diff_result.id
    assert_template DIFF_RESULT_SUMMARY
    #all
    assert_select "tbody#all_list" do
      assert_select "tr", :count => 1
    end
    #each modules
    assert_select "tbody#module_list" do
      assert_select "tr", :count => 1
    end
    #each files
    assert_select "tbody#file_list" do
      assert_select "tr", 1
    end
  end
  
  def test_it_wd_014
    #link to Summary of Warning for Directory
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    get DIFF_RESULT_SUMMARY, :diff_id => diff_result.id
    assert_template DIFF_RESULT_SUMMARY
  end
  
  def test_it_wd_015
    #link to Summary of Warning for File
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    get DIFF_RESULT_SUMMARY, :diff_id => diff_result.id
    assert_template DIFF_RESULT_SUMMARY
  end

  #SUMMARY OF WARNING FOR DIRECTORY
  #
  def test_it_wd_016
    #link to Warning Listing with Diff
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    get SUMMARY_FOR_DIRECTORY, :diff_id => diff_result.id,
      :path    => "sample_cpp/Base/src"
    assert_template SUMMARY_FOR_DIRECTORY
    get WARNING_LISTING_WITH_DIFF, :diff_id => diff_result.id,
      :path    => "sample_cpp/Base/src",
      :diff_file_id => diff_file.id
    assert_template WARNING_LISTING_WITH_DIFF
  end
  
  def test_it_wd_017
    #Download CSV Format
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    get SUMMARY_FOR_DIRECTORY, :diff_id => diff_result.id,
      :path    => "sample_cpp/Base/src"
    assert_template SUMMARY_FOR_DIRECTORY
    post DOWNLOAD_CSV_FORMAT, :diff_id => diff_result.id,
      :path    => "sample_cpp/Base/src",
      :current => 1
		assert_response :success
  end
  
  def test_it_wd_018
    #click link of Directory in Table
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    get SUMMARY_FOR_DIRECTORY, :diff_id => diff_result.id,
      :path    => "sample_cpp/Base/src"
    assert_template SUMMARY_FOR_DIRECTORY
  end
  
  def test_it_wd_019
    #click link of Source name in Table
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    get SUMMARY_FOR_FILE, :diff_id => diff_result.id,
      :diff_file_id => diff_file.id
    assert_template SUMMARY_FOR_FILE
  end
  
  def test_it_wd_020
    #Filer with other condition = ""
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    get SUMMARY_FOR_DIRECTORY, :diff_id => diff_result.id,
      :path    => "sample_cpp/Base/src"
    assert_template SUMMARY_FOR_DIRECTORY
    #filter
    #filter
    get url_for(:controller => DIFF_ADMINISTRATION, :action => "warning_directory_summary",
      :path         => PATH,
      :page         => 1,
      :file         => false,
      :file_id      => false,
      :filter_id    => "dir",
      :status       => 1, #common
      :rule_level   => 1, #critical
      :diff_id      => diff_result.id)
    assert_response :success
  end
  
  def test_it_wd_021
    #Filer with other condition = "0*"
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    get SUMMARY_FOR_DIRECTORY, :diff_id => diff_result.id,
      :path    => "sample_cpp/Base/src"
    assert_template SUMMARY_FOR_DIRECTORY
    #filter
    get url_for(:controller => DIFF_ADMINISTRATION, :action => "warning_directory_summary",
      :path         => PATH,
      :page         => 1,
      :file         => false,
      :file_id      => false,
      :filter_id    => "dir",
      :status       => 1, #common
      :rule_level   => 1, #critical
      :others       => 2, #rule number
      :others_value => "0*",
      :diff_id      => diff_result.id)
    assert_response :success
  end
  
  def test_it_wd_022
    #Filer with source name
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    get SUMMARY_FOR_DIRECTORY, :diff_id => diff_result.id,
      :path    => "sample_cpp/Base/src"
    assert_template SUMMARY_FOR_DIRECTORY
    #filter
    #filter
    get url_for(:controller => DIFF_ADMINISTRATION, :action => "warning_directory_summary",
      :path         => PATH,
      :page         => 1,
      :file         => false,
      :file_id      => false,
      :filter_id    => "dir",
      :status       => 1, #common
      :rule_level   => 1, #critical
      :others       => 3, #rule number
      :others_value => "Pre*",
      :diff_id      => diff_result.id)
    assert_response :success
  end

  #SUMMARY OF WARNING FOR FILE
  #
  def test_it_wd_023
    #link to Warning Listing with Diff
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    get SUMMARY_FOR_FILE, :diff_id => diff_result.id,
      :diff_file_id => diff_file.id
    assert_template SUMMARY_FOR_FILE
    get WARNING_LISTING_WITH_DIFF, :diff_id => diff_result.id,
      :diff_file_id => diff_file.id
    assert_template WARNING_LISTING_WITH_DIFF
  end

  def test_it_wd_024
    #Download CSV Format
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    get SUMMARY_FOR_FILE, :diff_id => diff_result.id,
      :diff_file_id => diff_file.id
    assert_template SUMMARY_FOR_FILE
    post DOWNLOAD_CSV_FORMAT, :diff_id => diff_result.id,
      :diff_file_id => diff_file.id,
      :current => 2
		assert_response :success
  end

  def test_it_wd_025
    #click link of directory in table
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    get SUMMARY_FOR_DIRECTORY, :diff_id => diff_result.id,
      :path    => "sample_cpp/Base/src"
    assert_template SUMMARY_FOR_DIRECTORY
  end

  def test_it_wd_026
    #click link of Source name in Table
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    get SUMMARY_FOR_FILE, :diff_id => diff_result.id,
      :diff_file_id => diff_file.id
    assert_template SUMMARY_FOR_FILE
  end

  def test_it_wd_027
    #Filer with other condition = ""
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    p diff_file
    file        = OriginalFile.find_by_id(diff_file.old_original_file_id)
    get SUMMARY_FOR_FILE, :diff_id => diff_result.id,
      :diff_file_id => diff_file.id
    assert_template SUMMARY_FOR_FILE
    #filter
    get url_for(:controller => DIFF_ADMINISTRATION, :action => "warning_file_summary",
      :page         => 1,
      :file         => file.source_name,
      :file_id      => file.id,
      :filter_id    => "file",
      :status       => 1, #common
      :rule_level   => 1, #critical
      :diff_id      => diff_result.id,
      :diff_file_id => diff_file.id)
    assert_response :success
  end

  def test_it_wd_028
    #Filer with other condition = "0*"
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    file        = OriginalFile.find_by_id(diff_file.old_original_file_id)
    get SUMMARY_FOR_FILE, :diff_id => diff_result.id,
      :diff_file_id => diff_file.id
    assert_template SUMMARY_FOR_FILE
    #filter
    get url_for(:controller => DIFF_ADMINISTRATION, :action => "warning_file_summary",
      :page         => 1,
      :file         => file.source_name,
      :file_id      => file.id,
      :filter_id    => "file",
      :status       => 1, #common
      :rule_level   => 1, #critical
      :others       => 2, #rule number
      :others_value => "0*",
      :diff_id      => diff_result.id,
      :diff_file_id => diff_file.id)
    assert_response :success
  end

  #WARNING LISTING WITH DIFF
  #
  def test_it_wd_029
    #link to warning listing with diff
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    get WARNING_LISTING_WITH_DIFF, :diff_id      => diff_result.id,
      :diff_file_id => diff_file.id
    assert_response :success
    assert_template WARNING_LISTING_WITH_DIFF
    assert_select "input[type='button'][value='#{_('Download CSV Format')}']"
  end

  def test_it_wd_030
    #download CSV format
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    get WARNING_LISTING_WITH_DIFF, :diff_id      => diff_result.id,
      :diff_file_id => diff_file.id
    assert_response :success
    assert_template WARNING_LISTING_WITH_DIFF
    assert_select "input[type='button'][value='#{_('Download CSV Format')}']"
    post DOWNLOAD_CSV_FORMAT, :diff_id => diff_result.id,
      :current => 3
  end

  def test_it_wd_031
    #Filer with rule number = "0*"
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    get WARNING_LISTING_WITH_DIFF, :diff_id      => diff_result.id,
      :diff_file_id => diff_file.id
    assert_response :success
    assert_template WARNING_LISTING_WITH_DIFF
    #filter
    get url_for(:controller => DIFF_ADMINISTRATION, :action => "warning_listing_with_status",
      :page         => 1,
      :filter_id    => "list",
      :status       => 1, #common
      :rule_level   => 1, #critical
      :others       => 2, #rule number
      :others_value => "0*",
      :diff_id      => diff_result.id,
      :diff_file_id => diff_file.id)
    assert_response :success
  end

  def test_it_wd_032
    #Filer with source name = "Pre*"
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    get WARNING_LISTING_WITH_DIFF, :diff_id      => diff_result.id,
      :diff_file_id => diff_file.id
    assert_response :success
    assert_template WARNING_LISTING_WITH_DIFF
    #filter
    get url_for(:controller => DIFF_ADMINISTRATION, :action => "warning_listing_with_status",
      :page         => 1,
      :filter_id    => "list",
      :status       => 1, #common
      :rule_level   => 1, #critical
      :others       => 3, #source name
      :others_value => "Pre*",
      :diff_id      => diff_result.id,
      :diff_file_id => diff_file.id)
    assert_response :success
  end

  def test_it_wd_033
    #Filer with invalid directory
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    get WARNING_LISTING_WITH_DIFF, :diff_id      => diff_result.id,
      :diff_file_id => diff_file.id
    assert_response :success
    assert_template WARNING_LISTING_WITH_DIFF
    #filter
    get url_for(:controller => DIFF_ADMINISTRATION, :action => "warning_listing_with_status",
      :page         => 1,
      :filter_id    => "list",
      :status       => 1, #common
      :rule_level   => 1, #critical
      :others       => 4, #directory
      :others_value => "invalid",
      :diff_id      => diff_result.id,
      :diff_file_id => diff_file.id)
    assert_select "div#warning_listing_table", _("No warning found.")
  end

  def test_it_wd_034
    #click link of directory in table
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    get WARNING_LISTING_WITH_DIFF, :diff_id      => diff_result.id,
      :diff_file_id => diff_file.id
    assert_response :success
    assert_template WARNING_LISTING_WITH_DIFF

    get SUMMARY_FOR_DIRECTORY, :diff_id => diff_result.id,
      :path    => PATH
    assert_template SUMMARY_FOR_DIRECTORY
  end

  def test_it_wd_035
    #click link of source name in table
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    file        = OriginalFile.find_by_id(diff_file.old_original_file_id)
    get WARNING_LISTING_WITH_DIFF, :diff_id      => diff_result.id,
      :diff_file_id => diff_file.id
    assert_response :success
    assert_template WARNING_LISTING_WITH_DIFF

    get ANALYSIS_RESULT_REPORT, :diff_id      => diff_result.id,
      :diff_file_id => diff_file.id,
      :file_id      => file.id
    assert_template ANALYSIS_RESULT_REPORT
  end

  #ANALYSIS RESULT REPORT WITH DIFF
  #
  def test_it_wd_036
    #link to analysis_report_with_diff
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    file        = OriginalFile.find_by_id(diff_file.old_original_file_id)
    get ANALYSIS_RESULT_REPORT, :diff_id      => diff_result.id,
      :diff_file_id => diff_file.id,
      :file_id      => file.id
    assert_template ANALYSIS_RESULT_REPORT
    assert_select "input[type='submit'][value='#{_('Warning Listing')}']"
    assert_select "input[type='submit'][value='#{_('Summary')}']"
    assert_select "input[type='checkbox'][id='Common']"
    assert_select "input[type='checkbox'][id='Added']"
    assert_select "input[type='checkbox'][id='Deleted']"
  end

  def test_it_wd_037
    #click warning listing button
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    file        = OriginalFile.find_by_id(diff_file.old_original_file_id)
    get ANALYSIS_RESULT_REPORT, :diff_id      => diff_result.id,
      :diff_file_id => diff_file.id,
      :file_id      => file.id
    assert_template ANALYSIS_RESULT_REPORT

    assert_select "input[type='submit'][value='#{_('Warning Listing')}']"
    get WARNING_LISTING_WITH_DIFF, :diff_id      => diff_result.id,
      :diff_file_id => diff_file.id
    assert_response :success
    assert_template WARNING_LISTING_WITH_DIFF
  end

  def test_it_wd_038
    #click summary button
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    file        = OriginalFile.find_by_id(diff_file.old_original_file_id)
    get ANALYSIS_RESULT_REPORT, :diff_id      => diff_result.id,
      :diff_file_id => diff_file.id,
      :file_id      => file.id
    assert_template ANALYSIS_RESULT_REPORT

    assert_select "input[type='submit'][value='#{_('Summary')}']"
    get SUMMARY_FOR_FILE, :diff_id      => diff_result.id,
      :diff_file_id => diff_file.id
    assert_response :success
    assert_template SUMMARY_FOR_FILE
  end

  def test_it_wd_039
    #Filer with other condition = ""
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    get WARNING_LISTING_WITH_DIFF, :diff_id      => diff_result.id,
      :diff_file_id => diff_file.id
    assert_response :success
    assert_template WARNING_LISTING_WITH_DIFF
    #filter
    get url_for(:controller => DIFF_ADMINISTRATION, :action => "warning_listing_with_status",
      :page         => 1,
      :filter_id    => "list",
      :status       => 1, #common
      :rule_level   => 1, #critical
      :others       => 2, #rule number
      :others_value => "0*",
      :diff_id      => diff_result.id,
      :diff_file_id => diff_file.id)
    assert_response :success
  end

  def test_it_wd_040
    #Filter
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    diff_file   = DiffFile.find(:last)
    file        = OriginalFile.find_by_id(diff_file.old_original_file_id)
    get WARNING_LISTING_WITH_DIFF, :diff_id      => diff_result.id,
      :diff_file_id => diff_file.id
    assert_response :success
    assert_template WARNING_LISTING_WITH_DIFF
    #filter
    get url_for(:controller => DIFF_ADMINISTRATION,
      :action    => "filter_report",
      :filter_id => "report_with_diff",
      :diff_id   => diff_result.id,
      :file_id   => file.id)
    assert_response :success
  end

  def test_it_wd_041
    #user click Delete to delete newest diff result
    login(Admin_login, Admin_pass)
    get DIFF_ADMINISTRATION
    assert_response :success
    diff_result = DiffResult.find(:last)
    get url_for(:controller => DIFF_ADMINISTRATION, :action => "del_diff_result",
      :diff_id => diff_result.id)
    assert_equal _("Delete result successful!"), flash[:notice]
  end

  def login(user, pass)
    get "/auth/login"
    assert_response :success
    post "/auth/login", :login => user, :password => pass
    assert_redirected_to :controller => "misc", :action => "index"
    get "/misc"
    assert_response :success
  end
end
