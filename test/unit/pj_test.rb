require File.dirname(__FILE__) + '/../test_helper'

class PjTest < ActiveSupport::TestCase
  PJ_ID = 1
  PU_ID = 1
  PER_PAGE = 4
  TCANA_ADMIN_ID = 1
  PU_ADMIN_ID = 2
  PJ_ADMIN_ID = 3
  PJ_MEMBER_ID= 4
  EVENT_IDS = [1,2,3,4]
  fixtures :subtasks
  fixtures :pus
  fixtures :pjs
  def setup
    @pj = Pj.find_by_id(PJ_ID)
  end

  # Test for function: get_paginate_subtasks
  # (page = 1, order_field = nil, order_direction = nil, per_page = PER_PAGE)
  # Valid input
  def test_ut_da10b_t1_01
    p "Test 01"
    # gets a list of subtasks
    subtasks = @pj.get_paginate_subtasks(1,
      nil,
      nil,
      PER_PAGE)
    # this subtask list contains 4 subtasks
    assert_equal(PER_PAGE,subtasks.length)
  end

  # Invalid page (page<=0)
  def test_ut_da10b_t1_02
    p "Test 02"
    # gets a list of subtasks
    subtasks = @pj.get_paginate_subtasks(0,
      nil,
      nil,
      PER_PAGE)
    # an empty list
    assert_equal(0,subtasks.length)
  rescue => error
    assert_equal("0 given as value, which translates to '0' as page number",error.message)
  end

  # Invalid page which exceeds the maximum value
  def test_ut_da10b_t1_03
    p "Test 03"
    subtasks = @pj.get_paginate_subtasks(100,
      nil,
      nil,
      PER_PAGE)


    # an empty list
    assert_equal(0,subtasks.size)
  end

  # Invalid PER_PAGE
  def test_ut_da10b_t1_04
    p "Test 04"
    begin

      subtasks = @pj.get_paginate_subtasks(1,
        "subtask_id",
        "",
        -5)
    rescue => error
      assert_match("per_page` setting cannot be less than 1 (-5 given)",
        error.message)
    end



  end
  # get all related subtasks without
  def test_ut_da10b_t1_05
    p "Test 05"
    subtasks = @pj.get_paginate_subtasks(1,
      nil,
      nil,
      0)

    # this list contain all of subtasks in subtasks table
    assert (Subtask.count >= subtasks.size)
  end

  #Valid order_field: pu_name, order direction: incrementally
  def test_ut_da10b_t1_06
    p "Test 06"
    # gets a list of subtasks ordered incrementally by pu_name
    subtasks = @pj.get_paginate_subtasks(1,
      "pu_name",
      "asc",
      PER_PAGE)

    # this subtask list contains 4 subtasks
    assert_equal(PER_PAGE,subtasks.length)

    # this list must be sorted incrementally by row
    (1..subtasks.size - 1).each do |i|
      assert(subtasks[i].pu_name >= subtasks[i - 1].pu_name)
    end
  end


  #Valid order_field: pj_name, order direction: incrementally
  def test_ut_da10b_t1_07
    p "Test 07"
    # gets a list of subtasks ordered incrementally by pu_name
    subtasks = @pj.get_paginate_subtasks(1,
      "pj_name",
      "asc",
      PER_PAGE)

    # this subtask list contains 4 subtasks
    assert_equal(PER_PAGE,subtasks.length)

    # this list must be sorted incrementally by row
    (1..subtasks.size - 1).each do |i|
      assert(subtasks[i].pj_name >= subtasks[i - 1].pj_name)
    end
  end


  #Valid order_field: task_name, order direction: incrementally
  def test_ut_da10b_t1_08
    p "Test 08"
    # gets a list of subtasks ordered incrementally by pu_name
    subtasks = @pj.get_paginate_subtasks(1,
      "task_name",
      "asc",
      PER_PAGE)

    # this subtask list contains 4 subtasks
    assert_equal(PER_PAGE,subtasks.length)

    # this list must be sorted incrementally by row
    (1..subtasks.size - 1).each do |i|
      assert(subtasks[i].task_name >= subtasks[i - 1].task_name)
    end
  end


  #Valid order_field: subtask_name, order direction: incrementally
  def test_ut_da10b_t1_09
    p "Test 09"
    # gets a list of subtasks ordered incrementally by pu_name
    subtasks = @pj.get_paginate_subtasks(1,
      "task_id",
      "asc",
      PER_PAGE)

    # this subtask list contains 4 subtasks
    assert_equal(PER_PAGE,subtasks.length)

    # this list must be sorted incrementally by row
    (1..subtasks.size - 1).each do |i|
      assert(subtasks[i].task_id >= subtasks[i - 1].task_id)
    end
  end


  #Valid order_field:subtask_id, order direction: incrementally
  def test_ut_da10b_t1_10
    p "Test 10"
    # gets a list of subtasks ordered incrementally by pu_name
    subtasks = @pj.get_paginate_subtasks(1,
      "sub_id",
      "asc",
      PER_PAGE)

    # this subtask list contains 4 subtasks
    assert_equal(PER_PAGE,subtasks.length)

  end

  #Valid order_field: pu_name, order direction: decrementally
  def test_ut_da10b_t1_11
    p "Test 11"
    # gets a list of subtasks ordered decrementally by pu_name
    subtasks = @pj.get_paginate_subtasks(1,
      "pu_name",
      "desc",
      PER_PAGE)
    # this list is sorted decrementally by pj_name
    (1..subtasks.size - 1).each do |i|
      assert(subtasks[i].pu_name <= subtasks[i - 1].pu_name)
    end
  end

  #Valid order_field:pj_name, order direction: decrementally
  def test_ut_da10b_t1_12
    p "Test 12"
    # gets a list of subtasks ordered decrementally by pu_name
    subtasks = @pj.get_paginate_subtasks(1,
      "pj_name",
      "desc",
      PER_PAGE)


    # this list is sorted decrementally by pj_name
    (1..subtasks.size - 1).each do |i|
      assert(subtasks[i].pj_name <= subtasks[i - 1].pj_name)
    end
  end

  # Invalid order_field
  def test_ut_da10b_t1_13
    p "Test 13"
    begin

      subtasks = @pj.get_paginate_subtasks(1,
        "xyz",
        "asc",
        PER_PAGE)

    rescue => error
      assert_match(/Unknown column 'xyz' in 'order clause'.*/,
        error.message)
    end
  end

  # Invalid order_direction
  def test_ut_da10b_t1_14
    p "Test 14"
    begin

      subtasks = @pj.get_paginate_subtasks(1,
        "sub_id",
        "xyz",
        PER_PAGE)
    rescue => error
      assert_match(/You have an error in your SQL syntax;.*/,
        error.message)
    end
  end

  ############################################################################
  # Test PJ Model in [Email Notification Function]                           #

  ##
  # Test: users_in_mailing_list()
  #
  # Input: + New PJ is created.
  #        + TCANA admin logged in.
  # Expected: users_in_mailing_list function return TCANA admin.
  #
  def test_ut_t5_sef_pj_001
    current_user = User.find(TCANA_ADMIN_ID)
    new_pj = Pj.create(:name => "test_pj",
      :pu_id => PU_ID)
    EVENT_IDS.each do |event_id|
      users = new_pj.users_in_mailing_list(event_id,current_user)
      assert_not_nil users
      users.each do |e|
        user = User.find(e[1])
        assert  user.toscana_admin?
      end
    end
  end
  # Input: + New PJ is created.
  #        + PU admin logged in.
  # Expected: users_in_mailing_list function return no users.
  #
  def test_ut_t5_sef_pj_002
    current_user = User.find(PU_ADMIN_ID)
    new_pj = Pj.create(:name => "test_pj",
      :pu_id => PU_ID)
    EVENT_IDS.each do |event_id|
      users = new_pj.users_in_mailing_list(event_id,current_user)
      assert users.blank?
    end
  end
  # Input: + New PJ is created.
  #        + PJ admin logged in.
  # Expected: users_in_mailing_list function return no users.
  #
  def test_ut_t5_sef_pj_003
    current_user = User.find(PJ_ADMIN_ID)
    new_pj = Pj.create(:name => "test_pj",
      :pu_id => PU_ID)
    # Create PJ admin right
    PrivilegesUsers.create(:user_id => PJ_ADMIN_ID,
      :privilege_id => 3,
      :pu_id  => PU_ID,
      :pj_id  => new_pj.id)
    #
    EVENT_IDS.each do |event_id|
      users = new_pj.users_in_mailing_list(event_id,current_user)
      assert users.blank?
    end
  end
  # Input: + New PJ is created.
  #        + TCANA admin, PU admin, PJ admin, PJ member is added to "in mailing list"
  #        + TCANA admin logged in.
  # Expected: users_in_mailing_list function return all these member above
  #
  def test_ut_t5_sef_pj_004
    current_user = User.find(TCANA_ADMIN_ID)
    new_pj = Pj.create(:name => "test_pj",
      :pu_id => PU_ID)
    #
    EVENT_IDS.each do |event_id|
      email_setting = EmailSetting.find(:first,
        :conditions => {
          :pj_id => new_pj.id,
          :analyze_process_event_id => event_id})
      email_setting.user_ids = "#{TCANA_ADMIN_ID},#{PU_ADMIN_ID},#{PJ_ADMIN_ID},#{PJ_MEMBER_ID}"
      email_setting.save

      users = new_pj.users_in_mailing_list(event_id,current_user)
      assert_equal 4,users.size
    end
  end
  # Input: + New PJ is created.
  #        + TCANA admin, PU admin, PJ admin, PJ member is added to "in mailing list"
  #        + PU admin logged in.
  # Expected: users_in_mailing_list function return all these member above except TCANA admin
  #
  def test_ut_t5_sef_pj_005
    current_user = User.find(PU_ADMIN_ID)
    new_pj = Pj.create(:name => "test_pj",
      :pu_id => PU_ID)
    # Create PJ admin right
    PrivilegesUsers.create(:user_id => PJ_ADMIN_ID,
      :privilege_id => 3,
      :pu_id  => PU_ID,
      :pj_id  => new_pj.id)
    # Create PJ member right
    PjsUsers.create(:pj_id  => new_pj.id,
      :user_id => PJ_MEMBER_ID)
    #
    EVENT_IDS.each do |event_id|
      email_setting = EmailSetting.find(:first,
        :conditions => {
          :pj_id => new_pj.id,
          :analyze_process_event_id => event_id})
      email_setting.user_ids = "#{TCANA_ADMIN_ID},#{PU_ADMIN_ID},#{PJ_ADMIN_ID},#{PJ_MEMBER_ID}"
      email_setting.save

      users = new_pj.users_in_mailing_list(event_id,current_user)
      assert_equal 3,users.size
    end
  end
  # Input: + New PJ is created.
  #        + TCANA admin, PU admin, PJ admin, PJ member is added to "in mailing list"
  #        + PJ admin logged in.
  # Expected: users_in_mailing_list function return only PJ admin and PJ member
  #
  def test_ut_t5_sef_pj_006
    current_user = User.find(PJ_ADMIN_ID)
    new_pj = Pj.create(:name => "test_pj",
      :pu_id => PU_ID)
    # Create PJ admin right
    PrivilegesUsers.create(:user_id => PJ_ADMIN_ID,
      :privilege_id => 3,
      :pu_id  => PU_ID,
      :pj_id  => new_pj.id)
    # Create PJ member right
    PjsUsers.create(:pj_id  => new_pj.id,
      :user_id => PJ_MEMBER_ID)
    #
    EVENT_IDS.each do |event_id|
      email_setting = EmailSetting.find(:first,
        :conditions => {
          :pj_id => new_pj.id,
          :analyze_process_event_id => event_id})
      email_setting.user_ids = "#{TCANA_ADMIN_ID},#{PU_ADMIN_ID},#{PJ_ADMIN_ID},#{PJ_MEMBER_ID}"
      email_setting.save

      users = new_pj.users_in_mailing_list(event_id,current_user)
      assert_equal 2,users.size
    end
  end
 
  ##
  # Test: users_not_in_mailing_list()
  #
  # Input: + New PJ is created.
  #        + TCANA admin logged in.
  # Expected: users_not_in_mailing_list function return all these above users except TCANA admin
  #
  def test_ut_t5_sef_pj_007
    current_user = User.find(TCANA_ADMIN_ID)
    new_pj = Pj.create(:name => "test_pj",
      :pu_id => PU_ID)
    #
    EVENT_IDS.each do |event_id|
      un_users = new_pj.users_not_in_mailing_list(event_id,current_user)
      un_users.each do |user_id|
        user = User.find(user_id[1])
        assert !user.toscana_admin?
      end
    end
  end
  # Input: + New PJ is created.
  #        + TCANA admin, PU/PJ admin, PJ member is assigned to be this PJ member.
  #        + PU admin logged in.
  # Expected: users_not_in_mailing_list function return all these above users except TCANA admin
  #
  def test_ut_t5_sef_pj_008
    current_user = User.find(PU_ADMIN_ID)
    new_pj = Pj.create(:name => "test_pj",
      :pu_id => PU_ID)
    #
    EVENT_IDS.each do |event_id|
      un_users = new_pj.users_not_in_mailing_list(event_id,current_user)
      un_users.each do |user_id|
        user = User.find(user_id[1])
        assert !user.toscana_admin?
      end
    end
  end
  # Input: + New PJ is created.
  #        + TCANA admin, PU/PJ admin, PJ member is assigned to be this PJ member.
  #        + PJ admin logged in.
  # Expected: users_not_in_mailing_list function return only PJ admin, PJ member
  #
  def test_ut_t5_sef_pj_009
    current_user = User.find(PJ_ADMIN_ID)
    new_pj = Pj.create(:name => "test_pj",
      :pu_id => PU_ID)
    # Create PJ admin right
    PrivilegesUsers.create(:user_id => PJ_ADMIN_ID,
      :privilege_id => 3,
      :pu_id  => PU_ID,
      :pj_id  => new_pj.id)
    #
    EVENT_IDS.each do |event_id|
      un_users = new_pj.users_not_in_mailing_list(event_id,current_user)
      un_users.each do |user_id|
        user = User.find(user_id[1])
        assert !user.pu_admin?(PU_ID)
        assert !user.toscana_admin?
      end
    end
  end
 
  ##
  # Test: create_default_setting(event_id)
  #
  # Input: When create a PJ
  # Expected: TCANA admin is default assigned to all email setting
  #
  def test_ut_t5_sef_pj_010
    new_pj = Pj.create(:name => "test_pj",
      :pu_id => PU_ID)
    email_settings = EmailSetting.find_all_by_pj_id(new_pj.id)
    email_settings.each do |setting|
      assert_equal TCANA_ADMIN_ID.to_s, setting.user_ids
    end
  end
  # End of testing PJ Model in [Email Notification Function]                 #
  ############################################################################

   ##***************************************************************##
   ## Test Unit TCANA2010B Phase 2
   #  T4.4
   ########################################################################
   # Input: + Pj has pj_id = 1
   # Expect: Pj had analyzed task
  def test_ut_t4_mtv_pj_001
    pj = Pj.find(1)
    assert_equal TRUE, pj.has_analyzed_task?
  end

  # Input: + Pj has ph_id = 3
  # Expect: Pj had not analyzed task
  def test_ut_t4_mtv_pu_002
    pj = Pj.find(3)
    assert_equal FALSE, pj.has_analyzed_task?
  end

  ### End of Unit test T4.4

end
