require File.dirname(__FILE__) + "/../../config/test_helper" unless defined? ENV["RAILS_ENV"]
require File.dirname(__FILE__) + "/../../config/selenium_setup" unless defined? SeleniumSetup


unless defined?(TestOSetup)
  module TestOSetup
    include SeleniumSetup
    ADMIN = User.find(:first)
    ADMIN_NAME= "#{ADMIN.last_name} #{ADMIN.first_name}"
    USER_ACCOUNT_NAME="newuser"
    USER_LAST_NAME="new"
    USER_FIRST_NAME="user"
    USER_EMAIL="newuser@tsdv.com.vn"
    USER_PASSWORD="abcdef"
    NEW_USER_ACCOUNT_NAME="newuserx"
    NEW_USER_LAST_NAME="newx"
    NEW_USER_FIRST_NAME="userx"
    NEW_USER_EMAIL="newuserx@tsdv.com.vn"
    NEW_USER_PASSWORD="abcdefx"
    WRONG_PASSWORD="fedcba"
    PJ_MEMBER_ID= "pj_member"
    PJ_MEMBER_PASSWORD= "pj_member"
    WAIT_TIME= 4
    PAGE_LOAD_TIME= "30000"
    #
    def delete_user(index_id)
      @selenium.open($xpath["admin_menu_page"])
      wait_for_element_present($xpath["user"]["user_management"])
      @selenium.click($xpath["user"]["user_management"])
      wait_for_element_present($xpath["user"]["user_list_row"]+"["+index_id.to_s+"]/td[9]/a[2]")
      delete_xpath=$xpath["user"]["user_list_row"]+"["+index_id.to_s+"]/td[9]/a[2]"
      @selenium.choose_ok_on_next_confirmation
      @selenium.click(delete_xpath)
      @selenium.get_confirmation
    end
    #
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
    def create_2nd_user
      @selenium.open($xpath["admin_menu_page"])
      wait_for_element_present($xpath["user"]["user_management"])
      @selenium.click($xpath["user"]["user_management"])
      wait_for_element_present("link=#{$link_texts["register"]}")
      @selenium.click("link=#{$link_texts["register"]}")
      wait_for_element_present($xpath["pu_user"]["register_button"])
      @selenium.type "user_account_name", USER_ACCOUNT_NAME
      @selenium.type "user_last_name",USER_LAST_NAME
      @selenium.type "user_first_name", USER_FIRST_NAME
      @selenium.type "user_email", USER_EMAIL
      @selenium.type "user_password", USER_PASSWORD
      @selenium.type "user_password_confirmation", USER_PASSWORD
      @selenium.click($xpath["pu_user"]["register_button"])
      wait_for_text_present("#{_("User")} #{USER_LAST_NAME} #{_("was registered")}")
      @selenium.type "user_account_name", NEW_USER_ACCOUNT_NAME
      @selenium.type "user_last_name",NEW_USER_LAST_NAME
      @selenium.type "user_first_name", NEW_USER_FIRST_NAME
      @selenium.type "user_email", NEW_USER_EMAIL
      @selenium.type "user_password", NEW_USER_PASSWORD
      @selenium.type "user_password_confirmation", NEW_USER_PASSWORD
      @selenium.click($xpath["pu_user"]["register_button"])
    end
    #
    def create_1st_user(user_account_name=USER_ACCOUNT_NAME,
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
      @selenium.type "user_last_name",user_last_name
      @selenium.type "user_first_name", user_first_name
      @selenium.type "user_email", user_email
      @selenium.type "user_password", user_password
      @selenium.type "user_password_confirmation", user_password
      @selenium.click($xpath["pu_user"]["register_button"])
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
  end
end
