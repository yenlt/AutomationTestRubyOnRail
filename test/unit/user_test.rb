require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  # user item
  ACCOUNT = "angq"
  PASS = "angq"
  MAIL = "angq@tsdv.com.vn"
  # ldap setting item
  NAME = "ldap setting"
  HOST = "10.116.17.165"
  PORT = "10389"
  BASE_DN = "ou=users,ou=system"
  ATTR_LOGIN = "uid"

  TCANA_ADMIN_ID = 1
  PU_ADMIN_ID = 2
  PJ_ADMIN_ID = 3
  PJ_MEMBER_ID = 4
  PU_ID = 1
  PJ_ID = 1
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :users

  def notest_should_create_user
    assert_difference User, :count do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference User, :count do
      u = create_user(:account_name => nil)
      assert u.errors.on(:account_name)
    end
  end

  def test_should_require_password
    assert_no_difference User, :count do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def notest_should_require_password_confirmation
    assert_no_difference User, :count do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference User, :count do
      u = create_user(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def notest_should_reset_password
    users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:quentin), User.authenticate('quentin', 'new password')
  end

  def notest_should_not_rehash_password
    users(:quentin).update_attributes(:account_name => 'quentin2')
    assert_equal users(:quentin), User.authenticate('quentin2', 'test')
  end

  def notest_should_authenticate_user
    assert_equal users(:quentin), User.authenticate('quentin', 'test')
  end

  def notest_should_set_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
  end

  def notest_should_unset_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    users(:quentin).forget_me
    assert_nil users(:quentin).remember_token
  end

  ##
  # Test: validate_on_create (also test validate item)
  #
  # Input: Create user with an ununique account name
  # Output: Failed to create
  #
  def test_ut_t1_la_user_001
    create_normal_user(ACCOUNT,MAIL,PASS)
    new_user = User.new(:account_name => ACCOUNT,
                        :email        => "other_mail",
                        :password     => "password" ,
                        :password_confirmation     => "password" 
                      )
    assert !new_user.save
  end
  #
  # Input: + Create user without ldap setting id
  #        + password or password confirmation is blank
  # Output: Failed to create
  #
  def test_ut_t1_la_user_002
    User.delete_all()
    new_user = User.new(:account_name => ACCOUNT,
                        :ldap_setting_id  => nil,
                        :password => nil,
                        :password_confirmation  => nil)
    assert !new_user.save
  end
  #
  # Input: + Create user without ldap setting id
  #        + password or password confirmation is not length enough
  # Output: Failed to create
  #
  def test_ut_t1_la_user_003
    User.delete_all()
    new_user = User.new(:account_name => ACCOUNT,
                        :ldap_setting_id  => nil,
                        :password => "abc",
                        :password_confirmation  => "abc")
    assert !new_user.save
  end
  #
  # Input: + Create user without ldap setting id
  #        + password or password confirmation length is larger than 10
  # Output: Failed to create
  #
  def test_ut_t1_la_user_004
    User.delete_all()
    new_user = User.new(:account_name => ACCOUNT,
                        :ldap_setting_id  => nil,
                        :password => "longer than 10 char",
                        :password_confirmation  => "longer than 10 char")
    assert !new_user.save
  end
  #
  # Input: + Create user without ldap setting id
  #        + password or password confirmation are not matched
  # Output: Failed to create
  #
  def test_ut_t1_la_user_005
    User.delete_all()
    new_user = User.new(:account_name => ACCOUNT,
                        :ldap_setting_id  => nil,
                        :password => "password",
                        :password_confirmation  => "not matched")
    assert !new_user.save
  end
  #
  # Input: + Create user with ldap setting
  #        + Ldap attr mail is blank
  # Output: Failed to create
  #
  def test_ut_t1_la_user_006
    ldap_setting = create_ldap_without_mail
    new_user = User.new(:account_name => ACCOUNT,
                        :ldap_setting_id  => ldap_setting.id)
    assert !new_user.save
  end
  #
  # Input: + Create user with ldap setting
  #        + Ldap attr mail is mapped
  # Output: user created successful
  #
  def test_ut_t1_la_user_007
    User.delete_all(["account_name = ?", ACCOUNT])
    ldap_setting = create_ldap_with_mail
    new_user = User.new(:account_name => ACCOUNT,
                        :ldap_setting_id  => ldap_setting.id)
    assert new_user.save
  end

  ##
  # Test: validate_on_update (also test validate_item)
  # 
  # Input: + Update user
  #        + his/her new account name has no same account name
  # Output: user is successful updated.
  #
  def test_ut_t1_la_user_008
    User.delete_all()
    user = create_normal_user(ACCOUNT,MAIL,PASS)    
    assert user.update_attributes(:account_name => "new name")
  end
  #
  # Input: + Update user
  #        + his/her new account name was the only one
  # Output: user is successful updated.
  #
  def test_ut_t1_la_user_009
    User.delete_all()
    user = create_normal_user(ACCOUNT,MAIL,PASS)
    assert user.update_attributes(:account_name => ACCOUNT)
  end
  #
  # Input: + Update user
  #        + his/her new account name has the same with the existed user.
  # Output: user is failed to update.
  #
  def test_ut_t1_la_user_010
    User.delete_all()
    create_normal_user(ACCOUNT,MAIL,PASS)
    user = create_normal_user("ACCOUNT",MAIL,PASS)
    assert !user.update_attributes(:account_name => ACCOUNT)
  end
  #
  # Input: + Update user
  #        + password is not inputter but password confirmation is inputted.
  # Output: user is failed to update.
  #
  def test_ut_t1_la_user_011 # bug
    User.delete_all()
    user = create_normal_user(ACCOUNT,MAIL,PASS)
    assert !user.update_attributes(:password  => "",
                                   :password_confirmation => PASS)
  end
  #
  # Input: + Update user
  #        + password and password confirmation are not matched
  # Output: user id failed to update.
  #
  def test_ut_t1_la_user_012
    User.delete_all()
    user = create_normal_user(ACCOUNT,MAIL,PASS)
    assert !user.update_attributes(:password  => "new pass",
                                   :password_confirmation => "no matched passs")
  end
  #
  # Input: + Update user with ldap setting id
  #        + attr mail is not mapped.
  #        + user email is not inputted.
  # Output: user id failed to update.
  #
  def test_ut_t1_la_user_013
    User.delete_all()
    user = create_normal_user(ACCOUNT,MAIL,PASS)
    ldap_setting = create_ldap_without_mail
    assert !user.update_attributes(:ldap_setting_id => ldap_setting.id,
                                  :email  => "")
  end
  #
  # Input: + Update user with ldap setting id
  #        + attr mail is mapped.
  # Output: user is successful updated.
  #
  def test_ut_t1_la_user_014
    User.delete_all()
    user = create_normal_user(ACCOUNT,MAIL,PASS)
    ldap_setting = create_ldap_with_mail
    assert user.update_attributes(:ldap_setting_id => ldap_setting.id)
  end
  ##
  # Test: authenticate()
  #
  # Input: authenticate user who is existed in users table and ldap setting is not set.
  # Output: normal authenticate user (pass)
  #
  def test_ut_t1_la_user_015
    User.delete_all()
    LdapSetting.delete_all()
    create_normal_user(ACCOUNT,MAIL,PASS)
    assert User.authenticate(ACCOUNT,PASS)
  end
  #
  # Input: authenticate user who is existed in users table and ldap setting is not set.
  # Output: normal authenticate user (failed)
  #
  def test_ut_t1_la_user_016
    User.delete_all()
    LdapSetting.delete_all()
    create_normal_user(ACCOUNT,MAIL,PASS)
    assert !User.authenticate(ACCOUNT,"wrong pass")
  end
  #
  # Input: authenticate user who is existed in users table and ldap setting is registered.
  # Output: Authenticate user with LDAP (pass)
  #
  def test_ut_t1_la_user_017
    User.delete_all()
    LdapSetting.delete_all()
    ldap_setting = create_ldap_with_mail
    create_ldap_user(ACCOUNT,MAIL,ldap_setting.id)
    assert User.authenticate(ACCOUNT,PASS)
  end
  #
  # Input: authenticate user who is existed in users table and ldap setting is registered.
  # Output: Authenticate user with LDAP (failed)
  #
  def test_ut_t1_la_user_018
    User.delete_all()
    LdapSetting.delete_all()
    ldap_setting = create_ldap_with_mail
    create_ldap_user(ACCOUNT,MAIL,ldap_setting.id)
    assert !User.authenticate(ACCOUNT,"wrong pass")
  end
  #
  # Input:  + Authenticate user who is not existed in users table but in LDAP server.
  #         + Ldap setting is registered and being used
  #         + Input right password
  # Output: On the fly user creation (succeess)
  #
  def test_ut_t1_la_user_019
    User.delete_all()
    LdapSetting.delete_all()
    create_ldap_with_mail
    assert User.authenticate(ACCOUNT,PASS)
  end
  #
  # Input:  + Authenticate user who is not existed in users table but in LDAP server.
  #         + Ldap setting is registered and being used
  #         + Password inputted is wrong.
  # Output: On the fly user creation (failed)
  #
  def test_ut_t1_la_user_020
    User.delete_all()
    LdapSetting.delete_all()
    create_ldap_with_mail
    assert !User.authenticate(ACCOUNT,"PASS")
  end
  #
  # Input:  + Authenticate user who is not existed in users table.
  #         + Ldap setting is registered and being used
  #         + User can not be found from LDAP server also
  # Output: Return false
  #
  def test_ut_t1_la_user_021
    User.delete_all()
    LdapSetting.delete_all()
    create_ldap_with_mail
    assert !User.authenticate("ACCOUNT","PASS")
  end
  #
  # Input:  + Authenticate user who is not existed in users table.
  #         + Ldap setting is registered but no being used.
  #         + User is existed in LDAP server.
  # Output: Return false
  #
  def test_ut_t1_la_user_022
    User.delete_all()
    LdapSetting.delete_all()
    ldap_setting = create_ldap_with_mail
    ldap_setting.in_use = false
    ldap_setting.save
    assert !User.authenticate(ACCOUNT,PASS)
  end

  ##
  # Test: on_the_fly_user_creation()
  #
  # Input: + account name, ldap_setting_id and mail are correct.
  # Output: User is created successful.
  #
  def test_ut_t1_la_user_023
    User.delete_all(["account_name = ?", ACCOUNT])
    user = User.new()
    assert user.on_the_fly_user_creation(ACCOUNT,1,MAIL)
  end
  #
  # Input: one of these inputter value is lack.
  # Output: user is failed to create.
  #
  def test_ut_t1_la_user_024
    user = User.new()
    assert !user.on_the_fly_user_creation(ACCOUNT,1,"")
  end

  ############################################################################
  # Test PJ Model in [Email Notification Function]                           #

  ##
  # Test: viewable?
  #
  # Input: + TCANA admin login
  #        + Request to view himselft
  # Output:  Return TRUE
  #
  def test_ut_t5_sef_user_01
    user = User.find(TCANA_ADMIN_ID)
    assert user.viewable?(user,PJ_ID)
  end
  # Input: + PU admin login
  #        + Request to view himselft
  # Output:  Return TRUE
  #
  def test_ut_t5_sef_user_02
    user = User.find(PU_ADMIN_ID)
    assert user.viewable?(user,PJ_ID)
  end
  # Input: + PJ admin login
  #        + Request to view himselft
  # Output:  Return TRUE
  #
  def test_ut_t5_sef_user_03
    user = User.find(PJ_ADMIN_ID)
    assert user.viewable?(user,PJ_ID)
  end
  # Input: + TCANA admin login
  #        + Request to view TCANA admin
  #        + Request to view PU admin
  #        + Request to view PJ admin
  #        + Request to view PJ member
  # Output:  Both cases return TRUE
  #
  def test_ut_t5_sef_user_04
    tcana_admin = User.find(TCANA_ADMIN_ID)
    pu_admin    = User.find(PU_ADMIN_ID)
    pj_admin    = User.find(PJ_ADMIN_ID)
    pj_member   = User.find(PJ_MEMBER_ID)
    assert tcana_admin.viewable?(tcana_admin,PJ_ID)
    assert tcana_admin.viewable?(pu_admin,PJ_ID)
    assert tcana_admin.viewable?(pj_admin,PJ_ID)
    assert tcana_admin.viewable?(pj_member,PJ_ID)
  end
  # Input: + PU admin login
  #        + Request to view TCANA admin
  #        + Request to view PU admin
  #        + Request to view PJ admin
  #        + Request to view PJ member
  # Output: Return FALSE when request to view TCANA admin
  #
  def test_ut_t5_sef_user_05
    tcana_admin = User.find(TCANA_ADMIN_ID)
    pu_admin    = User.find(PU_ADMIN_ID)
    pj_admin    = User.find(PJ_ADMIN_ID)
    pj_member   = User.find(PJ_MEMBER_ID)
    assert !pu_admin.viewable?(tcana_admin,PJ_ID)
    assert pu_admin.viewable?(pu_admin,PJ_ID)
    assert pu_admin.viewable?(pj_admin,PJ_ID)
    assert pu_admin.viewable?(pj_member,PJ_ID)
  end
  # Input: + PJ admin login
  #        + Request to view TCANA admin
  #        + Request to view PU admin
  #        + Request to view PJ admin
  #        + Request to view PJ member
  # Output:  Return FALSE when request to view TCANA/PU admin
  #
  def test_ut_t5_sef_user_06
    tcana_admin = User.find(TCANA_ADMIN_ID)
    pu_admin    = User.find(PU_ADMIN_ID)
    pj_admin    = User.find(PJ_ADMIN_ID)
    pj_member   = User.find(PJ_MEMBER_ID)
    assert !pj_admin.viewable?(tcana_admin,PJ_ID)
    assert !pj_admin.viewable?(pu_admin,PJ_ID)
    assert pj_admin.viewable?(pj_admin,PJ_ID)
    assert pj_admin.viewable?(pj_member,PJ_ID)
  end
  # Input: + PJ member login
  # Output:  Return FALSE
  #
  def test_ut_t5_sef_user_07
    tcana_admin = User.find(TCANA_ADMIN_ID)
    pu_admin    = User.find(PU_ADMIN_ID)
    pj_admin    = User.find(PJ_ADMIN_ID)
    pj_member   = User.find(PJ_MEMBER_ID)
    assert !pj_member.viewable?(tcana_admin,PJ_ID)
    assert !pj_member.viewable?(pu_admin,PJ_ID)
    assert !pj_member.viewable?(pj_admin,PJ_ID)
  end
  ############################################################################
  protected
    # create normal user
    def create_normal_user(name,mail,password)
      user = User.create(:account_name => name,
                  :email        => mail,
                  :password     => password,
                  :password_confirmation  => password)
      return user
    end
    # create a ldap user
    def create_ldap_user(name,mail,ldap_id)
      user = User.create( :account_name  =>   name,
                          :email        => mail,
                          :ldap_setting_id  => ldap_id)
      return user
    end
    # Create a ldap setting
    def create_ldap_with_mail
      ldap_setting = LdapSetting.create(:name   => NAME,
                                        :host   => HOST,
                                        :port   => PORT,
                                        :base_dn    => BASE_DN,
                                        :attr_login => ATTR_LOGIN,
                                        :on_the_fly_user_creation => true,
                                        :attr_mail  => "mail",
                                        :in_use     => true)
      return ldap_setting
    end
    # Create a ldap setting
    def create_ldap_without_mail
      ldap_setting = LdapSetting.create(:name   => NAME,
                                        :host   => HOST,
                                        :port   => PORT,
                                        :base_dn    => BASE_DN,
                                        :attr_login => ATTR_LOGIN,
                                        :in_use     => true)
      return ldap_setting
    end
    #
    def create_user(options = {})
      User.create({ :account_name => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    end
end
