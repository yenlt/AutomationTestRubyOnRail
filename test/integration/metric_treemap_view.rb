require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../integration/setup'
require 'pu_controller'
require 'pj_controller'

class ReviewResultFunctionTest < ActionController::IntegrationTest

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

  ##*****************************************##
  ## TEST INTEGRATION TCANA2010B PHASE 2 ##
  ##*****************************************##

  ## Test pu_controller.find_all_pus method
  # + User logged in.
  # + Request to find_all_pus
  #
  def test_it_t4_mtv_pu_001
    login(Admin_login, Admin_pass)
     get url_for(:controller => "pu",
        :action     => "find_all_pus(1,1,1)",
        :pu         => 1,
        :pj         => 1,
        :id         => 1)
     assert_response :success
  end

  # + User not logged in.
  # + Request to find_all_pus
  #
  def test_it_t4_mtv_pu_002
     get url_for(:controller => "pu",
        :action     => "find_all_pus",
        :pu         => 1,
        :pj         => 2,
        :id         => 6)
     assert_redirected_to :controller => "auth", :action => "login"
  end
  
  # Test pu_controller.find_all_pjs_belong_to_pu
  # + User logged in.
  # + Request to find_all_pjs_belong_to_pu
  #
  def test_it_t4_mtv_pu_003
     login(Admin_login, Admin_pass)
     get url_for(:controller => "pu",
        :action     => "find_all_pjs_belong_to_pu",
        :pu         => 1,
        :pj         => 2,
        :id         => 6)
     assert_response :success
  end

  # + User not logged in.
  # + Request to find_all_pjs_belong_to_pu
  #
  def test_it_t4_mtv_pu_004
     get url_for(:controller => "pu",
        :action     => "find_all_pjs_belong_to_pu",
        :pu         => 1,
        :pj         => 2,
        :id         => 6)
     assert_redirected_to :controller => "auth", :action => "login"
  end
  
  # Test pj_controller.find_all_tasks_belong_to_pj
  # + User logged in.
  # + Request to find_all_pjs_belong_to_pj
  #
  def test_it_t4_mtv_pj_001
    login(Admin_login, Admin_pass)
     get url_for(:controller => "pj",
        :action     => "find_all_tasks_belong_to_pj",
        :pu         => 1,
        :pj         => 2,
        :id         => 6)
     assert_response :success
  end

  # + User not logged in.
  # + Request to find_all_pjs_belong_to_pj
  #
  def test_it_t4_mtv_pj_002
#    login(Admin_login, Admin_pass)
     get url_for(:controller => "pj",
        :action     => "find_all_tasks_belong_to_pj",
        :pu         => 1,
        :pj         => 2,
        :id         => 6)
     assert_redirected_to :controller => "auth", :action => "login"
  end

  # Test treemap_controller
  # + User logged in as TCANA administrator
  # + Request to index
  #
  def test_it_t4_mtv_tr_001
    login(Admin_login, Admin_pass)
     get url_for(:controller => "treemap",
        :action     => "index",
        :pu         => 1,
        :pj         => 2,
        :id         => 5)
     assert_response :success
  end

  # + User logged in as PU administrator
  # + Request to index
  #
  def test_it_t4_mtv_tr_002
    login(Pu_admin, Pu_admin_pass)
     get url_for(:controller => "treemap",
        :action     => "index",
        :pu         => 1,
        :pj         => 2,
        :id         => 6)
     assert_response :success
  end

  # + User logged in as PJ administrator
  # + Request to index
  #
  def test_it_t4_mtv_tr_003
    login(Pj_admin, Pj_admin_pass)
     get url_for(:controller => "treemap",
        :action     => "index",
        :pu         => 1,
        :pj         => 1,
        :id         => 6)
     assert_response :success
  end

  # + User logged in as Pj_member
  # + Request to index
  #
  def test_it_t4_mtv_tr_004
    login(Pj_member, Pj_member_pass)
     get url_for(:controller => "treemap",
        :action     => "index",
        :pu         => 1,
        :pj         => 1,
        :id         => 6)
     assert_response :success
  end

  # + User logged in as Pu_member
  # + Request to index
  #
  def test_it_t4_mtv_tr_005
    login(Pu_member, Pu_member_pass)
     get url_for(:controller => "treemap",
        :action     => "index",
        :pu         => 1,
        :pj         => 1,
        :id         => 6)
     assert_redirected_to :controller => "misc", :action => "index"
  end

  # + User logged in as general_user
  # + Request to index
  #
  def test_it_t4_mtv_tr_006
    login(General_user, General_user_pass)
     get url_for(:controller => "treemap",
        :action     => "index",
        :pu         => 1,
        :pj         => 1,
        :id         => 6)
     assert_redirected_to :controller => "misc", :action => "index"
  end
end