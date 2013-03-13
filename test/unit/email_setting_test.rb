require File.dirname(__FILE__) + '/../test_helper'

class EmailSettingTest < ActiveSupport::TestCase
  fixtures :tasks
  TCANA_ADMIN_ID = 1
  PU_ADMIN_ID = 2
  PJ_ADMIN_ID = 3
  PJ_MEMBER_ID = 4
  PJ_ID = 1
  TASK_ID = 5
  SUBTASK_ID = 10
  OLD_STATE_ID = 1
  NEW_STATE_ID = 2
  WRONG_ID = 1000
  ############################################################################
  # Test EmailSetting Model in [Email Notification Function]                 #

  ##
  # Test: add_email_users(list_user,pj_id,current_user)
  #
  # Input:  + List of user is empty
  # Return: + Nothing happens
  #
  def test_ut_t5_sef_est_001
    current_user = User.find(TCANA_ADMIN_ID)
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID})
    email_setting.add_email_users("",PJ_ID,current_user)
    new_email_setting = EmailSetting.find(email_setting.id)
    assert_equal email_setting.user_ids, new_email_setting.user_ids
  end
  # Input:  + TCANA admin is added.
  #         + TCANA admin id is existed in List user.
  # Return: + TCANA admin id is unique.
  #
  def test_ut_t5_sef_est_002
    current_user = User.find(TCANA_ADMIN_ID)
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID})
    email_setting.add_email_users(["1"],PJ_ID,current_user)
    new_email_setting = EmailSetting.find(email_setting.id)
    assert_equal email_setting.user_ids, new_email_setting.user_ids
  end
  # Input:  + current_user = TCANA admin
  #         + TCANA admin, PU admin, PJ admin, PJ member id is existed in List user.
  # Return: + All selected user id is added.
  #
  def test_ut_t5_sef_est_003
    current_user = User.find(TCANA_ADMIN_ID)
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID})
    list_user = ["#{TCANA_ADMIN_ID}","#{PU_ADMIN_ID}","#{PJ_ADMIN_ID}","#{PJ_MEMBER_ID}"]
    email_setting.add_email_users(list_user,PJ_ID,current_user)
    new_email_setting = EmailSetting.find(email_setting.id)
    assert new_email_setting.user_ids.include?("#{TCANA_ADMIN_ID}")
    assert new_email_setting.user_ids.include?("#{PU_ADMIN_ID}")
    assert new_email_setting.user_ids.include?("#{PJ_ADMIN_ID}")
    assert new_email_setting.user_ids.include?("#{PJ_MEMBER_ID}")
  end  
  # Input:  + current_user = PU admin
  #         + TCANA admin, PU admin, PJ admin, PJ member id is existed in List user.
  # Return: + All selected user id is added, except TCANA admin.
  #
  def test_ut_t5_sef_est_004
    current_user = User.find(PU_ADMIN_ID)
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID})
    email_setting.user_ids = ""
    email_setting.save
    list_user = ["#{TCANA_ADMIN_ID}","#{PU_ADMIN_ID}","#{PJ_ADMIN_ID}","#{PJ_MEMBER_ID}"]
    email_setting.add_email_users(list_user,PJ_ID,current_user)
    new_email_setting = EmailSetting.find(email_setting.id)
    assert !new_email_setting.user_ids.include?("#{TCANA_ADMIN_ID}")
    assert new_email_setting.user_ids.include?("#{PU_ADMIN_ID}")
    assert new_email_setting.user_ids.include?("#{PJ_ADMIN_ID}")
    assert new_email_setting.user_ids.include?("#{PJ_MEMBER_ID}")
  end
  # Input:  + current_user = PJ admin
  #         + TCANA admin, PU admin, PJ admin, PJ member id is existed in List user.
  # Return: + All selected user id is added, except TCANA admin, PU admin
  #
  def test_ut_t5_sef_est_005
    current_user = User.find(PJ_ADMIN_ID)
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID})
    email_setting.user_ids = ""
    email_setting.save
    list_user = ["#{TCANA_ADMIN_ID}","#{PU_ADMIN_ID}","#{PJ_ADMIN_ID}","#{PJ_MEMBER_ID}"]
    email_setting.add_email_users(list_user,PJ_ID,current_user)
    new_email_setting = EmailSetting.find(email_setting.id)
    assert !new_email_setting.user_ids.include?("#{TCANA_ADMIN_ID}")
    assert !new_email_setting.user_ids.include?("#{PU_ADMIN_ID}")
    assert new_email_setting.user_ids.include?("#{PJ_ADMIN_ID}")
    assert new_email_setting.user_ids.include?("#{PJ_MEMBER_ID}")
  end
  # Input:  + current_user = PJ member
  #         + TCANA admin, PU admin, PJ admin, PJ member id is existed in List user.
  # Return: + All selected user id is added, except TCANA admin, PU admin, PJ admin
  #
  def test_ut_t5_sef_est_006
    current_user = User.find(PJ_MEMBER_ID)
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID})
    email_setting.user_ids = ""
    email_setting.save
    list_user = ["#{TCANA_ADMIN_ID}","#{PU_ADMIN_ID}","#{PJ_ADMIN_ID}","#{PJ_MEMBER_ID}"]
    email_setting.add_email_users(list_user,PJ_ID,current_user)
    new_email_setting = EmailSetting.find(email_setting.id)
    assert !new_email_setting.user_ids.include?("#{TCANA_ADMIN_ID}")
    assert !new_email_setting.user_ids.include?("#{PU_ADMIN_ID}")
    assert !new_email_setting.user_ids.include?("#{PJ_ADMIN_ID}")
    assert new_email_setting.user_ids.include?("#{PJ_MEMBER_ID}")
  end
  # Input:  + current_user = TCANA admin
  #         + selected user_id is not existed.
  # Return: + Nothing changes
  #
  def test_ut_t5_sef_est_007
    current_user = User.find(PJ_MEMBER_ID)
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID})
    list_user = ["#{WRONG_ID}"]
    email_setting.add_email_users(list_user,PJ_ID,current_user)
    new_email_setting = EmailSetting.find(email_setting.id)
    assert_equal email_setting.user_ids, new_email_setting.user_ids
  end
  ##
  # Test: del_email_users(list_user,pj_id,current_user)
  #
  # Input:  + List of user is empty
  # Return: + Nothing happens
  #
  def test_ut_t5_sef_est_008
    current_user = User.find(TCANA_ADMIN_ID)
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID})
    email_setting.del_email_users("",PJ_ID,current_user)
    new_email_setting = EmailSetting.find(email_setting.id)
    assert_equal email_setting.user_ids, new_email_setting.user_ids
  end
  # Input:  + current_user = TCANA admin
  #         + TCANA admin, PU admin, PJ admin, PJ member id is existed in List user.
  # Return: + All selected user id is removed
  #
  def test_ut_t5_sef_est_009
    current_user = User.find(TCANA_ADMIN_ID)
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID})
    list_user = ["#{TCANA_ADMIN_ID}","#{PU_ADMIN_ID}","#{PJ_ADMIN_ID}","#{PJ_MEMBER_ID}"]
    email_setting.add_email_users(list_user,PJ_ID,current_user)
    #
    email_setting.del_email_users(list_user,PJ_ID,current_user)
    new_email_setting = EmailSetting.find(email_setting.id)
    assert new_email_setting.user_ids.blank?
  end
  # Input:  + current_user = PU admin
  #         + TCANA admin, PU admin, PJ admin, PJ member id is existed in List user.
  # Return: + All selected user id is removed, except TCANA admin.
  #
  def test_ut_t5_sef_est_010
    current_user = User.find(TCANA_ADMIN_ID)
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID})
    list_user = ["#{TCANA_ADMIN_ID}","#{PU_ADMIN_ID}","#{PJ_ADMIN_ID}","#{PJ_MEMBER_ID}"]
    email_setting.add_email_users(list_user,PJ_ID,current_user)
    #
    current_user = User.find(PU_ADMIN_ID)
    email_setting.del_email_users(list_user,PJ_ID,current_user)
    new_email_setting = EmailSetting.find(email_setting.id)
    assert new_email_setting.user_ids.include?("#{TCANA_ADMIN_ID}")
    assert !new_email_setting.user_ids.include?("#{PU_ADMIN_ID}")
    assert !new_email_setting.user_ids.include?("#{PJ_ADMIN_ID}")
    assert !new_email_setting.user_ids.include?("#{PJ_MEMBER_ID}")
  end
  # Input:  + current_user = PJ admin
  #         + TCANA admin, PU admin, PJ admin, PJ member id is existed in List user.
  # Return: + All selected user id is removed, except TCANA admin, PU admin
  #
  def test_ut_t5_sef_est_011
    current_user = User.find(TCANA_ADMIN_ID)
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID})
    list_user = ["#{TCANA_ADMIN_ID}","#{PU_ADMIN_ID}","#{PJ_ADMIN_ID}","#{PJ_MEMBER_ID}"]
    email_setting.add_email_users(list_user,PJ_ID,current_user)
    #
    current_user = User.find(PJ_ADMIN_ID)
    email_setting.del_email_users(list_user,PJ_ID,current_user)
    new_email_setting = EmailSetting.find(email_setting.id)
    assert new_email_setting.user_ids.include?("#{TCANA_ADMIN_ID}")
    assert new_email_setting.user_ids.include?("#{PU_ADMIN_ID}")
    assert !new_email_setting.user_ids.include?("#{PJ_ADMIN_ID}")
    assert !new_email_setting.user_ids.include?("#{PJ_MEMBER_ID}")
  end
  # Input:  + current_user = TCANA admin
  #         + selected user_id is not existed.
  # Return: + Nothing changes
  #
  def test_ut_t5_sef_est_012
    current_user = User.find(TCANA_ADMIN_ID)
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID})
    list_user = ["#{TCANA_ADMIN_ID}","#{PU_ADMIN_ID}","#{PJ_ADMIN_ID}","#{PJ_MEMBER_ID}"]
    email_setting.add_email_users(list_user,PJ_ID,current_user)
    #
    current_user = User.find(PJ_ADMIN_ID)
    email_setting.del_email_users(["#{WRONG_ID}"],PJ_ID,current_user)
    new_email_setting = EmailSetting.find(email_setting.id)
    assert new_email_setting.user_ids.include?("#{TCANA_ADMIN_ID}")
    assert new_email_setting.user_ids.include?("#{PU_ADMIN_ID}")
    assert new_email_setting.user_ids.include?("#{PJ_ADMIN_ID}")
    assert new_email_setting.user_ids.include?("#{PJ_MEMBER_ID}")
  end
  ############################################################################
end