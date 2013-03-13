require File.dirname(__FILE__) + "/test_m_setup" unless defined? TestMSetup
#require "test/unit"
class TestM5 < Test::Unit::TestCase
  include TestMSetup
  #this is not a test
  def test_051
    assert true
  end
  # Arbitrary users are chosen and deleted from "user management" page.
  # A privileges_users record is deleted.
  def test_052
    test_000
    login("root","root")
    ## add user "pj_member" to SamplePU1 admin list
    add_pu_admin
    wait_for_button_enable($xpath["pu_user"]["add_user_pu"])
    all_privileges_users = PrivilegesUsers.find_all_by_user_id(USER_ID)
    assert_not_equal all_privileges_users,[]
    ## delete user "pj_member"
    delete_user_sample
    sleep 10
    all_privileges_users = PrivilegesUsers.find_all_by_user_id(USER_ID)
    assert_equal all_privileges_users,[]
    logout
  end
  # Arbitrary users are chosen and deleted from "user management" page.
  # A pus_users record is deleted.
  def test_053
    test_000
    login("root","root")
    ## add user "pj_member" to SamplePU1 admin list
    add_pu_admin
    wait_for_button_enable($xpath["pu_user"]["add_user_pu"])
    all_pus_users = PusUsers.find_all_by_user_id(USER_ID)
    assert_not_equal all_pus_users,[]
    ## delete user "pj_member"
    delete_user_sample
    sleep 10
    all_pus_users = PusUsers.find_all_by_user_id(USER_ID)
    assert_equal all_pus_users,[]
    logout
  end
  # Arbitrary users are chosen and deleted from "user management" page.
  # A pjs_users record is deleted.
  def test_054
    test_000
    login("root","root")
    ## add user "pj_member" to SamplePU1 admin list
    add_pu_admin
    wait_for_button_enable($xpath["pu_user"]["add_user_pu"])
    all_pjs_users = PjsUsers.find_all_by_user_id(USER_ID)
    assert_not_equal all_pjs_users,[]
    ## delete user "pj_member"
    delete_user_sample
    sleep 10
    all_pjs_users = PjsUsers.find_all_by_user_id(USER_ID)
    assert_equal all_pjs_users,[]
    logout
  end
end
