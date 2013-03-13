require File.dirname(__FILE__) + "/test_o_setup" unless defined? TestOSetup
#require "test/unit"
class TestO3 < Test::Unit::TestCase
  include TestOSetup
  # open List registered user page
  # after click link "変更", the subwindow will appear to edit information about a registered user
  def test_043
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    sleep WAIT_TIME
    assert_equal $window_titles["update_user_information"], @selenium.get_text($xpath["user"]["sub_window"]+ "/div/h3")
    logout
  end
  
  
  # open List registered user page
  # click link "変更", the subwindow will appear to edit information about a registered user
  # after click 'X' button on subwindow, this subwindow will fade out
  def test_044
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    sleep WAIT_TIME
    subwindow_id = @selenium.get_attribute("//body/div[2]@id")
    @selenium.click subwindow_id + "_close"
    sleep WAIT_TIME
    assert !is_element_present($window_titles["edit_user"])
    logout
  end
  # open change user information subwindow
  # the UserID is unentered and click the update button
  # the subwindow will be faded out
  def test_045
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    sleep WAIT_TIME
    @selenium.type "user_account_name", ""
    @selenium.click $xpath["user"]["update_user"]
    sleep WAIT_TIME
    assert !is_element_present($window_titles["edit_user"])
    logout
  end
  # open change user information subwindow
  # the UserID is unentered and click the update button
  # the log display will have "ユーザ情報の更新に失敗しました。入力内容をご確認ください。"
  def test_046
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    sleep WAIT_TIME
    @selenium.type "user_account_name", ""
    @selenium.click $xpath["user"]["update_user"]
    sleep WAIT_TIME
    assert @selenium.is_text_present($messages["update_user_failed"])
    logout
  end
  # open change user information subwindow
  # the last name of user is unentered and click the update button
  # the subwindow will be faded out
  def test_047
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    sleep WAIT_TIME
    @selenium.type "user_last_name", ""
    @selenium.click $xpath["user"]["update_user"]
    sleep WAIT_TIME
    assert !is_element_present($window_titles["edit_user"])
    logout
  end
  
  
  # open change user information subwindow
  # the last name of user is unentered and click the update button
  # the log display will have "ユーザ情報の更新に失敗しました。入力内容をご確認ください。"
  def test_048
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    sleep WAIT_TIME
    @selenium.type "user_last_name", ""
    @selenium.click $xpath["user"]["update_user"]
    sleep WAIT_TIME
    assert @selenium.is_text_present($messages["update_user_failed"])
    logout
  end
  
  # open change user information subwindow
  # the first name of user is unentered and click the update button
  # the subwindow will be faded out
  def test_049
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    sleep WAIT_TIME
    @selenium.type "user_first_name", ""
    @selenium.click $xpath["user"]["update_user"]
    sleep WAIT_TIME
    assert !is_element_present($window_titles["edit_user"])
    logout
  end
  
  
  # open change user information subwindow
  # the first name of user is unentered and click the update button
  # the log display will have "ユーザ情報の更新に失敗しました。入力内容をご確認ください。"
  def test_050
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    sleep WAIT_TIME
    @selenium.type "user_first_name", ""
    @selenium.click $xpath["user"]["update_user"]
    sleep WAIT_TIME
    assert @selenium.is_text_present($messages["update_user_failed"])
    logout
  end
  
  
  # open change user information subwindow
  # the email address of user is unentered and click the update button
  # the subwindow will be faded out
  def test_051
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    sleep WAIT_TIME
    @selenium.type "user_email", ""
    @selenium.click $xpath["user"]["update_user"]
    sleep WAIT_TIME
    assert !is_element_present($window_titles["edit_user"])
    logout
  end


  # open change user information subwindow
  # the email address of user is unentered and click the update button
  # the log display will have "ユーザ情報の更新に失敗しました。入力内容をご確認ください。"
  def test_052
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    sleep WAIT_TIME
    @selenium.type "user_email", ""
    @selenium.click $xpath["user"]["update_user"]
    sleep WAIT_TIME
    assert @selenium.is_text_present($messages["update_user_failed"])
    logout
  end
  
  
  # open change user information subwindow
  # the password of user is unentered and click the update button
  # the password confirmation is entered
  # the subwindow will be faded out
  def test_053
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    sleep WAIT_TIME
    @selenium.type "user_password", ""
    @selenium.click $xpath["user"]["update_user"]
    sleep WAIT_TIME
    assert !is_element_present($window_titles["edit_user"])
    logout
  end


  # open change user information subwindow
  # the password of user is unentered and click the update button
  # the password confirmation is entered
  # the log display will have "ユーザ情報の更新に失敗しました。入力内容をご確認ください。"
  def test_054
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    sleep WAIT_TIME
    @selenium.type "user_password", ""
    @selenium.type "user_password_confirmation",USER_PASSWORD
    @selenium.click $xpath["user"]["update_user"]
    sleep WAIT_TIME
    #this test case failed
    assert @selenium.is_text_present($messages["update_user_failed"])
    logout
  end
  
  # open change user information subwindow
  # the password is entered
  # the password confirmation of user is unentered and click the update button
  # the subwindow will be faded out
  def test_055
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    sleep WAIT_TIME
    @selenium.type "user_password_confirmation", ""
    @selenium.click $xpath["user"]["update_user"]
    sleep WAIT_TIME
    assert !is_element_present($window_titles["edit_user"])
    logout
  end


  # open change user information subwindow
  # the password is entered
  # the password confirmation of user is unentered and click the update button
  # the log display will have "ユーザ情報の更新に失敗しました。入力内容をご確認ください。"
  def test_056
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    sleep WAIT_TIME
    @selenium.type "user_password", USER_PASSWORD
    @selenium.type "user_password_confirmation", ""
    @selenium.click $xpath["user"]["update_user"]
    sleep WAIT_TIME
    #this test case failed
    assert @selenium.is_text_present($messages["update_user_failed"])
    logout
  end
  
  # open change user information subwindow
  # both the password and the password confirmation of user is entered
  # but the password is different from the password confirmation
  # click the update button
  # the subwindow will be faded out
  def test_057
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    sleep WAIT_TIME
    @selenium.type "user_password_confirmation", WRONG_PASSWORD
    @selenium.click $xpath["user"]["update_user"]
    sleep WAIT_TIME
    assert !is_element_present($window_titles["edit_user"])
    logout
  end


  # open change user information subwindow
  # both the password and the password confirmation of user is entered
  # but the password is different from the password confirmation
  # click the update button
  # the log display will have "ユーザ情報の更新に失敗しました。入力内容をご確認ください。"
  def test_058
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    sleep WAIT_TIME
    @selenium.type "user_password_confirmation", WRONG_PASSWORD
    @selenium.click $xpath["user"]["update_user"]
    sleep WAIT_TIME
    assert @selenium.is_text_present($messages["update_user_failed"])
    logout
  end
  # open change user information subwindow
  # both the password and the password confirmation of user is unentered
  # click the update button
  # the subwindow will be faded out
  def test_059
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    sleep WAIT_TIME
    @selenium.type "user_password", ""
    @selenium.type "user_password_confirmation", ""
    @selenium.click $xpath["user"]["update_user"]
    sleep WAIT_TIME
    assert !is_element_present($window_titles["edit_user"])
    logout
  end
  # open change user information subwindow
  # both the password and the password confirmation of user is unentered
  # click the update button
  # the log display will have "ユーザ情報を更新しました。"
  def test_060
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    sleep WAIT_TIME
    @selenium.type "user_password", ""
    @selenium.type "user_password_confirmation", ""
    @selenium.click $xpath["user"]["update_user"]
    sleep WAIT_TIME
    assert @selenium.is_text_present($messages["update_user_passed"])
    logout
  end
  # open change user information subwindow
  # both password and password confirmation are unentered
  # click the update button
  # we will relogin with old password
  # successful login demonstrates that the password of user wasn't changed
  def test_061
    test_000
    login("root","root")
    create_user
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    sleep WAIT_TIME
    @selenium.type "user_password", ""
    @selenium.type "user_password_confirmation", ""
    @selenium.click $xpath["user"]["update_user"]
    sleep WAIT_TIME
    assert @selenium.is_text_present($messages["update_user_passed"])
    logout
    login(USER_ACCOUNT_NAME,USER_PASSWORD)
    assert @selenium.is_element_present("link=#{$link_texts["toscana_management"]}")
    logout
  end
  # open change user information window
  # fill all information
  # click the update button
  # this button will be disable in a fixed time
  # but in this version, the subwindow is faded out and this button is still editable
  # the subwindow will be faded out
  def test_062
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    wait_for_element_present($xpath["user"]["update_user"])
    @selenium.type "user_account_name", NEW_USER_ACCOUNT_NAME
    @selenium.type "user_last_name", NEW_USER_LAST_NAME
    @selenium.type "user_first_name", NEW_USER_FIRST_NAME
    @selenium.type "user_email", NEW_USER_EMAIL
    @selenium.type "user_password", NEW_USER_PASSWORD
    @selenium.type "user_password_confirmation", NEW_USER_PASSWORD
    @selenium.click $xpath["user"]["update_user"]
    begin
      assert !@selenium.is_editable($xpath["user"]["update_user"])
    rescue Test::Unit::AssertionFailedError
      printf "This Test Fail!\n"
      @verification_errors << $!
    end
    sleep WAIT_TIME
    assert !is_element_present($window_titles["edit_user"])
    logout
  end
  # open change user information window
  # fill all information
  # click the update button
  # on the logdisplay will have "ユーザ情報を更新しました。"
  def test_063
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    sleep WAIT_TIME
    @selenium.type "user_account_name", NEW_USER_ACCOUNT_NAME
    @selenium.type "user_last_name", NEW_USER_LAST_NAME
    @selenium.type "user_first_name", NEW_USER_FIRST_NAME
    @selenium.type "user_email", NEW_USER_EMAIL
    @selenium.type "user_password", NEW_USER_PASSWORD
    @selenium.type "user_password_confirmation", NEW_USER_PASSWORD
    @selenium.click $xpath["user"]["update_user"]
    wait_for_text_present($messages["update_user_passed"])
    logout
  end
  
  # open change user information window
  # fill all information
  # click the update button
  # new information will be updated in the list registered user
  # we will relogin to check new password
  def test_064
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    total_user =get_xpath_count($xpath["user"]["user_list_row"])
    edit_user = $xpath["user"]["user_list_row"] + "[#{total_user}]/td[9]/a[1]"
    @selenium.click(edit_user)
    sleep WAIT_TIME
    @selenium.type "user_account_name", NEW_USER_ACCOUNT_NAME
    @selenium.type "user_last_name", NEW_USER_LAST_NAME
    @selenium.type "user_first_name", NEW_USER_FIRST_NAME
    @selenium.type "user_email", NEW_USER_EMAIL
    @selenium.type "user_password", NEW_USER_PASSWORD
    @selenium.type "user_password_confirmation", NEW_USER_PASSWORD
    @selenium.click $xpath["user"]["update_user"]
    wait_for_element_not_present($xpath["user"]["update_user"])
    logout
    login(NEW_USER_ACCOUNT_NAME,NEW_USER_PASSWORD)
    assert @selenium.is_element_present("link=#{$link_texts["toscana_management"]}")
    logout
  end

end
