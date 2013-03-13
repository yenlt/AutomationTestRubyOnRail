require File.dirname(__FILE__) + "/test_wd_setup" unless defined? TestWDSetup
require 'test/unit'
class TestWD5 < Test::Unit::TestCase
  include TestWDSetup
  TIME = 5
  PU = 1
  PJ = 1
  DIFF_ID = 1
  DIFF_FILE_ID = 1
  #
  #
  #
 
  def test_ST_WD_000
    printf "\n+ Test 000"
    access_warning_listing_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID)

    wait_for_text_present($warning_listing["title"])
  end

  def test_ST_WD_001    
    printf "\n+ Test 001"
    access_warning_listing_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID)
    
    wait_for_text_present($warning_listing["title"])
  end

  def test_ST_WD_002
    printf "\n+ Test 002"
    #display table of warnings
    access_warning_listing_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID)
    #warning table
     #header ID
    wait_for_element_present($warning_listing_xpath["header_id"])
    assert_equal "ID", get_text($warning_listing_xpath["header_id"])
     #header Directory
    wait_for_element_present($warning_listing_xpath["header_id"])
    assert_equal _("Directory"), get_text($warning_listing_xpath["header_directory"])
     #header Source Name
    wait_for_element_present($warning_listing_xpath["header_id"])
    assert_equal _("Source Name"), get_text($warning_listing_xpath["header_source_name"])
     #header Rule level
    wait_for_element_present($warning_listing_xpath["header_id"])
    assert_equal _("Rule Level"), get_text($warning_listing_xpath["header_rule_level"])
     #header Task name
    wait_for_element_present($warning_listing_xpath["header_id"])
    assert_equal _("Task Name"), get_text($warning_listing_xpath["header_task"])
     #header Line number
    wait_for_element_present($warning_listing_xpath["header_id"])
    assert_equal _("Line Number"), get_text($warning_listing_xpath["header_line"])
     #header Character number
    wait_for_element_present($warning_listing_xpath["header_id"])
    assert_equal _("Character Number"), get_text($warning_listing_xpath["header_character"])
     #header Rule number
    wait_for_element_present($warning_listing_xpath["header_id"])
    assert_equal _("Rule Number"), get_text($warning_listing_xpath["header_rule_number"])
     #header Message
    wait_for_element_present($warning_listing_xpath["header_id"])
    assert_equal _("Warning Message"), get_text($warning_listing_xpath["header_message"])
     #header Code
    wait_for_element_present($warning_listing_xpath["header_id"])
    assert_equal _("Code"), get_text($warning_listing_xpath["header_code"])
     #header Diff status
    wait_for_element_present($warning_listing_xpath["header_id"])
    assert_equal _("Diff Status"), get_text($warning_listing_xpath["header_status"])
    #row in table
    row = get_xpath_count($warning_listing_xpath["count_row"])
    assert_equal 15, row

  end

  def test_ST_WD_003
    printf "\n+ Test 003"
    #sort in warning table
    access_warning_listing_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID)
    #sort by id
    wait_for_element_present($warning_listing_xpath["header_id"])
    click "#{$warning_listing_xpath["header_id"]}/a"
    wait_for_attribute($warning_listing_xpath["header_id"], "class", "sortable sortdesc")
    assert_equal "sortable sortdesc", get_attribute($warning_listing_xpath["header_id"], "class")
    #sort by directory
    click "#{$warning_listing_xpath["header_directory"]}/a"
    wait_for_attribute($warning_listing_xpath["header_directory"], "class", "sortable sortasc")
    assert_equal "sortable sortasc", get_attribute($warning_listing_xpath["header_directory"], "class")
    #sort by source name
    click "#{$warning_listing_xpath["header_source_name"]}/a"
    wait_for_attribute($warning_listing_xpath["header_source_name"], "class", "sortable sortasc")
    assert_equal "sortable sortasc", get_attribute($warning_listing_xpath["header_source_name"], "class")
    #sort by rule level
    click "#{$warning_listing_xpath["header_rule_level"]}/a"
    wait_for_attribute($warning_listing_xpath["header_rule_level"], "class", "sortable sortasc")
    assert_equal "sortable sortasc", get_attribute($warning_listing_xpath["header_rule_level"], "class")
    #sort by task name
    click "#{$warning_listing_xpath["header_task"]}/a"
    wait_for_attribute($warning_listing_xpath["header_task"], "class", "sortable sortasc")
    assert_equal "sortable sortasc", get_attribute($warning_listing_xpath["header_task"], "class")
    #sort by line number
    click "#{$warning_listing_xpath["header_line"]}/a"
    wait_for_attribute($warning_listing_xpath["header_line"], "class", "sortable sortasc")
   #assert_equal "sortable sortasc", get_attribute($warning_listing_xpath["header_line"], "class")
    #sort by character number
    click "#{$warning_listing_xpath["header_character"]}/a"
    wait_for_attribute($warning_listing_xpath["header_character"], "class", "sortable sortasc")
    assert_equal "sortable sortasc", get_attribute($warning_listing_xpath["header_character"], "class")
    #sort by rule number
    click "#{$warning_listing_xpath["header_rule_number"]}/a"
    wait_for_attribute($warning_listing_xpath["header_rule_number"], "class", "sortable sortasc")
    assert_equal "sortable sortasc", get_attribute($warning_listing_xpath["header_rule_number"], "class")
    #sort by diff status
    click "#{$warning_listing_xpath["header_status"]}/a"
    wait_for_attribute($warning_listing_xpath["header_status"], "class", "sortable sortasc")
    assert_equal "sortable sortasc", get_attribute($warning_listing_xpath["header_status"], "class")
  end

  def test_ST_WD_004
    printf "\n+ Test 004"
    #link in warning table
    access_warning_listing_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID)
    #directory link
    wait_for_element_present($warning_listing_xpath["link_directory"])
    summary_dir = "#{_('Summary of Warning')}(#{get_text($warning_listing_xpath["link_directory"])})"
    click "#{$warning_listing_xpath["link_directory"]}"
    sleep TIME
    assert_equal summary_dir, get_text("//div[@id='pagetitle']")
  end

  def test_ST_WD_005
    printf "\n+ Test 005"
    #link in warning table
    access_warning_listing_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID)
    #source name link
    wait_for_element_present($warning_listing_xpath["link_source"])
    click "#{$warning_listing_xpath["link_source"]}"
    wait_for_element_not_present($warning_listing["title"])
    wait_for_text_present($analysis_report["title"])
    assert_equal $analysis_report["title"], get_text("//div[@id='pagetitle']")
  end

  def test_ST_WD_006
    printf "\n+ Test 006"
    #display filter conditions and [Filtering] button
    access_warning_listing_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID)
    #filter conditions
    assert_equal _("Diff status"), get_text($warning_listing_xpath["status_condition"])
    wait_for_element_present($warning_listing_xpath["select_status"])
    assert_equal _("Rule level"), get_text($warning_listing_xpath["rule_level_condition"])
    wait_for_element_present($warning_listing_xpath["select_rule_level"])
    assert_equal _("Other condition"), get_text($warning_listing_xpath["other_condition"])
    wait_for_element_present($warning_listing_xpath["select_other"])
    wait_for_element_present($warning_listing_xpath["other_text"])
    #filter button
    wait_for_element_present($warning_listing_xpath["filter_button"])
  end

  def test_ST_WD_007
    printf "\n+ Test 007"
    #filter
    access_warning_listing_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID)
    #filter with status and rule level
    select "status", _("Deleted")
    select "rule_level", _("All")
    #click filter button
    wait_for_element_present($warning_listing_xpath["filter_button"])
    click "#{$warning_listing_xpath["filter_button"]}"
    sleep 10
    count = get_xpath_count($warning_listing_xpath["count_row"])
    1.upto(count) do |i|
     assert_equal _("Deleted"), get_text($warning_listing_xpath["status_cell"].sub("__ROW__", i.to_s))
    end
  end

  def test_ST_WD_008
    printf "\n+ Test 008"
    #filter
    access_warning_listing_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID)
    #filter with status and rule level
    select "status", "label=Added"
    select "rule_level", "label=HiRisk"
    #click filter button
    wait_for_element_present($warning_listing_xpath["filter_button"])
    click "#{$warning_listing_xpath["filter_button"]}"
    sleep 10
    count = get_xpath_count($warning_listing_xpath["count_row"])
    1.upto(count) do |i|
     assert_equal "HiRisk", get_text($warning_listing_xpath["rule_level_cell"].sub("__ROW__", i.to_s))
     assert_equal "Added", get_text($warning_listing_xpath["status_cell"].sub("__ROW__", i.to_s))
    end
  end

  def test_ST_WD_009
    printf "\n+ Test 009"
    #filter
    access_warning_listing_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID)
    #filter with status and rule level
    select "status", _("All")
    select "rule_level", _("All")
    select "others", _("Rule Number")
    type "others_value", "0288"
    #click filter button
    wait_for_element_present($warning_listing_xpath["filter_button"])
    click "#{$warning_listing_xpath["filter_button"]}"
    sleep 10
    count = get_xpath_count($warning_listing_xpath["count_row"])
    1.upto(count) do |i|
     assert_equal "0288", get_text($warning_listing_xpath["rule_number_cell"].sub("__ROW__", i.to_s))
    end
  end

   def test_ST_WD_010
     printf "\n+ Test 010"
    #filter
    access_warning_listing_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID)
    #filter with wrong condition
    select "status", _("All")
    select "rule_level", _("All")
    select "others", _("Rule Number")
    type "others_value", "10000"
    #click filter button
    wait_for_element_present($warning_listing_xpath["filter_button"])
    click "#{$warning_listing_xpath["filter_button"]}"
    sleep 10
    wait_for_text_present(_("No warning found."))
  end

  def test_ST_WD_011
     printf "\n+ Test 011"
    #filter
    access_warning_listing_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID)
    #filter with special character
    select "status", _("All")
    select "rule_level", _("All")
    select "others", _("Rule Number")
    type "others_value", "$#??~!"
    #click filter button
    wait_for_element_present($warning_listing_xpath["filter_button"])
    click "#{$warning_listing_xpath["filter_button"]}"
    sleep 10
    wait_for_text_present(_("No warning found."))
  end

  def test_ST_WD_012
     printf "\n+ Test 012"
     #navigation bar
     access_warning_listing_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID)
     #display navigation bar
     1.upto(4) do |i|
       wait_for_element_present($warning_listing_xpath["navi_link"].sub("__ROW__", "#{i}"))
     end
   end

  def test_ST_WD_013
    printf "\n+ Test 013"
     #navigation bar
     access_warning_listing_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID)
     #link to diff administration
     wait_for_element_present($warning_listing_xpath["navi_link"].sub("__ROW__", "1"))
     click "#{$warning_listing_xpath["navi_link"].sub("__ROW__", "1")}"
     sleep TIME
     wait_for_text_present(_("Diff Administration"))
   end

  def test_ST_WD_014
    printf "\n+ Test 014"
     #navigation bar
     access_warning_listing_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID)
     #link to diff result summary
     wait_for_element_present($warning_listing_xpath["navi_link"].sub("__ROW__", "2"))
     click "#{$warning_listing_xpath["navi_link"].sub("__ROW__", "2")}"
     sleep TIME
     wait_for_text_present(_("Diff Result Summary"))
   end

  def test_ST_WD_015
    printf "\n+ Test 015"
     #navigation bar
     access_warning_listing_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID)  
     #link to summary of warning
     wait_for_element_present($warning_listing_xpath["navi_link"].sub("__ROW__", "3"))
     click "#{$warning_listing_xpath["navi_link"].sub("__ROW__", "3")}"
     wait_for_text_present(_("Summary of Warning"))
     sleep TIME
   end

  def test_ST_WD_016
    printf "\n+ Test 016"
     #navigation bar
     access_warning_listing_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID)
     #reload warning listing with diff
     wait_for_element_present($warning_listing_xpath["navi_link"].sub("__ROW__", "4"))
     click "#{$warning_listing_xpath["navi_link"].sub("__ROW__", "4")}"
     sleep TIME
     wait_for_text_present($warning_listing["title"])
  end

  def test_ST_WD_017
     printf "\n+ Test 017"
     #color of each row in table
     access_warning_listing_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID)
     #manual test
     assert true
  end

  def test_ST_WD_018
    printf "\n+ Test 018"
    #display download CSV button
    access_warning_listing_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID)
    #download button present
    wait_for_element_present($warning_listing_xpath["download"])
    assert_equal _("Download CSV Format"), get_value($warning_listing_xpath["download"])
    #click download CSV button
    click "#{$warning_listing_xpath["download"]}"
  end
end
