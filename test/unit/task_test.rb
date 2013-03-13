require File.dirname(__FILE__) + '/../test_helper'

class TaskTest < Test::Unit::TestCase
  include AuthenticatedTestHelper
  PUBLICIZE_TASK   = 6
  PUBLICIZED_TASK  = 2
  SELECTED_SUBTASK  = 7
  INVALID_TASK      = 10000
  CREATE_TASK       = 3
  SELECTED_TASK     = 7

  def test_ut_mart_t4_task_001
    #Publicize for selected task
    check = Task.publicize_for_task(PUBLICIZE_TASK)
    assert_equal true, check
  end

  def test_ut_mart_t4_task_002
    #Publicize unsuccessful with invalid Task
    check = Task.publicize_for_task(INVALID_TASK)
    assert_equal false, check
  end

  def test_ut_mart_t4_task_003
    #Unpublicize for selected task
    check = Task.unpublicize_for_task(PUBLICIZE_TASK)
    assert_equal true, check
  end

  def test_ut_mart_t4_task_004
    #Unpublicize unsuccessful with invalid Task
    check = Task.unpublicize_for_task(INVALID_TASK)
    assert_equal false, check
  end

  def test_ut_mart_t4_task_005
    enable_tool
    #Subtasks (according with enabled tools) of selected Task are publicized
    subs = Subtask.find_all_by_task_id(SELECTED_TASK)
    subs.each do |s|
      rev = Review.find_by_subtask_id(s)
      Review.update(rev.id, :publicized => 1)
    end
    
    check = Task.publicized?(SELECTED_TASK)
    assert_equal true, check
  end

  def test_ut_mart_t4_task_006
    enable_tool
    rev_id = 0
    #One subtask (according with enabled tools) of selected Task is unpublicized
    subs = Subtask.find_all_by_task_id(SELECTED_TASK)
    subs.each do |s|
      if subs.first == s
        rev = Review.find_by_subtask_id(s.id)
        rev_id = rev.id
        Review.update(rev.id, :publicized => 0)
      end
    end
    rev = Review.find(:all)
    check = Task.publicized?(SELECTED_TASK)
    assert_equal false, check
    Review.update(rev_id, :publicized => 1)
  end

  def test_ut_mart_t4_task_007
    #All analysis tool disabled
    disable_tool

    check = Task.publicized?(SELECTED_TASK)
    assert_equal false, check
  end

  def test_ut_mart_t4_task_008
    #Task is nil
    check = Task.publicized?(nil)
    assert_equal false, check
  end

  def test_ut_mart_t4_task_009
    #Create result files and summary files of selected Task to download
    task = Task.new
    check = task.export_analysis_result(SELECTED_TASK)
    if check.include?("AnalysisResult_Task_#{SELECTED_TASK}")
      assert true
    end
  end

  def test_ut_mart_t4_task_010
    enable_tool
    #Get subtasks and check publcize of task with All analysis tool
    subs = Subtask.find_all_by_task_id(SELECTED_TASK).collect { |s| s.id }
    subs = subs.join(",")
    check = Task.get_subtask_id_and_check_publicized(SELECTED_TASK, "All_Analysis_Tool")
    assert_equal check["subtask_id"], subs
    assert_equal true, check["publicized"]
  end

  def test_ut_mart_t4_task_011
    enable_tool
    #Get subtasks and check publcize of task with each tool
    sub = Subtask.find_by_task_id(PUBLICIZED_TASK)
    check = Task.get_subtask_id_and_check_publicized(PUBLICIZED_TASK, "QAC")
    assert_equal check["subtask_id"], sub.id
    assert_equal true, check["publicized"]
  end

  def test_ut_mart_t4_task_012
    #Get subtasks and check publcize of task when no enabled tool
    disable_tool
    
    subs = Subtask.find_all_by_task_id(SELECTED_TASK).collect { |s| s.id }
    subs = subs.join(",")
    check = Task.get_subtask_id_and_check_publicized(SELECTED_TASK, "All_Analysis_Tool")
    assert_equal check["subtask_id"], 0
    assert_equal false, check["publicized"]
  end

  def test_ut_mart_t4_task_013
    #Get subtasks and check publcize of task when selected tool disabled
    disable_tool

    sub = Subtask.find_all_by_task_id(PUBLICIZE_TASK)
    check = Task.get_subtask_id_and_check_publicized(PUBLICIZE_TASK, "QAC")
    assert_equal check["subtask_id"], 0
    assert_equal false, check["publicized"]
  end

  def test_ut_mart_t4_task_014
    #Create result file with Task has one or more than 1 analysis tool. All tool enabled
    enable_tool
    task = Task.find_by_id(CREATE_TASK)
    created = task.create_result
    subtasks = Subtask.find_all_by_task_id(CREATE_TASK)
    subtasks.each do |s|
      if s.review.extracted
        assert true
      end
    end
  end

  def test_ut_mart_t4_task_015
    #Create result file with Task has one or more than 1 analysis tool. 1 tool disabled
     AnalyzeTool.update(2, :in_use => 0)

    task = Task.find_by_id(CREATE_TASK)
    created = task.create_result
    subtasks = Subtask.find_all_by_task_id(CREATE_TASK)
    subtasks.each do |s|
      if s.review.extracted
        assert true
      end
    end
  end

  def test_ut_mart_t4_task_016
    #Create result file with Task has one or more than 1 analysis tool. All tool disabled
    disable_tool
    task = Task.find_by_id(CREATE_TASK)
    created = task.create_result
    subtasks = Subtask.find_all_by_task_id(CREATE_TASK)
    subtasks.each do |s|
      if s.review.extracted
        assert true
      end
    end
  end

  def test_ut_mart_t4_task_017
    #Get subtasks (according with enabled tools) of selected Task
    task = Task.find_by_id(SELECTED_TASK)
    subs = task.get_available_subtasks
    subs.each do |s|
      t = AnalyzeTool.find(:all, :conditions => {:in_use => 1},
                           :joins => "INNER JOIN subtasks ON subtasks.analyze_tool_id = analyze_tools.id AND subtasks.id = #{s.id}")
      if t.in_use
        assert true
      end
    end
  end

  def test_ut_mart_t4_task_018
    #Get subtasks (according with disabled tools) of selected Task
    task = Task.find_by_id(SELECTED_TASK)
    subs = task.get_available_subtasks
    subs.each do |s|
      t = AnalyzeTool.find(:all, :conditions => {:in_use => 0},
                           :joins => "INNER JOIN subtasks ON subtasks.analyze_tool_id = analyze_tools.id AND subtasks.id = #{s.id}")
      if t.in_use
        assert true
      end
    end
    enable_tool
  end

  def enable_tool
    tools = AnalyzeTool.find(:all)
    tools.each do |t|
      AnalyzeTool.update(t.id, :in_use => 1)
    end
  end

  def disable_tool
    tools = AnalyzeTool.find(:all)
    tools.each do |t|
      AnalyzeTool.update(t.id, :in_use => 0)
    end
  end
end