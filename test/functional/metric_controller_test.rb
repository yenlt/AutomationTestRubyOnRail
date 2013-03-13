require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../integration/setup'
require 'metric_controller'

class MetricControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  ##############################################################################
  # Setup
  ##############################################################################
  # Fixtures
  fixtures :users
  fixtures :privileges
  fixtures :privileges_users
  fixtures :pus
  fixtures :pjs
  fixtures :pus_users
  #
  TCANA_admin = "root"
  PU_admin = "pu_admin"
  PU_member = "pu_member"
  PJ_admin = "pj_admin"
  PJ_member = "pj_member"
  PU_ID = 1
  PJ_ID = 1
  TASK_ID = 1
  METRIC_NAME = "STM33"
  METRIC_TYPE = "File"
  ANALYZE_TOOL_ID = 1
  THRESHOLD_2 = 10
  THRESHOLD_1 = 5
  THRESHOLD = {"metric_type"=>"File", "threshold1_compare_operator_id"=>"1",
    "threshold2_compare_operator_id"=>"1", "metric_name"=>"STM33", 
    "analyze_tool_id"=>"1", "threshold_1"=>"1", "threshold_2"=>"10"}
  ###
  def create_a_metric_threshold
    threshold = MetricsThreshold.create(:pj_id => PJ_ID,
      :metric_name => METRIC_NAME,
      :metric_type => METRIC_TYPE,
      :analyze_tool_id => ANALYZE_TOOL_ID,
      :threshold_2 => THRESHOLD_2,
      :threshold_1 => THRESHOLD_1,
      :threshold2_compare_operator_id => 1,
      :threshold1_compare_operator_id => 1)
    return threshold
  end
  ##############################################################################
  # Test Metric Controller in [Metric Function Improvement]                    #

  ## Test: setting_metrics_thresholds
  # Test: Not login user has no right to request function
  # Input: Actor has not login but request to call setting_metrics_thresholds
  # Output: Redirected back to login page
  #
  def test_it_t4_smt_met_001
    post :setting_metrics_thresholds
    assert_redirected_to :controller => "auth", :action => "login"
  end
  # Point to test: TCANA/PU/PJ admin of the selected PJ has right to call this function.
  # Input: User login as TCANA/PU/PJ admin of the selected PJ.
  # Output: Successful call setting_metrics_thresholds subwindow.
  #
  def test_it_t4_smt_met_002
    users = [TCANA_admin, PU_admin, PJ_admin]
    users.each do |u|
      login_as u
      post :setting_metrics_thresholds,
        :pu => PU_ID,
        :pj => PJ_ID,
        :id => TASK_ID,
        :metrics => [],
        :analyze_tools => [],
        :metric_type => [],
        :old_window => []
      assert_response :success
      assert_template :setting_metrics_thresholds
    end
  end
  # Point to test: PU/PJ admin of the others PJ has no right to call this function
  # Input: User login as PU/PJ admin of the other PJ.
  # Output: Redirect misc/index
  #
  def test_it_t4_smt_met_003
    users = [PU_admin, PJ_admin]
    users.each do |u|
      login_as u
      post :setting_metrics_thresholds,
        :pu => 3,
        :pj => 6,
        :id => 28,
        :metrics => [],
        :analyze_tools => [],
        :metric_type => [],
        :old_window => []
      !assert_response :success
    end
  end
  # Point to test: PU/PJ member has no right to call this function
  # Input: User login as PU/PJ member of the selected PJ.
  # Output: Redirect misc/index
  #
  def test_it_t4_smt_met_004
    users = [PJ_member]
    users.each do |u|
      login_as u
      post :setting_metrics_thresholds,
        :pu => PU_ID,
        :pj => PJ_ID,
        :id => TASK_ID,
        :metrics => [],
        :analyze_tools => [],
        :metric_type => [],
        :old_window => []
      assert_redirected_to :controller => "misc", :action => "index"
    end
  end
  # Point to test: Display of window when no analyze_tools/metrics selected
  # Input:+params[:analyze_tools] = []
  #       +params[:metrics] = []
  # Output: Successful display subwindow with a message of no metric selected.
  #
  def test_it_t4_smt_met_005_006
    users = [TCANA_admin]
    users.each do |u|
      login_as u
      post :setting_metrics_thresholds,
        :pu => PU_ID,
        :pj => PJ_ID,
        :id => TASK_ID,
        :metrics => [],
        :analyze_tools => [],
        :metric_type => [],
        :old_window => []
      assert_response :success
      assert_template :setting_metrics_thresholds
    end
  end
  # Point to test: Display of window when some analyze_tools and metrics are selected.
  # Input:+ metric_names = [STTPP,STCDN]
  #       + analyze_tools = [QAC, QAC++]
  # Output: Successful display subwindow with a message of no metric selected.
  #
  def test_it_t4_smt_met_007
    users = [TCANA_admin]
    users.each do |u|
      login_as u
      post :setting_metrics_thresholds,
        :pu => PU_ID,
        :pj => PJ_ID,
        :id => TASK_ID,
        :metrics => ["STTPP","STCDN"],
        :analyze_tools => ["QAC", "QAC++"],
        :metric_type => ["File"],
        :old_window => []
      assert_response :success
      assert_template :setting_metrics_thresholds
    end
  end
  ## Test: edit_threshold
  # Test: Not login user has no right to request function
  # Input: Actor has not login but request to call edit_threshold
  # Output: Redirected back to login page
  #
  def test_it_t4_smt_met_008
    post :edit_threshold
    assert_redirected_to :controller => "auth", :action => "login"
  end
  # Point to test: TCANA/PU/PJ admin of the selected PJ has right to call this function.
  # Input: User login as TCANA/PU/PJ admin of the selected PJ.
  # Output: Successful call :edit_threshold subwindow.
  #
  def test_it_t4_smt_met_009
    users = [TCANA_admin, PU_admin, PJ_admin]
    users.each do |u|
      login_as u
      post :edit_threshold,
        :pu => PU_ID,
        :pj => PJ_ID,
        :id => TASK_ID,
        :metric_description_id => 39
      assert_response :success
      assert_template :edit_threshold
    end
  end
  # Point to test: PU/PJ admin of the others PJ has no right to call this function
  # Input: User login as PU/PJ admin of the other PJ.
  # Output: Redirect misc/index
  #
  def test_it_t4_smt_met_010
    users = [PU_admin, PJ_admin]
    users.each do |u|
      login_as u
      post :edit_threshold,
        :pu => 3,
        :pj => 6,
        :id => 28,
        :metric_description_id => 39
      !assert_response :success
    end
  end
  # Point to test: PU/PJ member has no right to call this function
  # Input: User login as PU/PJ member of the selected PJ.
  # Output: Redirect misc/index
  #
  def test_it_t4_smt_met_011
    users = [PJ_member]
    users.each do |u|
      login_as u
      post :edit_threshold,
        :pu => PU_ID,
        :pj => PJ_ID,
        :id => TASK_ID,
        :metric_description_id => 39
      assert_redirected_to :controller => "misc", :action => "index"
    end
  end
  # Point to test: Edit threshold which is existed
  # Input: Request to edit the existed threshold
  # Output: Successful display "edit_threshold" window
  #
  def test_it_t4_smt_met_012
    create_a_metric_threshold
    users = [TCANA_admin, PU_admin, PJ_admin]
    users.each do |u|
      login_as u
      post :edit_threshold,
        :pu => PU_ID,
        :pj => PJ_ID,
        :id => TASK_ID,
        :metric_description_id => 39
      assert_response :success
      assert_template :edit_threshold
    end
  end
  # Point to test: Edit threshold which is not existed
  # Input: Request to edit the not existed threshold
  # Output: Successful display "edit_threshold" window
  #
  def test_it_t4_smt_met_013
    users = [TCANA_admin, PU_admin, PJ_admin]
    users.each do |u|
      login_as u
      post :edit_threshold,
        :pu => PU_ID,
        :pj => PJ_ID,
        :id => TASK_ID,
        :metric_description_id => 39
      assert_response :success
      assert_template :edit_threshold
    end
  end

  ## Test: save_threshold
  # Test: Not login user has no right to request function
  # Input: Actor has not login but request to call save_threshold
  # Output: Redirected back to login page
  #
  def test_it_t4_smt_met_014
    post :save_threshold
    assert_redirected_to :controller => "auth", :action => "login"
  end
  # Point to test: TCANA/PU/PJ admin of the selected PJ has right to call this function.
  # Input: User login as TCANA/PU/PJ admin of the selected PJ.
  # Output: Successful call metric_threshold_item subwindow.
  #
  def test_it_t4_smt_met_015
    users = [TCANA_admin, PU_admin, PJ_admin]
    users.each do |u|
      login_as u
      post :save_threshold,
        :pu => PU_ID,
        :pj => PJ_ID,
        :id => TASK_ID,
        :metric_type => "File",
        :analyze_tool_id => 1,
        :metrics => ["STM33"],
        :table_page_index => 1,
        :analyze_tools => ["QAC","QAC++"],
        :threshold => THRESHOLD
      assert_response :success
      assert_template "metric_threshold_item"
    end
  end
  # Point to test: PU/PJ admin of the others PJ has no right to call this function
  # Input: User login as PU/PJ admin of the other PJ.
  # Output: Redirect misc/index
  #
  def test_it_t4_smt_met_016
    users = [PU_admin, PJ_admin]
    users.each do |u|
      login_as u
      post :save_threshold,
        :pu => 3,
        :pj => 6,
        :id => 28,
        :metric_type => "File",
        :analyze_tool_id => 1,
        :metrics => ["STM33"],
        :table_page_index => 1,
        :analyze_tools => ["QAC","QAC++"],
        :threshold => THRESHOLD
      !assert_response :success
    end
  end
  # Point to test: PU/PJ member has no right to call this function
  # Input: User login as PU/PJ member of the selected PJ.
  # Output: Redirect misc/index
  #
  def test_it_t4_smt_met_017
    users = [PJ_member]
    users.each do |u|
      login_as u
      post :save_threshold,
        :pu => PU_ID,
        :pj => PJ_ID,
        :id => TASK_ID,
        :metric_type => "File",
        :analyze_tool_id => 1,
        :metrics => ["STM33"],
        :table_page_index => 1,
        :analyze_tools => ["QAC","QAC++"],
        :threshold => THRESHOLD
      assert_redirected_to :controller => "misc", :action => "index"
    end
  end
  # Point to test: Save threshold with blank threshold 1 and 2
  # Input: Request to save threshold with blank threshold 1 and 2
  # Output: Successful save.
  #
  def test_it_t4_smt_met_018
    threshold = {"metric_type"=>"File", "threshold1_compare_operator_id"=>"1",
      "threshold2_compare_operator_id"=>"1", "metric_name"=>"STM33",
      "analyze_tool_id"=>"1", "threshold_1"=>"", "threshold_2"=>""}
    users = [TCANA_admin, PU_admin, PJ_admin]
    users.each do |u|
      login_as u
      post :save_threshold,
        :pu => PU_ID,
        :pj => PJ_ID,
        :id => TASK_ID,
        :metric_type => "File",
        :analyze_tool_id => 1,
        :metrics => ["STM33"],
        :table_page_index => 1,
        :analyze_tools => ["QAC","QAC++"],
        :threshold => threshold
      assert_response :success
      assert_template "metric_threshold_item"
    end
  end
  # Point to test: Save threshold with wrong threshold 1 and 2
  # Input: Request to save threshold with wrong threshold 1 and 2
  # Output: Failed to save.
  #
  def test_it_t4_smt_met_019
    threshold = {"metric_type"=>"File", "threshold1_compare_operator_id"=>"1",
      "threshold2_compare_operator_id"=>"1", "metric_name"=>"STM33",
      "analyze_tool_id"=>"1", "threshold_1"=>"abc", "threshold_2"=>"def"}
    users = [TCANA_admin, PU_admin, PJ_admin]
    users.each do |u|
      login_as u
      post :save_threshold,
        :pu => PU_ID,
        :pj => PJ_ID,
        :id => TASK_ID,
        :metric_type => "File",
        :analyze_tool_id => 1,
        :metrics => ["STM33"],
        :table_page_index => 1,
        :analyze_tools => ["QAC","QAC++"],
        :threshold => threshold
      assert_response :success
      threshold_value = MetricsThreshold.find(:all,
        :conditions => {:pj_id => PJ_ID,
          :metric_name => "STM33",
          :metric_type => "File",
          :analyze_tool_id => 1})
      assert threshold_value.blank?
    end
  end
  # Point to test: Save threshold with right threshold 1 and 2
  # Input: Request to save threshold with right threshold 1 and 2
  # Output: Successful to save.
  #
  def test_it_t4_smt_met_020_021
    users = [TCANA_admin, PU_admin, PJ_admin]
    users.each do |u|
      login_as u
      post :save_threshold,
        :pu => PU_ID,
        :pj => PJ_ID,
        :id => TASK_ID,
        :metric_type => "File",
        :analyze_tool_id => 1,
        :metrics => ["STM33"],
        :table_page_index => 1,
        :analyze_tools => ["QAC","QAC++"],
        :threshold => THRESHOLD
      assert_response :success
      assert_template "metric_threshold_item"
    end
  end
  ##############################################################################

end