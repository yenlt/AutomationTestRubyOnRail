require File.dirname(__FILE__) + "/../E1/test_e1_setup" unless defined? TestE1Setup

class TestE2 < Test::Unit::TestCase
  include TestE1Setup

  fixtures :tasks, :subtasks
  def test_035
    # this is not a test
    # It is consisted all 14 followed test cases
    assert(true)
  end

  def test_036
    task = Task.first
    # resets status of subtasks
    # all subtasks are on waiting
    subtask1 = task.subtask[0]
    subtask2 = task.subtask[1]

    subtask1.task_state_id = 1
    subtask2.task_state_id = 1
    subtask1.save
    subtask2.save
    task.task_state_id = 1
    task.save

    access_task_management_page_as_root
    view_task_details

    # our task is now on waiting
    task_explanation_xpath = element_locator('details')['state_explanation']
    task_explanation = get_text(task_explanation_xpath)
    assert_equal(TASK_STATUS_MESSAGES[1],
                 task_explanation)

    # The status of subtask1 is changed into 1=>2.
    subtask1.task_state_id = 2
    subtask1.save

    wait_for_element_text(task_explanation_xpath,
                          TASK_STATUS_MESSAGES[2])
    logout
  end

  def test_037
    task = Task.first
    # resets status of subtasks
    # all subtasks are on waiting
    subtask1 = task.subtask[0]
    subtask2 = task.subtask[1]

    subtask1.task_state_id = 1
    subtask2.task_state_id = 1
    subtask1.save
    subtask2.save
    task.task_state_id = 1
    task.save

    access_task_management_page_as_root
    view_task_details

    # The status of subtask1 is changed into 1=>2.
    subtask1.task_state_id = 2
    subtask1.save

    # The state of subtask1 changes "into analysis" from "waiting."
    subtask1_state_xpath = element_locator('details')['subtask1_state']
    wait_for_element_text(subtask1_state_xpath,
                          SUBTASK_STATUSES[2])

    logout
  end

  def test_038
    task = Task.first
    # resets status of subtasks
    # all subtasks are on waiting
    subtask1 = task.subtask[0]
    subtask2 = task.subtask[1]

    # subtask1 is now analyzing
    subtask1.task_state_id = 2
    subtask1.save
    # subtask2 is on waiting
    subtask2.task_state_id = 1
    subtask2.save
    task.task_state_id = 1
    task.save

    access_task_management_page_as_root
    view_task_details

    # The status of subtask2 is changed into 1=>2.
    subtask2.task_state_id = 2
    subtask2.save

    # The state of subtask2 changes "into analysis" from "waiting."
    subtask2_state_xpath = element_locator('details')['subtask2_state']
    wait_for_element_text(subtask2_state_xpath,
                          SUBTASK_STATUSES[2])

    logout
  end

  def test_039
    task = Task.first
    # resets status of subtasks
    # all subtasks are on waiting
    subtask1 = task.subtask[0]
    subtask2 = task.subtask[1]

    # subtask1, subtask2 is now analyzing
    subtask1.task_state_id = 2
    subtask1.save
    subtask2.task_state_id = 2
    subtask2.save
    task.task_state_id = 1
    task.save

    access_task_management_page_as_root
    view_task_details

    # The status of subtask1 is changed into 2=>5.
    subtask1.task_state_id = 5
    subtask1.save

    # The state of subtask1 changes to "completion" "out of analysis."
    subtask1_state_xpath = element_locator('details')['subtask1_state']
    wait_for_element_text(subtask1_state_xpath,
                          SUBTASK_STATUSES[5])

    logout
  end

  def test_040
    task = Task.first
    # resets status of subtasks
    # all subtasks are on waiting
    subtask1 = task.subtask[0]
    subtask2 = task.subtask[1]

    # subtask1, subtask2 is now analyzing
    subtask1.task_state_id = 2
    subtask1.save
    subtask2.task_state_id = 2
    subtask2.save
    task.task_state_id = 2
    task.save

    access_task_management_page_as_root
    view_task_details

    # The status of subtask1 is changed into 2=>5.
    subtask1.task_state_id = 5
    subtask1.save

    #The link of a [analysis result] becomes active.
    subtask1_result_link = element_locator('details')['subtask1_result']
    wait_for_element_present(subtask1_result_link)
    logout
  end

  def test_041
    task = Task.first
    # resets status of subtasks
    subtask1 = task.subtask[0]
    subtask2 = task.subtask[1]
    subtask1.task_state_id = 5
    subtask1.save
    subtask2.task_state_id = 2
    subtask2.save
    task.task_state_id = 2
    task.save

    access_task_management_page_as_root
    view_task_details

    # The status of subtask2 is changed into 2=>5.
    subtask2.task_state_id = 5
    subtask2.save

    # The analysis of this task changes a title to "it has completed."
    task_explanation_xpath = element_locator('details')['state_explanation']
    wait_for_element_text(task_explanation_xpath,
                          TASK_STATUS_MESSAGES[5])
    logout
  end

  def test_042
    task = Task.first
    # resets status of subtasks
    subtask1 = task.subtask[0]
    subtask2 = task.subtask[1]
    subtask1.task_state_id = 5
    subtask1.save
    subtask2.task_state_id = 2
    subtask2.save
    task.task_state_id = 2
    task.save

    access_task_management_page_as_root
    view_task_details

    # The status of subtask2 is changed into 2=>5.
    subtask2.task_state_id = 5
    subtask2.save

    # The state of subtask2 changes to "completion" "out of analysis."
    subtask2_state_xpath = element_locator('details')['subtask2_state']
    wait_for_element_text(subtask2_state_xpath,
                          SUBTASK_STATUSES[5])
    logout
  end

  def test_043
    task = Task.first
    # resets status of subtasks
    subtask1 = task.subtask[0]
    subtask2 = task.subtask[1]
    subtask1.task_state_id = 5
    subtask1.save
    subtask2.task_state_id = 2
    subtask2.save
    task.task_state_id = 2
    task.save

    access_task_management_page_as_root
    view_task_details

    # The status of subtask2 is changed into 2=>5.
    subtask2.task_state_id = 5
    subtask2.save

    # The link of a [analysis result] becomes active.
    subtask_result_link = element_locator('details')['subtask2_result']
    wait_for_element_present(subtask_result_link)
    logout
  end

  def test_044
    # not a test case
    assert(true)
  end

  def test_045
    test_037
  end

  def test_046
    test_038
  end

  def test_047
    test_039
  end

  def test_048
    task = Task.first
    # resets status of subtasks
    subtask1 = task.subtask[0]
    subtask2 = task.subtask[1]
    subtask1.task_state_id = 2
    subtask1.save
    subtask2.task_state_id = 2
    subtask2.save
    task.task_state_id = 2
    task.save

    access_task_management_page_as_root
    view_task_details
    #The status of subtask1 is changed into 2=>3.
    subtask1.task_state_id = 3
    subtask1.save

    # The state of subtask1 changes to "abnormalities" "out of analysis."
    subtask1_state = element_locator('details')['subtask1_state']
    wait_for_element_text(subtask1_state, SUBTASK_STATUSES[3])
    logout
  end

  def test_049
    task = Task.first
    # resets status of subtasks
    subtask1 = task.subtask[0]
    subtask2 = task.subtask[1]
    subtask1.task_state_id = 3
    subtask1.save
    subtask2.task_state_id = 2
    subtask2.save
    task.task_state_id = 2
    task.save

    access_task_management_page_as_root
    view_task_details
    #The status of subtask2 is changed into 2=>3.
    subtask2.task_state_id = 3
    subtask2.save

    # The state of subtask1 changes to "abnormalities" "out of analysis."
    subtask2_state = element_locator('details')['subtask2_state']
    wait_for_element_text(subtask2_state, SUBTASK_STATUSES[3])
    logout
  end

  def test_050
    task = Task.first
    # resets status of subtasks
    subtask1 = task.subtask[0]
    subtask2 = task.subtask[1]
    subtask1.task_state_id = 3
    subtask1.save
    subtask2.task_state_id = 2
    subtask2.save
    task.task_state_id = 2
    task.save

    access_task_management_page_as_root
    view_task_details
    #The status of subtask2 is changed into 2=>3.
    subtask2.task_state_id = 3
    subtask2.save

    # This task changes a title to "the abnormal end was carried out during analysis execution."
    task_explanation = element_locator('details')['state_explanation']

    wait_for_element_text(task_explanation,
                          TASK_STATUS_MESSAGES[3])
    logout
  end

  def test_051
    test_035
  end

  def test_052
    test_036
  end

  def test_053
    test_037
  end

  def test_054
    test_038
  end

  def test_055
    task = Task.first
    # resets status of subtasks
    subtask1 = task.subtask[0]
    subtask2 = task.subtask[1]
    subtask1.task_state_id = 2
    subtask1.save
    subtask2.task_state_id = 2
    subtask2.save
    task.task_state_id = 2
    task.save

    access_task_management_page_as_root
    view_task_details
    #The status of subtask1 is changed into 2=>4.
    subtask1.task_state_id = 4
    subtask1.save


    # The state of subtask1 changes to "cancellation" "out of analysis."
    subtask1_state = element_locator('details')['subtask1_state']
    wait_for_element_text(subtask1_state,
                          SUBTASK_STATUSES[4])

    logout
  end

  def test_056
    task = Task.first
    # resets status of subtasks
    subtask1 = task.subtask[0]
    subtask2 = task.subtask[1]
    subtask1.task_state_id = 4
    subtask1.save
    subtask2.task_state_id = 2
    subtask2.save
    task.task_state_id = 2
    task.save

    access_task_management_page_as_root
    view_task_details
    #The status of subtask1 is changed into 2=>4.
    subtask2.task_state_id = 4
    subtask2.save


    # This task changes [ "it was canceled" and ] a title.
    task_explanation = element_locator('details')['state_explanation']

    wait_for_element_text(task_explanation,
                          TASK_STATUS_MESSAGES[4])

    logout
  end

  def test_057
    task = Task.first
    # resets status of subtasks
    subtask1 = task.subtask[0]
    subtask2 = task.subtask[1]
    subtask1.task_state_id = 4
    subtask1.save
    subtask2.task_state_id = 2
    subtask2.save
    task.task_state_id = 2
    task.save

    access_task_management_page_as_root
    view_task_details
    #The status of subtask2 is changed into 2=>4.
    subtask2.task_state_id = 4
    subtask2.save


    # The state of subtask2 changes to "cancellation" "out of analysis."
    subtask2_state = element_locator('details')['subtask1_state']
    wait_for_element_text(subtask2_state,
                          SUBTASK_STATUSES[4])

    logout
  end
end
