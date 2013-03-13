require File.dirname(__FILE__) + '/../test_helper'

class ContextNotifierTest < ActiveSupport::TestCase
  fixtures :tasks
  PJ_ID = 1
  TASK_ID = 5
  SUBTASK_ID = 10
  OLD_STATE_ID = 1
  NEW_STATE_ID = 2
  WRONG_ID = 1000
  ############################################################################
  # Test ContextNotifier Model in [Email Notification Function]                 #

  ##
  # Test: email_message(task_id, subtask_id, event_id, old_state_id, new_state_id)
  #
  # Input:  + event_id = 1  # Subtask state is changed
  # Return: ~= /has changed from (__OLD_STATE__) state to (__NEW_STATE__) state/
  #
  def test_ut_t5_sef_con_001
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID,
        :analyze_process_event_id => AnalyzeProcessEvent::EVENT_IDS[:change]})
    email_message = ContextNotifier.email_message(TASK_ID,SUBTASK_ID,
      AnalyzeProcessEvent::EVENT_IDS[:change],OLD_STATE_ID,NEW_STATE_ID)
    assert email_message.include?("has changed from")
  end
  # Input:  + event_id = 2 # Subtask is time out
  # Return: ~= /for more than maximum time/
  #
  def test_ut_t5_sef_con_002
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID,
        :analyze_process_event_id => AnalyzeProcessEvent::EVENT_IDS[:time_out]})
    email_message = ContextNotifier.email_message(TASK_ID,SUBTASK_ID,
      AnalyzeProcessEvent::EVENT_IDS[:time_out],OLD_STATE_ID,NEW_STATE_ID)
    assert email_message.include?("for more than maximum time")
  end
  # Input: + event_id = 3 # At least 1 waiting task but no analyzing task
  # Return: ~= /Error: There is one or more waiting task(s) but no tasking is running./
  #
  def test_ut_t5_sef_con_003
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID,
        :analyze_process_event_id => AnalyzeProcessEvent::EVENT_IDS[:waiting_but_no_analyzing]})
    email_message = ContextNotifier.email_message(TASK_ID,SUBTASK_ID,
      AnalyzeProcessEvent::EVENT_IDS[:waiting_but_no_analyzing],OLD_STATE_ID,NEW_STATE_ID)
    assert email_message.include?("Error: There is one or more waiting task(s) but no tasking is running")
  end
  # Input: + event_id = 4 # Subtask is deleted
  # Return: ~= /has been deleted/
  #
  def test_ut_t5_sef_con_004
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID,
        :analyze_process_event_id => AnalyzeProcessEvent::EVENT_IDS[:delete]})
    email_message = ContextNotifier.email_message(TASK_ID,SUBTASK_ID,
      AnalyzeProcessEvent::EVENT_IDS[:delete],OLD_STATE_ID,NEW_STATE_ID)
    assert email_message.include?("has been deleted")
  end
  # Input: + event_id = 5 # Database is unable to be connected
  # Return: ~= /Error: Cannot access database./
  #
  def test_ut_t5_sef_con_005
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID,
        :analyze_process_event_id => AnalyzeProcessEvent::EVENT_IDS[:change]})
    email_message = ContextNotifier.email_message(TASK_ID,SUBTASK_ID,
      AnalyzeProcessEvent::EVENT_IDS[:error_db],OLD_STATE_ID,NEW_STATE_ID)
    assert email_message.include?("Error: Cannot access database.")
  end
  # Input: + event_id = 6 # Task is created
  # Return: ~= /Task ID (__TASK_ID__) that was register at (__TIME__)/
  #
  def test_ut_t5_sef_con_006
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID,
        :analyze_process_event_id => AnalyzeProcessEvent::EVENT_IDS[:change]})
    email_message = ContextNotifier.email_message(TASK_ID,SUBTASK_ID,
      AnalyzeProcessEvent::EVENT_IDS[:create],OLD_STATE_ID,NEW_STATE_ID)
    assert email_message.include?("Task ID (#{TASK_ID}) that was register at")
  end
  # Input: + event_id = WRONG_ID # The event_id is out side of the email list
  # Return: Blank email message
  #
  def test_ut_t5_sef_con_007
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID,
        :analyze_process_event_id => AnalyzeProcessEvent::EVENT_IDS[:change]})
    email_message = ContextNotifier.email_message(TASK_ID,SUBTASK_ID,
      WRONG_ID,OLD_STATE_ID,NEW_STATE_ID)
    assert email_message.blank?
  end

  ##
  # Test: email_title(event_id)
  #
  # Input: + event_id = 1 # Subtask state is changed
  # Return: ~= /Subtask state is changed/
  #
  def test_ut_t5_sef_con_008
#    email_setting = EmailSetting.find(:first,
#      :conditions => { :pj_id => PJ_ID,
#        :analyze_process_event_id => AnalyzeProcessEvent::EVENT_IDS[:change]})
    email_title = ContextNotifier.email_title(AnalyzeProcessEvent::EVENT_IDS[:change])
    assert email_title.include?("Subtask state is changed")
  end
  # Input: + event_id = 2 # Subtask is time out
  # Return: ~= /Subtask is timeout/
  #
  def test_ut_t5_sef_con_009
#    email_setting = EmailSetting.find(:first,
#      :conditions => { :pj_id => PJ_ID,
#        :analyze_process_event_id => AnalyzeProcessEvent::EVENT_IDS[:time_out]})
    email_title = ContextNotifier.email_title(AnalyzeProcessEvent::EVENT_IDS[:time_out])
    assert email_title.include?("Subtask is timeout")
  end
  # Input: + event_id = 3 # At least 1 waiting task but no analyzing task
  # Return: ~= /There is at least 1 waiting task but no analyzing task/
  #
  def test_ut_t5_sef_con_010
#    email_setting = EmailSetting.find(:first,
#      :conditions => { :pj_id => PJ_ID,
#        :analyze_process_event_id => AnalyzeProcessEvent::EVENT_IDS[:waiting_but_no_analyzing]})
    email_title = ContextNotifier.email_title(AnalyzeProcessEvent::EVENT_IDS[:waiting_but_no_analyzing])
    assert email_title.include?("There is at least 1 waiting task but no analyzing task")
  end
  # Input: + event_id = 4 # Subtask is deleted
  # Return: ~= /Subtask is deleted/
  #
  def test_ut_t5_sef_con_011
#    email_setting = EmailSetting.find(:first,
#      :conditions => { :pj_id => PJ_ID,
#        :analyze_process_event_id => AnalyzeProcessEvent::EVENT_IDS[:delete]})
    email_title = ContextNotifier.email_title(AnalyzeProcessEvent::EVENT_IDS[:delete])
    assert email_title.include?("Subtask is deleted")
  end
  # Input: + event_id = 5 # Database is unable to be connected
  # Return: ~= /Cannot connect to database/
  #
  def test_ut_t5_sef_con_012
#    email_setting = EmailSetting.find(:first,
#      :conditions => { :pj_id => PJ_ID,
#        :analyze_process_event_id => AnalyzeProcessEvent::EVENT_IDS[:change]})
    email_title = ContextNotifier.email_title(AnalyzeProcessEvent::EVENT_IDS[:error_db])
    assert email_title.include?("Cannot connect to database")
  end
  # Input: + event_id = 6 # Subtask is created.
  # Return: ~= /Subtask is created/
  #
  def test_ut_t5_sef_con_013
#    email_setting = EmailSetting.find(:first,
#      :conditions => { :pj_id => PJ_ID,
#        :analyze_process_event_id => AnalyzeProcessEvent::EVENT_IDS[:change]})
    email_title = ContextNotifier.email_title(AnalyzeProcessEvent::EVENT_IDS[:create])
    assert email_title.include?("Subtask is created")
  end
  # Input: + event_id = WRONG_ID # The event_id is out side of the email list
  # Return: Blank email message
  #
  def test_ut_t5_sef_con_014
#    email_setting = EmailSetting.find(:first,
#      :conditions => { :pj_id => PJ_ID,
#        :analyze_process_event_id => AnalyzeProcessEvent::EVENT_IDS[:change]})
    email_title = ContextNotifier.email_title(WRONG_ID)
    assert email_title.blank?
  end

  ##
  # Test: send_email(email_setting, task_id, subtask_id, event_id, old_state_id, new_state_id)
  #
  # Input: + event_id = 1 # Subtask state is changed
  #        + task_id, subtask_id, event_id, old_state_id, new_state_id
  # Return: Successful send email
  def test_ut_t5_sef_con_015
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID,
        :analyze_process_event_id => AnalyzeProcessEvent::EVENT_IDS[:change]})
    assert ContextNotifier.send_email(email_setting,TASK_ID,SUBTASK_ID,
      AnalyzeProcessEvent::EVENT_IDS[:change],OLD_STATE_ID,NEW_STATE_ID)
    # manually test by checking the mail.
  end
  # Input: + event_id = 2 # Subtask is time out
  #        + task_id, subtask_id, event_id, old_state_id, new_state_id
  # Return: Successful send email
  def test_ut_t5_sef_con_016
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID,
        :analyze_process_event_id => AnalyzeProcessEvent::EVENT_IDS[:time_out]})
    assert ContextNotifier.send_email(email_setting,TASK_ID,SUBTASK_ID,
      AnalyzeProcessEvent::EVENT_IDS[:time_out],OLD_STATE_ID,NEW_STATE_ID)
    # manually test by checking the mail.
  end
  # Input: + event_id = 4 # Subtask is deleted.
  #        + subtask_id
  # Return: Successful send email
  def test_ut_t5_sef_con_017
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID,
        :analyze_process_event_id => AnalyzeProcessEvent::EVENT_IDS[:delete]})
    assert ContextNotifier.send_email(email_setting,TASK_ID,SUBTASK_ID,
      AnalyzeProcessEvent::EVENT_IDS[:delete],OLD_STATE_ID,NEW_STATE_ID)
    # manually test by checking the mail.
  end
  # Input: + event_id = 6
  #        + task_id, Time
  # Return: Successful send email
  def test_ut_t5_sef_con_018
    email_setting = EmailSetting.find(:first,
      :conditions => { :pj_id => PJ_ID,
        :analyze_process_event_id => AnalyzeProcessEvent::EVENT_IDS[:change]})
    assert ContextNotifier.send_email(email_setting,TASK_ID,SUBTASK_ID,
      AnalyzeProcessEvent::EVENT_IDS[:create],OLD_STATE_ID,NEW_STATE_ID)
    # manually test by checking the mail.
  end

  ##
  # Test: self.send_email_waiting_but_no_analyzing
  #
  # Input: N/A
  # Return: Successful send email
  #
  def test_ut_t5_sef_con_019
    assert ContextNotifier.send_email_waiting_but_no_analyzing
    # manually test by checking the mail.
  end
  ##
  # Test: self.send_email_error_db(user_email)
  #
  # Input: N/A
  # Return: Successful send email
  #
  def test_ut_t5_sef_con_020
    assert ContextNotifier.send_email_error_db()
    # manually test by checking the mail.
  end
  ############################################################################
end