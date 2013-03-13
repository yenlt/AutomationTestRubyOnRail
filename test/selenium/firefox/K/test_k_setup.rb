require File.dirname(__FILE__) + "/../../config/test_helper" unless defined? ENV["RAILS_ENV"]
require File.dirname(__FILE__) + "/../../config/selenium_setup" unless defined? SeleniumSetup


unless defined?(TestKSetup)
  module TestKSetup
    include SeleniumSetup
    include GetText
    
    USER_ACCOUNT_NAME="newuser"
    USER_LAST_NAME="pj_member"
    USER_FIRST_NAME="user"
    USER_EMAIL="newuser@tsdv.com.vn"
    USER_PASSWORD="abcdef"
    SAMPLE_PU="SamplePU1"
    SAMPLE_PU2="SamplePU2"
    SAMPLE_PJ="SamplePJ1"
    MANAGER= User.find(:first).last_name
    NEW_SAMPLE_PU="newPU"
    NEW_SAMPLE_PJ="newPJ"
    WAIT_TIME= 4
    PAGE_LOAD_TIME= "30000"
    
    def create_user(user_account_name=USER_ACCOUNT_NAME,
        user_last_name =USER_LAST_NAME,
        user_first_name =USER_FIRST_NAME,
        user_email =USER_EMAIL,
        user_password= USER_PASSWORD)
      @selenium.open($xpath["admin_menu_page"])
      wait_for_element_present($xpath["user"]["user_management"])
      @selenium.click($xpath["user"]["user_management"])
      wait_for_element_present("link=#{$link_texts["register"]}")
      @selenium.click("link=#{$link_texts["register"]}")
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
    def open_pu_member_page(pu= SAMPLE_PU)
      @selenium.open($xpath["admin_menu_page"])
      wait_for_element_present($xpath["pu"]["pu_management"])
      @selenium.click($xpath["pu"]["pu_management"])
      wait_for_element_present($xpath["pu"]["pu_list_row"])
      @selenium.click("link=#{pu}")
      wait_for_element_present($xpath["pu_user"]["pu_member_management"])
      @selenium.click($xpath["pu_user"]["pu_member_management"])
      wait_for_text_present(_("Members of this PU"))
      wait_for_text_present(_("Non members of this PU"))
    end
    #
    def open_pu_admin_page(pu= SAMPLE_PU)
      @selenium.open($xpath["admin_menu_page"])
      wait_for_element_present($xpath["pu"]["pu_management"])
      @selenium.click($xpath["pu"]["pu_management"])
      wait_for_element_present($xpath["pu"]["pu_list_row"])
      @selenium.click("link=#{pu}")
      wait_for_page_to_load PAGE_LOAD_TIME
      wait_for_element_present($xpath["pu"]["pu_registration_administrator"])
      @selenium.click($xpath["pu"]["pu_registration_administrator"])
      wait_for_text_present(_("PU administrator listing"))
      wait_for_text_present(_("PU member listing"))
    end
    #
    def open_pj_member_page(pu=SAMPLE_PU,
        pj= SAMPLE_PJ )
      @selenium.open($xpath["admin_menu_page"])
      wait_for_element_present($xpath["pu"]["pu_management"])
      @selenium.click($xpath["pu"]["pu_management"])
      wait_for_element_present($xpath["pu"]["pu_list_row"])
      @selenium.click("link=#{pu}")
      wait_for_element_present($xpath["pj"]["pj_management"])
      @selenium.click($xpath["pj"]["pj_management"])
      wait_for_element_present($xpath["pj"]["pj_list_row"])
      @selenium.click("link=#{pj}")
      wait_for_page_to_load PAGE_LOAD_TIME
      wait_for_element_present($xpath["pj_user"]["pj_member_management"])
      @selenium.click($xpath["pj_user"]["pj_member_management"])
      wait_for_text_present(_("Members of this PJ"))
      wait_for_text_present(_("Non members of this PJ"))
    end
    #
    def open_pj_admin_page(pu=SAMPLE_PU,
        pj= SAMPLE_PJ )
      @selenium.open($xpath["admin_menu_page"])
      wait_for_element_present($xpath["pu"]["pu_management"])
      @selenium.click($xpath["pu"]["pu_management"])
      wait_for_element_present($xpath["pu"]["pu_list_row"])
      @selenium.click("link=#{pu}")
      wait_for_element_present($xpath["pj"]["pj_management"])
      @selenium.click($xpath["pj"]["pj_management"])
      wait_for_element_present($xpath["pj"]["pj_list_row"])
      @selenium.click("link=#{pj}")
      wait_for_element_present($xpath["pj"]["pj_registration_administrator"])
      wait_for_page_to_load PAGE_LOAD_TIME
      @selenium.click($xpath["pj"]["pj_registration_administrator"])
      wait_for_text_present(_("PJ administrator listing"))
      wait_for_text_present(_("PJ member listing"))
    end
    #
    def delete_user(index_id)
      @selenium.open($xpath["admin_menu_page"])
      wait_for_element_present($xpath["user"]["user_management"])
      @selenium.click($xpath["user"]["user_management"])
      wait_for_element_present($xpath["user"]["user_list_row"])
      delete_xpath=$xpath["user"]["user_list_row"]+"["+index_id.to_s+"]/td[9]/a[2]"
      @selenium.choose_ok_on_next_confirmation
      @selenium.click(delete_xpath)
      @selenium.get_confirmation
    end
    #
    def add_pj_admin
      @selenium.open($xpath["index_page"])
      wait_for_page_to_load PAGE_LOAD_TIME
      @selenium.click("link=#{SAMPLE_PJ}")
      wait_for_page_to_load PAGE_LOAD_TIME
      wait_for_element_present($xpath["pj"]["pj_registration_administrator"])
      @selenium.click($xpath["pj"]["pj_registration_administrator"])
      wait_for_element_present($xpath["pj_user"]["add_user_pj"])
      @selenium.add_selection $link_texts["pj_user"]["non_admin"], "label=#{USER_LAST_NAME}"
      @selenium.click($xpath["pj_user"]["add_user_pj"])
      wait_for_button_enable($xpath["pj_user"]["add_user_pj"])
    end
    #
    def remove_pj_admin
      @selenium.open($xpath["index_page"])
      wait_for_page_to_load PAGE_LOAD_TIME
      @selenium.click("link=#{SAMPLE_PJ}")
      wait_for_page_to_load PAGE_LOAD_TIME
      wait_for_element_present($xpath["pj"]["pj_registration_administrator"])
      @selenium.click($xpath["pj"]["pj_registration_administrator"])
      wait_for_element_present($xpath["pj_user"]["remove_user_pj"])
      @selenium.add_selection $link_texts["pj_user"]["admin"], "label=#{USER_LAST_NAME}"
      @selenium.click($xpath["pj_user"]["remove_user_pj"])
      wait_for_button_enable($xpath["pj_user"]["remove_user_pj"])
    end
    #
    def create_new_pu_inherit_samplepu
      @selenium.open($xpath["admin_menu_page"])
      wait_for_page_to_load PAGE_LOAD_TIME
      @selenium.click($xpath["pu"]["pu_management"])
      wait_for_element_present("link=#{$link_texts["register"]}")
      @selenium.click("link=#{$link_texts["register"]}")
      wait_for_text_present(_("Create New PU"))
      @selenium.type "project_unit_name", NEW_SAMPLE_PU
      @selenium.click "project_unit_original_1"
      @selenium.click "project_unit_member"
      @selenium.click "commit"
      run_script("destroy_subwindow()")
      wait_for_text_not_present(_("Create New PU"))
    end
    #
    def create_many_user(number_user)
      (1..number_user).each do |i|
        full_name= "newuser"+i.to_s
        last_name= "new"+i.to_s
        first_name= "user"+i.to_s
        email="newuser"+i.to_s+"@tsdv.com.vn"
        password="abcdef"
        create_user(full_name,last_name,first_name,email,password)
      end
    end
    #
    def delete_many_user(number_user)
      @selenium.open($xpath["admin_menu_page"])
      sleep WAIT_TIME
      wait_for_element_present("link=#{$link_texts["user_management"]}")
      @selenium.click "link=#{$link_texts["user_management"]}"
      wait_for_element_present($xpath["user"]["user_list_row"])
      number_user.times do
        total_user=get_xpath_count($xpath["user"]["user_list_row"])
        index_id=total_user
        delete_user(index_id)
        wait_for_element_not_present($xpath["user"]["user_list_row"]+"["+index_id.to_s+"]/td[9]/a[2]")
      end
    end
    #
    def create_a_pu
      @selenium.open($xpath["admin_menu_page"])
      wait_for_element_present($xpath["pu"]["pu_management"])
      @selenium.click($xpath["pu"]["pu_management"])
      wait_for_element_present("link=#{$link_texts["register"]}")
      @selenium.click("link=#{$link_texts["register"]}")
      wait_for_text_present(_("Create New PU"))
      @selenium.type "project_unit_name", NEW_SAMPLE_PU
      @selenium.click "commit"
      run_script("destroy_subwindow()")
      wait_for_text_present(_("register."))
    end
    #
    def add_many_pu_mem(pu=SAMPLE_PU)
      open_pu_member_page(pu)
      (1..5).each do |i|
        @selenium.add_selection $link_texts["pu_user"]["non_member"], "label=new#{i}"
      end
      @selenium.click($xpath["pu_user"]["add_user_pu"])
      wait_for_button_enable($xpath["pu_user"]["add_user_pu"])
    end
    #
    def add_pu_admin(pu=SAMPLE_PU)
      open_pu_admin_page(pu)
      @selenium.add_selection $link_texts["pu_user"]["member"], "label=#{USER_LAST_NAME}"
      @selenium.click($xpath["pu_user"]["add_user_pu"])
      wait_for_button_enable($xpath["pu_user"]["add_user_pu"])
    end
    #
    def add_a_pu_admin(pu=SAMPLE_PU)
      open_pu_admin_page(pu)
      @selenium.add_selection $link_texts["pu_user"]["member"], "label=new1"
      @selenium.click($xpath["pu_user"]["add_user_pu"])
      wait_for_button_enable($xpath["pu_user"]["add_user_pu"])
    end
    #
    def add_many_pu_admin(pu=SAMPLE_PU)
      open_pu_admin_page(pu)
      sleep WAIT_TIME
      (1..5).each do |i|
        @selenium.add_selection $link_texts["pu_user"]["member"], "label=new#{i}"
      end
      @selenium.click($xpath["pu_user"]["add_user_pu"])
      wait_for_button_enable($xpath["pu_user"]["add_user_pu"])
    end
    #
    def create_a_pj_of_newpu(pu = SAMPLE_PU, pj = SAMPLE_PJ)
      @selenium.open($xpath["admin_menu_page"])
      wait_for_page_to_load PAGE_LOAD_TIME
      @selenium.click($xpath["pu"]["pu_management"])
      wait_for_page_to_load PAGE_LOAD_TIME
      @selenium.click("link=#{pu}")
      wait_for_element_present($xpath["pj"]["pj_management"])
      @selenium.click($xpath["pj"]["pj_management"])
      wait_for_element_present("link=#{$link_texts["register"]}")
      @selenium.click("link=#{$link_texts["register"]}")
      wait_for_text_present(_("Create New Project"))
      @selenium.type "project_name",pj
      @selenium.click "commit"
      run_script("destroy_subwindow()") 
      wait_for_text_not_present(_("Create New Project"))
    end
    #
    def add_many_pj_mem(pu=SAMPLE_PU, pj= SAMPLE_PJ)
      open_pj_member_page(pu, pj)
      sleep WAIT_TIME
      (1..5).each do |i|
        @selenium.add_selection $link_texts["pj_user"]["non_member"], "label=new#{i}"
      end
      @selenium.click($xpath["pj_user"]["add_user_pj"])
      wait_for_button_enable($xpath["pj_user"]["add_user_pj"])
    end
    #
    def add_many_pj_admin(pu=SAMPLE_PU, pj= SAMPLE_PJ)
      open_pj_admin_page(pu, pj)
      (1..5).each do |i|
        @selenium.add_selection $link_texts["pj_user"]["non_admin"], "label=new#{i}"
      end
      @selenium.click($xpath["pj_user"]["add_user_pj"])
      wait_for_button_enable($xpath["pj_user"]["add_user_pj"])
    end
  end
end



