require File.dirname(__FILE__) + '/../test_helper'
require 'json'

class MetricCacheManagerTest < ActiveSupport::TestCase
  #
  #
  #
  def test_ut_t6_mvf_mda_001
    #
    task_id = 5
    metric_type = "class"
    metric_name = "STMTH"
    selected_file_ids = nil
    order_setting = nil
    limit_setting = nil
    other_setting = [order_setting, limit_setting]
    data = MetricCacheManager.get_metric_data(task_id, metric_type, metric_name, selected_file_ids, other_setting)
    p data
    assert_not_equal data, nil
  end
  #
  #
  #
  def test_ut_t6_mvf_mda_002
    #
    task_id = 5
    metric_type = "class"
    metric_name = "STMTH"
    selected_file_ids =  [332]
    order_setting = "DESC"
    limit_setting = "10"
    other_setting = [order_setting, limit_setting]
    data = MetricCacheManager.get_metric_data(task_id, metric_type, metric_name, selected_file_ids, other_setting)
p data
    assert_not_equal data, nil
  end
end