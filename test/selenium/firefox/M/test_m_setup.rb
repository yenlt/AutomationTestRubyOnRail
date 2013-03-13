require File.dirname(__FILE__) + "/../../config/test_helper" unless defined? ENV["RAILS_ENV"]
require File.dirname(__FILE__) + "/../../config/selenium_setup" unless defined? SeleniumSetup


unless defined?(TestMSetup)
  module TestMSetup
    include SeleniumSetup
    include GetText
    
    USER_ACCOUNT_NAME="newuser"
    USER_LAST_NAME="new"
    USER_FIRST_NAME="user"
    USER_EMAIL="newuser@tsdv.com.vn"
    USER_PASSWORD="abcdef"
    SAMPLE_PU="SamplePU1"
    SAMPLE_PJ="SamplePJ1"
    NEW_SAMPLE_PU="newPU"
    NEW_SAMPLE_PJ="newPJ"
    MASTER_NAME="new master"
    TASK_NAME="new task"
    master = Master.find(:all)
    MASTER_ID=master.first.id
    MASTER_ID2=master.last.id
    TASK_ID=3
    PU_ID=1
    PJ_ID=1
    USER_ID=User.find_by_account_name("pj_member")
    USER_PJ_LAST_NAME= "pj_member"
    WAIT_TIME= 4
    PAGE_LOAD_TIME= "30000"
    #
    def create_user(user_account_name=USER_ACCOUNT_NAME,
        user_last_name =USER_LAST_NAME,
        user_first_name =USER_FIRST_NAME,
        user_email =USER_EMAIL,
        user_password= USER_PASSWORD)
      @selenium.open($xpath["admin_menu_page"])
      wait_for_text_present($link_texts["user_management"])
      @selenium.click "link=#{$link_texts["user_management"]}"
      wait_for_text_present($link_texts["register"])
      @selenium.click "link=#{$link_texts["register"]}"
      wait_for_element_present($xpath["pu_user"]["register_button"])
      @selenium.type "user_account_name", user_account_name
      @selenium.type "user_last_name", user_last_name
      @selenium.type "user_first_name",user_first_name
      @selenium.type "user_email",user_email
      @selenium.type "user_password", user_password
      @selenium.type "user_password_confirmation", user_password
      @selenium.click($xpath["pu_user"]["register_button"])
      run_script("destroy_subwindow()")
    end
    #
    def delete_user_sample
      @selenium.open($xpath["admin_menu_page"])
      wait_for_element_present($xpath["user"]["user_management"])
      @selenium.click($xpath["user"]["user_management"])
      wait_for_element_present($xpath["user"]["user_list_row"])
      delete_xpath=$xpath["user"]["user_list_row"]+"[5]/td[9]/a[2]"
      @selenium.choose_ok_on_next_confirmation
      @selenium.click(delete_xpath)
      @selenium.get_confirmation
    end
    #
    def add_pu_admin
      @selenium.open($xpath["admin_menu_page"])
      wait_for_element_present($xpath["pu"]["pu_management"])
      @selenium.click($xpath["pu"]["pu_management"])
      wait_for_element_present($xpath["pu"]["pu_list_row"])
      @selenium.click("link=#{SAMPLE_PU}")
      wait_for_element_present($xpath["pu"]["pu_registration_administrator"])
      @selenium.click($xpath["pu"]["pu_registration_administrator"])
      wait_for_element_present($xpath["pu_user"]["add_user_pu"])
      @selenium.add_selection $link_texts["pu_user"]["member"],"label=#{USER_PJ_LAST_NAME}"
      @selenium.click($xpath["pu_user"]["add_user_pu"])
    end
    #
    def delete_master
      @selenium.open($xpath["admin_menu_page"])
      wait_for_element_present($xpath["pu"]["pu_management"])
      @selenium.click($xpath["pu"]["pu_management"])
      wait_for_element_present($xpath["pu"]["pu_list_row"])
      @selenium.click("link=#{SAMPLE_PU}")
      @selenium.wait_for_page_to_load PAGE_LOAD_TIME
      @selenium.click("link=#{SAMPLE_PJ}")
      @selenium.wait_for_page_to_load PAGE_LOAD_TIME
      wait_for_element_present($xpath["master_control"])
      @selenium.click($xpath["master_control"])
      sleep WAIT_TIME
      wait_for_element_present($xpath["master"]["master_list_row"])
      total_master=get_xpath_count($xpath["master"]["master_list_row"])
      @selenium.choose_ok_on_next_confirmation
      @selenium.click($xpath["master"]["master_list_row"]+"[#{total_master}]/td[6]/a[1]")
      @selenium.get_confirmation
    end
    #
    def delete_task
      @selenium.open "/task/index2/1/1"
      wait_for_element_present("//tbody[@id='task_list_1']/tr/td[1]")
      @selenium.click "//tbody[@id='task_list_1']/tr/td[1]"
      wait_for_element_present("//img[@alt='Edit-delete']")
      @selenium.choose_ok_on_next_confirmation
      @selenium.click "//img[@alt='Edit-delete']"
      @selenium.get_confirmation
    end
    #
    def delete_pu
      @selenium.open($xpath["admin_menu_page"])
      wait_for_element_present($xpath["pu"]["pu_management"])
      @selenium.click($xpath["pu"]["pu_management"])
      wait_for_element_present($xpath["pu"]["pu_list_row"]+"[1]/td[5]/a[2]")
      @selenium.choose_ok_on_next_confirmation
      @selenium.click($xpath["pu"]["pu_list_row"]+"[1]/td[5]/a[2]")
      @selenium.get_confirmation
    end
    #
    def delete_pj
      @selenium.open($xpath["admin_menu_page"])
      @selenium.wait_for_page_to_load PAGE_LOAD_TIME
      @selenium.click($xpath["pu"]["pu_management"])
      wait_for_element_present($xpath["pu"]["pu_list_row"])
      @selenium.click("link=#{SAMPLE_PU}")
      @selenium.wait_for_page_to_load PAGE_LOAD_TIME
      @selenium.click($xpath["pj"]["pj_management"])
      wait_for_element_present($xpath["pj"]["pj_list_row"])
      @selenium.choose_ok_on_next_confirmation
      @selenium.click($xpath["pj"]["pj_list_row"]+"[1]/td[5]/a[2]")
      @selenium.get_confirmation
    end
  end
end


