require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/setup'
require File.dirname(__FILE__) + '/../integration/setup'
require 'warning_controller'
require 'review_controller'

class WarningControllerTest < ActionController::TestCase

  include AuthenticatedTestHelper

  fixtures :users
  
  ## user
  REVIEWER_login  = 'root'
  PU_login        = 'pu_admin'
  PJ_login        = "pj_member"
  ## number of page
  WARNING_LISTING       = 2
  WARNING_LISTING_FILE  = 3
  COMMENT_LISTING       = 4
  COMMENT_LISTING_FILE  = 5
  ## warning list
  SAVED_WARNING     = ["3904","3905","3906","3907"]
  SELECTED_WARNING  = ["180"]
  SELECTED_WARNING_ARRAY = ["180", "181", "182", "183"]

  Admin_login = "root"
  Admin_pass  = "root"

  Pu_admin    = "pu_admin"
  Pu_admin_pass = "pu_admin"
  
  Pj_admin    = "pj_admin"
  Pj_admin_pass = "pj_admin"

  Pj_member   = "pj_member"
  Pj_member_pass = "pj_member"

  Pu_member   = "pu_member"
  Pu_member_pass = "pu_member"

  General_user = "general_user"
  General_user_pass = "general"

  WARNING_LISTING       = 2

  ##*****************************************##
  ## TEST INTEGRATION TCANA2011A PHASE 2 ##
  ##*****************************************##

  ## Test warning_controller.save_redmine_setting
  # + User not logged in.
  # + Request to save_redmine_setting
  #
  def test_it_t5_cbbt_wr_001
    issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
    action_status = {"0" => "4", "1" => "3", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
     get   :save_redmine_setting,
                  :pu         => 1,
                  :pj_redmine => 1,
                  :issue_status => issue_status,
                  :action_status => action_status,
                  :redmine_user => 1,
                  :pj         => 1,
                  :id         => 1
     assert_redirected_to :controller => "auth", :action => "login"
  end

  # + User logged in as TCANA/PU administration.
  # + Request to save_redmine_setting
  #
  def test_it_t5_cbbt_wr_002
    # test for "Save" button
    login_as REVIEWER_login
    issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
    action_status = {"0" => "4", "1" => "3", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
    get  :save_redmine_setting,
                  :pu         => 1,
                  :pj_redmine => 1,
                  :issue_status => issue_status,
                  :action_status => action_status,
                  :redmine_user => 1,
                  :pj         => 1,
                  :id         => 1
     assert_response :success
     # logout
#     logout
     login_as PU_login
     get :save_redmine_setting,
                  :pu         => 1,
                  :pj_redmine => 1,
                  :issue_status => issue_status,
                  :action_status => action_status,
                  :redmine_user => 1,
                  :pj         => 1,
                  :id         => 1
     assert_response :success
  end

   # + User logged in as PJ administration.
  # + Request to save_redmine_setting
  #
  def test_it_t5_cbbt_wr_003
    login_as REVIEWER_login
    #test for "Save" button
    issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
    action_status = {"0" => "4", "1" => "3", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
    get :save_redmine_setting,
                  :pu         => 1,
                  :pj_redmine => 1,
                  :issue_status => issue_status,
                  :action_status => action_status,
                  :redmine_user => 1,
                  :pj         => 1,
                  :id         => 1
     assert_response :success

     # test for "Save All" button
     get :save_redmine_setting,
                  :pu         => 1,
                  :pj_redmine => 1,
                  :issue_status => issue_status,
                  :action_status => action_status,
                  :redmine_user => 1,
                  :redmine_setting => "1",
                  :pj         => 1,
                  :id         => 1
     assert_response :success

     get :change_action_status
     assert_response :success
  end

  # + User logged in
  # save_redmine_setting is not successful
  # Redmine user is blank
  def test_it_t5_cbtt_wr_004
    login_as PU_login
     # for "Save" button
     issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
     action_status = {"0" => "4", "1" => "3", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
     # for "Save All" button
     get :save_redmine_setting,
                  :pu         => 1,
                  :pj_redmine => 1,
                  :issue_status => issue_status,
                  :action_status => action_status,
                  :redmine_user => "",
                  :redmine_setting => "1",
                  :pj         => 1,
                  :id         => 1
     assert_response :success
  end

  # + User logged in
  # save_redmine_setting is successful
  # there is no change in Redmine Setting
  # test for "Save All" button
  def test_it_t5_cbtt_wr_005
    login_as PU_login
    issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
    action_status = {"0" => "4", "1" => "3", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
    redmine_pj_mapping = RedminePjMapping.find_by_pj_id(1)
    RedminePjMapping.delete_all(:pj_id => redmine_pj_mapping.pj_id) if !redmine_pj_mapping.blank?
    @request.session["action_statuses"] = 0
     get :save_redmine_setting,
                  :pu         => 1,
                  :pj_redmine => "",
                  :issue_status => issue_status,
                  :action_status => action_status,
                  :redmine_user => 1,
                  :redmine_setting => "1",
                  :pj         => 1,
                  :id         => 1
     assert_response :success
  end

  # + User logged in
  # + Redmine PJ = ""
  # save_redmine_setting is not successful
  # test for "Save All" button
  def test_it_t5_cbtt_wr_006
      login_as PU_login
       # create new redmine pj mapping
       redmine_pj_mapping = RedminePjMapping.new
       redmine_pj_mapping.pj_id = 1
       redmine_pj_mapping.redmine_pj_id = 1
       redmine_pj_mapping.redmine_user_id = 1
       redmine_pj_mapping.save
      issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
      action_status = {"0" => "4", "1" => "3", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
       get :save_redmine_setting,
                    :pu         => 1,
                    :pj_redmine => "",
                    :issue_status => issue_status,
                    :action_status => action_status,
                    :redmine_user => 1,
                    :redmine_setting => "1",
                    :pj         => 1,
                    :id         => 1
       assert_response :success
  end

  # + User logged in
  # + pj_redmine = []
  # save_redmine_setting is not successful
  # test for "Save All" button
  def test_it_t5_cbtt_wr_007
      login_as PU_login
      issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
      action_status = {"0" => "4", "1" => "3", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
       # create new redmine pj mapping
       redmine_pj_mapping = RedminePjMapping.new
       redmine_pj_mapping.pj_id = 1
       redmine_pj_mapping.redmine_pj_id = 1
       redmine_pj_mapping.redmine_user_id = 1
       redmine_pj_mapping.save
       @request.session["action_statuses"] = 0
       get :save_redmine_setting,
                    :pu         => 1,
                    :pj_redmine => 1,
                    :issue_status => issue_status,
                    :action_status => action_status,
                    :redmine_user => 1,
                    :redmine_setting => "1",
                    :pj         => 1,
                    :id         => 1
       assert_response :success
  end

  # + User logged in
  # + redmine_user = ""
  # save_redmine_setting is not successful
  # test for "Save All" button
  def test_it_t5_cbtt_wr_008
      login_as PU_login
      redmine_pj_mapping = RedminePjMapping.find_by_pj_id(1)
      RedminePjMapping.delete_all(:pj_id => redmine_pj_mapping.pj_id) if !redmine_pj_mapping.blank?
      issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
      action_status = {"0" => "4", "1" => "3", "2" =>"2", "3" =>"", "4" => "2", "5" => ""}
       get :save_redmine_setting,
                    :pu         => 1,
                    :pj_redmine => "",
                    :issue_status => issue_status,
                    :action_status => action_status,
                    :redmine_user => 1,
                    :redmine_setting => '1',
                    :pj         => 1,
                    :id         => 1
       assert_response :success
  end

  # + User logged in
  # + At least "Action Status" combo box is empty
  # save_redmine_setting is not successful
  # test for "Save All" button
  def test_it_t5_cbtt_wr_009
      login_as PU_login
      issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
      action_status = {"0" => "4", "1" => "3", "2" =>"", "3" =>"", "4" => "2", "5" => "2"}
       get :save_redmine_setting,
                    :pu         => 1,
                    :pj_redmine => 1,
                    :issue_status => issue_status,
                    :action_status => action_status,
                    :redmine_user => 1,
                    :redmine_setting => "1",
                    :pj         => 1,
                    :id         => 1
       assert_response :success
  end

  # + User logged in
  # + action_status = []
  # save_redmine_setting is not successful
  # test for "Save" button
  def test_it_t5_cbtt_wr_010
      login_as PU_login
      issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
      action_status = {"0" => "4", "1" => "3", "2" =>"2", "3" =>"4", "4" => "2", "5" => "2"}
      pj_id = 1
       get :save_redmine_setting,
                    :pu         => 1,
                    :pj_redmine => 1,
                    :issue_status => issue_status,
                    :action_status => action_status,
                    :redmine_user => 1,
                    :redmine_setting => "1",
                    :pj         => 1,
                    :id         => 1
       redmine_pj_mapping = RedminePjMapping.find_by_pj_id(pj_id)
       assert_equal(redmine_pj_mapping.pj_id, pj_id )
       assert_response :success
  end

  # + User logged in
  # + Redmine PJ = ""
  # save_redmine_setting is not successful
  # test for "Save" button
  def test_it_t5_cbtt_wr_011
      login_as PU_login
      issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
      action_status = {"0" => "4", "1" => "", "2" =>"", "3" =>"1", "4" => "2", "5" => "2"}
       get :save_redmine_setting,
                    :pu         => 1,
                    :pj_redmine => "",
                    :issue_status => issue_status,
                    :action_status => action_status,
                    :redmine_user => 1,
                    :redmine_setting => "",
                    :pj         => 1,
                    :id         => 1
       assert_response :success
  end

  # + User logged in
  # + Redmine User = ""
  # save_redmine_setting is not successful
  # test for "Save" button
  def test_it_t5_cbtt_wr_012
      login_as PU_login
      issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
      action_status = {"0" => "4", "1" => "", "2" =>"", "3" =>"1", "4" => "2", "5" => "2"}
       get :save_redmine_setting,
                    :pu         => 1,
                    :pj_redmine => 1,
                    :issue_status => issue_status,
                    :action_status => action_status,
                    :redmine_user => "",
                    :redmine_setting => "",
                    :pj         => 1,
                    :id         => 1
       assert_response :success
  end

  # + User logged in
  # + At least a "Action Status" combo box is empty
  # save_redmine_setting is not successful
  # test for "Save" button
  def test_it_t5_cbtt_wr_013
      login_as PU_login
      issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
      action_status = {"0" => "4", "1" => "", "2" =>"", "3" =>"", "4" => "2", "5" => "2"}
       get :save_redmine_setting,
                    :pu         => 1,
                    :pj_redmine => 1,
                    :issue_status => issue_status,
                    :action_status => action_status,
                    :redmine_user => 1,
                    :redmine_setting => "",
                    :pj         => 1,
                    :id         => 1
       assert_response :success
  end

   # + User logged in
  # + At least a "Action Status" combo box is empty
  # save_redmine_setting is not successful
  # test for "Save" button
  def test_it_t5_cbtt_wr_013
      login_as PU_login
      issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
      action_status = {"0" => "4", "1" => "", "2" =>"", "3" =>"", "4" => "2", "5" => "2"}
       get :save_redmine_setting,
                    :pu         => 1,
                    :pj_redmine => 1,
                    :issue_status => issue_status,
                    :action_status => action_status,
                    :redmine_user => 1,
                    :redmine_setting => "",
                    :pj         => 1,
                    :id         => 1
       assert_response :success
  end

  # + User logged in
  # + There is no change in Redmine Setting
  # save_redmine_setting is successful
  # test for "Save" button
  def test_it_t5_cbtt_wr_014
      login_as PU_login
      issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
      action_status = {"0" => "4", "1" => "3", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
       # create new redmine pj mapping
       redmine_pj_mapping = RedminePjMapping.new
       redmine_pj_mapping.pj_id = 1
       redmine_pj_mapping.redmine_pj_id = 1
       redmine_pj_mapping.redmine_user_id = 1
       redmine_pj_mapping.save
       @request.session["action_statuses"] = 0
       get :save_redmine_setting,
                    :pu         => 1,
                    :pj_redmine => 1,
                    :issue_status => issue_status,
                    :action_status => action_status,
                    :redmine_user => 1,
                    :redmine_setting => "",
                    :pj         => 1,
                    :id         => 1
       assert_response :success
  end

  # + User logged in
  # + There is some change in Redmine Setting
  # save_redmine_setting is successful
  # test for "Save" button
  def test_it_t5_cbtt_wr_015
      login_as PU_login
      issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
      action_status = {"0" => "4", "1" => "3", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
      pj_id = 2
       # create new redmine pj mapping
       redmine_pj_mapping = RedminePjMapping.new
       redmine_pj_mapping.pj_id = 1
       redmine_pj_mapping.redmine_pj_id = 1
       redmine_pj_mapping.redmine_user_id = 1
       redmine_pj_mapping.save
       @request.session["action_statuses"] = 0
       get :save_redmine_setting,
                    :pu         => 1,
                    :pj_redmine => 2,
                    :issue_status => issue_status,
                    :action_status => action_status,
                    :redmine_user => 1,
                    :redmine_setting => "",
                    :pj         => 2,
                    :id         => 1
       redmine_pj_mapping = RedminePjMapping.find_by_pj_id(pj_id)
       assert_equal(redmine_pj_mapping.pj_id, pj_id )
       assert_response :success
  end

  # Test for warning_controller.remove_redmine_setting
  # + User not logged in
  # + Request to remove_redmine_setting
  def test_it_t5_cbbt_wr_016
     get :remove_redmine_setting,
                  :pj         => 1,
                  :id         => 1
     assert_redirected_to :controller => "auth", :action => "login"
  end

  # + User logged in as TCANA/PU administration
  # + Request to remove_redmine_setting
  # + Response is successful
  def test_it_t5_cbbt_wr_017
     login_as REVIEWER_login
     get :remove_redmine_setting,
                  :pj         => 1,
                  :id         => 1
     assert_response :success
  end

  # + User logged in as general user
  # + Request to remove_redmine_setting
  def test_it_t5_cbbt_wr_018
     login_as REVIEWER_login
     get :remove_redmine_setting,
                  :pj         => 1,
                  :id         => 1
     assert_response :success
  end

  # + User logged in
  # + Request to remove_redmine_setting
  # + Response is successful
  # + Redmine Setting is removed
  def test_it_t5_cbbt_wr_019
     login_as REVIEWER_login
     get :remove_redmine_setting,
                  :pj         => 1,
                  :id         => 1
     redmine_setting = RedminePjMapping.find_by_pj_id(1)
     assert_equal(nil, redmine_setting)
     assert_response :success
  end

  # + User logged in
  # + Request to remove_redmine_setting
  # + Response is successful
  # + all Warning-Issue are removed
  def test_it_t5_cbbt_wr_020
     login_as REVIEWER_login
     get :remove_redmine_setting,
                  :pj         => 1,
                  :id         => 1
     warning_issue = WarningIssue.find(:all)
     assert_equal([], warning_issue)
     assert_response :success
  end

  # + User logged in
  # + Request to remove_redmine_setting
  # + Response is successful
  # + New custom fields for Pj are not removed
  def test_it_t5_cbbt_wr_021
     login_as REVIEWER_login
     issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
      action_status = {"0" => "4", "1" => "3", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
     get :save_redmine_setting,
                    :pu         => 1,
                    :pj_redmine => 1,
                    :issue_status => issue_status,
                    :action_status => action_status,
                    :redmine_user => 1,
                    :redmine_setting => "",
                    :pj         => 1,
                    :id         => 1
     get :remove_redmine_setting,
                  :pj         => 1,
                  :id         => 1
     custom_fields = RedmineCustomField.find(:all)
     assert_not_equal(nil, custom_fields)
     assert_response :success
  end

  # Test for warning_controller.create_issue
  # + User not logged in
  # + Request to create_issue
  def test_it_t5_cbbt_wr_022
     get :create_issues,
                  :pj         => 1,
                  :id         => 1
     assert_redirected_to :controller => "auth", :action => "login"
  end

  # + User logged in as TCANA/PU administration
  # + Request to create_issue
  # + Response is successful
  def test_it_t5_cbbt_wr_023
    login_as REVIEWER_login
    issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
    action_status = {"0" => "4", "1" => "5", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
    # create result id
    SELECTED_WARNING.each do |warning|
        warning_result = WarningsResult.new
        warning_result.warning_id = warning
        warning_result.result_id = 123
        warning_result.rule_level = Warning.find(warning).rule_level
        warning_result.save
    end
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    # call save redmine setting
     get :save_redmine_setting,
                  :pu         => 1,
                  :pj_redmine => 1,
                  :issue_status => issue_status,
                  :action_status => action_status,
                  :redmine_user => 1,
                  :pj         => 1,
                  :id         => 1
   assert_response :success
     get  :create_issues,
          :p1   => WARNING_LISTING,
          :id => 5
     assert_response :success
  end

  # + User logged in as Pj member
  # + Request to create_issue
  def test_it_t5_cbbt_wr_024
    login_as REVIEWER_login
    issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
    action_status = {"0" => "4", "1" => "5", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    SELECTED_WARNING_ARRAY.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
     # create result id
    SELECTED_WARNING_ARRAY.each do |warning|
        warning_result = WarningsResult.new
        warning_result.warning_id = warning
        warning_result.result_id = 123
        warning_result.rule_level = Warning.find(warning).rule_level
        warning_result.save
    end
    # call save redmine setting
     get :save_redmine_setting,
                  :pu         => 1,
                  :pj_redmine => 1,
                  :issue_status => issue_status,
                  :action_status => action_status,
                  :redmine_user => 1,
                  :pj         => 1,
                  :id         => 1
   assert_response :success
     get  :create_issues,
          :p1   => WARNING_LISTING,
          :id => 5
     assert_response :success
  end

  # + User logged in
  # + Request to create_issue
  # inputted warning = 145
  def test_it_t5_cbbt_wr_025
    login_as REVIEWER_login
    issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
    action_status = {"0" => "4", "1" => "5", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    SELECTED_WARNING_ARRAY.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
     # create result id
    SELECTED_WARNING_ARRAY.each do |warning|
        warning_result = WarningsResult.new
        warning_result.warning_id = warning
        warning_result.result_id = 123
        warning_result.rule_level = Warning.find(warning).rule_level
        warning_result.save
    end
    # call save redmine setting
     get :save_redmine_setting,
                  :pu         => 1,
                  :pj_redmine => 1,
                  :issue_status => issue_status,
                  :action_status => action_status,
                  :redmine_user => 1,
                  :pj         => 1,
                  :id         => 1
   assert_response :success
     get  :create_issues,
          :p1   => WARNING_LISTING,
          :id => 5
     assert_response :success
     
    SELECTED_WARNING.each do |warning_id|
          warning_issue = WarningIssue.find_by_warning_id(warning_id)
          redmine_issue = RedmineIssue.find(warning_issue.redmine_issue_id)
          assert_not_equal(redmine_issue, nil)
     end
  end

  # + User logged in 
  # + Request to create_issue
  # inputted warning = array
  def test_it_t5_cbbt_wr_026
    login_as REVIEWER_login
    issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
    action_status = {"0" => "4", "1" => "5", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
     # create result id
    SELECTED_WARNING.each do |warning|
        warning_result = WarningsResult.new
        warning_result.warning_id = warning
        warning_result.result_id = 123
        warning_result.rule_level = Warning.find(warning).rule_level
        warning_result.save
    end
    # call save redmine setting
     get :save_redmine_setting,
                  :pu         => 1,
                  :pj_redmine => 1,
                  :issue_status => issue_status,
                  :action_status => action_status,
                  :redmine_user => 1,
                  :pj         => 1,
                  :id         => 1
   assert_response :success
     get  :create_issues,
          :p1   => WARNING_LISTING,
          :id => 5
     assert_response :success
     SELECTED_WARNING.each do |warning_id|
          warning_issue = WarningIssue.find_by_warning_id(warning_id)
          redmine_issue = RedmineIssue.find(warning_issue.redmine_issue_id)
          assert_not_equal(redmine_issue, nil)
     end
  end

   # + User logged in as Pj member
  # + Request to create_issue
  # + Inputted Warning is integer
  # + Warning/Comment listing for file
  def test_it_t5_cbbt_wr_027
    login_as REVIEWER_login
    issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
    action_status = {"0" => "4", "1" => "5", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
    # initialize @subtask
    @request.session["subtask"] = Subtask.find_by_id(1)
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
    SELECTED_WARNING_ARRAY.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    # create result id
    SELECTED_WARNING_ARRAY.each do |warning|
        warning_result = WarningsResult.new
        warning_result.warning_id = warning
        warning_result.result_id = 123
        warning_result.rule_level = Warning.find(warning).rule_level
        warning_result.save
    end
    # call save redmine setting
     get :save_redmine_setting,
                  :pu         => 1,
                  :pj_redmine => 1,
                  :issue_status => issue_status,
                  :action_status => action_status,
                  :redmine_user => 1,
                  :pj         => 1,
                  :id         => 1
   assert_response :success
     get  :create_issues,
          :p1   => WARNING_LISTING_FILE,
          :id => 5
     assert_response :success
     SELECTED_WARNING_ARRAY.each do |warning_id|
          warning_issue = WarningIssue.find_by_warning_id(warning_id)
          redmine_issue = RedmineIssue.find(warning_issue.redmine_issue_id)
          assert_not_equal(redmine_issue, nil)
     end
  end

  # + User logged in as Pj member
  # + Request to create_issue
  # + Inputted Warning is array
  # + Warning/Comment listing for file
  def test_it_t5_cbbt_wr_028
    login_as REVIEWER_login
    issue_status = {"0" => "1", "1" => "2", "2" =>"3", "3" =>"4", "4" => "5", "5" => "6"}
    action_status = {"0" => "4", "1" => "5", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
    # initialize @subtask
    @request.session["subtask"] = Subtask.find_by_id(1)
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
    SELECTED_WARNING_ARRAY.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    # create result id
    SELECTED_WARNING_ARRAY.each do |warning|
        warning_result = WarningsResult.new
        warning_result.warning_id = warning
        warning_result.result_id = 123
        warning_result.rule_level = Warning.find(warning).rule_level
        warning_result.save
    end
    # call save redmine setting
     get :save_redmine_setting,
                  :pu         => 1,
                  :pj_redmine => 1,
                  :issue_status => issue_status,
                  :action_status => action_status,
                  :redmine_user => 1,
                  :pj         => 1,
                  :id         => 1
   assert_response :success
     get  :create_issues,
          :p1   => WARNING_LISTING_FILE,
          :id => 5
     assert_response :success

    SELECTED_WARNING_ARRAY.each do |warning_id|
          warning_issue = WarningIssue.find_by_warning_id(warning_id)
          redmine_issue = RedmineIssue.find(warning_issue.redmine_issue_id)
          assert_not_equal(redmine_issue, nil)
     end
  end

  # Test for warning_controller.synchronize_issues
  # + User not logged in
  # + Request to synchronize_issue
  def test_it_t5_cbbt_wr_029
     get :synchronize_issues,
                  :pj         => 1,
                  :id         => 1
     assert_redirected_to :controller => "auth", :action => "login"
  end

  # + User logged in
  # + Request to synchronize_issue
  def test_it_t5_cbbt_wr_030
    login_as REVIEWER_login
    issue_status = {0 => "1", 1 => "2", 2 =>"3", 3 =>"4", 4 => "5", 5 => "6"}
    action_status = {"0" => "4", "1" => "5", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
     ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    SELECTED_WARNING_ARRAY.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    # create result id
    SELECTED_WARNING_ARRAY.each do |warning|
        warning_result = WarningsResult.new
        warning_result.warning_id = warning
        warning_result.result_id = 123
        warning_result.rule_level = Warning.find(warning).rule_level
        warning_result.save
    end
    # call save redmine setting
     get :save_redmine_setting,
                  :pu         => 1,
                  :pj_redmine => 1,
                  :issue_status => issue_status,
                  :action_status => action_status,
                  :redmine_user => 1,
                  :pj         => 1,
                  :id         => 1
     # call synchronize_issues
     get :synchronize_issues,
                  :pj         => 1,
                  :id         => 1,
                  :p1 => WARNING_LISTING
     assert_response :success
  end

  # + User logged in as PJ member
  # + Request to synchronize_issue
  def test_it_t5_cbbt_wr_031
    login_as REVIEWER_login
    issue_status = {0 => "1", 1 => "2", 2 =>"3", 3 =>"4", 4 => "5", 5 => "6"}
    action_status = {"0" => "4", "1" => "5", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
     ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    SELECTED_WARNING_ARRAY.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    # create result id
    SELECTED_WARNING_ARRAY.each do |warning|
        warning_result = WarningsResult.new
        warning_result.warning_id = warning
        warning_result.result_id = 123
        warning_result.rule_level = Warning.find(warning).rule_level
        warning_result.save
    end
    # call save redmine setting
     get :save_redmine_setting,
                  :pu         => 1,
                  :pj_redmine => 1,
                  :issue_status => issue_status,
                  :action_status => action_status,
                  :redmine_user => 1,
                  :pj         => 1,
                  :id         => 1
     # call synchronize_issues
     get :synchronize_issues,
                  :pj         => 1,
                  :id         => 1,
                  :p1 => WARNING_LISTING
     assert_response :success
  end

  # + User logged in
  # + Request to synchronize_issue
  # + Warning/Comment listing page
  def test_it_t5_cbbt_wr_032
    login_as REVIEWER_login
    issue_status = {0 => "1", 1 => "2", 2 =>"3", 3 =>"4", 4 => "5", 5 => "6"}
    action_status = {"0" => "4", "1" => "5", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
    # initialize @subtask
    @request.session["subtask"] = Subtask.find_by_id(1)
     ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    # create result id
    SELECTED_WARNING.each do |warning|
        warning_result = WarningsResult.new
        warning_result.warning_id = warning
        warning_result.result_id = 123
        warning_result.rule_level = Warning.find(warning).rule_level
        warning_result.save
    end

    # call save redmine setting
     get :save_redmine_setting,
                  :pu         => 1,
                  :pj_redmine => 1,
                  :issue_status => issue_status,
                  :action_status => action_status,
                  :redmine_user => 1,
                  :pj         => 1,
                  :id         => 1
     # call synchronize_issues
     get :synchronize_issues,
                  :pj         => 1,
                  :id         => 1,
                  :p1 => WARNING_LISTING
     assert_response :success

    SELECTED_WARNING.each do |warning_id|
          warning_issue = WarningIssue.find_by_warning_id(warning_id)
          redmine_issue = RedmineIssue.find(warning_issue.redmine_issue_id)
          assert_equal(redmine_issue.status_id, 1)
     end
  end

  # + User logged in
  # + Request to synchronize_issue
  # + Warning/Comment listing page
  def test_it_t5_cbbt_wr_033
    login_as REVIEWER_login
    issue_status = {0 => "1", 1 => "2", 2 =>"3", 3 =>"4", 4 => "5", 5 => "6"}
    action_status = {"0" => "4", "1" => "5", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
     ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    SELECTED_WARNING_ARRAY.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    # create result id
    SELECTED_WARNING_ARRAY.each do |warning|
        warning_result = WarningsResult.new
        warning_result.warning_id = warning
        warning_result.result_id = 123
        warning_result.rule_level = Warning.find(warning).rule_level
        warning_result.save
    end
    # call save redmine setting
     get :save_redmine_setting,
                  :pu         => 1,
                  :pj_redmine => 1,
                  :issue_status => issue_status,
                  :action_status => action_status,
                  :redmine_user => 1,
                  :pj         => 1,
                  :id         => 1
     # call synchronize_issues
     get :synchronize_issues,
                  :pj         => 1,
                  :id         => 1,
                  :p1 => WARNING_LISTING
     assert_response :success

    SELECTED_WARNING_ARRAY.each do |warning_id|
          warning_issue = WarningIssue.find_by_warning_id(warning_id)
          redmine_issue = RedmineIssue.find(warning_issue.redmine_issue_id)
          assert_equal(redmine_issue.status_id, 1)
     end
  end

  # + User logged in
  # + Request to synchronize_issue
  def test_it_t5_cbbt_wr_034
    login_as REVIEWER_login
    issue_status = {0 => "1", 1 => "2", 2 =>"3", 3 =>"4", 4 => "5", 5 => "6"}
    action_status = {"0" => "4", "1" => "5", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
    ## initialize session
    @request.session["subtask"] = Subtask.find_by_id(1)
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
    SELECTED_WARNING_ARRAY.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    # create result id
    SELECTED_WARNING_ARRAY.each do |warning|
        warning_result = WarningsResult.new
        warning_result.warning_id = warning
        warning_result.result_id = 123
        warning_result.rule_level = Warning.find(warning).rule_level
        warning_result.save
    end
    # call save redmine setting
     get :save_redmine_setting,
                  :pu         => 1,
                  :pj_redmine => 1,
                  :issue_status => issue_status,
                  :action_status => action_status,
                  :redmine_user => 1,
                  :pj         => 1,
                  :id         => 1
     # call synchronize_issues
     get :synchronize_issues,
                  :pj         => 1,
                  :id         => 1,
                  :p1 => WARNING_LISTING_FILE
     assert_response :success

    SELECTED_WARNING_ARRAY.each do |warning_id|
          warning_issue = WarningIssue.find_by_warning_id(warning_id)
          redmine_issue = RedmineIssue.find(warning_issue.redmine_issue_id)
          assert_equal(redmine_issue.status_id, 1)
     end
  end

  # + User logged in
  # + Request to synchronize_issue
  def test_it_t5_cbbt_wr_035
    login_as REVIEWER_login
    issue_status = {0 => "1", 1 => "2", 2 =>"3", 3 =>"4", 4 => "5", 5 => "6"}
    action_status = {"0" => "4", "1" => "5", "2" =>"2", "3" =>"1", "4" => "2", "5" => "2"}
     ## initialize session
    @request.session["subtask"] = Subtask.find_by_id(1)
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    SELECTED_WARNING_ARRAY.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    # create result id
    SELECTED_WARNING_ARRAY.each do |warning|
        warning_result = WarningsResult.new
        warning_result.warning_id = warning
        warning_result.result_id = 123
        warning_result.rule_level = Warning.find(warning).rule_level
        warning_result.save
    end
    # call save redmine setting
     get :save_redmine_setting,
                  :pu         => 1,
                  :pj_redmine => 1,
                  :issue_status => issue_status,
                  :action_status => action_status,
                  :redmine_user => 1,
                  :pj         => 1,
                  :id         => 1
     # call synchronize_issues
     get :synchronize_issues,
                  :pj         => 1,
                  :id         => 1,
                  :p1 => WARNING_LISTING
     assert_response :success

    SELECTED_WARNING_ARRAY.each do |warning_id|
          warning_issue = WarningIssue.find_by_warning_id(warning_id)
          redmine_issue = RedmineIssue.find(warning_issue.redmine_issue_id)
          assert_equal(redmine_issue.status_id, 1)
    end
  end
end