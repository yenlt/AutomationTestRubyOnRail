require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../integration/setup'
require 'devgroup_controller'

class DevgroupControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  fixtures :users
  fixtures :privileges
  fixtures :privileges_users
  fixtures :pus
  fixtures :pjs
  fixtures :settings
  fixtures :display_metrics

  TOSCANA_admin = "root"
  PU_admin = "pu_admin"
  PU_member = "pu_member"
  PJ_admin = "pj_admin"
  PJ_member = "pj_member"
  PJ_admin2 = "pj_admin2"


  ##############################################################################
  # Setup
  ##############################################################################
  ## get user id
  def get_user_id(account_name)
    user_id = User.find_by_account_name(account_name).id || 0
    return user_id
  end
  
  ##############################################################################
  # Display Metrics Transition
  ##############################################################################
  # PU member is not registered to PJ mean none PJ member.
  # TOSCANA_admin, PU_admin, PJ_admin, PJ_member have access right to PJ.
  # 3 metric subtask is selected.
  # All these subtask are extracted.
  #
  # Test metric_transition when logged in as :
  # + admin
  # + PJ member
  # + Non PJ member
  #

  # Admin
  def test_dtm_ut_c_001
    # TOSCANA_admin
    login_as TOSCANA_admin
    get :metric_transition, :pu => 1
    assert_response :success
    assert_not_equal nil,(@controller.instance_variable_get "@metric_list")
    #  PJ admin
    login_as PJ_admin
    get :metric_transition, :pu => 1
    assert_response :success
    assert_not_equal nil,(@controller.instance_variable_get "@metric_list")
    # PU admin
    login_as PU_admin
    get :metric_transition, :pu => 1
    assert_response :success
    assert_not_equal nil,(@controller.instance_variable_get "@metric_list")
  end

  # PJ member
  def test_dtm_ut_c_002
    login_as PJ_member
    get :metric_transition, :pu => 1
    assert_response :success
    assert_not_equal nil,(@controller.instance_variable_get "@metric_list")
  end

  # Non-member
  def test_dtm_ut_c_003
    login_as PJ_member
    get :metric_transition, :pu => 2
    assert_response :success
    assert_equal nil,(@controller.instance_variable_get "@metric_list")
  end

  #
  # Test metric_transition:
  # When logged in as an admin.
  # Metric list is sorted by date.
  #
  def test_dtm_ut_c_004
    login_as TOSCANA_admin
    get :metric_transition, :pu => 1
    assert_response :success
    @metric_list = @controller.instance_variable_get "@metric_list"
    unless @metric_list[1][3] < @metric_list[0][3]
      sorted = true
    end
    assert sorted, true
  end

  #
  # Test : download_csv_metric_list
  # User logged in.
  # Request to download a CSV file with a filter keyword = "*"
  #
  def test_dtm_ut_c_005
    login_as TOSCANA_admin
    get :metric_transition, :pu => 1
    assert_response :success
    post :download_csv_metric_list, :filter_keyword => "*", :pu => 1
    assert_response :success
  end

  #
  # Test : download_csv_metric_list
  # User logged in.
  # Request to download a CSV file with out a filter keyword
  #
  def test_dtm_ut_c_006
    login_as TOSCANA_admin
    get :metric_transition, :pu => 1
    assert_response :success
    post :download_csv_metric_list, :pu => 1, :filter_keyword => ""
    assert_response :success
  end

  #
  # Test : download_csv_metric_list
  # User logged in.
  # Request to download a CSV file with a wrong filter keyword
  #
  def test_dtm_ut_c_007
    login_as TOSCANA_admin
    get :metric_transition, :pu => 1
    assert_response :success
    post :download_csv_metric_list, :filter_keyword => "wrong_keyword", :pu => 1
    assert_response :success
  end

  #
  # Test : download_csv_metric_list
  # User logged in.
  # Request to download a CSV file with a filter keyword = "sample*"
  #
  def test_dtm_ut_c_008
    login_as TOSCANA_admin
    get :metric_transition, :pu => 1
    assert_response :success
    post :download_csv_metric_list, :filter_keyword => "sample*", :pu => 1
    assert_response :success
  end

  #
  # Test : download_csv_metric_list
  # User logged in.
  # Request to download a CSV file with a filter keyword contain ", ' or \
  #
  def test_dtm_ut_c_009
    login_as TOSCANA_admin
    get :metric_transition, :pu => 1
    assert_response :success
    post :download_csv_metric_list, :filter_keyword => "wr\'on\"g\\", :pu => 1
    assert_response :success
  end

  #
  # Test : download_csv_metric_list
  # User logged in.
  # Request to download a CSV file with a right filter keyword
  #
  def test_dtm_ut_c_010
    login_as TOSCANA_admin
    get :metric_transition, :pu => 1
    assert_response :success
    post :download_csv_metric_list, :filter_keyword => "sample_c/src", :pu => 1
    assert_response :success
  end

  #
  # Test : update_metric
  # User logged in.
  # Request to update with a filter keyword = "*"
  #
  def test_dtm_ut_c_011
    login_as TOSCANA_admin
    subtask_list = DisplayMetric.find_all_by_selected_pu_id(1)
    get :metric_transition, :pu => 1
    assert_response :success
    post :update_metric, :filter_keyword => "*", :pu => 1
    assert_response :success
    @metric_list = @controller.instance_variable_get "@metric_list"
    assert_equal @metric_list.size , subtask_list.size
  end

  #
  # Test : update_metric
  # User logged in.
  # Request to update with a filter keyword = ""
  #
  def test_dtm_ut_c_012
    login_as TOSCANA_admin
    subtask_list = DisplayMetric.find_all_by_selected_pu_id(1)
    get :metric_transition, :pu => 1
    assert_response :success
    post :update_metric, :pu => 1, :filter_keyword => ""
    assert_response :success
    @metric_list = @controller.instance_variable_get "@metric_list"
    assert_equal @metric_list.size , subtask_list.size
  end

  #
  # Test : update_metric
  # User logged in.
  # Request to update with a filter keyword = "wrong keyword"
  #
  def test_dtm_ut_c_013
    login_as TOSCANA_admin
    get :metric_transition, :pu => 1
    assert_response :success
    post :update_metric, :filter_keyword => "wrong_keyword", :pu => 1
    assert_response :success
    @metric_list = @controller.instance_variable_get "@metric_list"
    assert_equal @metric_list.size , 0
  end

  #
  # Test : update_metric
  # User logged in.
  # Request to update with a filter keyword = "sample*_c/src*"
  #
  def test_dtm_ut_c_014
    login_as TOSCANA_admin
    get :metric_transition, :pu => 1
    assert_response :success
    post :update_metric, :filter_keyword => "sample*", :pu => 1
    assert_response :success
    @metric_list = @controller.instance_variable_get "@metric_list"
    assert_equal @metric_list.size , 3
  end

  #
  # Test : update_metric
  # User logged in.
  # Request to update with a filter keyword = "wr\'\"\\"
  #
  def test_dtm_ut_c_015
    login_as TOSCANA_admin
    get :metric_transition, :pu => 1
    assert_response :success
    post :update_metric, :filter_keyword => "wr\'\"\\", :pu => 1
    assert_response :success
    @metric_list = @controller.instance_variable_get "@metric_list"
    assert_equal @metric_list.size , 0
  end

  #
  # Test : update_metric
  # User logged in.
  # Request to update with a filter keyword = "sample_c/src" (right keyword)
  #
  def test_dtm_ut_c_016
    login_as TOSCANA_admin
    get :metric_transition, :pu => 1
    assert_response :success
    post :update_metric, :filter_keyword => "sample_c/src", :pu => 1
    assert_response :success
    @metric_list = @controller.instance_variable_get "@metric_list"
    assert_equal @metric_list.size , 2
  end

  #
  # Test target_setting when logged in as :
  # + TOSCANA admin
  # + PU admin
  # + PJ admin
  #
  def test_dtm_ut_c_017
    # TOSCANA_admin
    login_as TOSCANA_admin
    get :target_setting, :pu => 1
    assert_response :success
    #  PJ admin
    login_as PJ_admin
    get :target_setting, :pu => 1
    assert_response :success
    # PU admin
    login_as PU_admin
    get :target_setting, :pu => 1
    assert_response :success
  end

  #
  # Test target_setting when logged in as :
  # + TOSCANA admin
  # + PU admin
  # + TOSCANA admin and PU admin have all access right to view all PJ in PU
  #
  def test_dtm_ut_c_018
    # TOSCANA_admin
    login_as TOSCANA_admin
    get :target_setting, :pu => 1
    assert_response :success
    @TOSCANA_admin_list = (@controller.instance_variable_get "@target_list")
    # PU admin
    login_as PU_admin
    get :target_setting, :pu => 1
    assert_response :success
    @PU_admin_list = (@controller.instance_variable_get "@target_list")
    # same access right
    assert_equal @TOSCANA_admin_list, @PU_admin_list
  end

  #
  # Test target_setting when logged in as :
  # + TOSCANA admin
  # + PJ admin
  # + targets list depend on PJ belong to PJ admin
  #
  def test_dtm_ut_c_019
    # TOSCANA_admin
    login_as TOSCANA_admin
    get :target_setting, :pu => 1
    assert_response :success
    @TOSCANA_admin_list = @controller.instance_variable_get "@target_list"
    # PU admin
    login_as PJ_admin2
    get :target_setting, :pu => 1
    assert_response :success
    @PJ_admin_list = @controller.instance_variable_get "@target_list"
    # same access right
    assert_not_equal @TOSCANA_admin_list, @PJ_admin_list
  end

  #
  # Test target_setting when logged in as :
  # + PU admin
  # + PJ admin
  # + targets list depend on PJ belong to PJ admin
  #
  def test_dtm_ut_c_020
    # TOSCANA_admin
    login_as PU_admin
    get :target_setting, :pu => 1
    assert_response :success
    @PU_admin_list = @controller.instance_variable_get "@target_list"
    # PU admin
    login_as PJ_admin2
    get :target_setting, :pu => 1
    assert_response :success
    @PJ_admin_list = @controller.instance_variable_get "@target_list"
    # same access right
    assert_not_equal @PU_admin_list, @PJ_admin_list
  end

  #
  # Test target_setting when logged in as :
  # + PJ admin 1
  # + PJ admin 2
  # + targets list depend on PJ belong to PJ admin
  #
  def test_dtm_ut_c_021
    # TOSCANA_admin
    login_as PJ_admin
    get :target_setting, :pu => 1
    assert_response :success
    @PJ_admin_list1 = @controller.instance_variable_get "@target_list"
    # PU admin
    login_as PJ_admin2
    get :target_setting, :pu => 1
    assert_response :success
    @PJ_admin_list2 = @controller.instance_variable_get "@target_list"
    # same access right
    assert_not_equal @PJ_admin_list1, @PJ_admin_list2
  end

  #
  # Test save_target_setting :
  # + There are 2 subtasks selected.
  # + Request save_target_setting.
  #
  def test_dtm_ut_c_022
    login_as TOSCANA_admin
    @request.session[:target_list] = [["2009/05/08", "SamplePJ1", 1, "sample_c_cpp_1_1", nil, 1, "QAC"],
      ["2009/05/08", "SamplePJ1", 1, "sample_c_cpp_1_1", nil, 2, "QAC++"]]
    post :save_target_setting, :pu => 1
    sleep 5
    get :target_setting, :pu => 1
    assert_response :success
    @target_list = @controller.instance_variable_get "@target_list"
    assert_equal @target_list.size, 2
  end

  #
  # Test save_target_setting :
  # + There are 2 subtasks selected.
  # + Delete 1 subtask.
  #
  def test_dtm_ut_c_023
    # TOSCANA_admin
    login_as TOSCANA_admin
    @request.session[:target_list] = [["2009/05/08", "SamplePJ1", 1, "sample_c_cpp_1_1", nil, 1, "QAC"]]
    @request.session[:graph]  = [[],[],[],[],[],[]]
    post :save_target_setting, :pu => 1
    sleep 5
    get :target_setting, :pu => 1
    assert_response :success
    @target_list = @controller.instance_variable_get "@target_list"
    assert_equal @target_list.size, 1
  end

  #
  # Test save_target_setting :
  # + There are 2 subtasks selected.
  # + Delete all subtasks
  #
  def test_dtm_ut_c_024
    # TOSCANA_admin
    login_as TOSCANA_admin
    @request.session[:target_list] = nil
    @request.session[:graph]  = [[],[],[],[],[],[]]
    post :save_target_setting, :pu => 1
    sleep 5
    get :target_setting, :pu => 1
    assert_response :success
    assert_equal nil, (@controller.instance_variable_get "@target_list")
  end

  #
  # Test save_target_setting :
  # + There are 2 subtask selected.
  # + Add 1 more subtask.
  #
  def test_dtm_ut_c_025
    # TOSCANA_admin
    login_as TOSCANA_admin
    @request.session[:target_list] = [["2009/05/08", "SamplePJ1", 1, "sample_c_cpp_1_1", nil, 1, "QAC"],
      ["2009/05/08", "SamplePJ1", 1, "sample_c_cpp_1_1", nil, 2, "QAC++"],
      ["2010/01/26", "SamplePJ2", 5, "sample_c_cpp_2", nil, 10, "QAC++"]]
    @request.session[:graph]  = [[],[],[],[],[],[]]
    post :save_target_setting, :pu => 1
    sleep 5
    get :target_setting, :pu => 1
    assert_response :success
    @target_list = @controller.instance_variable_get "@target_list"
    assert_equal @target_list.size, 3
  end

  #
  # Test init_metric_value :
  # + Subtask 1 registered to display_metrics table
  #  [subtask_id = 1, task_state_id = 5 , extracted = 0, STTPP= 0, selected_pu_id = 1]
  # + Extracted value change.
  # + The value of subtask will be change.
  #
  def test_dtm_ut_c_026
    # TOSCANA_admin
    login_as TOSCANA_admin
    old_subtask = DisplayMetric.find_by_subtask_id(1)
    old_subtask.extracted = 0
    old_subtask.STTPP = 0
    old_subtask.save
    get_subtask = DisplayMetric.find_by_subtask_id(1)
    @controller.init_metric_value(get_subtask)
    new_subtask = DisplayMetric.find_by_subtask_id(1)
    assert_not_equal old_subtask.STTPP, new_subtask.STTPP
    assert_not_equal old_subtask.extracted, new_subtask.extracted
  end

  #
  # Test init_metric_value :
  # + Subtask 1 registered to display_metrics table
  #  [subtask_id = 1, task_state_id = 0 , extracted = 1, STTPP= 0, selected_pu_id = 1]
  # + task_state_id  value change.
  # + The value of subtask will be change.
  #
  def test_dtm_ut_c_027
    # TOSCANA_admin
    login_as TOSCANA_admin
    old_subtask = DisplayMetric.find_by_subtask_id(1)
    old_subtask.task_state_id = 0
    old_subtask.STTPP = 0
    old_subtask.save
    get_subtask = DisplayMetric.find_by_subtask_id(1)
    @controller.init_metric_value(get_subtask)
    new_subtask = DisplayMetric.find_by_subtask_id(1)
    assert_not_equal old_subtask.STTPP, new_subtask.STTPP
    assert_not_equal old_subtask.task_state_id, new_subtask.task_state_id
  end

  #
  # Test init_metric_value :
  # + Subtask 1 registered to display_metrics table
  #  [subtask_id = 1, task_state_id = 5 , extracted = 1, STTPP= 0, selected_pu_id = 1]
  # + No value change.
  # + The value of subtask won't change.
  #
  def test_dtm_ut_c_028
    # TOSCANA_admin
    login_as TOSCANA_admin
    old_subtask = DisplayMetric.find_by_subtask_id(1)
    @controller.init_metric_value(old_subtask)
    new_subtask = DisplayMetric.find_by_subtask_id(1)
    assert_equal old_subtask, new_subtask
  end

  #
  # Test init_metric_value :
  # + Subtask 1 registered to display_metrics table
  #  [subtask_id = 1, task_state_id = 0 , extracted = 0, STTPP= 0, selected_pu_id = 1]
  # + task_state_id and extracted value change.
  # + The value of subtask will be change.
  #
  def test_dtm_ut_c_029
    # TOSCANA_admin
    login_as TOSCANA_admin
    old_subtask = DisplayMetric.find_by_subtask_id(1)
    old_subtask.extracted = 0
    old_subtask.task_state_id = 0
    old_subtask.STTPP = 0
    old_subtask.save
    get_subtask = DisplayMetric.find_by_subtask_id(1)
    @controller.init_metric_value(get_subtask)
    new_subtask = DisplayMetric.find_by_subtask_id(1)
    assert_not_equal old_subtask.STTPP, new_subtask.STTPP
    assert_not_equal old_subtask.task_state_id, new_subtask.task_state_id
    assert_not_equal old_subtask.extracted, new_subtask.extracted
  end

  #
  # Test get_subtask_list_by_user_id :
  # TOSCANA admin: user_id = 1
  # PU admin: user_id = 9
  # TOSCANA admin and PU admin get the same subtask list
  #
  def test_dtm_ut_c_030
    # TOSCANA_admin
    login_as TOSCANA_admin
    toscana_id = get_user_id(TOSCANA_admin)
    pu_admin_id = get_user_id(PU_admin)
    admin_subtask = @controller.get_subtask_list_by_user_id(toscana_id,1)
    pu_admin_subtask = @controller.get_subtask_list_by_user_id(pu_admin_id,1)
    assert_equal admin_subtask, pu_admin_subtask
  end

  #
  # Test get_subtask_list_by_user_id :
  # TOSCANA admin: user_id = 1
  # PJ admin: user_id = 11
  # TOSCANA admin and PJ admin get a difference subtask list
  #
  def test_dtm_ut_c_031
    # TOSCANA_admin
    login_as TOSCANA_admin
    toscana_id = get_user_id(TOSCANA_admin)
    pj_admin_id = get_user_id(PJ_admin2)
    admin_subtask = @controller.get_subtask_list_by_user_id(toscana_id,1)
    pj_admin_subtask = @controller.get_subtask_list_by_user_id(pj_admin_id,1)
    assert_not_equal admin_subtask, pj_admin_subtask
  end

  #
  # Test get_subtask_list_by_user_id :
  # PJ admin: user_id = 11
  # PU admin: user_id = 9
  # TOSCANA admin and PJ admin get a difference subtask list
  #
  def test_dtm_ut_c_032
    # TOSCANA_admin
    login_as PU_admin
    pu_admin_id = get_user_id(PU_admin)
    pj_admin_id = get_user_id(PJ_admin2)
    pj_admin_subtask = @controller.get_subtask_list_by_user_id(pj_admin_id,1)
    pu_admin_subtask = @controller.get_subtask_list_by_user_id(pu_admin_id,1)
    assert_not_equal pj_admin_subtask, pu_admin_subtask
  end

  #
  # Test get_subtask_list_by_user_id :
  # TOSCANA admin: user_id = 1
  # PU member: user_id = 10
  # TOSCANA admin and PJ admin get a difference subtask list
  #
  def test_dtm_ut_c_033
    # TOSCANA_admin
    login_as TOSCANA_admin
    toscana_id = get_user_id(TOSCANA_admin)
    pu_member_id = get_user_id(PJ_member)
    admin_subtask = @controller.get_subtask_list_by_user_id(toscana_id,1)
    pu_member_subtask = @controller.get_subtask_list_by_user_id(pu_member_id,1)
    assert_not_equal admin_subtask, pu_member_subtask
  end

  #
  # Test get_subtask_list_by_user_id :
  # PJ admin1: user_id = 8
  # PJ admin2: user_id = 11
  # TOSCANA admin and PU admin get the same subtask list
  #
  def test_dtm_ut_c_034
    # TOSCANA_admin
    login_as TOSCANA_admin
    pj2_admin_id = get_user_id(PJ_admin2)
    pj_admin_id = get_user_id(PJ_admin)
    pj1_admin_subtask = @controller.get_subtask_list_by_user_id(pj_admin_id,1)
    pj2_admin_subtask = @controller.get_subtask_list_by_user_id(pj2_admin_id,1)
    assert_not_equal pj1_admin_subtask, pj2_admin_subtask
  end

  #
  # Test get_target_setting_list_by_user_id :
  # TOSCANA admin: user_id = 1
  # PU admin: user_id = 9
  # TOSCANA admin and PU admin get the same target list
  #
  def test_dtm_ut_c_035
    # TOSCANA_admin
    login_as TOSCANA_admin
    toscana_id = get_user_id(TOSCANA_admin)
    pu_admin_id = get_user_id(PU_admin)
    admin_list = @controller.get_target_setting_list_by_user_id(toscana_id,1)
    pu_admin_list = @controller.get_target_setting_list_by_user_id(pu_admin_id,1)
    assert_equal admin_list, pu_admin_list
  end

  #
  # Test get_target_setting_list_by_user_id :
  # TOSCANA admin: user_id = 1
  # PJ admin: user_id = 11
  # TOSCANA admin and PJ admin get a difference target list
  #
  def test_dtm_ut_c_036
    # TOSCANA_admin
    login_as TOSCANA_admin
    toscana_id = get_user_id(TOSCANA_admin)
    pj_admin_id = get_user_id(PJ_admin2)
    admin_list = @controller.get_target_setting_list_by_user_id(toscana_id,1)
    pj_admin_list = @controller.get_target_setting_list_by_user_id(pj_admin_id,1)
    assert_not_equal admin_list, pj_admin_list
  end

  #
  # Test get_target_setting_list_by_user_id :
  # PJ admin: user_id = 11
  # PU admin: user_id = 9
  # TOSCANA admin and PJ admin get a difference target list
  #
  def test_dtm_ut_c_037
    # TOSCANA_admin
    login_as TOSCANA_admin
    pu_admin_id = get_user_id(PU_admin)
    pj_admin_id = get_user_id(PJ_admin2)
    pj_admin_list = @controller.get_target_setting_list_by_user_id(pj_admin_id,1)
    pu_admin_list = @controller.get_target_setting_list_by_user_id(pu_admin_id,1)
    assert_not_equal pj_admin_list, pu_admin_list
  end

  #
  # Test get_subtask_list_by_user_id :
  # PJ admin1: user_id = 8
  # PJ admin2: user_id = 11
  # TOSCANA admin and PU admin get the same target list
  #
  def test_dtm_ut_c_038
    # TOSCANA_admin
    login_as TOSCANA_admin
    pj_admin_id2 = get_user_id(PJ_admin2)
    pj_admin_id = get_user_id(PJ_admin)
    pj1_admin_list = @controller.get_target_setting_list_by_user_id(pj_admin_id,1)
    pj2_admin_list = @controller.get_target_setting_list_by_user_id(pj_admin_id2,1)
    assert_not_equal pj1_admin_list, pj2_admin_list
  end

  #
  # Test get_pj_list :
  # TOSCANA admin: user_id = 1
  # PU admin: user_id = 9
  # TOSCANA admin and PU admin get the same pj list
  #
  def test_dtm_ut_c_039
    # TOSCANA_admin
    login_as TOSCANA_admin
    toscana_id = get_user_id(TOSCANA_admin)
    pu_admin_id = get_user_id(PU_admin)
    admin_list = @controller.get_pj_list(toscana_id,1)
    pu_admin_list = @controller.get_pj_list(pu_admin_id,1)
    assert_equal admin_list, pu_admin_list
  end

  #
  # Test get_pj_list :
  # TOSCANA admin: user_id = 1
  # PJ admin: user_id = 11
  # TOSCANA admin and PJ admin get a difference pj list
  #
  def test_dtm_ut_c_040
    # TOSCANA_admin
    login_as TOSCANA_admin
    toscana_id = get_user_id(TOSCANA_admin)
    pj_admin_id = get_user_id(PJ_admin2)
    admin_list = @controller.get_pj_list(toscana_id,1)
    pj_admin_list = @controller.get_pj_list(pj_admin_id,1)
    assert_not_equal admin_list, pj_admin_list
  end

  #
  # Test get_pj_list :
  # PJ admin: user_id = 11
  # PU admin: user_id = 9
  # TOSCANA admin and PJ admin get a difference pj list
  #
  def test_dtm_ut_c_041
    # TOSCANA_admin
    login_as TOSCANA_admin
    pu_admin_id = get_user_id(PU_admin)
    pj_admin_id = get_user_id(PJ_admin2)
    pj_admin_list = @controller.get_pj_list(pj_admin_id,1)
    pu_admin_list = @controller.get_pj_list(pu_admin_id,1)
    assert_not_equal pj_admin_list, pu_admin_list
  end

  #
  # Test get_subtask_list_by_user_id :
  # PJ admin1: user_id = 8
  # PJ admin2: user_id = 11
  # TOSCANA admin and PU admin get the same pj list
  #
  def test_dtm_ut_c_042
    # TOSCANA_admin
    login_as TOSCANA_admin
    pj_admin_id = get_user_id(PJ_admin)
    pj_admin_id2 = get_user_id(PJ_admin2)
    pj1_admin_list = @controller.get_pj_list(pj_admin_id,1)
    pj2_admin_list = @controller.get_pj_list(pj_admin_id2,1)
    assert_not_equal pj1_admin_list, pj2_admin_list
  end

  #
  # Test update_task
  # When pjs= 1 and pjs = 2 task_list are difference.
  #
  def test_dtm_ut_c_043
    # TOSCANA_admin
    login_as TOSCANA_admin
    post :update_task, :pjs => 1
    task_list1 = @controller.instance_variable_get "@task_list"
    post :update_task, :pjs => 2
    task_list2 = @controller.instance_variable_get "@task_list"
    assert_not_equal task_list1, task_list2
  end

  #
  # Test add_subtask_to_targets_list
  # pj_id = 1
  # task_id = 1
  # qac = 1
  # qacpp = 0
  #
  def test_dtm_ut_c_044
    # TOSCANA_admin
    login_as TOSCANA_admin
    @request.session[:target_list] = nil
    post :add_subtask_to_targets_list, :pjs => 1, :tasks => 1, :qac => 1, :qacpp => 0
    assert_not_equal nil, @request.session[:target_list]
  end

  #
  # Test add_subtask_to_targets_list
  # pj_id = 1
  # task_id = 1
  # qac = 0
  # qacpp = 1
  #
  def test_dtm_ut_c_045
    # TOSCANA_admin
    login_as TOSCANA_admin
    @request.session[:target_list] = nil
    post :add_subtask_to_targets_list, :pjs => 1, :tasks => 1, :qac => 0, :qacpp => 1
    assert_not_equal nil, @request.session[:target_list]
  end

  #
  # Test add_subtask_to_targets_list
  # pj_id = 1
  # task_id = 1
  # qac = 1
  # qacpp = 1
  #
  def test_dtm_ut_c_046
    # TOSCANA_admin
    login_as TOSCANA_admin
    @request.session[:target_list] = nil
    post :add_subtask_to_targets_list, :pjs => 1, :tasks => 1, :qac => 1, :qacpp => 1
    assert_not_equal nil, @request.session[:target_list]
    assert_equal 2,@request.session[:target_list].count
  end

  #
  # Test add_subtask_to_targets_list
  # pj_id = 1
  # task_id = 1
  # qac = 0
  # qacpp = 0
  #
  def test_dtm_ut_c_047
    # TOSCANA_admin
    login_as TOSCANA_admin
    @request.session[:target_list] = nil
    post :add_subtask_to_targets_list, :pjs => 1, :tasks => 1, :qac => 0, :qacpp => 0
    assert_equal nil, @request.session[:target_list]
  end

  #
  # Test add_subtask_to_targets_list
  # pj_id = 1
  # task_id = 1
  # qac = 1
  # qacpp = 0
  # subtask is existed.
  #
  def test_dtm_ut_c_048
    # TOSCANA_admin
    login_as TOSCANA_admin
    @request.session[:target_list] = [["2009/05/08", "SamplePJ1", 1, "sample_c_cpp_1_1", nil, 1, "QAC"]]
    post :add_subtask_to_targets_list, :pjs => 1, :tasks => 1, :qac => 1, :qacpp => 0
    assert_equal 1, @request.session[:target_list].count
  end

  #
  # Test add_subtask_to_targets_list
  # pj_id = 1
  # task_id = 0
  # qac = 1
  # qacpp = 0
  #
  def test_dtm_ut_c_049
    # TOSCANA_admin
    login_as TOSCANA_admin
    @request.session[:target_list] = nil
    tasks = Task.find_all_by_pj_id(1)
    number_task = tasks.count
    post :add_subtask_to_targets_list, :pjs => 1, :tasks => 0, :qac => 1, :qacpp => 0
    assert_equal number_task, @request.session[:target_list].count
  end

  #
  # Test delete_subtask_from_targets_list
  # No subtasks selected
  #
  def test_dtm_ut_c_050
    # TOSCANA_admin
    login_as TOSCANA_admin
    @request.session[:target_list] = [["2009/05/08", "SamplePJ1", 1, "sample_c_cpp_1_1", nil, 1, "QAC"],
      ["2009/05/08", "SamplePJ1", 1, "sample_c_cpp_1_1", nil, 2, "QAC++"]]
    old_session = @request.session[:target_list].count
    post :delete_subtask_from_targets_list, :subtasks => 0
    assert_equal old_session, @request.session[:target_list].count
  end

  #
  # Test delete_subtask_from_targets_list
  # 1 subtask is selected
  #
  def test_dtm_ut_c_051
    # TOSCANA_admin
    login_as TOSCANA_admin
    @request.session[:target_list] = [["2009/05/08", "SamplePJ1", 1, "sample_c_cpp_1_1", nil, 1, "QAC"],
      ["2009/05/08", "SamplePJ1", 1, "sample_c_cpp_1_1", nil, 2, "QAC++"]]
    old_session = @request.session[:target_list].count
    post :delete_subtask_from_targets_list, :subtasks => "id1"
    assert_not_equal old_session, @request.session[:target_list].count
  end

  #
  # Test delete_subtask_from_targets_list
  # All subtask are deleted
  #
  def test_dtm_ut_c_052
    # TOSCANA_admin
    login_as TOSCANA_admin
    @request.session[:target_list] = [["2009/05/08", "SamplePJ1", 1, "sample_c_cpp_1_1", nil, 1, "QAC"],
      ["2009/05/08", "SamplePJ1", 1, "sample_c_cpp_1_1", nil, 2, "QAC++"]]
    post :delete_subtask_from_targets_list, :subtasks => ["id1","id2" ]
    assert_equal 0, @request.session[:target_list].count
  end

  #
	#	#  Test add_metric :
  #  + There are two row of metric seletion ( Metrics, Graph Type, Y Axis)
  #  + Request add_metric
  #
  def test_dtm_ut_c_053
    # TOSCANA_admin
    login_as TOSCANA_admin
    @request.session[:graph] = [['STTLN'],['Left','Right'],['Bar','Line'],['STTLN'],['Left','Right'],['Bar','Line']]
    @status_redraw = @controller.instance_variable_get "@status_redraw"
    @temp = @controller.instance_variable_get "@temp"
    post :add_metric
    assert_response :success
    @temp = @controller.instance_variable_get "@temp"
    assert_equal @temp, 3
  end

  #  Test add_metric :
  #  + There are more than two row of metric seletion ( Metrics, Graph Type, Y Axis)
  #  + Request add_metric
  #
  def test_dtm_ut_c_054
    # TOSCANA_admin
    login_as TOSCANA_admin
    @request.session[:graph] = [['STTLN'],['Left','Right'],['Bar','Line'],['STTLN'],['Left','Right'],['Bar','Line'],['STTLN'],['Left','Right'],['Bar','Line']]
    @status_redraw = @controller.instance_variable_get "@status_redraw"
    @temp = @controller.instance_variable_get "@temp"
    post :add_metric
    assert_response :success
    @temp = @controller.instance_variable_get "@temp"
    assert_equal @temp, 4

    @request.session[:graph] = [['STTLN'],['Left','Right'],['Bar','Line'],['STTLN'],['Left','Right'],['Bar','Line'],['STTLN'],['Left','Right'],['Bar','Line'],['STTLN'],['Left','Right'],['Bar','Line']]
    @temp = @controller.instance_variable_get "@temp"
    post :add_metric
    assert_response :success
    @temp = @controller.instance_variable_get "@temp"
    assert_equal @temp, 5

    @request.session[:graph] = [['STTLN'],['Left','Right'],['Bar','Line'],['STTLN'],['Left','Right'],['Bar','Line'],['STTLN'],['Left','Right'],['Bar','Line'],['STTLN'],['Left','Right'],['Bar','Line'],['STTLN'],['Left','Right'],['Bar','Line']]
    @temp = @controller.instance_variable_get "@temp"
    post :add_metric
    assert_response :success
    @temp = @controller.instance_variable_get "@temp"
    assert_equal @temp, 6
  end

  #
  #  Test add_metric :
  #  + There are nine row of metric seletion ( Metrics, Graph Type, Y Axis)
  #  + Request add_metric
  #
  def test_dtm_ut_c_055
    # TOSCANA_admin
    login_as TOSCANA_admin
    @request.session[:graph] = [['STTLN'],['Left','Right'],['Bar','Line'],
      ['STTLN'],['Left','Right'],['Bar','Line'],
      ['STTLN'],['Left','Right'],['Bar','Line'],
      ['STTLN'],['Left','Right'],['Bar','Line'],
      ['STTLN'],['Left','Right'],['Bar','Line'],
      ['STTLN'],['Left','Right'],['Bar','Line'],
      ['STTLN'],['Left','Right'],['Bar','Line'],
      ['STTLN'],['Left','Right'],['Bar','Line'],
      ['STTLN'],['Left','Right'],['Bar','Line'],
      ['STTLN'],['Left','Right'],['Bar','Line']
    ]
    @status_redraw = @controller.instance_variable_get "@status_redraw"
    @temp = @controller.instance_variable_get "@temp"
    post :add_metric
    assert_response :success
    @temp = @controller.instance_variable_get "@temp"
    assert_equal @temp, 10
  end
end
