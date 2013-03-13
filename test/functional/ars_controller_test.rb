require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../integration/setup'
require 'ars_controller'

class ArsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  ##############################################################################
  # Setup
  ##############################################################################
  # Fixtures
  fixtures :users
  fixtures :privileges
  fixtures :privileges_users
  fixtures :analyze_rule_config_details
  fixtures :analyze_rule_configs
  fixtures :analyze_rule_configs_pus
  fixtures :analyze_rule_configs_pjs
  fixtures :analyze_rule_configs_tasks
  fixtures :analyze_rule_configs_subtasks
  #
  PU = 1
  PJ = 1
  TCANA_admin = "root"
  PU_admin = "pu_admin"
  PJ_member = "pj_member"
  PJ_admin = "pj_admin"
  PARAM_ARS = { :name => "Sample name",
    :description  => "sample description"
  }
  #
  def create_arss(number)
    if number >= 1
      AnalyzeRuleConfig.delete_all()
      (1..number).each do |i|
        AnalyzeRuleConfig.create( :name => "Sample name #{i.to_s}",
          :description  => "Sample description for #{i.to_s}",
          :created_by   => 1)
      end
    end
  end
  #
  def create_a_ars(user_id)
    ars = AnalyzeRuleConfig.create(:name => "Sample ARS",
      :description  => "Sample description for ARS",
      :created_by   => user_id)
    return ars
  end
  #
  def create_arsd(ars_id)
    analyze_levels = AnalyzeLevel.levels.map do |level|
      [level, AnalyzeLevel.name(level)]
    end
    AnalyzeTool.find(:all).each do |tool|
      analyze_levels.each do |level|
        AnalyzeRuleConfigDetail.create( :rule_level=> level,
          :rule_numbers => "1,2,3",
          :analyze_tool_id  => tool.id,
          :analyze_rule_config_id => ars_id)
      end
    end
  end
  #
  def params
    params = {"rule"=>{"critical"=>"1", "normal"=>"1", "high"=>"1"}}
    return params
  end

  ##############################################################################
  # Analyze Rule Config Administration
  ##############################################################################

  # Function: index
  #
  # Input:  + User has not logged in.
  #         + Request to view ARS index page from MISC menu/ PU admin menu/ PJ admin menu
  # Expected: Redirected back to login page.
  #
  def test_it_t2_ars_ars_001
    # User has not logged in
    post :index # MISC page
    assert_equal nil,(@controller.instance_variable_get "@ars")
    assert_redirected_to :controller => "auth", :action => 'login'
    # User has not logged in
    post :index, :pu => PU # PU admin page
    assert_equal nil,(@controller.instance_variable_get "@ars")
    assert_redirected_to :controller => "auth", :action => 'login'
    # User has not logged in
    post :index, :pu => PU, :pj => PJ # PJ admin page
    assert_equal nil,(@controller.instance_variable_get "@ars")
    assert_redirected_to :controller => "auth", :action => 'login'
  end
  #
  # Input:  + TCANA admin logged in.
  #         + Request to view ARS index page from MISC menu/ PU admin menu/ PJ admin menu
  # Expected: Successful open ARS index page.
  #
  def test_it_t2_ars_ars_002
    login_as TCANA_admin
    # 
    post :index # MISC page
    assert_response :success
    assert_template "index"
    # 
    post :index, :pu => PU # PU admin page
    assert_response :success
    assert_template "index"
    # 
    post :index, :pu => PU, :pj => PJ # PJ admin page
    assert_response :success
    assert_template "index"
  end
  #
  # Input:  + PU admin logged in.
  #         + Request to view ARS index page from MISC menu/ PU admin menu/ PJ admin menu
  # Expected: + Successful open ARS index page from PU/PJ admin
  #           + Can not open ARS page from MISC menu
  #
  def test_it_t2_ars_ars_003
    login_as PU_admin
    # 
    post :index # MISC page
    assert_template ""
    assert_redirected_to :controller => "misc", :action => "index"
    #
    post :index, :pu => PU # PU admin page
    assert_response :success
    assert_template "index"
    # 
    post :index, :pu => PU, :pj => PJ # PJ admin page
    assert_response :success
    assert_template "index"
  end
  #
  # Input:  + PJ admin logged in.
  #         + Request to view ARS index page from MISC menu/ PU admin menu/ PJ admin menu
  # Expected: + Successful open ARS index page from PJ admin
  #           + Can not open ARS page from MISC menu and PU admin menu
  #
  def test_it_t2_ars_ars_004
    login_as PJ_admin
    # 
    post :index # MISC page
    assert_template ""
    assert_redirected_to :controller => "misc", :action => "index"
    # 
    post :index, :pu => PU # PU admin page
    assert_template ""
    assert_redirected_to :controller => "misc", :action => "index"
    # 
    post :index, :pu => PU, :pj => PJ # PJ admin page
    assert_response :success
    assert_template "index"
  end
  #
  # Input:  + PJ member logged in.
  #         + Request to view ARS index page from MISC menu/ PU admin menu/ PJ admin menu
  # Expected: Has no right to open those page
  #
  def test_it_t2_ars_ars_005
    login_as PJ_member
    # 
    post :index # MISC page
    assert_template ""
    assert_redirected_to :controller => "misc", :action => "index"
    #
    post :index, :pu => PU # PU admin page
    assert_template ""
    assert_redirected_to :controller => "misc", :action => "index"
    # 
    post :index, :pu => PU, :pj => PJ # PJ admin page
    assert_template ""
    assert_redirected_to :controller => "misc", :action => "index"
  end
  #
  # Input:  + TCANA admin logged in
  #         + Request to view ARS index.
  #         + Requested page is larger than the number of page.
  # Expected: Return to page 1.
  #
  def test_it_t2_ars_ars_006
    login_as TCANA_admin
    # 
    post :index, :page => 1000 # MISC page
    assert_template "index"
    assert_equal 1,(@controller.instance_variable_get "@page").to_i
  end

  # Function: create_ars
  #
  # Input:  + Admin logged in
  #         + Request to view create ARS page.
  # Expected: + Open a new subwindow of creating ARS
  #
  def test_it_t2_ars_ars_007
    login_as TCANA_admin
    #
    post :create_ars
    assert_template "edit_ars"
    ars = (@controller.instance_variable_get "@ars")
    assert_not_equal nil,ars
    assert_nil ars.id
    login_as PU_admin
    #
    post :create_ars
    assert_template "edit_ars"
    ars = (@controller.instance_variable_get "@ars")
    assert_not_equal nil,ars
    assert_nil ars.id
    login_as PJ_admin
    # 
    post :create_ars
    assert_template "edit_ars"
    ars = (@controller.instance_variable_get "@ars")
    assert_not_equal nil,ars
    assert_nil ars.id
  end

  # Function: edit_ars
  #
  # Input:  + TCANA admin logged in
  #         + Request to view edit ARS page. (from MISC, PU/PJ admin menu)
  # Expected: + Open a new subwindow of editing ARS
  #
  def test_it_t2_ars_ars_008
    login_as TCANA_admin
    ars = create_a_ars(1000)
    # 
    post :edit_ars, :id => ars.id
    assert_template "edit_ars"
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_not_equal nil,ars_collect
    assert_equal ars.id, ars_collect.id
    #
    post :edit_ars, :pu => PU, :id => ars.id
    assert_template "edit_ars"
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_not_equal nil,ars_collect
    assert_equal ars.id, ars_collect.id
    # 
    post :edit_ars, :pu => PU, :pj => PJ, :id => ars.id
    assert_template "edit_ars"
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_not_equal nil,ars_collect
    assert_equal ars.id, ars_collect.id
  end
  #
  # Input:  + PU admin logged in
  #         + Request to view edit ARS page. 
  #         + ARS is free and not created by him.
  # Expected: + Has no right to edit
  #
  def test_it_t2_ars_ars_009
    login_as PU_admin
    ars = create_a_ars(1000)
    #
    post :edit_ars, :pu => PU, :id => ars.id
    assert_template ""
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_equal nil,ars_collect    
  end
  #
  # Input:  + PJ admin logged in
  #         + Request to view edit ARS page.
  #         + ARS is free or not created by him.
  # Expected: + Has no right to edit
  #
  def test_it_t2_ars_ars_010
    ars = create_a_ars(1000)
    login_as PJ_admin
    post :edit_ars, :pu => PU, :pj => PJ, :id => ars.id
    assert_template ""
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_equal nil,ars_collect
  end
  #
  # Input:  + PU admin logged in
  #         + Request to view edit ARS page. 
  #         + ARS is created by him or being used by his PU
  # Expected: + Has right to edit
  #
  def test_it_t2_ars_ars_011
    login_as PU_admin
    user = User.find_by_account_name(PU_admin)
    ars = create_a_ars(user.id)
    post :edit_ars, :pu => PU, :id => ars.id
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_not_nil ars_collect
    assert_equal ars.id, ars_collect.id
    #
    ars.created_by = 1000
    ars.save
    AnalyzeRuleConfigsPus.create(:analyze_rule_config_id => ars.id,
      :pu_id                  => PU)
    post :edit_ars, :pu => PU, :id => ars.id
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_not_nil ars_collect
    assert_equal ars.id, ars_collect.id
  end
  #
  # Input:  + PJ admin logged in
  #         + Request to view edit ARS page.
  #         + ARS is created by him or being used by his PJ
  # Expected: + Has right to edit
  #
  def test_it_t2_ars_ars_012
    login_as PJ_admin
    user = User.find_by_account_name(PJ_admin)
    ars = create_a_ars(user.id)
    post :edit_ars, :pu => PU, :pj => PJ, :id => ars.id
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_not_nil ars_collect
    assert_equal ars.id, ars_collect.id
    #
    ars.created_by = 1000
    ars.save
    AnalyzeRuleConfigsPjs.create(:analyze_rule_config_id => ars.id,
      :pj_id => PJ )
    post :edit_ars, :pu => PU, :pj => PJ, :id => ars.id
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_not_nil ars_collect
    assert_equal ars.id, ars_collect.id
  end
  # Input:  + TCANA admin logged in
  #         + Request to edit the ARS which is not existed or ars id is nil.
  # Expected: + Error message is displayed.
  #
  def test_it_t2_ars_ars_013
    login_as TCANA_admin
    #
    post :edit_ars, :id => 1000
    assert_template ""
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_equal nil,ars_collect
    #
    post :edit_ars, :pu => PU, :id => 1000
    assert_template ""
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_equal nil,ars_collect
    #
    post :edit_ars, :pu => PU, :pj => PJ, :id => 1000
    assert_template ""
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_equal nil,ars_collect
  end
  # Function: show_ars
  #
  # Input:  + TCANA admin logged in
  #         + Request to show ars.
  # Expected: + Open a new subwindow of ARS information
  #
  def test_it_t2_ars_ars_014
    login_as TCANA_admin
    ars = create_a_ars(1000)
    #
    post :show_ars, :id => ars.id
    assert_template "show_ars"
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_not_equal nil,ars_collect
    assert_equal ars.id, ars_collect.id
    #
    post :show_ars, :pu => PU, :id => ars.id
    assert_template "show_ars"
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_not_equal nil,ars_collect
    assert_equal ars.id, ars_collect.id
    #
    post :show_ars, :pu => PU, :pj => PJ, :id => ars.id
    assert_template "show_ars"
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_not_equal nil,ars_collect
    assert_equal ars.id, ars_collect.id
  end
  # Input:  + TCANA admin logged in
  #         + Request to show the ARS which is not existed or ars id is nil.
  # Expected: + Error message is displayed.
  #
  def test_it_t2_ars_ars_015
    login_as TCANA_admin
    #
    post :show_ars, :id => 9999
    assert_template ""
    #
    post :show_ars, :pu => PU, :id => 9999
    assert_template ""
    #
    post :show_ars, :pu => PU, :pj => PJ, :id => 9999
    assert_template ""
  end
  # Test: copy_ars
  #
  # Input:  + TCANA admin logged in
  #         + Request to create a copy ARS.
  # Expected: + A copy of ARS is displayed.
  #
  def test_it_t2_ars_ars_016
    login_as TCANA_admin
    ars = create_a_ars(1000)
    #
    post :copy_ars, :id => ars.id
    assert_template "edit_ars"
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_not_equal nil,ars_collect
    assert_not_equal ars.id, ars_collect.id
    assert_equal  ars.name, ars_collect.name
    #
    post :copy_ars,:pu => PU, :id => ars.id
    assert_template "edit_ars"
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_not_equal nil,ars_collect
    assert_not_equal ars.id, ars_collect.id
    assert_equal  ars.name , ars_collect.name
    #
    post :copy_ars, :pu => PU, :pj => PJ, :id => ars.id
    assert_template "edit_ars"
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_not_equal nil,ars_collect
    assert_not_equal ars.id, ars_collect.id
    assert_equal  ars.name , ars_collect.name
  end
  #
  # Input:  + TCANA admin logged in
  #         + Request to create a copy of a nil ARS id
  # Expected: + Error message is displayed.
  #
  def test_it_t2_ars_ars_017
    login_as TCANA_admin
    #
    post :copy_ars, :id => nil
    assert_template ""
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_equal nil,ars_collect
    #
    post :copy_ars,:pu => PU, :id => nil
    assert_template ""
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_equal nil,ars_collect
    #
    post :copy_ars, :pu => PU, :pj => PJ, :id => nil
    assert_template ""
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_equal nil,ars_collect
  end
  # Input:  + TCANA admin logged in
  #         + Request to copy the ARS which is not existed or ars id is nil.
  # Expected: + Error message is displayed.
  #
  def test_it_t2_ars_ars_018
    login_as TCANA_admin
    #
    post :copy_ars, :id => 9999
    assert_template ""
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_equal nil,ars_collect
    #
    post :copy_ars, :pu => PU, :id => 9999
    assert_template ""
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_equal nil,ars_collect
    #
    post :copy_ars, :pu => PU, :pj => PJ, :id => 9999
    assert_template ""
    ars_collect = (@controller.instance_variable_get "@ars")
    assert_equal nil,ars_collect
  end
  # Test: update_ars
  #
  # Input:  + TCANA admin logged in
  #         + Request to update ARS with an invalid value.
  # Expected: + Failed to update the ARS.
  #
  def test_it_t2_ars_ars_019
    login_as TCANA_admin
    ars = create_a_ars(1)
    #
    post :update_ars,
      :id => ars.id, :ars => {:name=> "", :description => ""},
      :qac => params, :qacpp => params, :pgr => params
    assert_template ""
    assert_equal ars,AnalyzeRuleConfig.find(:last)
    #
    post :update_ars,
      :pu => PU,
      :id => ars.id, :ars => {:name=> "", :description => ""},
      :qac => params, :qacpp => params, :pgr => params
    assert_template ""
    assert_equal ars,AnalyzeRuleConfig.find(:last)
    #
    post :update_ars,
      :pu => PU, :pj => PJ, 
      :id => ars.id, :ars => {:name=> "", :description => ""},
      :qac => params, :qacpp => params, :pgr => params
    assert_template ""
    assert_equal ars,AnalyzeRuleConfig.find(:last)
  end
  #
  # Input:  + TCANA admin logged in
  #         + Request to update ARS with an valid value.
  # Expected: + ARS successful updated.
  #
  def test_it_t2_ars_ars_020
    login_as TCANA_admin
    ars = create_a_ars(1)
    #
    post :update_ars,
      :id => ars.id, :ars => PARAM_ARS,
      :qac => params, :qacpp => params, :pgr => params
    assert_template "index"
    assert_not_equal ars.updated_at,AnalyzeRuleConfig.find(:last).updated_at
    #
    post :update_ars,
      :pu => PU,
      :id => ars.id, :ars => PARAM_ARS,
      :qac => params, :qacpp => params, :pgr => params
    assert_template "index"
    assert_not_equal ars.updated_at,AnalyzeRuleConfig.find(:last).updated_at
    #
    post :update_ars,
      :pu => PU, :pj => PJ,
      :id => ars.id, :ars => PARAM_ARS,
      :qac => params, :qacpp => params, :pgr => params
    assert_template "index"
    assert_not_equal ars.updated_at,AnalyzeRuleConfig.find(:last).updated_at
  end
  # Input:  + TCANA admin logged in
  #         + Request to update the ARS which is not existed or ars id is nil.
  # Expected: + Error message is displayed.
  #
  def test_it_t2_ars_ars_021
    login_as TCANA_admin
    #
    post :update_ars,
      :pu => PU, :pj => PJ,
      :id => 9999, :ars => PARAM_ARS,
      :qac => params, :qacpp => params, :pgr => params
    assert_template ""
    #
    post :update_ars,
      :pu => PU, :pj => PJ,
      :id => 9999, :ars => PARAM_ARS,
      :qac => params, :qacpp => params, :pgr => params
    assert_template ""
    #
    post :update_ars,
      :pu => PU, :pj => PJ,
      :id => 9999, :ars => PARAM_ARS,
      :qac => params, :qacpp => params, :pgr => params
    assert_template ""
  end
  # Test: save_ars
  #
  # Input:  + TCANA admin logged in
  #         + Request to save ARS with an invalid value.
  # Expected: + Failed to create the ARS.
  #
  def test_it_t2_ars_ars_022
    login_as TCANA_admin
    old_ars = AnalyzeRuleConfig.find(:all)
    #
    post :save_ars,
      :ars => {:name=> "", :description => ""},
      :qac => params, :qacpp => params, :pgr => params
    assert_template ""
    latest_ars = AnalyzeRuleConfig.find(:all)
    assert_equal old_ars, latest_ars
    #
    post :save_ars,
      :pu => PU,
      :ars => {:name=> "", :description => ""},
      :qac => params, :qacpp => params, :pgr => params
    assert_template ""
    latest_ars = AnalyzeRuleConfig.find(:all)
    assert_equal old_ars, latest_ars
    #
    post :save_ars,
      :pu => PU, :pj => PJ,
      :ars => {:name=> "", :description => ""},
      :qac => params, :qacpp => params, :pgr => params
    assert_template ""
    latest_ars = AnalyzeRuleConfig.find(:all)
    assert_equal old_ars, latest_ars
  end
  #
  # Input:  + TCANA admin logged in
  #         + Request to update ARS with an valid value.
  # Expected: + ARS successful updated.
  #
  def test_it_t2_ars_ars_023
    login_as TCANA_admin
    old_ars = AnalyzeRuleConfig.find(:all)
    #
    post :save_ars,
      :ars => PARAM_ARS,
      :qac => params, :qacpp => params, :pgr => params
    assert_template "index"
    latest_ars = AnalyzeRuleConfig.find(:all)
    assert_not_equal old_ars, latest_ars
    assert_equal old_ars.size + 1, latest_ars.size
    #
    post :save_ars,
      :pu => PU,
      :ars => PARAM_ARS,
      :qac => params, :qacpp => params, :pgr => params
    assert_template "index"
    latest_ars = AnalyzeRuleConfig.find(:all)
    assert_not_equal old_ars, latest_ars
    assert_equal old_ars.size + 2, latest_ars.size
    #
    post :save_ars,
      :pu => PU, :pj => PJ,
      :ars => PARAM_ARS,
      :qac => params, :qacpp => params, :pgr => params
    assert_template "index"
    latest_ars = AnalyzeRuleConfig.find(:all)
    assert_not_equal old_ars, latest_ars
    assert_equal old_ars.size + 3, latest_ars.size
  end
  # Test: delete_ars
  #
  # Input:  + TCANA admin logged in
  #         + Request to delete ARS with an valid value from Misc admin menu
  # Expected: + Successful delete ARS.
  #           + ARSD which is belong to the ARS are also deleted.
  #
  def test_it_t2_ars_ars_024
    login_as TCANA_admin
    ars = create_a_ars(1)
    create_arsd(ars.id)
    assert !AnalyzeRuleConfig.find_by_id(ars.id).blank?
    assert !AnalyzeRuleConfigDetail.find_by_analyze_rule_config_id(ars.id).blank?
    #
    post :delete_ars,
      :id => ars.id
    assert_template "index"
    assert AnalyzeRuleConfig.find_by_id(ars.id).blank?
    assert AnalyzeRuleConfigDetail.find_by_analyze_rule_config_id(ars.id).blank? 
  end
  #
  # Input:  + TCANA admin logged in
  #         + Request to delete ARS with an valid value from PU admin menu
  # Expected: + Successful delete ARS.
  #           + ARSD which is belong to the ARS are also deleted.
  #
  def test_it_t2_ars_ars_025
    login_as TCANA_admin
    ars = create_a_ars(1)
    create_arsd(ars.id)
    assert !AnalyzeRuleConfig.find_by_id(ars.id).blank?
    assert !AnalyzeRuleConfigDetail.find_by_analyze_rule_config_id(ars.id).blank?
    #
    post :delete_ars,
      :pu => PU,
      :id => ars.id
    assert_template "index"
    assert AnalyzeRuleConfig.find_by_id(ars.id).blank?
    assert AnalyzeRuleConfigDetail.find_by_analyze_rule_config_id(ars.id).blank?
  end
  #
  # Input:  + TCANA admin logged in
  #         + Request to delete ARS with an valid value from PJ admin menu
  # Expected: + Successful delete ARS.
  #           + ARSD which is belong to the ARS are also deleted.
  #
  def test_it_t2_ars_ars_026
    login_as TCANA_admin
    ars = create_a_ars(1)
    create_arsd(ars.id)
    assert !AnalyzeRuleConfig.find_by_id(ars.id).blank?
    assert !AnalyzeRuleConfigDetail.find_by_analyze_rule_config_id(ars.id).blank?
    #
    post :delete_ars,
      :pu => PU, :pj => PJ,
      :id => ars.id
    assert_template "index"
    assert AnalyzeRuleConfig.find_by_id(ars.id).blank?
    assert AnalyzeRuleConfigDetail.find_by_analyze_rule_config_id(ars.id).blank?
  end
  #
  # Input:  + TCANA admin logged in
  #         + Request to delete ARS which is in the last page of ARS list
  # Expected: + Successful delete ARS.
  #           + ARSD which is belong to the ARS are also deleted.
  #           + Return back to the first page of ARS list.
  #
  def test_it_t2_ars_ars_027
    login_as TCANA_admin
    create_arss(20)
    ars = create_a_ars(1)
    create_arsd(ars.id)
    assert !AnalyzeRuleConfig.find_by_id(ars.id).blank?
    assert !AnalyzeRuleConfigDetail.find_by_analyze_rule_config_id(ars.id).blank?
    #
    post :delete_ars,
      :id => ars.id, :page => 3
    assert_template "index"
    assert AnalyzeRuleConfig.find_by_id(ars.id).blank?
    assert AnalyzeRuleConfigDetail.find_by_analyze_rule_config_id(ars.id).blank?
    assert_equal 1,(@controller.instance_variable_get "@page").to_i
  end
  #
  # Input:  + TCANA admin logged in
  #         + Try to delete the setting which is being used
  # Expected: + Unable to delete the selected setting.
  #
  def test_it_t2_ars_ars_028
    login_as TCANA_admin
    create_arss(20)
    ars = create_a_ars(1)
    create_arsd(ars.id)
    old_ars = AnalyzeRuleConfig.find(:all)
    old_arsd = AnalyzeRuleConfigDetail.find(:all)
    AnalyzeRuleConfigsPus.create(:analyze_rule_config_id => ars.id,
      :pu_id => PU)
    #
    post :delete_ars,
      :id => ars.id
    assert_template ""
    new_ars = AnalyzeRuleConfig.find(:all)
    new_arsd = AnalyzeRuleConfigDetail.find(:all)
    assert_equal old_ars, new_ars
    assert_equal old_arsd, new_arsd
  end
  #
  # Input:  + TCANA admin logged in
  #         + Request to delete the ARS which is not existed or with nil ars id
  # Expected: + Error message is displayed.
  #
  def test_it_t2_ars_ars_029
    login_as TCANA_admin
    #
    post :delete_ars,
      :id => nil
    assert_template ""
    #
    post :delete_ars,
      :id => nil, :pu => PU
    assert_template ""
    #
    post :delete_ars,
      :id => nil, :pu => PU, :pj => PJ
    assert_template ""
  end
  # Test: refer_copy_ars
  #
  # Input:  + TCANA admin logged in
  #         + Request to copy ars for a PU
  # Expected: + Old relationship of PU is cut off.
  #           + New copy of the referred setting is created.
  #           + The relationship of PU and the new setting is created.
  #
  def test_it_t2_ars_ars_030
    login_as TCANA_admin
    AnalyzeRuleConfig.delete_all()
    AnalyzeRuleConfigsPus.delete_all()
    #
    old_ars = create_a_ars(1)
    AnalyzeRuleConfigsPus.create( :analyze_rule_config_id => old_ars.id,
      :pu_id     => PU)
    refer_ars = create_a_ars(2)
    assert_equal AnalyzeRuleConfig.find(:all).size, 2
    post :refer_copy_ars,
      :pu => PU, :id => refer_ars.id
    #
    new_ars =  AnalyzeRuleConfig.find(:last)
    assert AnalyzeRuleConfigsPus.find_by_analyze_rule_config_id(old_ars.id).blank?
    assert_not_equal AnalyzeRuleConfig.find(:all).size, 2
    assert_equal new_ars.name, refer_ars.name
    assert_equal new_ars.description, refer_ars.description
    assert AnalyzeRuleConfigsPus.find_by_analyze_rule_config_id(new_ars.id)
  end
  #
  # Input:  + TCANA admin logged in
  #         + Request to copy ars for a PJ
  # Expected: + Old relationship of PJ is cut off.
  #           + New copy of the referred setting is created.
  #           + The relationship of PJ and the new setting is created.
  #
  def test_it_t2_ars_ars_031
    login_as TCANA_admin
    AnalyzeRuleConfig.delete_all()
    AnalyzeRuleConfigsPjs.delete_all()
    #
    old_ars = create_a_ars(1)
    AnalyzeRuleConfigsPjs.create( :analyze_rule_config_id => old_ars.id,
      :pj_id     => PJ)
    refer_ars = create_a_ars(2)
    assert_equal AnalyzeRuleConfig.find(:all).size, 2
    post :refer_copy_ars,
      :pu => PU, :pj => PJ, :id => refer_ars.id
    #
    new_ars =  AnalyzeRuleConfig.find(:last)
    assert AnalyzeRuleConfigsPjs.find_by_analyze_rule_config_id(old_ars.id).blank?
    assert_not_equal AnalyzeRuleConfig.find(:all).size, 2
    assert_equal new_ars.name, refer_ars.name
    assert_equal new_ars.description, refer_ars.description
    assert AnalyzeRuleConfigsPjs.find_by_analyze_rule_config_id(new_ars.id)
  end
  # Test: refer_edit_ars
  #
  # Input:  + TCANA admin logged in
  #         + Request to refer edit the ars for the PU
  # Expected: + Old relationship of PU is cut off.
  #           + The relationship of PU and the setting is created.
  #
  def notest_it_t2_ars_ars_032
    login_as TCANA_admin
    AnalyzeRuleConfig.delete_all()
    AnalyzeRuleConfigsPus.delete_all()
    #
    old_ars = create_a_ars(1)
    AnalyzeRuleConfigsPus.create( :analyze_rule_config_id => old_ars.id,
      :pu_id     => PU)
    refer_ars = create_a_ars(2)
    assert_equal AnalyzeRuleConfig.find(:all).size, 2
    post :refer_edit_ars,
      :pu => PU, :id => refer_ars.id
    #
    assert AnalyzeRuleConfigsPus.find_by_analyze_rule_config_id(old_ars.id).blank?
    assert_equal AnalyzeRuleConfig.find(:all).size, 2
    assert AnalyzeRuleConfigsPus.find_by_analyze_rule_config_id(refer_ars.id)
  end
  #
  # Input:  + TCANA admin logged in
  #         + Request to refer edit the ars for the PJ
  # Expected: + Old relationship of PJ is cut off.
  #           + The relationship of PJ and the setting is created.
  #
  def notest_it_t2_ars_ars_033
    login_as TCANA_admin
    AnalyzeRuleConfig.delete_all()
    AnalyzeRuleConfigsPjs.delete_all()
    #
    old_ars = create_a_ars(1)
    AnalyzeRuleConfigsPjs.create( :analyze_rule_config_id => old_ars.id,
      :pj_id     => PJ)
    refer_ars = create_a_ars(2)
    assert_equal AnalyzeRuleConfig.find(:all).size, 2
    post :refer_edit_ars,
      :pu => PU, :pj => PJ, :id => refer_ars.id
    #
    assert AnalyzeRuleConfigsPjs.find_by_analyze_rule_config_id(old_ars.id).blank?
    assert_equal AnalyzeRuleConfig.find(:all).size, 2
    assert AnalyzeRuleConfigsPjs.find_by_analyze_rule_config_id(refer_ars.id)
  end
  # Test: set_ars_default
  #
  # Input:  + TCANA admin logged in
  #         + Request to set_ars_default for a selected ars id
  # Expected: + successful set ars default
  #           + replace the selected html id with the last saved rule number of associated ARS detail.
  #
  def test_it_t2_ars_ars_034
    login_as TCANA_admin
    ars = create_a_ars(1)
    create_arsd(ars.id)
    post :set_ars_default,
      :pu => nil, :pj => nil, :ars_id => ars.id, :tool_id => 1, :level_id => 1
    assert_response :success
  end
  #
  # Input:  + TCANA admin logged in
  #         + Request to set_ars_default with a nil ars id
  # Expected: Replace the selected html id with a nil value.
  #
  def test_it_t2_ars_ars_035
    login_as TCANA_admin
    post :set_ars_default,
      :pu => nil, :pj => nil, :ars_id => nil, :tool_id => 1, :level_id => 1
    assert_response :success
  end
  #
  # Input:  + TCANA admin logged in
  #         + Request to set_ars_default for a selected ars id
  #         + The associated ARS detail is not existed
  # Expected: Replace the selected html id with nil value.
  #
  def test_it_t2_ars_ars_036
    login_as TCANA_admin
    ars = create_a_ars(1)
    post :set_ars_default,
      :pu => nil, :pj => nil, :ars_id => ars.id, :tool_id => 1, :level_id => 1
    assert_response :success
  end
  #
  # Input:  + TCANA admin logged in
  #         + Request to set_ars_default for the ARS which is not existed
  # Expected: Replace the selected html id with nil value.
  #
  def test_it_t2_ars_ars_037
    login_as TCANA_admin
    post :set_ars_default,
      :pu => nil, :pj => nil, :ars_id => 9999, :tool_id => 1, :level_id => 1
    assert_response :success
  end
end
