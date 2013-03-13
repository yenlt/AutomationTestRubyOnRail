require File.dirname(__FILE__) + "/../../config/test_helper" unless defined? ENV["RAILS_ENV"]
require File.dirname(__FILE__) + "/../../config/selenium_setup" unless defined? SeleniumSetup
										
module TestHSetup
	include SeleniumSetup
	include GetText

	WAIT_TIME = 5

$xpath = {
	"sample_c_cpp_1_1"									=>	"//tr[@id='task_id1']/td[2]",
	"link_return"												=>	"//div[@id='main_area']/div/a",
	"result_index_page_link"						=>	"//div[@id='main_area']/table[@id='tab_contents']/tbody[2]/tr/td[@id='task_detail_window']/div[@id='task_detail']/table/tbody/tr[4]/td[3]/table/tbody[@id='log_and_result']/tr[1]/td[5]/a"
}

$result_index_xpath = {
	#WHOLE
	"whole"																		=>	_("Overall"),
	#whole table		
	"whole_rule_level"												=>	"//div[@id='main_area']/div/table[1]/tbody/tr",
	"whole_row_count"													=>	"//div[4]/div/table[1]/tbody/tr",
	"whole_col_count"													=>	"//div[4]/div/table[1]/tbody/tr[1]/th",
	"link_under_whole"												=>	"//div[@id='main_area']/div/table[1]/tbody/tr",
	#MODULE
	"module"																	=>	_("Each Module"),
	#module table
	"module_rule_level"												=>	"//div[@id='main_area']/div/table[2]/tbody/tr",		
	"module_col_count"												=>	"//div[@id='main_area']/div/table[2]/tbody/tr[1]/th",		
	"module_row_count"												=>	"//div[@id='main_area']/div/table[2]/tbody/tr/td/a",
	"link_under_module"												=>	"//div[@id='main_area']/div/table[2]/tbody/tr",
	#FILE
	"every_file"															=>	_("Each File"),
	"link_under_file_root"										=>	"//div[@id='main_area']/div/ul[1]/li",
	"link_under_file_sample_c/src"						=>	"//div[@id='main_area']/div/ul[2]/li"
}

$critical_summary	=	{
	"critical_page_title"											=>	"#{_("Analysis Result")}(Critical.Summary.html)\n#{_("Analysis Task")}1:「sample_c_cpp_1_1」,#{_("Tool")}:「QAC」",
	"link_to_view_message_page"								=>	"//div[@id='main_area']/table[1]/tbody/tr/td[2]/a",
	"link_to_view_result_page"								=>	"//div[@id='main_area']/table[2]/tbody/tr[2]/td[2]/font/a"
}

$critical_source	=	{
	"critical_page_title"											=>	"#{_("Analysis Result")}(analyzeme.c.Critical.html)\n#{_("Analysis Task")}1:「sample_c_cpp_1_1」,#{_("Tool")}:「QAC」",
	"link_to_view_message_page"								=>	"//div[@id='main_area']/b[1]/a"
}	

$view_message	=	{
	"next_message"														=>	"//img[@alt='[next]']",					
	"previous_message"												=>	"//img[@alt='[previous]']",
	#"link_to_view_misc_page"									=>	"//div[@id='main_area']/table[4]/tbody/tr/td[2]/a[4]",
	"link_to_view_misc_page"									=>	"link=#{_("Message")} #{_("Index")}",
	"view_misc_page_title"										=>	"QA C #{_("Help")} - #{_("Message")} #{_("Index")}"
}								

$view_misc	=	{
	"link_to_view_message_page"								=>	"//div[@id='main_area']/table[1]/tbody/tr[2]/td[1]/a",
	"view_message_page_title"									=>	"QAC#{_("Message")}",
	#"link_to_view_misc_page"									=>	"//div[@id='main_area']/table[2]/tbody/tr/td[2]/a[1]",
	"link_to_view_misc_page"									=>	"link=#{_("Group")} #{_("Index")}",
	"view_misc_page_title"										=>	"QA C #{_("Help")} - #{_("Group")} #{_("Index")}"
}		

$title	=	{
	"analysis_result"													=>	_("Analysis Result"),
	"task_name"																=>	"#{_("Analysis Task")}1:「sample_c_cpp_1_1」",
	"tool_name"																=>	"#{_("Tool")}：「QAC」",
	"file_name"																=>	"Critical.Summary.html",		
	"pu_name"																	=>	"//div[@id='navi_area']/div[@id='navi']/a[1]",
	"pj_name"																	=>	"//div[@id='navi_area']/div[@id='navi']/a[2]",
	"task_management"													=>	"//div[@id='navi_area']/div[@id='navi']/a[3]",
	"analysis_result_index"										=>	"//div[@id='navi_area']/div[@id='navi']/a[4]",
	"analysis_result_type"										=>	"//div[@id='navi_area']/div[@id='navi']/a[5]"			
}			
	
	def goto_Result_Index_page
		login
		open_page
	end
 
 	def open_page
 		wait_for_text_present(_("User Page"))
    click "link=SamplePU1"
		  wait_for_text_present("PU: SamplePU1")
    click "link=SamplePJ1"
		  wait_for_text_present("PJ: SamplePJ1")
    click "link=#{_("Analysis Task Administration")}"
		  wait_for_element_present($xpath["sample_c_cpp_1_1"])
		click $xpath["sample_c_cpp_1_1"]
    sleep WAIT_TIME
		  wait_for_text_present("[#{_("Analysis")}]")
		  resultIndex = get_attribute($xpath["result_index_page_link"], "href")
		  open resultIndex
    	wait_for_text_present(_("Analysis Result"))
 	end
 
end 
