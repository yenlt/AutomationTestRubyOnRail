require File.dirname(__FILE__) + "/test_scm_setup" unless defined? TestSCMSetup
require 'test/unit'

class TestSCM < Test::Unit::TestCase
  include TestSCMSetup
  #
  # Test Access right of Periodical Analysis Setting
  #
  # User hasn't logged in.
  # Request to view Periodical Analysis Setting tab.
  #
  def test_scm_st_001
    printf "\n Test 001"
    open "/devgroup/pj_index/1/1"
    sleep SLEEP_TIME
    assert @selenium.is_text_present($page_titles["auth_login"])
  end
  # Logged in as an PJ admin.
  # Request to view Periodical Analysis Setting tab.
  #
  def test_scm_st_002
    printf "\n Test 002"
    login(PJ_ADMIN_USER,PJ_ADMIN_PASSWORD)
    open "/devgroup/pj_index/1/1"
    sleep SLEEP_TIME
    click ($display_scm_xpath["menu_link"])
    sleep SLEEP_TIME
    assert is_text_present($display_scm["scm_tab_name"])
    logout
  end
  #
  # Test View of Periodical Analysis Setting tab.
  #
  # Access tab.
  # "Save", "Clear", "Delete", Save All Setting" button is displayed.
  #
  def test_scm_st_003
    printf "\n Test 003"
    open_periodical_analysis_setting_tab    
    assert(is_element_present($display_scm_xpath["save_button"]))   
    assert(is_element_present($display_scm_xpath["clear_button"]))
    assert(is_element_present($display_scm_xpath["delete_button"]))
    assert(is_element_present($display_scm_xpath["save_all_button"]))
    logout
  end
  # SCM select field is displayed.
  #
  def test_scm_st_004
    printf "\n Test 004"
    open_periodical_analysis_setting_tab
    assert is_text_present("SCM")
    assert(is_element_present($display_scm_xpath["scm_select_field"]))
    assert ["SVN","CVS"], get_select_options($display_scm_xpath["scm_select_field"])
    logout
  end
  # URL field is displayed.
  # This field is empty
  #
  def test_scm_st_005
    printf "\n Test 005"
    open_periodical_analysis_setting_tab
    assert(is_text_present($display_scm["URL*"]))
    assert(is_element_present($display_scm_xpath["url_field"]))
    assert_equal "",get_value($display_scm_xpath["url_field"])
    logout
  end
  # URL rule is displayed.
  #
  def test_scm_st_006
    printf "\n Test 006"
    open_periodical_analysis_setting_tab
    assert is_text_present($display_scm["url_rule"])
    logout
  end
  # User field is displayed.
  # This field is empty
  #
  def test_scm_st_007
    printf "\n Test 007"
    open_periodical_analysis_setting_tab
    assert is_text_present($display_scm["user_field"])
    assert is_element_present($display_scm_xpath["user_field"])
    assert_equal "",get_value($display_scm_xpath["user_field"])
    logout
  end
  # password field is displayed.
  # This field is empty
  #
  def test_scm_st_008
    printf "\n Test 008"
    open_periodical_analysis_setting_tab
    assert is_text_present($display_scm["password_field"])
    assert is_element_present($display_scm_xpath["password_field"])
    assert_equal "",get_value($display_scm_xpath["password_field"])
    logout
  end
  # Base revision field is displayed.
  # This field is empty
  #
  def test_scm_st_009
    printf "\n Test 009"
    open_periodical_analysis_setting_tab
    assert is_text_present($display_scm["revision_field"])
    assert is_element_present($display_scm_xpath["revision_field"])
    assert_equal "",get_value($display_scm_xpath["revision_field"])
    logout
  end
  # Master field is displayed.
  # This field is empty
  #
  def test_scm_st_010
    printf "\n Test 010"
    open_periodical_analysis_setting_tab
    assert is_text_present($display_scm["master_field"])
    assert is_element_present($display_scm_xpath["master_field"])
    assert_equal "",get_value($display_scm_xpath["master_field"])
    logout
  end
  # Analysis tool field is displayed.
  # This field is empty
  #
  def test_scm_st_011
    printf "\n Test 011"
    open_periodical_analysis_setting_tab
    assert is_text_present($display_scm["analysis_field"])
    assert is_element_present($display_scm_xpath["qac"])
    assert is_element_present($display_scm_xpath["qacpp"])
    assert is_text_present("QAC")
    assert is_text_present("QAC++")
    logout
  end
  # Interval field is displayed.
  # Default value is "*/30 * * * *"
  #
  def test_scm_st_012
    printf "\n Test 012"
    open_periodical_analysis_setting_tab
    assert is_text_present($display_scm["interval_field"])
    assert is_text_present($display_scm["interval_rule"])
    assert is_element_present($display_scm_xpath["interval_field"])
    assert_equal "*/30 * * * *",get_value($display_scm_xpath["interval_field"])
    logout
  end
  # File field is displayed.
  #
  def test_scm_st_013
    printf "\n Test 013"
    open_periodical_analysis_setting_tab
    assert is_text_present($display_scm["file_field"])
    assert is_element_present($display_scm_xpath["file_field"])
    logout
  end
  #
  # Test SCM select field
  #
  # Select CVS module
  #
  def test_scm_st_014
    printf "\n Test 014"
    open_periodical_analysis_setting_tab
    select $display_scm_xpath["scm_select_field"],"CVS"
    assert is_element_present($display_scm_xpath["cvs_access"])
    assert is_element_present($display_scm_xpath["cvs_module"])
    logout
  end
  # Save a right setting with SVN tool.
  #
  def test_scm_st_015
    printf "\n Test 015"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      1,
      0
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    begin
      assert(is_text_present($display_scm["success_message"]))
      open "/devgroup/pj_index/1/1"
      wait_for_page_to_load LOAD_TIME
      @selenium.click $display_scm_xpath["menu_link"]
      sleep SLEEP_TIME
      @selenium.click $display_scm_xpath["scm_tab"]
      sleep SLEEP_TIME
      assert_equal "SVN",get_selected_value($display_scm_xpath["scm_select_field"])
#    rescue Test::Unit::AssertionFailedError
#      @verification_errors << $!
    end
    logout
    ScmConfig.destroy_all
  end
  # Save a right setting with CVS tool.
  #
  def test_scm_st_016
    printf "\n Test 016"
    open_periodical_analysis_setting_tab
    fill_scm_form("CVS",
      CVS_ACCESS_TYPE,
      CVS_MODULE_RIGHT,
      URL_CVS_RIGHT_KEYWORD,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      1,
      0
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    begin
      assert(is_text_present($display_scm["success_message"]))
      open "/devgroup/pj_index/1/1"
      wait_for_page_to_load LOAD_TIME
      @selenium.click $display_scm_xpath["menu_link"]
      sleep SLEEP_TIME
      @selenium.click $display_scm_xpath["scm_tab"]
      sleep SLEEP_TIME
      assert_equal "CVS",get_selected_value($display_scm_xpath["scm_select_field"])
#    rescue Test::Unit::AssertionFailedError
#      @verification_errors << $!
    end
    logout
    ScmConfig.destroy_all
  end
  
  # Test url rule
  #
  # Input an invalid url.
  #
  def test_scm_st_017
    printf "\n Test 017"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      WRONG_URL,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      1,
      0
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
 #   assert(is_text_present($display_scm["url_error"]))
    sleep SLEEP_TIME
    logout
  end
  # Input a nil url.
  #
  def test_scm_st_018
    printf "\n Test 018"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      nil,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      1,
      0
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    #assert(is_text_present($display_scm["url_error"]))
    logout
  end
  # Save a right setting.
  # Access periodical analysis setting tab the second time.
  # Saved url is displayed.
  #
  def test_scm_st_019
    printf "\n Test 019"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      1,
      0
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    begin
      assert(is_text_present($display_scm["success_message"]))
      open "/devgroup/pj_index/1/1"
      wait_for_page_to_load LOAD_TIME
      @selenium.click $display_scm_xpath["menu_link"]
      sleep SLEEP_TIME
      @selenium.click $display_scm_xpath["scm_tab"]
      sleep SLEEP_TIME
      assert_equal URL_SVN_RIGHT_KEYWORD,get_value($display_scm_xpath["url_field"])
#    rescue Test::Unit::AssertionFailedError
#      @verification_errors << $!
    end
    logout
    ScmConfig.destroy_all
  end
  #
  # Test user & password field
  #
  # Input an incorrect user and password
  #
  def test_scm_st_020
    printf "\n Test 020"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_WRONG_KEYWORD,
      PASSWORD_WRONG_KEYWORD,
      nil,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      1,
      0
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
  #  assert(is_text_present($display_scm["url_error"]))
    logout
  end
  # Save a correct setting.
  # Access Periodical tab the second time.
  # Saved user is displayed.
  #
  def test_scm_st_021
    printf "\n Test 021"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      1,
      0
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    begin
      assert(is_text_present($display_scm["success_message"]))
      open "/devgroup/pj_index/1/1"
      wait_for_page_to_load LOAD_TIME
      @selenium.click $display_scm_xpath["menu_link"]
      sleep SLEEP_TIME
      @selenium.click $display_scm_xpath["scm_tab"]
      sleep SLEEP_TIME
      assert_equal LOGIN_RIGHT_KEYWORD,get_value($display_scm_xpath["user_field"])
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    ScmConfig.destroy_all
  end
  #
  # Test base revision field
  #
  # Input a string to base revision
  #
  def test_scm_st_022
    printf "\n Test 022"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_WRONG_KEYWORD,
      PASSWORD_WRONG_KEYWORD,
      "string",
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      1,
      0
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    assert(is_text_present($display_scm["url_error"]))
    logout
  end
  # input a nil base revision.
  #
  def test_scm_st_023
    printf "\n Test 023"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      1,
      0
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    begin
      assert(is_text_present($display_scm["success_message"]))
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    ScmConfig.destroy_all
  end
  # input a right revision number.
  #
  def test_scm_st_024
    printf "\n Test 024"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      1,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      1,
      0
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    begin
      assert(is_text_present($display_scm["success_message"]))
      open "/devgroup/pj_index/1/1"
      wait_for_page_to_load LOAD_TIME
      @selenium.click $display_scm_xpath["menu_link"]
      sleep SLEEP_TIME
      @selenium.click $display_scm_xpath["scm_tab"]
      sleep SLEEP_TIME
      assert_equal "1",get_value($display_scm_xpath["revision_field"])
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    ScmConfig.destroy_all
  end
  #
  # Test master base name field
  #
  # Input nil to master base name
  #
  def test_scm_st_025
    printf "\n Test 025"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      nil,
      1,
      0
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    assert(is_text_present($display_scm["master_error"]))
    logout
  end
  # input a wrong base name.
  #
  def test_scm_st_026
    printf "\n Test 026"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      "wrong name",
      1,
      0
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    assert(is_text_present($display_scm["master_error"]))
    logout
  end
  # input a right master name.
  #
  def test_scm_st_027
    printf "\n Test 027"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      1,
      0
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    begin
      assert(is_text_present($display_scm["success_message"]))
      open "/devgroup/pj_index/1/1"
      wait_for_page_to_load LOAD_TIME
      @selenium.click $display_scm_xpath["menu_link"]
      sleep SLEEP_TIME
      @selenium.click $display_scm_xpath["scm_tab"]
      sleep SLEEP_TIME
      assert_equal MASTER_BASE_NAME_RIGHT_KEYWORD,get_value($display_scm_xpath["master_field"])
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    ScmConfig.destroy_all
  end
  #
  # Test analysis tool field
  #
  # 2 checkboxes are unchecked the first time
  #
  def test_scm_st_028
    printf "\n Test 028"
    open_periodical_analysis_setting_tab
    assert !is_checked($display_scm_xpath["qac"])
    assert !is_checked($display_scm_xpath["qacpp"])
    logout
  end
  # all setting are correct.
  # QAC and QAC++ are unchecked.
  # Click Save.
  #
  def test_scm_st_029
    printf "\n Test 029"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      0,
      0
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    assert(is_text_present($display_scm["analysis_error"]))
    logout
  end
  # QAC is checked.
  # Click "Save".
  # Access periodical tab the second time.
  #
  def test_scm_st_030
    printf "\n Test 030"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      1,
      0
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    begin
      assert(is_text_present($display_scm["success_message"]))
      open "/devgroup/pj_index/1/1"
      wait_for_page_to_load LOAD_TIME
      @selenium.click $display_scm_xpath["menu_link"]
      sleep SLEEP_TIME
      @selenium.click $display_scm_xpath["scm_tab"]
      sleep SLEEP_TIME
      assert is_checked($display_scm_xpath["qac"])
      assert !is_checked($display_scm_xpath["qacpp"])
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    ScmConfig.destroy_all
  end
  # QAC++ is checked.
  # Click "Save".
  # Access periodical tab the second time.
  #
  def test_scm_st_031
    printf "\n Test 031"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      0,
      1
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    begin
      assert(is_text_present($display_scm["success_message"]))
      open "/devgroup/pj_index/1/1"
      wait_for_page_to_load LOAD_TIME
      @selenium.click $display_scm_xpath["menu_link"]
      sleep SLEEP_TIME
      @selenium.click $display_scm_xpath["scm_tab"]
      sleep SLEEP_TIME
      assert !is_checked($display_scm_xpath["qac"])
      assert is_checked($display_scm_xpath["qacpp"])
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    ScmConfig.destroy_all
  end
  # QAC and QAC++ are checked.
  # Click "Save".
  # Access periodical tab the second time.
  #
  def test_scm_st_032
    printf "\n Test 032"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      1,
      1
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    begin
      assert(is_text_present($display_scm["success_message"]))
      open "/devgroup/pj_index/1/1"
      wait_for_page_to_load LOAD_TIME
      @selenium.click $display_scm_xpath["menu_link"]
      sleep SLEEP_TIME
      @selenium.click $display_scm_xpath["scm_tab"]
      sleep SLEEP_TIME
      assert is_checked($display_scm_xpath["qac"])
      assert is_checked($display_scm_xpath["qacpp"])
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    ScmConfig.destroy_all
  end
  #
  # Test interval field
  #
  # Input a nil interval.
  #
  def test_scm_st_033
    printf "\n Test 033"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      1,
      0,
      " "
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    assert(is_text_present($display_scm["interval_error"]))
    logout
  end
  # Input a wrong interval.
  #
  def test_scm_st_034
    printf "\n Test 034"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      1,
      0,
      "wrong interval"
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    assert(is_text_present($display_scm["interval_error"]))
    logout
  end
  # Save a right interval.
  # Access periodical tab the second time.
  #
  def test_scm_st_035
    printf "\n Test 035"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      1,
      0,
      RIGHT_INTERVAL
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    begin
      assert(is_text_present($display_scm["success_message"]))
      open "/devgroup/pj_index/1/1"
      wait_for_page_to_load LOAD_TIME
      @selenium.click $display_scm_xpath["menu_link"]
      sleep SLEEP_TIME
      @selenium.click $display_scm_xpath["scm_tab"]
      sleep SLEEP_TIME
      assert_equal RIGHT_INTERVAL,get_value($display_scm_xpath["interval_field"])
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    ScmConfig.destroy_all
  end
  #
  # Test upload preprocess file
  #
  # Those test are manually tested.
  #
  def test_scm_st_036
    printf "\n Test 036"
  end
  def test_scm_st_037
    printf "\n Test 037"
  end
  def test_scm_st_038
    printf "\n Test 038"
  end
  #
  # Test Save button
  #
  # All field are inputted successful.
  # Save button is clicked.
  #
  def test_scm_st_039
    printf "\n Test 039"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      1,
      1
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    begin
      assert(is_text_present($display_scm["success_message"]))
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    ScmConfig.destroy_all
  end
  # All field are blanked.
  # Save button is clicked.
  #
  def test_scm_st_040
    printf "\n Test 040"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      0,
      0
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    assert is_text_present($display_scm["url_error"])
    logout
  end
  # Save a right setting.
  # Open tab the second time.
  # Click Save button
  #
  def test_scm_st_041
    printf "\n Test 041"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      1,
      1
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    begin
      assert(is_text_present($display_scm["success_message"]))
      type($display_scm_xpath["password_field"], PASSWORD_RIGHT_KEYWORD)
      click $display_scm_xpath["save_button"]
      sleep SLEEP_TIME
      assert(is_text_present($display_scm["update_message"]))
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    ScmConfig.destroy_all
  end
  #
  # Test Clear button
  #
  # A setting was saved.
  # Change some field.
  # Click Clear button
  #
  def test_scm_st_042
    printf "\n Test 042"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      1,
      1
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    begin
      assert(is_text_present($display_scm["success_message"]))
      type($display_scm_xpath["user_field"], "sample")
      type($display_scm_xpath["url_field"], "sample")
      click $display_scm_xpath["clear_button"]
      sleep SLEEP_TIME
      assert_equal LOGIN_RIGHT_KEYWORD, get_value($display_scm_xpath["user_field"])
      assert_equal URL_SVN_RIGHT_KEYWORD, get_value($display_scm_xpath["url_field"])
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    ScmConfig.destroy_all
  end
  # No setting was saved.
  # Change some field.
  # Click Clear button
  #
  def test_scm_st_043
    printf "\n Test 043"
    open_periodical_analysis_setting_tab
    type($display_scm_xpath["user_field"], "sample")
    type($display_scm_xpath["url_field"], "sample")
    click $display_scm_xpath["clear_button"]
    sleep SLEEP_TIME
    assert_equal "", get_value($display_scm_xpath["user_field"])
    assert_equal "", get_value($display_scm_xpath["url_field"])
    logout
  end
  #
  # Test Save All Setting button
  #
  # All field are inputted successful.
  # Save All Setting button is clicked.
  #
  def test_scm_st_044
    printf "\n Test 044"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      1,
      1
    )
    click $display_scm_xpath["save_all_button"]
    sleep SLEEP_TIME
    begin
      assert(is_text_present($display_scm["save_all_success"]))
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    ScmConfig.destroy_all
  end
  # Some incorrect field are inputted.
  # Save All Setting button is clicked.
  #
  def test_scm_st_045
    printf "\n Test 045"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      "wrong",
      "wrong",
      nil,
      nil,
      nil,
      nil,
      0,
      0
    )
    click $display_scm_xpath["save_all_button"]
    sleep SLEEP_TIME
    assert is_text_present($display_scm["url_error"])
    logout
  end
  # Nothing changed in periodical tab.
  # Save All Setting button is clicked.
  #
  def test_scm_st_046
    printf "\n Test 046"
    open_periodical_analysis_setting_tab
    click $display_scm_xpath["save_all_button"]
    sleep SLEEP_TIME
    assert is_text_present($display_scm["save_all_success"])
    logout
  end
  #
  # Test Delete button
  #
  # A setting was saved.
  # Click Delete button.
  #
  def test_scm_st_047
    printf "\n Test 047"
    open_periodical_analysis_setting_tab
    fill_scm_form("SVN",
      nil,
      nil,
      URL_SVN_RIGHT_KEYWORD,
      LOGIN_RIGHT_KEYWORD,
      PASSWORD_RIGHT_KEYWORD,
      nil,
      MASTER_BASE_NAME_RIGHT_KEYWORD,
      1,
      1
    )
    click $display_scm_xpath["save_button"]
    sleep SLEEP_TIME
    choose_ok_on_next_confirmation
    click $display_scm_xpath["delete_button"]
    sleep SLEEP_TIME
    assert @selenium.get_confirmation()
    assert is_text_present($display_scm["success_delete"])
    logout
  end
  # No setting was saved.
  # Click Delete button.
  #
  def test_scm_st_048
    printf "\n Test 048"
    open_periodical_analysis_setting_tab
    choose_ok_on_next_confirmation
    click $display_scm_xpath["delete_button"]
    sleep SLEEP_TIME
    assert @selenium.get_confirmation()
    assert is_text_present($display_scm["error_delete"])
    logout
  end
end
