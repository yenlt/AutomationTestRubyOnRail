require File.dirname(__FILE__) + '/../test_helper'

class RiskTypeTest < ActiveSupport::TestCase
  include AuthenticatedTestHelper
	# test: map_task_to_ids
	def test_ut_rsf10a_t3_risk_001
		task = "Not Required"
		array_map = [3,4]
		assert_equal array_map,RiskType.map_task_to_ids(task)
	end

	def test_ut_rsf10a_t3_risk_002
		task = "abcxyz"
		array_map = []
		assert_equal array_map,RiskType.map_task_to_ids(task)
	end

	def test_ut_rsf10a_t3_risk_003
		task = "123456"
		array_map = []
		assert_equal array_map,RiskType.map_task_to_ids(task)
	end
end