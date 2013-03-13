require File.dirname(__FILE__) + '/../test_helper'

class MetricsThresholdTest < ActiveSupport::TestCase
  fixtures :users
  fixtures :tasks
  fixtures :subtasks
  fixtures :metrics_thresholds
  
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
  #
  def create_float_metric_threshold
    threshold = MetricsThreshold.create(:pj_id => PJ_ID,
      :metric_name => "STMOB",
      :metric_type => METRIC_TYPE,
      :analyze_tool_id => ANALYZE_TOOL_ID,
      :threshold_2 => THRESHOLD_2,
      :threshold_1 => THRESHOLD_1,
      :threshold2_compare_operator_id => 1,
      :threshold1_compare_operator_id => 1)
    return threshold
  end

  ############################################################################
  # Test MetricsThreshold Model in [Metric Function Improvement]             #
  
  ## Test validate_on_create function (Those test cases also test: + reset_data
  #                                                                + validate_item
  #                                                                + valid_data(threshold)
  #                                                                + valid_integer?(str)
  #                                                                + valid_fload?(str))
  #  Point to test: The valid of threshold 2
  #  Input: + Invalid threshold 2 value is inputed.
  #         + Request to save metric threshold.
  #  Output: Unable to save metric threshold with invalid data.
  #
  def test_ut_t4_smt_mtm_001
    metric_threshold = MetricsThreshold.new(:metric_name => METRIC_NAME,
      :pj_id => PJ_ID,
      :metric_type => METRIC_TYPE,
      :analyze_tool_id => ANALYZE_TOOL_ID,
      :threshold_2 => "abc")
    assert !metric_threshold.save
  end
  #  Point to test: The valid of threshold 1
  #  Input: + Invalid threshold 1 value is inputed.
  #         + Request to save metric threshold.
  #  Output: Unable to save metric threshold with invalid data.
  #
  def test_ut_t4_smt_mtm_002
    metric_threshold = MetricsThreshold.new(:metric_name => METRIC_NAME,
      :pj_id => PJ_ID,
      :metric_type => METRIC_TYPE,
      :analyze_tool_id => ANALYZE_TOOL_ID,
      :threshold_1 => "abc")
    assert !metric_threshold.save
  end
  #  Point to test: The valid of threshold 2 and 1
  #  Input: + Invalid threshold 2 and 1 value is inputed.
  #         + Request to save metric threshold.
  #  Output: Unable to save metric threshold with invalid data.
  #
  def test_ut_t4_smt_mtm_003
    metric_threshold = MetricsThreshold.new(:metric_name => METRIC_NAME,
      :pj_id => PJ_ID,
      :metric_type => METRIC_TYPE,
      :analyze_tool_id => ANALYZE_TOOL_ID,
      :threshold_2 => "abc",
      :threshold_1 => "def")
    assert !metric_threshold.save
  end
  #  Point to test: Unable to save when the metrics is not existed.
  #  Input: + Threshold 2 and 1 value is inputed.
  #         + Request to save metric threshold.
  #  Output: Unable to save metric threshold with invalid selected metrics.
  #
  def test_ut_t4_smt_mtm_004
    metric_threshold = MetricsThreshold.new(:metric_name => "METRIC_NAME",
      :pj_id => PJ_ID,
      :metric_type => METRIC_TYPE,
      :analyze_tool_id => ANALYZE_TOOL_ID,
      :threshold_2 => 1,
      :threshold_1 => 2)
    assert !metric_threshold.save
  end
  #  Point to test: Able to save when no threshold value is inputted.
  #  Input: + Threshold 2 and 1 value is not inputed.
  #         + Request to save metric threshold.
  #  Output: Metrics threshold is created.
  #
  def test_ut_t4_smt_mtm_005
    metric_threshold = MetricsThreshold.new(:metric_name => METRIC_NAME,
      :pj_id => PJ_ID,
      :metric_type => METRIC_TYPE,
      :analyze_tool_id => ANALYZE_TOOL_ID,
      :threshold1_compare_operator_id => 2,
      :threshold2_compare_operator_id => 2)
    assert metric_threshold.save
  end
  #  Point to test: Able to save when one threshold value is inputted.
  #  Input: + Threshold 1 value is inputed.
  #         + Request to save metric threshold.
  #  Output: Metrics threshold is created.
  #
  def test_ut_t4_smt_mtm_006
    metric_threshold = MetricsThreshold.new(:metric_name => METRIC_NAME,
      :pj_id => PJ_ID,
      :metric_type => METRIC_TYPE,
      :analyze_tool_id => ANALYZE_TOOL_ID,
      :threshold1_compare_operator_id => 2,
      :threshold2_compare_operator_id => 2,
      :threshold_1 => 2)
    assert metric_threshold.save
    assert_equal MetricsThreshold.find(metric_threshold.id).threshold_1.to_s , "2"
  end
  #  Point to test: When a threshold value is nil, the associated compare operator id is reset to 1
  #  Input: + Threshold 1 value is nil.
  #         + Request to save metric threshold.
  #  Output: Metrics threshold is created. The associated compare operator id is reset to 1.
  #
  def test_ut_t4_smt_mtm_007
    metric_threshold = MetricsThreshold.new(:metric_name => METRIC_NAME,
      :pj_id => PJ_ID,
      :metric_type => METRIC_TYPE,
      :analyze_tool_id => ANALYZE_TOOL_ID,
      :threshold1_compare_operator_id => 2,
      :threshold2_compare_operator_id => 2,
      :threshold_1 => "")
    assert metric_threshold.save
    assert_equal MetricsThreshold.find(metric_threshold.id).threshold1_compare_operator_id.to_s , "1"
  end

  ## Test validate_on_update function (Those test cases also test: + reset_data
  #                                                                + validate_item
  #                                                                + valid_data(threshold)
  #                                                                + valid_integer?(str)
  #                                                                + valid_fload?(str))
  #  Point to test: The valid of threshold 2
  #  Input: + Invalid threshold 2 value is inputed.
  #         + Request to save metric threshold.
  #  Output: Unable to update metric threshold with invalid data.
  #
  def test_ut_t4_smt_mtm_008
    threshold = create_a_metric_threshold
    metric_threshold = MetricsThreshold.find(threshold.id)
    metric_threshold.threshold_2 = "abc"
    assert !metric_threshold.save
  end
  #  Point to test: The valid of threshold 1
  #  Input: + Invalid threshold 1 value is inputed.
  #         + Request to save metric threshold.
  #  Output: Unable to update metric threshold with invalid data.
  #
  def test_ut_t4_smt_mtm_009
    threshold = create_a_metric_threshold
    metric_threshold = MetricsThreshold.find(threshold.id)
    metric_threshold.threshold_1 = "abc"
    assert !metric_threshold.save
  end
  #  Point to test: The valid of threshold 2 and 1
  #  Input: + Invalid threshold 2 and 1 value is inputed.
  #         + Request to save metric threshold.
  #  Output: Unable to update metric threshold with invalid data.
  #
  def test_ut_t4_smt_mtm_010
    threshold = create_a_metric_threshold
    metric_threshold = MetricsThreshold.find(threshold.id)
    metric_threshold.threshold_2 = "abc"
    metric_threshold.threshold_1 = "def"
    assert !metric_threshold.save
  end
  #  Point to test: Able to save when no threshold value is inputted.
  #  Input: + Threshold 2 and 1 value is not inputed.
  #         + Request to save metric threshold.
  #  Output: Metrics threshold is updated.
  #
  def test_ut_t4_smt_mtm_011
    threshold = create_a_metric_threshold
    metric_threshold = MetricsThreshold.find(threshold.id)
    metric_threshold.threshold_2 = ""
    metric_threshold.threshold_1 = ""
    assert metric_threshold.save
  end
  #  Point to test: Able to save when one threshold value is inputted.
  #  Input: + Threshold 1 value is inputed.
  #         + Request to save metric threshold.
  #  Output: Metrics threshold is updated.
  #
  def test_ut_t4_smt_mtm_012
    threshold = create_float_metric_threshold
    metric_threshold = MetricsThreshold.find(threshold.id)
    metric_threshold.threshold_2 = 12
    metric_threshold.threshold_1 = 23
    assert metric_threshold.save
    assert_equal MetricsThreshold.find(metric_threshold.id).threshold_1.to_s , "23"
    assert_equal MetricsThreshold.find(metric_threshold.id).threshold_2.to_s , "12"
  end
  #  Point to test: When a threshold value is nil, the associated compare operator id is reset to 1
  #  Input: + Threshold 1 value is nil.
  #         + Request to save metric threshold.
  #  Output: Metrics threshold is update. The associated compare operator id is reset to 1.
  #
  def test_ut_t4_smt_mtm_013
    threshold = create_float_metric_threshold
    metric_threshold = MetricsThreshold.find(threshold.id)
    metric_threshold.threshold_1 = ""
    assert metric_threshold.save
    assert_equal MetricsThreshold.find(metric_threshold.id).threshold1_compare_operator_id.to_s , "1"
  end

  ## Test analyze_tool_name(analyze_tool_id)
  # Point to test: Get the right name of the analyze tool
  # Input: input a analyze tool id
  # Output: the right name of the inputed analyze tool id
  #
  def test_ut_t4_smt_mtm_014
    threshold = create_a_metric_threshold
    analyze_name = threshold.analyze_tool_name(1)
    assert_equal analyze_name, "QAC"
    analyze_name = threshold.analyze_tool_name(2)
    assert_equal analyze_name, "QAC++"
    analyze_name = threshold.analyze_tool_name(3)
    assert_equal analyze_name, "PGRelief"
  end
  # Point to test: Input no analyze tool id
  # Input: input no analyze tool id
  # Output: Return nil.
  #
  def test_ut_t4_smt_mtm_015
    threshold = create_a_metric_threshold
    analyze_name = threshold.analyze_tool_name("")
    assert analyze_name.blank?
  end
  # Point to test: Input a wrong number of analyze tool id
  # Input: input a wrong analyze tool id
  # Output: Return nil.
  #
  def test_ut_t4_smt_mtm_016
    threshold = create_a_metric_threshold
    analyze_name = threshold.analyze_tool_name(100)
    assert analyze_name.blank?
  end
  ## Test data_type
  # Point to test: Get the right name of the data type
  # Input:  + Select a metric threshold.
  #         + Request to get the data type of the selected metrics threshold.
  # Output: Return the right data type of the selected metrics threshold.
  #
  def test_ut_t4_smt_mtm_017
    threshold = create_a_metric_threshold
    assert threshold.data_type
  end
  ## Test match_threshold?(value) (Also test : + matched?(comp_id,threshold_id,value)
  #                                            + get_value(value) )
  # Point to test: No threshold is set.
  # Input:  + No threshold is set for the selected metrics
  # Output: Return 0 (Normal)
  #
  def test_ut_t4_smt_mtm_018
    threshold = create_a_metric_threshold
    threshold.threshold_1 = ""
    threshold.threshold_2 = ""
    threshold.save
    #
    assert_equal threshold.match_threshold?(THRESHOLD_2),0
  end
  # Point to test: Flow of checking threshold 2,1
  # Input:  + Threshold 2 vs 1 are set.
  #         + The metric value is matched with threshold 2
  # Output: Return 2 (Red)
  #
  def test_ut_t4_smt_mtm_019
    threshold = create_a_metric_threshold
    #
    value = THRESHOLD_2 - 2
    assert_equal threshold.match_threshold?(value),2
  end
  # Point to test: Flow of checking threshold 2,1
  # Input:  + Threshold 2 vs 1 are set.
  #         + The metric value is matched with also threshold 1 and 2
  # Output: Return 2 (Red)
  #
  def test_ut_t4_smt_mtm_020
    threshold = create_a_metric_threshold
    #
    value = THRESHOLD_1 - 1
    assert_equal threshold.match_threshold?(value),2
  end
  # Point to test: Flow of checking threshold 2,1
  # Input:  + Threshold 2 vs 1 are set.
  #         + The metric value is matched with threshold 1 but not with threshold 2
  # Output: Return 1 (Yellow)
  #
  def test_ut_t4_smt_mtm_021
    threshold = create_a_metric_threshold
    threshold.threshold2_compare_operator_id = 3
    threshold.save
    #
    value = THRESHOLD_1 - 1
    assert_equal threshold.match_threshold?(value),1
  end
  # Point to test: Flow of checking threshold 2,1
  # Input:  + Threshold 2 vs 1 are set.
  #         + The metric value is not matched with any threshold
  # Output: Return 0 (Normal)
  #
  def test_ut_t4_smt_mtm_022
    threshold = create_a_metric_threshold
    #
    value = THRESHOLD_2 + 2
    assert_equal threshold.match_threshold?(value),0
  end
  # Point to test: Flow of checking threshold 2,1
  # Input:  + Threshold 1 is set. Threshold 2 is blank.
  #         + The metric value is not matched with any threshold
  # Output: Return 0 (Normal)
  #
  def test_ut_t4_smt_mtm_023
    threshold = create_a_metric_threshold
    threshold.threshold_2 = ""
    threshold.save
    #
    value = THRESHOLD_1 + 2
    assert_equal threshold.match_threshold?(value),0
  end
  # Point to test: Flow of checking threshold 2,1
  # Input:  + Threshold 1 is set. Threshold 2 is blank.
  #         + The metric value is matched with threshold 1
  # Output: Return 1 (Yellow)
  #
  def test_ut_t4_smt_mtm_024
    threshold = create_float_metric_threshold
    threshold.threshold_2 = ""
    threshold.save
    #
    value = THRESHOLD_1 - 2.1
    assert_equal threshold.match_threshold?(value),1
  end
  # Point to test: Flow of checking threshold 2,1
  # Input:  + Threshold 2 is set. Threshold 1 is blank.
  #         + The metric value is not matched with threshold 2
  # Output: Return 0 (Normal)
  #
  def test_ut_t4_smt_mtm_025
    threshold = create_float_metric_threshold
    threshold.threshold_1 = ""
    threshold.save
    #
    value = THRESHOLD_2 + 2.14
    assert_equal threshold.match_threshold?(value),0
  end
  ############################################################################
end