require File.dirname(__FILE__) + '/../test_helper'

class AnalyzeToolTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  ### Start test analyze_tools Task 3 - 2011A001

  ## Test self.all_analyze_tools()
  #
  # Input:  All analyze tools are enabled.
  #         Call all_analyze_tools function.
  # Output: Return all analyze tools from analyze_tools table.
  def test_uts_at_m_001
    all = AnalyzeTool.find(:all)
    all.each do |tool|
      tool.in_use = true
      tool.save
    end unless all.blank?
    #
    analyze_tools = AnalyzeTool.all_analyze_tools
    assert !analyze_tools.blank?
    assert_equal all.size,analyze_tools.size
  end
  # Input: Some analyze tools are enabled. (C++Test, PGRelief).
  #        Call all_analyze_tools function.
  # Output: Return all enabled analyze tools.
  def test_uts_at_m_002
    tool_ids = [3,4]
    #
    all = AnalyzeTool.find(:all)
    all.each do |tool|
      if tool_ids.include?(tool.id)
        tool.in_use = true
      else
        tool.in_use = false
      end
      tool.save
    end unless all.blank?
    #
    analyze_tools = AnalyzeTool.all_analyze_tools
    assert !analyze_tools.blank?
    assert_equal 2,analyze_tools.size
    analyze_tools.each do |tool|
      assert tool_ids.include?(tool.id)
    end
  end
  # Input: No analyze tool is enabled.
  #        Call all_analyze_tools function.
  # Output: Return all enabled analyze tools.
  def test_uts_at_m_003
    all = AnalyzeTool.find(:all)
    all.each do |tool|
      tool.in_use = false
      tool.save
    end unless all.blank?
    #
    analyze_tools = AnalyzeTool.all_analyze_tools
    assert analyze_tools.blank?
  end
  ## Test self.no_analyze_tools?()
  #
  # Input: No analyze tool is enabled.
  #        Call no_analyze_tool? function.
  # Output: Return true.
  def test_uts_at_m_004
    all = AnalyzeTool.find(:all)
    all.each do |tool|
      tool.in_use = false
      tool.save
    end unless all.blank?
    #
    assert AnalyzeTool.no_analyze_tool?
  end
  # Input: Some analyze tools is enabled.
  #        Call no_analyze_tool? function.
  # Output: Return false.
  def test_uts_at_m_005
    tool_ids = [1,4]
    #
    all = AnalyzeTool.find(:all)
    all.each do |tool|
      if tool_ids.include?(tool.id)
        tool.in_use = true
      else
        tool.in_use = false
      end
      tool.save
    end unless all.blank?
    #
    assert !AnalyzeTool.no_analyze_tool?
  end
  # Input: All analyze tools are enabled.
  #        Call no_analyze_tool? function.
  # Output: Return false.
  def test_uts_at_m_006
    all = AnalyzeTool.find(:all)
    all.each do |tool|
      tool.in_use = true
      tool.save
    end unless all.blank?
    #
    assert !AnalyzeTool.no_analyze_tool?
  end
  ## Test self.all_analyze_tools_with_metrics()
  #
  # Input: No analyze tool is enabled.
  #        Call all_analyze_tools_with_metrics function.
  # Output: Return blank array.
  def test_uts_at_m_007
    all = AnalyzeTool.find(:all)
    all.each do |tool|
      tool.in_use = false
      tool.save
    end unless all.blank?
    #
    assert AnalyzeTool.all_analyze_tools_with_metrics.blank?
  end
  # Input:  Only C++Test is enabled.
  #         Call all_analyze_tools_with_metrics function.
  # Output: Return blank array.
  def test_uts_at_m_008
    tool_ids = [4]
    #
    all = AnalyzeTool.find(:all)
    all.each do |tool|
      if tool_ids.include?(tool.id)
        tool.in_use = true
      else
        tool.in_use = false
      end
      tool.save
    end unless all.blank?
    #
    assert AnalyzeTool.all_analyze_tools_with_metrics.blank?
  end
  # Input: Some analyze tools are enabled.
  #        C++Test is enabled.
  #        Call all_analyze_tools_with_metrics function.
  # Output: Return an array of all enabled analyze tools except C++Test
  def test_uts_at_m_009
    tool_ids = [1,2,4]
    #
    all = AnalyzeTool.find(:all)
    all.each do |tool|
      if tool_ids.include?(tool.id)
        tool.in_use = true
      else
        tool.in_use = false
      end
      tool.save
    end unless all.blank?
    #
    analyze_tools = AnalyzeTool.all_analyze_tools_with_metrics
    #
    assert_equal 2,analyze_tools.size
    analyze_tools.each do |tool|
      assert tool_ids.include?(tool.id)
      assert_not_equal 4,tool.id
    end
  end
  # Input: Some analyze tools are enabled.
  #        C++Test is not enabled.
  #        Call all_analyze_tools_with_metrics function.
  # Output: Return an array of all enabled analyze tools.
  def test_uts_at_m_010
    tool_ids = [1,2,3]
    #
    all = AnalyzeTool.find(:all)
    all.each do |tool|
      if tool_ids.include?(tool.id)
        tool.in_use = true
      else
        tool.in_use = false
      end
      tool.save
    end unless all.blank?
    #
    analyze_tools = AnalyzeTool.all_analyze_tools_with_metrics
    #
    assert_equal 3,analyze_tools.size
    analyze_tools.each do |tool|
      assert tool_ids.include?(tool.id)
    end
  end
  # Input: All analyze tools are enabled.
  #        Call all_analyze_tools_with_metrics function.
  # Output: Return an array of all enabled analyze tools except C++Test
  def test_uts_at_m_011
    all = AnalyzeTool.find(:all)
    all.each do |tool|
      tool.in_use = true
      tool.save
    end unless all.blank?
    #
    analyze_tools = AnalyzeTool.all_analyze_tools_with_metrics
    #
    assert_equal 3,analyze_tools.size
  end
  ## Test self.in_use?(tool_id) function
  #
  # Input: Selected analyze tool is enabled.
  #        Call self.in_use?(tool_id) function.
  # Output: Return true
  #
  def test_uts_at_m_012
    tool_id = 4
    tool = AnalyzeTool.find_by_id(tool_id)
    tool.in_use = true
    tool.save
    #
    assert AnalyzeTool.in_use?(tool_id)
  end
  # Input: Selected analyze tool is not enabled.
  #        Call self.in_use?(tool_id) function.
  # Output: Return false
  #
  def test_uts_at_m_013
    tool_id = 4
    tool = AnalyzeTool.find_by_id(tool_id)
    tool.in_use = false
    tool.save
    #
    assert !AnalyzeTool.in_use?(tool_id)
  end
  # Input: Call self.in_use?(tool_id) function for a nil tool id
  # Output: Return false
  #
  def test_uts_at_m_014 # Bug
    assert !AnalyzeTool.in_use?(nil)
  end
  # Input: Call self.in_use?(tool_id) function for a tool id which is not existed.
  # Output: Return false
  #
  def test_uts_at_m_015 # Bug
    tool_id = 10000
    assert !AnalyzeTool.in_use?(tool_id)
  end
  ##############################################################################
  # Test other un-tested functions                                             #

  ## Test self.tool_name(tool_id)
  #
  # Input: Get self.tool_name(4)
  # Output: Return C++Test name
  def test_uts_at_m_016
    assert AnalyzeTool.tool_name(4),"cpptest"
  end
  # Input: Get self.tool_name(nil)
  # Output: Return nil
  def test_uts_at_m_017 # Bug
    assert !AnalyzeTool.tool_name(nil)
  end
  # Input: Get self.tool_name(1000) *An ID of no analyze tool
  # Output: Return nil
  def test_uts_at_m_018 # Bug
    assert !AnalyzeTool.tool_name(1000)
  end
  ## Test self.tool_id(name)
  #
  # Input: Get self.tool_id("cpptest")
  # Output: Return C++Test ID
  def test_uts_at_m_019
    assert AnalyzeTool.tool_id("C++Test"),4
  end
  # Input: Get self.tool_id(nil)
  # Output: Return nil
  def test_uts_at_m_020 # Bug
    assert !AnalyzeTool.tool_id(nil)
  end
  # Input: Get self.tool_id("wrong name")
  # Output: Return nil
  def test_uts_at_m_021 # Bug
    assert !AnalyzeTool.tool_id("wrong name")
  end
  ## Test self.method_missing(method_name, *args, &block)
  #
  # Input: Get AnalyzeTool.qac
  # Output: Return all information of QAC tool
  def test_uts_at_m_022
    qac_tool = AnalyzeTool.find(1)
    assert AnalyzeTool.qac,qac_tool
  end
  # Input: Get AnalyzeTool.qacpp
  # Output: Return all information of QAC++ tool
  def test_uts_at_m_023
    qacpp_tool = AnalyzeTool.find(2)
    assert AnalyzeTool.qacpp,qacpp_tool
  end
  # Input: Get AnalyzeTool.pgr
  # Output: Return all information of PGRelief tool
  def test_uts_at_m_024
    pgr_tool = AnalyzeTool.find(3)
    assert AnalyzeTool.pgr,pgr_tool
  end
  # Input: Get AnalyzeTool.cpptest
  # Output: Return all information of C++Test tool
  def test_uts_at_m_025
    cpptest_tool = AnalyzeTool.find(4)
    assert AnalyzeTool.cpptest,cpptest_tool
  end
  ### End test analyze_tools Task 3 - 2011A001
end
