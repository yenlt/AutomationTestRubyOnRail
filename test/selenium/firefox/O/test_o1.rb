require File.dirname(__FILE__) + "/test_o_setup" unless defined? TestOSetup
#require "test/unit"
class TestO1 < Test::Unit::TestCase
  include TestOSetup
  # Display list of user in User Management page
  def test_001
    test_000
    login("root","root")
    ## delete user "pj_member"
    delete_user(3)
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    assert @selenium.is_element_present($xpath["user"]["user_list_row"]+"[1]/th[1]")
    assert_equal "root", @selenium.get_text($xpath["user"]["user_list_row"]+"[2]/td[3]")
    assert_equal ADMIN_NAME, @selenium.get_text($xpath["user"]["user_list_row"]+"[2]/td[4]")
    logout
  end
  # If there is only 1 user in database
  # User list will have 2 row: header row and the first user's row
  # This table will not have third row
  def test_002
    test_000
    login("root","root")
    ## delete user "pj_member"
    delete_user(3)
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    @selenium.click($xpath["user"]["user_management"])
    sleep WAIT_TIME
    begin
      assert @selenium.is_element_present($xpath["user"]["user_list_row"]+"[1]/th[1]")
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    begin
      assert @selenium.is_element_present($xpath["user"]["user_list_row"]+"[2]/td[1]")
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    begin
      assert_equal ADMIN_NAME, @selenium.get_text($xpath["user"]["user_list_row"]+"[2]/td[4]")
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    #only admin
    (1..9).each do |i|
      begin
        assert !@selenium.is_element_present($xpath["user"]["user_list_row"]+"[3]/td[#{i}]")
      rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
      end
    end
    logout
  end
  # when there are many users in database
  # a list of users will be displayed
  def test_003
    test_000
    login("root","root")
    ## create new user
    create_user
    total_user=get_xpath_count($xpath["user"]["user_list_row"])
    assert_equal USER_LAST_NAME + " "+ USER_FIRST_NAME, @selenium.get_text($xpath["user"]["user_list_row"]+"[#{total_user}]/td[4]")
    assert_equal USER_EMAIL, @selenium.get_text($xpath["user"]["user_list_row"]+"[#{total_user}]/td[6]")
    logout
  end
end
