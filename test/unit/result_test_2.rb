require File.dirname(__FILE__) + '/../test_helper'

class ResultTest < Test::Unit::TestCase
  include AuthenticatedTestHelper
  SELECTED_TASK = 7
  SELECTED_SUBTASK = [9, 10, 11, 12]
  WARNING_ID = 3425
  RESULT_ID = 205

  def test_ut_mart_t4_result_001
    #Create html string of warning
    warning = Warning.find_by_id(WARNING_ID)
    result = Result.find_by_id(RESULT_ID)
    div_warning = result.create_div_warning(warning)
    if div_warning.include?("<b>#{warning.body}</b></a>")
      assert true
    end
  end

  def test_ut_mart_t4_result_002
    #test Warning is nil
    result = Result.find_by_id(RESULT_ID)
    div_warning = result.create_div_warning(nil)
    assert_equal "", div_warning
  end

  def test_ut_mart_t4_result_003
    #Delete warnings of other subtask in content of results of a Task
    result = Result.find_by_task_id(SELECTED_TASK)
    check = Result.delete_warnings_of_other_subtask(SELECTED_TASK, SELECTED_SUBTASK[0], result.contents)
    unless check.include?("sub_id=#{SELECTED_SUBTASK[0]}")
      assert true
    end
  end

  def test_ut_mart_t4_result_004
    #content of result is nil    
    check = Result.delete_warnings_of_other_subtask(SELECTED_TASK, SELECTED_SUBTASK[0], nil)
    assert_equal "", check
  end

  def test_ut_mart_t4_result_005
    #Delete warnings from result content of group selected subtasks
    result = Result.find_by_id(RESULT_ID)
    sub = [9, 10]
    subtasks = Subtask.find(:all, :conditions => {:id => sub})
    deleted = Result.delete_warnings_of_selected_subtask(subtasks, result.contents)
    if !deleted.include?("tool_id=#{subtasks[0]}") || !deleted.include?("tool_id=#{subtasks[1]}")
      assert true
    end
  end

  def test_ut_mart_t4_result_006
    #Group subtask is nil
    result = Result.find_by_id(RESULT_ID)
    subtasks = []
    deleted = Result.delete_warnings_of_selected_subtask(subtasks, result.contents)
    assert_equal deleted, result.contents
  end

  def test_ut_mart_t4_result_007
    #Result content is nil
    subtasks = [9, 10]
    deleted = Result.delete_warnings_of_selected_subtask(subtasks, nil)
    assert_equal "", deleted
  end

  def test_ut_mart_t4_result_008
    #Download result for a Task
    check = Result.export_result_reports(SELECTED_TASK, SELECTED_SUBTASK[0], "task", "tmp/AnalysisResult_Task_#{SELECTED_TASK}")
    if check.include?("Task_=#{SELECTED_TASK}")
      assert true
    end
  end

  def test_ut_mart_t4_result_009
    #Download result for selected subtask
    check = Result.export_result_reports(SELECTED_TASK, SELECTED_SUBTASK[0], "subtask", "tmp/AnalysisResult_Subtask_#{SELECTED_SUBTASK[0]}")
    if check.include?("Subtask_=#{SELECTED_SUBTASK[0]}")
      assert true
    end
  end
end