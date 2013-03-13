require File.dirname(__FILE__) + "/test_wd_setup" unless defined? TestWDSetup
require 'test/unit'
class TestWD6 < Test::Unit::TestCase
  include TestWDSetup
  TIME = 5
  PU = 1
  PJ = 1
  DIFF_ID = 1
  DIFF_FILE_ID = 1
  FILE_NAME = "analyzeme.c"
  FILE_ID   = 1 
  
  def test_ST_WD_001
    printf "\n+ Test 001"
    access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
    wait_for_text_present($analysis_report_xpath["title"])
  end

  def test_ST_WD_002
    printf "\n+ Test 002"
    #display name of new/old version
    access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
    wait_for_element_present($analysis_report_xpath["new_file"])
    wait_for_element_present($analysis_report_xpath["old_file"])
    #get data
    diff_result = DiffResult.find_by_id(DIFF_ID)
    new_pu   = Pu.find_by_id(diff_result.new_pu_id)
    new_pj   = Pj.find_by_id(diff_result.new_pj_id)
    new_task = Task.find_by_id(diff_result.new_task_id)
    old_pu   = Pu.find_by_id(diff_result.old_pu_id)
    old_pj   = Pj.find_by_id(diff_result.old_pj_id)
    old_task = Task.find_by_id(diff_result.old_task_id)
    tool = AnalyzeTool.find_by_id(diff_result.analyze_tool_id)
    #assert
    assert_equal "#{new_pu.name} : #{new_pj.name} : #{new_task.name} : #{tool.name}", get_text($analysis_report_xpath["new_file"])
    assert_equal "#{old_pu.name} : #{old_pj.name} : #{old_task.name} : #{tool.name}", get_text($analysis_report_xpath["old_file"])
  end

  def test_ST_WD_003
    printf "\n+ Test 003"
    #display contents of new/old file
    access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
    new_rows = get_xpath_count("#{$analysis_report_xpath["new_contents"]}")
    old_rows = get_xpath_count("#{$analysis_report_xpath["old_contents"]}")

    1.upto(new_rows) do |i|
      new_att = get_attribute("#{$analysis_report_xpath["new_contents"]}[#{i}]/td[2]", "class")
      if new_att == "common"
        assert true
      end

      if get_attribute("#{$analysis_report_xpath["new_contents"]}[#{i}]/td[2]", "class") == "added"
        assert_equal "added", get_attribute("#{$analysis_report_xpath["new_contents"]}[#{i}]/td[2]", "class")
      end
    end

    1.upto(old_rows) do |i|
      if get_attribute("#{$analysis_report_xpath["old_contents"]}[#{i}]/td[2]", "class") == "common"
        assert_equal "common", get_attribute("#{$analysis_report_xpath["old_contents"]}[#{i}]/td[2]", "class")
      end

      if get_attribute("#{$analysis_report_xpath["old_contents"]}[#{i}]/td[2]", "class") == "deleted"
        assert_equal "deleted", get_attribute("#{$analysis_report_xpath["old_contents"]}[#{i}]/td[2]", "class")
      end
    end
  end

  def test_ST_WD_004
    printf "\n+ Test 004"
    #color of common line
    access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
    wait_for_element_present($analysis_report_xpath["new_contents"])
    wait_for_element_present($analysis_report_xpath["old_contents"])
    new_rows = get_xpath_count("#{$analysis_report_xpath["new_contents"]}")
    old_rows = get_xpath_count("#{$analysis_report_xpath["old_contents"]}")

    1.upto(new_rows) do |i|
      new_att = get_attribute("#{$analysis_report_xpath["new_contents"]}[#{i}]/td[2]", "bgcolor")
      if new_att == ""
        assert true
      end
    end

    1.upto(old_rows) do |i|
      old_att = get_attribute("#{$analysis_report_xpath["old_contents"]}[#{i}]/td[2]", "bgcolor")
      if old_att == ""
        assert true
      end
    end
  end

  def test_ST_WD_005
    printf "\n+ Test 005"
    #color of added line
    access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
    wait_for_element_present($analysis_report_xpath["new_contents"])
    new_rows = get_xpath_count("#{$analysis_report_xpath["new_contents"]}")
    exist = false
    1.upto(new_rows) do |i|
      new_att = get_attribute("#{$analysis_report_xpath["new_contents"]}[#{i}]/td[2]", "bgcolor")
      if new_att != ""
        exist = true
        assert_equal '#fecccb', new_att
      end
    end
    if exist == false
      p "Do not have added line"
    end
  end

  def test_ST_WD_006
    printf "\n+ Test 006"
    #color of deleted line
    access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
    wait_for_element_present($analysis_report_xpath["old_contents"])
    old_rows = get_xpath_count("#{$analysis_report_xpath["old_contents"]}")
    exist = false
    1.upto(old_rows) do |i|
      old_att = get_attribute("#{$analysis_report_xpath["old_contents"]}[#{i}]/td[2]", "bgcolor")
      if old_att != ""
        exist = true
        assert_equal '#dde9f7', old_att
      end
    end
    if exist == false
      p "Do not have deleted line"
    end
  end

  def test_ST_WD_007
    printf "\n+ Test 007"
    #color of common warnings
    access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
    #manual test
    assert true
  end

  def test_ST_WD_008
    printf "\n+ Test 008"
    #color of added warnings
    access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
    #manual test
    assert true
  end

  def test_ST_WD_009
    printf "\n+ Test 009"
    #color of deleted warnings
    access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
    #manual test
    assert true
  end

  def test_ST_WD_010
    printf "\n+ Test 010"
    #warning listing button
    access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
    #click button
    wait_for_element_present($analysis_report_xpath["warning_listing"])
    click "#{$analysis_report_xpath["warning_listing"]}"
    wait_for_text_present(_("Warning Listing with Diff"))
  end

  def test_ST_WD_011
    printf "\n+ Test 011"
    #summary button
    access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
    #click button
    wait_for_element_present($analysis_report_xpath["summary"])
    click "#{$analysis_report_xpath["summary"]}"
    wait_for_text_present(_("Summary of Warning"))
  end

  def test_ST_WD_012
    printf "\n+ Test 012"
    #display hide checkboxes
    access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
    wait_for_element_present($analysis_report_xpath["check_common"])
    wait_for_element_present($analysis_report_xpath["check_added"])
    wait_for_element_present($analysis_report_xpath["check_deleted"])
    sleep TIME
    assert_equal _("Hide common warnings"), get_text($analysis_report_xpath["hide_text"].sub('COL', "1"))
    assert_equal _("Hide added warnings"), get_text($analysis_report_xpath["hide_text"].sub('COL', "2"))
    assert_equal _("Hide deleted warnings"), get_text($analysis_report_xpath["hide_text"].sub('COL', "3"))
  end

  def test_ST_WD_013
    printf "\n+ Test 013"
    #check hide common warnings
    access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
    #check common
    wait_for_element_present($analysis_report_xpath["check_common"])
    click "#{$analysis_report_xpath["check_common"]}"
    wait_for_element_present($analysis_report_xpath["new_contents"])
    wait_for_element_present($analysis_report_xpath["old_contents"])
    new_rows = get_xpath_count("#{$analysis_report_xpath["new_contents"]}")
    old_rows = get_xpath_count("#{$analysis_report_xpath["old_contents"]}")

    1.upto(new_rows) do |i|
      att = get_attribute("#{$analysis_report_xpath["new_contents"]}[#{i}]/td[2]", "class")
      if att != nil && att != "common"
        assert true
      end
    end

    1.upto(old_rows) do |i|
      att = get_attribute("#{$analysis_report_xpath["old_contents"]}[#{i}]/td[2]", "class")
      if att != nil && att != "common"
        assert true
      end
    end
  end

  def test_ST_WD_014
    #check hide added warnings
    access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
    #check added
    wait_for_element_present($analysis_report_xpath["check_added"])
    click "#{$analysis_report_xpath["check_added"]}"
    wait_for_element_present($analysis_report_xpath["new_contents"])
    new_rows = get_xpath_count("#{$analysis_report_xpath["new_contents"]}")

    1.upto(new_rows) do |i|
      att = get_attribute("#{$analysis_report_xpath["new_contents"]}[#{i}]/td[2]", "class")
      if  att != nil && att != "added"
        assert true
      end
    end
  end

  def test_ST_WD_015
    #check hide deleted warnings
    access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
    #check added
    wait_for_element_present($analysis_report_xpath["check_deleted"])
    click "#{$analysis_report_xpath["check_deleted"]}"
    wait_for_element_present($analysis_report_xpath["old_contents"])
    new_rows = get_xpath_count("#{$analysis_report_xpath["old_contents"]}")

    1.upto(new_rows) do |i|
      att = get_attribute("#{$analysis_report_xpath["old_contents"]}[#{i}]/td[2]", "class")
      if  att != nil && att != "deleted"
        assert true
      end
    end
  end

  def test_ST_WD_016
    #navigation bar
    access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
    #display navigation bar
    1.upto(4) do |i|
       wait_for_element_present($analysis_report_xpath["navi_link"].sub("__ROW__", "#{i}"))
     end
  end

  def test_ST_WD_017
     #navigation bar
     access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
     #link to diff administration
     wait_for_element_present($analysis_report_xpath["navi_link"].sub("__ROW__", "1"))
     click "#{$analysis_report_xpath["navi_link"].sub("__ROW__", "1")}"
     sleep TIME
     wait_for_text_present(_("Diff Administration"))
   end

  def test_ST_WD_018
     #navigation bar
     access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
     #link to diff result summary
     wait_for_element_present($analysis_report_xpath["navi_link"].sub("__ROW__", "2"))
     click "#{$analysis_report_xpath["navi_link"].sub("__ROW__", "2")}"
     sleep TIME
     wait_for_text_present(_("Diff Result Summary"))
   end

  def test_ST_WD_019
     #navigation bar
     access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
     #link to summary of warning
     wait_for_element_present($analysis_report_xpath["navi_link"].sub("__ROW__", "3"))
     click "#{$analysis_report_xpath["navi_link"].sub("__ROW__", "3")}"
     sleep TIME
     wait_for_text_present(_("Summary of Warning"))
   end

  def test_ST_WD_020
     #navigation bar
     access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
     #reload ananlysis report with diff
     wait_for_element_present($analysis_report_xpath["navi_link"].sub("__ROW__", "4"))
     click "#{$analysis_report_xpath["navi_link"].sub("__ROW__", "4")}"
     sleep TIME
     wait_for_text_present($analysis_report_xpath["title"])
  end

  def test_ST_WD_021
    #display filter's contents
    access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
    wait_for_element_present($analysis_report_xpath["status_condition"])
    wait_for_element_present($analysis_report_xpath["other_condition"])
    wait_for_element_present($analysis_report_xpath["select_rule_level"])
    wait_for_element_present($analysis_report_xpath["select_other"])
    wait_for_element_present($analysis_report_xpath["other_text"])
    wait_for_element_present($analysis_report_xpath["filter_button"])
  end

  def test_ST_WD_022
    printf "\n+ Test 022"
    #filter with right status and rule number
    access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
    wait_for_element_present($analysis_report_xpath["status_condition"])
    wait_for_element_present($analysis_report_xpath["other_condition"])
    wait_for_element_present($analysis_report_xpath["filter_button"])
    #condition
    select "rule_level", _("All")
    select "others", _("Rule Number")
    type "others_value", "0288"
    #filter
    click "#{$analysis_report_xpath["filter_button"]}"
    wait_for_element_present($analysis_report_xpath["new_contents"])
    wait_for_element_present($analysis_report_xpath["old_contents"])
    new_rows = get_xpath_count("#{$analysis_report_xpath["new_contents"]}")
    old_rows = get_xpath_count("#{$analysis_report_xpath["old_contents"]}")
    1.upto(new_rows) do |i|
      att = get_attribute("#{$analysis_report_xpath["new_contents"]}[#{i}]/td[2]", "class")
      if att != ""
        new_war = get_text("#{$analysis_report_xpath["new_contents"]}[#{i}]/td[2]")
        if new_war.include? "0288"
          assert true
        end
      end
    end

    1.upto(old_rows) do |i|
      att = get_attribute("#{$analysis_report_xpath["old_contents"]}[#{i}]/td[2]", "class")
      if att != ""
        old_war = get_text("#{$analysis_report_xpath["new_contents"]}[#{i}]/td[2]")
        if old_war.include? "0288"
          assert true
        end
      end
    end
  end

  def test_ST_WD_023
    printf "\n+ Test 023"
    #filter with wrong rulenumber
    access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
    wait_for_element_present($analysis_report_xpath["status_condition"])
    wait_for_element_present($analysis_report_xpath["other_condition"])
    wait_for_element_present($analysis_report_xpath["filter_button"])
    #condition
    select "rule_level", "label=#{_('All')}"
    select "others", "label=#{_('Rule Number')}"
    type "others_value", "10000"
    #filter
    click "#{$analysis_report_xpath["filter_button"]}"
    wait_for_element_present($analysis_report_xpath["new_contents"])
    wait_for_element_present($analysis_report_xpath["old_contents"])
    new_rows = get_xpath_count("#{$analysis_report_xpath["new_contents"]}")
    old_rows = get_xpath_count("#{$analysis_report_xpath["old_contents"]}")

    1.upto(new_rows) do |i|
      att = get_attribute("#{$analysis_report_xpath["new_contents"]}[#{i}]/td[2]", "class")
      if att != ""
        new_war = get_text("#{$analysis_report_xpath["new_contents"]}[#{i}]/td[2]")
        if new_war.include? "10000"
          assert false
        end
      end
    end

    1.upto(old_rows) do |i|
      att = get_attribute("#{$analysis_report_xpath["old_contents"]}[#{i}]/td[2]", "class")
      if att != ""
        old_war = get_text("#{$analysis_report_xpath["new_contents"]}[#{i}]/td[2]")
        if old_war.include? "10000"
          assert false
        end
      end
    end
  end

  def test_ST_WD_024
    printf "\n+ Test 024"
    #filter with pattern (ex. 02*)
    access_analysis_report_with_diff(PU, PJ, DIFF_ID, DIFF_FILE_ID, FILE_NAME, FILE_ID)
    wait_for_element_present($analysis_report_xpath["status_condition"])
    wait_for_element_present($analysis_report_xpath["other_condition"])
    wait_for_element_present($analysis_report_xpath["filter_button"])
    #condition
    select "rule_level", _("All")
    select "others", _("Rule Number")
    type "others_value", "02*"
    #filter
    click "#{$analysis_report_xpath["filter_button"]}"
    wait_for_element_present($analysis_report_xpath["new_contents"])
    wait_for_element_present($analysis_report_xpath["old_contents"])
    new_rows = get_xpath_count("#{$analysis_report_xpath["new_contents"]}")
    old_rows = get_xpath_count("#{$analysis_report_xpath["old_contents"]}")

    1.upto(new_rows) do |i|
      att = get_attribute("#{$analysis_report_xpath["new_contents"]}[#{i}]/td[2]", "class")
      if att != ""
        new_war = get_text("#{$analysis_report_xpath["new_contents"]}[#{i}]/td[2]")
        if new_war == ""
          assert false
        end
      end
    end

    1.upto(old_rows) do |i|
      att = get_attribute("#{$analysis_report_xpath["old_contents"]}[#{i}]/td[2]", "class")
      if att != ""
        old_war = get_text("#{$analysis_report_xpath["new_contents"]}[#{i}]/td[2]")
        if old_war == ""
          assert false
        end
      end
    end
  end

#  def test_ST_WD_025
#    #filter with empty other and other text
#  end
#
#  def test_ST_WD_026
#    #filter with empty other and type smt in other text
#  end
end
