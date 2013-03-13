require File.dirname(__FILE__) + "/test_m_setup" unless defined? TestMSetup
#require "test/unit"
class TestM1 < Test::Unit::TestCase
  include TestMSetup
  #This not a test
  def test_001
    assert true
  end
  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # PJ record is deleted.
  def test_002
    test_000
    login("root","root")
    pj_of_pu = Pj.find_all_by_pu_id(PU_ID)
    assert_not_equal pj_of_pu,[]
    delete_pu
    pj_of_pu = Pj.find_all_by_pu_id(PU_ID)
    assert_equal pj_of_pu,[]
    logout
  end
  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # all Pu users record is deleted.
  def test_003
    test_000
    login("root","root")
    all_members_of_pu = PusUsers.find_all_by_pu_id(PU_ID)
    assert_not_equal all_members_of_pu,[]
    delete_pu
    all_members_of_pu = PusUsers.find_all_by_pu_id(PU_ID)
    assert_equal all_members_of_pu,[]
    logout
  end
  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # PJ Users record is deleted.
  def test_004
    test_000
    login("root","root")
    all_pj_mem = PjsUsers.find_all_by_pj_id(PJ_ID)
    sleep WAIT_TIME
    assert_not_equal all_pj_mem, []
    delete_pu
    pj_mem = PjsUsers.find_all_by_pj_id(PJ_ID)
    sleep WAIT_TIME
    begin
      assert_equal pj_mem, []
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
  end
  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # PrivilegesUsers is deleted
  def test_005
    test_000
    login("root","root")
    privilege_users_of_pu = PrivilegesUsers.find_all_by_pu_id(PU_ID)
    assert_not_equal privilege_users_of_pu,[]
    delete_pu
    privilege_users_of_pu = PrivilegesUsers.find_all_by_pu_id(PU_ID)
    begin
      assert_equal privilege_users_of_pu,[]
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
  end
  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # Master record is deleted
  def test_006
    test_000
    login("root","root")
    all_masters_of_pj = Master.find_all_by_pj_id(PJ_ID)
    assert_not_equal all_masters_of_pj,[]
    delete_pu
    all_masters_of_pj = Master.find_all_by_pj_id(PJ_ID)
    begin
      assert_equal all_masters_of_pj,[]
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
  end
  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # Task record is deleted
  def test_007
    test_000
    login("root","root")
    all_task_of_pj = Task.find_all_by_pj_id(PJ_ID)
    assert_not_equal all_task_of_pj,[]
    delete_pu
    all_task_of_pj = Task.find_all_by_pj_id(PJ_ID)
    assert_equal all_task_of_pj,[]
    logout
  end
  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # Subtask record is deleted
  def test_008
    test_000
    login("root","root")
    all_subtasks = Subtask.find_all_by_task_id(TASK_ID)
    assert_not_equal all_subtasks, []
    delete_pu
    all_subtasks = Subtask.find_all_by_task_id(TASK_ID)
    assert_equal all_subtasks, []
    logout
  end
  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # Segment record is deleted
  def test_009
    test_000
    login("root","root")
    all_segments_of_master = Segment.find_all_by_fk_id(MASTER_ID)
    assert_not_equal all_segments_of_master, []
    delete_pu
    all_segments_of_master = Segment.find_all_by_fk_id(MASTER_ID)
    assert_equal all_segments_of_master, []
    logout
  end
  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # Directory tree record is deleted
  def test_010
    test_000
    login("root","root")
    all_directory_tree_of_master = DirectoryTree.find_all_by_fk_id(MASTER_ID)
    assert_not_equal all_directory_tree_of_master, []
    delete_pu
    all_directory_tree_of_master= DirectoryTree.find_all_by_fk_id(MASTER_ID)
    assert_equal all_directory_tree_of_master, []
    logout
  end

  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # Temp file record is deleted
  def test_011
    test_000
    login("root","root")
    all_temp_file_of_master = TempFile.find_all_by_master_id(MASTER_ID)
    delete_pu
    all_temp_file_of_master= TempFile.find_all_by_master_id(MASTER_ID)
    assert_equal all_temp_file_of_master, []
    logout
  end

  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # Result record is deleted
  def test_012
    test_000
    login("root","root")
    all_subtasks = Subtask.find_all_by_task_id(TASK_ID)
    all_subtasks_ids = all_subtasks.map { |a_subtask| a_subtask.id }
    all_result_of_task = Result.find(:all, :conditions => [ "subtask_id IN (?)", all_subtasks_ids])
    assert_not_equal all_result_of_task, []
    delete_pu
    all_result_of_task= Result.find(:all, :conditions => [ "subtask_id IN (?)", all_subtasks_ids])
    assert_equal all_result_of_task, []
    logout
  end
  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # Analyze log record is deleted
  def test_013
    test_000
    login("root","root")
    all_subtasks = Subtask.find_all_by_task_id(TASK_ID)
    all_subtasks_ids = all_subtasks.map { |a_subtask| a_subtask.id }
    all_analyze_log_of_task = AnalyzeLog.find(:all, :conditions => [ "subtask_id IN (?)", all_subtasks_ids])
    assert_not_equal all_analyze_log_of_task, []
    delete_pu
    all_analyze_log_of_task= AnalyzeLog.find(:all, :conditions => [ "subtask_id IN (?)", all_subtasks_ids])
    assert_equal all_analyze_log_of_task, []
    logout
  end

  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # Analyze config record remains
  def test_014
    test_000
    login("root","root")
    all_analyze_log_of_task_before = AnalyzeConfig.find(:all)
    delete_pu
    all_analyze_log_of_task_after= AnalyzeConfig.find(:all)
    assert_equal all_analyze_log_of_task_before, all_analyze_log_of_task_after
    logout
  end

  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # Analyze rule config record remains
  def test_015
    test_000
    login("root","root")
    all_analyze_rule_config_before = AnalyzeRuleConfig.find(:all)
    delete_pu
    all_analyze_rule_config_after= AnalyzeRuleConfig.find(:all)
    assert_equal all_analyze_rule_config_before, all_analyze_rule_config_after
    logout
  end


  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # Analyze config pus record is deleted
  def test_016
    test_000
    login("root","root")
    all_analyze_config_pus_before = AnalyzeConfigsPus.find_all_by_pu_id(PU_ID)
    assert_not_equal all_analyze_config_pus_before, []
    delete_pu
    all_analyze_config_pus_after= AnalyzeConfigsPus.find_all_by_pu_id(PU_ID)
    assert_equal all_analyze_config_pus_after,[]
    logout
  end



  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # Analyze config pjs record is deleted
  def test_017
    test_000
    login("root","root")
    all_analyze_config_pjs_before = AnalyzeConfigsPjs.find_all_by_pj_id(PJ_ID)
    assert_not_equal all_analyze_config_pjs_before, []
    delete_pu
    all_analyze_config_pjs_after= AnalyzeConfigsPjs.find_all_by_pj_id(PJ_ID)
    assert_equal all_analyze_config_pjs_after,[]
    logout
  end


  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # Analyze rule config pus record is deleted
  def test_018
    test_000
    login("root","root")
    all_analyze_rule_config_pus_before = AnalyzeRuleConfigsPus.find_all_by_pu_id(PU_ID)
    assert_not_equal all_analyze_rule_config_pus_before, []
    delete_pu
    all_analyze_rule_config_pus_after= AnalyzeRuleConfigsPus.find_all_by_pu_id(PU_ID)
    assert_equal all_analyze_rule_config_pus_after,[]
    logout
  end



  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # Analyze rule config pjs record is deleted
  def test_019
    test_000
    login("root","root")
    all_analyze_rule_config_pjs_before = AnalyzeRuleConfigsPjs.find_all_by_pj_id(PJ_ID)
    assert_not_equal all_analyze_rule_config_pjs_before, []
    delete_pu
    all_analyze_rule_config_pjs_after= AnalyzeRuleConfigsPjs.find_all_by_pj_id(PJ_ID)
    assert_equal all_analyze_rule_config_pjs_after,[]
    logout
  end



  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # Analyze config tasks record is deleted
  def test_020
    test_000
    login("root","root")
    all_analyze_config_task_before = AnalyzeConfigsTasks.find_all_by_task_id(TASK_ID)
    assert_not_equal all_analyze_config_task_before, []
    delete_pu
    all_analyze_config_task_after= AnalyzeConfigsTasks.find_all_by_task_id(TASK_ID)
    assert_equal all_analyze_config_task_after,[]
    logout
  end



  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # Analyze rule config tasks record is deleted
  def test_021
    test_000
    login("root","root")
    all_analyze_rule_config_task_before = AnalyzeRuleConfigsTasks.find_all_by_task_id(TASK_ID)
    assert_not_equal all_analyze_rule_config_task_before, []
    delete_pu
    all_analyze_rule_config_task_after= AnalyzeRuleConfigsTasks.find_all_by_task_id(TASK_ID)
    assert_equal all_analyze_rule_config_task_after,[]
    logout
  end


  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # Analyze config subtasks record is deleted
  def test_022
    test_000
    login("root","root")
    all_subtasks = Subtask.find_all_by_task_id(TASK_ID)
    all_subtasks_ids = all_subtasks.map { |a_subtask| a_subtask.id }
    all_analyze_config_subtask_before = AnalyzeConfigsSubtasks.find(:all, :conditions => [ "subtask_id IN (?)", all_subtasks_ids])
    assert_not_equal all_analyze_config_subtask_before, []
    delete_pu
    all_analyze_config_subtask_after= AnalyzeConfigsSubtasks.find(:all, :conditions => [ "subtask_id IN (?)", all_subtasks_ids])
    assert_equal all_analyze_config_subtask_after,[]
    logout
  end


  # Arbitrary PU(s) are chosen and deleted from "PU management" page.
  # Analyze rule config subtasks record is deleted
  def test_023
    test_000
    login("root","root")
    all_subtasks = Subtask.find_all_by_task_id(TASK_ID)
    all_subtasks_ids = all_subtasks.map { |a_subtask| a_subtask.id }
    all_analyze_rule_config_subtask_before = AnalyzeRuleConfigsSubtasks.find(:all, :conditions => [ "subtask_id IN (?)", all_subtasks_ids])
    assert_not_equal all_analyze_rule_config_subtask_before, []
    delete_pu
    all_analyze_rule_config_subtask_after= AnalyzeRuleConfigsSubtasks.find(:all, :conditions => [ "subtask_id IN (?)", all_subtasks_ids])
    assert_equal all_analyze_rule_config_subtask_after,[]
    logout
  end

end
