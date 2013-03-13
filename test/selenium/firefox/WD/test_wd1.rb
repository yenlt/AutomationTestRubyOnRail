require File.dirname(__FILE__) + "/test_wd_setup" unless defined? TestWDSetup
require 'test/unit'
class TestWD1 < Test::Unit::TestCase
  include TestWDSetup
  #
  # Test Access right of Diff Administration page
  #
  # User hasn't logged in
  #
  def test_wd_st_001
    printf "\n+ Test 001"
    open "/diff"
    sleep SLEEP_TIME
    assert @selenium.is_text_present($page_titles["auth_login"])
  end
  # User logged in.
  # Diff Administration link is displayed.
  #
  def test_wd_st_002
    printf "\n+ Test 002"
    login
    sleep SLEEP_TIME
    assert @selenium.is_element_present($diff_administration_xpath["menu_link"])
    logout
  end
  # User logged in.
  # Click Diff Administration link.
  # Diff Administration page is displayed.
  #
  def test_wd_st_003
    printf "\n+ Test 003"
    login
    sleep SLEEP_TIME
    assert @selenium.is_element_present($diff_administration_xpath["menu_link"])
    click $diff_administration_xpath["menu_link"]
    assert @selenium.is_text_present($diff_administration["title"])
    logout
  end
  #
  # Test display of Diff Administration page
  #
  # Logged in as an admin.
  # New version select field is displayed.
  #
  def test_wd_st_004
    printf "\n+ Test 004"
    open_diff_administration_page
    assert @selenium.is_text_present($diff_administration["new_version_field_name"])
    assert @selenium.is_element_present($diff_administration_xpath["new_pu_select"])
    assert @selenium.is_element_present($diff_administration_xpath["new_pj_select"])
    assert @selenium.is_element_present($diff_administration_xpath["new_task_select"])
    logout
  end
  # Logged in as an admin.
  # Old version select field is displayed.
  #
  def test_wd_st_005
    printf "\n+ Test 005"
    open_diff_administration_page
    assert @selenium.is_text_present($diff_administration["old_version_field_name"])
    assert @selenium.is_element_present($diff_administration_xpath["old_pu_select"])
    assert @selenium.is_element_present($diff_administration_xpath["old_pj_select"])
    assert @selenium.is_element_present($diff_administration_xpath["old_task_select"])
    logout
  end
  # Logged in as an admin.
  # Analysis tool select field is displayed.
  #
  def test_wd_st_006
    printf "\n+ Test 006"
    open_diff_administration_page
    assert @selenium.is_text_present($diff_administration["select_analysis_tool"])
    assert @selenium.is_element_present($diff_administration_xpath["analysis_tool_select"])
    assert @selenium.is_text_present("QAC")
    assert @selenium.is_text_present("QAC++")
    logout
  end
  # Logged in as an admin.
  # Execute Diff button is displayed.
  #
  def test_wd_st_007
    printf "\n+ Test 007"
    open_diff_administration_page
    assert @selenium.is_element_present($diff_administration_xpath["execute_diff_button"])
    logout
  end
  # Logged in as an admin.
  # Link to result field is displayed.
  #
  def test_wd_st_008
    printf "\n+ Test 008"
    open_diff_administration_page
    assert is_text_present($diff_administration_xpath["link_to_result"])
    #assert @selenium.is_text_present($diff_administration["link_to_result"])
    assert @selenium.is_text_present($diff_administration["no_result_yet"])
    logout
  end
  # Logged in as an admin.
  # Recent diff result table is displayed.
  #
  def test_wd_st_009
    printf "\n+ Test 009"
    open_diff_administration_page
    assert @selenium.is_text_present($diff_administration["recent_diff_result"])
    (1..4).each do |index|
      assert_equal $diff_administration["recent_diff_result_head1"][index-1],
        @selenium.get_text($diff_administration_xpath["recent_diff_result_head1"].sub("__INDEX__",index.to_s))
    end
    (1..10).each do |index|
      if index > 5
        assert_equal $diff_administration["recent_diff_result_head2"][index-6],
        @selenium.get_text($diff_administration_xpath["recent_diff_result_head2"].sub("__INDEX__",index.to_s))
      else
        assert_equal $diff_administration["recent_diff_result_head2"][index-1],
        @selenium.get_text($diff_administration_xpath["recent_diff_result_head2"].sub("__INDEX__",index.to_s))
      end
    end
    logout
  end
  # Logged in as a PJ member.
  # Only recent diff result table is displayed.
  #
  def test_wd_st_010
    printf "\n+ Test 010"
    open_diff_administration_page_as(PJ_MEMBER_USER,PJ_MEMBER_PASSWORD)
    # recent diff result table
    assert @selenium.is_text_present($diff_administration["recent_diff_result"])
    (1..4).each do |index|
      assert_equal $diff_administration["recent_diff_result_head1"][index-1],
        @selenium.get_text($diff_administration_xpath["recent_diff_result_head1"].sub("__INDEX__",index.to_s))
    end
    (1..10).each do |index|
      if index > 5
        assert_equal $diff_administration["recent_diff_result_head2"][index-6],
        @selenium.get_text($diff_administration_xpath["recent_diff_result_head2"].sub("__INDEX__",index.to_s))
      else
        assert_equal $diff_administration["recent_diff_result_head2"][index-1],
        @selenium.get_text($diff_administration_xpath["recent_diff_result_head2"].sub("__INDEX__",index.to_s))
      end
    end
    assert !@selenium.is_text_present($diff_administration["new_version_field_name"])
    assert !@selenium.is_text_present($diff_administration["old_version_field_name"])
    assert !@selenium.is_text_present($diff_administration["select_analysis_tool"])
    assert !@selenium.is_element_present($diff_administration_xpath["execute_diff_button"])
    logout
  end
  # Logged in as a none PJ member.
  # Only header of recent diff result table is displayed.
  #
  def test_wd_st_011
    printf "\n+ Test 011"
    open_diff_administration_page_as(NONE_PJ_MEMBER_USER,NONE_PJ_MEMBER_PASSWORD)
    # recent diff result table
    assert @selenium.is_text_present($diff_administration["recent_diff_result"])
    (1..4).each do |index|
      assert_equal $diff_administration["recent_diff_result_head1"][index-1],
        @selenium.get_text($diff_administration_xpath["recent_diff_result_head1"].sub("__INDEX__",index.to_s))
    end
    (1..10).each do |index|
      if index > 5
        assert_equal $diff_administration["recent_diff_result_head2"][index-6],
        @selenium.get_text($diff_administration_xpath["recent_diff_result_head2"].sub("__INDEX__",index.to_s))
      else
        assert_equal $diff_administration["recent_diff_result_head2"][index-1],
        @selenium.get_text($diff_administration_xpath["recent_diff_result_head2"].sub("__INDEX__",index.to_s))
      end
    end
    assert !@selenium.is_text_present($diff_administration["new_version_field_name"])
    assert !@selenium.is_text_present($diff_administration["old_version_field_name"])
    assert !@selenium.is_text_present($diff_administration["select_analysis_tool"])
    assert !@selenium.is_element_present($diff_administration_xpath["execute_diff_button"])
    assert_equal 0,get_xpath_count($diff_administration_xpath["recent_diff_result_row"])
    logout
  end
  #
  # Test PU select box
  #
  # Logged in as TOSCANA admin.
  # All PU listed.
  #
  def test_wd_st_012
    printf "\n+ Test 012"
    open_diff_administration_page
    pus = Pu.find(:all)
    all_pus = []
    pus.each do |pu|
      all_pus << pu.name
    end
    new_pus = @selenium.get_select_options($diff_administration_xpath["new_pu_select"])
    old_pus = @selenium.get_select_options($diff_administration_xpath["old_pu_select"])
    assert_equal all_pus, new_pus
    assert_equal all_pus, old_pus
    logout
  end
  # Logged in as a PU admin.
  # All PU that are belong to that user will be listed.
  #
  def test_wd_st_013
    printf "\n+ Test 013"
    open_diff_administration_page_as(PU_ADMIN_USER, PU_ADMIN_PASSWORD)
    user_id = User.find_by_account_name(PU_ADMIN_USER).id
    pus = PusUsers.find_all_by_user_id(user_id)
    all_pus = []
    pus.each do |pu|
      pu_name = Pu.find_by_id(pu.pu_id).name
      all_pus << pu_name
    end
    new_pus = @selenium.get_select_options($diff_administration_xpath["new_pu_select"])
    old_pus = @selenium.get_select_options($diff_administration_xpath["old_pu_select"])
    assert_equal all_pus, new_pus
    assert_equal all_pus, old_pus
    logout
  end
  #
  # Test new PJ select box
  #
  # Logged in as TOSCANA admin.
  # All PJ belong to selected PU are listed.
  #
  def test_wd_st_014
    printf "\n+ Test 014"
    open_diff_administration_page
    selected_pu_id = @selenium.get_selected_value($diff_administration_xpath["new_pu_select"])
    pjs = Pj.find_all_by_pu_id(selected_pu_id)
    all_pjs = []
    pjs.each do |pj|
      all_pjs << pj.name
    end
    new_pjs = @selenium.get_select_options($diff_administration_xpath["new_pj_select"])
    assert_equal all_pjs, new_pjs
    logout
  end
  # Logged in as TOSCANA admin.
  # Change PU selected. List of PJ automatically changed.
  #
  def test_wd_st_015
    printf "\n+ Test 015"
    open_diff_administration_page
    selected_pu_id = @selenium.get_selected_value($diff_administration_xpath["new_pu_select"])
    pjs = Pj.find_all_by_pu_id(selected_pu_id)
    old_pjs = []
    pjs.each do |pj|
      old_pjs << pj.name
    end
    old_pj_list = @selenium.get_select_options($diff_administration_xpath["new_pj_select"])
    select $diff_administration_xpath["new_pu_select"], "SamplePU2"
    sleep SLEEP_TIME
    new_pj_list = @selenium.get_select_options($diff_administration_xpath["new_pj_select"])
    assert_equal old_pjs, old_pj_list
    assert_not_equal old_pjs, new_pj_list
    logout
  end
  #
  # Test new task select box
  #
  # Logged in as TOSCANA admin.
  # All task belong to selected PJ are listed.
  #
  def test_wd_st_016
    printf "\n+ Test 016"
    open_diff_administration_page
    selected_pu_id = @selenium.get_selected_value($diff_administration_xpath["new_pj_select"])
    tasks = Task.find_all_by_pj_id(selected_pu_id)
    all_tasks = []
    tasks.each do |task|
      all_tasks << task.name
    end
    new_tasks = @selenium.get_select_options($diff_administration_xpath["new_task_select"])
    assert_equal all_tasks, new_tasks
    logout
  end
  # Logged in as TOSCANA admin.
  # Change PJ selected. List of tasks automatically changed.
  #
  def test_wd_st_017
    printf "\n+ Test 017"
    open_diff_administration_page
    selected_pj_id = @selenium.get_selected_value($diff_administration_xpath["new_pj_select"])
    tasks = Task.find_all_by_pj_id(selected_pj_id)
    old_tasks = []
    tasks.each do |task|
      old_tasks << task.name
    end
    old_task_list = @selenium.get_select_options($diff_administration_xpath["new_task_select"])
    select $diff_administration_xpath["new_pj_select"], "SamplePJ2"
    sleep SLEEP_TIME
    new_task_list = @selenium.get_select_options($diff_administration_xpath["new_task_select"])
    assert_equal old_tasks, old_task_list
    assert_not_equal old_tasks, new_task_list
    logout
  end

  # Test old PJ select box
  #
  # Logged in as TOSCANA admin.
  # All PJ belong to selected PU are listed.
  #
  def test_wd_st_018
    printf "\n+ Test 018"
    open_diff_administration_page
    selected_pu_id = @selenium.get_selected_value($diff_administration_xpath["old_pu_select"])
    pjs = Pj.find_all_by_pu_id(selected_pu_id)
    all_pjs = []
    pjs.each do |pj|
      all_pjs << pj.name
    end
    new_pjs = @selenium.get_select_options($diff_administration_xpath["old_pj_select"])
    assert_equal all_pjs, new_pjs
    logout
  end
  # Logged in as TOSCANA admin.
  # Change PU selected. List of PJ automatically changed.
  #
  def test_wd_st_019
    printf "\n+ Test 019"
    open_diff_administration_page
    selected_pu_id = @selenium.get_selected_value($diff_administration_xpath["old_pu_select"])
    pjs = Pj.find_all_by_pu_id(selected_pu_id)
    old_pjs = []
    pjs.each do |pj|
      old_pjs << pj.name
    end
    old_pj_list = @selenium.get_select_options($diff_administration_xpath["old_pj_select"])
    select $diff_administration_xpath["old_pu_select"], "SamplePU2"
    sleep SLEEP_TIME
    new_pj_list = @selenium.get_select_options($diff_administration_xpath["old_pj_select"])
    assert_equal old_pjs, old_pj_list
    assert_not_equal old_pjs, new_pj_list
    logout
  end
  #
  # Test task select box
  #
  # Logged in as TOSCANA admin.
  # All task belong to selected PJ are listed.
  #
  def test_wd_st_020
    printf "\n+ Test 020"
    open_diff_administration_page
    selected_pu_id = @selenium.get_selected_value($diff_administration_xpath["old_pj_select"])
    tasks = Task.find_all_by_pj_id(selected_pu_id)
    all_tasks = []
    tasks.each do |task|
      all_tasks << task.name
    end
    new_tasks = @selenium.get_select_options($diff_administration_xpath["old_task_select"])
    assert_equal all_tasks, new_tasks
    logout
  end
  # Logged in as TOSCANA admin.
  # Change PJ selected. List of tasks automatically changed.
  #
  def test_wd_st_021
    printf "\n+ Test 021"
    open_diff_administration_page
    selected_pj_id = @selenium.get_selected_value($diff_administration_xpath["old_pj_select"])
    tasks = Task.find_all_by_pj_id(selected_pj_id)
    old_tasks = []
    tasks.each do |task|
      old_tasks << task.name
    end
    old_task_list = @selenium.get_select_options($diff_administration_xpath["old_task_select"])
    select $diff_administration_xpath["old_pj_select"], "SamplePJ2"
    sleep SLEEP_TIME
    new_task_list = @selenium.get_select_options($diff_administration_xpath["old_task_select"])
    assert_equal old_tasks, old_task_list
    assert_not_equal old_tasks, new_task_list
    logout
  end
  #
  # Test Execute Diff button
  #
  # Logged in as TOSCANA admin.
  # Select the same task to diff.
  # Click QAC.
  # Click Execute Diff
  #
  def test_wd_st_022
    printf "\n+ Test 022"
    open_diff_administration_page
    # select new version
    select $diff_administration_xpath["new_pu_select"], "SamplePU1"
    sleep SLEEP_TIME
    select $diff_administration_xpath["new_pj_select"], "SamplePJ1"
    sleep SLEEP_TIME
    select $diff_administration_xpath["new_task_select"], "sample_c_cpp_1_1"
    # select old version
    select $diff_administration_xpath["old_pu_select"], "SamplePU1"
    sleep SLEEP_TIME
    select $diff_administration_xpath["old_pj_select"], "SamplePJ1"
    sleep SLEEP_TIME
    select $diff_administration_xpath["old_task_select"], "sample_c_cpp_1_1"
    # check QAC
    check $diff_administration_xpath["qac"]
    click $diff_administration_xpath["execute_diff_button"]
    sleep SLEEP_TIME
    assert is_text_present($diff_administration["error_messsage"])
    logout
  end
  # Logged in as TOSCANA admin.
  # Select the same task to diff.
  # Click QAC++.
  # Click Execute Diff.
  #
  def test_wd_st_023
    printf "\n+ Test 023"
    open_diff_administration_page
    # select new version
    select $diff_administration_xpath["new_pu_select"], "SamplePU1"
    sleep SLEEP_TIME
    select $diff_administration_xpath["new_pj_select"], "SamplePJ1"
    sleep SLEEP_TIME
    select $diff_administration_xpath["new_task_select"], "sample_c_cpp_1_1"
    # select old version
    select $diff_administration_xpath["old_pu_select"], "SamplePU1"
    sleep SLEEP_TIME
    select $diff_administration_xpath["old_pj_select"], "SamplePJ1"
    sleep SLEEP_TIME
    select $diff_administration_xpath["old_task_select"], "sample_c_cpp_1_1"
    # check QAC++
    check $diff_administration_xpath["qacpp"]
    click $diff_administration_xpath["execute_diff_button"]
    sleep SLEEP_TIME
    assert is_text_present($diff_administration["error_messsage"])
    logout
  end
  # Logged in as TOSCANA admin.
  # Select task that are different.
  # Click QAC.
  # Click Execute Diff.
  #
  def test_wd_st_024
    printf "\n+ Test 024"
    open_diff_administration_page
    old_row_number = get_xpath_count($diff_administration_xpath["recent_diff_result_row"])
    p old_row_number
    execute_qac_task
    begin
      new_row_number = get_xpath_count($diff_administration_xpath["recent_diff_result_row"])
      assert_equal old_row_number + 1, new_row_number
      assert is_text_present($diff_administration["success_message"])
      assert is_text_present($diff_administration["diff_result"])
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=diff_results"
  end
#   Logged in as TOSCANA admin.
#   Select task that are different.
#   Click QAC++.
#   Click Execute Diff.

  def test_wd_st_025
    printf "\n+ Test 025"
    open_diff_administration_page
    old_row_number = get_xpath_count($diff_administration_xpath["recent_diff_result_row"])
    execute_qacpp_task
    begin
      new_row_number = get_xpath_count($diff_administration_xpath["recent_diff_result_row"])
      assert_equal old_row_number + 1, new_row_number
      assert is_text_present($diff_administration["success_message"])
      assert is_text_present($diff_administration["diff_result"])
#    rescue Test::Unit::AssertionFailedError
#      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=diff_results"
  end
  # Logged in as TOSCANA admin.
  # Select task that are different.
  # Click QAC.
  # Click Execute Diff.
  # Those tasks are executed.
  #
  def test_wd_st_026
    printf "\n+ Test 026"
    open_diff_administration_page
    old_row_number = get_xpath_count($diff_administration_xpath["recent_diff_result_row"])
    # select new version
    select $diff_administration_xpath["new_pu_select"], "SamplePU1"
    sleep SLEEP_TIME
    select $diff_administration_xpath["new_pj_select"], "SamplePJ1"
    sleep SLEEP_TIME
    select $diff_administration_xpath["new_task_select"], "sample_c_cpp_1_1"
    # select old version
    select $diff_administration_xpath["old_pu_select"], "SamplePU1"
    sleep SLEEP_TIME
    select $diff_administration_xpath["old_pj_select"], "SamplePJ1"
    sleep SLEEP_TIME
    select $diff_administration_xpath["old_task_select"], "test1"
    # check QAC
    check $diff_administration_xpath["qac"]
    begin
      click $diff_administration_xpath["execute_diff_button"]
      wait_for_element_not_present($diff_administration_xpath["wait_element"])
      sleep SLEEP_TIME
      new_row_number = get_xpath_count($diff_administration_xpath["recent_diff_result_row"])
      assert_equal old_row_number , new_row_number
      assert is_text_present($diff_administration["success_message"])
      assert is_text_present($diff_administration["diff_result"])
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=diff_results"
  end
  # Logged in as TOSCANA admin.
  # Select task that are different.
  # Click QAC++.
  # Click Execute Diff.
  # Those tasks are executed.
  #
  def test_wd_st_027
    printf "\n+ Test 027"
    open_diff_administration_page
    execute_qacpp_task
    begin
      old_row_number = get_xpath_count($diff_administration_xpath["recent_diff_result_row"])
      execute_qacpp_task
      new_row_number = get_xpath_count($diff_administration_xpath["recent_diff_result_row"])
      assert_equal old_row_number , new_row_number
      assert is_text_present($diff_administration["success_message"])
      assert is_text_present($diff_administration["diff_result"])
#    rescue Test::Unit::AssertionFailedError
#      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=diff_results"
  end
  # "No result yet" link
  #
  def test_wd_st_028
    printf "\n+ Test 028"
    open_diff_administration_page
    click $diff_administration_xpath["diff_result"]
    sleep SLEEP_TIME
    assert is_text_present($diff_administration["title"])
    logout
  end
  # "Diff Result" link
  #
  def test_wd_st_029
    printf "\n+ Test 029"
    open_diff_administration_page
    execute_qac_task
    click $diff_administration_xpath["diff_result"]
    sleep SLEEP_TIME
    begin
      assert is_text_present($diff_administration["diff_result_title"])
#    rescue Test::Unit::AssertionFailedError
#      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=diff_results"
  end
  #
  # Test Delete link
  #
  # Click on delete link
  #
  def test_wd_st_030
    printf "\n+ Test 030"
    open_diff_administration_page
    begin
      click $diff_administration_xpath["delete_link1"]
      sleep SLEEP_TIME
      assert_equal $diff_administration["delete_confirm"], @selenium.get_confirmation()
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=diff_results"
  end
  # Click on delete link.
  # Chose OK
  #
  def test_wd_st_031
    printf "\n+ Test 031"
    open_diff_administration_page
    old_result_number = get_xpath_count($diff_administration_xpath["recent_diff_result_row"])
    begin
      choose_ok_on_next_confirmation
      click $diff_administration_xpath["delete_link1"]
      sleep SLEEP_TIME
      assert_equal $diff_administration["delete_confirm"], @selenium.get_confirmation()
      new_result_number = get_xpath_count($diff_administration_xpath["recent_diff_result_row"])
      assert is_text_present($diff_administration["delete_message"])
      assert_equal old_result_number -1, new_result_number
#    rescue Test::Unit::AssertionFailedError
#      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=diff_results,diff_source_codes,diff_warnings,diff_files,original_files,original_source_codes"
  end
  # Click on delete link.
  # Chose cancel
  #
  def test_wd_st_032
    printf "\n+ Test 032"
    open_diff_administration_page
    old_result_number = get_xpath_count($diff_administration_xpath["recent_diff_result_row"])
    begin
      choose_cancel_on_next_confirmation
      click $diff_administration_xpath["delete_link1"]
      sleep SLEEP_TIME
      assert_equal $diff_administration["delete_confirm"], @selenium.get_confirmation()
      new_result_number = get_xpath_count($diff_administration_xpath["recent_diff_result_row"])
      assert_equal old_result_number , new_result_number
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    system "rake db:fixtures:load FIXTURES=diff_results"
  end
  #
  # Test Diff link
  #
  def test_wd_st_033
    printf "\n+ Test 033"
    open_diff_administration_page
    click $diff_administration_xpath["diff_link1"]
    sleep SLEEP_TIME
    assert is_text_present($diff_administration["diff_result_title"])
    logout
  end
  #
  # Test Recent Result table
  #
  # Logged in as Toscana Admin
  #
  def test_wd_st_034
    printf "\n+ Test 034"
    open_diff_administration_page
    diff_numbers = DiffResult.find(:all)
    recent_row_numbers = get_xpath_count($diff_administration_xpath["recent_diff_result_row"])
    assert_equal diff_numbers.count, recent_row_numbers
    logout
  end
  # Logged in as PU Admin
  #
  def test_wd_st_035
    printf "\n+ Test 035"
    open_diff_administration_page_as(PU_ADMIN_USER, PU_ADMIN_PASSWORD)
    user_id = User.find_by_account_name(PU_ADMIN_USER).id
    list_pu_user = PusUsers.find_all_by_user_id(user_id)
    list_pu = []
    list_pu_user.each do |pu|
      list_pu << pu.pu_id
    end
    diff = DiffResult.find(:all)
    number_pu = 0
    diff.each do |d|
      old_pu = false
      new_pu = false
      list_pu.each do |pu|
        if pu = d.old_pu_id
          old_pu = true
        end
        if pu = d.new_pu_id
          new_pu = true
        end
      end
      if old_pu == true && new_pu == true
        number_pu =+1
      end
    end
    recent_row_numbers = get_xpath_count($diff_administration_xpath["recent_diff_result_row"])
    assert_equal number_pu, recent_row_numbers
    logout
  end
  # Logged in as PJ Admin
  #
  def test_wd_st_036
    printf "\n+ Test 036"
    open_diff_administration_page_as(PJ_ADMIN_USER, PJ_ADMIN_PASSWORD)
    user_id = User.find_by_account_name(PJ_ADMIN_USER).id
    list_pj_user = PjsUsers.find_all_by_user_id(user_id)
    list_pj = []
    list_pj_user.each do |pj|
      list_pj << pj.pj_id
    end
    diff = DiffResult.find(:all)
    number_pj = 0
    diff.each do |d|
      old_pj= false
      new_pj = false
      list_pj.each do |pj|
        if pj = d.old_pj_id
          old_pj = true
        end
        if pj = d.new_pj_id
          new_pj = true
        end
      end
      if old_pj == true && new_pj == true
        number_pj =+1
      end
    end
    recent_row_numbers = get_xpath_count($diff_administration_xpath["recent_diff_result_row"])
    assert_equal number_pj, recent_row_numbers
    logout
  end
  # Logged in as PJ Admin
  #
  def test_wd_st_037
    printf "\n+ Test 037"
    open_diff_administration_page_as(PJ_MEMBER_USER, PJ_MEMBER_USER)
    user_id = User.find_by_account_name(PJ_MEMBER_USER).id
    list_pj_user = PjsUsers.find_all_by_user_id(user_id)
    list_pj = []
    list_pj_user.each do |pj|
      list_pj << pj.pj_id
    end
    diff = DiffResult.find(:all)
    number_pj = 0
    diff.each do |d|
      old_pj= false
      new_pj = false
      list_pj.each do |pj|
        if pj = d.old_pj_id
          old_pj = true
        end
        if pj = d.new_pj_id
          new_pj = true
        end
      end
      if old_pj == true && new_pj == true
        number_pj =+1
      end
    end
    recent_row_numbers = get_xpath_count($diff_administration_xpath["recent_diff_result_row"])
    assert_equal number_pj, recent_row_numbers
    logout
  end
  # Logged in as PJ Admin
  #
  def test_wd_st_038
    printf "\n+ Test 038"
    open_diff_administration_page_as(NONE_PJ_MEMBER_USER, NONE_PJ_MEMBER_USER)
    recent_row_numbers = get_xpath_count($diff_administration_xpath["recent_diff_result_row"])
    assert_equal 0, recent_row_numbers
    logout
  end

end
