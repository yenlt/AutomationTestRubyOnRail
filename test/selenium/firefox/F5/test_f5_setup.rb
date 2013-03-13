require File.dirname(__FILE__) + "/../../config/test_helper" unless defined? ENV["RAILS_ENV"]
require File.dirname(__FILE__) + "/../../config/selenium_setup" unless defined? SeleniumSetup
												
module TestF5Setup
	include SeleniumSetup
	include GetText

  WAIT_TIME = 3

$xpath = {
	"task_management_page"							=>	"/task/index2/1/1",
	"sample_c_cpp_1_1"									=>	"//tr[@id='task_id1']/td[2]",
	"link_return"												=>	"//div[@id='main_area']/div/a",
	"result_index_page_link"						=>	"//div[@id='main_area']/table[@id='tab_contents']/tbody[2]/tr/td[@id='task_detail_window']/div[@id='task_detail']/table/tbody/tr[4]/td[3]/table/tbody[@id='log_and_result']/tr[1]/td[5]/a"
}

$task_registration = {
	#tab
	"general_tab"													=>	_("General Setting"),
	"tool_setting_tab"										=>	_("Analysis Tool Setting"),
	"master_tab"													=>	_("Master"),
	#register page
	"registration_task"										=>	"//input[@id='confirm_task_btn']",
	"registration"												=>	"//div[@id='confirmation_window']/input",
	"registration_title"									=>	_("Setting of a Analysis Task and a Master"),
	"can_not_register_message"						=>	_("Analysis Task cannot be registered,because there is a problem in an entry content."),
	"individual_can_not_register_message"	=>	_("Analysis Task cannot be registered,because there is a problem in an entry content."),
	"sub_window_register_task"						=>	"//div[@id='confirmation_window']/input",
	"rule_level_uncheck"									=>	"Error:Analysis level un-selecting.",
	"rule_unsetting"											=>	_("Unsetting Analysis Rule"),
	"new_task_registered"									=>	_("The overall analysis task new_task was registered"),
	"individual_task_registered"					=>	_("The individual analysis task new_task was registered"),
	"select_master"												=>	"//select[@id='master_id']",
	"no_master"														=>	_("With no applicable Master"),
	"no_upload_file"											=>	_("The file has not uploaded."),
	#master tab
	"upload_button"												=>	"//input[@id='upload_once_btn']",
	"upload_package"											=>	"//input[@id='file_upload_upload_way_upload_once']",
	"upload_individual"										=>	"//input[@id='file_upload_upload_way_upload_each']",
	"dir_tree"														=>	"//table[@id='upload_each']/tbody/tr[2]/td/input",
	"sample_c_directory"									=>	"//div[@id='directory_tree_area']/ul[@id='l1p0n1']/li[1]/a",
	"upload_individual_button"						=>	"//table[@id='file_upload_table']/tbody/tr[1]/td/input",
	#task detail. individual tab
	"individual_task_tab"									=>	"//table[@id='tab_title']/tbody/tr[2]/td[@id='tab2']/a",
	"file_stored"													=>	"//table[@id='replace_file_list']/tbody[@id='replace_file']/tr/td[@id='old_filename']"
}

	def login_task_registration
		login
		wait_for_text_present(_("User Page"))
    open $xpath["task_management_page"]
    wait_for_text_present(_("Overall Analysis Task"))
    wait_for_text_present(_("Register Analysis Task"))
		click "link=#{_("Register Analysis Task")}"
		wait_for_text_present(_("General Setting"))
 	end
 
 	def create_master
    Master.create(:content_type => 'gz',
                   :user_id => 1,
                   :pj_id => 1,
                   :expl => "master sample",
                   :master_status_id => 2,
                   :name => "master_sample",
                   :filename => "/master_sample.tar.gz",
                   :master_type => 1
    )
  end
  
  def reset_upload_file
  	#delete uploaded individual sample file
  	TempFile.destroy_all
  end
  
  def delete_newtask
  	Task.destroy(:last)
  end
 
end 
