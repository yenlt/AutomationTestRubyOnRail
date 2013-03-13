require File.dirname(__FILE__) + "/../../config/test_helper" unless defined? ENV["RAILS_ENV"]
require File.dirname(__FILE__) + "/../../config/selenium_setup" unless defined? SeleniumSetup
								
module TestGSetup
	include SeleniumSetup
	include GetText
	
	WAIT_TIME = 5

$xpath = {
	"task_management_page"							=>	"/task/index2/1/1",
	"sample_c_cpp_1_1"									=>	"//tr[@id='task_id1']/td[2]",
	"link_return"												=>	"//div[@id='main_area']/div/a",
	"result_index_page_link"						=>	"//div[@id='main_area']/table[@id='tab_contents']/tbody[2]/tr/td[@id='task_detail_window']/div[@id='task_detail']/table/tbody/tr[4]/td[3]/table/tbody[@id='log_and_result']/tr[1]/td[5]/a"
}

$analytical_rule	=	{
	#analytical rule page content
	"analytical_rule_text"							=>	_("Select Analysis Rule"),	
	"selection_link"										=>	"//table[@id='analyze_rule_numbers']/tbody/tr[_ROW_]/td[_COL_]/table/tbody/tr[3]/td/a[1]",
	"qac_selection_normal"							=>	"//table[@id='analyze_rule_numbers']/tbody/tr[3]/td[1]/table/tbody/tr[3]/td/a[1]",
	"qac_text_normal"										=>	"//textarea[@id='qac_rule1']",
	"qac_selection_high"								=>	"//table[@id='analyze_rule_numbers']/tbody/tr[3]/td[2]/table/tbody/tr[3]/td/a[1]",
	"qac_selection_critical"						=>	"//table[@id='analyze_rule_numbers']/tbody/tr[3]/td[3]/table/tbody/tr[3]/td/a[1]",
	"qac++_selection_normal"						=>	"//table[@id='analyze_rule_numbers']/tbody/tr[5]/td[1]/table/tbody/tr[3]/td/a[1]",
	"qac++_selection_high"							=>	"//table[@id='analyze_rule_numbers']/tbody/tr[5]/td[2]/table/tbody/tr[3]/td/a[1]",
	"qac++_selection_critical"					=>	"//table[@id='analyze_rule_numbers']/tbody/tr[5]/td[3]/table/tbody/tr[3]/td/a[1]",
	"default"														=>	"//table[@id='analyze_rule_numbers']/tbody/tr[3]/td[1]/table/tbody/tr[3]/td/a[2]",
	"selection"														=>	"//table[@id='analyze_rule_numbers']/tbody/tr[3]/td[2]/table/tbody/tr[3]/td/a",
	#analytical rule link and checker
	"link_page"													=>	"//p[@id='page_list']/a",
	"rule_list"													=>	"//tbody[@id='rule_list']/tr",
	"check_rule"												=>	"//table[@id='rule_list_table']/tbody[@id='rule_list']/tr",
	"rule_id"														=>	"]/td[1]/input[@id='checked_rules[]']",
	"first_rule_number"									=>	"//tbody[@id='rule_list']/tr[1]/td[2]",
	"last_rule_number"									=>	"//tbody[@id='rule_list']/tr[100]/td[2]",
	"first_rule"												=>	"//tbody[@id='rule_list']/tr[1]/td[1]/input[@id='checked_rules[]']",
	"last_rule"													=>	"//tbody[@id='rule_list']/tr[100]/td[1]/input[@id='checked_rules[]']",
	#button analytical rule sub window
	"check_button"											=>	"//div[@id='rule_select_window']/form/div[2]/input[2]",
	"clear_button"											=>	"//div[@id='rule_select_window']/form/div[2]/input[3]",
	"is_check_all_button"								=>	"//div[@id='rule_select_window']/form/div[2]/input[4]",
	"is_clear_all_button"								=>	"//div[@id='rule_select_window']/form/div[2]/input[5]",	
	"registration"											=>	"//div[@id='rule_select_window']/form/div[2]/input[1]"
}
	
$task_registration = {
	#register page	
	"registration_task"										=>	"//input[@id='confirm_task_btn']",
	"register_task"												=>	"//div[@id='rule_select_window']/form/div[2]/input[1]",
	"registration_title"									=>	_("Setting of a Analysis Task and a Master"),
	"new_task_registered"									=>	_("The overall analysis task new_task was registered"),
	"select_master"												=>	"//select[@id='master_id']",
	#subwindow
	"selection_link"											=>	"//table[@id='analyze_rule_numbers']/tbody/tr[_ROW_]/td[_COL_]/table/tbody/tr[3]/td/a[1]",
	"is_check_all_button"									=>	"//div[@id='rule_select_window']/form/div[2]/input[4]",
	"registration"												=>	"//div[@id='confirmation_window']/input",
	#qac++ level
	"qac++_normal"												=>	"//table[@id='analyze_rule_and_level']/tbody/tr[5]/td[2]/input[@id='normal']",
	"qac++_high"													=>	"//table[@id='analyze_rule_and_level']/tbody/tr[5]/td[3]/input[@id='high']",
	"qac++_critical"											=>	"//table[@id='analyze_rule_and_level']/tbody/tr[5]/td[4]/input[@id='critical']"
}		

$task_detail	=	{
	"new_task_id"													=>	"//tr[@id='task_id_NEW_TASK_']/td[2]",
	"task_detail_title"										=>	_("This Task is in the state waiting for analysis now."),
	"qac_rule"														=>	"//div[@id='task_detail']/table/tbody/tr[15]/td/table/tbody/tr[1]/td[2]/a",
	"qac++_rule"													=>	"//div[@id='task_detail']/table/tbody/tr[15]/td/table/tbody/tr[2]/td[2]/a"
}
	
	def login_analytical_rule
		login
		wait_for_text_present(_("User Page"))
    click "link=SamplePU1"
		wait_for_text_present("PU: SamplePU1")
   	click "link=#{_("PU Setting")}"
   	wait_for_text_present(_("Analysis Rule Setting"))
 	end
 	
 	def login_task_registration
		login
		wait_for_text_present(_("User Page"))
    open $xpath["task_management_page"]
    wait_for_text_present(_("Overall Analysis Task"))
    wait_for_text_present(_("Register Analysis Task"))
		click "link=#{_("Register Analysis Task")}"
		wait_for_text_present(_("General Setting"))
 	end
end 
