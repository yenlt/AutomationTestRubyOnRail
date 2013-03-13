require File.dirname(__FILE__) + "/test_wd_setup" unless defined? TestWDSetup
require 'test/unit'
class TestWD2 < Test::Unit::TestCase
  include TestWDSetup
  #
  # Test access right
  #
  # Open diff result page with an invalid id.
  #
  def test_wd_st_001
    printf "\n+ Test 001"
    open_diff_result_summary_page(ERROR_DIFF_ID)
    assert is_text_present($diff_administration["title"])
    assert is_text_present($diff_result_summary["error_message"].sub("__INDEX__",ERROR_DIFF_ID.to_s))
    logout
  end
  #15:59:41 結果 (id=100) が見つかりません。
  # Test display of Diff Result Summary page
  #
  # Logged in.
  # Diff Result Summary page is displayed.
  #
  def test_wd_st_002
    printf "\n+ Test 002"
    open_diff_result_summary_page(1)
    assert is_text_present($diff_result_summary["title"])
    logout
  end
  # PU, PJ, Analysis tool is displayed.
  #
  def test_wd_st_003
    printf "\n+ Test 003"
    open_diff_result_summary_page(1)
    diff = DiffResult.find_by_id(1)
    new_pu = Pu.find_by_id(diff.new_pu_id).name
    new_pj = Pj.find_by_id(diff.new_pj_id).name
    new_task = Task.find_by_id(diff.new_task_id).name
    old_pu = Pu.find_by_id(diff.old_pu_id).name
    old_pj = Pj.find_by_id(diff.old_pj_id).name
    old_task = Task.find_by_id(diff.old_task_id).name
    case diff.analyze_tool_id
    when 1
      tool = "QAC"
    when 2
      tool = "QAC++"
    end
    assert is_text_present("#{new_pu} : #{new_pj} : #{new_task} : #{tool} <-> #{old_pu} : #{old_pj} : #{old_task} : #{tool}")
    logout
  end
#   Logged in.
#   All table is displayed.

  def test_wd_st_004
    printf "\n+ Test 004"
    open_diff_result_summary_page(1)
    assert is_text_present($diff_result_summary["all_table_header"])
    (1..10).each do |i|
      assert_equal $diff_result_summary["all_table"][i-1], @selenium.get_text($diff_result_summary_xpath["all_table_header"]+"[#{i}]")
    end
    logout
  end
  # Logged in.
  # Module table is displayed.
  #
  def test_wd_st_005
    printf "\n+ Test 005"
    open_diff_result_summary_page(1)
    assert is_text_present($diff_result_summary["module_table_header"])
    (1..10).each do |i|
      assert_equal $diff_result_summary["all_table"][i-1], @selenium.get_text($diff_result_summary_xpath["module_table_header"]+"[#{i}]")
    end
    logout
  end
  # Logged in.
  # File table is displayed.
  #
  def test_wd_st_006
    printf "\n+ Test 006"
    open_diff_result_summary_page(1)
    assert is_text_present($diff_result_summary["file_table_header"])
    (1..11).each do |i|
      assert_equal $diff_result_summary["file_table"][i-1], @selenium.get_text($diff_result_summary_xpath["file_table_header"]+"[#{i}]")
    end
    logout
  end
  # Logged in.
  # Click Module link.
  #
  def test_wd_st_007
    printf "\n+ Test 007"
    open_diff_result_summary_page(1)
    module_name = @selenium.get_text($diff_result_summary_xpath["module_link"])
    click $diff_result_summary_xpath["module_link"]
    sleep SLEEP_TIME
    assert is_text_present($diff_result_summary["summary_page_title"].sub("__INDEX__",module_name))
    logout
  end
  # Logged in.
  # Click Directory link.
  #
  def test_wd_st_008
    printf "\n+ Test 008"
    open_diff_result_summary_page(1)
    directory_name = @selenium.get_text($diff_result_summary_xpath["directory_link"])
    click $diff_result_summary_xpath["directory_link"]
    sleep SLEEP_TIME
    assert is_text_present($diff_result_summary["summary_page_title"].sub("__INDEX__",directory_name))
    logout
  end
  # Logged in.
  # Click Module link.
  #
  def test_wd_st_009
    printf "\n+ Test 009"
    open_diff_result_summary_page(1)
    file_name = @selenium.get_text($diff_result_summary_xpath["file_link"])
    click $diff_result_summary_xpath["file_link"]
    sleep SLEEP_TIME
    assert is_text_present($diff_result_summary["summary_page_title"].sub("__INDEX__",file_name))
    logout
  end

end
