require File.dirname(__FILE__) + "/test_h_setup" unless defined? TestHSetup
require "test/unit"

class TestH < Test::Unit::TestCase
  include TestHSetup
  
  def test_001
  	printf "\n+ Test 001	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#display right contents
  	#whole title
  	wait_for_text_present($result_index_xpath["whole"])
  	wait_for_text_present(_("Rule Level"))
	  wait_for_text_present(_("Analysis summary"))
	  wait_for_text_present(_("Count for every directory"))
	  wait_for_text_present(_("Count for every file"))
	  wait_for_text_present(_("Count for every rule"))
	  assert_equal "Critical",get_text($result_index_xpath["whole_rule_level"]+"[2]/th")
		assert_equal "Hi Risk",get_text($result_index_xpath["whole_rule_level"]+"[3]/th")
		assert_equal "Normal",get_text($result_index_xpath["whole_rule_level"]+"[4]/th")
  	#module title
  	wait_for_text_present($result_index_xpath["module"])
  	wait_for_text_present(_("Module"))
	  wait_for_text_present(_("Rule level"))
	  wait_for_text_present(_("Summary of each file"))
	  wait_for_text_present(_("Count for every directory"))
	  wait_for_text_present(_("Count for every file"))
	  wait_for_text_present(_("Count for every rule"))
	  #root
	  assert_equal "Critical",get_text($result_index_xpath["module_rule_level"]+"[3]/th")
		assert_equal "High",get_text($result_index_xpath["module_rule_level"]+"[4]/th")
		assert_equal "Normal",get_text($result_index_xpath["module_rule_level"]+"[5]/th")
		#sample_c/src
		assert_equal "Critical",get_text($result_index_xpath["module_rule_level"]+"[7]/th")
		assert_equal "High",get_text($result_index_xpath["module_rule_level"]+"[8]/th")
		assert_equal "Normal",get_text($result_index_xpath["module_rule_level"]+"[9]/th")
  	#everyfile title
  	wait_for_text_present($result_index_xpath["every_file"])
  	#no gap in table under whole
  	assert_equal 4, get_xpath_count($result_index_xpath["whole_row_count"])
		assert_equal 5, get_xpath_count($result_index_xpath["whole_col_count"])
  end
  
  def test_002
  	printf "\n+ Test 002	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#nogap in table under module
  	assert_equal 6, get_xpath_count($result_index_xpath["module_col_count"])
  	assert_equal 6, get_xpath_count($result_index_xpath["module_row_count"])
  end
  
  def test_003
 		printf "\n+ Test 003	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#no garbled character
  	body_text = get_text("//body")
    assert_equal body_text, get_body_text
  end
  
  def test_004
  printf "\n+ Test 004	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#assert link under whole
  	wait_for_element_present($result_index_xpath["link_under_whole"]+"[2]/td[1]/a")
  	wait_for_element_present($result_index_xpath["link_under_whole"]+"[3]/td[1]/a")
  	wait_for_element_present($result_index_xpath["link_under_whole"]+"[4]/td[1]/a")
  	#dead link not started
  end
  
  def test_005
  	printf "\n+ Test 005	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#click link under whole
  	click $result_index_xpath["link_under_whole"]+"[2]/td[1]/a"
  	#link to suitable page
  	wait_for_text_present($critical_summary["critical_page_title"])
  end
  
  def test_006
  	printf "\n+ Test 006	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#assert link under module
  	wait_for_element_present($result_index_xpath["link_under_module"]+"[3]/td[1]/a")
  	wait_for_element_present($result_index_xpath["link_under_module"]+"[4]/td[1]/a")
  	wait_for_element_present($result_index_xpath["link_under_module"]+"[5]/td[1]/a")
  	wait_for_element_present($result_index_xpath["link_under_module"]+"[7]/td[1]/a")
  	wait_for_element_present($result_index_xpath["link_under_module"]+"[8]/td[1]/a")
  	wait_for_element_present($result_index_xpath["link_under_module"]+"[9]/td[1]/a")
  	#dead link not started
  end
  
  def test_007
  	printf "\n+ Test 007	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#click link under whole
  	click $result_index_xpath["link_under_module"]+"[3]/td[1]/a"
  	#link to suitable page
  	wait_for_text_present($critical_summary["critical_page_title"])
  end
  
  def test_008
  	printf "\n+ Test 008	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#assert link under every file
  	#root
  	wait_for_element_present($result_index_xpath["link_under_file_root"]+"[1]/a")
  	wait_for_element_present($result_index_xpath["link_under_file_root"]+"[2]/a")
  	wait_for_element_present($result_index_xpath["link_under_file_root"]+"[3]/a")
  	#sample_c/src
  	wait_for_element_present($result_index_xpath["link_under_file_sample_c/src"]+"[1]/a")
  	wait_for_element_present($result_index_xpath["link_under_file_sample_c/src"]+"[2]/a")
  	wait_for_element_present($result_index_xpath["link_under_file_sample_c/src"]+"[3]/a")
  	wait_for_element_present($result_index_xpath["link_under_file_sample_c/src"]+"[4]/a")
  	wait_for_element_present($result_index_xpath["link_under_file_sample_c/src"]+"[5]/a")
  	wait_for_element_present($result_index_xpath["link_under_file_sample_c/src"]+"[6]/a")
  	wait_for_element_present($result_index_xpath["link_under_file_sample_c/src"]+"[7]/a")
  	wait_for_element_present($result_index_xpath["link_under_file_sample_c/src"]+"[8]/a")
  	wait_for_element_present($result_index_xpath["link_under_file_sample_c/src"]+"[9]/a")
  	#dead link not started
  end
  
  def test_009
  	printf "\n+ Test 009	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#click link under whole
  	click $result_index_xpath["link_under_file_root"]+"[1]/a"
  	#link to suitable page
  	wait_for_text_present($critical_summary["critical_page_title"])
  end
  
  def test_010
  	printf "\n+ Test 010	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#click link under whole
  	click $result_index_xpath["link_under_file_root"]+"[1]/a"
  	#link to summary page
  	wait_for_text_present($critical_summary["critical_page_title"])
  	#no garbled character
  	body_text = get_text("//body")
    assert_equal body_text, get_body_text
  end
  
  def test_011
  	printf "\n+ Test 011	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#click link under whole
  	click $result_index_xpath["link_under_file_root"]+"[1]/a"
  	#link to summary page
  	wait_for_text_present($critical_summary["critical_page_title"])
  	#link [returning]
  	wait_for_text_present(_("Back"))
  	wait_for_element_present($xpath["link_return"])
  	#dead link not started
  end
  
  def test_012
  	printf "\n+ Test 012	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#click link under whole
  	click $result_index_xpath["link_under_file_root"]+"[1]/a"
  	#link to summary page
  	wait_for_text_present($critical_summary["critical_page_title"])
  	#link [returning]
  	wait_for_text_present(_("Back"))
  	wait_for_element_present($xpath["link_return"])
  	#click link [returning]
  	click $xpath["link_return"]
  	wait_for_text_present(_("Analysis Result"))
  	#link to previous page
  end
  
  def test_013
  	printf "\n+ Test 013	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#click link under whole
  	click $result_index_xpath["link_under_file_root"]+"[1]/a"
  	#link to summary page
  	wait_for_text_present($critical_summary["critical_page_title"])
  	#link to view message
  	wait_for_element_present($critical_summary["link_to_view_message_page"])
  	#dead link not started
  end
  
  def test_014
  	printf "\n+ Test 014	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#click link under whole
  	click $result_index_xpath["link_under_file_root"]+"[1]/a"
  	#link to summary page
  	wait_for_text_present($critical_summary["critical_page_title"])
  	#link to view message
  	wait_for_element_present($critical_summary["link_to_view_message_page"])
  	click $critical_summary["link_to_view_message_page"]
  	wait_for_text_present("QAC#{_("Message")}")
  	#link to suitable page
  end
  
  def test_015
  	printf "\n+ Test 015	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#click link under whole
  	click $result_index_xpath["link_under_file_root"]+"[1]/a"
  	#link to summary page
  	wait_for_text_present($critical_summary["critical_page_title"])
  	#link to view result
  	wait_for_element_present($critical_summary["link_to_view_result_page"])
  	#dead link not started
  end
  
  def test_016
  	printf "\n+ Test 016	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#link to summary page
  	click $result_index_xpath["link_under_file_root"]+"[1]/a"
  	wait_for_text_present($critical_summary["critical_page_title"])
  	#link to view result
  	wait_for_element_present($critical_summary["link_to_view_result_page"])
  	click $critical_summary["link_to_view_result_page"]
  	wait_for_text_present("#{_("Analysis Result")}(#{_("Summary")})")
  	#link to suitable page
  end
  
  def test_017
  	printf "\n+ Test 017	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#link to source page
  	click $result_index_xpath["link_under_file_sample_c/src"]+"[5]/a"
  	wait_for_text_present($critical_source["critical_page_title"])
  	#no garbled character
  	body_text = get_text("//body")
    assert_equal body_text, get_body_text
  end
  
  def test_018
  	printf "\n+ Test 018	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#link to source page
  	click $result_index_xpath["link_under_file_sample_c/src"]+"[5]/a"
  	wait_for_text_present($critical_source["critical_page_title"])
  	#link [returning]
  	wait_for_text_present(_("Back"))
  	#dead link not started
  end
  
  def test_019
 		printf "\n+ Test 019	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#link to source page
  	click $result_index_xpath["link_under_file_sample_c/src"]+"[5]/a"
  	wait_for_text_present($critical_source["critical_page_title"])
  	#link [returning]
  	wait_for_text_present("[#{_("Back")}]")
  	wait_for_element_present($xpath["link_return"])
  	#click link [returning]
  	click $xpath["link_return"]
  	wait_for_text_present($title["analysis_result"])
  	#link to previous page
  end
  
  def test_020
  	printf "\n+ Test 020	"#no garbled character
  	body_text = get_text("//body")
    assert_equal body_text, get_body_text
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#link to source page
  	click $result_index_xpath["link_under_file_sample_c/src"]+"[5]/a"
  	wait_for_text_present($critical_source["critical_page_title"])
  	#link to view message
  	wait_for_element_present($critical_source["link_to_view_message_page"])
  	#dead link not started
  end
  
  def test_021
  	printf "\n+ Test 021	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#link to source page
  	click $result_index_xpath["link_under_file_sample_c/src"]+"[5]/a"
  	wait_for_text_present($critical_source["critical_page_title"])
  	#link to view message
  	click $critical_source["link_to_view_message_page"]
  	wait_for_text_present("QAC#{_("Message")}")
		#link to suitable page  	
  end

	def test_022
		printf "\n+ Test 022	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#link to summary page
  	click $result_index_xpath["link_under_file_root"]+"[1]/a"
  	wait_for_text_present($critical_summary["critical_page_title"])
  	#link to view message page
  	click $critical_summary["link_to_view_message_page"]
  	wait_for_text_present("QAC#{_("Message")}")
  	#no garbled character
  	body_text = get_text("//body")
    assert_equal body_text, get_body_text
	end
	
	def test_023
		printf "\n+ Test 023	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#link to summary page
  	click $result_index_xpath["link_under_file_root"]+"[1]/a"
  	wait_for_text_present($critical_summary["critical_page_title"])
  	#link to view message page
  	click $critical_summary["link_to_view_message_page"]
  	wait_for_text_present("QAC#{_("Message")}")
  	#link to view misc page
  	wait_for_element_present($view_message["link_to_view_misc_page"])
  	#dead link not started
	end
	
	def test_024
		printf "\n+ Test 024	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#link to summary page
  	click $result_index_xpath["link_under_file_root"]+"[1]/a"
  	wait_for_text_present($critical_summary["critical_page_title"])
  	#link to view message page
  	click $critical_summary["link_to_view_message_page"]
  	wait_for_text_present("QAC#{_("Message")}")
  	#link to view misc page
  	wait_for_element_present($view_message["link_to_view_misc_page"])
  	click $view_message["link_to_view_misc_page"]
  	wait_for_text_present($view_message["view_misc_page_title"])
  	sleep WAIT_TIME
	end
	
	def test_025
		printf "\n+ Test 025	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#link to summary page
  	click $result_index_xpath["link_under_file_root"]+"[1]/a"
  	wait_for_text_present($critical_summary["critical_page_title"])
  	#link to view message page
  	click $critical_summary["link_to_view_message_page"]
  	wait_for_text_present("QAC#{_("Message")}")
  	#check link to view message
  	wait_for_element_present($view_message["next_message"])
  	wait_for_element_present($view_message["previous_message"])
  	#dead link not started
	end
	
	def test_026
		printf "\n+ Test 026	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#link to summary page
  	click $result_index_xpath["link_under_file_root"]+"[1]/a"
  	wait_for_text_present($critical_summary["critical_page_title"])
  	#link to view message page
  	click $critical_summary["link_to_view_message_page"]
  	wait_for_text_present("QAC#{_("Message")}")
  	#link to next message
  	wait_for_element_present($view_message["next_message"])
  	click $view_message["next_message"]
  	wait_for_text_present("QAC#{_("Message")}")
  	sleep WAIT_TIME
  	#link to previous message
  	wait_for_element_present($view_message["previous_message"])
  	click $view_message["previous_message"]
  	wait_for_text_present("QAC#{_("Message")}")
  	sleep WAIT_TIME
	end
	
	def test_027
		printf "\n+ Test 027	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#click link under whole
  	click $result_index_xpath["link_under_file_root"]+"[1]/a"
  	#link to summary page
  	wait_for_text_present($critical_summary["critical_page_title"])
  	#link to view message
  	wait_for_element_present($critical_summary["link_to_view_message_page"])
  	click $critical_summary["link_to_view_message_page"]
  	wait_for_text_present("QAC#{_("Message")}")
  	#link to view misc page
  	wait_for_element_present($view_message["link_to_view_misc_page"])
  	click	$view_message["link_to_view_misc_page"]
  	wait_for_text_present($view_message["view_misc_page_title"])
  	#no garbled character
  	body_text = get_text("//body")
    assert_equal body_text, get_body_text
	end
	
	def test_028
		printf "\n+ Test 028	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#click link under whole
  	click $result_index_xpath["link_under_file_root"]+"[1]/a"
  	#link to summary page
  	wait_for_text_present($critical_summary["critical_page_title"])
  	#link to view message
  	wait_for_element_present($critical_summary["link_to_view_message_page"])
  	click $critical_summary["link_to_view_message_page"]
  	wait_for_text_present("QAC#{_("Message")}")
  	#link to view misc page
  	wait_for_element_present($view_message["link_to_view_misc_page"])
  	click	$view_message["link_to_view_misc_page"]
  	wait_for_text_present($view_message["view_misc_page_title"])
  	#assert link to view message
  	wait_for_element_present($view_misc["link_to_view_message_page"])
  	#dead link not started
	end
	
	def test_029
		printf "\n+ Test 029	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#click link under whole
  	click $result_index_xpath["link_under_file_root"]+"[1]/a"
  	#link to summary page
  	wait_for_text_present($critical_summary["critical_page_title"])
  	#link to view message
  	wait_for_element_present($critical_summary["link_to_view_message_page"])
  	click $critical_summary["link_to_view_message_page"]
  	wait_for_text_present("QAC#{_("Message")}")
  	#link to view misc page
  	wait_for_element_present($view_message["link_to_view_misc_page"])
  	click	$view_message["link_to_view_misc_page"]
  	wait_for_text_present($view_message["view_misc_page_title"])
  	#link to other view message page
  	click $view_misc["link_to_view_message_page"]
  	wait_for_text_present($view_misc["view_message_page_title"])
  	sleep WAIT_TIME
	end
	
	def test_030
		printf "\n+ Test 030	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#click link under whole
  	click $result_index_xpath["link_under_file_root"]+"[1]/a"
  	#link to summary page
  	wait_for_text_present($critical_summary["critical_page_title"])
  	#link to view message
  	wait_for_element_present($critical_summary["link_to_view_message_page"])
  	click $critical_summary["link_to_view_message_page"]
  	wait_for_text_present("QAC#{_("Message")}")
  	#link to view misc page
  	wait_for_element_present($view_message["link_to_view_misc_page"])
  	click	$view_message["link_to_view_misc_page"]
  	wait_for_text_present($view_message["view_misc_page_title"])
  	#assert link to view misc
  	wait_for_element_present($view_misc["link_to_view_misc_page"])
  	#dead link not started
	end
	
	def test_031
		printf "\n+ Test 031	"
  	goto_Result_Index_page
  	wait_for_text_present($title["analysis_result"])
  	#click link under whole
  	click $result_index_xpath["link_under_file_root"]+"[1]/a"
  	#link to summary page
  	wait_for_text_present($critical_summary["critical_page_title"])
  	#link to view message
  	wait_for_element_present($critical_summary["link_to_view_message_page"])
  	click $critical_summary["link_to_view_message_page"]
  	wait_for_text_present("QAC#{_("Message")}")
  	#link to view misc page
  	wait_for_element_present($view_message["link_to_view_misc_page"])
  	click	$view_message["link_to_view_misc_page"]
  	wait_for_text_present($view_message["view_misc_page_title"])
  	#link to other view message page
  	click $view_misc["link_to_view_misc_page"]
  	wait_for_text_present($view_misc["view_misc_page_title"])
  	sleep WAIT_TIME
	end
	
	def test_032
		printf "\n+ Test 032	"
  	goto_Result_Index_page
  	#index page display
  	#analysis result
  	wait_for_text_present($title["analysis_result"])
  	#task name
  	wait_for_text_present($title["task_name"])
  	#tool name
  	wait_for_text_present($title["tool_name"])
	end
	
	def test_033
		printf "\n+ Test 033	"
  	goto_Result_Index_page
  	#a view result page display
  	wait_for_element_present($result_index_xpath["link_under_whole"])
  	click $result_index_xpath["link_under_whole"]+"[2]/td[1]/a"
  	#analysis result
  	wait_for_text_present($title["analysis_result"])
  	#file name
  	wait_for_text_present($title["file_name"])
  	#task name
  	wait_for_text_present($title["task_name"])
  	#tool name
  	wait_for_text_present($title["tool_name"])
	end

	def test_034
		printf "\n+ Test 034	"
  	goto_Result_Index_page
  	#index page display
  	#navi link
  	#PU name
  	wait_for_element_present($title["pu_name"])
  	assert_equal "[PU] SamplePU1", get_text($title["pu_name"])
  	#PJ name
  	wait_for_element_present($title["pu_name"])
  	assert_equal "[PJ] SamplePJ1", get_text($title["pj_name"])
  	#task management
  	wait_for_element_present($title["task_management"])
  	assert_equal _("Analysis Task Administration"), get_text($title["task_management"])
  	#analysis result index
  	wait_for_element_present($title["analysis_result_index"])
  	assert_equal _("Index of Analysis Results"), get_text($title["analysis_result_index"])
	end
	
	def test_035
		printf "\n+ Test 035	"
  	goto_Result_Index_page
  	#view result page display
		wait_for_element_present($result_index_xpath["link_under_file_root"]+"[1]/a")
		click $result_index_xpath["link_under_file_root"]+"[1]/a"
		#navi link
  	#PU name
  	wait_for_element_present($title["pu_name"])
  	assert_equal "[PU] SamplePU1", get_text($title["pu_name"])
  	#PJ name
  	wait_for_element_present($title["pu_name"])
  	assert_equal "[PJ] SamplePJ1", get_text($title["pj_name"])
  	#task management
  	wait_for_element_present($title["task_management"])
  	assert_equal _("Analysis Task Administration"), get_text($title["task_management"])
  	#analysis result index
  	wait_for_element_present($title["analysis_result_index"])
  	assert_equal _("Index of Analysis Results"), get_text($title["analysis_result_index"])
		#analysis result(type)
		wait_for_element_present($title["analysis_result_type"])
		assert_equal "#{_("Analysis Result")}(#{_("Summary")})", get_text($title["analysis_result_type"])
	end
end
