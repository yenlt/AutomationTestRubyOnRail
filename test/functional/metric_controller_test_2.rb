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
  fixtures :metrics
  #
  TCANA_admin = "root"
  PU_admin = "pu_admin"
  Other_member = "quentin"
  PJ_admin = "pj_admin"
  PJ_member = "pj_member"

  def setup
    @controller = MetricController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_it_t4_mvf_met_001
    post :view_graph
    assert_redirected_to :controller => "auth", :action => "login"
  end

  def test_it_t4_mvf_met_002
    login_as Other_member
    post :view_graph
    assert_redirected_to :controller => "misc", :action => "index"
  end

  def test_it_t4_mvf_met_003
    login_as TCANA_admin
    post :view_graph, :pu => 1, :pj => 2, :id => 5
    assert_response :success
    assert_template "view_graph"
  end

  def test_it_t4_mvf_met_004
    post :view_directories_and_files_window
    assert_redirected_to :controller => "auth", :action => "login"
  end

  def test_it_t4_mvf_met_005
    login_as Other_member
    post :view_directories_and_files_window
    assert_redirected_to :controller => "misc", :action => "index"
  end

  def test_it_t4_mvf_met_006
    login_as TCANA_admin
    post :view_directories_and_files_window, :pu => 1, :pj => 2, :id => 5
    assert_response :success
  end

  def test_it_t4_mvf_met_007
    login_as TCANA_admin
    post :view_graph, :id => 10000
    assert_redirected_to :controller => "misc", :action => "index"
  end

  def test_it_t4_mvf_met_008
    post :save_target_setting
    assert_redirected_to :controller => "auth", :action => "login"
  end

  def test_it_t4_mvf_met_009
    login_as Other_member
    post :save_target_setting
    assert_redirected_to :controller => "misc", :action => "index"
  end

  def test_it_t4_mvf_met_010
    login_as TCANA_admin
    post :save_target_setting, :pu => 1, :pj => 2, :id => 5, :params => {"chkbox_dir330"=>"330"}
    assert_response :success
  end

  def test_it_t4_mvf_met_011
    login_as TCANA_admin
    post :save_target_setting, :pu => 1, :pj => 2, :id => 5, :params => {}
    assert_response :success
  end

  def test_it_t4_mvf_met_012
    post :draw_graph
    assert_redirected_to :controller => "auth", :action => "login"
  end

  def test_it_t4_mvf_met_013
    login_as Other_member
    post :draw_graph
    assert_redirected_to :controller => "misc", :action => "index"
  end

  def test_it_t4_mvf_met_014
    login_as TCANA_admin
    post :draw_graph, :pu => 1, :pj => 2, :id => 5
    #assert_redirected_to :controller => "metric", :action => "draw_graph"
    assert_response :success
  end

  def test_it_t4_mvf_met_015
    login_as TCANA_admin
    post :draw_graph, :pu => 1, :pj => 2, :id => 5, :limit_setting => -1
    assert_response :success
  end

  def test_it_t4_mvf_met_016
    login_as TCANA_admin
    post :draw_graph, :pu => 1, :pj => 2, :id => 5, :limit_setting => "abc"
    assert_response :success
  end

  def test_it_t4_mvf_met_017
    login_as TCANA_admin
    post :draw_graph, :pu => 1, :pj => 2, :id => 5, :limit_setting => 10, :order_setting => "ASC", :selected_file_ids => []
    assert_response :success
  end

  def test_it_t4_mvf_met_018
    login_as TCANA_admin
    post :draw_graph, :pu => 1, :pj => 2, :id => 5, :metric_name => "abc"
    assert_response :success
  end

  def test_it_t4_mvf_met_019
    login_as TCANA_admin
    post :draw_graph, :pu => 1, :pj => 2, :id => 5, :metric_name => "STCBO", :limit_setting => 10, :order_setting => "ASC"
    assert_response :success
  end

  def test_it_t4_mvf_met_020
    login_as TCANA_admin
    post :draw_graph, :pu => 1, :pj => 2, :id => 5, :metric_name => "STMTH", :limit_setting => 10, :order_setting => "DESC"
    assert_response :success
  end
end