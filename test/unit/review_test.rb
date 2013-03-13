require File.dirname(__FILE__) + '/../test_helper'

class ReviewTest < Test::Unit::TestCase
  include AuthenticatedTestHelper
	EXTRACTED_SUBTASK_ID = 10
  PUBLICIZED_SUBTASK_ID = 7

#	####*********** Test Review Model Task5 TCANA2010A***********#########
#	# test :execute_filter_warnings
#	# invalid input
#	# return html
#	def test_ut_fdw10a_t5_rev_001
#		filter1 = FilterCondition.new("Rule Level", "is", 1)
#		filter_conditions = []
#		filter_conditions << filter1
#		review = Review.new
#		query = QueryFilter.new(filter_conditions)
#		warning_results = WarningsResult.find_all_by_result_id(10)
#		warnings_filtereds = query.generate_warning_filter
#		warnings_filtered = []
#		warning_in_result = []
#		for warning_result in warning_results
#				warning = Warning.find_by_id(warning_result.warning_id)
#				warning_in_result << warning
#		end
#		for item in warning_in_result
#				#remove all redundant warnings
#				 if warnings_filtereds.include?(item)
#						warnings_filtered << item
#				 end
#		end
#		html_return = review.execute_filter_warnings(10, 12, 1, filter_conditions)
#		for warning in warnings_filtered
#				assert html_return[1].values[0].include? warning
#		end
#	end
#
#	# have no warning is found
#	# return html with source no warning
#	def test_ut_fdw10a_t5_rev_002
#		filter1 = FilterCondition.new("Rule Level", "is", 1)
#		filter2 = FilterCondition.new(("Change Status"), "is", 2)
#		filter_conditions = []
#		filter_conditions << filter1
#		filter_conditions << filter2
#		review = Review.new
#		query = QueryFilter.new(filter_conditions)
#		warning_results = WarningsResult.find_all_by_result_id(10)
#		warnings_filtereds = query.generate_warning_filter
#		warnings_filtered = []
#		warning_in_result = []
#		for warning_result in warning_results
#				warning = Warning.find_by_id(warning_result.warning_id)
#				warning_in_result << warning
#		end
#		for item in warning_in_result
#				#remove all redundant warnings
#				 if warnings_filtereds.include?(item)
#						warnings_filtered << item
#				 end
#		end
#		html_return = review.execute_filter_warnings(10, 12, 1, filter_conditions)
#		for warning in warnings_filtered
#				assert_nil html_return
#		end
#	end
#
#	# filter_conditions parameter is []
#	# return html with source code and warning
#	def test_ut_fdw10a_t5_rev_003
#		filter_conditions = []
#		review = Review.new
#		query = QueryFilter.new(filter_conditions)
#		warning_results = WarningsResult.find_all_by_result_id(10)
#		warnings_filtereds = query.generate_warning_filter
#		warnings_filtered = []
#		warning_in_result = []
#		for warning_result in warning_results
#				warning = Warning.find_by_id(warning_result.warning_id)
#				warning_in_result << warning
#		end
#		for item in warning_in_result
#				#remove all redundant warnings
#				 if warnings_filtereds.include?(item)
#						warnings_filtered << item
#				 end
#		end
#		html_return = review.execute_filter_warnings(10, 12, 1, filter_conditions)
#		for warning in warnings_filtered
#				assert_nil html_return
#		end
#	end
#
#	#input valid
#	# return array contain warnings
#	def test_ut_fdw10a_t5_rev_004
#		filter1 = FilterCondition.new("Rule Level", "is", 1)
#		filter_conditions = []
#		filter_conditions << filter1
#		review = Review.new
#		query = QueryFilter.new(filter_conditions)
#		warning_results = WarningsResult.find_all_by_result_id(10)
#		warnings_filtereds = query.generate_warning_filter
#		warnings_filtered = []
#		warning_in_result = []
#		for warning_result in warning_results
#				warning = Warning.find_by_id(warning_result.warning_id)
#				warning_in_result << warning
#		end
#		for item in warning_in_result
#				#remove all redundant warnings
#				 if warnings_filtereds.include?(item)
#						warnings_filtered << item
#				 end
#		end
#		html_return = review.execute_filter_warnings(10, 12, 0, filter_conditions)
#		for warning in warnings_filtered
#				assert html_return[1].values[0].include? warning
#		end
#	end
#
#	# have no warning is found
#	# return nil
#	def test_ut_fdw10a_t5_rev_005
#		filter1 = FilterCondition.new("Rule Level", "is", 1)
#		filter2 = FilterCondition.new(("Change Status"), "is", 2)
#		filter_conditions = []
#		filter_conditions << filter1
#		filter_conditions << filter2
#		review = Review.new
#		query = QueryFilter.new(filter_conditions)
#		warning_results = WarningsResult.find_all_by_result_id(10)
#		warnings_filtereds = query.generate_warning_filter
#		warnings_filtered = []
#		warning_in_result = []
#		for warning_result in warning_results
#				warning = Warning.find_by_id(warning_result.warning_id)
#				warning_in_result << warning
#		end
#		for item in warning_in_result
#				#remove all redundant warnings
#				 if warnings_filtereds.include?(item)
#						warnings_filtered << item
#				 end
#		end
#		html_return = review.execute_filter_warnings(10, 12, 0, filter_conditions)
#		for warning in warnings_filtered
#				assert_nil html_return
#		end
#	end
#
#	# filter_conditions parameter is []
#	# return nil
#	def test_ut_fdw10a_t5_rev_006
#		filter_conditions = []
#		review = Review.new
#		query = QueryFilter.new(filter_conditions)
#		warning_results = WarningsResult.find_all_by_result_id(10)
#		warnings_filtereds = query.generate_warning_filter
#		warnings_filtered = []
#		warning_in_result = []
#		for warning_result in warning_results
#				warning = Warning.find_by_id(warning_result.warning_id)
#				warning_in_result << warning
#		end
#		for item in warning_in_result
#				#remove all redundant warnings
#				 if warnings_filtereds.include?(item)
#						warnings_filtered << item
#				 end
#		end
#		html_return = review.execute_filter_warnings(10, 12, 0, filter_conditions)
#		for warning in warnings_filtered
#				assert_nil html_return
#		end
#	end
#
#	# input valid
#	# return html with source code and warnings
#	def test_ut_fdw10a_t5_rev_007
#		filter1 = FilterCondition.new("Rule Level", "is", 1)
#		filter_conditions = []
#		filter_conditions << filter1
#		review = Review.new
#		query = QueryFilter.new(filter_conditions)
#		warning_results = WarningsResult.find_all_by_result_id(10)
#		warnings_filtereds = query.generate_warning_filter
#		warnings_filtered = []
#		warning_in_result = []
#		for warning_result in warning_results
#				warning = Warning.find_by_id(warning_result.warning_id)
#				warning_in_result << warning
#		end
#		for item in warning_in_result
#				#remove all redundant warnings
#				 if warnings_filtereds.include?(item)
#						warnings_filtered << item
#				 end
#		end
#		html_return = review.filter_publicized(10, warnings_filtered)
#		warnings_filtered = warnings_filtered.map do |w|
#				w.id
#			end
#	#	assert_equal html_return[0], "dddd"
#		for warning_id in warnings_filtered
#				assert html_return[0].include? "id='warning_#{warning_id}'"
#		end
#	end
#
#	# no conditions have found
#	# return html with warnings and sourcecodes
#	def test_ut_fdw10a_t5_rev_008
#		filter_conditions = []
#		review = Review.new
#		query = QueryFilter.new(filter_conditions)
#		warning_results = WarningsResult.find_all_by_result_id(10)
#		warnings_filtereds = query.generate_warning_filter
#		warnings_filtered = []
#		warning_in_result = []
#		for warning_result in warning_results
#				warning = Warning.find_by_id(warning_result.warning_id)
#				warning_in_result << warning
#		end
#		html_return = review.filter_publicized(10, warnings_filtered)
#
#		warning_in_result = warning_in_result.map do |w|
#				w.id
#		end
#		for warning_id in warning_in_result
#				assert html_return[0].include? "id='warning_#{warning_id}"
#		end
#	end
#
#	# input valid
#	# return warning array
#	def test_ut_fdw10a_t5_rev_009
#		filter1 = FilterCondition.new("Rule Level", "is", 1)
#		filter_conditions = []
#		filter_conditions << filter1
#		review = Review.new
#		query = QueryFilter.new(filter_conditions)
#		warning_results = WarningsResult.find_all_by_result_id(10)
#		warnings_filtereds = query.generate_warning_filter
#		warnings_filtered = []
#		warning_in_result = []
#		for warning_result in warning_results
#				warning = Warning.find_by_id(warning_result.warning_id)
#				warning_in_result << warning
#		end
#		for item in warning_in_result
#				#remove all redundant warnings
#				 if warnings_filtereds.include?(item)
#						warnings_filtered << item
#				 end
#		end
#		warnings_filtered_id = warnings_filtered.map do |w|
#					w.id
#		end
#		html_return = review.filter_unpublicized(10, 12, warnings_filtered_id)
#		for warning in warnings_filtered
#					assert html_return[1].values[0].include? warning
#		end
#	end
#
#	# warning_filter parameter is blank
#	# return html include source code
#	def test_ut_fdw10a_t5_rev_010
#		filter_conditions = []
#		review = Review.new
#		query = QueryFilter.new(filter_conditions)
#		warning_results = WarningsResult.find_all_by_result_id(10)
#		warnings_filtereds = query.generate_warning_filter
#		warnings_filtered = []
#		warning_in_result = []
#		for warning_result in warning_results
#				warning = Warning.find_by_id(warning_result.warning_id)
#				warning_in_result << warning
#		end
#		for item in warning_in_result
#				#remove all redundant warnings
#				 if warnings_filtereds.include?(item)
#						warnings_filtered << item
#				 end
#		end
#		warnings_filtered_id = warnings_filtered.map do |w|
#					w.id
#		end
#		source_code1= SourceCode.find_by_id(9944)
#		source_code2= SourceCode.find_by_id(9945)
#		source_code3= SourceCode.find_by_id(9946)
#		source_codes = []
#		source_codes << source_code1
#		source_codes << source_code2
#		source_codes << source_code3
#		html_return = review.filter_unpublicized(10, 12, warnings_filtered_id)
#		for source_code in source_codes
#				assert html_return[0].include? source_code
#		end
#	end
#
#	# input valid
#	# return array
#	def test_ut_fdw10a_t5_rev_011
#		base_warning = ["9916", "9917", "9918", "9919", "9920"]
#		warning_id = [9917, 9918, 9919]
#		base_id = ["9916", "9920"]
#		review = Review.new
#		base_return = review.delete_warning_id_filtered(base_warning, warning_id)
#		assert_equal base_id, base_return
#	#	assert base_warning.include?(9916.to_s)
#	end
#
#	# base_warning is blank
#	# return array
#	def test_ut_fdw10a_t5_rev_012
#		base_warning = []
#		warning_id = ["9916", "9917", "9918", "9919", "9920"]
#		review = Review.new
#		base_return = review.delete_warning_id_filtered(base_warning, warning_id)
#		assert_equal base_warning, base_return
#	#	assert base_warning.include?(9916.to_s)
#	end
#
#	# warning_id parameter is blank
#	# return array
#	def test_ut_fdw10a_t5_rev_013
#		base_warning = ["9916", "9917", "9918", "9919", "9920"]
#		warning_id = []
#		review = Review.new
#		base_return = review.delete_warning_id_filtered(base_warning, warning_id)
#		assert_equal base_warning, base_return
#	#	assert base_warning.include?(9916.to_s)
#	end
#
#	# input valid
#	# return html
#	def test_ut_fdw10a_t5_rev_014
#		base_warning = ["7943", "7944", "7945", "7946", "7947"]
#		review = Review.new
#		warnings_filtered = []
#		html_return = review.filter_publicized(10, warnings_filtered)
#		html_after_hide = review.hide_warning(base_warning, html_return[0])
#		assert_equal html_return[0], html_after_hide
#	end
#
#	# base_warning parameter is blank
#	# return html
#	def test_ut_fdw10a_t5_rev_015
#		base_warning = []
#		review = Review.new
#		warnings_filtered = []
#		html_return = review.filter_publicized(10, warnings_filtered)
#		html_after_hide = review.hide_warning(base_warning, html_return[0])
#		assert_equal html_return[0], html_after_hide
#	end
#
#	# html_content parameter is blank
#	# return html
#	def test_ut_fdw10a_t5_rev_016
#		base_warning = ["7943", "7944", "7945", "7946", "7947"]
#		review = Review.new
#		warnings_filtered = []
#		html_return = []
#		html_after_hide = review.hide_warning(base_warning, html_return)
#		assert_equal html_return, html_after_hide
#	end

  def test_ut_rrf10b_t3_19
    #TEST FILTER_PUBLICIZED FUNCTION
    source = ["sample_c/src", "analyzeme.c"]
    filter_success = ["9800"]
    result = Result.find_by_path_and_source_name_and_subtask_id_and_rule_set(source[0], source[1], 7, 1)
    rev = Review.new
    success = rev.filter_publicized(result.id, filter_success)

    assert_equal 1, success[1]
    if success.include?("<div id=\"warning_#{filter_success[0]}\">")
      assert true
    end
  end

  def test_ut_rrf10b_t3_20
    #TEST FILTER_PUBLICIZED FUNCTION: FILTER FAIL
    source = ["sample_c/src", "analyzeme.c"]
    filter_fail    = []
    result = Result.find_by_path_and_source_name_and_subtask_id_and_rule_set(source[0], source[1], 7, 1)
    rev = Review.new
    fail    = rev.filter_publicized(result.id, filter_fail)
    
    assert_equal 0, fail[1]
    if success.include?("style='display:none;'")
      assert true
    end
  end

  def test_ut_rrf10b_t3_21
    #TEST FILTER_UNPUBLICIZED FUNCTION
    source = ["sample_c/src", "analyzeme.c"]
    filter_success = ["9800"]
    result = Result.find_by_path_and_source_name_and_subtask_id_and_rule_set(source[0], source[1], 7, 1)
    rev = Review.new
    success = rev.filter_unpublicized(result.id, filter_success)
    
    assert_equal 1, success.last
  end

  def test_ut_rrf10b_t3_22
    #TEST FILTER_UNPUBLICIZED FUNCTION
    #FILTER FAIL
    source = ["sample_c/src", "analyzeme.c"]
    filter_fail    = []
    result = Result.find_by_path_and_source_name_and_subtask_id_and_rule_set(source[0], source[1], 7, 1)
    rev = Review.new
    fail    = rev.filter_unpublicized(result.id, filter_fail)

    assert_equal 0, fail.last
  end
end
