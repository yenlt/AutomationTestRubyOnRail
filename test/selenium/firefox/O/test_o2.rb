require File.dirname(__FILE__) + "/test_o_setup" unless defined? TestOSetup
#require "test/unit"
class TestO2 < Test::Unit::TestCase
  include TestOSetup
  # after clicking link "[登録]", a subwindow will appear
  # this subwindow is used to register a new user
  def test_004
    test_000
    login("root","root")
    ## delete user "pj_member"
    delete_user(3)
    @selenium.open($xpath["admin_menu_page"])
    wait_for_element_present($xpath["user"]["user_management"])
    @selenium.click($xpath["user"]["user_management"])
    wait_for_element_present("link=#{$link_texts["register"]}")
    @selenium.click("link=#{$link_texts["register"]}")
    wait_for_text_present(_("User Registration"))
    logout
  end
  # Register a new user without an UserID
  # TOSCANA will raise an error "-- registration failure: -- please confirm an entry content -- "
  # In this version of TOSCANA, the log will display this error in Japanese,
  # this is "登録失敗：入力内容をご確認ください。"
  def test_005
    test_000
    login("root","root")
    create_user("","new","user","newuser@tsdv.com.vn","abcdef")
    wait_for_text_present($messages["register_user_failed"])
    logout
  end
  # After click link to register a new user, all information in this form will be cleared  #
  def test_006
    test_000
    login("root","root")
    create_1st_user("","new","user","newuser@tsdv.com.vn","abcdef")
    sleep WAIT_TIME
    (2..7).each do |i|
      if(i!=3)
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td")
      else
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td/input[@id='user_last_name']")
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td/input[@id='user_first_name']")
      end
    end
    logout
  end
  # if User ID is not entered in registration form, there isn't any new user registered
  # User ID in registration form will not be changed
  def test_007
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{$link_texts["register"]}")
    sleep WAIT_TIME
    user_id = @selenium.get_text($xpath["user"]["user_register"]+"/tr[1]/td")
    @selenium.type "user_last_name",USER_LAST_NAME
    @selenium.type "user_first_name",USER_FIRST_NAME
    @selenium.type "user_email", USER_EMAIL
    @selenium.type "user_password", USER_PASSWORD
    @selenium.type "user_password_confirmation", USER_PASSWORD
    @selenium.click($xpath["pu_user"]["register_button"])
    sleep WAIT_TIME
    begin
      assert_equal user_id, @selenium.get_text($xpath["user"]["user_register"]+"/tr[1]/td")
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
  end
  # Register a new user without a last name
  # TOSCANA will raise an error "-- registration failure: -- please confirm an entry content -- "
  # In this version of TOSCANA, the log will display this error in Japanese
  # which is "登録失敗：入力内容をご確認ください。"
  def test_008
    test_000
    login("root","root")
    create_user("new_user","","user","newuser@tsdv.com.vn","abcdef")
    wait_for_text_present($messages["register_user_failed"])
    logout
  end
  # Register a new user without a last name
  # after click link to register, all information in the form will be clear
  def test_009
    test_000
    login("root","root")
    create_1st_user("new_user","","user","newuser@tsdv.com.vn","abcdef")
    sleep WAIT_TIME
    (2..7).each do |i|
      if(i!=3)
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td")
      else
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td/input[@id='user_last_name']")
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td/input[@id='user_first_name']")
      end
    end
    logout
  end
  # Register a new user without a last name
  # after click link to register, the User ID in the form will not  be changed
  def test_010
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{$link_texts["register"]}")
    sleep WAIT_TIME
    user_id = @selenium.get_text($xpath["user"]["user_register"]+"/tr[1]/td")
    @selenium.type "user_account_name", USER_ACCOUNT_NAME
    @selenium.type "user_first_name",USER_FIRST_NAME
    @selenium.type "user_email", USER_EMAIL
    @selenium.type "user_password", USER_PASSWORD
    @selenium.type "user_password_confirmation", USER_PASSWORD
    @selenium.click($xpath["pu_user"]["register_button"])
    sleep WAIT_TIME
    begin
      assert_equal user_id, @selenium.get_text($xpath["user"]["user_register"]+"/tr[1]/td")
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
  end
  # Register a new user without a first name
  # after click register link, The time of a log display is updated.
  def test_011
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{$link_texts["register"]}")
    sleep WAIT_TIME
    @selenium.type "user_account_name", USER_ACCOUNT_NAME
    @selenium.type "user_last_name",USER_LAST_NAME
    @selenium.type "user_email", USER_EMAIL
    @selenium.type "user_password", USER_PASSWORD
    @selenium.type "user_password_confirmation", USER_PASSWORD
    post_time = Time.now
    second = post_time.strftime("%S")
    hour_and_minute = post_time.strftime("%H:%M:")
    @selenium.click($xpath["pu_user"]["register_button"])
    sleep WAIT_TIME
    delay = 60
    result = 0
    for i in 0..delay do
      second_delay = (second.to_i + i).to_s
      if second_delay.to_i < 10
        second_delay = '0'+second_delay
      end
      log_display = hour_and_minute + second_delay +" "+$messages["register_user_failed"]
      if @selenium.is_text_present(log_display)
        result = 1
      end
    end
    assert_equal result,1
  end
  # Register a new user without a first name
  # TOSCANA will raise an error "-- registration failure: -- please confirm an entry content -- "
  # In this version of TOSCANA, the log will display this error in Japanese
  # which is "登録失敗：入力内容をご確認ください。"
  def test_012
    test_000
    login("root","root")
    create_user("new_user","new","","newuser@tsdv.com.vn","abcdef")
    wait_for_text_present($messages["register_user_failed"])
    logout
  end
  # Register a new user without a first name
  # after click link to register, all information in the form will be clear
  def test_013
    test_000
    login("root","root")
    create_1st_user("new_user","new","","newuser@tsdv.com.vn","abcdef")
    sleep WAIT_TIME
    (2..7).each do |i|
      if(i!=3)
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td")
      else
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td/input[@id='user_last_name']")
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td/input[@id='user_first_name']")
      end
    end
    logout
  end
  # Register a new user without a first name
  # after click link to register, the User ID in the form will not  be changed
  def test_014
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{$link_texts["register"]}")
    sleep WAIT_TIME
    user_id = @selenium.get_text($xpath["user"]["user_register"]+"/tr[1]/td")
    @selenium.type "user_account_name", USER_ACCOUNT_NAME
    @selenium.type "user_last_name",USER_LAST_NAME
    @selenium.type "user_email", USER_EMAIL
    @selenium.type "user_password", USER_PASSWORD
    @selenium.type "user_password_confirmation", USER_PASSWORD
    @selenium.click($xpath["pu_user"]["register_button"])
    sleep WAIT_TIME
    begin
      assert_equal user_id, @selenium.get_text($xpath["user"]["user_register"]+"/tr[1]/td")
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
  end
  # Register a new user without an email address
  # after click register link, The time of a log display is updated.
  def test_015
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{$link_texts["register"]}")
    sleep WAIT_TIME
    user_id = @selenium.get_text($xpath["user"]["user_register"]+"/tr[1]/td")
    @selenium.type "user_account_name", USER_ACCOUNT_NAME
    @selenium.type "user_last_name",USER_LAST_NAME
    @selenium.type "user_first_name", USER_FIRST_NAME
    @selenium.type "user_password", USER_PASSWORD
    @selenium.type "user_password_confirmation", USER_PASSWORD
    post_time = Time.now
    second = post_time.strftime("%S")
    hour_and_minute = post_time.strftime("%H:%M:")
    @selenium.click($xpath["pu_user"]["register_button"])
    sleep WAIT_TIME
    delay = 10
    result = 0
    for i in 0..delay do
      second_delay = (second.to_i + i).to_s
      if second_delay.to_i < 10
        second_delay = '0'+second_delay
      end
      log_display = hour_and_minute + second_delay +" "+$messages["register_user_failed"]
      if @selenium.is_text_present(log_display)
        result = 1
        break
      end
    end
    assert_equal result,1
    logout
  end
  # Register a new user without an email address
  # TOSCANA will raise an error "-- registration failure: -- please confirm an entry content -- "
  # In this version of TOSCANA, the log will display this error in Japanese
  # which is "登録失敗：入力内容をご確認ください。"
  def test_016
    test_000
    login("root","root")
    create_user("new_user","new","user","","abcdef")
    wait_for_text_present($messages["register_user_failed"])
    logout
  end
  # Register a new user without an email address
  # after click link to register, all information in the form will be clear
  def test_017
    test_000
    login("root","root")
    create_1st_user("new_user","new","user","","abcdef")
    sleep WAIT_TIME
    (2..7).each do |i|
      if(i!=3)
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td")
      else
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td/input[@id='user_last_name']")
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td/input[@id='user_first_name']")
      end
    end
    logout
  end
  # Register a new user without an email address
  # after click link to register, the User ID in the form will not  be changed
  def test_018
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{$link_texts["register"]}")
    sleep WAIT_TIME
    user_id = @selenium.get_text($xpath["user"]["user_register"]+"/tr[1]/td")
    @selenium.type "user_account_name", USER_ACCOUNT_NAME
    @selenium.type "user_last_name",USER_LAST_NAME
    @selenium.type "user_first_name", USER_FIRST_NAME
    @selenium.type "user_password", USER_PASSWORD
    @selenium.type "user_password_confirmation", USER_PASSWORD
    @selenium.click($xpath["pu_user"]["register_button"])
    sleep WAIT_TIME
    begin
      assert_equal user_id, @selenium.get_text($xpath["user"]["user_register"]+"/tr[1]/td")
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
  end
  # Register a new user without a password
  # after click register link, The time of a log display is updated.
  def test_019
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{$link_texts["register"]}")
    sleep WAIT_TIME
    user_id = @selenium.get_text($xpath["user"]["user_register"]+"/tr[1]/td")
    @selenium.type "user_account_name", USER_ACCOUNT_NAME
    @selenium.type "user_last_name",USER_LAST_NAME
    @selenium.type "user_first_name", USER_FIRST_NAME
    @selenium.type "user_email", USER_EMAIL
    @selenium.type "user_password_confirmation", USER_PASSWORD
    post_time = Time.now
    second = post_time.strftime("%S")
    hour_and_minute = post_time.strftime("%H:%M:")
    @selenium.click($xpath["pu_user"]["register_button"])
    sleep WAIT_TIME
    delay = 10
    result = 0
    for i in 0..delay do
      second_delay = (second.to_i + i).to_s
      if second_delay.to_i < 10
        second_delay = '0'+second_delay
      end
      log_display = hour_and_minute + second_delay +" "+$messages["register_user_failed"]
      if @selenium.is_text_present(log_display)
        result = 1
        break
      end
    end
    assert_equal result,1
    logout
  end
  # Register a new user without a password
  # TOSCANA will raise an error "-- registration failure: -- please confirm an entry content -- "
  # In this version of TOSCANA, the log will display this error in Japanese
  # which is "登録失敗：入力内容をご確認ください。"
  def test_020
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{$link_texts["register"]}")
    sleep WAIT_TIME
    @selenium.type "user_account_name", USER_ACCOUNT_NAME
    @selenium.type "user_last_name",USER_LAST_NAME
    @selenium.type "user_first_name", USER_FIRST_NAME
    @selenium.type "user_email", USER_EMAIL
    @selenium.type "user_password_confirmation", USER_PASSWORD
    @selenium.click($xpath["pu_user"]["register_button"])
    sleep WAIT_TIME
    wait_for_text_present($messages["register_user_failed"])
    logout
  end



  # Register a new user without a password
  # after click link to register, all information in the form will be clear
  def test_021
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{$link_texts["register"]}")
    sleep WAIT_TIME
    @selenium.type "user_account_name", USER_ACCOUNT_NAME
    @selenium.type "user_last_name", USER_LAST_NAME
    @selenium.type "user_first_name", USER_FIRST_NAME
    @selenium.type "user_email", USER_EMAIL
    @selenium.type "user_password_confirmation", USER_PASSWORD
    @selenium.click($xpath["pu_user"]["register_button"])
    sleep WAIT_TIME
    (2..7).each do |i|
      if(i!=3)
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td")
      else
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td/input[@id='user_last_name']")
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td/input[@id='user_first_name']")
      end
    end
    logout
  end
  # Register a new user without a password
  # after click link to register, the User ID in the form will not  be changed
  def test_022
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{$link_texts["register"]}")
    sleep WAIT_TIME
    user_id = @selenium.get_text($xpath["user"]["user_register"]+"/tr[1]/td")
    @selenium.type "user_account_name", USER_ACCOUNT_NAME
    @selenium.type "user_last_name",USER_LAST_NAME
    @selenium.type "user_first_name", USER_FIRST_NAME
    @selenium.type "user_email", USER_EMAIL
    @selenium.type "user_password_confirmation", USER_PASSWORD
    @selenium.click($xpath["pu_user"]["register_button"])
    sleep WAIT_TIME
    begin
      assert_equal user_id, @selenium.get_text($xpath["user"]["user_register"]+"/tr[1]/td")
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
  end
  # Register a new user without a password confirmation
  # TOSCANA will raise an error "-- registration failure: -- please confirm an entry content -- "
  # In this version of TOSCANA, the log will display this error in Japanese
  # which is "登録失敗：入力内容をご確認ください。"
  def test_023
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{$link_texts["register"]}")
    sleep WAIT_TIME
    @selenium.type "user_account_name", USER_ACCOUNT_NAME
    @selenium.type "user_last_name",USER_LAST_NAME
    @selenium.type "user_first_name", USER_FIRST_NAME
    @selenium.type "user_email", USER_EMAIL
    @selenium.type "user_password", USER_PASSWORD
    @selenium.click($xpath["pu_user"]["register_button"])
    sleep WAIT_TIME
    wait_for_text_present($messages["register_user_failed"])
    logout
  end
  # Register a new user without a password confirmation
  # after click link to register, all information in the form will be clear
  def test_024
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{$link_texts["register"]}")
    sleep WAIT_TIME
    @selenium.type "user_account_name", USER_ACCOUNT_NAME
    @selenium.type "user_last_name", USER_LAST_NAME
    @selenium.type "user_first_name", USER_FIRST_NAME
    @selenium.type "user_email", USER_EMAIL
    @selenium.type "user_password", USER_PASSWORD
    @selenium.click($xpath["pu_user"]["register_button"])
    sleep WAIT_TIME
    (2..7).each do |i|
      if(i!=3)
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td")
      else
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td/input[@id='user_last_name']")
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td/input[@id='user_first_name']")
      end
    end
    logout
  end
  # Register a new user without a password confirmation
  # after click link to register, the User ID in the form will not  be changed
  def test_025
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{$link_texts["register"]}")
    sleep WAIT_TIME
    user_id = @selenium.get_text($xpath["user"]["user_register"]+"/tr[1]/td")
    @selenium.type "user_account_name", USER_ACCOUNT_NAME
    @selenium.type "user_last_name",USER_LAST_NAME
    @selenium.type "user_first_name", USER_FIRST_NAME
    @selenium.type "user_email", USER_EMAIL
    @selenium.type "user_password", USER_PASSWORD
    @selenium.click($xpath["pu_user"]["register_button"])
    sleep WAIT_TIME
    begin
      assert_equal user_id, @selenium.get_text($xpath["user"]["user_register"]+"/tr[1]/td")
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
  end

  # Register a new user with password is different from password confirmation
  # TOSCANA will raise an error "-- registration failure: -- please confirm an entry content -- "
  # In this version of TOSCANA, the log will display this error in Japanese
  # which is "登録失敗：入力内容をご確認ください。"
  def test_026
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{$link_texts["register"]}")
    sleep WAIT_TIME
    @selenium.type "user_account_name", USER_ACCOUNT_NAME
    @selenium.type "user_last_name",USER_LAST_NAME
    @selenium.type "user_first_name", USER_FIRST_NAME
    @selenium.type "user_email", USER_EMAIL
    @selenium.type "user_password", USER_PASSWORD
    @selenium.type "user_password_confirmation", WRONG_PASSWORD
    @selenium.click($xpath["pu_user"]["register_button"])
    sleep WAIT_TIME
    wait_for_text_present($messages["register_user_failed"])
    logout
  end
  # Register a new user with password is different from password confirmation
  # after click link to register, all information in the form will be clear
  def test_027
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{$link_texts["register"]}")
    sleep WAIT_TIME
    @selenium.type "user_account_name", USER_ACCOUNT_NAME
    @selenium.type "user_last_name", USER_LAST_NAME
    @selenium.type "user_first_name", USER_FIRST_NAME
    @selenium.type "user_email", USER_EMAIL
    @selenium.type "user_password", USER_PASSWORD
    @selenium.type "user_password_confirmation", WRONG_PASSWORD
    @selenium.click($xpath["pu_user"]["register_button"])
    sleep WAIT_TIME
    (2..7).each do |i|
      if(i!=3)
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td")
      else
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td/input[@id='user_last_name']")
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td/input[@id='user_first_name']")
      end
    end
    logout
  end
  # Register a new user with password is different from password confirmation
  # after click link to register, the User ID in the form will not  be changed
  def test_028
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{$link_texts["register"]}")
    sleep WAIT_TIME
    user_id = @selenium.get_text($xpath["user"]["user_register"]+"/tr[1]/td")
    @selenium.type "user_account_name", USER_ACCOUNT_NAME
    @selenium.type "user_last_name",USER_LAST_NAME
    @selenium.type "user_first_name", USER_FIRST_NAME
    @selenium.type "user_email", USER_EMAIL
    @selenium.type "user_password", USER_PASSWORD
    @selenium.type "user_password_confirmation", WRONG_PASSWORD
    @selenium.click($xpath["pu_user"]["register_button"])
    sleep WAIT_TIME
    begin
      assert_equal user_id, @selenium.get_text($xpath["user"]["user_register"]+"/tr[1]/td")
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
  end
  # Register a new user will all valid information
  # After clicked 'Register' button, this button will be disable in a fixed time
  # But in this version of TOSCANA, this button isn't disable after being clicked.
  def test_029
    test_000
    login("root","root")
    create_1st_user
    begin
      assert !@selenium.is_editable($xpath["pu_user"]["register_button"])
    rescue Test::Unit::AssertionFailedError
      printf "This Test Fail!\n"
      @verification_errors << $!
    end
    logout
  end
  # Register a new user will all valid information
  # After registering sucessful, the log display will be changed to inform the successful registration
  # This log will contain "ユーザ userを登録しました。"
  #
  def test_030
    test_000
    login("root","root")
    ## create new user
    create_user
    sleep WAIT_TIME
    wait_for_text_present($messages["register_user_success"].sub("_NEW_USER_",USER_LAST_NAME))
    logout
  end
  # Register a new user will all valid information
  # After registering sucessful,
  # the information of new user will be updated in The list of registered users
  #
  def test_031
    test_000
    login("root","root")
    ## create new user
    create_user
    wait_for_text_present("#{_("User")} #{USER_LAST_NAME} #{_("was registered")}")
    total_user=get_xpath_count($xpath["user"]["user_list_row"])
    assert_equal USER_LAST_NAME + " "+ USER_FIRST_NAME, @selenium.get_text($xpath["user"]["user_list_row"]+"[#{total_user}]/td[4]")
    assert_equal USER_EMAIL, @selenium.get_text($xpath["user"]["user_list_row"]+"[#{total_user}]/td[6]")
    logout
  end
  # Register a new user will all valid information
  # After registering sucessful, the subwindow will not be fade out
  def test_032
    test_000
    login("root","root")
    create_1st_user
    sleep WAIT_TIME
    attribute = @selenium.get_attribute("//body/div[2]@style")
    # if there is a piece of text "display: none", this subwindow will be fade out
    result = (attribute.to_s =~ /display: none/ )
    # 'result' is nill demonstrates that the subwindow still available
    assert_equal result, nil
    logout
  end
  # Register a new user will all valid information
  # After registering sucessful,
  # all the information of previous user will be cleared
  def test_033
    test_000
    login("root","root")
    create_1st_user
    sleep WAIT_TIME
    (2..7).each do |i|
      if(i!=3)
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td")
      else
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td/input[@id='user_last_name']")
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td/input[@id='user_first_name']")
      end
    end
    logout
  end


  # Register a new user will all valid information
  # After registering sucessful,
  # all the information of previous user will be cleared and the ID of new user will increase by 1
  def test_034
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{$link_texts["register"]}")
    sleep WAIT_TIME
    user_id = @selenium.get_text($xpath["user"]["user_register"]+"/tr[1]/td")
    create_1st_user
    sleep WAIT_TIME
    new_user_id= @selenium.get_text($xpath["user"]["user_register"]+"/tr[1]/td")
    user_id = user_id.to_i
    new_user_id=new_user_id.to_i
    assert user_id +1 , new_user_id
    logout
  end
  # The 2nd user is continuously registered after a user's registration
  # after that, the 'register' button will be in a fixed time disable state.
  # In this version of TOSCANA, this button is not disable
  def test_035
    test_000
    login("root","root")
    create_2nd_user
    begin
      assert !@selenium.is_editable($xpath["pu_user"]["register_button"])
    rescue Test::Unit::AssertionFailedError
      printf "This Test Fail!\n"
      @verification_errors << $!
    end
    logout
  end
  # The 2nd user is continuously registered after a user's registration
  # after that, the time on the log display is update
  #
  def test_036
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{$link_texts["register"]}")
    sleep WAIT_TIME
    @selenium.type "user_account_name", USER_ACCOUNT_NAME
    @selenium.type "user_last_name",USER_LAST_NAME
    @selenium.type "user_first_name", USER_FIRST_NAME
    @selenium.type "user_email", USER_EMAIL
    @selenium.type "user_password", USER_PASSWORD
    @selenium.type "user_password_confirmation", USER_PASSWORD
    @selenium.click($xpath["pu_user"]["register_button"])
    sleep WAIT_TIME
    @selenium.type "user_account_name", NEW_USER_ACCOUNT_NAME
    @selenium.type "user_last_name",NEW_USER_LAST_NAME
    @selenium.type "user_first_name", NEW_USER_FIRST_NAME
    @selenium.type "user_email", NEW_USER_EMAIL
    @selenium.type "user_password", NEW_USER_PASSWORD
    @selenium.type "user_password_confirmation", NEW_USER_PASSWORD
    post_time = Time.now
    second = post_time.strftime("%S")
    hour_and_minute = post_time.strftime("%H:%M:")
    @selenium.click($xpath["pu_user"]["register_button"])
    run_script("destroy_subwindow()")
    sleep WAIT_TIME
    delay = 60
    result = 0
    for i in 0..delay do
      second_delay = (second.to_i + i).to_s
      if second_delay.to_i < 10
        second_delay = '0'+ second_delay
      end
      log_display =hour_and_minute + second_delay +" " + $messages["register_user_success"].sub("_NEW_USER_",NEW_USER_LAST_NAME)
      if @selenium.is_text_present(log_display)
        result = 1
        break
      end
    end
    assert_equal result,1
  end
  # The 2nd user is continuously registered after a user's registration
  # after that, the log display will have 'ユーザ new 2を登録しました。'
  #
  def test_037
    test_000
    login("root","root")
    create_2nd_user
    run_script("destroy_subwindow()")
    sleep WAIT_TIME
    assert @selenium.is_text_present($messages["register_user_success"].sub("_NEW_USER_",NEW_USER_LAST_NAME))
    sleep WAIT_TIME
    logout
  end
  # The 2nd user is continuously registered after a user's registration
  # after that, the information about two new users will be displayed on The list of User
  def test_038
    test_000
    login("root","root")
    create_2nd_user
    run_script("destroy_subwindow()")
    sleep WAIT_TIME
    total_user=get_xpath_count($xpath["user"]["user_list_row"])
    assert_equal NEW_USER_LAST_NAME + " "+ NEW_USER_FIRST_NAME, @selenium.get_text($xpath["user"]["user_list_row"]+"[#{total_user}]/td[4]")
    assert_equal NEW_USER_EMAIL, @selenium.get_text($xpath["user"]["user_list_row"]+"[#{total_user}]/td[6]")
    logout
  end

  # The 2nd user is continuously registered after a user's registration
  # after that the fade-out of subwindow is not carried out
  def test_039
    test_000
    login("root","root")
    create_2nd_user
    sleep WAIT_TIME
    abc = @selenium.get_attribute("//body/div[2]@style")
    # if there is a piece of text "display: none", this subwindow will be fade out
    result = (abc.to_s =~ /display: none/ )
    # 'result' is nill demonstrates that the subwindow still available
    assert_equal result, nil
    logout
  end

  # The 2nd user is continuously registered after a user's registration
  # after that the information of previous user is cleaned
  def test_040
    test_000
    login("root","root")
    create_2nd_user
    sleep WAIT_TIME
    (2..7).each do |i|
      if(i!=3)
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td")
      else
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td/input[@id='user_last_name']")
        assert_equal "",@selenium.get_text($xpath["user"]["user_register"]+"/tr[#{i}]/td/input[@id='user_first_name']")
      end
    end
    logout
  end

  # The 2nd user is continuously registered after a user's registration
  # after that the User ID increase by 1
  def test_041
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{$link_texts["register"]}")
    sleep WAIT_TIME
    user_id = @selenium.get_text($xpath["user"]["user_register"]+"/tr[1]/td")
    create_2nd_user
    sleep WAIT_TIME
    new_user_id= @selenium.get_text($xpath["user"]["user_register"]+"/tr[1]/td")
    user_id = user_id.to_i
    new_user_id=new_user_id.to_i
    assert user_id +2 , new_user_id
    logout
  end
  # after click "X" button on the subwindow, it will fade out
  def test_042
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{$link_texts["register"]}")
    sleep WAIT_TIME
    subwindow_id = @selenium.get_attribute("//body/div[2]@id")
    close_button = subwindow_id + "_close"
    @selenium.click close_button
    sleep WAIT_TIME
    assert !is_element_present($window_titles["register_user"])
    logout
  end
end
