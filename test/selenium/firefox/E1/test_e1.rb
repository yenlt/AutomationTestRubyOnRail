#require File.dirname(__FILE__) + "/test_e1_setup" unless defined? TestE1Setup
#
#class TestE1 < Test::Unit::TestCase
#  include TestE1Setup
#
#  fixtures :tasks, :subtasks
#  TASK_ROW = 'task_id1' unless defined? TASK_ROW
#
##  def test_001
##    # clears all tasks
##    tasks = Task.find(:all,
##                      :conditions => {:pj_id => PJ_ID})
##    tasks.each do |task|
##      task.pj_id = 0
##      task.save!
##    end
##
##    access_task_management_page_as_root
##    logout
##  end
#
#  def test_002
#    # clears all tasks
#    tasks = Task.find(:all,
#                      :conditions => {:pj_id => PJ_ID})
#    tasks.each do |task|
#      task.pj_id = 0
#      task.save!
#    end
#
#    #
#    access_task_management_page_as_root
#
#    # by default, overall tab is displayed
#    assert(is_text_present($messages['no_task_in_list']))
#
#    # individual tab
#    open_individual_tab
#    assert(is_text_present($messages['no_task_in_list']))
#
#    # other tab
#    open_other_tab
#    assert(is_text_present($messages['no_task_in_list']))
#
#    logout
#  end
#
#  def test_003
#    access_task_management_page_as_root
#    assert(is_text_present($messages['task_details']))
#    logout
#  end
#
#  def test_004
#    access_task_management_page_as_root
#    logout
#  end
#
#  def test_005
#    access_task_management_page_as_root
#
#    # overall tab
#    open_overall_tab
#    check_tab_header_style('overall',
#                           'focused')
#    check_tab_header_style('individual',
#                           'unfocused')
#    check_tab_header_style('other',
#                           'unfocused')
#    check_tab_pane_style('overall',
#                         'focused')
#    check_tab_pane_style('individual',
#                         'unfocused')
#    check_tab_pane_style('other',
#                         'unfocused')
#
#    # individual tab
#    open_individual_tab
#    check_tab_header_style('overall',
#                           'unfocused')
#    check_tab_header_style('individual',
#                           'focused')
#    check_tab_header_style('other',
#                           'unfocused')
#    check_tab_pane_style('overall',
#                         'unfocused')
#    check_tab_pane_style('individual',
#                         'focused')
#    check_tab_pane_style('other',
#                         'unfocused')
#
#    # other tab
#    open_other_tab
#    check_tab_header_style('overall',
#                           'unfocused')
#    check_tab_header_style('individual',
#                           'unfocused')
#    check_tab_header_style('other',
#                           'focused')
#    check_tab_pane_style('overall',
#                         'unfocused')
#    check_tab_pane_style('individual',
#                         'unfocused')
#    check_tab_pane_style('other',
#                         'focused')
#
#    logout
#  end
#
#  def test_006
#    test_005
#  end
#
#  def test_007
#    access_task_management_page_as_root
#    expected_task_ids = get_col('overall', 'id')
#
#    # gets id from database
#    tasks = Task.find(:all,
#                      :order      => 'id desc',
#                      :conditions => {:analyze_type_id  => 1,
#                                      :pj_id            => PJ_ID,
#                                      :id               => expected_task_ids})
#    task_ids = tasks.collect do |task| task.id.to_s; end
#
#    assert_equal(expected_task_ids,
#                 task_ids)
#    logout
#  end
#
#  def test_008
#    access_task_management_page_as_root
#
#    open_individual_tab
#    expected_task_ids = get_col('individual', 'id')
#
#    # gets id from database
#    tasks = Task.find(:all,
#                      :order      => 'id desc',
#                      :conditions => {:analyze_type_id  => 2,
#                                      :pj_id            => PJ_ID,
#                                      :user_id          => 1,
#                                      :id               => expected_task_ids})
#    task_ids = tasks.collect do |task| task.id.to_s; end
#
#    assert_equal(expected_task_ids,
#                 task_ids)
#    logout
#  end
#
#  def test_009
#    access_task_management_page_as_root
#
#    open_other_tab
#
#    expected_task_ids = get_col('other', 'id')
#
#    # gets id from database
#    tasks = Task.find(:all,
#                      :order      => 'id desc',
#                      :conditions => ['analyze_type_id = ? AND pj_id = ? AND user_id != ? AND id IN (?)',
#                                      2,
#                                      PJ_ID,
#                                      1,
#                                      expected_task_ids ])
#
#    task_ids = tasks.collect do |task| task.id.to_s; end
#
#    assert_equal(expected_task_ids,
#                 task_ids)
#    logout
#  end
#
#  def test_010
#    access_task_management_page_as_root
#
#    # at the initial display, there is not task details
#    assert(is_element_not_present(element_locator('task_details')))
#    logout
#  end
#
#  def test_011
#    access_task_management_page_as_root
#
#    # moves mouse over a row
#    mouse_over(TASK_ROW)
#
#    #
#    row_style = get_style(TASK_ROW)
#
#    expected_row_style = TASK_STYLES['mouseover']
#
#    # background is bright
#    assert_equal(expected_row_style,
#                 row_style)
#
#    logout
#  end
#
#  def test_012
#    access_task_management_page_as_root
#
#    # moves mouse over a row
#    mouse_over(TASK_ROW)
#
#    #
#    row_style = get_style(TASK_ROW)
#
#    expected_row_style = TASK_STYLES['mouseover']
#
#    # text is red
#    assert_equal(expected_row_style,
#                 row_style)
#
#    logout
#  end
#
#
#  def test_013
#    check_task_background("waiting")
#  end
#
#  def test_014
#    check_task_background("analyzing")
#  end
#
#  def test_015
#    check_task_background("aborted")
#  end
#
#  def test_016
#    check_task_background("cancelled")
#  end
#
#  def test_017
#    check_task_background('completed')
#  end
#end
