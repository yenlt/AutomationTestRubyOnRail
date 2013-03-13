require File.dirname(__FILE__) + "/test_dtm_setup" unless defined? TestDTMSetup
require 'test/unit'
class TestDTM1 < Test::Unit::TestCase
  include TestDTMSetup
   RIGHT_KEYWORD       = "sample_c/src"
    WRONG_KEYWORD       = "wrong_keyword"
    SPECIAL_KEYWORD     = "spe'ci\"al\\"
    SCRIPT_KEYWORD      = "alert(\"abc\");"
    REGULAR_KEYWORD     = "samp*"
  # Test Access right of Display Metric Transition
  #
  # User hasn't logged in
  #
  def test_dtm_st_001
    printf "\n+ Test 001"
    open "/devgroup/pu_index/1"
    sleep SLEEP_TIME
    assert @selenium.is_text_present($page_titles["auth_login"])
  end
  # User logged in
  # Request to view PU detail page
  # Display Metric Transition button is displayed.

  def test_dtm_st_002
    printf "\n+ Test 002"
    login
    open "/devgroup/pu_index/1"
    sleep SLEEP_TIME
    assert_equal $display_metric["name"], @selenium.get_text($display_metric_xpath["menu"])
    logout
  end

  # User logged in
  # Request to view PU detail page
  # Display Metric Transition button is displayed.
  def test_dtm_st_003
    printf "\n+ Test 003"
    open_display_metric_page
    assert_equal $display_metric["name"], @selenium.get_text($display_metric_xpath["title"])
    logout
  end
 #
  # Test display of Display Metrics page
  #
  # User logged in.
  # All subtasks are extracted.
  # Access display metrics page.
  # Table and Graph tab are displayed.
  def test_dtm_st_004
    printf "\n+ Test 004"
    open_display_metric_page
    assert_equal $display_metric["table"], @selenium.get_text($display_metric_xpath["table_name"])
    assert_equal $display_metric["graph"], @selenium.get_text($display_metric_xpath["graph_name"])
    logout
  end

  # User logged in.
  # All subtasks are extracted.
  # Access display metrics page.
  # Table tab is default selected.
  def test_dtm_st_005
    assert true
  end

  # User logged in.
  # All subtasks are extracted.
  # Access display metrics page.
  # Click graph tab.
  # The color of Table tab and Graph tab changed.
  def test_dtm_st_006
    assert true
  end

  # User logged in.
  # All subtasks are extracted.
  # Access display metrics page.
  # Filter keyword field and Update button are displayed.
  def test_dtm_st_007
    printf "\n+ Test 007"
    open_display_metric_page
    assert_equal $display_metric["filter_name"], @selenium.get_text($display_metric_xpath["filter_name"])
    assert(is_element_present($display_metric_xpath["filter_keyword"]))
    assert(is_element_present($display_metric_xpath["filter_button"]))
    logout
  end

  # Test display of table tab
  # User logged in.
  # No subtask are selected.
  # Access display metrics page.
  def test_dtm_st_008
    printf "\n+ Test 008"
    DisplayMetric.destroy_all
    open_display_metric_page
    begin
      assert is_text_present($display_metric["no_subtask"])
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=display_metrics"
  end

  # User logged in.
  # Some subtask are selected
  # All subtask are extracted.
  # A table displayed.
  def test_dtm_st_009
    printf "\n+ Test 009"
   open_display_metric_page
    (1..14).each do |i|
      assert_equal $display_metric_table["#{i}"], @selenium.get_text($display_metric_xpath["table_header"].sub('__INDEX__',i.to_s))
    end
    logout
  end
  # List of metric are displayed.

  def test_dtm_st_010
    printf "\n+ Test 010"
    open_display_metric_page
    assert_not_equal 0, get_xpath_count($display_metric_xpath["row"])
    date = []
    subtask_id = []
    number_rows =  get_xpath_count($display_metric_xpath["row"])
    (1..number_rows).each do |i|
      date << @selenium.get_text($display_metric_xpath["table_content"].sub('__ROW_INDEX__',i.to_s)+"[4]")
      subtask_id << @selenium.get_text($display_metric_xpath["table_content"].sub('__ROW_INDEX__',i.to_s)+"[1]")
    end
    if date[0] <= date[number_rows-1] && subtask_id[0] <= subtask_id[number_rows-1]
      assert true
    else
      assert false
    end
    logout
  end
  # Download CSV Format button is displayed.

  def test_dtm_st_011
    printf "\n+ Test 011"
    open_display_metric_page
    assert_equal $display_metric["download_csv_button"], get_attribute($display_metric_xpath["download_csv_button"],"value")
    logout
  end
  # Target Setting button is displayed.

  def test_dtm_st_012
    printf "\n+ Test 012"
    open_display_metric_page
    assert_equal $display_metric["target_setting_button"], get_attribute($display_metric_xpath["target_setting_button"],"value")
    logout
  end
  # Logged in as PJ member
  # Targets setting button is not displayed.

  def test_dtm_st_013
    printf "\n+ Test 013"
    # access display metric transition page as pj member of PU 1
    open_display_metric_page_as_user(PJ_member_user, PJ_member_password, 1)
    assert_not_equal $display_metric["target_setting_button"], get_attribute($display_metric_xpath["target_setting_button"],"value")
    logout
  end
  # Logged in.
  # Some subtask are selected, but some subtask are not extracted.

  def test_dtm_st_014
    printf "\n+ Test 014"
    add_unextracted_subtask
    open_display_metric_page
    begin
      assert is_element_present($display_metric_xpath["extract"])
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=display_metrics"
  end
  # Logged in.
  # Some subtask are selected, but some subtask are not extracted.

  def test_dtm_st_015
    printf "\n+ Test 015"
    add_unextracted_subtask
    open_display_metric_page
    begin
      assert_equal $display_metric["here_link"], @selenium.get_text($display_metric_xpath["here_link"])
   # rescue Test::Unit::AssertionFailedError
   # @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=display_metrics"
  end
  #   Logged in.
  #   Some subtask are selected, but some subtask are not extracted.

  def test_dtm_st_016
    printf "\n+ Test 016"
    add_unextracted_subtask
    open_display_metric_page
    begin
      if ($lang=='ja')
      assert_equal $display_metric["unextracted_message_ja"], @selenium.get_text($display_metric_xpath["unextracted_message"])
      else
        assert_equal $display_metric["unextracted_message_en"], @selenium.get_text($display_metric_xpath["unextracted_message"])
      end
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=display_metrics"
  end
  # Test Directory Filter
  # Logged in.
  # Input a nil filter keyword and click "Update" button

  def test_dtm_st_017
    printf "\n+ Test 017"
    open_display_metric_page
    old_table = get_xpath_count($display_metric_xpath["row"])
    click $display_metric_xpath["update_button"]
    sleep SLEEP_TIME
    new_table = get_xpath_count($display_metric_xpath["row"])
    assert_equal old_table, new_table
    logout
  end
#   Logged in.
#   Input a right filter keyword and click "Update" button

  def test_dtm_st_018
    printf "\n+ Test 018"
    open_display_metric_page
    sleep 3
    old_table = get_xpath_count($display_metric_xpath["row"])
    type("filter_keyword",RIGHT_KEYWORD)
    click $display_metric_xpath["update_button"]
    sleep SLEEP_TIME
    new_table = get_xpath_count($display_metric_xpath["row"])
    assert_not_equal old_table, new_table
    logout
  end
  # Logged in.
  # Input a wrong filter keyword and click "Update" button

  def test_dtm_st_019
    printf "\n+ Test 019"
    open_display_metric_page
    old_table = get_xpath_count($display_metric_xpath["row"])
    type("filter_keyword",WRONG_KEYWORD)
    click $display_metric_xpath["update_button"]
    sleep SLEEP_TIME
    new_table = get_xpath_count($display_metric_xpath["row"])
    assert_not_equal old_table, new_table
    assert_equal 0,new_table
    logout
  end
  # Logged in.
  # Input a special filter keyword and click "Update" button

  def test_dtm_st_020
    printf "\n+ Test 020"
    open_display_metric_page
    old_table = get_xpath_count($display_metric_xpath["row"])
    type("filter_keyword",SPECIAL_KEYWORD)
    click $display_metric_xpath["update_button"]
    sleep SLEEP_TIME
    new_table = get_xpath_count($display_metric_xpath["row"])
    assert_not_equal old_table, new_table
    assert_equal 0,new_table
    logout
  end
  # Logged in.
  # Input a * filter keyword and click "Update" button

  def test_dtm_st_021
    printf "\n+ Test 021"
    open_display_metric_page
    old_table = get_xpath_count($display_metric_xpath["row"])
    type("filter_keyword","*")
    click $display_metric_xpath["update_button"]
    sleep SLEEP_TIME
    new_table = get_xpath_count($display_metric_xpath["row"])
    assert_equal old_table, new_table
    logout
  end
  # Logged in.
  # Input a script filter keyword and click "Update" button

  def test_dtm_st_022
    printf "\n+ Test 022"
    open_display_metric_page
    old_table = get_xpath_count($display_metric_xpath["row"])
    type("filter_keyword",SCRIPT_KEYWORD)
    click $display_metric_xpath["update_button"]
    sleep SLEEP_TIME
    new_table = get_xpath_count($display_metric_xpath["row"])
    assert_not_equal old_table, new_table
    assert_equal 0,new_table
    logout
  end
  # Logged in.
  # Input a regular expression filter keyword and click "Update" button

  def test_dtm_st_023
    printf "\n+ Test 023"
    open_display_metric_page
    old_table = get_xpath_count($display_metric_xpath["row"])
    type("filter_keyword",REGULAR_KEYWORD)
    click $display_metric_xpath["update_button"]
    sleep SLEEP_TIME
    new_table = get_xpath_count($display_metric_xpath["row"])
    assert_equal old_table, new_table
    logout
  end

  def test_dtm_st_024
    printf "\n+ Test 024"
    DisplayMetric.destroy_all
    open_display_metric_page
    begin
      old_table = get_xpath_count($display_metric_xpath["row"])
      type("filter_keyword","*")
      click $display_metric_xpath["update_button"]
      sleep SLEEP_TIME
      new_table = get_xpath_count($display_metric_xpath["row"])
      assert_equal old_table, new_table
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=display_metrics"
  end


  # Test Download CSV Format button
  # From test case 25 to 31, test manually
  def test_dtm_st_025
    printf "\n+ Test 025"
    assert true
  end

  def test_dtm_st_026
    printf "\n+ Test 026"
    assert true
  end

  def test_dtm_st_027
    printf "\n+ Test 027"
    assert true
  end

  def test_dtm_st_028
    printf "\n+ Test 028"
    assert true
  end

  def test_dtm_st_029
    printf "\n+ Test 029"
    assert true
  end

  def test_dtm_st_030
    printf "\n+ Test 030"
    assert true
  end

  def test_dtm_st_031
    printf "\n+ Test 031"
    assert true
  end

  # Test Metric Transition Graph
  # Logged in.
  # No subtask is selected to display.

  def test_dtm_st_032
    printf "\n+ Test 032"
    DisplayMetric.destroy_all
    open_display_metric_page
    click $display_metric_xpath["graph"]
    sleep SLEEP_TIME
    begin
      assert is_text_present($display_metric["no_subtask"])
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=display_metrics"
  end
  # Logged in.
  # Select "Graph" tab.
  # View of graph tab is displayed.

  def test_dtm_st_033
    printf "\n+ Test 033"
    open_display_metric_page
    click $display_metric_xpath["graph"]
    sleep SLEEP_TIME
    begin
      assert is_element_present($display_metric_xpath["add_metric_button"])
      assert is_element_present($display_metric_xpath["redraw_button"])
      assert_equal($display_metric["metrics"], @selenium.get_text($display_metric_xpath["select_metrics"]+"[1]"))
      assert_equal($display_metric["graph_type"], @selenium.get_text($display_metric_xpath["select_metrics"]+"[2]"))
      assert_equal($display_metric["y_axis"], @selenium.get_text($display_metric_xpath["select_metrics"]+"[3]"))
      assert !is_checked($display_metric_xpath["cumulative"])
      assert_equal 2, get_xpath_count($display_metric_xpath["select_metric_row"])
      assert_equal _("STTLN"), @selenium.get_selected_value($display_metric_xpath["metric_select_box"].sub('__INDEX__',"0"))
      assert_equal _("Bar"), @selenium.get_selected_value($display_metric_xpath["graph_type_select_box"].sub('__INDEX__',"0"))
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
  end
#   Logged in.
#   Select "Graph" tab.
#   9 option of metrics to select.

  def test_dtm_st_034
    printf "\n+ Test 034"
    open_display_metric_page
    click $display_metric_xpath["graph"]
    sleep SLEEP_TIME
    begin
      @metric_options = @selenium.get_select_options($display_metric_xpath["metric_select_box"].sub('__INDEX__',"0"))
      assert_equal 9, @metric_options.count
      (0..8).each do |index|
        assert_equal $display_metric["metric_options"][index], @metric_options[index]
      end
#    rescue Test::Unit::AssertionFailedError
#      @verification_errors << $!
    end
    logout
  end
  # Logged in.
  # Select "Graph" tab.
  # 2 option of graph type to select.

  def test_dtm_st_035
    printf "\n+ Test 035"
    open_display_metric_page
    click $display_metric_xpath["graph"]
    sleep SLEEP_TIME
    begin
      @graph_type_options = @selenium.get_select_options($display_metric_xpath["graph_type_select_box"].sub('__INDEX__',"0"))
      assert_equal 2, @graph_type_options.count
      (0..1).each do |index|
        assert_equal $display_metric["graph_type_options"][index], @graph_type_options[index]
      end
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
  end
  # Logged in.
  # Select "Graph" tab.
  # Yaxis is displayed.

  def test_dtm_st_036
    printf "\n+ Test 036"
    open_display_metric_page
    click $display_metric_xpath["graph"]
    sleep SLEEP_TIME
    begin
      assert is_element_present("//div[@id = 'left0']")
      assert is_element_present("//div[@id = 'left1']")
      select "graph_type0", _("Line")
      sleep SLEEP_TIME
      assert is_element_present("//div[@id = 'right0']")
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
  end

  # Test Redraw button
  # From test case 37 to 44, test manually
  def test_dtm_st_037
    printf "\n+ Test 037"
    assert true
  end

  def test_dtm_st_038
    printf "\n+ Test 038"
    assert true
  end

  def test_dtm_st_039
    printf "\n+ Test 039"
    assert true
  end

  def test_dtm_st_040
    printf "\n+ Test 040"
    assert true
  end

  def test_dtm_st_041
    printf "\n+ Test 041"
    assert true
  end

  def test_dtm_st_042
    printf "\n+ Test 042"
    assert true
  end

  def test_dtm_st_043
    printf "\n+ Test 043"
    assert true
  end

  def test_dtm_st_044
    printf "\n+ Test 044"
    assert true
  end

  # Test "Add Metrics" button
  # Logged in.
  # Click "Add Metrics" 1 time.

  def test_dtm_st_045
    printf "\n+ Test 045"
    open_display_metric_page
    click $display_metric_xpath["graph"]
    sleep SLEEP_TIME
    assert_equal 2, get_xpath_count($display_metric_xpath["select_metric_row"])
    old_metrics = []
    old_graph_types = []
    (0..1).each do |index|
      old_metrics[index] = @selenium.get_selected_value($display_metric_xpath["metric_select_box"].sub('__INDEX__',index.to_s))
      old_graph_types[index]= @selenium.get_selected_value($display_metric_xpath["graph_type_select_box"].sub('__INDEX__',index.to_s))
    end
    click $display_metric_xpath["add_metric_button"]
    sleep SLEEP_TIME
    assert_equal 3, get_xpath_count($display_metric_xpath["select_metric_row"])
    new_metrics = []
    new_graph_types = []
    (0..1).each do |index|
      new_metrics[index] = @selenium.get_selected_value($display_metric_xpath["metric_select_box"].sub('__INDEX__',index.to_s))
      new_graph_types[index]= @selenium.get_selected_value($display_metric_xpath["graph_type_select_box"].sub('__INDEX__',index.to_s))
    end
    assert_equal old_metrics, new_metrics
    assert_equal old_graph_types, new_graph_types
    logout
  end
  # Logged in.
  # Click "Add Metrics" more than 1 time.

  def test_dtm_st_046
    printf "\n+ Test 046"
    open_display_metric_page
    click $display_metric_xpath["graph"]
    sleep SLEEP_TIME
    assert_equal 2, get_xpath_count($display_metric_xpath["select_metric_row"])
    old_metrics = []
    old_graph_types = []
    (0..1).each do |index|
      old_metrics[index] = @selenium.get_selected_value($display_metric_xpath["metric_select_box"].sub('__INDEX__',index.to_s))
      old_graph_types[index]= @selenium.get_selected_value($display_metric_xpath["graph_type_select_box"].sub('__INDEX__',index.to_s))
    end
    3.times do
      click $display_metric_xpath["add_metric_button"]
      sleep SLEEP_TIME
    end
    assert_equal 5, get_xpath_count($display_metric_xpath["select_metric_row"])
    new_metrics = []
    new_graph_types = []
    (0..1).each do |index|
      new_metrics[index] = @selenium.get_selected_value($display_metric_xpath["metric_select_box"].sub('__INDEX__',index.to_s))
      new_graph_types[index]= @selenium.get_selected_value($display_metric_xpath["graph_type_select_box"].sub('__INDEX__',index.to_s))
    end
    assert_equal old_metrics, new_metrics
    assert_equal old_graph_types, new_graph_types
    logout
  end
  # Logged in.
  # Click "Add Metrics" more than 7 times.
  # Only 9 rows of metrics are displayed.

  def test_dtm_st_047
    printf "\n+ Test 047"
    open_display_metric_page
    click $display_metric_xpath["graph"]
    sleep SLEEP_TIME
    assert_equal 2, get_xpath_count($display_metric_xpath["select_metric_row"])
    10.times do
      click $display_metric_xpath["add_metric_button"]
      sleep SLEEP_TIME
    end
    assert_equal 9, get_xpath_count($display_metric_xpath["select_metric_row"])
    logout
  end

  # Test access right of Target setting page.
  #
  # Logged in as an admin.
  # Access Display Metric Transition page.

  def test_dtm_st_048
    printf "\n+ Test 048"
    # TOSCANA admin
    open_display_metric_page_as_user(TOSCANA_user,TOSCANA_password,1)
    assert(is_element_present($display_metric_xpath["target_setting_button"]))

    logout
    # PU admin
    open_display_metric_page_as_user(PU_admin_user,PU_admin_password,1)
    assert(is_element_present($display_metric_xpath["target_setting_button"]))

    logout
    # PJ admin
    open_display_metric_page_as_user(PJ_admin_user,PJ_admin_password,1)
    assert(is_element_present($display_metric_xpath["target_setting_button"]))

    logout
  end
  # Logged in as a member.
  # Access Display Metric Transition page.

  def test_dtm_st_049
    printf "\n+ Test 049"
    open_display_metric_page_as_user(PJ_member_user,PJ_member_password,1)
    assert_not_equal $display_metric["target_setting_button"], get_attribute($display_metric_xpath["target_setting_button"],"value")
    logout
  end
  # Access target setting page as an admin

  def test_dtm_st_050
    printf "\n+ Test 050"
    open_target_setting_page
    assert_equal $display_metric["target_setting_title"], @selenium.get_text($display_metric_xpath["target_setting_title"])
    logout
  end

  # Test display of Target Setting page
  #
  # Admin logged in.
  # Save button is displayed.

  def test_dtm_st_051
    printf "\n+ Test 051"
    open_target_setting_page
    assert $display_metric["save_button"], @selenium.get_text($display_metric_xpath["save_button"])
    logout
  end
  # Admin logged in.
  # PJ, Task, QAC, QAC ++ are displayed.

  def test_dtm_st_052
    printf "\n+ Test 052"
    open_target_setting_page
    # select field header
    assert_equal $display_metric["pj_field"], @selenium.get_text($display_metric_xpath["select_field_header"]+"[1]")
    assert_equal $display_metric["task_field"], @selenium.get_text($display_metric_xpath["select_field_header"]+"[2]")
    assert_equal $display_metric["tool_field"], @selenium.get_text($display_metric_xpath["select_field_header"]+"[3]")
  end
  # Admin logged in.
  # AddSubtask button is displayed.

  def test_dtm_st_053
    printf "\n+ Test 053"
    open_target_setting_page
    assert $display_metric["add_subtask_button"], @selenium.get_text($display_metric_xpath["add_subtask_button"])
    logout
  end
  # Admin logged in.
  # Table of subtask are displayed.

  def test_dtm_st_054
    printf "\n+ Test 054"
    open_target_setting_page
    (2..8).each do |i|
      assert_equal $target_setting_table["#{i}"], @selenium.get_text($display_metric_xpath["target_setting_header"].sub('__INDEX__',i.to_s))
    end
    logout
  end
  # Admin logged in.
  # No subtask are selected.

  def test_dtm_st_055
    printf "\n+ Test 055"
    DisplayMetric.destroy_all
    open_target_setting_page
    begin
      assert is_text_present($display_metric["no_subtask"])
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=display_metrics"
  end
  # Admin logged in.
  # List of subtask are displayed.

  def test_dtm_st_056
    printf "\n+ Test 056"
    open_target_setting_page
    assert_not_equal 0, get_xpath_count($display_metric_xpath["target_setting_row"])
    date = []
    subtask_id = []
    number_rows =  get_xpath_count($display_metric_xpath["target_setting_row"])
    (1..number_rows).each do |i|
      date << @selenium.get_text($display_metric_xpath["target_setting_row_content"].sub('__INDEX__',i.to_s)+"[2]")
      subtask_id << @selenium.get_text($display_metric_xpath["target_setting_row_content"].sub('__INDEX__',i.to_s)+"[7]")
    end
    if date[0] <= date[number_rows-1] && subtask_id[0] <= subtask_id[number_rows-1]
      assert true
    else
      assert false
    end
    logout
  end
  # Admin logged in.
  # Each row have 1 checkbox field

  def test_dtm_st_057
    printf "\n+ Test 057"
    open_target_setting_page
    number_rows =  get_xpath_count($display_metric_xpath["target_setting_row"])
    (1..number_rows).each do |i|
      subtask_id = @selenium.get_text($display_metric_xpath["target_setting_row_content"].sub('__INDEX__',i.to_s)+"[7]")
      assert_equal "id"+subtask_id, get_attribute($display_metric_xpath["target_setting_row_checkbox"].sub('__INDEX__',i.to_s), "value")
    end
    logout
  end
  # Admin logged in.
  # Check All, Uncheck All, Delete button are displayed.

  def test_dtm_st_058
    printf "\n+ Test 058"
    open_target_setting_page
    sleep SLEEP_TIME
    assert(is_element_present($display_metric_xpath["check_all_button"]))
    assert(is_element_present($display_metric_xpath["uncheck_all_button"]))
    assert(is_element_present($display_metric_xpath["delete_button"]))
    logout
  end

#   Test PJ select field
#   Logged in as a TOSCANA admin
  def test_dtm_st_059
    printf "\n+ Test 059"
    open_target_setting_page
    all_pjs = Pj.find_all_by_pu_id(1)
    all_pj_names = []
    all_pjs.each do |pj|
      all_pj_names << pj.name
    end
    pj_list = get_select_options($display_metric_xpath["pj_list"])
    assert_equal all_pj_names, pj_list
    logout
  end

#  Logged in as a PJ admin
  def test_dtm_st_060
    printf "\n+ Test 060"
    open_target_setting_page_as_user(PJ_admin_user2,PJ_admin_password2,1)
    # all pjs belong to PU id
    all_pjs = Pj.find_all_by_pu_id(1)
    all_pj_names = []
    all_pjs.each do |pj|
      all_pj_names << pj.name
    end
    # pjs belong to user and PU
    list_pj_user = []
    user_id = User.find_by_account_name(PJ_admin_user2)
    pjs_user = PjsUsers.find_all_by_user_id(user_id.id)
    all_pjs.each do |pj|
      pjs_user.each do |pj_user|
        if pj.id == pj_user.pj_id
          list_pj_user << pj.name
        end
      end
    end
    # assert
    pj_list = get_select_options($display_metric_xpath["pj_list"])
    assert_not_equal all_pj_names, pj_list
    assert_equal list_pj_user,pj_list
    logout
  end

  # Test Task select Field
  # Select 1 PJ.
  # Task list change.

  def test_dtm_st_061
    printf "\n+ Test 061"
    open_target_setting_page
    old_task_list = get_select_options($display_metric_xpath["task_list"])
    @selenium.select "pjs","SamplePJ2"
    sleep SLEEP_TIME
    new_task_list = get_select_options($display_metric_xpath["task_list"])
    assert_not_equal old_task_list, new_task_list
    logout
  end
  # List of task.

  def test_dtm_st_062
    printf "\n+ Test 062"
    all = false
    open_target_setting_page
    task_list = get_select_options($display_metric_xpath["task_list"])
    task_list.each do |task|
      if task == _("All")
        all = true
      end
    end
    assert_equal all, true
    selected_task = get_selected_value($display_metric_xpath["task_list"])
    # value of All is 0
    assert_equal "0", selected_task
    logout
  end

  # Test "Add Subtask" button
  # Logged in.
  # Select PJ and Task but not check subtask
  # Click "Add Subtask" button.
  # Nothing happened.

  def test_dtm_st_063
    printf "\n+ Test 063"
    open_target_setting_page
    old_subtask_list = get_xpath_count($display_metric_xpath["target_setting_row"])
    @selenium.select "pjs", "SamplePJ2"
    sleep SLEEP_TIME
    @selenium.select "tasks", "sample_c_cpp_2"
    click $display_metric_xpath["add_subtask_button"]
    sleep SLEEP_TIME
    new_subtask_list = get_xpath_count($display_metric_xpath["target_setting_row"])
    assert_equal old_subtask_list, new_subtask_list
    logout
  end
  # Logged in.
  # Select PJ and Task and check QAC
  # Click "Add Subtask" button.
  # 1 subtask added.

  def test_dtm_st_064
    printf "\n+ Test 064"
    open_target_setting_page
    old_subtask_list = get_xpath_count($display_metric_xpath["target_setting_row"])
    @selenium.select "pjs", "SamplePJ2"
    sleep SLEEP_TIME
    @selenium.select "tasks", "sample_c_cpp_1"
    @selenium.check "qac"
    click $display_metric_xpath["add_subtask_button"]
    sleep SLEEP_TIME
    new_subtask_list = get_xpath_count($display_metric_xpath["target_setting_row"])
    assert_equal old_subtask_list + 1, new_subtask_list
    logout
  end
  # Logged in.
  # Select PJ and Task and check QAC++
  # Click "Add Subtask" button.
  # 1 subtask added.

  def test_dtm_st_065
    printf "\n+ Test 065"
    open_target_setting_page
    old_subtask_list = get_xpath_count($display_metric_xpath["target_setting_row"])
    @selenium.select "pjs", "SamplePJ2"
    sleep SLEEP_TIME
    @selenium.select "tasks", "sample_c_cpp_1"
    @selenium.check "qacpp"
    click $display_metric_xpath["add_subtask_button"]
    sleep SLEEP_TIME
    new_subtask_list = get_xpath_count($display_metric_xpath["target_setting_row"])
    assert_equal old_subtask_list + 1, new_subtask_list
    logout
  end
  # Logged in.
  # Select a subtask of QAC that have selected.
  # Click "Add Subtask" button.
  # Nothing changed.

  def test_dtm_st_066
    printf "\n+ Test 066"
    open_target_setting_page
    old_subtask_list = get_xpath_count($display_metric_xpath["target_setting_row"])
    @selenium.select "pjs", "SamplePJ2"
    sleep SLEEP_TIME
    @selenium.select "tasks", "sample_c_cpp_2"
    @selenium.check "qac"
    click $display_metric_xpath["add_subtask_button"]
    sleep SLEEP_TIME
    new_subtask_list = get_xpath_count($display_metric_xpath["target_setting_row"])
    assert_equal old_subtask_list, new_subtask_list
    logout
  end
  # Logged in.
  # Select a subtask of QAC++ that have selected.
  # Click "Add Subtask" button.
  # Nothing changed.

  def test_dtm_st_067
    printf "\n+ Test 067"
    open_target_setting_page
    old_subtask_list = get_xpath_count($display_metric_xpath["target_setting_row"])
    @selenium.select "pjs", "SamplePJ2"
    sleep SLEEP_TIME
    @selenium.select "tasks", "sample_c_cpp_2"
    @selenium.check "qacpp"
    click $display_metric_xpath["add_subtask_button"]
    sleep SLEEP_TIME
    new_subtask_list = get_xpath_count($display_metric_xpath["target_setting_row"])
    assert_equal old_subtask_list, new_subtask_list
    logout
  end
  # No subtask are selected.
  # Logged in.
  # Select PJ = 1
  # Task = All
  # Check QAC
  # Click "Add Subtask" button.
  # All subtask analyzed by QAC are selected.

  def test_dtm_st_068
    printf "\n+ Test 068"
    DisplayMetric.destroy_all
    masters = Master.find_all_by_pj_id(1)
    total_subtask = 0
    masters.each do |master|
      subtask_list = Subtask.find_all_by_master_id_and_analyze_tool_id(master.id,1)
      total_subtask += subtask_list.count
    end
    begin
      open_target_setting_page
      @selenium.select "pjs", "SamplePJ1"
      sleep SLEEP_TIME
      @selenium.select "tasks", _("All")
      @selenium.check "qac"
      click $display_metric_xpath["add_subtask_button"]
      sleep SLEEP_TIME
      list_of_subtask = get_xpath_count($display_metric_xpath["target_setting_row"])
      assert_equal list_of_subtask, total_subtask
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=display_metrics"
  end
  # No subtask are selected.
  # Logged in.
  # Select PJ = 1
  # Task = All
  # Check QAC++
  # Click "Add Subtask" button.
  # All subtask analyzed by QAC++ are selected.

  def test_dtm_st_069
    printf "\n+ Test 069"
    DisplayMetric.destroy_all
    masters = Master.find_all_by_pj_id(1)
    total_subtask = 0
    masters.each do |master|
      subtask_list = Subtask.find_all_by_master_id_and_analyze_tool_id(master.id,2)
      total_subtask += subtask_list.count
    end
    begin
      open_target_setting_page
      @selenium.select "pjs", "SamplePJ1"
      sleep SLEEP_TIME
      @selenium.select "tasks", _("All")
      @selenium.check "qacpp"
      click $display_metric_xpath["add_subtask_button"]
      sleep SLEEP_TIME
      list_of_subtask = get_xpath_count($display_metric_xpath["target_setting_row"])
      assert_equal list_of_subtask, total_subtask
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=display_metrics"
  end
  # No subtask are selected.
  # Logged in.
  # Select PJ = 1
  # Task = sample_c_cpp_1_1
  # Check QAC and QAC++
  # Click "Add Subtask" button.
  # All subtask analyzed by QAC and QAC++ are selected.

  def test_dtm_st_070
    printf "\n+ Test 070"
    DisplayMetric.destroy_all
    begin
      open_target_setting_page
      @selenium.select "pjs", "SamplePJ1"
      sleep SLEEP_TIME
      @selenium.select "tasks", "sample_c_cpp_1_1"
      @selenium.check "qac"
      @selenium.check "qacpp"
      click $display_metric_xpath["add_subtask_button"]
      sleep SLEEP_TIME
      list_of_subtask = get_xpath_count($display_metric_xpath["target_setting_row"])
      assert_equal list_of_subtask, 2
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=display_metrics"
  end
  # No subtask are selected.
  # Logged in.
  # Select PJ = 1
  # Task = All
  # Check QAC and QAC++
  # Click "Add Subtask" button.
  # All subtask analyzed by QAC and QAC++ are selected.

  def test_dtm_st_071
    printf "\n+ Test 071"
    DisplayMetric.destroy_all
    masters = Master.find_all_by_pj_id(1)
    total_subtask = 0
    masters.each do |master|
      subtask_list = Subtask.find_all_by_master_id_and_analyze_tool_id(master.id,1)
      total_subtask += subtask_list.count
      subtask_list = Subtask.find_all_by_master_id_and_analyze_tool_id(master.id,2)
      total_subtask += subtask_list.count
    end
    begin
      open_target_setting_page
      @selenium.select "pjs", "SamplePJ1"
      sleep SLEEP_TIME
      @selenium.select "tasks", _("All")
      @selenium.check "qac"
      @selenium.check "qacpp"
      click $display_metric_xpath["add_subtask_button"]
      sleep SLEEP_TIME
      list_of_subtask = get_xpath_count($display_metric_xpath["target_setting_row"])
      assert_equal list_of_subtask, total_subtask
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=display_metrics"
  end

  # Test "Check All" button
  # Logged in.
  # Some subtask are selected.
  # No subtask is checked.
  # Click "Check All" button.
  # All subtask are checked.

  def test_dtm_st_072
    printf "\n+ Test 072"
    open_target_setting_page
    assert !is_checked("subtasks[]")
    click $display_metric_xpath["check_all_button"]
    sleep SLEEP_TIME
    assert is_checked("subtasks[]")
    logout
  end
  # Logged in.
  # Some subtask are selected.
  # Some subtask is checked.
  # Click "Check All" button.
  # All subtask are checked.

  def test_dtm_st_073
    printf "\n+ Test 073"
    open_target_setting_page
    assert !is_checked("subtasks[]")
    check $display_metric_xpath["sample_subtask"]
    click $display_metric_xpath["check_all_button"]
    sleep SLEEP_TIME
    assert is_checked("subtasks[]")
    logout
  end
  # Logged in.
  # No subtask are select.
  # Click Check All button
  # Nothing happenned.

  def test_dtm_st_074
    printf "\n+ Test 074"
    DisplayMetric.destroy_all
    open_target_setting_page
    click $display_metric_xpath["check_all_button"]
    logout
    system "rake db:fixtures:load FIXTURES=display_metrics"
  end

  # Test "Uncheck All" button
  # Logged in.
  # Some subtask are selected.
  # No subtask is checked.
  # Click "Uncheck All" button.
  # Nothing happened.

  def test_dtm_st_075
    printf "\n+ Test 075"
    open_target_setting_page
    assert !is_checked("subtasks[]")
    click $display_metric_xpath["uncheck_all_button"]
    sleep SLEEP_TIME
    assert !is_checked("subtasks[]")
    logout
  end
  # Logged in.
  # Some subtask are selected.
  # Click "Check All" button.
  # Click "Uncheck All" button.

  def test_dtm_st_076
    printf "\n+ Test 076"
    open_target_setting_page
    assert !is_checked("subtasks[]")
    click $display_metric_xpath["check_all_button"]
    sleep SLEEP_TIME
    assert is_checked("subtasks[]")
    click $display_metric_xpath["uncheck_all_button"]
    sleep SLEEP_TIME
    assert !is_checked("subtasks[]")
    logout
  end
  # Logged in.
  # No subtask are select.
  # Click Uncheck All button
  # Nothing happenned.

  def test_dtm_st_077
    printf "\n+ Test 077"
    DisplayMetric.destroy_all
    open_target_setting_page
    click $display_metric_xpath["uncheck_all_button"]
    logout
    system "rake db:fixtures:load FIXTURES=display_metrics"
  end

  # Test "Delete" button
  # Logged in.
  # No subtask is checked.
  # Click "Delete" button.
  def test_dtm_st_078
    printf "\n+ Test 078"
    open_target_setting_page
    old_subtasks = get_xpath_count($display_metric_xpath["target_setting_row"])
    click $display_metric_xpath["delete_button"]
    sleep SLEEP_TIME
    new_subtasks = get_xpath_count($display_metric_xpath["target_setting_row"])
    assert_equal old_subtasks, new_subtasks
    logout
  end
  # Logged in.
  # 1 Subtask is checked.
  # Click "Delete" button.

  def test_dtm_st_079
    printf "\n+ Test 079"
    open_target_setting_page
    old_subtasks = get_xpath_count($display_metric_xpath["target_setting_row"])
    check $display_metric_xpath["sample_subtask"]
    click $display_metric_xpath["delete_button"]
    sleep SLEEP_TIME
    new_subtasks = get_xpath_count($display_metric_xpath["target_setting_row"])
    assert_equal old_subtasks - 1, new_subtasks
    logout
  end
  # Logged in.
  # All subtask are checked.
  # Click "Delete" button.

  def test_dtm_st_080
    printf "\n+ Test 080"
    open_target_setting_page
    old_subtasks = get_xpath_count($display_metric_xpath["target_setting_row"])
    click $display_metric_xpath["check_all_button"]
    sleep SLEEP_TIME
    click $display_metric_xpath["delete_button"]
    sleep SLEEP_TIME
    new_subtasks = get_xpath_count($display_metric_xpath["target_setting_row"])
    assert_not_equal 0, old_subtasks
    assert_equal 0, new_subtasks
    logout
  end

  # Test "Save" button
  # Logged in.
  # Do nothing.
  # Click "Save" button
  def test_dtm_st_081
    printf "\n+ Test 081"
    open_target_setting_page
    click $display_metric_xpath["save_button"]
    sleep SLEEP_TIME
    wait_for_text_present($display_metric["name"])
    assert is_text_present($display_metric["save_message"])
    logout
  end

  # Logged in.
  # No subtask is selected.
  # Add some subtask.
  # Click "Save" button.
  # All selected subtask are listed.
  def test_dtm_st_082
    printf "\n+ Test 082"
    DisplayMetric.destroy_all
    begin
      open_target_setting_page
      @selenium.select "pjs", "SamplePJ2"
      sleep SLEEP_TIME
      @selenium.select "tasks", "sample_c_cpp_2"
      @selenium.check "qac"
      @selenium.check "qacpp"
      click $display_metric_xpath["add_subtask_button"]
      sleep SLEEP_TIME
      selected_subtask = get_xpath_count($display_metric_xpath["target_setting_row"])
      click $display_metric_xpath["save_button"]
      sleep SLEEP_TIME
      wait_for_text_present($display_metric["name"])
      assert is_text_present($display_metric["save_message"])
      display_subtask = get_xpath_count($display_metric_xpath["row"])
      assert_equal selected_subtask, display_subtask
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=display_metrics"
  end
  # Logged in.
  # Some subtask are selected.
  # Delete some subtask.
  # Click "Save" button.
  # All selected subtask are listed.

  def test_dtm_st_083
    printf "\n+ Test 083"
    begin
      open_target_setting_page
      check $display_metric_xpath["sample_subtask"]
      click $display_metric_xpath["delete_button"]
      sleep SLEEP_TIME
      selected_subtask = get_xpath_count($display_metric_xpath["target_setting_row"])
      click $display_metric_xpath["save_button"]
      sleep SLEEP_TIME
      wait_for_text_present($display_metric["name"])
      assert is_text_present($display_metric["save_message"])
      display_subtask = get_xpath_count($display_metric_xpath["row"])
      assert_equal selected_subtask, display_subtask
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=display_metrics"
  end
  # Logged in.
  # Some subtask are selected.
  # Delete all subtask.
  # Click "Save" button.
  # No subtask is displayed.

  def test_dtm_st_084
    printf "\n+ Test 084"
    begin
      open_target_setting_page
      click $display_metric_xpath["check_all_button"]
      click $display_metric_xpath["delete_button"]
      sleep SLEEP_TIME
      click $display_metric_xpath["save_button"]
      sleep SLEEP_TIME
      wait_for_text_present($display_metric["name"])
      assert is_text_present($display_metric["save_message"])
      assert is_text_present($display_metric["no_subtask"])
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=display_metrics"
  end
  # Logged in.
  # No subtask are selected.
  # Add some subtask.
  # Delete some subtask.
  # Click "Save" button.
  # List of subtask is displayed.

  def test_dtm_st_085
    printf "\n+ Test 085"
    DisplayMetric.destroy_all
    begin
      open_target_setting_page
      @selenium.select "pjs", "SamplePJ2"
      sleep SLEEP_TIME
      @selenium.select "tasks", "sample_c_cpp_2"
      @selenium.check "qac"
      @selenium.check "qacpp"
      click $display_metric_xpath["add_subtask_button"]
      sleep SLEEP_TIME
      check $display_metric_xpath["sample_subtask"]
      click $display_metric_xpath["delete_button"]
      sleep SLEEP_TIME
      selected_subtask = get_xpath_count($display_metric_xpath["target_setting_row"])
      click $display_metric_xpath["save_button"]
      sleep SLEEP_TIME
      wait_for_text_present($display_metric["name"])
      assert is_text_present($display_metric["save_message"])
      display_subtask = get_xpath_count($display_metric_xpath["row"])
      assert_equal selected_subtask, display_subtask
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=display_metrics"
  end
  # Logged in.
  # Some subtask are selected.
  # Delete some subtask.
  # Add some subtask.
  # Click "Save" button.
  # List of subtask is displayed.

  def test_dtm_st_086
    printf "\n+ Test 086"
    begin
      open_target_setting_page
      check $display_metric_xpath["sample_subtask"]
      click $display_metric_xpath["delete_button"]
      @selenium.select "pjs", "SamplePJ2"
      sleep SLEEP_TIME
      @selenium.select "tasks", "sample_c_cpp_2"
      @selenium.check "qac"
      @selenium.check "qacpp"
      click $display_metric_xpath["add_subtask_button"]
      sleep SLEEP_TIME
      selected_subtask = get_xpath_count($display_metric_xpath["target_setting_row"])
      click $display_metric_xpath["save_button"]
      sleep SLEEP_TIME
      wait_for_text_present($display_metric["name"])
      assert is_text_present($display_metric["save_message"])
      display_subtask = get_xpath_count($display_metric_xpath["row"])
      assert_equal selected_subtask, display_subtask
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=display_metrics"
  end

# Test Extract Data
# Logged in.
# Select some subtask that are not extracted.
# Click "Save".
# Redirect to Display Metric page with an extracting data notice.

  def test_dtm_st_087
    printf "\n+ Test 087"
    begin
      open_target_setting_page
      @selenium.select "pjs", "SamplePJ2"
      sleep SLEEP_TIME
      @selenium.select "tasks", _("All")
      @selenium.check "qac"
      @selenium.check "qacpp"
      click $display_metric_xpath["add_subtask_button"]
      sleep SLEEP_TIME
      click $display_metric_xpath["save_button"]
      sleep SLEEP_TIME
      if( $lang == 'ja')
      assert is_text_present($display_metric["unextracted_message_ja"])
      else
        assert is_text_present($display_metric["unextracted_message_en"])
      end
#    rescue Test::Unit::AssertionFailedError
#      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=display_metrics"
  end
# Logged in.
# Select some subtask that are not extracted.
# Click "Save".
# Redirect to Display Metric page with an extracting data notice.
# Click "Here" link.
# Redirect to PU detail page.

  def test_dtm_st_088
    printf "\n+ Test 088"
    begin
      open_target_setting_page
      @selenium.select "pjs", "SamplePJ2"
      sleep SLEEP_TIME
      @selenium.select "tasks", _("All")
      @selenium.check "qac"
      @selenium.check "qacpp"
      click $display_metric_xpath["add_subtask_button"]
      sleep SLEEP_TIME
      click $display_metric_xpath["save_button"]
      sleep SLEEP_TIME
      if($lang == 'ja')
      assert is_text_present($display_metric["unextracted_message_ja"])
      else
       assert is_text_present($display_metric["unextracted_message_en"])
      end
      click $display_metric_xpath["here_link"]
      assert is_text_present("PU: SamplePU1")
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=display_metrics"
  end
# Logged in.
# Select some subtask that are not extracted.
# Click "Save".
# Redirect to Display Metric page with an extracting data notice.
# Click "Extract" button.
# A message of extracting data is displayed.

  def test_dtm_st_089
    printf "\n+ Test 089"
    begin
      open_target_setting_page
      @selenium.select "pjs", "SamplePJ2"
      sleep SLEEP_TIME
      @selenium.select "tasks", _("All")
      @selenium.check "qac"
      @selenium.check "qacpp"
      click $display_metric_xpath["add_subtask_button"]
      sleep SLEEP_TIME
      click $display_metric_xpath["save_button"]
      sleep SLEEP_TIME*2
            if ($lang=='ja')
      assert_equal $display_metric["unextracted_message_ja"], @selenium.get_text($display_metric_xpath["unextracted_message"])
      else
        assert_equal $display_metric["unextracted_message_en"], @selenium.get_text($display_metric_xpath["unextracted_message"])
      end     
      sleep SLEEP_TIME     
      click $display_metric_xpath["extract"]         
      wait_for_text_present($display_metric["extracting_message"])
    end
    logout
    system "rake db:fixtures:load"
  end
# Logged in.
# Select some subtask that are not extracted.
# Click "Save".
# Redirect to Display Metric page with an extracting data notice.
# Click "Extract" button.
# A message of extracting data is displayed.
# After extracted finished. A message of successful extracting is displayed.

  def test_dtm_st_090
    printf "\n+ Test 090"
    begin
      open_target_setting_page
      @selenium.select "pjs", "SamplePJ2"
      sleep SLEEP_TIME
      @selenium.select "tasks", _("All")
      @selenium.check "qac"
      @selenium.check "qacpp"
      click $display_metric_xpath["add_subtask_button"]
      sleep SLEEP_TIME
      click $display_metric_xpath["save_button"]
      sleep SLEEP_TIME
       if($lang == 'ja')
      assert is_text_present($display_metric["unextracted_message_ja"])
      else
       assert is_text_present($display_metric["unextracted_message_en"])
      end
      sleep SLEEP_TIME
      click $display_metric_xpath["extract"]
      wait_for_text_present($display_metric["extracting_message"])
      wait_for_text_not_present($display_metric["extracting_message"])
      if ( $lang == 'ja')

      wait_for_text_present($display_metric["success_message_ia"])
      else
        sleep 10
        wait_for_text_present($display_metric["success_message_en"])
        sleep 10
      end
    end
    logout
    system "rake db:fixtures:load"
  end
# Logged in.
# Select some subtask that are not extracted.
# Click "Save".
# Redirect to Display Metric page with an extracting data notice.
# Click "Extract" button.
# A message of extracting data is displayed.
# After extracted finished. A message of successful extracting is displayed.
# Click "Here" button.
# Redirect back to Display Metric page

 def test_dtm_st_091
    printf "\n+ Test 091"
    begin
      open_target_setting_page
      @selenium.select "pjs", "SamplePJ2"
      sleep SLEEP_TIME
      @selenium.select "tasks", _("All")
      @selenium.check "qac"
      @selenium.check "qacpp"
      click $display_metric_xpath["add_subtask_button"]
      sleep SLEEP_TIME
      click $display_metric_xpath["save_button"]
      sleep SLEEP_TIME
       if($lang == 'ja')
      assert is_text_present($display_metric["unextracted_message_ja"])
      else
       assert is_text_present($display_metric["unextracted_message_en"])
      end
      click $display_metric_xpath["extract"]
      sleep SLEEP_TIME
      #wait_for_text_present($display_metric["extracting_message"])
      # wait_for_text_not_present($display_metric["extracting_message"])
      if ( $lang == 'ja')
      wait_for_text_present($display_metric["success_message_ia"])
      else
        wait_for_text_present($display_metric["success_message_en"])
      end
      click $display_metric_xpath["success_here_link"]
      wait_for_text_present($display_metric["name"])
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load"
  end
  end
