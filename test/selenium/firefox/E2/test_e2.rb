require File.dirname(__FILE__) + "/../E1/test_e1_setup" unless defined? TestE1Setup

class TestE2 < Test::Unit::TestCase
  include TestE1Setup
  self.fixture_path = File.join(File.expand_path(File.dirname(__FILE__)), 'fixtures')

  fixtures :all
  def test_001
    access_task_management_page_as_root
    view_task_details
    logout
  end

  def test_002
    access_task_management_page_as_root
    view_task_details

    # master link
    master_link = element_locator('details')['master'] + '/a'
    assert(is_element_present(master_link))
    logout
  end

  def test_003
    access_task_management_page_as_root

    # clicks on a row
    view_individual_task_details

    # master link
    master_link = element_locator('details')['master'] + '/a[1]'

    # private master link
    private_master_link = element_locator('details')['master'] + '/a[2]'

    assert(is_element_present(master_link))
    assert(is_element_present(private_master_link))
    logout
  end

  def test_004
    access_task_management_page_as_root

    # for an overall analysis task
    view_task_details
    # master link
    master_link = element_locator('details')['master'] + '/a[1]'
    # clicks on master link to open master's information subwindow
    click master_link
    wait_for_text_present($window_titles['master_information'])
    # closes the window
    first_window_id = get_attribute "//body/div[2]", "id"

    run_script("Windows.close('#{first_window_id}')")
    wait_for_text_not_present($window_titles['master_information'])

    # for an individual analysis task
    view_individual_task_details
    master_link = element_locator('details')['master'] + '/a[1]'
    # clicks on master link to open master's information subwindow
    click master_link
    wait_for_text_present($window_titles['master_information'])
    # closes the window
    first_window_id = get_attribute "//body/div[1]", "id"

    run_script("Windows.close('#{first_window_id}')")
    wait_for_text_not_present($window_titles['master_information'])
    sleep 5
    # clicks on private master link to open master's information subwindow
    private_master_link = element_locator('details')['master'] + '/a[2]'
    click private_master_link
    wait_for_text_not_present($window_titles['master_information'])
    # closes the window
    first_window_id = get_attribute "//body/div[1]", "id"

    run_script("Windows.close('#{first_window_id}')")
    wait_for_text_not_present($window_titles['master_information'])

    logout
  end

  def test_005

  end

  def test_006
    access_task_management_page_as_root
    view_task_details

    element =  element_locator('details')['state_explanation']
    assert_equal($messages['complete_task_description'], get_text(element))

    # there is a link to view analysis result
    assert(is_element_present(element_locator('details')['result']))
    logout
  end

  def test_007
    access_task_management_page_as_root

    view_task_details
    # master link
    master_link = element_locator('details')['master'] + '/a'
    # opens task's information subwindow
    click master_link
    wait_for_text_present($window_titles['master_information'])
    logout
  end

  def test_008
    access_task_management_page_as_root
    view_task_details

    # clicks on [Log] link to view log in a subwindow
    click element_locator('details')['log']
    wait_for_text_present($window_titles['task_log'])

    select_frame("//iframe")

    # the log is related to the task (id = 1)
    wait_for_text_present(_('Analysis Task'))
    # the log is related to the subtask (id = 1)
    wait_for_text_present(_('Subtask'))
    logout
  end

  def test_009
    access_task_management_page_as_root
    view_task_details
    # clicks on [analysis result] link to view the results
    click element_locator('details')['result']
    logout
  end

  def test_010
    # not a test case, this test case contains  all 6 followed test cases
    assert(true)
  end

  def test_011
    view_setting("make_root")
  end
  def test_012
    view_setting("header_file_at_analyze")
  end
  def test_013
    view_setting("make_options")
  end
  def test_014
    view_setting("environment_variables")
  end
  def test_015
    view_setting("analyze_allow_files")
  end
  def test_016
    view_setting("analyze_deny_files")
  end
  def test_017
    view_setting("analyze_tool_config")
  end
  def test_018
    view_setting('other')
  end

  def test_019
    access_task_management_page_as_root
    view_task_details
    logout
  end

  def test_020
    access_task_management_page_as_root
    view_individual_task_details
    logout
  end

  def test_021
    access_task_management_page_as_root
    view_other_task_details
    logout
  end

  def test_022
    access_task_management_page_as_pj_member
    view_task_details
    logout
  end

  def test_023
    access_task_management_page_as_pj_member
    view_individual_task_details(OTHER_TASK_ROW)
    logout
  end

  def test_024
    access_task_management_page_as_pj_member
    open_other_tab
    click INDIVIDUAL_TASK_ROW
    # pj members can not see other's task
    wait_for_text_present($messages["task_detail_denied"])
    logout
  end

  def test_025
    access_task_management_page_as_root
    view_task_details
    assert(is_element_present(element_locator('details')['delete_link']))
    logout
  end

  def test_026
    access_task_management_page_as_root
    view_individual_task_details
    assert(is_element_present(element_locator('details')['delete_link']))
    logout
  end

  def test_027
    access_task_management_page_as_root
    view_other_task_details
    assert(is_element_present(element_locator('details')['delete_link']))
    logout
  end

  def test_028
    access_task_management_page_as_pj_member
    view_task_details
    assert(is_element_not_present(element_locator('details')['delete_link']))
    logout
  end

  def test_029
    access_task_management_page_as_pj_member
    view_individual_task_details(OTHER_TASK_ROW)
    logout
  end
  def test_030
    access_task_management_page_as_pj_member
    click INDIVIDUAL_TASK_ROW
    assert(is_element_not_present(element_locator('details')['delete_link']))
    logout
  end

  def test_031
    access_task_management_page_as_root
    view_task_details
    analyze_rule_row = element_locator('details')['analyze_rules']
    total_analyze_rule_rows = get_xpath_count(analyze_rule_row)
    (1..total_analyze_rule_rows).each do |index|
      row = analyze_rule_row + "[#{index}]"
      analyze_tool_name = get_text(row + "/td[1]")
      link = row + "/td[2]/a"
      total_links = get_xpath_count(link)
      (1..total_links).each do |j|
        # opens the subwindows by clicking on rules' link
        rule_link = link + "[#{j}]"
        rule_name = get_text(rule_link)
        click rule_link
        # checks  the relationship between our task and the subwindow
        expected_title = "#{analyze_tool_name}:Level:#{rule_name.capitalize}"
        wait_for_text_present(expected_title)
      end
    end
  end

  def test_032
    access_task_management_page_as_root
    view_task_details
    analyze_rule_row = element_locator('details')['analyze_rules']
    total_analyze_rule_rows = get_xpath_count(analyze_rule_row)

    row = analyze_rule_row + "[1]"
    analyze_tool_name = get_text(row + "/td[1]")
    rule_link = row + "/td[2]/a"
    rule_name = get_text(rule_link)

    # opens subwindow by clicking on rule_link
    expected_title = "#{analyze_tool_name}:"+_("Level")+":#{rule_name.capitalize}"
    click rule_link
    wait_for_text_present(expected_title)

    subwindow_id = get_attribute('//iframe', 'id')
    select_frame subwindow_id
    wait_for_element_present('//div/a')
    click '//div/a'
    href = get_attribute('//div/a', "href")
    href =~ /.*?message_id=(\d).*?/
    message_id = $1
    wait_for_pop_up "", "30000"
    sleep 5
    expected_title = "#{analyze_tool_name}"+_("Message")+"(#{message_id})"
    select_window("title=#{expected_title}")
    assert(is_text_present(expected_title))
    logout
  end

  def test_033
    # Cannot register a task without settings for analyze tools
    printf "\n+ This is not a test case!"
    assert(true)
  end

  def test_034
    test_033
  end
end
