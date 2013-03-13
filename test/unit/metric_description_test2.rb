require File.dirname(__FILE__) + '/../test_helper'

class MetricDescriptionTest < ActiveSupport::TestCase
  fixtures :users
  fixtures :tasks
  fixtures :subtasks

  PJ_ID = 1
  METRIC_NAME = "STM33"
  METRIC_TYPE = "File"
  ANALYZE_TOOL_ID = 1
  THRESHOLD_2 = 10
  THRESHOLD_1 = 5
  ###########################################################################
  # Setup                                                                   #
  def create_a_metric_threshold
    threshold = MetricsThreshold.create(:pj_id => PJ_ID,
      :metric_name => METRIC_NAME,
      :metric_type => METRIC_TYPE,
      :analyze_tool_id => ANALYZE_TOOL_ID,
      :threshold_2 => THRESHOLD_2,
      :threshold_1 => THRESHOLD_1,
      :threshold2_compare_operator_id => 1,
      :threshold1_compare_operator_id => 1)
    return threshold
  end

  ###########################################################################
  # Test MetricDescription Model in [Metric Function Improvement]           #

  ## Test: self.get_smt_list(metric_names, metric_type, analyze_tools, order_field, order_direction, page)
  # Input: metric_names = nil
  # Output: return nil
  #
  def test_ut_t4_smt_mdm_001
    smt_list = MetricDescription.get_smt_list("","File","QAC")
    assert smt_list.blank?
  end
  # Input:+ metric_names = STTPP
  #       + analyze_tools = nil
  # Output: return blank array
  #
  def test_ut_t4_smt_mdm_002
    smt_list = MetricDescription.get_smt_list("STTPP","File","")
    assert smt_list.blank?
  end
  # Input:+ metric_names = STTPP
  #       + analyze_tools = [QAC]
  # Output: return the selected metric
  #
  def test_ut_t4_smt_mdm_003
    smt_list = MetricDescription.get_smt_list(["STTPP"],"File",["QAC"])
    assert_not_nil smt_list.size
  end
  # Input:+ metric_names = STTPP
  #       + analyze_tools = [QAC, QAC++]
  # Output: return 2 values of QAC and QAC++ in threshold list
  #
  def test_ut_t4_smt_mdm_004
    smt_list = MetricDescription.get_smt_list(["STTPP"],"File",["QAC","QAC++"])
    assert smt_list.size,2
  end
  # Input:+ metric_names = [STTPP,STCDN]
  #       + analyze_tools = [QAC, QAC++]
  # Output: return all values of metric base on selected analyze tools(QAC and QAC++) in threshold list
  #
  def test_ut_t4_smt_mdm_005
    smt_list = MetricDescription.get_smt_list(["STTPP","STCDN "],"File",["QAC","QAC++"])
    assert smt_list.size,4
  end
  # Input:+ metric_names = [STTPP,STCDN]
  #       + analyze_tools = [QAC, QAC++]
  #       + order_field = analyze_tool_id
  #       + order_direction = ASC
  # Output: return all SMT sorted by analyze_tool_id by ASC
  #
  def test_ut_t4_smt_mdm_006
    smt_list = MetricDescription.get_smt_list(["STTPP","STCDN "],"File",["QAC","QAC++"], "analyze_tool_id", "ASC")
    assert smt_list.size,4
    assert smt_list[0].analyze_tool_id <= smt_list[2].analyze_tool_id
  end
  # Input:+ metric_names = [STTPP,STCDN]
  #       + analyze_tools = [QAC, QAC++]
  #       + order_field = analyze_tool_id
  #       + order_direction = DESC
  # Output: return all SMT sorted by analyze_tool_id by DESC
  #
  def test_ut_t4_smt_mdm_007
    smt_list = MetricDescription.get_smt_list(["STTPP","STCDN "],"File",["QAC","QAC++"], "analyze_tool_id", "DESC")
    assert smt_list.size,4
    assert smt_list[0].analyze_tool_id >= smt_list[2].analyze_tool_id
  end
  # Input:+ metric_names = [STTPP,STCDN]
  #       + analyze_tools = [QAC, QAC++]
  #       + order_field = name
  #       + order_direction = ASC
  # Output: return all SMT sorted by name by ASC
  #
  def test_ut_t4_smt_mdm_008
    smt_list = MetricDescription.get_smt_list(["STTPP","STCDN "],"File",["QAC","QAC++"], "name", "ASC")
    assert smt_list.size,4
    assert smt_list[0].name <= smt_list[2].name
  end
  # Input:+ metric_names = [STTPP,STCDN]
  #       + analyze_tools = [QAC, QAC++]
  #       + order_field = name
  #       + order_direction = DESC
  # Output: return all SMT sorted by name by DESC
  #
  def test_ut_t4_smt_mdm_009
    smt_list = MetricDescription.get_smt_list(["STTPP","STCDN "],"File",["QAC","QAC++"], "name", "DESC")
    assert smt_list.size,4
    assert smt_list[0].name >= smt_list[2].name
  end
  # Input:+ metric_names = [STTPP,STCDN,STM33,STBME,STBMO,STFNC,STBMS,STBUG,STCCA,STCCB,STCCC]
  #       + analyze_tools = [QAC, QAC++]
  #       + page = nil
  # Output: all selected metrics of page 1 is displayed.
  #
  def test_ut_t4_smt_mdm_010
    metric_names = ["STTPP","STCDN","STM33","STBME","STBMO","STFNC","STBMS","STBUG","STCCA","STCCB","STCCC"]
    smt_list_0 = MetricDescription.get_smt_list(metric_names,"File",["QAC","QAC++"], "name", "DESC")
    smt_list_1 = MetricDescription.get_smt_list(metric_names,"File",["QAC","QAC++"], "name", "DESC",1)
    assert smt_list_0, smt_list_1
  end
  # Input:+ metric_names = [STTPP,STCDN,STM33,STBME,STBMO,STFNC,STBMS,STBUG,STCCA,STCCB,STCCC]
  #       + analyze_tools = [QAC, QAC++]
  #       + page = 1
  # Output: 10 values is displayed in each page.
  #
  def test_ut_t4_smt_mdm_011
    metric_names = ["STTPP","STCDN","STM33","STBME","STBMO","STFNC","STBMS","STBUG","STCCA","STCCB","STCCC"]
    smt_list = MetricDescription.get_smt_list(metric_names,"File",["QAC","QAC++"], "name", "DESC",1)
    assert smt_list.size, 10
  end
  # Input:+ metric_names = [STTPP,STCDN,STM33,STBME,STBMO,STFNC,STBMS,STBUG,STCCA,STCCB,STCCC]
  #       + analyze_tools = [QAC, QAC++]
  #       + page = out of size (10)
  # Output: No value is return.
  #
  def test_ut_t4_smt_mdm_012
    metric_names = ["STTPP","STCDN","STM33","STBME","STBMO","STFNC","STBMS","STBUG","STCCA","STCCB","STCCC"]
    smt_list = MetricDescription.get_smt_list(metric_names,"File",["QAC","QAC++"], "name", "DESC",10)
    assert smt_list.blank?
  end
  # Input:+ selected metrics has 'String' data type
  #       + analyze_tools = [QAC, QAC++]
  # Output: No value is return.
  #
  def test_ut_t4_smt_mdm_013
    metric_names = ["STMCC"]
    smt_list = MetricDescription.get_smt_list(metric_names,"Func",["QAC","QAC++"])
    assert smt_list.blank?
  end

  ## Test: threshold2(pj_id)
  # Input:
  # Output:
  def test_ut_t4_smt_mdm_014
    create_a_metric_threshold
    metric_description = MetricDescription.find(:first,
      :conditions => { :name => METRIC_NAME,
        :metric_type => METRIC_TYPE,
        :analyze_tool_id => ANALYZE_TOOL_ID})
    assert metric_description.threshold2(PJ_ID)
  end
  ## Test: threshold1(pj_id)
  # Input:
  # Output:
  def test_ut_t4_smt_mdm_015
    create_a_metric_threshold
    metric_description = MetricDescription.find(:first,
      :conditions => { :name => METRIC_NAME,
        :metric_type => METRIC_TYPE,
        :analyze_tool_id => ANALYZE_TOOL_ID})
    assert metric_description.threshold1(PJ_ID)
  end
  ###########################################################################
end