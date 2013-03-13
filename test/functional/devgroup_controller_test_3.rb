require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../integration/setup'

class DevgroupControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  ##############################################################################
  # Setup
  ##############################################################################
  # Fixtures
  fixtures :users
  fixtures :privileges
  fixtures :privileges_users
  fixtures :settings
  fixtures :pus
  fixtures :pjs
  fixtures :subtasks
  fixtures :tasks
  #
  TCANA_admin = "root"
  PU_admin = "pu_admin"
  Other_member = "quentin"
  PJ_admin = "pj_admin"
  PJ_member = "pj_member"

  def setup
    @controller = DevgroupController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_it_t4_bsf_dev_001
    post :save_backend_setting
    assert_redirected_to :controller => "auth", :action => "login"
  end

  def test_it_t4_bsf_dev_002
    login_as PJ_member
    post :save_backend_setting
    assert_redirected_to :controller => "misc", :action => "index"
  end

  def test_it_t4_bsf_dev_003
    login_as TCANA_admin
    post :save_backend_setting, :pu => 1, :pj => 1, :selected =>{"setting"=>"regex"}, :regex_text => "t*"
    assert_response :success
    assert_equal "Save BackEnd Setting successful", flash[:notice]
  end

  def test_it_t4_bsf_dev_004
    login_as TCANA_admin  
    post :save_backend_setting, :pu => 1, :pj => 1, :selected =>{"setting"=>"regex"}, :regex_text => ""
    assert_response :success
    assert_equal "Regular Expression string is required", flash[:notice]
  end

  def test_it_t4_bsf_dev_005
    login_as TCANA_admin
    post :save_backend_setting, :pu => 1, :pj => 1, :selected =>{"setting"=>"regex"}, :regex_text => "+++"
    assert_response :success
    assert_equal "Regular Expression string is invalid", flash[:notice]
  end

  def test_it_t4_bsf_dev_006
    login_as TCANA_admin
    post :save_backend_setting, :pu => 1, :pj => 1, :selected =>{"setting"=>"other"}, :regex_text => "t*"
    assert_response :success
    assert_equal "There was an error in BackEnd Setting", flash[:notice]
  end

  def test_it_t4_bsf_dev_007
    login_as TCANA_admin
    post :save_backend_setting, :pu => 1, :pj => 1, :selected =>{"setting"=>"list"}, :regex_text => ".*", :usable => ["2", "3"]
    assert_response :success
    assert_equal "Save BackEnd Setting successful", flash[:notice]
  end

  def test_it_t4_bsf_dev_008
    login_as TCANA_admin
    post :save_backend_setting, :pu => 1, :pj => 1, :selected =>{"setting"=>"list"}, :regex_text => ".*", :usable => []
    assert_response :success
    assert_equal "Save BackEnd Setting successful", flash[:notice]
  end

  def test_it_t4_bsf_dev_009
    login_as TCANA_admin
    post :save_backend_setting, :pu => 1, :pj => 1, :selected =>{"setting"=>"other"}, :regex_text => ".*", :usable => ["2"]
    assert_response :success
    assert_equal "There was an error in BackEnd Setting", flash[:notice]
  end

  def test_it_t4_bsf_dev_010
    post :cancel_target_setting, :pu => 1, :pj => 2
    assert_redirected_to :controller => "auth", :action => "login"
  end

  def test_it_t4_bsf_dev_011
    login_as PJ_member
    post :cancel_target_setting, :pu => 1, :pj => 2
    assert_response :success
  end

  def test_it_t4_bsf_dev_012
    login_as TCANA_admin
    post :cancel_target_setting, :pu => 1, :pj => 2, :selected =>{"setting"=>"regex"}, :regex_text => "t*"
    assert_response :success
  end

  def test_it_t4_bsf_dev_013
    login_as TCANA_admin
    post :cancel_target_setting, :pu => 1, :pj => 1, :selected =>{"setting"=>"regex"}, :regex_text => "t*"    
    assert_response :success
    check = PjBackendSetting.find_by_pj_id(1)
    assert_not_equal check.regex_string, "t*"
  end

  def test_it_t4_bsf_dev_014
    post :test_regex_string
    assert_redirected_to :controller => "auth", :action => "login"
  end

  def test_it_t4_bsf_dev_015
    login_as PJ_member
    post :test_regex_string
    assert_redirected_to :controller => "misc", :action => "index"
  end

  def test_it_t4_bsf_dev_016
    login_as TCANA_admin
    post :test_regex_string, :pu => 1, :pj => 2, :regex_text => ""
    assert_response :success
    assert_equal "Regular Expression string is required", flash[:notice]
  end

  def test_it_t4_bsf_dev_017
    login_as TCANA_admin
    post :test_regex_string, :pu => 1, :pj => 2, :regex_text => "+++"
    assert_response :success
    assert_equal "Regular Expression string is invalid", flash[:notice]
  end

  def test_it_t4_bsf_dev_018
    login_as TCANA_admin
    post :test_regex_string, :pu => 1, :pj => 2, :regex_text => "z*"
    assert_response :success
    assert_response :success
  end

  def test_it_t4_bsf_dev_019
    login_as TCANA_admin
    post :test_regex_string, :pu => 1, :pj => 1, :regex_text => "t*"
    assert_response :success
  end
end