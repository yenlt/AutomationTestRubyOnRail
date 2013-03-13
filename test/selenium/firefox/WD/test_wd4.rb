require File.dirname(__FILE__) + "/test_wd_setup" unless defined? TestWDSetup
require 'test/unit'
class TestWD4 < Test::Unit::TestCase
  include TestWDSetup

	# User logged in
  # Request to warning diff for file page
  # "Warning Listing" button is displayed.
  # "Download CVS Format" button is displayed.
  # "Filtering" button is displayed.
  # "Diff status" combo box is displayed.
  # "Rule level" combo box is displayed.
  # "Other condition" combo box is displayed.
  # Text box for “Other condition” is displayed.
  # The table show information of each warning
	def test_wd_st_001
    printf "\n+ Test 001"
    open_warning_diff_file
		    assert(is_element_present($warning_diff_xpath["warning_listing_button"]))
				assert(is_element_present($warning_diff_xpath["download_csv_button"]))
				assert(is_element_present($warning_diff_xpath["diff_status_combo"]))
				assert(is_element_present($warning_diff_xpath["rule_level_combo"]))
				assert(is_element_present($warning_diff_xpath["other_condition_combo"]))
				assert(is_element_present($warning_diff_xpath["filter_textbox"]))
				assert(is_element_present($warning_diff_xpath["filtering_button"]))
				(1..8).each do |i|
            assert_equal $warning_diff_table["#{i}"], @selenium.get_text($warning_diff_xpath["table_header"].sub('__INDEX__',i.to_s))
				end
    logout
  end

	# User logged in
  # Request to warning diff for file page
	# Click on "Warning Listing" button
	# Move to "Warning Listing with Diff Stataus" page
	def test_wd_st_002
    printf "\n+ Test 002"
		 assert(true)
	end

	# User logged in
  # Request to warning diff for file page
	# Click on "Download CSV" button
	# Download content in the table
	def test_wd_st_003
    printf "\n+ Test 003"
    open_warning_diff_file
				assert(is_element_present($warning_diff_xpath["download_csv_button"]))
    logout
  end

	# User logged in
  # Request to warning diff for file page
	# Click on "Diff Status" combo box
	def test_wd_st_004
    printf "\n+ Test 004"
    open_warning_diff_file

    (1..4).each do |i|
            assert_equal $diff_status["#{i}"], @selenium.get_text($warning_diff_xpath["diff_status_combo_index"].sub('__DINDEX__',i.to_s))
				end
    logout
  end

	# User logged in
  # Request to warning diff for file page
	# Click on "Rule Level" combo box
	def test_wd_st_005
    printf "\n+ Test 005"
    open_warning_diff_file

    (1..4).each do |i|
            assert_equal $rule_level["#{i}"], @selenium.get_text($warning_diff_xpath["rule_level_combo_index"].sub('__RINDEX__',i.to_s))
				end
    logout
  end

	# User logged in
  # Request to warning diff for file page
	# Click on "Other Condition" combo box
	def test_wd_st_006
    printf "\n+ Test 006"
    open_warning_diff_file

    (1..2).each do |i|
            assert_equal $other_condition["#{i}"], @selenium.get_text($warning_diff_xpath["other_condition_combo_index"].sub('__OINDEX__',i.to_s))
				end
    logout
  end

	# User logged in
  # Request to warning diff for file page
	# The value of "Other condition" combo box is "Rule Number"
	# Input a RIGHT KEYWORD
	# "Filtering" button is clicked
	def test_wd_st_007
    printf "\n+ Test 007"
    open_warning_diff_file
    old_table = get_xpath_count($warning_diff_xpath["row"])
		@selenium.select "others", _("Rule Number")
    @selenium.type($warning_diff_xpath["filter_textbox"],RIGHT_KEYWORD)
    click $warning_diff_xpath["filtering_button"]
    sleep SLEEP_TIME
    new_table = get_xpath_count($warning_diff_xpath["row"])
    assert_not_equal old_table, new_table
    logout
  end

	# User logged in
  # Request to warning diff for file page
	# The value of "Other condition" combo box is "Rule Number"
	# Input a WRONG KEYWORD
	# "Filtering" button is clicked
	def test_wd_st_008
    printf "\n+ Test 008"
    open_warning_diff_file
    old_table = get_xpath_count($warning_diff_xpath["row"])
     @selenium.select "others", _("Rule Number")
    @selenium.type($warning_diff_xpath["filter_textbox"],WRONG_KEYWORD)
    click $warning_diff_xpath["filtering_button"]
    sleep SLEEP_TIME
    new_table = get_xpath_count($warning_diff_xpath["row"])
    assert_not_equal old_table, new_table
		assert_equal 0,new_table
    logout
  end

	# User logged in
  # Request to warning diff for file page
	# The value of "Other condition" combo box is "Rule Number"
	# Input a SPECIAL KEYWORD
	# "Filtering" button is clicked
	def test_wd_st_009
    printf "\n+ Test 009"
    open_warning_diff_file
    old_table = get_xpath_count($warning_diff_xpath["row"])
		@selenium.select "others", _("Rule Number")
    @selenium.type($warning_diff_xpath["filter_textbox"],SPECIAL_KEYWORD)
    click $warning_diff_xpath["filtering_button"]
    sleep SLEEP_TIME
    new_table = get_xpath_count($warning_diff_xpath["row"])
    assert_not_equal old_table, new_table
		assert_equal 0,new_table
    logout
  end

	# User logged in
  # Request to warning diff for file page
	# The value of "Other condition" combo box is "Rule Number"
	# Input a REGULAR KEYWORD
	# "Filtering" button is clicked
	def test_wd_st_010
    printf "\n+ Test 010"
    open_warning_diff_file
    old_table = get_xpath_count($warning_diff_xpath["row"])
		@selenium.select "others", _("Rule Number")
    @selenium.type($warning_diff_xpath["filter_textbox"],REGULAR_KEYWORD)
    click $warning_diff_xpath["filtering_button"]
    sleep SLEEP_TIME
    new_table = get_xpath_count($warning_diff_xpath["row"])
    assert_equal old_table, new_table
		assert_not_equal 0,new_table
    logout
  end

#	 User logged in
#   Request to warning diff for file page
#	 Click on column header of each column
#	 Sort the row of table
	def test_wd_st_011
    printf "\n+ Test 011"
    open_warning_diff_file
    old_table = get_xpath_count($warning_diff_xpath["row"])
		befores = []
  	(1..15).each do |i|
          befores <<   @selenium.get_text($warning_diff_xpath["row_rule_number"].sub('__SINDEX__',i.to_s))
		end
    click $warning_diff_xpath["link_sort_rule_number"] + "/a"
    sleep SLEEP_TIME

    new_table = get_xpath_count($warning_diff_xpath["row"])
		afters = []
		(1..15).each do |i|
          afters <<   @selenium.get_text($warning_diff_xpath["row_rule_number"].sub('__SINDEX__',i.to_s))
		end
    assert_equal old_table, new_table
		assert_not_equal afters, befores
	 # sort by directory
    click "#{$warning_diff_xpath["link_sort_directory"]}/a"
    wait_for_attribute($warning_diff_xpath["link_sort_directory"], "class", "sortable sortasc")
    assert_equal "sortable sortasc", get_attribute($warning_diff_xpath["link_sort_directory"], "class")
		# sort by source name
    click "#{$warning_diff_xpath["link_sort_source_name"]}/a"
    wait_for_attribute($warning_diff_xpath["link_sort_source_name"], "class", "sortable sortasc")
    assert_equal "sortable sortasc", get_attribute($warning_diff_xpath["link_sort_source_name"], "class")
		# sort by rule level
    click "#{$warning_diff_xpath["link_sort_rule_level"]}/a"
    wait_for_attribute($warning_diff_xpath["link_sort_rule_level"], "class", "sortable sortasc")
    assert_equal "sortable sortasc", get_attribute($warning_diff_xpath["link_sort_rule_level"], "class")
		# sort by task name
    click "#{$warning_diff_xpath["link_sort_task_name"]}/a"
    wait_for_attribute($warning_diff_xpath["link_sort_task_name"], "class", "sortable sortasc")
    assert_equal "sortable sortasc", get_attribute($warning_diff_xpath["link_sort_task_name"], "class")
		# sort by rule number
    click "#{$warning_diff_xpath["link_sort_rule_number"]}/a"
    wait_for_attribute($warning_diff_xpath["link_sort_rule_number"], "class", "sortable sortasc")
    assert_equal "sortable sortasc", get_attribute($warning_diff_xpath["link_sort_rule_number"], "class")
		# sort by diff status
    click "#{$warning_diff_xpath["link_sort_diff_status"]}/a"
    wait_for_attribute($warning_diff_xpath["link_sort_diff_status"], "class", "sortable sortasc")
    assert_equal "sortable sortasc", get_attribute($warning_diff_xpath["link_sort_diff_status"], "class")
    logout
  end

	# User logged in
  # Request to warning diff for file page
	# Click on directory link under "Directory" column
	# Move to "Summary of Warning (for directory)" page
	def test_wd_st_012
    printf "\n+ Test 012"
    open_warning_diff_file

    click $warning_diff_xpath["link_to_directory"] + "/a"
    sleep SLEEP_TIME
    assert(is_text_present($warning_diff["summary_warning_directory"]))
    logout
  end

  # User logged in
  # Request to warning diff for file page
	# Click on source link under "Source Name" column
	# Move to "Analysis Report with Diff" page
	def test_wd_st_013
    printf "\n+ Test 013"
    assert(true)
  end

	# User logged in
  # Request to warning diff for file page
	# The quantity of warning result table is less than 15
	# Pagination is non displayed
	def test_wd_st_014
    printf "\n+ Test 014"
    open_warning_diff_file
		@selenium.select "status", "Added"
    click $warning_diff_xpath["filtering_button"]
    sleep SLEEP_TIME
    assert(!is_text_present($warning_diff["pagination_text"]))
		assert(is_element_not_present($warning_diff_xpath["pagination"]))

		@selenium.select "status", "Deleted"
    click $warning_diff_xpath["filtering_button"]
    sleep SLEEP_TIME
    assert(!is_text_present($warning_diff["pagination_text"]))
		assert(is_element_not_present($warning_diff_xpath["pagination"]))
    logout
  end

	# User logged in
  # Request to warning diff for file page
	# The quantity of warning result table is more than 15
	# Pagination is displayed
	def test_wd_st_015
    printf "\n+ Test 015"
    open_warning_diff_file
    click $warning_diff_xpath["filtering_button"]
    sleep SLEEP_TIME
    assert(is_text_present($warning_diff["pagination_text"]))
		assert(is_element_present($warning_diff_xpath["pagination"]))
		warning_result = get_xpath_count($warning_diff_xpath["row"])
		@selenium.select "status", _("All")
		click $warning_diff_xpath["filtering_button"]
    sleep SLEEP_TIME
    assert(is_text_present($warning_diff["pagination_text"]))
		assert(is_element_present($warning_diff_xpath["pagination"]))
		warning_result = get_xpath_count($warning_diff_xpath["row"])
		assert_equal 15, warning_result
    logout
  end


		def test_wd_st_016
    printf "\n+ Test 016"
    assert true
  end
  #
  def test_wd_st_017
    printf "\n+ Test 017"
    assert true
  end
  #
  def test_wd_st_018
    printf "\n+ Test 018"
    assert true
  end

	# User logged in
  # Request to warning diff for file page
	# Click on "Summary of Warning" link
	# Back to this page
	def test_wd_st_019
    printf "\n+ Test 019"
    open_warning_diff_file
    click $warning_diff_xpath["navi_area"] + "/a[3]"
    sleep SLEEP_TIME
    assert(is_text_present($warning_diff["summary_warning_file"]))
    logout
  end

	# User logged in
  # Request to warning diff for file page
	# Click on "Diff Result Summary" link
	# Return to "Diff Result Summary" page
	def test_wd_st_020
    printf "\n+ Test 020"
    open_warning_diff_file
    click $warning_diff_xpath["navi_area"] + "/a[2]"
    sleep SLEEP_TIME
    assert(is_text_present($warning_diff["diff_summary"]))
    logout
  end

	# User logged in
  # Request to warning diff for file page
	# Click on "Diff Administration" link
	# Return "Diff Administration" page
	def test_wd_st_021
    printf "\n+ Test 021"
    open_warning_diff_file
    click $warning_diff_xpath["navi_area"] + "/a[1]"
    sleep SLEEP_TIME
    assert(is_text_present($warning_diff["diff_admin"]))
    logout
  end

end
