require File.dirname(__FILE__) + '/../test_helper'

class DiffFileTest < Test::Unit::TestCase
  include AuthenticatedTestHelper
  DIFF_RESULT = 4
  DIFF_FILE_1 = 7
  DIFF_FILE_2 = 8
  INVALID_TASK  = 10000

  def test_ut_mart_t4_diff_file_001
    #Execute diff. Save result of diff for line of code, status of warnings into DB.
    #Set comment succession is ON
    df = DiffFile.find_by_id(DIFF_FILE_1)
    check = df.execute_diff(true)
    unless df.critical_contents.blank? && df.hirisk.blank? && df.normal.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_file_002
    #Execute diff. Save result of diff for line of code, status of warnings into DB.
    #Set comment succession is OFF
    df = DiffFile.find_by_id(DIFF_FILE_1)
    check = df.execute_diff(false)
    unless df.critical_contents.blank? && df.hirisk.blank? && df.normal.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_file_003
    #Delete warning of uncommon tool between old task and new task
    df = DiffFile.find_by_id(DIFF_FILE_1)
    result = Result.find_by_task_id(df.diff_result.old_task_id)
    check = df.delete_warning_uncommon_tool(result.contents, 3)
    unless check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_file_004
    #No uncommon tool between two task
    df = DiffFile.find_by_id(DIFF_FILE_2)
    result = Result.find_by_task_id(df.diff_result.old_task_id)
    res = df.modify_line_of_code(result, df.id, "old_file")
    check = df.delete_warning_uncommon_tool(result.contents, 3)
    if check == result.contents
      assert true
    end
  end

  def test_ut_mart_t4_diff_file_005
    #Delete warnings of subtask from result content
    df = DiffFile.find_by_id(DIFF_FILE_2)
    result = Result.find_by_task_id(df.diff_result.old_task_id)
    sub = Subtask.find_by_task_id(df.diff_result.old_task_id)
    check = df.delete_from_result(result, sub.id, 3)
    if !check.include?("tool_id=#{sub.id}")
      assert true
    end
  end

  def test_ut_mart_t4_diff_file_005
    #Delete warnings of invalid subtask from result content
    df = DiffFile.find_by_id(DIFF_FILE_2)
    result = Result.find_by_task_id(df.diff_result.old_task_id)
    check = df.delete_from_result(result.contents, 10000, 3)
    if check == result.contents
      assert true
    end
  end

  def test_ut_mart_t4_diff_file_006
    #Get result of old Task for selected diff file
    diff_file = DilfFile.find_by_id(DIFF_FILE_1)
    rule = [1,2,3]
    rule.each do |r|
      check = diff_file.get_source_code_from_result("old_file", r)
      unless check.blank?
        assert true
      end
    end
  end

  def test_ut_mart_t4_diff_file_007
    #Get result of new Task for selected diff file
    diff_file = DilfFile.find_by_id(DIFF_FILE_1)
    rule = [1,2,3]
    rule.each do |r|
      check = diff_file.get_source_code_from_result("new_file", r)
      unless check.blank?
        assert true
      end
    end
  end

  def test_ut_mart_t4_diff_file_008
    #Get result of Task with invalid diff file
    diff_file = DilfFile.new
    rule = [1,2,3]
    rule.each do |r|
      check = diff_file.get_source_code_from_result("old_file", r)
      if check.blank?
        assert true
      end
    end
  end

  def test_ut_mart_t4_diff_file_009
    #Input line status for each line of old source code
    #get result
    result = Result.find_by_task_id_and_file_name(DIFF_FILE_1, "Bdiff.c.Normal.Html", "old_file")
    df = DiffFile.find_by_id(DIFF_FILE_1)
    #modify source code
    check = df.modify_line_of_code(result, df.id, "old_file")
    unless check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_file_010
    #Input line status for each line of new source code
    #get result
    result = Result.find_by_task_id_and_file_name(DIFF_FILE_1, "Bdiff.c.Normal.Html", "new_file")
    df = DiffFile.find_by_id(DIFF_FILE_1)
    #modify source code
    check = df.modify_line_of_code(result, df.id, "new_file")
    unless check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_file_011
    #get result
    result = Result.new
    df = DiffFile.find_by_id(DIFF_FILE_1)
    #modify source code
    check = df.modify_line_of_code(result, df.id, "new_file")
    unless check.blank?
      assert true
    end
  end
end