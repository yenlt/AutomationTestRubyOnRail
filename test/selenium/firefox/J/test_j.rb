require File.dirname(__FILE__) + "/test_j_setup" unless defined? TestJSetup
require "test/unit"

class TestJ < Test::Unit::TestCase
  include TestJSetup
  
  def test_001
  	printf "\n+ Test 001	"
  	login_analysis_log
  	#The detailed [log] link of an analysis task is clicked.
		#- A subwindow rises and an analysis execution log page is displayed.
		#click log link
		click $xpath["[log]_link"]
		#subwindow display
		wait_for_text_present($analysis_log["analysis_log_page_title"])
		sleep WAIT_TIME
  end
  
  def test_002
  	printf "\n+ Test 002	"
  	login_analysis_log
  	#An analysis execution log page is displayed.
		#Page title: Analysis execution log 
		#Task No: "task name"
		#tool : "tool name" It has become.
		#click log link
		click $xpath["[log]_link"]
		#page title
		wait_for_text_present($analysis_log["analysis_log_page_title"])
		#task name, tool name
		wait_for_element_present($analysis_log["task_tool_xpath"])
		assert_equal $analysis_log["task_tool_name"], get_text($analysis_log["task_tool_xpath"])
  end
  
  def test_003
 		printf "\n+ Test 003	"
 		login_analysis_log
  	#Navi link
		#Navi, [PU] PU name > [PJ] PJ name > task management > Analysis execution log It has become.
		#click log link
		click $xpath["[log]_link"]
		#navi link
		is_text_present($analysis_log["navi_link"])
		
  end
  
  def test_004
  	printf "\n+ Test 004	"
  	login_analysis_log
  	#■ The state of the subtask of the present [: / state ] is displayed.
		#click log link
		click $xpath["[log]_link"]
		#subwindow display
		wait_for_text_present($analysis_log["analysis_log_page_title"])
		#state of subtask
		wait_for_element_present($analysis_log["analyzer_run_end"])
		assert_equal $analysis_log["analyzer_run_end_text"], get_text($analysis_log["analyzer_run_end"])
  end
  
  def test_005
  	printf "\n+ Test 005	"
  	login_analysis_log
  	#The advance situation of analysis is as the following format. 
  	#The number of files / the number of analysis files which carried out the completion of analysis, 
  	#and an error (the number of error files)
		#click log link
		click $xpath["[log]_link"]
		#subwindow display
		wait_for_text_present($analysis_log["analysis_log_page_title"])
		#analysis file and error
		wait_for_element_present($analysis_log["analysis_progress_error"])
		assert_equal $analysis_log["analysis_progress_error_text"], get_text($analysis_log["analysis_progress_error"])
  end
  
  def test_006
  	printf "\n+ Test 006	"
  	login_analysis_log
  	#Since the error file of the number of files / the number of analysis files which carried out the completion of analysis, 
  	#and the error (the number of error files) is a link, it is clicked.
		#The subwindow which enumerated the file names from which the error was detected. It appears.
		#click log link
		click $xpath["[log]_link"]
		#subwindow display
		wait_for_text_present($analysis_log["analysis_log_page_title"])
  	#click error
  	wait_for_element_present($analysis_log["error_sub_window_link"])
  	click $analysis_log["error_sub_window_link"]
  	#display error sub window
  	wait_for_element_present($analysis_log["error_files"])
  	sleep 2
  end
  
  def test_007
  	printf "\n+ Test 007	"
  	login_analysis_log
  	#The file name in the present analysis is displayed on the file in analysis.
		#click log link
		click $xpath["[log]_link"]
		#subwindow display
		wait_for_text_present($analysis_log["analysis_log_page_title"])
  	#click error
  	wait_for_element_present($analysis_log["error_sub_window_link"])
  	click $analysis_log["error_sub_window_link"]
  	#display error sub window
  	wait_for_element_present($analysis_log["error_files"])
  	#file name display
  	assert_equal $analysis_log["error_files_name"], get_text($analysis_log["error_files"])
  end
  
  def test_008
  	printf "\n+ Test 008	"
  	login_analysis_log
  	#The number of the analyzed files goes into the number of analysis files.
		#click log link
		click $xpath["[log]_link"]
		#subwindow display
		wait_for_text_present($analysis_log["analysis_log_page_title"])
  	#number of analyzed files
  	wait_for_element_present($analysis_log["analysis_files"])
  	assert_equal "6", get_text($analysis_log["analysis_files"])
  end
  
  def test_009
  	printf "\n+ Test 009	"
  	login_analysis_log
  	#An analysis execution log page is displayed.
		#The analysis log text is operated orthopedically and displayed.
		#click log link
		click $xpath["[log]_link"]
		#subwindow display
		wait_for_text_present($analysis_log["analysis_log_page_title"])
		#analysis log text displayed
		wait_for_element_present($analysis_log["analysis_log_text"])
  end

end
