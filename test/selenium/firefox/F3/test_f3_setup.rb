require File.dirname(__FILE__) + "/../../config/test_helper" unless defined? ENV["RAILS_ENV"]
require File.dirname(__FILE__) + "/../../config/selenium_setup" unless defined? SeleniumSetup

WAIT_TIME = 3
module TestF3Setup
	include SeleniumSetup
  include GetText
  
$xpath = {
	"task_management_page"							=>	"/task/index2/1/1",	
	"sample_c_cpp_1_1"									=>	"//tr[@id='task_id1']/td[2]",
	"link_return"												=>	"//div[@id='main_area']/div/a",
	"result_index_page_link"						=>	"//div[@id='main_area']/table[@id='tab_contents']/tbody[2]/tr/td[@id='task_detail_window']/div[@id='task_detail']/table/tbody/tr[4]/td[3]/table/tbody[@id='log_and_result']/tr[1]/td[5]/a"
}

$tool_setting	=	{
	"selection_box"								=>	"//div[@id='tool_setting']/table[1]/tbody/tr[3]/td[1]/select[@id='tool_name']",
	"bold_text"										=>	"//table[@id='tool_configuration']/tbody/tr[1]/th[@id='target_tool']",
	"save_setting"								=>	"//input[@value='#{_('Save Setting')}']",
	"saved_message"								=>	_("Execution setting was updated."),
	"registration_task"						=>	"//input[@id='confirm_task_btn']",
	"registration_task_close"			=>	"//body/div[2]",
	"make_options_text"						=>	"//textarea[@id='make_options']",
	"environment_text"						=>	"//textarea[@id='environment_variables']",
	"header_file_text"						=>	"//textarea[@id='header_file_at_analyze']",
	"analyze_tool_text"						=>	"//textarea[@id='analyze_tool_config']",
	"others_text"									=>	"//textarea[@id='others']",
	"default_link"								=>	"//div[@id='tool_setting']/table[@id='tool_configuration']/tbody/tr[_ROW_INDEX_]/td/a"
}		
	
 	def login_tool_setting
	 	login
 		wait_for_text_present(_("User Page"))
    open $xpath["task_management_page"]
    wait_for_text_present(_("Overall Analysis Task"))
    wait_for_text_present(_("Register Analysis Task"))
		click "link=#{_('Register Analysis Task')}"
		wait_for_text_present(_("Basic Setting"))
		click "link=#{_('Analysis Tool Setting')}"
		wait_for_text_present(_("Select an analysis tool."))
		sleep WAIT_TIME
 	end
 
end 
