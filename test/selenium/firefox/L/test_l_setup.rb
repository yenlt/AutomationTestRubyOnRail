require File.dirname(__FILE__) + "/../../config/test_helper" unless defined? ENV["RAILS_ENV"]
require File.dirname(__FILE__) + "/../../config/selenium_setup" unless defined? SeleniumSetup


unless defined?(TestLSetup)
  module TestLSetup
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

    def create_a_pj_inherit_newpj(pu= NEW_SAMPLE_PU, pj = NEW_SAMPLE_PJ)
      @selenium.open($xpath["admin_menu_page"])
      wait_for_element_present($xpath["pu"]["pu_management"])
      @selenium.click($xpath["pu"]["pu_management"])
      wait_for_element_present($xpath["pu"]["pu_list_row"])
      @selenium.click("link=#{pu}")
      wait_for_page_to_load PAGE_LOAD_TIME
      wait_for_element_present($xpath["pj"]["pj_management"])
      @selenium.click($xpath["pj"]["pj_management"])
      wait_for_element_present("link=#{$link_texts["register"]}")
      @selenium.click("link=#{$link_texts["register"]}")
      wait_for_element_present($xpath["pj"]["inherit_pj"])
      @selenium.type "project_name",pj
      @selenium.click($xpath["pj"]["inherit_pj"])
      @selenium.click "project_member"
      @selenium.click "commit"
      wait_for_text_present("#{_("Project")} [#{pj}] #{_("register-.")}")
    end
    #
    def add_a_pj_admin(pu=SAMPLE_PU, pj= SAMPLE_PJ)
      @selenium.open($xpath["admin_menu_page"])
      wait_for_element_present($xpath["pu"]["pu_management"])
      @selenium.click($xpath["pu"]["pu_management"])
      wait_for_element_present($xpath["pu"]["pu_list_row"])
      @selenium.click("link=#{pu}")
      wait_for_page_to_load PAGE_LOAD_TIME
      wait_for_element_present($xpath["pj"]["pj_management"])
      @selenium.click($xpath["pj"]["pj_management"])
      wait_for_element_present($xpath["pj"]["pj_list_row"])
      @selenium.click("link=#{pj}")
      wait_for_page_to_load PAGE_LOAD_TIME
      wait_for_element_present($xpath["pj"]["pj_registration_administrator"])
      @selenium.click($xpath["pj"]["pj_registration_administrator"])
      wait_for_element_present($xpath["pj_user"]["add_user_pj"])
      @selenium.add_selection $link_texts["pj_user"]["non_admin"], "label=new1"
      @selenium.click($xpath["pj_user"]["add_user_pj"])
      wait_for_button_enable($xpath["pj_user"]["add_user_pj"])
    end
   
  end
end



