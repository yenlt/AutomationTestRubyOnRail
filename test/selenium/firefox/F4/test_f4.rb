require File.dirname(__FILE__) + "/test_f4_setup" unless defined? TestF4Setup
require "test/unit"

class TestF4 < Test::Unit::TestCase
  include TestF4Setup

  def setup
    @verification_errors = []
    if $lang == "en"
      @overall = "Overall Analyze"
      @individual= "Individual Analyze"
    elsif $lang == "ja"
      @overall = "全体解析"
      @individual = "個人解析"
    end
    if $selenium
      @selenium = $selenium
    else
      @selenium = Selenium::SeleniumDriver.new(SELENIUM_CONFIG)
      @selenium.start
    end
  end

  def teardown
    @selenium.stop unless $selenium
    assert_equal [], @verification_errors
    write_log
  end
 
  def test_001
  	printf "\n+ Test 001	"
  	user_login("pj_admin", "pj_admin")
  	#The task type is set to whole analysis
    assert_equal @overall, get_selected_label("analyze_type")
    sleep WAIT_TIME
  end
  
  def test_002
  	printf "\n+ Test 002	"
  	user_login("pj_admin", "pj_admin")
  	#A task type can be changed to individual analysis
  	select "analyze_type", "label=#{@individual}"
    assert_equal @individual, get_selected_label("analyze_type")
    sleep WAIT_TIME
  end

  def test_003
  	printf "\n+ Test 003	"
  	user_login("pj_member", "pj_member")
  	#The task type is set to individual analysis
    assert_equal @individual, get_selected_label("analyze_type")
    sleep WAIT_TIME
  end

  def test_004
  	printf "\n+ Test 004  "
  	user_login("pj_member", "pj_member")
  	#A task type cannot be changed to whole analysis
  	assert_not_equal @overall, get_select_options("analyze_type").join(",")
    assert_not_equal @overall, get_selected_label("analyze_type")
    sleep WAIT_TIME
  end

  def test_005
  	printf "\n+ Test 005	"
  	login_general_control
		#selection qac normal
		wait_for_element_present($general_control["qac_selection_normal"])
		click $general_control["qac_selection_normal"]
		#load indicator displayed
		str = get_attribute($general_control["selection"], "onclick")
		indicator = str.include? "set_load_indicator"
		begin
			assert indicator
		rescue Exception => e
			printf "- Test Failed! Load indicator did not displayed"
			assert false
		end
		wait_for_text_present($general_control["general_control_text"])
  end

  def test_006
  	printf "\n+ Test 006	"
  	login_general_control
		#selection qac normal
		wait_for_element_present($general_control["qac_selection_normal"])
		click $general_control["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($general_control["general_control_text"])
		run_script("destroy_subwindow()")
		#selection qac high
		wait_for_element_present($general_control["qac_selection_high"])
		click $general_control["qac_selection_high"]
		sleep WAIT_TIME
		wait_for_text_present($general_control["general_control_text"])
		run_script("destroy_subwindow()")
		#selection qac critical
		wait_for_element_present($general_control["qac_selection_critical"])
		click $general_control["qac_selection_critical"]
		sleep WAIT_TIME
		wait_for_text_present($general_control["general_control_text"])

  end

  def test_007
 		printf "\n+ Test 007	"
 		login_general_control
		#selection qac++ normal
		wait_for_element_present($general_control["qac++_selection_normal"])
		click $general_control["qac++_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($general_control["general_control_text"])
		run_script("destroy_subwindow()")
		#selection qac++ high
		wait_for_element_present($general_control["qac++_selection_high"])
		click $general_control["qac++_selection_high"]
		sleep WAIT_TIME
		wait_for_text_present($general_control["general_control_text"])
		run_script("destroy_subwindow()")
		#selection qac++ critical
		wait_for_element_present($general_control["qac++_selection_critical"])
		click $general_control["qac++_selection_critical"]
		sleep WAIT_TIME
		wait_for_text_present($general_control["general_control_text"])

  end

  def test_008
  	printf "\n+ Test 008	"
  	login_general_control
  	#selection qac normal
		wait_for_element_present($general_control["qac_selection_normal"])
		click $general_control["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($general_control["general_control_text"])
		#no analytical rule checked
		wait_for_element_present($general_control["check_rule"])
		check_count = get_xpath_count($general_control["check_rule"])
		1.upto(check_count)	do  |i|
			rule = $general_control["check_rule"]+ "["+i.to_s + $general_control["check_rule_id"]
			assert !is_checked(rule)
		end

  end

  def test_009
  	printf "\n+ Test 009	"
  	login_general_control
  	#selection qac normal
		wait_for_element_present($general_control["qac_selection_normal"])
		click $general_control["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($general_control["general_control_text"])
		#no analytical rule checked
		wait_for_element_present($general_control["check_rule"])
		rule = $general_control["check_rule"] + "[1" + $general_control["check_rule_id"]
		click rule
		assert is_checked(rule)

  end

  def test_010
  	printf "\n+ Test 010	"
  	login_general_control
  	#setting rule is characters string
  	type "qac_rule1", "f4 invalid"
		#selection qac normal
		wait_for_element_present($general_control["qac_selection_normal"])
		click $general_control["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($general_control["general_control_text"])
		#no analytical rule checked
		wait_for_element_present($general_control["check_rule"])
		check_count = get_xpath_count($general_control["check_rule"])
		1.upto(check_count)	do  |i|
			rule = $general_control["check_rule"]+ "["+i.to_s + "]/td[2]"
			assert_not_equal "invalid", get_text(rule)
		end

  end

  def test_011
  	printf "\n+ Test 011	"
  	login_general_control
  	#setting rule = 0
  	type "qac_rule1", "8"
		#selection qac normal
		wait_for_element_present($general_control["qac_selection_normal"])
		click $general_control["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($general_control["general_control_text"])
		wait_for_element_present($general_control["check_rule"])
		#rule number not displayed
		check_count = get_xpath_count($general_control["check_rule"])
		1.upto(check_count)	do  |i|
			rule_number = $general_control["check_rule"]+ "["+i.to_s + "]/td[2]"
			assert_not_equal "22", get_text(rule_number)
			#no analytical rule checked
			rule = $general_control["check_rule"]+ "[" +i.to_s + $general_control["check_rule_id"]
			assert !is_checked(rule)
		end

  end

  def test_012
  	printf "\n+ Test 012	"
  	login_general_control
  	#setting rule
  	type "qac_rule1", "8"
  	#selection qac normal
		wait_for_element_present($general_control["qac_selection_normal"])
		click $general_control["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($general_control["general_control_text"])
		wait_for_text_present(_("Register"))
		click $general_control["registration"]
		wait_for_element_present($general_control["qac_text_normal"])
		sleep WAIT_TIME
		begin
			assert_equal "", get_value("qac_rule1")
		rescue Exception => e
			printf "- Test Failed! "
			assert false
		end
  end

  def test_013
  	printf "\n+ Test 013	"
  	login_general_control
  	#selection qac normal
		wait_for_element_present($general_control["qac_selection_normal"])
		click $general_control["qac_selection_normal"]
		sleep WAIT_TIME
    link_page_count = get_xpath_count($general_control["link_page"])
    1.upto(link_page_count) do  |i|
      link = get_text($general_control["link_page"] + "[" + i.to_s + "]")
      #link to each page
      click "link=#{link}"
      sleep WAIT_TIME
      rule_list_count = get_xpath_count($general_control["rule_list"])
      all_rules = []
      #get all rules
      1.upto(rule_list_count) do  |j|
        all_rules << get_text($general_control["rule_list"]+ "[" + j.to_s + "]/td[2]")
      end
      #assert no dupicate
    	no_duplication_rules = all_rules.uniq
    	assert_equal no_duplication_rules, all_rules
    end

  end

  def test_014
  	printf "\n+ Test 014	"
  	login_general_control
  	#selection qac normal
		wait_for_element_present($general_control["qac_selection_normal"])
		click $general_control["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_element_present($general_control["rule_list"])
		#check rule
		click $general_control["first_rule"]
		assert is_checked($general_control["first_rule"])
		#link to other page
		click $general_control["link_page"] + "[2]"
		sleep WAIT_TIME
		wait_for_text_present($general_control["general_control_text"])
		#back to first page
		click $general_control["link_page"] + "[1]"
		sleep WAIT_TIME
		#rule still checked
		wait_for_element_present($general_control["rule_list"])
		assert is_checked($general_control["first_rule"])
  end

  def test_015
  	printf "\n+ Test 015	"
  	login_general_control
		#selection qac normal
		wait_for_element_present($general_control["qac_selection_normal"])
		click $general_control["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($general_control["general_control_text"])
		wait_for_element_present($general_control["check_button"])
		#click check button
		click $general_control["check_button"]
		sleep WAIT_TIME
		#all checker checked
		check_count = get_xpath_count($general_control["check_rule"])
		1.upto(check_count)	do  |i|
			rule = $general_control["check_rule"]+ "[" +i.to_s + $general_control["check_rule_id"]
			assert is_checked(rule)
		end
  end

  def test_016
  	printf "\n+ Test 016	"
  	login_general_control
		#selection qac normal
		wait_for_element_present($general_control["qac_selection_normal"])
		click $general_control["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($general_control["general_control_text"])
		#check one rule
		wait_for_element_present($general_control["first_rule"])
		click $general_control["first_rule"]
		assert is_checked($general_control["first_rule"])
		#click clear button
		wait_for_element_present($general_control["clear_button"])
		click $general_control["clear_button"]
		sleep WAIT_TIME
		#all checker unchecked
		check_count = get_xpath_count($general_control["check_rule"])
		1.upto(check_count)	do  |i|
			rule = $general_control["check_rule"]+ "[" +i.to_s + $general_control["check_rule_id"]
			assert !is_checked(rule)
		end
  end

  def test_017
  	printf "\n+ Test 017	"
  	login_general_control
		#selection qac normal
		wait_for_element_present($general_control["qac_selection_normal"])
		click $general_control["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($general_control["general_control_text"])
		#check one rule
		wait_for_element_present($general_control["first_rule"])
		click $general_control["first_rule"]
		assert is_checked($general_control["first_rule"])
		#click is check all button
		wait_for_element_present($general_control["is_check_all_button"])
		click $general_control["is_check_all_button"]
		sleep WAIT_TIME
		#rest of checker will be checked
		link_page_count = get_xpath_count($general_control["link_page"])
		1.upto(link_page_count) do  |i|
      link = get_text($general_control["link_page"] + "[" + i.to_s + "]")
      #link to each page
      click "link=#{link}"
      sleep WAIT_TIME
      rule_list_count = get_xpath_count($general_control["rule_list"])
			1.upto(rule_list_count)	do  |i|
				rule = $general_control["check_rule"]+ "[" +i.to_s + $general_control["check_rule_id"]
				assert is_checked(rule)
			end
		end
  end

  def test_018
  	printf "\n+ Test 018	"
  	login_general_control
		#selection qac normal
		wait_for_element_present($general_control["qac_selection_normal"])
		click $general_control["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($general_control["general_control_text"])
		#check one rule
		wait_for_element_present($general_control["first_rule"])
		click $general_control["first_rule"]
		assert is_checked($general_control["first_rule"])
		#click is clear all button
		wait_for_element_present($general_control["is_clear_all_button"])
		click $general_control["is_clear_all_button"]
		sleep WAIT_TIME
		#rest of checker will be unchecked
		link_page_count = get_xpath_count($general_control["link_page"])
		1.upto(link_page_count) do  |i|
      link = get_text($general_control["link_page"] + "[" + i.to_s + "]")
      #link to each page
      click "link=#{link}"
      sleep WAIT_TIME
      rule_list_count = get_xpath_count($general_control["rule_list"])
			1.upto(rule_list_count)	do  |i|
				rule = $general_control["check_rule"]+ "[" +i.to_s + $general_control["check_rule_id"]
				assert !is_checked(rule)
			end
		end
  end

  def test_019
  	printf "\n+ Test 019	"
  	login_general_control
  	#selection qac normal
		wait_for_element_present($general_control["qac_selection_normal"])
		click $general_control["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($general_control["general_control_text"])
		#check one rule
		wait_for_element_present($general_control["first_rule"])
		click $general_control["first_rule"]
		#registration
		click $general_control["registration"]
		wait_for_element_present($general_control["qac_text_normal"])
		sleep WAIT_TIME
		#The checked analytical rule is stored in a text field
		assert_equal "9", get_value($general_control["qac_text_normal"])
  end

  def test_020
  	printf "\n+ Test 020	"
  	login_general_control
  	#selection qac normal
		wait_for_element_present($general_control["default"])
		click $general_control["default"]
		assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
  end

  def test_021
  	printf "\n+ Test 021	"
  	login_general_control
  	#setting rule
  	type "qac_rule1", "9"
  	#selection qac normal
		wait_for_element_present($general_control["default"])
		choose_ok_on_next_confirmation
		click $general_control["default"]
		assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
		sleep WAIT_TIME
		#reset to default setting
		wait_for_element_present($general_control["qac_text_normal"])
		assert_equal "", get_value($general_control["qac_text_normal"])
  end

  def test_022
 		printf "\n+ Test 022	"
  	login_general_control
  	#setting rule
  	type "qac_rule1", "9"
  	#selection qac normal
		wait_for_element_present($general_control["default"])
		choose_cancel_on_next_confirmation
		click $general_control["default"]
		assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
		sleep WAIT_TIME
		#nothing change
		wait_for_element_present($general_control["qac_text_normal"])
		assert_equal "9", get_value($general_control["qac_text_normal"])
  end

end
