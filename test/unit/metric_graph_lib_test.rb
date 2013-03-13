require File.dirname(__FILE__) + '/../test_helper'
require 'json'

class MetricGraphLibTest < ActiveSupport::TestCase
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
    data = MetricGraphLib.render_graph(task_id, metric_type, metric_name, selected_file_ids, other_setting)
    
    assert_not_equal data, nil
    if data.include?("FileInfo")
      assert true
    end
  end
  #
  #
  #
  def test_ut_t6_mvf_mda_002
    #
    task_id = 5
    metric_type = "class"
    metric_name = "STMTH"
    selected_file_ids =  ["332"]
    order_setting = "DESC"
    limit_setting = "10"
    other_setting = [order_setting, limit_setting]
    data = MetricGraphLib.render_graph(task_id, metric_type, metric_name, selected_file_ids, other_setting)
    
    assert_not_equal data, nil
    if !data.include?("FileInfo") && data.include?("AnzException")
      assert true
    end
  end
end