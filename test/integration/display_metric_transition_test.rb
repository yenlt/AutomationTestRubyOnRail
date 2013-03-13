require File.dirname(__FILE__) + '/../test_helper'
#require File.dirname(__FILE__) + '/setup'

class DisplayMetricTransitionTest < ActionController::IntegrationTest

  ##############################################################################
  # Setup
  ##############################################################################
  fixtures :users
  fixtures :privileges
  fixtures :privileges_users

  fixtures :pus
  fixtures :pjs

  fixtures :settings
  fixtures :display_metrics

  TOSCANA_admin_user = "root"
  TOSCANA_admin_password = "root"
  PU_admin_user = "pu_admin"
  PU_admin_password = "pu_admin"
  PU_member_user = "pj_member2"
  PU_member_password = "pj_member2"
  PJ_admin_user = "pj_admin"
  PJ_admin_password = "pj_admin"
  PJ_member_user = "pj_member"
  PJ_member_password = "pj_member"
  PJ2_admin_user = "pj_admin2"
  PJ2_admin_password = "pj_admin2"
  def setup
  end

  def teardown
  end

  ##############################################################################
  # Display Metrics Transition
  ##############################################################################
  def test_000
    import_sql
  end
  
  #
  # Test access right
  #
  def test_dtm_it_001
    get "devgroup/pu_index/1"
    assert_redirected_to :controller => "auth",:action => "login"
  end
  #
  # Test access right for display metrics
  #
  # Logged in as TOSCANA admin.
  # 3 subtasks are selected.
  # + 1 subtask of PJ 1
  # + 2 subtask of PJ 2
  #
  def test_dtm_it_002
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    subtasks = DisplayMetric.find_all_by_selected_pu_id(1)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "tbody#metric_list" do
      assert_select "tr", :count => subtasks.size
    end
  end
  # Logged in as PJ member of PJ 1
  # 1 subtasks are selected.
  #
  def test_dtm_it_003
    login_as_user(PJ_member_user,PJ_member_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "tbody#metric_list" do
      assert_select "tr", :count => 1
    end
  end
  # Logged in as non PJ member
  # 2 subtasks are selected.
  #
  def test_dtm_it_004
    login_as_user(PU_member_user,PU_member_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 2)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "div#metric_list" , _("There isn't any subtask!")
  end
  #
  # Test access right for targets setting
  #
  # Logged in as an admin.
  # 3 subtasks are selected.
  #
  def test_dtm_it_005
    # TOSCANA admin
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "input#target_setting_buton"
    # PU admin
    login_as_user(PU_admin_user,PU_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "input#target_setting_buton"
    # PJ admin
    login_as_user(PJ_admin_user,PJ_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "input#target_setting_buton"
  end
  # Logged in as a member.
  # 3 subtasks are selected.
  #
  def test_dtm_it_006
    # PJ member
    login_as_user(PJ_member_user,PJ_member_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "input#target_setting_buton", 0
    # PU member
    login_as_user(PU_member_user,PU_member_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "input#target_setting_buton", 0
  end
  #
  # Test display of display metrics
  #
  # Logged in as TOSCANA admin.
  #
  def test_dtm_it_007
    displays = DisplayMetric.find_all_by_selected_pu_id(1)
    # TOSCANA admin
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "tbody#metric_list" do
      assert_select "tr", :count => displays.count
    end
  end
  # Logged in as PU admin.
  #
  def test_dtm_it_008
    displays = DisplayMetric.find_all_by_selected_pu_id(1)
    # PU admin
    login_as_user(PU_admin_user,PU_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "tbody#metric_list" do
      assert_select "tr", :count => displays.count
    end
  end
  # Logged in as PJ admin of PJ 1
  #
  def test_dtm_it_009
    # PJ admin
    login_as_user(PJ_admin_user,PJ_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "tbody#metric_list" do
      assert_select "tr", :count => 1
    end
  end
  # Logged in as PJ admin of PJ2
  #
  def test_dtm_it_010
    # PJ2 admin
    login_as_user(PJ2_admin_user,PJ2_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 2)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "div#metric_list", _("There isn't any subtask!")
  end
  # Logged in as PJ member
  #
  def test_dtm_it_011
    # PJ member
    login_as_user(PJ_member_user,PJ_member_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "tbody#metric_list" do
      assert_select "tr", :count => 1
    end
  end
  # Logged in as PU member
  #
  def test_dtm_it_012
    # PU member
    login_as_user(PU_member_user,PU_member_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 2)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "div#metric_list", _("There isn't any subtask!")
  end
  #
  # Test display of targets setting
  #
  # Logged in as TOSCANA admin
  #
  def test_dtm_it_013
    pj_list = Pj.find_all_by_pu_id(1)
    pj_name = []
    pj_list.each do |pj|
      pj_name << pj.name
    end
    selected_subtask = DisplayMetric.find_all_by_selected_pu_id(1)
    number_subtask = selected_subtask.count
    # TOSCANA admin
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "target_setting", :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_setting"
    ## pj list
    assert_select "div#select_pj" do
      pj_name.each do |name|
        assert_select "option", name
      end
    end
    ## list of subtask
    assert_select "tbody#target_list" do
      assert_select "tr", :count => number_subtask
    end
  end
  # Logged in as PU admin
  #
  def test_dtm_it_014
    pj_list = Pj.find_all_by_pu_id(1)
    pj_name = []
    pj_list.each do |pj|
      pj_name << pj.name
    end
    selected_subtask = DisplayMetric.find_all_by_selected_pu_id(1)
    number_subtask = selected_subtask.count
        # PU admin
    login_as_user(PU_admin_user,PU_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "target_setting", :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_setting"
    ## pj list
    assert_select "div#select_pj" do
      pj_name.each do |name|
        assert_select "option", name
      end
    end
    ## list of subtask
    assert_select "tbody#target_list" do
      assert_select "tr", :count => number_subtask
    end
  end
  # Logged in as PJ admin 1
  #
  def test_dtm_it_015
    ## get list of PJ belong to PJ admin 1
    user_id = User.find_by_account_name(PJ_admin_user).id
    pj_list = PrivilegesUsers.find_all_by_user_id_and_pu_id(user_id,1)
    pj_name = []
    pj_list.each do |pj|
      pj_name << Pj.find_by_id(pj.pj_id).name
    end
    # PU admin
    login_as_user(PJ_admin_user,PJ_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "target_setting", :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_setting"
    ## pj list
    assert_select "div#select_pj" do
      pj_name.each do |name|
        assert_select "option", name
      end
    end
    ## list of subtask
    assert_select "tbody#target_list" do
      assert_select "tr", :count => pj_list.count
    end
  end
  #
  # Test Delete subtask
  #
  # 0 subtask is selected. Request to delete
  #
  def test_dtm_it_016
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    selected_subtask = DisplayMetric.find_all_by_selected_pu_id(1)
    number_subtask = selected_subtask.count
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "target_setting", :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_setting"
    get url_for(:controller => "devgroup", :action => "delete_subtask_from_targets_list", :subtasks => [""])
    assert_response :success
    assert_template "devgroup/_target_item"
    assert_select "tr", :count => number_subtask
  end
  # 1 subtask is selected. Request to delete
  #
  def test_dtm_it_017
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    selected_subtask = DisplayMetric.find_all_by_selected_pu_id(1)
    number_subtask = selected_subtask.count
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "target_setting", :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_setting"
    get url_for(:controller => "devgroup", :action => "delete_subtask_from_targets_list", :subtasks => ["id1"])
    assert_response :success
    assert_template "devgroup/_target_item"
    assert_select "tr", :count => (number_subtask-1)
  end
  # All subtask is selected. Request to delete
  #
  def test_dtm_it_018
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "target_setting", :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_setting"
    get url_for(:controller => "devgroup", :action => "delete_subtask_from_targets_list", :subtasks => ["id1","id9","id10"])
    assert_response :success
    assert_select "tr", :count => 0
  end
  #
  # Test Add subtask
  #
  # 0 subtask is selected.
  # Request 1 subtask to add.
  #
  def test_dtm_it_019
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "target_setting", :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_setting"
    ## delete subtask.
    get url_for(:controller => "devgroup", :action => "delete_subtask_from_targets_list", :subtasks => ["id1","id9","id10"])
    assert_response :success
    ## add 1 subtask.
    get url_for(:controller => "devgroup", :action => "add_subtask_to_targets_list",
      :pjs => "1", :tasks => "1", :qac => "1", :qacpp => nil , :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_item"
    assert_select "tr", :count => 1
  end
  # 0 subtask is selected.
  # Request to add  QAC and QAC++.
  #
  def test_dtm_it_020
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "target_setting", :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_setting"
    ## delete subtask.
    get url_for(:controller => "devgroup", :action => "delete_subtask_from_targets_list", :subtasks => ["id1","id9","id10"])
    assert_response :success
    ## add 1 subtask.
    get url_for(:controller => "devgroup", :action => "add_subtask_to_targets_list",
      :pjs => "1", :tasks => "1", :qac => "1", :qacpp => "1" , :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_item"
    assert_select "tr", :count => 2
  end
  # 0 subtask is selected.
  # Task selected = All . QAC is checked.
  #
  def test_dtm_it_021
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "target_setting", :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_setting"
    ## delete subtask.
    get url_for(:controller => "devgroup", :action => "delete_subtask_from_targets_list", :subtasks => ["id1","id9","id10"])
    assert_response :success
    ## add 1 subtask.
    get url_for(:controller => "devgroup", :action => "add_subtask_to_targets_list",
      :pjs => "1", :tasks => "0", :qac => "1", :qacpp => nil , :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_item"
    assert_select "tr", :count => 2
  end
  # 0 subtask is selected.
  # Task selected = All . QAC++ is checked.
  #
  def test_dtm_it_022
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "target_setting", :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_setting"
    ## delete subtask.
    get url_for(:controller => "devgroup", :action => "delete_subtask_from_targets_list", :subtasks => ["id1","id9","id10"])
    assert_response :success
    ## add 1 subtask.
    get url_for(:controller => "devgroup", :action => "add_subtask_to_targets_list",
      :pjs => "1", :tasks => "0", :qac => nil , :qacpp => "1" , :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_item"
    assert_select "tr", :count => 2
  end
  # 0 subtask is selected.
  # Task selected = All . QAC and QAC++ are checked.
  #
  def test_dtm_it_023
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "target_setting", :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_setting"
    ## delete subtask.
    get url_for(:controller => "devgroup", :action => "delete_subtask_from_targets_list", :subtasks => ["id1","id9","id10"])
    assert_response :success
    ## add 1 subtask.
    get url_for(:controller => "devgroup", :action => "add_subtask_to_targets_list",
      :pjs => "1", :tasks => "0", :qac => "1" , :qacpp => "1" , :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_item"
    assert_select "tr", :count => 4
  end
  # 0 subtask is selected.
  # 0 subtask is selected to add.
  #
  def test_dtm_it_024
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "target_setting", :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_setting"
    ## delete subtask.
    get url_for(:controller => "devgroup", :action => "delete_subtask_from_targets_list", :subtasks => ["id1","id9","id10"])
    assert_response :success
    ## add 1 subtask.
    get url_for(:controller => "devgroup", :action => "add_subtask_to_targets_list",
      :pjs => "1", :tasks => "0", :qac => nil , :qacpp => nil , :pu => 1)
    assert_response :success
    assert_select "tr", :count => 0
  end
  # 3 subtasks are selected.
  # Subtask which is selected, is selected to add.
  #
  def test_dtm_it_025
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "target_setting", :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_setting"
    ## add
    get url_for(:controller => "devgroup", :action => "add_subtask_to_targets_list",
      :pjs => "1", :tasks => "1", :qac => "1" , :qacpp => nil , :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_item"
    assert_select "tr", :count => 3
  end
  #
  # Test Save subtask
  #
  # 3 subtasks are selected.
  # 1 subtask is deleted.
  # Request to save.
  #
  def test_dtm_it_026
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "target_setting", :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_setting"
    ## delete subtask.
    get url_for(:controller => "devgroup", :action => "delete_subtask_from_targets_list", :subtasks => ["id1"])
    assert_response :success
    ## save
    get url_for(:controller => "devgroup", :action => "save_target_setting", :pu => 1)
    assert_template "devgroup/_metric_transition"
    assert_equal _("Targets setting were saved."), flash[:notice]
    @metric_list = @controller.instance_variable_get "@metric_list"
    assert_equal @metric_list.size, 2
  end
  # 3 subtasks are selected.
  # 0 subtask is deleted.
  # Request to save.
  #
  def test_dtm_it_027
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "target_setting", :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_setting"
    ## delete subtask.
    get url_for(:controller => "devgroup", :action => "delete_subtask_from_targets_list", :subtasks => [""])
    assert_response :success
    ## save
    get url_for(:controller => "devgroup", :action => "save_target_setting",:pu => 1)
    assert_template "devgroup/_metric_transition"
    assert_equal _("Targets setting were saved."), flash[:notice]
    @metric_list = @controller.instance_variable_get "@metric_list"
    assert_equal @metric_list.size, 3
  end
  # 3 subtasks are selected.
  # All subtask are deleted.
  # Request to save.
  #
  def test_dtm_it_028
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "target_setting", :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_setting"
    ## delete subtask.
    get url_for(:controller => "devgroup", :action => "delete_subtask_from_targets_list", :subtasks => ["id1","id9", "id10"])
    assert_response :success
    ## save
    get url_for(:controller => "devgroup", :action => "save_target_setting",:pu => 1)
    assert_template "devgroup/_metric_transition"
    assert_equal _("Targets setting were saved."), flash[:notice]
    @metric_list = @controller.instance_variable_get "@metric_list"
    assert_equal @metric_list, nil
  end
  # 0 subtasks are selected.
  # 1subtask is added.
  # Request to save.
  #
  def test_dtm_it_029
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "target_setting", :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_setting"
    ## delete subtask.
    get url_for(:controller => "devgroup", :action => "delete_subtask_from_targets_list", :subtasks => ["id1","id9", "id10"])
    assert_response :success
    ## add 1 subtask.
    get url_for(:controller => "devgroup", :action => "add_subtask_to_targets_list",
      :pjs => "1", :tasks => "1", :qac => "1" , :qacpp => nil , :pu => 1)
    assert_response :success
    ## save
    get url_for(:controller => "devgroup", :action => "save_target_setting",:pu => 1)
    assert_template "devgroup/_metric_transition"
    assert_equal _("Targets setting were saved."), flash[:notice]
    @metric_list = @controller.instance_variable_get "@metric_list"
    assert_equal @metric_list.size, 1
  end
  # 0 subtasks are selected.
  # All subtask are added.
  # Request to save.
  #
  def test_dtm_it_030
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "target_setting", :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_setting"
    ## delete subtask.
    get url_for(:controller => "devgroup", :action => "delete_subtask_from_targets_list", :subtasks => ["id1","id9", "id10"])
    assert_response :success
    ## add 1 subtask.
    get url_for(:controller => "devgroup", :action => "add_subtask_to_targets_list",
      :pjs => "1", :tasks => "0", :qac => "1" , :qacpp => "1" , :pu => 1)
    assert_response :success
    ## save
    get url_for(:controller => "devgroup", :action => "save_target_setting",:pu => 1)
    assert_template "devgroup/_metric_transition"
    assert_equal _("Targets setting were saved."), flash[:notice]
    @metric_list = @controller.instance_variable_get "@metric_list"
    assert_equal @metric_list.size, 4
  end
  # 3 subtasks are selected.
  # Delete some subtask, add some subtask.
  # Request to save.
  #
  def test_dtm_it_031
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "target_setting", :pu => 1)
    assert_response :success
    assert_template "devgroup/_target_setting"
    ## delete subtask.
    get url_for(:controller => "devgroup", :action => "delete_subtask_from_targets_list", :subtasks => ["id1"])
    assert_response :success
    ## add 1 subtask.
    get url_for(:controller => "devgroup", :action => "add_subtask_to_targets_list",
      :pjs => "2", :tasks => "2", :qac => "1" , :qacpp => "1" , :pu => 1)
    assert_response :success
    ## delete subtask.
    get url_for(:controller => "devgroup", :action => "delete_subtask_from_targets_list", :subtasks => ["id9"])
    assert_response :success
    ## save
    get url_for(:controller => "devgroup", :action => "save_target_setting",:pu => 1)
    assert_template "devgroup/_metric_transition"
    assert_equal _("Targets setting were saved."), flash[:notice]
  end
  #
  # Test Targets Setting Button
  #
  # Logged in as PJ member
  #
  def test_dtm_it_032
    login_as_user(PJ_member_user,PJ_member_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "input#target_setting_buton", 0
  end
  # Logged in as PU member
  #
  def test_dtm_it_033
    login_as_user(PU_member_user,PU_member_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "input#target_setting_buton", 0
  end
  # Logged in as TOSCANA admin
  #
  def test_dtm_it_034
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "input#target_setting_buton"
  end
  #
  # Test Filter
  #
  # 3 subtasks are selected.
  # Input wrong filter keyword.
  # Request to update.
  #
  def test_dtm_it_035
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    ## filter
    get url_for(:controller => "devgroup", :action => "update_metric",
                                  :filter_keyword => "wrong", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    !assert_select "tbody#metric_list"
  end
  # 3 subtasks are selected.
  # Input a right filter keyword.
  # Request to update.
  #
  def test_dtm_it_036
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    ## filter
    get url_for(:controller => "devgroup", :action => "update_metric",
                                  :filter_keyword => "sample_c/src", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "tbody#metric_list" do
      assert_select "tr", :count => 2
    end
  end
  # 3 subtasks are selected.
  # Input a "*" filter keyword.
  # Request to update.
  #
  def test_dtm_it_037
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    ## filter
    get url_for(:controller => "devgroup", :action => "update_metric",
                                  :filter_keyword => "*", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "tbody#metric_list" do
      assert_select "tr", :count => 3
    end
  end
  # 3 subtasks are selected.
  # Input a regular expression filter keyword.
  # Request to update.
  #
  def test_dtm_it_038
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    ## filter
    get url_for(:controller => "devgroup", :action => "update_metric",
                                  :filter_keyword => "sam*", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "tbody#metric_list" do
      assert_select "tr", :count => 3
    end
  end
  # 3 subtasks are selected.
  # Input a nil filter keyword.
  # Request to update.
  #
  def test_dtm_it_039
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    ## filter
    get url_for(:controller => "devgroup", :action => "update_metric",
                                  :filter_keyword => "   ", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "tbody#metric_list" do
      assert_select "tr", :count => 3
    end
  end
  # 3 subtasks are selected.
  # Input a script keyword.
  # Request to update.
  #
  def test_dtm_it_040
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    ## filter
    get url_for(:controller => "devgroup", :action => "update_metric",
                                  :filter_keyword => "alert('abc');", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    assert_select "tbody#metric_list" do
      assert_select "tr", :count => 0
    end
  end
  #
  # Test Download CSV Format.
  #
  # 2 subtasks are selected.
  #
  def test_dtm_it_041
    login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
    get 'devgroup/pu_index/1'
    assert_response :success
    get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
    assert_response :success
    assert_template "devgroup/_metric_transition"
    ## download
    get url_for(:controller => "devgroup", :action => "download_csv_metric_list",
                                  :filter_keyword => "", :pu => 1)
    assert_response :success
  end
#	#
#	# Test Display Metric Transition Graph
#	# Request Display Metric Transition Graph
	def test_dtm_it_042
		login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
		get 'devgroup/pu_index/1'
		assert_response :success
		get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
		assert_response :success
		assert_template "devgroup/_metric_transition"
		assert_select "td#add_metric_button"
		assert_select "th#redraw_button"
		assert_select "tbody#option_metric_second" do
      assert_select "tr", :count => 2
			assert_select "td:last-of-type" , "\\t\\t        Left \n\\t\\t"
#
# Test Add Metric
# + Two metric selection
# + Request Add Metric
	def test_dtm_it_043
		login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
		get 'devgroup/pu_index/1'
		assert_response :success
		get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
		assert_response :success
		assert_template "devgroup/_metric_transition"
    # request Add Metrics
		get url_for(:controller => "devgroup", :action => "add_metric", :pu => 1)
		assert_response :success
		assert_template "devgroup/_graph_item"
		assert_select "tbody#option_metric_second" do
      assert_select "tr", :count => 3
			assert_select "td:last-of-type" , "\\t\\t       \n\\t\\t\\t        Left \n\\t\\t\\t   \n\\t\\t       \n\\t\\t"
		end
	end
#
# Test Add Metric
# + More two selection
# + Request Add Metric
	def test_dtm_it_044
		login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
		get 'devgroup/pu_index/1'
		assert_response :success
		get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
		assert_response :success
		assert_template "devgroup/_metric_transition"
		# request Add Metrics
		get url_for(:controller => "devgroup", :action => "add_metric", :pu => 1)
		assert_response :success
		assert_template "devgroup/_graph_item"
		assert_select "tbody#option_metric_second" do
      assert_select "tr", :count => 3
			assert_select "td:last-of-type" , "\\t\\t       \n\\t\\t\\t        Left \n\\t\\t\\t   \n\\t\\t       \n\\t\\t"
		end

		# request Add Metrics
		get url_for(:controller => "devgroup", :action => "add_metric", :pu => 1)
		assert_response :success
		assert_template "devgroup/_graph_item"
		assert_select "tbody#option_metric_second" do
      assert_select "tr", :count => 4
			assert_select "td:last-of-type" , "\\t\\t       \n\\t\\t\\t        Left \n\\t\\t\\t   \n\\t\\t       \n\\t\\t"
		end
		# request Add Metrics
		get url_for(:controller => "devgroup", :action => "add_metric", :pu => 1)
		assert_response :success
		assert_template "devgroup/_graph_item"
		assert_select "tbody#option_metric_second" do
      assert_select "tr", :count => 5
			assert_select "td:last-of-type" , "\\t\\t       \n\\t\\t\\t        Left \n\\t\\t\\t   \n\\t\\t       \n\\t\\t"
		end
	end
#
# Test Add Metrics
# + Nine metric selection
# + Request Add Metrics
	def test_dtm_it_045
		login_as_user(TOSCANA_admin_user,TOSCANA_admin_password)
		get 'devgroup/pu_index/1'
		assert_response :success
		get url_for(:controller => "devgroup", :action => "metric_transition", :pu => 1)
		assert_response :success
		assert_template "devgroup/_metric_transition"
		# request Add Metrics
		# 3
		get url_for(:controller => "devgroup", :action => "add_metric", :pu => 1)
		assert_response :success
		# 4
		get url_for(:controller => "devgroup", :action => "add_metric", :pu => 1)
		assert_response :success
		# 5
		get url_for(:controller => "devgroup", :action => "add_metric", :pu => 1)
		assert_response :success
		# 6
		get url_for(:controller => "devgroup", :action => "add_metric", :pu => 1)
		assert_response :success
		# 7
		get url_for(:controller => "devgroup", :action => "add_metric", :pu => 1)
		assert_response :success
		# 8
		get url_for(:controller => "devgroup", :action => "add_metric", :pu => 1)
		assert_response :success
		# 9
		get url_for(:controller => "devgroup", :action => "add_metric", :pu => 1)
		assert_response :success
		#  no add more metric selection # 9
		get url_for(:controller => "devgroup", :action => "add_metric", :pu => 1)
		assert_response :success
		# 9. don't permit increase
		get url_for(:controller => "devgroup", :action => "add_metric", :pu => 1)
		assert_response :success

		assert_template "devgroup/_graph_item"
		assert_select "tbody#option_metric_second" do
      assert_select "tr", :count => 9
			assert_select "td:last-of-type" , "\\t\\t       \n\\t\\t\\t        Left \n\\t\\t\\t   \n\\t\\t       \n\\t\\t"
		end
	end

end
	end
end
