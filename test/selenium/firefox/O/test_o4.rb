require File.dirname(__FILE__) + "/test_o_setup" unless defined? TestOSetup
#require "test/unit"
class TestO4 < Test::Unit::TestCase
  include TestOSetup
  # Change own information
  # Display "Change of User Information" page
  def test_065
    test_000
    login(PJ_MEMBER_ID, PJ_MEMBER_PASSWORD)
    @selenium.open($xpath["index_page"])
    wait_for_element_present($xpath["user"]["user_infor"])
    @selenium.click($xpath["user"]["user_infor"])
    wait_for_text_present($window_titles["update_user_information"])
    wait_for_text_present($link_texts["pu_user"]["pu_user_list_table"][1])
    wait_for_text_present($link_texts["pu_user"]["pu_user_list_table"][2])
    logout
  end

  # open "Change of User Information" page
  # The User ID is unentered and click update button
  # The log display will inform an error "ユーザ情報の更新に失敗しました。入力内容をご確認ください。"
  def test_066
    test_000
    login(PJ_MEMBER_ID, PJ_MEMBER_PASSWORD)
    wait_for_element_present($xpath["user"]["user_infor"])
    @selenium.click($xpath["user"]["user_infor"])
    wait_for_element_present($xpath["user"]["update_user"])
    @selenium.type "user_account_name", ""
    @selenium.click($xpath["user"]["update_user"])
    begin
      wait_for_text_present($messages["update_user_failed"])
    rescue Exception => e
      printf "This Test Fail!\n"
      assert false
    end
    
    logout
  end

  # open "Change of User Information" page
  # The last name of user is unentered and click update button
  # The log display will inform an error "ユーザ情報の更新に失敗しました。入力内容をご確認ください。"
  def test_067
    test_000
    login(PJ_MEMBER_ID, PJ_MEMBER_PASSWORD)
    wait_for_element_present($xpath["user"]["user_infor"])
    @selenium.click($xpath["user"]["user_infor"])
    wait_for_element_present($xpath["user"]["update_user"])
    @selenium.type "user_last_name", ""
    @selenium.click($xpath["user"]["update_user"])
    sleep WAIT_TIME
    begin
      wait_for_text_present($messages["update_user_failed"])
    rescue Exception => e
      printf "This Test Fail!\n"
      assert false
    end
    logout
  end


  # open "Change of User Information" page
  # The first name of user is unentered and click update button
  # The log display will inform an error "ユーザ情報の更新に失敗しました。入力内容をご確認ください。"
  def test_068
    test_000
    login(PJ_MEMBER_ID, PJ_MEMBER_PASSWORD)
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_infor"])
    sleep WAIT_TIME
    @selenium.type "user_first_name", ""
    @selenium.click($xpath["user"]["update_user"])
    sleep WAIT_TIME
    begin
      wait_for_text_present($messages["update_user_failed"])
    rescue Exception => e
      printf "This Test Fail!\n"
      assert false
    end
    logout
  end

  # open "Change of User Information" page
  # The email address is unentered and click update button
  # The log display will inform an error "ユーザ情報の更新に失敗しました。入力内容をご確認ください。"
  def test_069
    test_000
    login(PJ_MEMBER_ID, PJ_MEMBER_PASSWORD)
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_infor"])
    sleep WAIT_TIME
    @selenium.type "user_email", ""
    @selenium.click($xpath["user"]["update_user"])
    sleep WAIT_TIME
    begin
      wait_for_text_present($messages["update_user_failed"])
    rescue Exception => e
      printf "This Test Fail!\n"
      assert false
    end
    logout
  end

  # open "Change of User Information" page
  # password and password confirmation are unentered and click update  button
  # The log display will inform "ユーザ情報を更新しました。"
  def test_070
    test_000
    login(PJ_MEMBER_ID, PJ_MEMBER_PASSWORD)
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_infor"])
    sleep WAIT_TIME
    @selenium.type "user_password", ""
    @selenium.type "user_password_confirmation", ""
    @selenium.click($xpath["user"]["update_user"])
    sleep WAIT_TIME
    wait_for_text_present($messages["update_user_passed"])
    logout
  end

  # open "Change of User Information" page
  # password and password confirmation are unentered and click update  button
  # relogin with old password
  def test_071
    test_000
    login(PJ_MEMBER_ID, PJ_MEMBER_PASSWORD)
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_infor"])
    sleep WAIT_TIME
    @selenium.type "user_password", ""
    @selenium.type "user_password_confirmation", ""
    @selenium.click($xpath["user"]["update_user"])
    sleep WAIT_TIME
    wait_for_text_present($messages["update_user_passed"])
    logout
    login(PJ_MEMBER_ID, PJ_MEMBER_PASSWORD)
    assert @selenium.is_element_present("link=#{$link_texts["toscana_management"]}")
    logout
  end

  # open "Change of User Information" page
  # the password field is empty and click update button
  def test_072
    test_000
    login(PJ_MEMBER_ID, PJ_MEMBER_PASSWORD)
    wait_for_element_present($xpath["user"]["user_infor"])
    @selenium.click($xpath["user"]["user_infor"])
    wait_for_element_present($xpath["user"]["update_user"])
    @selenium.type "user_password", ""
    @selenium.click($xpath["user"]["update_user"])
    sleep WAIT_TIME
    wait_for_text_present($messages["update_user_passed"])
    logout
  end

  # open "Change of User Information" page
  # the password confirmation field is empty and click update button
  def test_073
    test_000
    login(PJ_MEMBER_ID, PJ_MEMBER_PASSWORD)
    wait_for_element_present($xpath["user"]["user_infor"])
    @selenium.click($xpath["user"]["user_infor"])
    wait_for_element_present($xpath["user"]["update_user"])
    @selenium.type "user_password_confirmation", ""
    @selenium.click($xpath["user"]["update_user"])
    sleep WAIT_TIME
    wait_for_text_present($messages["update_user_passed"])
    logout
  end

  # open "Change of User Information" page
  # the password is different from the password confirmation
  # then click update button
  # this test is failed because we can't update successfully with the conditions above
  def test_074
    test_000
    login(PJ_MEMBER_ID, PJ_MEMBER_PASSWORD)
    wait_for_element_present($xpath["user"]["user_infor"])
    @selenium.click($xpath["user"]["user_infor"])
    wait_for_element_present($xpath["user"]["update_user"])
    @selenium.type "user_password", PJ_MEMBER_PASSWORD
    @selenium.type "user_password_confirmation", WRONG_PASSWORD
    @selenium.click($xpath["user"]["update_user"])
    sleep WAIT_TIME
    wait_for_text_present($messages["update_user_passed"])
    logout
  end




end
