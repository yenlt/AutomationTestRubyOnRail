require File.dirname(__FILE__) + "/test_m_setup" unless defined? TestMSetup
#require "test/unit"
class TestM4 < Test::Unit::TestCase
  include TestMSetup
  # this is not a test
  def test_046
    assert true
  end
  # Arbitrary tasks are chosen and deleted from "management of analysis task" page.
  # A task record is deleted.
  def test_047
    test_000
    printf "\n+ Test 047"
    login("root","root")
    all_tasks = Task.find_all_by_id(TASK_ID)
    assert_not_equal all_tasks, []
    delete_task
    wait_for_element_not_present("//img[@alt='Edit-delete']")
    all_tasks = Task.find_all_by_id(TASK_ID)
    assert_equal all_tasks, []
    logout
  end

  # Arbitrary tasks are chosen and deleted from "management of analysis task" page.
  # subtasks record is deleted.
  def test_048
    test_000
    login("root","root")
    all_subtasks = Subtask.find_all_by_task_id(TASK_ID)
    assert_not_equal all_subtasks, []
    delete_task
    wait_for_element_not_present("//img[@alt='Edit-delete']")
    all_subtasks = Subtask.find_all_by_task_id(TASK_ID)
    assert_equal all_subtasks, []
    logout
  end


  # Arbitrary tasks are chosen and deleted from "management of analysis task" page.
  # Results record is deleted.
  def test_049
    test_000
    login("root","root")
    all_subtasks = Subtask.find_all_by_task_id(TASK_ID)
    all_subtasks_ids = all_subtasks.map { |a_subtask| a_subtask.id }
    all_result_of_task = Result.find(:all, :conditions => [ "subtask_id IN (?)", all_subtasks_ids])
    assert_not_equal all_result_of_task, []
    delete_task
    wait_for_element_not_present("//img[@alt='Edit-delete']")
    all_result_of_task = Result.find(:all, :conditions => [ "subtask_id IN (?)", all_subtasks_ids])
    assert_equal all_result_of_task, []
    logout
  end


  # Arbitrary tasks are chosen and deleted from "management of analysis task" page.
  # analyze log record is deleted.
  def test_050
    test_000
    login("root","root")
    all_subtasks = Subtask.find_all_by_task_id(TASK_ID)
    all_subtasks_ids = all_subtasks.map { |a_subtask| a_subtask.id }
    all_analyze_log_of_task = AnalyzeLog.find(:all, :conditions => [ "subtask_id IN (?)", all_subtasks_ids])
    assert_not_equal all_analyze_log_of_task, []
    delete_task
    wait_for_element_not_present("//img[@alt='Edit-delete']")
    all_analyze_log_of_task = AnalyzeLog.find(:all, :conditions => [ "subtask_id IN (?)", all_subtasks_ids])
    assert_equal all_analyze_log_of_task, []
    logout
  end
end
