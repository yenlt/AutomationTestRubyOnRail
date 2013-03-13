require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../integration/setup'
require 'pj_controller'

class PjControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  ##############################################################################
  # Setup
  ##############################################################################
  # Fixtures
  fixtures :users
  fixtures :privileges
  fixtures :privileges_users
  fixtures :pus
  fixtures :pjs
  fixtures :pus_users
  fixtures :email_settings
  #
  TCANA_admin = "root"
  PU_admin = "pu_admin"
  PU_member = "pu_member"
  PJ_admin = "pj_admin"
  PJ_member = "pj_member"
  #
  PU_ID = 1
  EVENT_IDS = [1,2,3,4]
  ##############################################################################
  # Test PJ Controller in [Email Notification Function]                        #

  ## Setup: Create a new PJ and assign the PJ admin and PJ member.
  def create_pj(pu_id = PU_ID, pj_admin_id = 3, pj_member_id = 4)
    #create PJ
    new_pj = Pj.create(:name => "Test PJ", :pu_id => pu_id)
    #assign PJ admin
    PrivilegesUsers.create(:user_id => pj_admin_id ,
      :privilege_id => 3,
      :pu_id => pu_id,
      :pj_id => new_pj.id)
    #assign PJ member
    PjsUsers.create(:pj_id => new_pj.id,
      :user_id  => pj_member_id)
    #
    return new_pj
  end

  ####################################
  # Function: add_email_users
  #
  # Test: Not login user has no right to request function
  # Input:  + Actor has not login but request to call add_email_users function.
  # Expected: Redirected back to login page.
  #
  def test_it_t5_sef_met_pj_001
    post :add_email_users
    assert_redirected_to :controller => "auth", :action => "login"
  end
  # Test: PU/PJ member has no right to request function
  # Input: + PU/PJ member login.
  #        + Request to call add_email_users for each analyze process event id
  # Expected: Redirected back to his/her page.
  #
  def test_it_t5_sef_met_pj_002
    new_pj = create_pj
    EVENT_IDS.each do |event_id|
      # PJ member
      login_as PJ_member
      post :add_email_users,
        :pu => PU_ID,
        :pj => new_pj.id,
        :analyze_event_id => event_id,
        :non_member => []
      assert_redirected_to :controller => "misc", :action => "index"
      # PU member & member of other PJ
      login_as PJ_member
      post :add_email_users,
        :pu => PU_ID,
        :pj => 100,
        :analyze_event_id => event_id,
        :non_member => []
      assert_redirected_to :controller => "misc", :action => "index"
    end
  end
  # Test: TCANA/PU/PJ admin of the selected PJ has right to request function
  # Input: + TCANA/PU/PJ admin login.
  #        + Request to call add_email_users for each analyze process event id
  #        + A PJ member is selected.
  # Expected: Selected member is added.
  #
  def test_it_t5_sef_met_pj_003
    pj_member_id = User.find_by_account_name(PJ_member).id
    non_member = ["#{pj_member_id}"]
    new_pj = create_pj
    users = [TCANA_admin, PU_admin, PJ_admin]
    #
    users.each do |u|
      login_as u
      EVENT_IDS.each do |event_id|
        post :add_email_users,
          :pu => PU_ID,
          :pj => new_pj.id,
          :analyze_event_id => event_id,
          :non_member => non_member
        assert_response :success
        email_setting = EmailSetting.find(:first,
          :conditions => { :pj_id => new_pj.id,
            :analyze_process_event_id => event_id})
        assert !email_setting.blank?
        assert email_setting.user_ids.include?("#{pj_member_id}")
      end
    end
  end
  # Test: TCANA/PU/PJ admin of the selected PJ has right to add multiple users.
  # Input: + TCANA/PU/PJ admin login.
  #        + Request to call add_email_users for each analyze process event id
  #        + Multiple user is selected
  # Expected: Selected members is added.
  #
  def test_it_t5_sef_met_pj_004
    pj_member_id = User.find_by_account_name(PJ_member).id
    pj_admin_id = User.find_by_account_name(PJ_admin).id
    new_pj = create_pj
    non_members = ["#{pj_member_id}","#{pj_admin_id}"]
    users = [TCANA_admin, PU_admin, PJ_admin]
    #
    users.each do |u|
      login_as u
      EVENT_IDS.each do |event_id|
        post :add_email_users,
          :pu => PU_ID,
          :pj => new_pj.id,
          :analyze_event_id => event_id,
          :non_member => non_members
        assert_response :success
        email_setting = EmailSetting.find(:first,
          :conditions => { :pj_id => new_pj.id,
            :analyze_process_event_id => event_id})
        assert !email_setting.blank?
        assert email_setting.user_ids.include?("#{pj_member_id}")
        assert email_setting.user_ids.include?("#{pj_admin_id}")
      end
    end
  end
  # Test: TCANA/PU/PJ admin request to add user who is not existed in DB
  # Input: + TCANA/PU/PJ admin login.
  #        + Request to call add_email_users for each analyze process event id
  #        + User selected is not existed in DB
  # Expected: Nothing is happened
  #
  def test_it_t5_sef_met_pj_005 # bug
    new_pj = create_pj
    non_members = ["1000"]
    users = [TCANA_admin, PU_admin, PJ_admin]
    #
    users.each do |u|
      login_as u
      EVENT_IDS.each do |event_id|
        email_setting = EmailSetting.find(:first,
          :conditions => { :pj_id => new_pj.id,
            :analyze_process_event_id => event_id})
        email_setting.user_ids = ""
        email_setting.save
        #
        post :add_email_users,
          :pu => PU_ID,
          :pj => new_pj.id,
          :analyze_event_id => event_id,
          :non_member => non_members
        assert_response :success
        email_setting = EmailSetting.find(:first,
          :conditions => { :pj_id => new_pj.id,
            :analyze_process_event_id => event_id})
        assert !email_setting.blank?
        assert email_setting.user_ids.blank?
      end
    end
  end
  # Test: TCANA/PU/PJ admin request to add no user
  # Input: + TCANA/PU/PJ admin login.
  #        + Request to call add_email_users for each analyze process event id
  #        + Select no user
  # Expected: Nothing is happened
  #
  def test_it_t5_sef_met_pj_006
    new_pj = create_pj
    non_members = []
    users = [TCANA_admin, PU_admin, PJ_admin]
    #
    users.each do |u|
      login_as u
      EVENT_IDS.each do |event_id|
        email_setting = EmailSetting.find(:first,
          :conditions => { :pj_id => new_pj.id,
            :analyze_process_event_id => event_id})
        email_setting.user_ids = ""
        email_setting.save
        #
        post :add_email_users,
          :pu => PU_ID,
          :pj => new_pj.id,
          :analyze_event_id => event_id,
          :non_member => non_members
        assert_response :success
        email_setting = EmailSetting.find(:first,
          :conditions => { :pj_id => new_pj.id,
            :analyze_process_event_id => event_id})
        assert !email_setting.blank?
        assert email_setting.user_ids.blank?
      end
    end
  end
  # Test: TCANA admin has right to add all other members includes PU admin, PJ admin ...
  # Input: + TCANA admin login.
  #        + Request to call add_email_users for each analyze process event id
  #        + PU admin, PJ admin, TCANA admin are selected.
  # Expected: Selected members is added.
  #
  def test_it_t5_sef_met_pj_007
    pj_member_id = User.find_by_account_name(PJ_member).id
    pj_admin_id = User.find_by_account_name(PJ_admin).id
    pu_admin_id = User.find_by_account_name(PU_admin).id
    tcana_admin_id = User.find_by_account_name(TCANA_admin).id
    new_pj = create_pj
    non_members = ["#{pj_member_id}","#{pj_admin_id}","#{pu_admin_id}","#{tcana_admin_id}"]
    # TCANA admin
    login_as TCANA_admin
    EVENT_IDS.each do |event_id|
      email_setting = EmailSetting.find(:first,
        :conditions => { :pj_id => new_pj.id,
          :analyze_process_event_id => event_id})
      email_setting.user_ids = ""
      email_setting.save
      #
      post :add_email_users, 
        :pu => PU_ID,
        :pj => new_pj.id,
        :analyze_event_id => event_id,
        :non_member => non_members
      assert_response :success
      email_setting = EmailSetting.find(:first,
        :conditions => { :pj_id => new_pj.id,
          :analyze_process_event_id => event_id})
      assert !email_setting.blank?
      assert email_setting.user_ids.include?("#{pj_member_id}")
      assert email_setting.user_ids.include?("#{pj_admin_id}")
      assert email_setting.user_ids.include?("#{pu_admin_id}")
      assert email_setting.user_ids.include?("#{tcana_admin_id}")
    end
  end
  # Test: PU admin has right to add all other members except TCANA admin.
  # Input: + PU admin login.
  #        + Request to call add_email_users for each analyze process event id
  #        + PU admin, PJ admin, TCANA admin are selected.
  # Expected: Selected members is added except TCANA admin
  #
  def test_it_t5_sef_met_pj_008
    pj_member_id = User.find_by_account_name(PJ_member).id
    pj_admin_id = User.find_by_account_name(PJ_admin).id
    pu_admin_id = User.find_by_account_name(PU_admin).id
    tcana_admin_id = User.find_by_account_name(TCANA_admin).id
    new_pj = create_pj
    non_members = ["#{pj_member_id}","#{pj_admin_id}","#{pu_admin_id}","#{tcana_admin_id}"]
    # TCANA admin
    login_as PU_admin
    EVENT_IDS.each do |event_id|
      email_setting = EmailSetting.find(:first,
        :conditions => { :pj_id => new_pj.id,
          :analyze_process_event_id => event_id})
      email_setting.user_ids = ""
      email_setting.save
      #
      post :add_email_users, 
        :pu => PU_ID,
        :pj => new_pj.id,
        :analyze_event_id => event_id,
        :non_member => non_members
      assert_response :success
      email_setting = EmailSetting.find(:first,
        :conditions => { :pj_id => new_pj.id,
          :analyze_process_event_id => event_id})
      assert !email_setting.blank?
      assert email_setting.user_ids.include?("#{pj_member_id}")
      assert email_setting.user_ids.include?("#{pj_admin_id}")
      assert email_setting.user_ids.include?("#{pu_admin_id}")
      assert !email_setting.user_ids.include?("#{tcana_admin_id}")
    end
  end
  # Test: PJ admin has right to add all other members except TCANA admin, PU admin
  # Input: + PJ admin login.
  #        + Request to call add_email_users for each analyze process event id
  #        + PU admin, PJ admin, TCANA admin are selected.
  # Expected: Selected members is added except TCANA admin, PU admin
  #
  def test_it_t5_sef_met_pj_009
    pj_member_id = User.find_by_account_name(PJ_member).id
    pj_admin_id = User.find_by_account_name(PJ_admin).id
    pu_admin_id = User.find_by_account_name(PU_admin).id
    tcana_admin_id = User.find_by_account_name(TCANA_admin).id
    new_pj = create_pj
    non_members = ["#{pj_member_id}","#{pj_admin_id}","#{pu_admin_id}","#{tcana_admin_id}"]
    # TCANA admin
    login_as PJ_admin
    EVENT_IDS.each do |event_id|
      email_setting = EmailSetting.find(:first,
        :conditions => { :pj_id => new_pj.id,
          :analyze_process_event_id => event_id})
      email_setting.user_ids = ""
      email_setting.save
      #
      post :add_email_users,
        :pu => PU_ID,
        :pj => new_pj.id,
        :analyze_event_id => event_id,
        :non_member => non_members
      assert_response :success
      email_setting = EmailSetting.find(:first,
        :conditions => { :pj_id => new_pj.id,
          :analyze_process_event_id => event_id})
      assert !email_setting.blank?
      assert email_setting.user_ids.include?("#{pj_member_id}")
      assert email_setting.user_ids.include?("#{pj_admin_id}")
      assert !email_setting.user_ids.include?("#{pu_admin_id}")
      assert !email_setting.user_ids.include?("#{tcana_admin_id}")
    end
  end

  ####################################
  # Function: del_email_users
  #
  # Test: Not login user has no right to request function
  # Input:  + Actor has not login but request to call del_email_users function.
  # Expected: Redirected back to login page.
  #
  def test_it_t5_sef_met_pj_010
    post :del_email_users
    assert_redirected_to :controller => "auth", :action => "login"
  end
  # Test: PU/PJ member has no right to request function
  # Input: + PU/PJ member login.
  #        + Request to call del_email_users for each analyze process event id
  # Expected: Redirected back to his/her page.
  #
  def test_it_t5_sef_met_pj_011
    new_pj = create_pj
    EVENT_IDS.each do |event_id|
      # PJ member
      login_as PJ_member
      post :del_email_users,
        :pu => PU_ID,
        :pj => new_pj.id,
        :analyze_event_id => event_id,
        :member => []
      assert_redirected_to :controller => "misc", :action => "index"
      # PU member & member of other PJ
      login_as PJ_member
      post :del_email_users,
        :pu => PU_ID,
        :pj => 100,
        :analyze_event_id => event_id,
        :member => []
      assert_redirected_to :controller => "misc", :action => "index"
    end
  end
  # Test: TCANA/PU/PJ admin of the selected PJ has right to request function
  # Input: + TCANA/PU/PJ admin login.
  #        + Request to call del_email_users for each analyze process event id
  #        + A PJ member is selected.
  # Expected: Selected member is deleted.
  #
  def test_it_t5_sef_met_pj_012
    pj_member_id = User.find_by_account_name(PJ_member).id
    member = ["#{pj_member_id}"]
    new_pj = create_pj
    users = [TCANA_admin, PU_admin, PJ_admin]
    #
    users.each do |u|
      login_as u
      EVENT_IDS.each do |event_id|
        post :add_email_users,
          :pu => PU_ID,
          :pj => new_pj.id,
          :analyze_event_id => event_id,
          :non_member => member
        assert_response :success
        # Remove
        post :del_email_users,
          :pu => PU_ID,
          :pj => new_pj.id,
          :analyze_event_id => event_id,
          :member => member
        assert_response :success
        #
        email_setting = EmailSetting.find(:first,
          :conditions => { :pj_id => new_pj.id,
            :analyze_process_event_id => event_id})
        assert !email_setting.blank?
        assert !email_setting.user_ids.include?("#{pj_member_id}")
      end
    end
  end
  # Test: TCANA/PU/PJ admin of the selected PJ has right to remove multiple users.
  # Input: + TCANA/PU/PJ admin login.
  #        + Request to call del_email_users for each analyze process event id
  #        + Multiple user is selected
  # Expected: Selected members is removed
  #
  def test_it_t5_sef_met_pj_013
    pj_member_id = User.find_by_account_name(PJ_member).id
    pj_admin_id = User.find_by_account_name(PJ_admin).id
    new_pj = create_pj
    members = ["#{pj_member_id}","#{pj_admin_id}"]
    users = [TCANA_admin, PU_admin, PJ_admin]
    #
    users.each do |u|
      login_as u
      EVENT_IDS.each do |event_id|
        post :add_email_users,
          :pu => PU_ID,
          :pj => new_pj.id,
          :analyze_event_id => event_id,
          :non_member => members
        assert_response :success
        email_setting = EmailSetting.find(:first,
          :conditions => { :pj_id => new_pj.id,
            :analyze_process_event_id => event_id})
        assert !email_setting.blank?
        #
        post :del_email_users,
          :pu => PU_ID,
          :pj => new_pj.id,
          :analyze_event_id => event_id,
          :member => members
        assert_response :success
        email_setting = EmailSetting.find(:first,
          :conditions => { :pj_id => new_pj.id,
            :analyze_process_event_id => event_id})
        assert !email_setting.blank?
        assert !email_setting.user_ids.include?("#{pj_member_id}")
        assert !email_setting.user_ids.include?("#{pj_admin_id}")
      end
    end
  end
  # Test: TCANA/PU/PJ admin request to remove user who is not existed in DB
  # Input: + TCANA/PU/PJ admin login.
  #        + Request to call del_email_users for each analyze process event id
  #        + User selected is not existed in DB
  # Expected: Nothing is happened
  #
  def test_it_t5_sef_met_pj_014 # bug
    new_pj = create_pj
    members = ["1000"]
    users = [TCANA_admin, PU_admin, PJ_admin]
    #
    users.each do |u|
      login_as u
      EVENT_IDS.each do |event_id|
        email_setting = EmailSetting.find(:first,
          :conditions => { :pj_id => new_pj.id,
            :analyze_process_event_id => event_id})
        email_setting.user_ids = ""
        email_setting.save
        #
        post :del_email_users,
          :pu => PU_ID,
          :pj => new_pj.id,
          :analyze_event_id => event_id,
          :member => members
        assert_response :success
        email_setting = EmailSetting.find(:first,
          :conditions => { :pj_id => new_pj.id,
            :analyze_process_event_id => event_id})
        assert !email_setting.blank?
        assert email_setting.user_ids.blank?
      end
    end
  end
  # Test: TCANA/PU/PJ admin request to remove no user
  # Input: + TCANA/PU/PJ admin login.
  #        + Request to call del_email_users for each analyze process event id
  #        + Select no user
  # Expected: Nothing is happened
  #
  def test_it_t5_sef_met_pj_015
    new_pj = create_pj
    members = []
    users = [TCANA_admin, PU_admin, PJ_admin]
    #
    users.each do |u|
      login_as u
      EVENT_IDS.each do |event_id|
        email_setting = EmailSetting.find(:first,
          :conditions => { :pj_id => new_pj.id,
            :analyze_process_event_id => event_id})
        email_setting.user_ids = ""
        email_setting.save
        #
        post :del_email_users,
          :pu => PU_ID,
          :pj => new_pj.id,
          :analyze_event_id => event_id,
          :member => members
        assert_response :success
        email_setting = EmailSetting.find(:first,
          :conditions => { :pj_id => new_pj.id,
            :analyze_process_event_id => event_id})
        assert !email_setting.blank?
        assert email_setting.user_ids.blank?
      end
    end
  end
  # Test: TCANA admin has right to remove all other members includes PU admin, PJ admin ...
  # Input: + TCANA admin login.
  #        + Request to call del_email_users for each analyze process event id
  #        + PU admin, PJ admin, TCANA admin are selected.
  # Expected: Selected members is delete.
  #
  def test_it_t5_sef_met_pj_016
    pj_member_id = User.find_by_account_name(PJ_member).id
    pj_admin_id = User.find_by_account_name(PJ_admin).id
    pu_admin_id = User.find_by_account_name(PU_admin).id
    tcana_admin_id = User.find_by_account_name(TCANA_admin).id
    new_pj = create_pj
    members = ["#{pj_member_id}","#{pj_admin_id}","#{pu_admin_id}","#{tcana_admin_id}"]
    # TCANA admin
    login_as TCANA_admin
    EVENT_IDS.each do |event_id|
      email_setting = EmailSetting.find(:first,
        :conditions => { :pj_id => new_pj.id,
          :analyze_process_event_id => event_id})
      email_setting.user_ids = ""
      email_setting.save
      #
      post :add_email_users,
        :pu => PU_ID,
        :pj => new_pj.id,
        :analyze_event_id => event_id,
        :non_member => members
      assert_response :success
      #
      post :del_email_users,
        :pu => PU_ID,
        :pj => new_pj.id,
        :analyze_event_id => event_id,
        :member => members
      assert_response :success
      #
      email_setting = EmailSetting.find(:first,
        :conditions => { :pj_id => new_pj.id,
          :analyze_process_event_id => event_id})
      assert !email_setting.blank?
      assert !email_setting.user_ids.include?("#{pj_member_id}")
      assert !email_setting.user_ids.include?("#{pj_admin_id}")
      assert !email_setting.user_ids.include?("#{pu_admin_id}")
      assert !email_setting.user_ids.include?("#{tcana_admin_id}")
    end
  end
  # Test: PU admin has right to remove all other members except TCANA admin.
  # Input: + PU admin login.
  #        + Request to call del_email_users for each analyze process event id
  #        + PU admin, PJ admin, TCANA admin are selected.
  # Expected: Selected members is removed except TCANA admin
  #
  def test_it_t5_sef_met_pj_017
    pj_member_id = User.find_by_account_name(PJ_member).id
    pj_admin_id = User.find_by_account_name(PJ_admin).id
    pu_admin_id = User.find_by_account_name(PU_admin).id
    tcana_admin_id = User.find_by_account_name(TCANA_admin).id
    new_pj = create_pj
    members = ["#{pj_member_id}","#{pj_admin_id}","#{pu_admin_id}","#{tcana_admin_id}"]
    # TCANA admin
    login_as PU_admin
    EVENT_IDS.each do |event_id|
      email_setting = EmailSetting.find(:first,
        :conditions => { :pj_id => new_pj.id,
          :analyze_process_event_id => event_id})
      email_setting.user_ids = "#{pj_member_id},#{pj_admin_id},#{pu_admin_id},#{tcana_admin_id}"
      email_setting.save
      #
      post :del_email_users,
        :pu => PU_ID,
        :pj => new_pj.id,
        :analyze_event_id => event_id,
        :member => members
      assert_response :success
      email_setting = EmailSetting.find(:first,
        :conditions => { :pj_id => new_pj.id,
          :analyze_process_event_id => event_id})
      assert !email_setting.blank?
      assert !email_setting.user_ids.include?("#{pj_member_id}")
      assert !email_setting.user_ids.include?("#{pj_admin_id}")
      assert !email_setting.user_ids.include?("#{pu_admin_id}")
      assert email_setting.user_ids.include?("#{tcana_admin_id}")
    end
  end
  # Test: PJ admin has right to remove all other members except TCANA admin, PU admin
  # Input: + PJ admin login.
  #        + Request to call del_email_users for each analyze process event id
  #        + PU admin, PJ admin, TCANA admin are selected.
  # Expected: Selected members is removed except TCANA admin, PU admin
  #
  def test_it_t5_sef_met_pj_018
    pj_member_id = User.find_by_account_name(PJ_member).id
    pj_admin_id = User.find_by_account_name(PJ_admin).id
    pu_admin_id = User.find_by_account_name(PU_admin).id
    tcana_admin_id = User.find_by_account_name(TCANA_admin).id
    new_pj = create_pj
    members = ["#{pj_member_id}","#{pj_admin_id}","#{pu_admin_id}","#{tcana_admin_id}"]
    # TCANA admin
    login_as PJ_admin
    EVENT_IDS.each do |event_id|
      email_setting = EmailSetting.find(:first,
        :conditions => { :pj_id => new_pj.id,
          :analyze_process_event_id => event_id})
      email_setting.user_ids = "#{pj_member_id},#{pj_admin_id},#{pu_admin_id},#{tcana_admin_id}'"
      email_setting.save
      #
      post :del_email_users,
        :pu => PU_ID,
        :pj => new_pj.id,
        :analyze_event_id => event_id,
        :member => members
      assert_response :success
      email_setting = EmailSetting.find(:first,
        :conditions => { :pj_id => new_pj.id,
          :analyze_process_event_id => event_id})
      assert !email_setting.blank?
      assert !email_setting.user_ids.include?("#{pj_member_id}")
      assert !email_setting.user_ids.include?("#{pj_admin_id}")
      assert email_setting.user_ids.include?("#{pu_admin_id}")
      assert email_setting.user_ids.include?("#{tcana_admin_id}")
    end
  end
  ##############################################################################

end