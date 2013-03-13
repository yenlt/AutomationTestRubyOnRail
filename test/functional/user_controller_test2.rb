require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../integration/setup'
require 'user_controller'

class UserControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  ##############################################################################
  # Setup
  ##############################################################################
  # Fixtures
  fixtures :users
  fixtures :privileges
  fixtures :privileges_users
  #
  NAME = "ldap_setting"
  HOST = "localhost"
  PORT = "10389"
  SSL_PORT = "10633"
  ACCOUNT = "ou=users,ou=system"
  PASS = "root"
  BASE_DN = "ou=users,ou=system"
  LOGIN = "uid"
  MAIL = "mail"
  #
  TCANA_admin = "root"
  PU_admin = "pu_admin"
  PJ_member = "pj_member"
  PJ_admin = "pj_admin"
  USER_NAME = "angq"
  USER_MAIL = "angq@tsdv.com.vn"
  USER_PASS = "angq"
  #
  def params(name,nick,pass,pass_confirm,mail)
    params = {  :password_confirmation  =>  pass_confirm,
      :nick_name              =>  nick,
      :account_name           =>  name,
      :password               =>  pass,
      :email                  =>  mail}
    return params
  end
  #
  def params_edit(id,name,nick,pass,pass_confirm,mail)
    params = {  :id           => id,
      :password_confirmation  =>  pass_confirm,
      :nick_name              =>  nick,
      :account_name           =>  name,
      :password               =>  pass,
      :email                  =>  mail}
    return params
  end
  #
  def create_a_ldap
    LdapSetting.delete_all()
    ldap = LdapSetting.create( :name =>  NAME,
      :host =>  HOST,
      :port =>  PORT,
      :base_dn  => BASE_DN,
      :attr_login => LOGIN,
      :in_use => true)
    return ldap
  end
  #
  def create_a_fly_ldap
    LdapSetting.delete_all()
    ldap = LdapSetting.create( :name =>  NAME,
      :host =>  HOST,
      :port =>  PORT,
      :base_dn  => BASE_DN,
      :attr_login => LOGIN,
      :on_the_fly_user_creation  => true,
      :attr_mail => MAIL,
      :in_use => true)
    return ldap
  end
  #
  def create_ldap_user(ldap_id)
    user = User.create( :account_name => USER_NAME,
      :email        => USER_MAIL,
      :ldap_setting_id  => ldap_id)
    return user
  end
  #
  def create_normal_user(name,mail,pass,pass_confirm)
    user = User.create(:account_name  => name,
      :email         => mail,
      :password      => pass,
      :password_confirmation => pass_confirm)
    return user
  end

  ##############################################################################
  # Cooperation with LDAP
  ##############################################################################

  # Function: add_user
  # 
  # Input: + TCANA member (PU/PJ admin, PU/PJ member) logged in.
  #        + Request to add user
  # Expect: TCANA member has no right to add user
  #
  def test_it_t1_la_user_001
    login_as PU_admin
    get :add_user
    assert_redirected_to :controller => "misc", :action => "index"
    post :add_user,
      :user => params(USER_NAME,"",USER_PASS,USER_PASS,USER_MAIL),
      :ldap_status => "OFF"
    assert_redirected_to :controller => "misc", :action => "index"
    #
    login_as PJ_admin
    get :add_user
    assert_redirected_to :controller => "misc", :action => "index"    
    post :add_user,
      :user => params(USER_NAME,"",USER_PASS,USER_PASS,USER_MAIL),
      :ldap_status => "OFF"
    assert_redirected_to :controller => "misc", :action => "index"
  end
  #
  # Input: + TCANA admin logged in.
  #        + Request to add user normal.
  #        + All required information are inputted correct.
  # Expect: User is created.
  #
  def test_it_t1_la_user_002
    login_as TCANA_admin
    get :add_user
    assert_response :success
    assert_template "add_user"
    #
    post :add_user,
      :user => params(USER_NAME,"",USER_PASS,USER_PASS,USER_MAIL),
      :ldap_status => "OFF"
    assert_response :success
  end
  #
  # Input: + TCANA admin logged in.
  #        + Request to add user with LDAP (mail is not mapped)
  #        + Account name and email are inputted.
  # Expect: User is created.
  #
  def test_it_t1_la_user_003
    create_a_ldap
    login_as TCANA_admin
    post :add_user,
      :user => params(USER_NAME,"","","",USER_MAIL),
      :ldap_status => "ON"
    assert_response :success
    assert_equal USER_NAME,User.find(:last).account_name
  end
  #
  # Input: + TCANA admin logged in.
  #        + Request to add user with LDAP (mail is mapped)
  #        + Only account name is inputted
  # Expect: User is created.
  #
  def test_it_t1_la_user_004
    create_a_fly_ldap
    login_as TCANA_admin
    post :add_user,
      :user => params(USER_NAME,"","","",""),
      :ldap_status => "ON"
    assert_response :success
    assert_equal USER_NAME,User.find(:last).account_name
  end
  #
  # Input: + TCANA admin logged in.
  #        + Request to add user with LDAP (mail is not mapped)
  #        + Only account name is inputted
  # Expect: User is failed to create.
  #
  def test_it_t1_la_user_005
    create_a_ldap
    login_as TCANA_admin
    post :add_user,
      :user => params(USER_NAME,"","","",""),
      :ldap_status => "ON"
    assert_response :success
    assert_not_equal USER_NAME,User.find(:last).account_name
  end
  # Function: change_user
  #
  # Input: + TCANA member (PU/PJ admin, PU/PJ member) logged in.
  #        + Request to change user
  # Expect: TCANA member has no right to change user
  #
  def test_it_t1_la_user_006
    user = create_normal_user(USER_NAME,USER_MAIL,USER_PASS,USER_PASS)
    login_as PU_admin
    get :change_user, :id => user.id
    assert_redirected_to :controller => "misc", :action => "index"    
    post :change_user,
      :user => params_edit(user.id,USER_NAME,"",USER_PASS,USER_PASS,USER_MAIL),
      :ldap_status => "OFF"
    assert_redirected_to :controller => "misc", :action => "index"
    #
    login_as PJ_admin
    get :change_user, :id => user.id
    assert_redirected_to :controller => "misc", :action => "index"   
    post :change_user,
      :user => params_edit(user.id,USER_NAME,"",USER_PASS,USER_PASS,USER_MAIL),
      :ldap_status => "OFF"
    assert_redirected_to :controller => "misc", :action => "index"
  end
  #
  # Input: + TCANA admin logged in.
  #        + Request to change user normally.
  #        + All required information are inputted correct.
  # Expect: User is updated.
  #
  def test_it_t1_la_user_007
    user = create_normal_user(USER_NAME,USER_MAIL,USER_PASS,USER_PASS)
    login_as TCANA_admin
    get :change_user, :id => user.id
    assert_response :success
    assert_template "change_user"
    post :change_user,
      :user =>  params_edit(user.id,USER_NAME,"",USER_PASS,USER_PASS,USER_MAIL),
      :ldap_status => "OFF"
    assert_response :success
  end
  #
  # Input: + TCANA admin logged in.
  #        + Request to change user.
  #        + Normal user change to LDAP cooperated user
  # Expect: User is successful updated
  #
  def test_it_t1_la_user_008
    user = create_normal_user(USER_NAME,USER_MAIL,USER_PASS,USER_PASS)
    ldap = create_a_ldap
    login_as TCANA_admin
    post :change_user,
      :user =>  params_edit(user.id,USER_NAME,"","","",USER_MAIL),
      :ldap_status => "ON"
    assert_response :success
    assert_equal USER_NAME,User.find(:last).account_name
    assert_equal ldap.id, User.find(:last).ldap_setting_id
  end
  #
  # Input: + TCANA admin logged in.
  #        + Request to change user.
  #        + LDAP cooperated user to normal user
  # Expect: User is successful updated.
  #
  def test_it_t1_la_user_009
    ldap = create_a_ldap
    user = create_ldap_user(ldap.id)
    login_as TCANA_admin
    post :change_user,
      :user => params_edit(user.id,USER_NAME,"",USER_PASS,USER_PASS,USER_MAIL),
      :ldap_status => "OFF"
    assert_response :success
    assert_equal USER_NAME,User.find(:last).account_name
  end
  #
  # Input: + TCANA admin logged in.
  #        + Request to change user with LDAP.
  #        + LDAP setting is not existed.
  # Expect: User is failed to update.
  #
  def test_it_t1_la_user_010
    LdapSetting.delete_all()
    user = create_normal_user(USER_NAME,USER_MAIL,USER_PASS,USER_PASS)
    login_as TCANA_admin
    post :change_user,
      :user =>  params_edit(user.id,USER_NAME,"","","",USER_MAIL),
      :ldap_status => "ON"
    assert_nil User.find(:last).ldap_setting_id
  end
  #
  # Input: + TCANA admin logged in.
  #        + Request to change user.
  #        + LDAP cooperated user to normal user
  #        + Inputted pass and pass confirmation are not matched.
  # Expect: User is failed to update.
  #
  def test_it_t1_la_user_011
    ldap = create_a_ldap
    user = create_ldap_user(ldap.id)
    login_as TCANA_admin
    post :change_user,
      :user => params_edit(user.id,"USER_NAME","",USER_PASS,"USER_PASS",USER_MAIL),
      :ldap_status => "OFF"
    #assert_not_equal "USER_NAME",User.find(:last).account_name
  end
  #
  # Input: + TCANA admin logged in.
  #        + Request to change user.
  #        + LDAP cooperated user to normal user
  #        + Inputted pass and pass confirmation is not length enough
  # Expect: User is failed to update.
  #
  def test_it_t1_la_user_012
    ldap = create_a_ldap
    user = create_ldap_user(ldap.id)
    login_as TCANA_admin
    post :change_user,
      :user => params_edit(user.id,"USER_NAME","","123","123",USER_MAIL),
      :ldap_status => "OFF"
    #assert_not_equal "USER_NAME",User.find(:last).account_name
  end
  #
  # Input: + TCANA admin logged in.
  #        + Request to change user.
  #        + LDAP cooperated user to normal user
  #        + Inputted pass and pass confirmation is not longer than 10.
  # Expect: User is failed to update.
  #
  def test_it_t1_la_user_013
    ldap = create_a_ldap
    user = create_ldap_user(ldap.id)
    login_as TCANA_admin
    post :change_user,
      :user => params_edit(user.id,"USER_NAME","","123456789012","123456789012",USER_MAIL),
      :ldap_status => "OFF"
    #assert_not_equal "USER_NAME",User.find(:last).account_name
  end
  # Function: self_change_user
  #
  # Input: + TCANA member (PU/PJ admin, PU/PJ member) logged in.
  #        + Request to change user
  # Expect: + TCANA member has right to change his/her self information.
  #         + His/her information is updated.
  #
  def test_it_t1_la_user_014
    user = User.find_by_account_name_and_deleted_at(PJ_member,nil)
    login_as user.account_name
    get :self_change_user, :id => user.id
    assert_response :success
    assert_template "change_user"
    post :self_change_user,
      :user => params_edit(user.id,"USER_NAME","",USER_PASS,USER_PASS,USER_MAIL),
      :ldap_status => "OFF"
    assert_response :success
    assert_equal "USER_NAME", User.find_by_id(user.id).account_name
  end
  # Input: + TCANA member (PU/PJ admin, PU/PJ member) logged in.
  #        + Request to change from normal user to LDAP user.
  # Expect:+ His/her information is updated.
  #
  def test_it_t1_la_user_015
    ldap = create_a_ldap
    user =  User.find_by_account_name_and_deleted_at(PJ_member,nil)
    login_as user.account_name
    post :self_change_user,
      :user => params_edit(user.id,USER_NAME,"","","",USER_MAIL),
      :ldap_status => "ON"
    assert_response :success
    assert_equal ldap.id, User.find_by_id(user.id).ldap_setting_id
    assert_equal USER_NAME, User.find_by_id(user.id).account_name
  end
  # Input: + TCANA member (PU/PJ admin, PU/PJ member) logged in.
  #        + Request to change from LDAP user to normal user.
  # Expect:+ His/her information is updated.
  #
  def test_it_t1_la_user_016
    ldap = create_a_ldap
    user =  User.find_by_account_name_and_deleted_at(PJ_member,nil)
    login_as user.account_name
    post :self_change_user,
      :user => params_edit(user.id,USER_NAME,"","","",USER_MAIL),
      :ldap_status => "ON"
    assert_response :success
    assert_equal ldap.id, User.find_by_id(user.id).ldap_setting_id
    assert_equal USER_NAME, User.find_by_id(user.id).account_name
    #
    post :self_change_user,
      :user => params_edit(user.id,USER_NAME,"",USER_PASS,USER_PASS,USER_MAIL),
      :ldap_status => "OFF"
    assert_response :success
    assert_nil User.find_by_id(user.id).ldap_setting_id
  end
  # Input: + TCANA member (PU/PJ admin, PU/PJ member) logged in.
  #        + Request to change from LDAP user to normal user.
  #        + Pass and pass confirmation are blank.
  # Expect:+ Failed to update user information
  #
  def test_it_t1_la_user_017
    ldap = create_a_ldap
    user =  User.find_by_account_name_and_deleted_at(PJ_member,nil)
    login_as user.account_name
    post :self_change_user,
      :user => params_edit(user.id,USER_NAME,"","","",USER_MAIL),
      :ldap_status => "ON"
    assert_response :success
    assert_equal ldap.id, User.find_by_id(user.id).ldap_setting_id
    assert_equal USER_NAME, User.find_by_id(user.id).account_name
    #
    post :self_change_user,
      :user => params_edit(user.id,USER_NAME,"","","",USER_MAIL),
      :ldap_status => "OFF"
    assert_equal ldap.id,User.find_by_id(user.id).ldap_setting_id
  end


  
end
