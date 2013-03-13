require File.dirname(__FILE__) + "/test_m_setup" unless defined? TestMSetup
#require "test/unit"
class TestM2 < Test::Unit::TestCase
  include TestMSetup
  #this is not a test
  def test_024
    assert true
  end
  # Arbitrary PJ(s) are chosen and deleted from "PJ management" page.
  # PJ Users record is deleted.
  def test_025
    test_000
    login("root","root")
    all_pj_mem = PjsUsers.find_all_by_pj_id(PJ_ID)
    assert_not_equal all_pj_mem, []
    delete_pj
    all_pj_mem = PjsUsers.find_all_by_pj_id(PJ_ID)
    begin
      assert_equal all_pj_mem, []
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
  end
  # Arbitrary PJ(s) are chosen and deleted from "PJ management" page.
  # PrivilegesUsers is deleted
  def test_026
    test_000
    login("root","root")
    privilege_users_of_pj = PrivilegesUsers.find_all_by_pj_id(PJ_ID)
    assert_not_equal privilege_users_of_pj,[]
    delete_pj
    privilege_users_of_pj = PrivilegesUsers.find_all_by_pj_id(PJ_ID)
    assert_equal privilege_users_of_pj,[]
    logout
  end
  # Arbitrary Pj(s) are chosen and deleted from "Pj management" page.
  # Master record is deleted
  def test_027
    test_000
    login("root","root")
    all_masters_of_pj = Master.find_all_by_pj_id(PJ_ID)
    assert_not_equal all_masters_of_pj,[]
    delete_pj
    all_masters_of_pj = Master.find_all_by_pj_id(PJ_ID)
    assert_equal all_masters_of_pj,[]
    logout
  end
  # Arbitrary PJ(s) are chosen and deleted from "PJ management" page.
  # Task record is deleted
  def test_028
    test_000
    login("root","root")
    all_task_of_pj = Task.find_all_by_pj_id(PJ_ID)
    assert_not_equal all_task_of_pj,[]
    delete_pj
    all_task_of_pj = Task.find_all_by_pj_id(PJ_ID)
    assert_equal all_task_of_pj,[]
    logout
  end


  # Arbitrary PJ(s) are chosen and deleted from "PJ management" page.
  # Subtask record is deleted
  def test_029
    test_000
    login("root","root")
    all_subtasks = Subtask.find_all_by_task_id(TASK_ID)
    assert_not_equal all_subtasks, []
    delete_pj
    all_subtasks = Subtask.find_all_by_task_id(TASK_ID)
    assert_equal all_subtasks, []
    logout
  end

  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # Segment record is deleted
  def test_030
    test_000
    login("root","root")
    all_segments_of_master = Segment.find_all_by_fk_id(MASTER_ID)
    assert_not_equal all_segments_of_master, []
    delete_pj
    all_segments_of_master = Segment.find_all_by_fk_id(MASTER_ID)
    assert_equal all_segments_of_master, []
    logout
  end



  # Arbitrary PJ(s) are chosen and deleted from "PJ management" page.
  # Directory tree record is deleted
  def test_031
    test_000
    login("root","root")
    all_directory_tree_of_master = DirectoryTree.find_all_by_fk_id(MASTER_ID)
    assert_not_equal all_directory_tree_of_master, []
    delete_pj
    all_directory_tree_of_master= DirectoryTree.find_all_by_fk_id(MASTER_ID)
    assert_equal all_directory_tree_of_master, []
    logout
  end



  # Arbitrary PJ(s) are chosen and deleted from "PJ management" page.
  # Temp file record is deleted
  def test_032
    test_000
    login("root","root")
    all_temp_file_of_master = TempFile.find_all_by_master_id(MASTER_ID)
    delete_pj
    all_temp_file_of_master= TempFile.find_all_by_master_id(MASTER_ID)
    assert_equal all_temp_file_of_master, []
    logout
  end

  # Arbitrary PJ(s) are chosen and deleted from "PJ management" page.
  # Result record is deleted
  def test_033
    test_000
    login("root","root")
    all_subtasks = Subtask.find_all_by_task_id(TASK_ID)
    all_subtasks_ids = all_subtasks.map { |a_subtask| a_subtask.id }
    all_result_of_task = Result.find(:all, :conditions => [ "subtask_id IN (?)", all_subtasks_ids])
    assert_not_equal all_result_of_task, []
    delete_pj
    all_result_of_task= Result.find(:all, :conditions => [ "subtask_id IN (?)", all_subtasks_ids])
    assert_equal all_result_of_task, []
    logout
  end
  # Arbitrary PJ(s) are chosen and deleted from "PJ management" page.
  # Analyze log record is deleted
  def test_034
    test_000
    login("root","root")
    all_subtasks = Subtask.find_all_by_task_id(TASK_ID)
    all_subtasks_ids = all_subtasks.map { |a_subtask| a_subtask.id }
    all_analyze_log_of_task = AnalyzeLog.find(:all, :conditions => [ "subtask_id IN (?)", all_subtasks_ids])
    assert_not_equal all_analyze_log_of_task, []
    delete_pj
    all_analyze_log_of_task= AnalyzeLog.find(:all, :conditions => [ "subtask_id IN (?)", all_subtasks_ids])
    assert_equal all_analyze_log_of_task, []
    logout
  end


  # Arbitrary PJ(s) are chosen and deleted from "PJ management" page.
  # Analyze config record remains
  def test_035
    test_000
    login("root","root")
    all_analyze_log_of_task_before = AnalyzeConfig.find(:all)
    delete_pj
    all_analyze_log_of_task_after= AnalyzeConfig.find(:all)
    assert_equal all_analyze_log_of_task_before, all_analyze_log_of_task_after
    logout
  end

  # Arbitrary Pj(s) are chosen and deleted from "Pj management" page.
  # Analyze rule config record remains
  def test_036
    test_000
    login("root","root")
    all_analyze_rule_config_before = AnalyzeRuleConfig.find(:all)
    delete_pj
    all_analyze_rule_config_after= AnalyzeRuleConfig.find(:all)
    assert_equal all_analyze_rule_config_before, all_analyze_rule_config_after
    logout
  end


  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # Analyze config pjs record is deleted
  def test_037
    test_000
    login("root","root")
    all_analyze_config_pjs_before = AnalyzeConfigsPjs.find_all_by_pj_id(PJ_ID)
    assert_not_equal all_analyze_config_pjs_before, []
    delete_pj
    all_analyze_config_pjs_after= AnalyzeConfigsPjs.find_all_by_pj_id(PJ_ID)
    assert_equal all_analyze_config_pjs_after,[]
    logout
  end

  # Arbitrary Pj(s) are chosen and deleted from "Pj management" page.
  # Analyze rule config pjs record is deleted
  def test_038
    test_000
    login("root","root")
    all_analyze_rule_config_pjs_before = AnalyzeRuleConfigsPjs.find_all_by_pj_id(PJ_ID)
    assert_not_equal all_analyze_rule_config_pjs_before, []
    delete_pj
    all_analyze_rule_config_pjs_after= AnalyzeRuleConfigsPjs.find_all_by_pj_id(PJ_ID)
    assert_equal all_analyze_rule_config_pjs_after,[]
    logout
  end


  # Arbitrary Pj(s) are chosen and deleted from "Pj management" page.
  # Analyze config tasks record is deleted
  def test_039
    test_000
    login("root","root")
    all_analyze_config_task_before = AnalyzeConfigsTasks.find_all_by_task_id(TASK_ID)
    assert_not_equal all_analyze_config_task_before, []
    delete_pj
    all_analyze_config_task_after= AnalyzeConfigsTasks.find_all_by_task_id(TASK_ID)
    assert_equal all_analyze_config_task_after,[]
    logout
  end

  # Arbitrary Pj(s) are chosen and deleted from "Pj management" page.
  # Analyze rule config tasks record is deleted
  def test_040
    test_000
    login("root","root")
    all_analyze_rule_config_task_before = AnalyzeRuleConfigsTasks.find_all_by_task_id(TASK_ID)
    assert_not_equal all_analyze_rule_config_task_before, []
    delete_pj
    all_analyze_rule_config_task_after= AnalyzeRuleConfigsTasks.find_all_by_task_id(TASK_ID)
    assert_equal all_analyze_rule_config_task_after,[]
    logout
  end


  # Arbitrary PJ(s) are chosen and deleted from "PJ management" page.
  # Analyze config subtasks record is deleted
  def test_041
    test_000
    login("root","root")
    all_subtasks = Subtask.find_all_by_task_id(TASK_ID)
    all_subtasks_ids = all_subtasks.map { |a_subtask| a_subtask.id }
    all_analyze_config_subtask_before = AnalyzeConfigsSubtasks.find(:all, :conditions => [ "subtask_id IN (?)", all_subtasks_ids])
    assert_not_equal all_analyze_config_subtask_before, []
    delete_pj
    all_analyze_config_subtask_after= AnalyzeConfigsSubtasks.find(:all, :conditions => [ "subtask_id IN (?)", all_subtasks_ids])
    assert_equal all_analyze_config_subtask_after,[]
    logout
  end



  # Arbitrary Pj(s) are chosen and deleted from "Pj management" page.
  # Analyze rule config subtasks record is deleted
  def test_042
    test_000
    login("root","root")
    all_subtasks = Subtask.find_all_by_task_id(TASK_ID)
    all_subtasks_ids = all_subtasks.map { |a_subtask| a_subtask.id }
    all_analyze_rule_config_subtask_before = AnalyzeRuleConfigsSubtasks.find(:all, :conditions => [ "subtask_id IN (?)", all_subtasks_ids])
    assert_not_equal all_analyze_rule_config_subtask_before, []
    delete_pj
    all_analyze_rule_config_subtask_after= AnalyzeRuleConfigsSubtasks.find(:all, :conditions => [ "subtask_id IN (?)", all_subtasks_ids])
    assert_equal all_analyze_rule_config_subtask_after,[]
    logout
  end
end
