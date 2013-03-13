require File.dirname(__FILE__) + "/../../config/test_helper" unless defined? ENV["RAILS_ENV"]
require File.dirname(__FILE__) + "/../../config/selenium_setup" unless defined? SeleniumSetup

WAIT_TIME = 3
module TestF4Setup
	include SeleniumSetup
  include GetText
  
$xpath = {
	"auth_login"                        =>  _("TOSCANA Login"),
	"task_management_page"							=>	"/task/index2/1/1",	
	"sample_c_cpp_1_1"									=>	"//tr[@id='task_id1']/td[2]",
	"link_return"												=>	"//div[@id='main_area']/div/a",
	"result_index_page_link"						=>	"//div[@id='main_area']/table[@id='tab_contents']/tbody[2]/tr/td[@id='task_detail_window']/div[@id='task_detail']/table/tbody/tr[4]/td[3]/table/tbody[@id='log_and_result']/tr[1]/td[5]/a"
}

$general_control	=	{
	#general_control page content
	"general_control_text"								=>	_("Basic Setting"),
	"qac_selection_normal"								=>	"//table[@id='analyze_rule_numbers']/tbody/tr[3]/td[1]/table/tbody/tr[3]/td/a[1]",
	"qac_text_normal"											=>	"//textarea[@id='qac_rule1']",
	"qac_selection_high"									=>	"//table[@id='analyze_rule_numbers']/tbody/tr[3]/td[2]/table/tbody/tr[3]/td/a[1]",
	"qac_selection_critical"							=>	"//table[@id='analyze_rule_numbers']/tbody/tr[3]/td[3]/table/tbody/tr[3]/td/a[1]",
	"qac++_selection_normal"							=>	"//table[@id='analyze_rule_numbers']/tbody/tr[5]/td[1]/table/tbody/tr[3]/td/a[1]",
	"qac++_selection_high"								=>	"//table[@id='analyze_rule_numbers']/tbody/tr[5]/td[2]/table/tbody/tr[3]/td/a[1]",
	"qac++_selection_critical"						=>	"//table[@id='analyze_rule_numbers']/tbody/tr[5]/td[3]/table/tbody/tr[3]/td/a[1]",
	"default"															=>	"//table[@id='analyze_rule_numbers']/tbody/tr[3]/td[1]/table/tbody/tr[3]/td/a[2]",
	"selection"														=>	"//table[@id='analyze_rule_numbers']/tbody/tr[3]/td[2]/table/tbody/tr[3]/td/a",
	#general_control link and checker
	"link_page"														=>	"//p[@id='page_list']/a",
	"rule_list"														=>	"//tbody[@id='rule_list']/tr",
	"check_rule"													=>	"//table[@id='rule_list_table']/tbody[@id='rule_list']/tr",
	"check_rule_id"												=>	"]/td[1]/input[@id='checked_rules[]']",
	"first_rule"													=>	"//tbody[@id='rule_list']/tr[1]/td[1]/input[@id='checked_rules[]']",
	"last_rule"														=>	"//tbody[@id='rule_list']/tr[100]/td[1]/input[@id='checked_rules[]']",
	#button general_control sub window
	"check_button"												=>	"//div[@id='rule_select_window']/form/div[2]/input[2]",
	"clear_button"												=>	"//div[@id='rule_select_window']/form/div[2]/input[3]",
	"is_check_all_button"									=>	"//div[@id='rule_select_window']/form/div[2]/input[4]",
	"is_clear_all_button"									=>	"//div[@id='rule_select_window']/form/div[2]/input[5]",	
	"registration"												=>	"//div[@id='rule_select_window']/form/div[2]/input[1]"
}
					
	def login_general_control
		login
 		wait_for_text_present(_("User Page"))
    open $xpath["task_management_page"]
    wait_for_text_present(_("Overall Analysis Task"))
    wait_for_text_present(_("Register Analysis Task"))
		click "link=#{_('Register Analysis Task')}"
		wait_for_text_present(_("Basic Setting"))
 	end
 	
 	def user_login(username, password)
    # open login page
    open "auth/login"
    wait_for_text_present($page_titles["auth_login"])
    # type username & password
    type("login",
         username)
    type("password",
         password)
    # log in
    click "commit"

    #open general control
    wait_for_page_to_load "30000"
    wait_for_text_present(_("User Page"))
    open $xpath["task_management_page"]
    wait_for_text_present(_("Overall Analysis Task"))
    wait_for_text_present(_("Register Analysis Task"))
		click "link=#{_('Register Analysis Task')}"
		wait_for_text_present(_("Basic Setting"))
 	end
 	
 	def register_user
 		#register admin pj
 		create_new_user("adminpj")
 		pj_user = User.find(:last)
 		PjsUsers.create(:pj_id => 1, :user_id => pj_user.id)
 		PrivilegesUsers.create(:privilege_id => 3, :user_id => pj_user.id, :pj_id => 1, :pu_id => 1)
 		
 		#register member pj
 		create_new_user("memberpj")
 		pj_user = User.find(:last)
 		PjsUsers.create(:pj_id => 1, :user_id => pj_user.id)
 	end
 	
 	def delete_user
 		#delete users
 		1.upto(2) do
	 		pj_user = User.find(:last)
	 		User.destroy(pj_user.id)	
	 		PjsUsers.destroy(pj_user.id)	
 		end
 		PrivilegesUsers.destroy(:last)
 	end
 	
 	def create_new_user(user_name)
 		new_user = User.new
 		new_user.account_name = user_name
    new_user.first_name  = "TOSCANA"
    new_user.last_name  = user_name
    new_user.nick_name = ''
    new_user.email = "#{user_name}@tsdv.com.vn"
    new_user.password = user_name
    new_user.password_confirmation = user_name
    new_user.save
    sleep WAIT_TIME
 	end
end 
