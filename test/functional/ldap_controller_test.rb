require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../integration/setup'
require 'ldap_controller'

class LdapControllerTest < ActionController::TestCase
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
  SSL_PORT = "10636"
  ACCOUNT = "ou=users,ou=system"
  PASS = "root"
  BASE_DN = "ou=users,ou=system"
  LOGIN = "uid"
  MAIL = "mail"
  #
  TCANA_admin = "root"
  PU_admin = "pu_admin"
  PU_member = "pu_member"
  PJ_admin = "pj_admin"
  USER_NAME = "angq"
  USER_MAIL = "angq@tsdv.com.vn"
  # Create a number of LDAP setting
  def create_ldap_settings(numbers)
    if numbers >= 1
      LdapSetting.delete_all()
      (1..numbers).each do |i|
        ldap = LdapSetting.new( :name =>  NAME+ i.to_s,
          :host =>  HOST,
          :port =>  SSL_PORT,
          :tls  => true,
          :base_dn  => BASE_DN,
          :attr_login => LOGIN)
        ldap.save
      end
    end
  end
  #
  def create_a_ldap
    ldap = LdapSetting.create( :name =>  NAME,
      :host =>  HOST,
      :port =>  PORT,
      :base_dn  => BASE_DN,
      :attr_login => LOGIN)
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
  def params(name,port,account,pass,base_dn,tls,mail,on_the_fly,attr_login,host)
    params = {  :name => name,
                :port => port,
                :account  =>  account,
                :account_password => pass,
                :base_dn  =>  base_dn,
                :tls  =>  tls,
                :attr_mail  =>  mail,
                :on_the_fly_user_creation =>  on_the_fly,
                :attr_login =>  attr_login,
                :host =>  host  }
    return params
  end
  ##############################################################################
  # LDAP Administration function
  ##############################################################################

  # Function: index
  #
  # Input:  + User has not logged in.
  #         + Request to call "index" function to view LDAP administration page.
  # Expected: Redirected back to login page.
  #
  def test_it_t1_la_ldap_001
    # User has not logged in
    post :index
    assert_equal nil,(@controller.instance_variable_get "@ldap_settings")
    assert_redirected_to :controller => "auth", :action => 'login'
  end
  #
  # Input:  + TCANA member logged in.
  #         + Request to call "index" function to view LDAP administration page.
  # Expected: Redirected back to misc page.
  #
  def test_it_t1_la_ldap_002
    # PU/PJ admin
    login_as PU_admin
    post :index
    assert_equal nil,(@controller.instance_variable_get "@ldap_settings")
    assert_redirected_to :controller => "misc", :action => "index"
    #
    login_as PJ_admin
    post :index
    assert_equal nil,(@controller.instance_variable_get "@ldap_settings")
    assert_redirected_to :controller => "misc", :action => "index"
  end
  #
  # Input:  + TCANA admin logged in.
  #         + Request to call "index" function to view LDAP administration page.
  # Expected: Index page is displayed.
  #
  def test_it_t1_la_ldap_003
    # TCANA admin login
    login_as TCANA_admin
    post :index
    assert_response :success
    assert_template "index"
    assert_not_equal nil,(@controller.instance_variable_get "@ldap_settings")
  end
  #
  # Input:  + TCANA admin logged in.
  #         + Request to call "index" function to view LDAP administration page.
  #         + Request to view the first page of LDAP list. (more than 10 ldap is existed)
  # Expected: + Index page is displayed.
  #           + 10 LDAP setting/page is displayed.
  def test_it_t1_la_ldap_004
    create_ldap_settings(15)
    # TCANA admin login
    login_as TCANA_admin
    post :index, :page => 1
    assert_response :success
    assert_template "index"
    assert_equal 10,(@controller.instance_variable_get "@ldap_settings").size
    assert_equal 1,(@controller.instance_variable_get "@page").to_i
  end
  #
  # Input:  + TCANA admin logged in.
  #         + Request to call "index" function to view LDAP administration page.
  #         + Request to view the page out of size. (more than 10 ldap is existed, request to view page 1000)
  # Expected: + Index page is displayed.
  #           + the first page of LDAP list is displayed.
  def test_it_t1_la_ldap_005
    create_ldap_settings(15)
    # TCANA admin login
    login_as TCANA_admin
    post :index, :page => 1000
    assert_response :success
    assert_template "index"
    assert_equal 10,(@controller.instance_variable_get "@ldap_settings").size
    assert_equal 1,(@controller.instance_variable_get "@page").to_i
  end
  #
  # Input:  + TCANA admin logged in.
  #         + Request to call "index" function to view LDAP administration page.
  #         + Request to view the page with the sort options (sort with name field)
  # Expected: + Index page is displayed.
  #           + LDAP list is sorted.
  def test_it_t1_la_ldap_006
    create_ldap_settings(15)
    # TCANA admin login
    login_as TCANA_admin
    post :index, :page => 1, :order_field => "name", :order_direction => "ASC"
    assert_response :success
    assert_template "index"
    ldaps = @controller.instance_variable_get "@ldap_settings"
    assert_equal 10,ldaps.size
    assert true if ldaps[1].name > ldaps[2].name
    #
    post :index, :page => 1, :order_field => "name", :order_direction => "DESC"
    assert_response :success
    assert_template "index"
    ldaps = @controller.instance_variable_get "@ldap_settings"
    assert_equal 10,ldaps.size
    assert true if ldaps[1].name < ldaps[2].name
  end
  #
  # Input:  + TCANA admin logged in.
  #         + Request to call "index" function to view LDAP administration page.
  #         + Request to view the page with the sort options (sort with type field)
  # Expected: + Index page is displayed.
  #           + LDAP list is sorted.
  def test_it_t1_la_ldap_007
    create_ldap_settings(15)
    # TCANA admin login
    login_as TCANA_admin
    post :index, :page => 1, :order_field => "tls", :order_direction => "ASC"
    assert_response :success
    assert_template "index"
    ldaps = @controller.instance_variable_get "@ldap_settings"
    assert_equal 10,ldaps.size
    assert true if ldaps[1].auth_method_name > ldaps[2].auth_method_name
    #
    post :index, :page => 1, :order_field => "tls", :order_direction => "DESC"
    assert_response :success
    assert_template "index"
    ldaps = @controller.instance_variable_get "@ldap_settings"
    assert_equal 10,ldaps.size
    assert true if ldaps[1].auth_method_name < ldaps[2].auth_method_name
  end
  #
  # Input:  + TCANA admin logged in.
  #         + Request to call "index" function to view LDAP administration page.
  #         + Request to view the page with the sort options (sort with port field)
  # Expected: + Index page is displayed.
  #           + LDAP list is sorted.
  def test_it_t1_la_ldap_008
    create_ldap_settings(15)
    # TCANA admin login
    login_as TCANA_admin
    post :index, :page => 1, :order_field => "port", :order_direction => "ASC"
    assert_response :success
    assert_template "index"
    ldaps = @controller.instance_variable_get "@ldap_settings"
    assert_equal 10,ldaps.size
    assert true if ldaps[1].port > ldaps[2].port
    #
    post :index, :page => 1, :order_field => "port", :order_direction => "DESC"
    assert_response :success
    assert_template "index"
    ldaps = @controller.instance_variable_get "@ldap_settings"
    assert_equal 10,ldaps.size
    assert true if ldaps[1].port < ldaps[2].port
  end

  # Function: edit_ldap_setting
  #
  # Input:  + TCANA member(PU/PJ admin, PU/PJ member) logged in.
  #         + Request to call "edit_ldap_setting" function to view Edit LDAP administration page.
  # Expected: Has no right to edit LDAP setting.
  #
  def test_it_t1_la_ldap_009
    ldap = create_a_ldap
    # PU admin login
    login_as PU_admin
    post :edit_ldap_setting, :id => ldap.id
    assert_redirected_to :controller => "misc", :action => "index"
    # PJ admin login
    login_as PJ_admin
    post :edit_ldap_setting, :id => ldap.id
    assert_redirected_to :controller => "misc", :action => "index"
  end
  #
  # Input:  + TCANA admin logged in.
  #         + Request to call "edit_ldap_setting" function to view Edit LDAP administration page.
  # Expected: Edit LDAP setting page is displayed with the selected LDAP setting
  #
  def test_it_t1_la_ldap_010
    ldap = create_a_ldap
    # PU admin login
    login_as TCANA_admin
    post :edit_ldap_setting, :id => ldap.id
    assert_response :success
    assert_template "edit_ldap_setting"
    ldap_setting = @controller.instance_variable_get "@ldap_setting"
    assert_equal ldap,ldap_setting
  end

  # Function: delete_ldap_setting
  #
  # Input:  + TCANA member(PU/PJ admin, PU/PJ member) logged in.
  #         + Request to call "delete_ldap_setting" function to delete LDAP setting.
  # Expected: Has no right to delete LDAP setting.
  #
  def test_it_t1_la_ldap_011
    ldap = create_a_ldap
    # PU admin login
    login_as PU_admin
    post :delete_ldap_setting, :id => ldap.id
    assert_redirected_to :controller => "misc", :action => "index"
    # PJ admin login
    login_as PJ_admin
    post :delete_ldap_setting, :id => ldap.id
    assert_redirected_to :controller => "misc", :action => "index"
  end
  # Input:  + TCANA admin logged in.
  #         + Request to call "delete_ldap_setting" function to delete LDAP setting.
  # Expected: + LDAP setting is deleted.
  #           + Redirect back to Index page.
  def test_it_t1_la_ldap_012
    ldap = create_a_ldap
    # admin login
    login_as TCANA_admin
    post :delete_ldap_setting, :id => ldap.id
    assert_response :success
    assert_template "index"
  end
  # Input:  + TCANA admin logged in.
  #         + Request to call "delete_ldap_setting" function to delete LDAP setting.
  #         + Delete the last setting in the last page.
  # Expected: + LDAP setting is deleted.
  #           + Redirect back to Index page.
  #           + Page 1 is displayed.
  #
  def test_it_t1_la_ldap_013
    create_ldap_settings(21)
    last_ldap = LdapSetting.find(:last)
    # admin login
    login_as TCANA_admin
    post :delete_ldap_setting, :id => last_ldap.id, :page => 3
    assert_response :success
    assert_template "index"
    assert_equal 10,(@controller.instance_variable_get "@ldap_settings").size
    assert_equal 1,(@controller.instance_variable_get "@page").to_i
  end
  # Input:  + TCANA admin logged in.
  #         + Request to call "delete_ldap_setting" function to delete LDAP setting.
  #         + Delete the setting which is not existed.
  # Expected: + No LDAP setting is deleted.
  #
  def test_it_t1_la_ldap_014
    create_ldap_settings(21)
    out_side_id = 10000
    old_ldaps = LdapSetting.find(:all).size
    # admin login
    login_as TCANA_admin
    post :delete_ldap_setting, :id => out_side_id, :page => 3
    assert_response :success
    assert_template "index"
    assert_equal old_ldaps, LdapSetting.find(:all).size
  end
  # Input:  + TCANA admin logged in.
  #         + Request to call "delete_ldap_setting" function to delete LDAP setting.
  #         + Delete the setting which is being used by user.
  # Expected: + LDAP setting wont be deleted.
  #
  def test_it_t1_la_ldap_015
    ldap = create_a_ldap
    create_ldap_user(ldap.id)
    old_ldaps = LdapSetting.find(:all).size
    # admin login
    login_as TCANA_admin
    post :delete_ldap_setting, :id => ldap.id
    assert_response :success
    assert_template "index"
    assert_equal old_ldaps, LdapSetting.find(:all).size
  end

  # Function: new_ldap_setting
  #
  # Input:  + TCANA member(PU/PJ admin, PU/PJ member) logged in.
  #         + Request to call "new_ldap_setting" function to view Create LDAP administration page.
  # Expected: Has no right to create LDAP setting.
  #
  def test_it_t1_la_ldap_016
    # PU admin login
    login_as PU_admin
    post :new_ldap_setting
    assert_redirected_to :controller => "misc", :action => "index"
    # PJ admin login
    login_as PJ_admin
    post :new_ldap_setting
    assert_redirected_to :controller => "misc", :action => "index"
  end
  #
  # Input:  + TCANA admin logged in.
  #         + Request to call "new_ldap_setting" function to view Create LDAP administration page.
  # Expected: Create LDAP setting page is displayed with the selected LDAP setting
  #
  def test_it_t1_la_ldap_017
    # TCANA admin login
    login_as TCANA_admin
    post :new_ldap_setting
    assert_response :success
    assert_template "new_ldap_setting"
    ldap_setting = @controller.instance_variable_get "@ldap_setting"
    assert_equal nil,ldap_setting.id
  end

  # Function: test_ldap_connection
  #
  # Input:  + TCANA member(PU/PJ admin, PU/PJ member) logged in.
  #         + Request to call "test_ldap_connection" function.
  # Expected: Has no right to test LDAP connection.
  #
  def test_it_t1_la_ldap_018
    # PU admin login
    login_as PU_admin
    post :test_ldap_connection
    assert_redirected_to :controller => "misc", :action => "index"
    # PJ admin login
    login_as PJ_admin
    post :test_ldap_connection
    assert_redirected_to :controller => "misc", :action => "index"
  end
  #
  # Input:  + TCANA admin logged in.
  #         + Request to call "test_ldap_connection" function.
  # Expected: Ldap connection is connected successful.
  #
  def test_it_t1_la_ldap_019
    ldap = create_a_ldap
    # TCANA admin login
    login_as TCANA_admin
    post :test_ldap_connection, :id => ldap.id
    assert_response :success
  end
  #
  # Input:  + TCANA admin logged in.
  #         + Request to call "test_ldap_connection" function.
  # Expected: Ldap connection is failed to connect.
  #
  def test_it_t1_la_ldap_020
    ldap = create_a_ldap
    ldap.host = "wrong host"
    ldap.save
    # TCANA admin login
    login_as TCANA_admin
    post :test_ldap_connection, :id => ldap.id
    notice = session["flash"][:notice]
    assert true if notice.include?("Error")
  end

  # Function: clear_ldap_setting
  #
  # Input:  + TCANA member(PU/PJ admin, PU/PJ member) logged in.
  #         + Request to call "clear_ldap_setting" function.
  # Expected: Has no right to act clear_ldap_setting function.
  #
  def test_it_t1_la_ldap_021
    # PU admin login
    login_as PU_admin
    post :clear_ldap_setting
    assert_redirected_to :controller => "misc", :action => "index"
    # PJ admin login
    login_as PJ_admin
    post :clear_ldap_setting
    assert_redirected_to :controller => "misc", :action => "index"
  end
  #
  # Input:  + TCANA admin logged in.
  #         + Request to call "clear_ldap_setting" function.
  #         + Clear a nil ldap setting (clear in creating new LDAP)
  # Expected: return a new LDAP setting
  #
  def test_it_t1_la_ldap_022
    # TCANA admin login
    login_as TCANA_admin
    post :clear_ldap_setting
    assert_response :success
    assert_template "ldap_form"
    assert_equal nil,(@controller.instance_variable_get "@ldap_setting").id
  end
  #
  # Input:  + TCANA admin logged in.
  #         + Request to call "clear_ldap_setting" function.
  #         + Clear with a ldap setting id (clear in editing the LDAP)
  # Expected: return the selected LDAP information
  #
  def test_it_t1_la_ldap_023
    ldap = create_a_ldap
    # TCANA admin login
    login_as TCANA_admin
    post :clear_ldap_setting, :id => ldap.id
    assert_response :success
    assert_template "ldap_form"
    assert_equal ldap,(@controller.instance_variable_get "@ldap_setting")
  end

  # Function: save_ldap_setting_status
  #
  # Input:  + TCANA member(PU/PJ admin, PU/PJ member) logged in.
  #         + Request to call "save_ldap_setting_status" function.
  # Expected: Has no right to save  LDAP setting status.
  #
  def test_it_t1_la_ldap_024
    ldaps = LdapSetting.find_by_in_use(true)
    #
    if ldaps.blank?
      ldaps = create_a_ldap
      ldaps.in_use = true
      ldaps.save
    end
    #
    ldap = create_a_ldap
    # PU admin login
    login_as PU_admin
    post :save_ldap_setting_status, :in_use => ldap.id
    assert_redirected_to :controller => "misc", :action => "index"
    # PJ admin login
    login_as PJ_admin
    post :save_ldap_setting_status, :in_use => ldap.id
    assert_redirected_to :controller => "misc", :action => "index"
  end
  #
  # Input:  + TCANA admin logged in.
  #         + Request to call "save_ldap_setting_status" function.
  # Expected: LDAP setting status is successful updated.
  #
  def test_it_t1_la_ldap_025
    ldaps = LdapSetting.find_by_in_use(true)
    #
    if ldaps.blank?
      ldaps = create_a_ldap
      ldaps.in_use = true
      ldaps.save
    end
    #
    ldap = create_a_ldap
    # TCANA admin login
    login_as TCANA_admin
    post :save_ldap_setting_status, :in_use => ldap.id
    assert_response :success
    assert_equal false,LdapSetting.find_by_id(ldaps.id).in_use
  end
  #
  # Input:  + TCANA admin logged in.
  #         + Request to call "save_ldap_setting_status" function.
  #         + selected LDAP id is nil.
  # Expected: Nothing changes.
  #
  def test_it_t1_la_ldap_026
    ldaps = LdapSetting.find_by_in_use(true)
    #
    if ldaps.blank?
      ldaps = create_a_ldap
      ldaps.in_use = true
      ldaps.save
    end
    # TCANA admin login
    login_as TCANA_admin
    post :save_ldap_setting_status, :in_use => nil
    assert_response :success
    assert_equal true,LdapSetting.find_by_id(ldaps.id).in_use
  end
  #
  # Input:  + TCANA admin logged in.
  #         + Request to call "save_ldap_setting_status" function.
  #         + User is registered with old LDAP server.
  #         + Select a new LDAP setting to change status
  # Expected: + New LDAP setting is in used.
  #           + User who was registered with old LDAP setting are changed to new LDAP setting.
  #
  def test_it_t1_la_ldap_027
    ldaps = LdapSetting.find_by_in_use(true)
    #
    if ldaps.blank?
      ldaps = create_a_ldap
      ldaps.in_use = true
      ldaps.save
    end
    #
    ldap = create_a_ldap
    user = create_ldap_user(ldaps.id)
    # TCANA admin login
    login_as TCANA_admin
    post :save_ldap_setting_status, :in_use => ldap.id
    assert_response :success
    assert_equal false,LdapSetting.find_by_id(ldaps.id).in_use
    assert_equal User.find_by_id(user.id).ldap_setting_id, ldap.id
  end
  #
  # Input:  + TCANA admin logged in.
  #         + Request to call "save_ldap_setting_status" function.
  #         + User is registered with old LDAP server.
  #         + Select a nil LDAP setting to save.
  # Expected: + no LDAP setting is selected.
  #           + User who was registered with old LDAP setting  will has his/her password = his/her account name
  #
  def test_it_t1_la_ldap_028
    ldaps = LdapSetting.find_by_in_use(true)
    #
    if ldaps.blank?
      ldaps = create_a_ldap
      ldaps.in_use = true
      ldaps.save
    end
    #
    user = create_ldap_user(ldaps.id)
    # TCANA admin login
    login_as TCANA_admin
    post :save_ldap_setting_status, :in_use => 0
    assert_response :success
    assert LdapSetting.find_all_by_in_use(true).blank?
    assert_equal User.find_by_id(user.id).ldap_setting_id, nil
  end
  # Function: create_ldap_setting
  #
  # Input:  + TCANA member(PU/PJ admin, PU/PJ member) logged in.
  #         + Request to call "create_ldap_setting" function.
  # Expected: Has no right to save  LDAP setting.
  #
  def test_it_t1_la_ldap_029
    # PU admin login
    login_as PU_admin
    post :create_ldap_setting, 
      :ldap_setting => params(NAME,PORT,ACCOUNT,PASS,BASE_DN,"0",MAIL,"0",LOGIN,HOST)
    assert_redirected_to :controller => "misc", :action => "index"
    # PJ admin login
    login_as PJ_admin
    post :create_ldap_setting, 
      :ldap_setting => params(NAME,PORT,ACCOUNT,PASS,BASE_DN,"0",MAIL,"0",LOGIN,HOST)
    assert_redirected_to :controller => "misc", :action => "index"
  end
  #
  # Input:  + TCANA admin logged in.
  #         + All required information are inputted right.
  #         + Request to call "create_ldap_setting" function.
  # Expected: LDAP setting is saved.
  #
  def test_it_t1_la_ldap_030
    LdapSetting.delete_all()
    # TCANA admin login
    login_as TCANA_admin
    post :create_ldap_setting, 
      :ldap_setting => params(NAME,PORT,ACCOUNT,PASS,BASE_DN,"0",MAIL,"0",LOGIN,HOST)
    assert_not_equal 0,LdapSetting.find(:all).size
  end
  #
  # Input:  + TCANA admin logged in.
  #         + One of those required fields is not inputted right.
  #         + Request to call "create_ldap_setting" function.
  # Expected: LDAP setting is unable to save.
  #
  def test_it_t1_la_ldap_031
    LdapSetting.delete_all()
    # TCANA admin login
    login_as TCANA_admin
    post :create_ldap_setting, 
      :ldap_setting => params(NAME,"",ACCOUNT,PASS,BASE_DN,"0",MAIL,"0",LOGIN,HOST)
    assert_equal 0,LdapSetting.find(:all).size
  end
  # Function: update_ldap_setting
  #
  # Input:  + TCANA member(PU/PJ admin, PU/PJ member) logged in.
  #         + Request to call "update_ldap_setting" function.
  # Expected: Has no right to update  LDAP setting.
  #
  def test_it_t1_la_ldap_032
    ldap = create_a_ldap
    # PU admin login
    login_as PU_admin
    post :update_ldap_setting,
      :id => ldap.id,
      :ldap_setting => params(NAME,PORT,ACCOUNT,PASS,BASE_DN,"0",MAIL,"0",LOGIN,HOST)
    assert_redirected_to :controller => "misc", :action => "index"
    # PJ admin login
    login_as PJ_admin
    post :update_ldap_setting,
      :id => ldap.id,
      :ldap_setting => params(NAME,PORT,ACCOUNT,PASS,BASE_DN,"0",MAIL,"0",LOGIN,HOST)
    assert_redirected_to :controller => "misc", :action => "index"
  end
  #
  # Input:  + TCANA admin logged in.
  #         + All required information are inputted right.
  #         + Request to call "create_ldap_setting" function.
  # Expected: LDAP setting is saved.
  #
  def test_it_t1_la_ldap_033
    LdapSetting.delete_all()
    ldap = create_a_ldap
    # TCANA admin login
    login_as TCANA_admin
    post :update_ldap_setting,
      :id => ldap.id,
      :ldap_setting => params(NAME+"new",PORT,ACCOUNT,PASS,BASE_DN,"0",MAIL,"0",LOGIN,HOST)
    assert_not_equal ldap.name,LdapSetting.find_by_id(ldap.id).name
  end
  #
  # Input:  + TCANA admin logged in.
  #         + One of those required fields is not inputted right.
  #         + Request to call "create_ldap_setting" function.
  # Expected: LDAP setting is unable to save.
  #
  def test_it_t1_la_ldap_034
    LdapSetting.delete_all()
    ldap = create_a_ldap
    # TCANA admin login
    login_as TCANA_admin
    post :update_ldap_setting,
      :id => ldap.id,
      :ldap_setting => params(NAME,"",ACCOUNT,PASS,BASE_DN,"0",MAIL,"0",LOGIN,HOST)
    assert_equal ldap,LdapSetting.find_by_id(ldap.id)
  end
end