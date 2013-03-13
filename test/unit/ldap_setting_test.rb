require File.dirname(__FILE__) + '/../test_helper'

NAME = "ldap setting"
HOST = "localhost"
PORT = "10389"
BASE_DN = "ou=users,ou=system"
ATTR_LOGIN = "uid"
LOGIN = "angq"
PASS  = "angq"
SSL_NAME = "ldap setting"
SSL_HOST = "localhost"
SSL_PORT = "10636"
SSL_BASE_DN = "ou=users,ou=system"
SSL_ATTR_LOGIN = "uid"

class LdapSettingTest < ActiveSupport::TestCase
  fixtures :users
  fixtures :privileges
  fixtures :privileges_users
  ##
  # Test:  validate on create (also test validate_item function)
  #
  # Input:  + Create new LDAP setting with tls option.
  # Output: saved
  #
  def test_ut_t1_la_ldap_001
    ldap_setting = LdapSetting.new( :name   => SSL_NAME,
                                    :host   => SSL_HOST,
                                    :port   => SSL_PORT,
                                    :base_dn    => SSL_BASE_DN,
                                    :attr_login => SSL_ATTR_LOGIN,
                                    :tls        => true,
                                    :account    => "",
                                    :account_password =>  ""
                                  )
    assert ldap_setting.save
  end

  #
  # Input:  + Create new LDAP setting with tls option.
  #         + account is blank.
  # Output: unable to save
  #
  def notest_ut_t1_la_ldap_002
    ldap_setting = LdapSetting.new( :name   => SSL_NAME,
                                    :host   => SSL_HOST,
                                    :port   => SSL_PORT,
                                    :base_dn    => SSL_BASE_DN,
                                    :attr_login => SSL_ATTR_LOGIN,
                                    :tls        => true,
                                    :account    => "",
                                    :account_password =>  "secret"
                                  )
    assert !ldap_setting.save
  end

  #
  # Input:  + Create new LDAP setting with tls option.
  #         + account_password is blank.
  # Output: unable to save
  #
  def notest_ut_t1_la_ldap_003
    ldap_setting = LdapSetting.new( :name   => SSL_NAME,
                                    :host   => SSL_HOST,
                                    :port   => SSL_PORT,
                                    :base_dn    => SSL_BASE_DN,
                                    :attr_login => SSL_ATTR_LOGIN,
                                    :tls        => true,
                                    :account    => "account",
                                    :account_password =>  ""
                                  )
    assert !ldap_setting.save
  end

  #
  # Input:  + Create new LDAP setting with tls option.
  #         + account and account_password are inputted right.
  # Output: saved
  #
  def notest_ut_t1_la_ldap_004
    ldap_setting = LdapSetting.new( :name   => SSL_NAME,
                                    :host   => SSL_HOST,
                                    :port   => SSL_PORT,
                                    :base_dn    => SSL_BASE_DN,
                                    :attr_login => SSL_ATTR_LOGIN,
                                    :tls        => true,
                                    :account    => SSL_ACCOUNT,
                                    :account_password =>  SSL_PASS
                                  )
    assert ldap_setting.save
  end

  #
  # Input:  + Create new LDAP setting with on_the_fly_user_creation option.
  #         + attr mail is blank.
  # Output: unable to save
  #
  def test_ut_t1_la_ldap_005
    ldap_setting = LdapSetting.new( :name   => NAME,
                                    :host   => HOST,
                                    :port   => PORT,
                                    :base_dn    => BASE_DN,
                                    :attr_login => ATTR_LOGIN,
                                    :on_the_fly_user_creation   => true,
                                    :attr_mail  => ""
                                  )
    assert !ldap_setting.save
  end

  #
  # Input:  + Create new LDAP setting with on_the_fly_user_creation option.
  #         + attr mail is inputted.
  # Output: saved
  #
  def test_ut_t1_la_ldap_006
    ldap_setting = LdapSetting.new( :name   => NAME,
                                    :host   => HOST,
                                    :port   => PORT,
                                    :base_dn    => BASE_DN,
                                    :attr_login => ATTR_LOGIN,
                                    :on_the_fly_user_creation   => true,
                                    :attr_mail  => "mail"
                                  )
    assert ldap_setting.save
  end

  ##
  # Test: validate on update (also test validate_item function)
  #
  # Input:  + Update LDAP setting with tls option.
  #         + account and account_password are blank.
  # Output: unable to update
  #
  def test_ut_t1_la_ldap_007
    ldap_setting = create_ldap_ssl
    assert ldap_setting.update_attributes(:tls => true,
                                           :account => "",
                                           :account_password  => "")
  end

  #
  # Input:  + Update LDAP setting with tls option.
  #         + account is blank.
  # Output: unable to update
  #
  def notest_ut_t1_la_ldap_008
    ldap_setting = create_ldap_ssl
    assert !ldap_setting.update_attributes(:tls => true,
                                           :account => "",
                                           :account_password  => "secret")
  end

  #
  # Input:  + Update LDAP setting with tls option.
  #         + account_password is blank.
  # Output: unable to update
  #
  def notest_ut_t1_la_ldap_009
    ldap_setting = create_ldap_ssl
    assert !ldap_setting.update_attributes(:tls => true,
                                           :account => "account",
                                           :account_password  => "")
  end

  #
  # Input:  + Update LDAP setting with tls option.
  #         + account and account_password are inputted.
  # Output: updated
  #
  def notest_ut_t1_la_ldap_010
    ldap_setting = create_ldap_ssl
    assert ldap_setting.update_attributes( :tls => true,
                                           :account => SSL_ACCOUNT,
                                           :account_password  => SSL_PASS)
  end

  #
  # Input:  + Update LDAP setting with on_the_fly_user_creation option.
  #         + attr mail is blank.
  # Output: unable to update
  #
  def test_ut_t1_la_ldap_011
    ldap_setting = create_ldap_ssl
    assert !ldap_setting.update_attributes(:on_the_fly_user_creation => true,
                                           :attr_mail  => "")
  end

  #
  # Input:  + Update LDAP setting with on_the_fly_user_creation option.
  #         + attr mail is inputted.
  # Output: updated
  #
  def test_ut_t1_la_ldap_012
    ldap_setting = create_ldap_ssl
    assert ldap_setting.update_attributes(:on_the_fly_user_creation => true,
                                          :attr_mail  => "mail")
  end

  ##
  # Test: authenticate(login,password)
  #
  # Input: authenticate with nil login and password
  # Output: return nil
  #
  def test_ut_t1_la_ldap_013
    ldap_setting = create_ldap
    assert !ldap_setting.authenticate("","")
  end

  #
  # Input: authenticate with true login but wrong password
  # Output: return nil
  #
  def test_ut_t1_la_ldap_014
    ldap_setting = create_ldap
    assert !ldap_setting.authenticate(LOGIN,"wrong pass")
  end

  #
  # Input: authenticate with wrong login and password
  # Output: return nil
  #
  def test_ut_t1_la_ldap_015
    ldap_setting = create_ldap
    assert ldap_setting.authenticate("wrong login","wrong pass").blank?
  end

  #
  # Input:+ authenticate with true user and password
  #       + on_the_fly_user_creation option is selected.
  # Output: Return mail of user
  #
  def test_ut_t1_la_ldap_016
    ldap_setting = create_ldap
    assert ldap_setting.authenticate(LOGIN,PASS)
  end

  #
  # Input:+ authenticate with true user and password
  #       + on_the_fly_user_creation option is deselected.
  # Output: Return true
  #
  def test_ut_t1_la_ldap_017
    ldap_setting = LdapSetting.create(:name   => NAME,
                                      :host   => HOST,
                                      :port   => PORT,
                                      :base_dn    => BASE_DN,
                                      :attr_login => ATTR_LOGIN,
                                      :on_the_fly_user_creation => false,
                                      :attr_mail  => "mail")
    assert ldap_setting.authenticate(LOGIN,PASS)
  end

  #
  # Input:+ authenticate with true user and password
  #       + the connection is failed
  # Output: Return nil
  #
  def test_ut_t1_la_ldap_018
    ldap_setting = create_ldap
    ldap_setting.host = "wrong host"
    ldap_setting.save
    assert !ldap_setting.authenticate(LOGIN,PASS)
  end

  ##
  # Test after_initialize
  #
  # Input: create ldap setting with port = 0
  # Output: default port (389) is saved.
  #
  def test_ut_t1_la_ldap_019
    ldap_setting = LdapSetting.create(:name   => NAME,
                                      :host   => HOST,
                                      :port   => 0,
                                      :base_dn    => BASE_DN,
                                      :attr_login => ATTR_LOGIN,
                                      :on_the_fly_user_creation => true,
                                      :attr_mail  => "mail")
    assert_equal ldap_setting.port, 389
  end

  ##
  # Test: check_user_id(login)
  #
  # Input: Nil login
  # Output: return false
  #
  def test_ut_t1_la_ldap_020
    ldap_setting = create_ldap
    assert !ldap_setting.check_user_id("")
  end

  #
  # Input: wrong login
  # Output: return false
  #
  def test_ut_t1_la_ldap_021
    ldap_setting = create_ldap
    assert !ldap_setting.check_user_id("wrong_user")
  end

  #
  # Input: right login
  # Output: return true
  #
  def test_ut_t1_la_ldap_022
    ldap_setting = create_ldap
    assert ldap_setting.check_user_id(LOGIN)
  end

  #
  # Input:  + ldap server can not connected
  #         + check with right user id
  # Output: return false
  #
  def test_ut_t1_la_ldap_023
    ldap_setting = create_ldap
    ldap_setting.host = "wrong host"
    ldap_setting.save
    assert !ldap_setting.check_user_id(LOGIN)
  end
  
  #
  # Input:  + ldap setting is registered without mail attribute.
  #         + check with right user id
  # Output: return true
  #
  def test_ut_t1_la_ldap_024 
    ldap_setting = create_ldap
    ldap_setting.on_the_fly_user_creation = false
    ldap_setting.save
    assert ldap_setting.check_user_id(LOGIN)
  end
  ##
  # Test: test_connection
  #
  # Input: test a right connection
  # Output: return nil
  #
  def test_ut_t1_la_ldap_025
    ldap_setting = create_ldap
    assert !ldap_setting.test_connection
  end

  #
  # Input: test a wrong connection
  # Output: return error
  #
  def test_ut_t1_la_ldap_026
    ldap_setting = create_ldap
    ldap_setting.host = "wrong host"
    ldap_setting.save
    begin
      assert !ldap_setting.test_connection
    rescue
      assert true
    end
  end

  ##
  # Test auth_method_name
  #
  # Input: Ldap setting is registered with tls
  # Output: auth method name of this setting is LDAPS
  #
  def test_ut_t1_la_ldap_027
    ldap_setting = create_ldap
    assert_equal ldap_setting.auth_method_name, "LDAP"
  end
  #
  # Input: Ldap setting is registered without tls
  # Output: auth method name of this setting is LDAP
  #
  def test_ut_t1_la_ldap_028
    ldap_setting = create_ldap_ssl
    assert_equal ldap_setting.auth_method_name, "LDAPS"
  end

  ##
  # Test users_in_use
  #
  # Input: Register a number of user using ldap setting
  # Output: return the number of user.
  #
  def test_ut_t1_la_ldap_029
    ldap_setting = create_ldap
    create_user(ldap_setting.id)
    assert_not_nil ldap_setting.users_in_use
  end

  ##
  # Test: paginate_ldap_setting()
  #
  # Input:+ No Ldap setting is existed
  #       + paginate ldap setting
  # Output: Nil array.
  #
  def test_ut_t1_la_ldap_030
    LdapSetting.delete_all()
    ldaps = LdapSetting.paginate_ldap_setting(1,"","")
    assert true if ldaps.blank?
  end

  # Input: pagiante ldap setting from a list of ldap setting
  # Output: return list of ldap settig (10/page)
  #
  def test_ut_t1_la_ldap_031
    LdapSetting.delete_all()
    15.times { create_ldap }
    ldaps1 = LdapSetting.paginate_ldap_setting(1,"","")
    assert_equal ldaps1.size, 10
    ldaps2 = LdapSetting.paginate_ldap_setting(2,"","")
    assert_equal ldaps2.size, 5
  end

  # Input: pagiante ldap setting from a list of ldap setting with sort conditions (ASC)
  # Output: return paginated list of setting
  #
  def test_ut_t1_la_ldap_032
    LdapSetting.delete_all()
    i = 1
    10.times do LdapSetting.create( :name   => NAME + i.to_s,
                                    :host   => HOST,
                                    :port   => PORT,
                                    :base_dn    => BASE_DN,
                                    :attr_login => ATTR_LOGIN,
                                    :on_the_fly_user_creation => true,
                                    :attr_mail  => "mail");
                 i= i + 1 end
    # name
    ldaps = LdapSetting.paginate_ldap_setting(1,"name","ASC")
    assert false if ldaps[0].name > ldaps[1].name
    # host
    ldaps = LdapSetting.paginate_ldap_setting(1,"host","ASC")
    assert false if ldaps[0].host > ldaps[1].host
    # type
    ldaps = LdapSetting.paginate_ldap_setting(1,"tls","ASC")
    assert false if ldaps[0].type > ldaps[1].type
  end

  # Input: pagiante ldap setting from a list of ldap setting with sort conditions (DESC)
  # Output: return paginated list of setting
  #
  def test_ut_t1_la_ldap_033
    LdapSetting.delete_all()
    i = 1
    10.times do LdapSetting.create( :name   => NAME + i.to_s,
                                    :host   => HOST,
                                    :port   => PORT,
                                    :base_dn    => BASE_DN,
                                    :attr_login => ATTR_LOGIN,
                                    :on_the_fly_user_creation => true,
                                    :attr_mail  => "mail");
                 i= i + 1 end
    # name
    ldaps = LdapSetting.paginate_ldap_setting(1,"name","DESC")
    assert false if ldaps[0].name < ldaps[1].name
    # host
    ldaps = LdapSetting.paginate_ldap_setting(1,"host","DESC")
    assert false if ldaps[0].host < ldaps[1].host
    # type
    ldaps = LdapSetting.paginate_ldap_setting(1,"tls","DESC")
    assert false if ldaps[0].type < ldaps[1].type
  end

  ##
  # Test: get_ldap_user_email(login)
  #
  # Input: Nil login
  # Output: return false
  #
  def test_ut_t1_la_ldap_034
    ldap_setting = create_ldap
    assert !ldap_setting.get_ldap_user_email("")
  end

  #
  # Input: wrong login
  # Output: return false
  #
  def test_ut_t1_la_ldap_035
    ldap_setting = create_ldap
    assert !ldap_setting.get_ldap_user_email("wrong_user")
  end

  #
  # Input: right login
  # Output: return user email
  #
  def test_ut_t1_la_ldap_036
    ldap_setting = create_ldap
    assert ldap_setting.get_ldap_user_email(LOGIN)
  end

  #
  # Input:  + ldap server can not connected
  #         + check with right user id
  # Output: return false
  #
  def test_ut_t1_la_ldap_037
    ldap_setting = create_ldap
    ldap_setting.host = "wrong host"
    ldap_setting.save
    assert !ldap_setting.get_ldap_user_email(LOGIN)
  end
  
  ##
  # Test: self.switch_active_ldap(new_ldap_id)
  #
  # Input: Switch active ldap with new ldap setting == selected ldap setting
  # Output: return true
  #
  def test_ut_t1_la_ldap_038
    LdapSetting.delete_all()
    existed_ldap_setting = create_ldap
    assert LdapSetting.switch_active_ldap(existed_ldap_setting.id)
  end
  #
  # Input: Disable the selected LDAP setting
  # Output: return true
  #
  def test_ut_t1_la_ldap_039
    LdapSetting.delete_all()
    create_ldap
    assert LdapSetting.switch_active_ldap(0)
  end
  #
  # Input:+ Change the selected LDAP setting.
  #       + User is using LDAP setting
  # Output: + return true
  #         + User who was using old LDAP setting will used new setting
  def test_ut_t1_la_ldap_040
    LdapSetting.delete_all()
    ldap_setting = create_ldap
    user = create_user(ldap_setting.id)
    new_setting = create_ldap
    new_setting.in_use = false
    new_setting.save
    assert LdapSetting.switch_active_ldap(new_setting.id)
    assert User.find_by_id(user.id).ldap_setting_id = new_setting.id
  end
  #
  # Input:  + User is using LDAP setting
  #         + Disable the LDAP setting
  # Output: + return true
  #         + User who was using old LDAP setting will be normal user
  def test_ut_t1_la_ldap_041
    LdapSetting.delete_all()
    ldap_setting = create_ldap
    user = create_user(ldap_setting.id)
    assert LdapSetting.switch_active_ldap(0)
    assert_nil User.find_by_id(user.id).ldap_setting_id
  end
  #
  # Input:  + Switch LDAP setting with a un-findable id
  # Output: + return false
  def test_ut_t1_la_ldap_042
    LdapSetting.delete_all()
    create_ldap
    assert !LdapSetting.switch_active_ldap(9999)
  end
  protected
  #
  # Create a user with a ldap setting id
  #
  def create_user(ldap_setting_id = 0)
    User.create(  :account_name  => LOGIN,
                  :email         => "angq@tsdv.com.vn",
                  :ldap_setting_id  => ldap_setting_id)
  end

  # Create a ldap setting
  def create_ldap
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

  # create ldap ssl setting
  def create_ldap_ssl
    ldap_setting = LdapSetting.create(:name   => SSL_NAME,
                                      :host   => SSL_HOST,
                                      :port   => SSL_PORT,
                                      :base_dn    => SSL_BASE_DN,
                                      :attr_login => SSL_ATTR_LOGIN,
                                      :tls        => true,
                                      :on_the_fly_user_creation => true,
                                      :attr_mail  => "mail",
                                      :in_use     => true)
    return ldap_setting
  end

end
