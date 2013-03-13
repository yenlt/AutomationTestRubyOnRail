require File.dirname(__FILE__) + "/../../config/test_helper" unless defined? ENV["RAILS_ENV"]
require File.dirname(__FILE__) + "/../../config/selenium_setup" unless defined? SeleniumSetup



unless defined?(TestVMFSetup)
  module TestVMFSetup
    include SeleniumSetup
    include GetText
    
UNCOMPLETE_ID=4
COMPLETE_ID=5
NEW_ID=1000
OLD_ID=1
WAIT_TIME= 4
PAGE_LOAD_TIME= "30000"
PU_ID=1
PJ_ID=1
TASK_ID=1

$page_title = {
	"misc_page_title"													=>	_("User Page"),
	"task_details_page_title"									=>	_("Details of an Analysis Task"),
	"metric_view_page_title"									=>	_("Metric View")
}

$xpath_link = {
	"xpath_to_metric_page"										=>	"//tbody[@id='log_and_result']/tr[3]/td/a"
}

$file_table_tab =	{
	#button
	"analyze_tool_check_all"									=>	"//div[@id='1_file_analyze_tools']/h3/input[1]",
	"analyze_tool_uncheck_all"								=>	"//div[@id='1_file_analyze_tools']/h3/input[2]",
	"select_metrics_check_all"								=>	"//div[@id='1_file_table_metrics']/h3/input[1]",
	"select_metrics_uncheck_all"							=>	"//div[@id='1_file_table_metrics']/h3/input[2]",
	"customize"																=>	"//input[@value='Customize']",
	"download_csv"														=>	"//input[@value='Download CSV Format']",
	#radio checker
	"QAC_radio"																=>	"//input[@id='1_file_QAC']",
	"QAC++_radio"															=>	"//input[@id='1_file_QAC++']",
	"STFNC_radio"															=>	"//input[@id='1_file_STFNC']",
	"STM33_radio"															=>	"//input[@id='1_file_STM33']",
	"STTPP_radio"															=>	"//input[@id='1_file_STTPP']",	
	"STBME_radio"															=>	"//input[@id='1_file_STBME']",
	#page
	"page_2"																	=>	"//li[@id='file_table_pane']/div[@id='1_file_HTML_table']/div/a[1]",
	#HTML table head
	"file_name"																=>	"//div[@id='1_file_HTML_table']/table/thead/tr/th[1]",
	"item_name"																=>	"//div[@id='1_file_HTML_table']/table/thead/tr/th[2]",
	"analyze_tool"														=>	"//div[@id='1_file_HTML_table']/table/thead/tr/th[3]",
	'STFNC'																		=>	"//div[@id='1_file_HTML_table']/table/thead/tr/th[4]",
	"STM33"																		=>	"//div[@id='1_file_HTML_table']/table/thead/tr/th[5]",
	"STTPP"																		=>	"//div[@id='1_file_HTML_table']/table/thead/tr/th[6]",
	"STBME"																		=>	"//div[@id='1_file_HTML_table']/table/thead/tr/th[4]",
	#HTML table body
	"file_name_row_1"													=>	"//div[@id='1_file_HTML_table']/table/tbody/tr[1]/td[1]",
	"file_name_row_1_value"										=>	"//div[@id='1_file_HTML_table']/table/tbody/tr[1]/td[4]",
	"file_name_row_2_value"										=>	"//div[@id='1_file_HTML_table']/table/tbody/tr[2]/td[4]",
	"QAC_analyze_tool"												=>	"//div[@id='1_file_HTML_table']/table/tbody/tr[1]/td[3]",
	"QAC++_analyze_tool"											=>	"//div[@id='1_file_HTML_table']/table/tbody/tr[2]/td[3]",
	"data_change"															=>	"//div[@id='1_file_HTML_table']/table/tbody/tr[2]/td[5]",
	#Customize subwindow
	"new_STBME_radio"																		=>	"//div[@id='metric_descriptions']/div[1]/input[@id='new_STBME']",
	"customize_check_all"																=>	"//div[@id='sub_window']/input[1]",
	"customize_uncheck_all"															=>	"//div[@id='sub_window']/input[2]",
	"customize_ok"																			=>	"//div[@id='sub_window']/input[3]",
	"customize_cancel"																	=>	"//div[@id='sub_window']/input[4]",
	#Customize subwindow Metrics name and description
	"customize_count"																			=>	"//div[@id='metric_descriptions']/div",				
	"metrics_name"																				=>	"//div[@id='metric_descriptions']/div[27]/label",
	"metrics_description"																	=>	"//div[@id='metric_descriptions']/div[27]/em"		
}


$class_table_tab =	{
	#link to class table tab
	"link_to_class_table_tab"									=>	"//li[@id='class_table_tab']/a[@id='class_table']",
	#button
	"analyze_tool_check_all"									=>	"//div[@id='1_class_analyze_tools']/h3/input[1]",
	"analyze_tool_uncheck_all"								=>	"//div[@id='1_class_analyze_tools']/h3/input[2]",
	"select_metrics_check_all"								=>	"//div[@id='1_class_table_metrics']/h3/input[1]",
	"select_metrics_uncheck_all"							=>	"//div[@id='1_class_table_metrics']/h3/input[2]",
	"customize"																=>	"//div[@id='1_class_table_metrics']/h3/input[3]",
	"download_csv"														=>	"//li[@id='class_table_pane']/form/h3/input",
	#radio checker
	"QAC_radio"																=>	"//input[@id='1_class_QAC']",
	"QAC++_radio"															=>	"//input[@id='1_class_QAC++']",
	"STCBO_radio"															=>	"//input[@id='1_class_STCBO']",
	"STLCM_radio"															=>	"//input[@id='1_class_STLCM']",
	"STMTH_radio"															=>	"//input[@id='1_class_STMTH']",	
	"STWMC_radio"															=>	"//input[@id='1_class_STWMC']",
	#Page 2
	"page_2"																	=>	"//li[@id='class_table_pane']/div[@id='1_class_HTML_table']/div/a[1]",
	#HTML table head																 
	"file_name"																=>	"//div[@id='1_class_HTML_table']/table/thead/tr/th[1]",
	"item_name"																=>	"//div[@id='1_class_HTML_table']/table/thead/tr/th[2]",
	"analyze_tool"														=>	"//div[@id='1_class_HTML_table']/table/thead/tr/th[3]",
	'STCBO'																		=>	"//div[@id='1_class_HTML_table']/table/thead/tr/th[4]",
	"STLCM"																		=>	"//div[@id='1_class_HTML_table']/table/thead/tr/th[5]",
	"STMTH"																		=>	"//div[@id='1_class_HTML_table']/table/thead/tr/th[6]",
	"STWMC"																		=>	"//div[@id='1_class_HTML_table']/table/thead/tr/th[7]",
	#HTML table body
	"file_name_row_1"													=>	"//div[@id='1_class_HTML_table']/table/tbody/tr[1]/td[1]",
	"file_name_row_1_value"										=>	"//div[@id='1_class_HTML_table']/table/tbody/tr[1]/td[6]",
	"file_name_row_2_value"										=>	"//div[@id='1_class_HTML_table']/table/tbody/tr[2]/td[6]",
	"QAC_analyze_tool"												=>	"//div[@id='1_class_HTML_table']/table/tbody/tr[1]/td[3]",
	"QAC++_analyze_tool"											=>	"//div[@id='1_class_HTML_table']/table/tbody/tr[2]/td[3]",
	"STCBO_column_value"											=>	"//div[@id='1_class_HTML_table']/table/tbody/tr[1]/td[4]",	
	"data_change"															=>	"//div[@id='1_class_HTML_table']/table/tbody/tr[2]/td[6]",	
	#Customize subwindow
	"new_STCBO_radio"																		=>	"//div[@id='metric_descriptions']/div[1]/input[@id='new_STCBO']",
	"new_STWMC_radio"																		=>	"//div[@id='metric_descriptions']/div[8]/input[@id='new_STWMC']",
	"customize_check_all"																=>	"//div[@id='sub_window']/input[1]",
	"customize_uncheck_all"															=>	"//div[@id='sub_window']/input[2]",
	"customize_ok"																			=>	"//div[@id='sub_window']/input[3]",
	"customize_cancel"																	=>	"//div[@id='sub_window']/input[4]",
	#Customize subwindow Metrics name and description
	"customize_count"																			=>	"//div[@id='metric_descriptions']/div",				
	"metrics_name"																				=>	"//div[@id='metric_descriptions']/div[27]/label",
	"metrics_description"																	=>	"//div[@id='metric_descriptions']/div[27]/em"		
}


$func_table_tab =	{
	#link to func table tab
	"link_to_func_table_tab"									=>	"//li[@id='func_table_tab']/a[@id='func_table']",
	#button
	"analyze_tool_check_all"									=>	"//div[@id='1_func_analyze_tools']/h3/input[1]",
	"analyze_tool_uncheck_all"								=>	"//div[@id='1_func_analyze_tools']/h3/input[2]",
	"select_metrics_check_all"								=>	"//div[@id='1_func_table_metrics']/h3/input[1]",
	"select_metrics_uncheck_all"							=>	"//div[@id='1_func_table_metrics']/h3/input[2]",
	"customize"																=>	"//div[@id='1_func_table_metrics']/h3/input[3]",
	"download_csv"														=>	"//li[@id='func_table_pane']/form/h3/input",
	#radio checker
	"QAC_radio"																=>	"//input[@id='1_func_QAC']",
	"QAC++_radio"															=>	"//input[@id='1_func_QAC++']",
	"STCYC_radio"															=>	"//input[@id='1_func_STCYC']",
	"STLIN_radio"															=>	"//input[@id='1_func_STLIN']",
	"STMIF_radio"															=>	"//input[@id='1_func_STMIF']",	
	"STAKI_radio"															=>	"//input[@id='1_func_STAKI']",
	"STUNR_radio"															=>	"//input[@id='1_func_STUNR']",
	#Page 2
	"page_2"																	=>	"//li[@id='func_table_pane']/div[@id='1_func_HTML_table']/div/a[1]",
	#HTML table head																 
	"file_name"																=>	"//div[@id='1_func_HTML_table']/table/thead/tr/th[1]",
	"item_name"																=>	"//div[@id='1_func_HTML_table']/table/thead/tr/th[2]",
	"analyze_tool"														=>	"//div[@id='1_func_HTML_table']/table/thead/tr/th[3]",
	'STCYC'																		=>	"//div[@id='1_func_HTML_table']/table/thead/tr/th[4]",
	"STLIN"																		=>	"//div[@id='1_func_HTML_table']/table/thead/tr/th[5]",
	"STMIF"																		=>	"//div[@id='1_func_HTML_table']/table/thead/tr/th[6]",
	"STUNR"																		=>	"//div[@id='1_func_HTML_table']/table/thead/tr/th[7]",
	#HTML table body
	"file_name_row_1"													=>	"//div[@id='1_func_HTML_table']/table/tbody/tr[1]/td[1]",
	"file_name_row_1_value"										=>	"//div[@id='1_func_HTML_table']/table/tbody/tr[1]/td[6]",
	"file_name_row_2_value"										=>	"//div[@id='1_func_HTML_table']/table/tbody/tr[2]/td[6]",
	"QAC_analyze_tool"												=>	"//div[@id='1_func_HTML_table']/table/tbody/tr[1]/td[3]",
	"QAC++_analyze_tool"											=>	"//div[@id='1_func_HTML_table']/table/tbody/tr[2]/td[3]",
	"data_change"															=>	"//div[@id='1_func_HTML_table']/table/tbody/tr[2]/td[5]",
	#Customize subwindow
	"new_STAKI_radio"																		=>	"//div[@id='metric_descriptions']/div[1]/input[@id='new_STAKI']",
	"new_STUNR_radio"																		=>	"//div[@id='metric_descriptions']/div[25]/input[@id='new_STUNR']",
	"customize_check_all"																=>	"//div[@id='sub_window']/input[1]",
	"customize_uncheck_all"															=>	"//div[@id='sub_window']/input[2]",
	"customize_ok"																			=>	"//div[@id='sub_window']/input[3]",
	"customize_cancel"																	=>	"//div[@id='sub_window']/input[4]",
	#Customize subwindow Metrics name and description
	"customize_count"																			=>	"//div[@id='metric_descriptions']/div",				
	"metrics_name"																				=>	"//div[@id='metric_descriptions']/div[27]/label",
	"metrics_description"																	=>	"//div[@id='metric_descriptions']/div[27]/em"		
}
    # display metric page
    def login_metric
    	login
    	wait_for_text_present($page_title["misc_page_title"])
    	click  	"link=sample_c_cpp_1_1"
    	wait_for_text_present($page_title["task_details_page_title"])
   		wait_for_text_present(_("This task was completed."))
    	#wait_for_element_present($xpath_link["xpath_to_metric_page"])
    	click		"link=" + get_text($xpath_link["xpath_to_metric_page"])
    	wait_for_page_to_load	"30000"
    	wait_for_text_present($page_title["metric_view_page_title"])
    end	
    #open analysis task detail page
    #
    def open_analysis_task_detail_page(pu_id=PU_ID, pj_id=PJ_ID, task_id=TASK_ID)
      login("root","root")
      open "task/task_detail/#{pu_id}/#{pj_id}?id=#{task_id}"
      wait_for_page_to_load PAGE_LOAD_TIME
    end
    #open metric page
    def open_metric_page(pu_id=PU_ID, pj_id=PJ_ID, task_id=TASK_ID)
      login("root","root")
      sleep WAIT_TIME
      open "/metric/index/#{pu_id}/#{pj_id}?id=#{task_id}"
      sleep 2*WAIT_TIME
    end
    #open metric tab
    def open_metric_tab(tab_index)
      open_metric_page
      click("link=#{tab_index}")
      sleep WAIT_TIME
    end
    #open metric customize subwindow
    def open_metric_customize_subwindow(tab_index)
      open_metric_tab(tab_index)
      click "#{$xpath["metric"]["customize_button"]}"
      sleep WAIT_TIME
    end
    #chose a random item
    def check_random_metric(tab_index)
      open_metric_customize_subwindow(tab_index)
      #get total check item
      total_checks=get_xpath_count($xpath["metric"]["sub_window_list"])
      #get a random value
      random_item= rand(total_checks -1) +1
      check_item_xpath=$xpath["metric"]["sub_window"]+ "/div[#{random_item}]"
      #get content of value
      check_contents= @selenium.get_text(check_item_xpath)
      @@check_random_value=check_contents[0..4]
      while (is_checked("//input[@value='#{@@check_random_value}']")==true)
        random_item= rand(total_checks-1) +1
        check_item_xpath=$xpath["metric"]["sub_window"]+ "/div[#{random_item}]"
        #get content of value
        check_contents= @selenium.get_text(check_item_xpath)
        @@check_random_value=check_contents[0..4]
      end
      check("//input[@value='#{@@check_random_value}']")
    end
  end
end



