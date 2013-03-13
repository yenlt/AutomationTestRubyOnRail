require File.dirname(__FILE__) + '/../test_helper'

class FilterConditionTest < Test::Unit::TestCase
  include AuthenticatedTestHelper
	EXTRACTED_SUBTASK_ID = 10

	####*********** Test FilterCondition Model Task5 TCANA2010A***********#########
	# test :create_query

	# test "Rule Level" criterion
	def test_ut_fdw10a_t5_fic_001
		filter_condition = FilterCondition.new("Rule Level", "is", 1)
		string_return = filter_condition.create_query
		assert_equal "rule_level = 1", string_return
  end

	def test_ut_fdw10a_t5_fic_002
		filter_condition = FilterCondition.new("Rule Level", "is not", 1)
		string_return = filter_condition.create_query
		assert_equal "rule_level != 1", string_return
  end

	def test_ut_fdw10a_t5_fic_003
		filter_condition = FilterCondition.new("Rule Level", "is","")
		string_return = filter_condition.create_query
		assert_equal "rule_level IS NULL", string_return
  end

	def test_ut_fdw10a_t5_fic_004
		filter_condition = FilterCondition.new("Rule Level", "is not","")
		string_return = filter_condition.create_query
		assert_equal "rule_level IS NOT NULL", string_return
  end

	# test "Rule ID" criterion
	def test_ut_fdw10a_t5_fic_005
		filter_condition = FilterCondition.new("Rule ID", "is","0045")
		string_return = filter_condition.create_query
		assert_equal "rule LIKE '0045'", string_return
  end

	def test_ut_fdw10a_t5_fic_006
		filter_condition = FilterCondition.new("Rule ID", "is not","0045")
		string_return = filter_condition.create_query
		assert_equal "rule NOT LIKE '0045'", string_return
  end

	def test_ut_fdw10a_t5_fic_007
		filter_condition = FilterCondition.new("Rule ID", "is","")
		string_return = filter_condition.create_query
		assert_equal "rule IS NULL", string_return
  end

	def test_ut_fdw10a_t5_fic_008
		filter_condition = FilterCondition.new("Rule ID", "is not","")
		string_return = filter_condition.create_query
		assert_equal "rule IS NOT NULL", string_return
  end

	# test "Action Status" criterion
	def test_ut_fdw10a_t5_fic_009
		filter_condition = FilterCondition.new("Action Status", "is", 1)
		string_return = filter_condition.create_query
		assert_equal "risk_types.id = 1", string_return
  end

	def test_ut_fdw10a_t5_fic_010
		filter_condition = FilterCondition.new("Action Status", "is not", 1)
		string_return = filter_condition.create_query
		assert_equal "risk_types.id != 1", string_return
  end

	def test_ut_fdw10a_t5_fic_011
		filter_condition = FilterCondition.new("Change Status", "is", 1)
		string_return = filter_condition.create_query
		assert_equal "change_status_id = 1", string_return
  end

	# test "Change Status" criterion
	def test_ut_fdw10a_t5_fic_012
		filter_condition = FilterCondition.new("Change Status", "is not", 1)
		string_return = filter_condition.create_query
		assert_equal "change_status_id != 1", string_return
  end

	def test_ut_fdw10a_t5_fic_013
		filter_condition = FilterCondition.new("Change Status", "is", "")
		string_return = filter_condition.create_query
		assert_equal "change_status_id IS NULL", string_return
  end

	def test_ut_fdw10a_t5_fic_014
		filter_condition = FilterCondition.new("Change Status", "is not", "")
		string_return = filter_condition.create_query
		assert_equal "change_status_id IS NOT NULL", string_return
  end

end
