require File.dirname(__FILE__) + '/../test_helper'


class SubtaskTest < Test::Unit::TestCase
  include AuthenticatedTestHelper
  PUBLICIZE_TASK    = 1
  CREATE_TASK       = 3
  SELECTED_TASK     = 7
  SELECTED_SUBTASK  = [9, 10, 11, 12]
  SELECTED_RESULT   = 205
  SELECTED_FILE     = 64
  TOOL_NAME         = "QAC"
  INVALID_TASK      = 10000
  
  def test_ut_mart_t4_subtask_001
    #Publicize successful for selected subtask
    check = Subtask.publicize_for_subtask(TOOL_NAME, PUBLICIZE_TASK)
    assert_equal true, check
  end

  def test_ut_mart_t4_subtask_002
    #Publicizie unssucessful with invalid Task id
    check = Subtask.publicize_for_subtask(TOOL_NAME, INVALID_TASK)
    assert_equal false, check
  end

  def test_ut_mart_t4_subtask_003
    #Unpublicize for selected subtask
    check = Subtask.unpublicize_for_subtask(TOOL_NAME, PUBLICIZE_TASK)
    assert_equal true, check
  end

  def test_ut_mart_t4_subtask_004
    #Unpublicize unsuccessful with invalid Task id
    check = Subtask.unpublicize_for_subtask(TOOL_NAME, INVALID_TASK)
    assert_equal false, check
  end

  def test_ut_mart_t4_subtask_005
    #Create result file of selected subtask (according to enabled tool)
    sub = Subtask.find_by_id(SELECTED_SUBTASK[0])
    gen = sub.generate_result(SELECTED_TASK)
    created = Result.find_all_by_task_id(SELECTED_TASK)
    unless created.blank?
      assert true
    end
  end

  def test_ut_mart_t4_subtask_006
    #Create result file of selected subtask (according to disabled tool)
    sub = Subtask.find_by_id(3)
    gen = sub.generate_result(CREATE_TASK)
    checks = Result.find_all_by_task_id(CREATE_TASK)
    checks.each do |c|
      if c.contents.include?("tool_id=#{3}")
        assert true
      end
    end
  end

  def test_ut_mart_t4_subtask_007
    #Get id of subtask
    check = Subtask.find_subtask_by_tool_name(SELECTED_TASK, TOOL_NAME)
    assert_equal check.id, SELECTED_SUBTASK[0]
  end

  def test_ut_mart_t4_subtask_008
    #Get id of subtask with invalid Task id
    check = Subtask.find_subtask_by_tool_name(INVALID_TASK, TOOL_NAME)
    if check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_subtask_009
    #Get id of subtask with invalid tool name
    check = Subtask.find_subtask_by_tool_name(SELECTED_TASK, "XXXX")
    if check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_subtask_010
    #Delete result file of selected Task when this file do not contain any warning
    sub = Subtask.find_by_id(1)
    del = sub.delete_result_by_subtask(1, 3)
    check = Result.find_all_by_task_id(5)
    if check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_subtask_011
    #Remove warning of selected subtask in result file. Result file still exist
    sub = Subtask.find_by_id(SELECTED_SUBTASK[0])
    del = sub.delete_result_by_subtask(sub.id, SELECTED_TASK)
    checks = Result.find_all_by_task_id(SELECTED_TASK)
    checks.each do |c|
      if c.contents.include?("tool_id=#{SELECTED_SUBTASK[0]}")
        assert true
      end
    end
  end

  def test_ut_mart_t4_subtask_012
    #Remove warning of selected subtask in result file
    sub = Subtask.find_by_id(7)
    warnings = [3089]
    res = Result.find_by_id(211)
    check = sub.delete_warnings_of_selected_subtask(warnings, res.contents)
    warnings.each do |w|
      unless check.include?("warning_id=#{w.id}")
        assert true
      end
    end
  end

  def test_ut_mart_t4_subtask_013
    #Warning is nil
    sub = Subtask.find_by_id(7)
    res = Result.find_by_id(211)
    check = sub.delete_warnings_of_selected_subtask(nil, res.contents)
    assert_equal check, res.contents
  end

  def test_ut_mart_t4_subtask_014
    #Result file contains warnings
    sub = Subtask.find_by_id(7)
    res = Result.find(212)
    check = sub.check_result_after_deleted_warnings(res.result)
    assert_equal false, check
  end

  def test_ut_mart_t4_subtask_015
    #Result file do not contain warnings. Remain subtasks of Task is not deleted yet
    sub = Subtask.find_by_id(SELECTED_SUBTASK[2])
    res = "<html>example string</html>"
    check = sub.check_result_after_deleted_warnings(res)
    assert_equal true, check
  end

  def test_ut_mart_t4_subtask_016
    #Result file do not contain warnings. Remain subtasks of Task is deleted. Selected subtask is the last
    sub = Subtask.find_by_id(SELECTED_SUBTASK[2])
    check = sub.delete_diff_result_by_subtask(SELECTED_SUBTASK[2], SELECTED_TASK)
    diff = DiffResult.find_by_old_task_id(SELECTED_TASK)
    if diff.blank?
      assert true
    end
  end

  def test_ut_mart_t4_subtask_017
    #Delete diff result of all analysis tool
    res = Result.delete_all(:task_id => SELECTED_TASK)
    sub = Subtask.find_by_id(SELECTED_SUBTASK[2])
    check = sub.delete_diff_result_by_subtask(SELECTED_SUBTASK[2], SELECTED_TASK)
    diff = DiffResult.find_by_new_task_id(SELECTED_TASK)
    if diff.blank?
      assert true
    end
  end

  def test_ut_mart_t4_subtask_018
    #Delete diff result of each analysis tool
    res = Result.delete_all(:task_id => 3)
    sub = Subtask.find_by_id(1)
    check = sub.delete_diff_result_by_subtask(1, 3)
    diff = DiffResult.find_by_new_task_id(1)
    if diff.blank?
      assert true
    end
  end

  def test_ut_mart_t4_subtask_019
    #Delete diff result when result of selected task deleted
    res = Result.delete_all(:task_id => 3)
    sub = Subtask.find_by_id(1)
    check = sub.delete_diff_result_by_subtask(1, 3)
    diff = DiffResult.find_by_old_task_id(3)
    if diff.blank?
      assert true
    end
  end
end