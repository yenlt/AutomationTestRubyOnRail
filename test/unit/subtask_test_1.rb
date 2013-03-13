############################################################################
require File.dirname(__FILE__) + '/../test_helper'

class SubtaskTest < ActiveSupport::TestCase
  include AuthenticatedTestHelper  
  PER_PAGE = 10
  SUBTASK_ID = 1  
  # Test for function: self.get_all_subtasks_and_paginate
  # (page = 1, order_field = nil, order_direction = nil, per_page = PER_PAGE)
  # Valid input
  def test_ut_da10b_t1_01
    p "Test 1"
    # gets a list of subtasks
    subtasks = Subtask.get_all_subtasks_and_paginate(1,
                                                    nil,
                                                    nil,
                                                    PER_PAGE)
    # this list contains 10 subtasks
    assert_equal(PER_PAGE,
      subtasks.length)

  end

  # Invalid page (page<=0)
  def test_ut_da10b_t1_02
    p "Test 2"
    # gets a list of subtasks
    subtasks = Subtask.get_all_subtasks_and_paginate(0,
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
    p "Test 3"
    subtasks = Subtask.get_all_subtasks_and_paginate(100,
      nil,
      nil,
      PER_PAGE)
    # an empty list
    assert_equal(0,subtasks.size)
  end

  # Invalid PER_PAGE
  def test_ut_da10b_t1_04
    p "Test 4"
    begin

      subtasks = Subtask.get_all_subtasks_and_paginate(1,
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
    p "Test 5"
    subtasks = Subtask.get_all_subtasks_and_paginate(1,
                                                    nil,
                                                    nil,
                                                    0)
    # this list contain all of subtasks in subtasks table
    assert_equal(Subtask.count, subtasks.size)
  end

  #Valid order_field: pu_name, order direction: incrementally
  def test_ut_da10b_t1_006
    p "Test 6"
    # gets a list of subtasks ordered incrementally by pu_name
    subtasks = Subtask.get_all_subtasks_and_paginate(1,
                                                    "pu_name",
                                                    "asc",
                                                    PER_PAGE)

    # this list contains 10 subtasks
    assert_equal(PER_PAGE, subtasks.size)
    # this list must be sorted incrementally by row
    (1..subtasks.size - 1).each do |i|
      assert(subtasks[i].pu_name >= subtasks[i - 1].pu_name)
    end
  end

  #Valid order_field: pj_name, order direction: incrementally
  def test_ut_da10b_t1_007
    p "Test 7"
    # gets a list of subtasks ordered incrementally by pu_name
    subtasks = Subtask.get_all_subtasks_and_paginate(1,
                                                    "pj_name",
                                                    "asc",
                                                    PER_PAGE)

    # this list contains 10 subtasks
    assert_equal(PER_PAGE, subtasks.size)
    # this list must be sorted incrementally by row
    (1..subtasks.size - 1).each do |i|
      assert(subtasks[i].pj_name >= subtasks[i - 1].pj_name)
    end
  end


  # Valid order_field: task_name, order direction: incrementally
  def test_ut_da10b_t1_008
    p "Test 8"
    # gets a list of subtasks ordered incrementally by pu_name
    subtasks = Subtask.get_all_subtasks_and_paginate(1,
                                                    "task_name",
                                                    "asc",
                                                    PER_PAGE)  

    # this list contains 10 subtasks
    assert_equal(PER_PAGE, subtasks.size)    
  end

  #Valid order_field: subtask_name, order direction: incrementally
  def test_ut_da10b_t1_009
    p "Test 9"
    # gets a list of subtasks ordered incrementally by pu_name
    subtasks = Subtask.get_all_subtasks_and_paginate(1,
                                                    "task_id",
                                                    "asc",
                                                    PER_PAGE)

    # this list contains 10 subtasks
    assert_equal(PER_PAGE, subtasks.size)
    # this list must be sorted incrementally by task_id
    (1..subtasks.size - 1).each do |i|
      assert(subtasks[i].task_id >= subtasks[i - 1].task_id)
    end
  end

  #Valid order_field:subtask_id, order direction: incrementally
  def test_ut_da10b_t1_010
    p "Test 10"
    # gets a list of subtasks ordered incrementally by pu_name
    subtasks = Subtask.get_all_subtasks_and_paginate(1,
                                                    "sub_id",
                                                    "asc",
                                                     PER_PAGE)

    # this list contains 10 subtasks
    assert_equal(PER_PAGE, subtasks.size)
  end

  #Valid order_field: pu_name, order direction: decrementally
  def test_ut_da10b_t1_011
    p "Test 11"
    # gets a list of subtasks ordered decrementally by pu_name
    subtasks = Subtask.get_all_subtasks_and_paginate(1,
                                                    "pu_name",
                                                    "desc",
                                                    PER_PAGE)
    # this list contains 10 subtasks
    assert_equal(PER_PAGE, subtasks.size)
    
  end

  #Valid order_field:pj_name, order direction: decrementally
  def test_ut_da10b_t1_012
    p "Test 12"
    # gets a list of subtasks ordered decrementally by pu_name
    subtasks = Subtask.get_all_subtasks_and_paginate(1,
                                                    "pj_name",
                                                    "desc",
                                                    PER_PAGE)

   # this list contains 10 subtasks
    assert_equal(PER_PAGE, subtasks.size)
    # this list is sorted decrementally by pj_name
    (1..subtasks.size - 1).each do |i|
      assert(subtasks[i].pj_name <= subtasks[i - 1].pj_name)
    end
  end

  # Invalid order_field
  def test_ut_da10b_t1_013
    p "Test 13"
    begin
      subtasks = Subtask.get_all_subtasks_and_paginate(1,
                                                      "xyz",
                                                      "asc",
                                                      PER_PAGE)
    rescue => error
      assert_match(/Unknown column 'xyz' in 'order clause'.*/,
        error.message)
    end
  end

  # Invalid order_direction
  def test_ut_da10b_t1_014
    p "Test 14"
    begin

      subtasks = Subtask.get_all_subtasks_and_paginate(1,
                                                      "sub_id",
                                                      "xyz",
                                                      PER_PAGE)
    rescue => error
      assert_match(/You have an error in your SQL syntax;.*/,
        error.message)
    end
  end
  # test function delete subtask
  def test_delete_subtask
    p "test_delete_subtask"
    diff_results =  []
    subtask = Subtask.find_by_id(SUBTASK_ID)
    warning_ids = Warning.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).map do |warning| warning.id end
    original_file_ids = OriginalFile.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).map do |original_file| original_file.id end
    conditions = "diff_results.old_task_id = '#{subtask.task_id}'"
    conditions += " OR diff_results.new_task_id = '#{subtask.task_id}'"
    conditions += " AND diff_results.analyze_tool_id = '#{subtask.analyze_tool_id}'"
    # Find all diff_result corresponding with subtask
    diff_results = DiffResult.find(:all,
                                   :conditions => conditions)
    diff_result_ids = diff_results.map do |diff_result| diff_result.id end
    subtask.delete_subtask
    # Confirm the deletion of subtask records
    assert_equal nil, Subtask.find_by_id(SUBTASK_ID)
    # Confirm the deletion of wraning records
    assert_equal 0, Warning.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of result records
    assert_equal 0, Result.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of summaries records
    assert_equal 0, Summary.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of result directories records
    assert_equal 0, ResultDirectory.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of analyze logs records
    assert_equal 0, AnalyzeLog.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of original_files records
    assert_equal 0, OriginalFile.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of source code records
    assert_equal 0, SourceCode.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of review records
    assert_equal 0, Review.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of metric records
    assert_equal 0, Metric.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of display metric records
    assert_equal 0, DisplayMetric.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of analyze config subtask records
    assert_equal 0, AnalyzeConfigsSubtasks.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of analyze rule config subtask records
    assert_equal 0, AnalyzeRuleConfigsSubtasks.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of warning result records
    # Confirm the deletion of diff warnign records
    # Confirm the deletion of comment records
    warning_ids.each do |warning_id|
      assert_equal 0, WarningsResult.find(:all, :conditions=>["warning_id = ?", warning_id]).length
      assert_equal 0, DiffWarning.find(:all, :conditions=>["warning_id = ?", warning_id]).length
      assert_equal 0, Comment.find(:all, :conditions=>["warning_id = ?", warning_id]).length
    end
    # Confirm the deletion of original source code records
    original_file_ids.each do |original_file_id|
      assert_equal 0, OriginalSourceCode.find(:all, :conditions=>["original_file_id = ?", original_file_id]).length
    end
    # Confirm the deletion of original diff result records
    assert_equal 0, diff_results.length
    # Confirm the deletion of diff source code records
    # Confirm the deletion of diff file records
    diff_result_ids.each do |diff_result_id|
      assert_equal 0, DiffSourceCode.find(:all, :conditions=>["diff_result_id = ?", diff_result_id]).length
      assert_equal 0, DiffFile.find(:all, :conditions=>["diff_result_id = ?", diff_result_id]).length
    end
  end

  # test function delete result
  def test_delete_result
    p "test_delete_result"
    diff_results =  []
    subtask = Subtask.find_by_id(SUBTASK_ID)
    warning_ids = Warning.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).map do |warning| warning.id end
    original_file_ids = OriginalFile.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).map do |original_file| original_file.id end
    conditions = "diff_results.old_task_id = '#{subtask.task_id}'"
    conditions += " OR diff_results.new_task_id = '#{subtask.task_id}'"
    conditions += " AND diff_results.analyze_tool_id = '#{subtask.analyze_tool_id}'"
    # Find all diff_result corresponding with subtask
    diff_results = DiffResult.find(:all,
                                   :conditions => conditions)
    diff_result_ids = diff_results.map do |diff_result| diff_result.id end

    subtask.delete_result
    # Confirm the not delete subtask records
    assert_not_nil(Subtask.find_by_id(SUBTASK_ID))
    # Confirm the not delete analyze log records   
    assert_not_equal 0, AnalyzeLog.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm not delete analyze config subtask records
    assert_not_equal 0, AnalyzeConfigsSubtasks.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm not delete analyze rule config subtask records
    assert_not_equal 0, AnalyzeRuleConfigsSubtasks.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of wraning records
    assert_equal 0, Warning.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of result records
    assert_equal 0, Result.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of summaries records
    assert_equal 0, Summary.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of result directories records
    assert_equal 0, ResultDirectory.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of original_files records
    assert_equal 0, OriginalFile.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of source code records
    assert_equal 0, SourceCode.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of review records
    assert_equal 0, Review.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of metric records
    assert_equal 0, Metric.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of display metric records
    assert_equal 0, DisplayMetric.find(:all, :conditions=>["subtask_id = #{SUBTASK_ID}"]).length
    # Confirm the deletion of warning result records
    # Confirm the deletion of diff warnign records
    # Confirm the deletion of comment records
    warning_ids.each do |warning_id|
      assert_equal 0, WarningsResult.find(:all, :conditions=>["warning_id = ?", warning_id]).length
      assert_equal 0, DiffWarning.find(:all, :conditions=>["warning_id = ?", warning_id]).length
      assert_equal 0, Comment.find(:all, :conditions=>["warning_id = ?", warning_id]).length
    end
    # Confirm the deletion of original source code records
    original_file_ids.each do |original_file_id|
      assert_equal 0, OriginalSourceCode.find(:all, :conditions=>["original_file_id = ?", original_file_id]).length
    end
    # Confirm the deletion of original diff result records
    assert_equal 0, diff_results.length
    # Confirm the deletion of diff source code records
    # Confirm the deletion of diff file records
    diff_result_ids.each do |diff_result_id|
      assert_equal 0, DiffSourceCode.find(:all, :conditions=>["diff_result_id = ?", diff_result_id]).length
      assert_equal 0, DiffFile.find(:all, :conditions=>["diff_result_id = ?", diff_result_id]).length
    end
    # Confirm task state is update after delete result
    assert_equal 6,subtask.task_state_id
  end
  #Test function: not_del_result
  def test_not_del_result
    subtask = Subtask.find_by_id(SUBTASK_ID)
    # assert true
    assert subtask.not_del_result
     subtask=Subtask.new( :task_state_id => "1",
                          :task_id => "6" )

    # assert false
    assert !subtask.not_del_result
  end
end