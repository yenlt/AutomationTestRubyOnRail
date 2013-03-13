require File.dirname(__FILE__) + '/../test_helper'

class DiffResultTest < Test::Unit::TestCase
  include AuthenticatedTestHelper
  OLD_TASK      = 6
  NEW_TASK      = 7
  EXTRACT_TASK  = 5
  ALL_TOOL      = "all"
  EACH_TOOL     = "qac"
  INVALID_TASK  = 10000

  def test_ut_mart_t4_diff_result_001
    #Diff two task with All analysis tool (all tool enabled). Set comment succession ON
    diff = create_new_diff_result(OLD_TASK, NEW_TASK,ALL_TOOL,3)
    check = diff.execute_diff(true)
    assert_equal true, check
  end

  def test_ut_mart_t4_diff_result_002
    #Diff two task with All analysis tool (one tool enabled). Set comment succession ON
    diff = create_new_diff_result(OLD_TASK, NEW_TASK, ALL_TOOL,3)
    check = diff.execute_diff(true)
    assert_equal true, check
  end

  def test_ut_mart_t4_diff_result_003
    #Diff two task with All analysis tool (one tool enabled). Set comment succession OFF
    diff = create_new_diff_result(OLD_TASK, NEW_TASK, ALL_TOOL,3)
    check = diff.execute_diff(false)
    assert_equal true, check
  end

  def test_ut_mart_t4_diff_result_004
    #Diff two task with All analysis tool (all tool disabled)
    diff = create_new_diff_result(OLD_TASK, NEW_TASK, ALL_TOOL,3)
    check = diff.execute_diff(false)
    assert_equal true, check
  end

  def test_ut_mart_t4_diff_result_005
    #Diff two task with invalid analysis tool
    diff = create_new_diff_result(1, 2, EACH_TOOL,3)
    check = diff.execute_diff(false)
    assert_equal true, check
  end

  def test_ut_mart_t4_diff_result_006
    #Diff two task with invalid analysis tool
    diff = create_new_diff_result(1, 2, EACH_TOOL,3)
    check = diff.execute_diff(false)
    assert_equal true, check
  end

  def test_ut_mart_t4_diff_result_007
    #Extract data for old task if result of this task not created yet
    diff = create_new_diff_result(3, 4, EACH_TOOL,3)
    check = diff.extract_data
    assert_equal true, check
  end

  def test_ut_mart_t4_diff_result_008
    #Extract data for new task if result of this task not created yet
    diff = create_new_diff_result(OLD_TASK, EXTRACT_TASK,ALL_TOOL,3)
    check = diff.extract_data
    assert_equal true, check
  end

  def test_ut_mart_t4_diff_result_009
    #Extract data unsuccesful if data invalid
    diff = create_new_diff_result(OLD_TASK, INVALID_TASK,ALL_TOOL,3)
    check = diff.extract_data
    assert_equal false, check
  end

  def test_ut_mart_t4_diff_result_010
    #Create file used to diff successful for all analysis tool setting
    diff = create_new_diff_result(OLD_TASK, NEW_TASK, ALL_TOOL,3)
    check = diff.create_diff_files
    assert_equal true, check
  end

  def test_ut_mart_t4_diff_result_011
    #Create file used to diff successful for each tool setting
    diff = create_new_diff_result(OLD_TASK, NEW_TASK, EACH_TOOL,3)
    check = diff.create_diff_files
    assert_equal true, check
  end

  def test_ut_mart_t4_diff_result_012
    #Create file used to diff unsuccessful with invalid analyze tool
    diff = create_new_diff_result(OLD_TASK, NEW_TASK, "xxxx",3)
    check = diff.create_diff_files
    assert_equal false, check
  end

  def test_ut_mart_t4_diff_result_013
    #Get common files of inputted subtasks
    diff = create_new_diff_result(OLD_TASK, NEW_TASK, ALL_TOOL,3)
    subtasks = [1, 7]
    check = diff.list_files_used_to_diff(subtasks)
    !assert_equal nil, check
  end

  def test_ut_mart_t4_diff_result_014
    #Return nil when not found any common file
    diff = create_new_diff_result(OLD_TASK, NEW_TASK, ALL_TOOL,3)
    subtasks = [1, 10000]
    check = diff.list_files_used_to_diff(subtasks)
    assert_equal nil, check
  end

  def create_new_diff_result(old_task, new_task, tool, state)
    diff  = DiffResult.create(:old_pu_id    => 1,
                              :old_pj_id    => 1,
                              :old_task_id  => old_task,
                              :new_pu_id    => 1,
                              :new_pj_id    => 1,
                              :new_task_id  => new_task,
                              :analyze_tool => tool,
                              :diff_state_id => state)
    return diff
  end
end
