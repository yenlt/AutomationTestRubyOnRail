require File.dirname(__FILE__) + '/../test_helper'

class QueryFilterTest < Test::Unit::TestCase
  include AuthenticatedTestHelper
	EXTRACTED_SUBTASK_ID = 10

	####*********** Test QueryFilter Model Task5 TCANA2010A***********#########
	# test :generate_query_for_each_criterion

	# test "Rule Level" criterion
	def test_ut_fdw10a_t5_quf_001
		# construct conditions
		rule_level_object = FilterCondition.new("Rule Level", "is", 1)
		array_criterion = []
		array_criterion << rule_level_object
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "rule_level = 1", string_return
  end

	def test_ut_fdw10a_t5_quf_002
		# construct conditions
		rule_level_object_1 = FilterCondition.new("Rule Level", "is", 1)
		rule_level_object_2 = FilterCondition.new("Rule Level", "is", 2)
		array_criterion = []
		array_criterion << rule_level_object_1
		array_criterion << rule_level_object_2
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(rule_level = 1 OR rule_level = 2)", string_return
  end

	def test_ut_fdw10a_t5_quf_003
		# construct conditions
		rule_level_object_1 = FilterCondition.new("Rule Level", "is not", 1)
		rule_level_object_2 = FilterCondition.new("Rule Level", "is", 2)
		array_criterion = []
		array_criterion << rule_level_object_1
		array_criterion << rule_level_object_2
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(rule_level != 1 OR rule_level = 2)", string_return
  end

	def test_ut_fdw10a_t5_quf_004
		# construct conditions
		rule_level_object_1 = FilterCondition.new("Rule Level", "is not", 1)
		rule_level_object_2 = FilterCondition.new("Rule Level", "is not", 2)
		array_criterion = []
		array_criterion << rule_level_object_1
		array_criterion << rule_level_object_2
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(rule_level != 1 OR rule_level != 2)", string_return
  end

	def test_ut_fdw10a_t5_quf_005
		# construct conditions
		rule_level_object_1 = FilterCondition.new("Rule Level", "is not", 1)
		rule_level_object_2 = FilterCondition.new("Rule Level", "is not", 2)
		rule_level_object_3 = FilterCondition.new("Rule Level", "is", 3)
		array_criterion = []
		array_criterion << rule_level_object_1
		array_criterion << rule_level_object_2
		array_criterion << rule_level_object_3
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(rule_level != 1 OR rule_level != 2 OR rule_level = 3)", string_return
  end

	def test_ut_fdw10a_t5_quf_006
		# construct conditions
		rule_level_object_1 = FilterCondition.new("Rule Level", "is not", 1)
		rule_level_object_2 = FilterCondition.new("Rule Level", "is", "")
		rule_level_object_3 = FilterCondition.new("Rule Level", "is", 3)
		array_criterion = []
		array_criterion << rule_level_object_1
		array_criterion << rule_level_object_2
		array_criterion << rule_level_object_3
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(rule_level != 1 OR rule_level IS NULL OR rule_level = 3)", string_return
  end

	# test for "Rule ID" criterion
	def test_ut_fdw10a_t5_quf_007
		# construct conditions
		rule_level_object = FilterCondition.new("Rule ID", "is", "0045")
		array_criterion = []
		array_criterion << rule_level_object
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "rule LIKE '0045'", string_return
  end

	def test_ut_fdw10a_t5_quf_008
		# construct conditions
		rule_level_object_1 = FilterCondition.new("Rule ID", "is", "0045")
		rule_level_object_2 = FilterCondition.new("Rule ID", "is", "0034")
		array_criterion = []
		array_criterion << rule_level_object_1
		array_criterion << rule_level_object_2
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(rule LIKE '0045' OR rule LIKE '0034')", string_return
  end

	def test_ut_fdw10a_t5_quf_009
		# construct conditions
		rule_level_object_1 = FilterCondition.new("Rule ID", "is not", "0045")
		rule_level_object_2 = FilterCondition.new("Rule ID", "is", "0034")
		array_criterion = []
		array_criterion << rule_level_object_1
		array_criterion << rule_level_object_2
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(rule NOT LIKE '0045' OR rule LIKE '0034')", string_return
  end

	def test_ut_fdw10a_t5_quf_010
		# construct conditions
		rule_level_object_1 = FilterCondition.new("Rule ID", "is not", "0045")
		rule_level_object_2 = FilterCondition.new("Rule ID", "is not", "0034")
		array_criterion = []
		array_criterion << rule_level_object_1
		array_criterion << rule_level_object_2
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(rule NOT LIKE '0045' OR rule NOT LIKE '0034')", string_return
  end

	def test_ut_fdw10a_t5_quf_011
		# construct conditions
		rule_level_object_1 = FilterCondition.new("Rule ID", "is not", "0045")
		rule_level_object_2 = FilterCondition.new("Rule ID", "is", "0034")
		rule_level_object_3 = FilterCondition.new("Rule ID", "is", "0035")
		array_criterion = []
		array_criterion << rule_level_object_1
		array_criterion << rule_level_object_2
		array_criterion << rule_level_object_3
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(rule NOT LIKE '0045' OR rule LIKE '0034' OR rule LIKE '0035')", string_return

		rule_level_object_4 = FilterCondition.new("Rule ID", "is", "0048")
		array_criterion << rule_level_object_4
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(rule NOT LIKE '0045' OR rule LIKE '0034' OR rule LIKE '0035' OR rule LIKE '0048')", string_return

		rule_level_object_5 = FilterCondition.new("Rule ID", "is not", "0049")
		array_criterion << rule_level_object_5
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(rule NOT LIKE '0045' OR rule LIKE '0034' OR rule LIKE '0035' OR rule LIKE '0048' OR rule NOT LIKE '0049')", string_return
  end

	def test_ut_fdw10a_t5_quf_012
		# construct conditions
		rule_level_object_1 = FilterCondition.new("Rule ID", "is not", "0045")
		rule_level_object_2 = FilterCondition.new("Rule ID", "is", "")
		rule_level_object_3 = FilterCondition.new("Rule ID", "is", "0035")
		array_criterion = []
		array_criterion << rule_level_object_1
		array_criterion << rule_level_object_2
		array_criterion << rule_level_object_3
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(rule NOT LIKE '0045' OR rule IS NULL OR rule LIKE '0035')", string_return

		rule_level_object_4 = FilterCondition.new("Rule ID", "is", "0048")
		array_criterion << rule_level_object_4
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(rule NOT LIKE '0045' OR rule IS NULL OR rule LIKE '0035' OR rule LIKE '0048')", string_return

		rule_level_object_5 = FilterCondition.new("Rule ID", "is not", "0049")
		array_criterion << rule_level_object_5
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(rule NOT LIKE '0045' OR rule IS NULL OR rule LIKE '0035' OR rule LIKE '0048' OR rule NOT LIKE '0049')", string_return
  end

	# test "Action Status" criterion
	def test_ut_fdw10a_t5_quf_013
		# construct conditions
		rule_level_object = FilterCondition.new("Action Status", "is", 2)
		array_criterion = []
		array_criterion << rule_level_object
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "risk_types.id = 2", string_return
  end

	def test_ut_fdw10a_t5_quf_014
		# construct conditions
		rule_level_object_1 = FilterCondition.new("Action Status", "is", 2)
		rule_level_object_2 = FilterCondition.new("Action Status", "is", 3)
		array_criterion = []
		array_criterion << rule_level_object_1
		array_criterion << rule_level_object_2
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(risk_types.id = 2 OR risk_types.id = 3)", string_return
  end

	def test_ut_fdw10a_t5_quf_015
		# construct conditions
		rule_level_object_1 = FilterCondition.new("Action Status", "is not", 2)
		rule_level_object_2 = FilterCondition.new("Action Status", "is", 3)
		array_criterion = []
		array_criterion << rule_level_object_1
		array_criterion << rule_level_object_2
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(risk_types.id != 2 OR risk_types.id = 3)", string_return
  end

	def test_ut_fdw10a_t5_quf_016
		# construct conditions
		rule_level_object_1 = FilterCondition.new("Action Status", "is not", 2)
		rule_level_object_2 = FilterCondition.new("Action Status", "is not", 3)
		array_criterion = []
		array_criterion << rule_level_object_1
		array_criterion << rule_level_object_2
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(risk_types.id != 2 OR risk_types.id != 3)", string_return
  end

	def test_ut_fdw10a_t5_quf_017
		# construct conditions
		rule_level_object_1 = FilterCondition.new("Action Status", "is not", 2)
		rule_level_object_2 = FilterCondition.new("Action Status", "is not", 3)
		rule_level_object_3 = FilterCondition.new("Action Status", "is", 4)
		array_criterion = []
		array_criterion << rule_level_object_1
		array_criterion << rule_level_object_2
		array_criterion << rule_level_object_3
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(risk_types.id != 2 OR risk_types.id != 3 OR risk_types.id = 4)", string_return

		rule_level_object_4 = FilterCondition.new("Action Status", "is", 1)
		array_criterion << rule_level_object_4
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(risk_types.id != 2 OR risk_types.id != 3 OR risk_types.id = 4 OR risk_types.id = 1)", string_return
  end

	# test for "Change Status" criterion
	def test_ut_fdw10a_t5_quf_018
		# construct conditions
		rule_level_object = FilterCondition.new("Change Status", "is", 2)
		array_criterion = []
		array_criterion << rule_level_object
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "change_status_id = 2", string_return
  end

	def test_ut_fdw10a_t5_quf_019
		# construct conditions
		rule_level_object_1 = FilterCondition.new("Change Status", "is", 2)
		rule_level_object_2 = FilterCondition.new("Change Status", "is", 1)
		array_criterion = []
		array_criterion << rule_level_object_1
		array_criterion << rule_level_object_2
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(change_status_id = 2 OR change_status_id = 1)", string_return
  end

	def test_ut_fdw10a_t5_quf_020
		# construct conditions
		rule_level_object_1 = FilterCondition.new("Change Status", "is not", 2)
		rule_level_object_2 = FilterCondition.new("Change Status", "is", 1)
		array_criterion = []
		array_criterion << rule_level_object_1
		array_criterion << rule_level_object_2
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(change_status_id != 2 OR change_status_id = 1)", string_return
  end

	def test_ut_fdw10a_t5_quf_021
		# construct conditions
		rule_level_object_1 = FilterCondition.new("Change Status", "is not", 2)
		rule_level_object_2 = FilterCondition.new("Change Status", "is not", 1)
		array_criterion = []
		array_criterion << rule_level_object_1
		array_criterion << rule_level_object_2
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(change_status_id != 2 OR change_status_id != 1)", string_return
  end

	def test_ut_fdw10a_t5_quf_022
		# construct conditions
		rule_level_object_1 = FilterCondition.new("Change Status", "is not", 2)
		rule_level_object_2 = FilterCondition.new("Change Status", "is", "")
		array_criterion = []
		array_criterion << rule_level_object_1
		array_criterion << rule_level_object_2
		query_filter = QueryFilter.new(array_criterion)
		string_return = query_filter.generate_query_for_each_criterion(array_criterion)
		assert_equal "(change_status_id != 2 OR change_status_id IS NULL)", string_return
  end

	# test generate_warning_filter
	def test_ut_fdw10a_t5_quf_023
		# construct conditions
		object_criterion = FilterCondition.new("Change Status", "is", 1)
		array_items = []
		array_items << object_criterion
		object_query = QueryFilter.new(array_items)
		return_warnings = object_query.generate_warning_filter
		test_warnings = Warning.find_by_sql("SELECT warnings.* FROM warnings
																													WHERE change_status_id = 1")
		assert_equal return_warnings, test_warnings
  end

	def test_ut_fdw10a_t5_quf_024
		# construct conditions
		object_criterion_1 = FilterCondition.new("Change Status", "is", 1)
		object_criterion_2 = FilterCondition.new("Rule ID", "is", '0034')
		array_items = []
		array_items << object_criterion_1
		array_items << object_criterion_2
		object_query = QueryFilter.new(array_items)
		return_warnings = object_query.generate_warning_filter
		test_warnings = Warning.find_by_sql("SELECT warnings.* FROM warnings
																													WHERE change_status_id = 1 AND rule LIKE '0034'")
		assert_equal return_warnings, test_warnings
  end

	def test_ut_fdw10a_t5_quf_025
		# construct conditions
		object_criterion_1 = FilterCondition.new("Change Status", "is", 1)
		object_criterion_2 = FilterCondition.new("Rule ID", "is", '0034')
		object_criterion_3 = FilterCondition.new("Action Status", "is", 2)
		array_items = []
		array_items << object_criterion_1
		array_items << object_criterion_2
		array_items << object_criterion_3
		object_query = QueryFilter.new(array_items)
		return_warnings = object_query.generate_warning_filter
		test_warnings = Warning.find_by_sql("SELECT warnings.* FROM warnings
																							 LEFT OUTER JOIN comments			ON warnings.id				= comments.warning_id
																							 LEFT OUTER JOIN risk_types		ON risk_types.id		= comments.risk_type_id
																													WHERE change_status_id = 1 AND rule LIKE '0034' AND risk_types.id = 2")
		assert_equal return_warnings, test_warnings
  end

	def test_ut_fdw10a_t5_quf_026
		# construct conditions
		object_criterion_1 = FilterCondition.new("Change Status", "is", 1)
		object_criterion_2 = FilterCondition.new("Rule ID", "is", "")
		object_criterion_3 = FilterCondition.new("Action Status", "is", 2)
		array_items = []
		array_items << object_criterion_1
		array_items << object_criterion_2
		array_items << object_criterion_3
		object_query = QueryFilter.new(array_items)
		return_warnings = object_query.generate_warning_filter
		test_warnings = Warning.find_by_sql("SELECT warnings.* FROM warnings
																							 LEFT OUTER JOIN comments			ON warnings.id				= comments.warning_id
																							 LEFT OUTER JOIN risk_types		ON risk_types.id		= comments.risk_type_id
																													WHERE change_status_id = 1 AND rule IS NULL AND risk_types.id = 2")
		assert_equal return_warnings, test_warnings
  end

	def test_ut_fdw10a_t5_quf_027
		# construct conditions
		object_criterion_1 = FilterCondition.new("Change Status", "is", 1)
		object_criterion_2 = FilterCondition.new("Change Status", "is not", "")
		object_criterion_3 = FilterCondition.new("Action Status", "is", 2)
		array_items = []
		array_items << object_criterion_1
		array_items << object_criterion_2
		array_items << object_criterion_3
		object_query = QueryFilter.new(array_items)
		return_warnings = object_query.generate_warning_filter
		test_warnings = Warning.find_by_sql("SELECT warnings.* FROM warnings
																							 LEFT OUTER JOIN comments			ON warnings.id				= comments.warning_id
																							 LEFT OUTER JOIN risk_types		ON risk_types.id		= comments.risk_type_id
																													WHERE (change_status_id = 1 OR change_status_id IS NOT NULL) AND risk_types.id = 2")
		assert_equal return_warnings, test_warnings
  end

end
