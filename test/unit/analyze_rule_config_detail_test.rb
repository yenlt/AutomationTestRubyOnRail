require File.dirname(__FILE__) + '/../test_helper'

class AnalyzeRuleConfigDetailTest < ActiveSupport::TestCase
  fixtures :users
  fixtures :privileges
  fixtures :privileges_users
  ##
  # Test levels()
  #
  # Input: N/A
  # Output: return [1,2,3]
  #
  def test_ut_t2_ars_ard_001
    assert_equal [1,2,3],AnalyzeRuleConfigDetail.levels
  end

  ##
  # Test find_by_rule_level()
  #
  # Input: find a rule level name of rule id 1
  # Output: return "normal"
  #
  def test_ut_t2_ars_ard_002
    ars_detail = AnalyzeRuleConfigDetail.find_by_rule_level(1)
    assert_equal ars_detail.level_name, "normal"
  end

  #
  # Input: find a rule level name of rule id 2
  # Output: return "high"
  #
  def test_ut_t2_ars_ard_003
    ars_detail = AnalyzeRuleConfigDetail.find_by_rule_level(2)
    assert_equal ars_detail.level_name, "high"
  end

  #
  # Input: find a rule level name of rule id 3
  # Output: return "critical"
  #
  def test_ut_t2_ars_ard_004
    ars_detail = AnalyzeRuleConfigDetail.find_by_rule_level(3)
    assert_equal ars_detail.level_name, "critical"
  end

  #
  # Input: find a rule level name of rule id 100
  # Output: return nil
  #
  def test_ut_t2_ars_ard_005
    ars_detail = AnalyzeRuleConfigDetail.find_by_rule_level(100)
    assert_nil ars_detail
  end

  ##
  # Test rule_number_list()
  #
  # Input: split up a string of number
  # Output: an array of list string number
  #
  def test_ut_t2_ars_ard_006
    ars_detail = AnalyzeRuleConfigDetail.find(:first)
    ars_detail.rule_numbers = "1,2,3,4,5"
    ars_detail.save
    assert_equal ars_detail.rule_number_list, ["1","2","3","4","5"]
  end

  ##
  # Test copy()
  #
  # Input: copy a selected ARS detail
  # Output: return a new ARS detail with a analyze_tool_id, rule_level, rule_numbers
  #         copy from the selected ARS detail
  #
  def test_ut_t2_ars_ard_007
    ars_detail = AnalyzeRuleConfigDetail.find(:first)
    new_ars_detail = AnalyzeRuleConfigDetail.create()
    new_ars_detail.copy(ars_detail)
    #new_ars_detail.save
    assert_equal ars_detail.analyze_tool_id ,new_ars_detail.analyze_tool_id
    assert_equal ars_detail.rule_level, new_ars_detail.rule_level
    assert_equal ars_detail.rule_numbers, new_ars_detail.rule_numbers
  end



end
