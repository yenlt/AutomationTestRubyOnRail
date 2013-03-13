require File.dirname(__FILE__) + '/../test_helper'

class PuTest < ActiveSupport::TestCase
  PU_ID = 1
  PER_PAGE = 5
  ADMIN_USER_ID = 1
  PU_ADMIN_USER_ID = 2
  PJ_ADMIN_USER_ID = 4
  PJ_MEMBER_USER_ID = 6
  NOT_AVAILABLE_USER_ID = 400
#  fixtures :subtasks
#  fixtures :pus
#  fixtures :pjs
  def setup
    @pu = Pu.find_by_id(PU_ID)   
  end
   ########################################################################
   # Test function: get_paginate_subtasks
   ########################################################################
  # Test for function: get_paginate_subtasks
  # (page = 1, order_field = nil, order_direction = nil, per_page = PER_PAGE)
  # Valid input
  def test_ut_da10b_t1_01
    p "Test 01"
    # gets a list of subtasks
    subtasks = @pu.get_paginate_subtasks(1,
                                        nil,
                                        nil,
                                        PER_PAGE)
    # this list contains 5 subtasks
    assert_equal(PER_PAGE,subtasks.length)
  end

  # Invalid page (page<=0)
  def test_ut_da10b_t1_02
    p "Test 02"
    # gets a list of subtasks
    subtasks = @pu.get_paginate_subtasks(0,
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
    subtasks = @pu.get_paginate_subtasks(100,
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

      subtasks = @pu.get_paginate_subtasks(1,
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
    subtasks = @pu.get_paginate_subtasks(1,
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
    subtasks = @pu.get_paginate_subtasks(1,
                                        "pu_name",
                                        "asc",
                                        PER_PAGE)

    # this list is empty
    assert_equal(PER_PAGE,subtasks.size)

    # this list must be sorted incrementally by row
    (1..subtasks.size - 1).each do |i|
      assert(subtasks[i].pu_name >= subtasks[i - 1].pu_name)
    end
  end


  #Valid order_field: pj_name, order direction: incrementally
   def test_ut_da10b_t1_07
     p "Test 07"
    # gets a list of subtasks ordered incrementally by pu_name
    subtasks = @pu.get_paginate_subtasks(1,
                                        "pj_name",
                                        "asc",
                                        PER_PAGE)

    # this list is empty
    assert_equal(PER_PAGE,
      subtasks.size)

    # this list must be sorted incrementally by row
    (1..subtasks.size - 1).each do |i|
      assert(subtasks[i].pj_name >= subtasks[i - 1].pj_name)
    end
  end


  #Valid order_field: task_name, order direction: incrementally
   def test_ut_da10b_t1_08
     p "Test 08"
    # gets a list of subtasks ordered incrementally by pu_name
    subtasks = @pu.get_paginate_subtasks(1,
                                        "task_name",
                                        "asc",
                                        PER_PAGE)

    # this list is empty
    assert_equal(PER_PAGE,
      subtasks.size)

    # this list must be sorted incrementally by row
    (1..subtasks.size - 1).each do |i|
      assert(subtasks[i].task_name >= subtasks[i - 1].task_name)
    end
  end


  #Valid order_field: subtask_name, order direction: incrementally
   def test_ut_da10b_t1_09
     p "Test 09"
    # gets a list of subtasks ordered incrementally by pu_name
    subtasks = @pu.get_paginate_subtasks(1,
                                        "task_id",
                                        "asc",
                                        PER_PAGE)

    # this list is empty
    assert_equal(PER_PAGE,
      subtasks.size)

    # this list must be sorted incrementally by row
    (1..subtasks.size - 1).each do |i|
      assert(subtasks[i].task_id >= subtasks[i - 1].task_id)
    end
  end


  #Valid order_field:subtask_id, order direction: incrementally
   def test_ut_da10b_t1_10
     p "Test 10"
    # gets a list of subtasks ordered incrementally by pu_name
    subtasks = @pu.get_paginate_subtasks(1,
                                        "sub_id",
                                        "asc",
                                        PER_PAGE)

    # this list is empty
    assert_equal(PER_PAGE, subtasks.size)

  end

  #Valid order_field: pu_name, order direction: decrementally
   def test_ut_da10b_t1_11
     p "Test 11"
    # gets a list of subtasks ordered decrementally by pu_name
    subtasks = @pu.get_paginate_subtasks(1,
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
    subtasks = @pu.get_paginate_subtasks(1,
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

      subtasks = @pu.get_paginate_subtasks(1,
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

      subtasks = @pu.get_paginate_subtasks(1,
                                          "sub_id",
                                          "xyz",
                                          PER_PAGE)
    rescue => error
      assert_match(/You have an error in your SQL syntax;.*/,
        error.message)
    end
  end

   ########################################################################
   # Test function: get_pjs_belong_to_pu
   ########################################################################
  # pjs belong to pu isn't empty
   def test_ut_da10b_t1_15
     p "Test 15"
    # gets a list of pjs belong to selected pu
    pjs = @pu.get_pjs_belong_to_pu
    expected_pj = [["", 0], ["SamplePJ1", 1], ["SamplePJ2", 2]]
    assert_equal expected_pj, pjs
   end

  # pjs belong to pu is empty
  def test_ut_da10b_t1_16
     p "Test 16"
     pu =Pu.new( :name => "SamplePU3" )
         # gets a list of pjs belong to selected pu
    pjs = pu.get_pjs_belong_to_pu
    assert_equal [], pjs
   end

   ##***************************************************************##
   ## Test Unit TCANA2010B Phase 2                                ##
   #  T4.4                                                        ##
   ##***************************************************************##

  # Input: + Pu has pu_id = 1
  #
  # Expect: Return TRUE.
  def test_ut_t4_mtv_pu_001
    pu = Pu.find(1)
    assert_equal TRUE, pu.has_analyzed_task?
  end

  # Input: + Pu has pu_id = 2
  #
  # Expect: Return FALSE.
  def test_ut_t4_mtv_pu_002
    pu = Pu.find(2)
    assert_equal FALSE, pu.has_analyzed_task?
  end

  # Input: + Pu has pu_id = 1
  #        + pj_id = 1
  #
  # Expect: Return TRUE.
  def test_ut_t4_mtv_pu_003
    pu = Pu.find(1)
    pj_id = 1
    assert_equal TRUE, pu.check_pj_belong_to_pu?(pj_id)
    pj_id = 3
    assert_equal FALSE, pu.check_pj_belong_to_pu?(pj_id)
  end

  # Input: + Pu has pu_id = 1
  #        + pj_id = 5
  #
  # Expect: Return FALSE.
  def test_ut_t4_mtv_pu_004
    pu = Pu.find(1)
    pj_id = 5
    assert_equal FALSE, pu.check_pj_belong_to_pu?(pj_id)
  end

 
  # Input: + Pu has pu_id = 1
  #        + user_id = 2 (pu_admin)
  #
  # Expect: array contain satisfied pj
  def test_ut_t4_mtv_pu_005
    pu = Pu.find(1)
    pj1 = Pj.find(1)
    pj2 = Pj.find(2)
    pj_id = 1
    user_id = PU_ADMIN_USER_ID # pu admin
    assert_equal pj1, pu.find_all_pjs_of_pu(user_id, pj_id)[0]
    assert_equal pj2, pu.find_all_pjs_of_pu(user_id, pj_id)[1]
  end

  # Input: + Pu has pu_id = 1
  #         + user_id = 5 (pj_member)
  #
  # Expect: array contain satisfied pj
  def test_ut_t4_mtv_pu_006
    pu = Pu.find(1)
    pj1 = Pj.find(1)
    pj_id = 1
    user_id = PJ_MEMBER_USER_ID # pj member
    assert_equal pj1, pu.find_all_pjs_of_pu(user_id, pj_id)[0]
#    assert_equal pj2, pu.find_all_pjs_of_pu(user_id)[1]
  end

  # Input: + Pu has pu_id = 1
  #         + user_id = 100 (this user is not available)
  #
  # Expect: return []
  def test_ut_t4_mtv_pu_007
    pu = Pu.find(1)
    pj_id = 1
    user_id = NOT_AVAILABLE_USER_ID # user is not available
    assert_equal nil, pu.find_all_pjs_of_pu(user_id, pj_id)[0]
  end

end
