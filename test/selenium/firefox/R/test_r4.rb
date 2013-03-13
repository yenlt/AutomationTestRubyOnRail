require File.dirname(__FILE__) + "/test_r_setup" unless defined? TestRSetup


 #Tests to check consistency between Analysis Result Report List,
 #Warning Listing and Comment Listing

class TestR4 < Test::Unit::TestCase
  include TestRSetup

  $old_review_status = true
  setup :setup_data
  def setup_data
    $old_review_status = set_subtask_publicized(SUB_ID, false)
  end

  def teardown
    set_subtask_publicized(SUB_ID, $old_review_status)
    Comment.delete_all
    @selenium.stop unless $selenium
    assert_equal [], @verification_errors
    write_log
  end

  
   #Check if the specified comment appears in comment listing
  
  def check_comment_exist_in_warning_list(warning_id, comment_text, comment_status)
    for i in [1, 2]
      if (i == 1) then # Warning listing page for subtask
        open_warning_listing_page_for_subtask
        sleep 5
        comment_text_xpath = "//tr[@id='warning_#{warning_id}']/td[11]"
        comment_status_xpath = "//tr[@id='warning_#{warning_id}']/td[12]"
      else # Warning listing page for file
        open_warning_listing_page_for_file
        sleep 5
        comment_text_xpath = "//tr[@id='warning_#{warning_id}']/td[8]"
        comment_status_xpath = "//tr[@id='warning_#{warning_id}']/td[9]"
      end

      actual_comment_text = get_text(comment_text_xpath)
      actual_comment_status = get_text(comment_status_xpath)
      assert_equal(comment_text, actual_comment_text)
      if (comment_status) then
        assert_equal(COMMENT_STATUSES["registered"], actual_comment_status)
      else
        assert_equal(COMMENT_STATUSES["temporary"], actual_comment_status)
      end
    end
  end

  def check_comment_not_exist_in_warning_list(warning_id)
    for i in [1, 2]
      if (i == 1) then # Warning listing page for subtask
        open_warning_listing_page_for_subtask
        sleep 5
        comment_text_xpath = "//tr[@id='warning_#{warning_id}']/td[11]"
        comment_status_xpath = "//tr[@id='warning_#{warning_id}']/td[12]"
        add_link_xpath = "//tr[@id='warning_#{warning_id}']/td[13]/a[1]"
      else # Warning listing page for file
        open_warning_listing_page_for_file
        sleep 5
        comment_text_xpath = "//tr[@id='warning_#{warning_id}']/td[8]"
        comment_status_xpath = "//tr[@id='warning_#{warning_id}']/td[9]"
        add_link_xpath = "//tr[@id='warning_#{warning_id}']/td[10]/a[1]"
      end

      actual_comment_text = get_text(comment_text_xpath)
      actual_comment_status = get_text(comment_status_xpath)
      assert_equal("", actual_comment_text)
      assert_equal("", actual_comment_status)
      assert_equal("["+_("Add")+"]", get_text(add_link_xpath))
    end
  end

  
  # Check if the specified comment appears in warning listing
  
  def check_comment_exist_in_comment_list(warning_id, comment_text, comment_status)
    for i in [1, 2]
      if (i == 1) then # Warning listing page for subtask
        open_comment_listing_page_for_subtask
        comment_text_xpath = "//tr[@id='warning_#{warning_id}']/td[11]"
        comment_status_xpath = "//tr[@id='warning_#{warning_id}']/td[12]"
      else # Warning listing page for file
        open_comment_listing_page_for_file
        comment_text_xpath = "//tr[@id='warning_#{warning_id}']/td[8]"
        comment_status_xpath = "//tr[@id='warning_#{warning_id}']/td[9]"
      end

      actual_comment_text = get_text(comment_text_xpath)
      actual_comment_status = get_text(comment_status_xpath)
      assert_equal(comment_text, actual_comment_text)
      if (comment_status) then
        assert_equal(_("Registered"), actual_comment_status)
      else
        assert_equal(_("Temporary Save"), actual_comment_status)
      end
    end
  end

  def check_comment_not_exist_in_comment_list(warning_id)
    for i in [1, 2]
      if (i == 1) then # Comment listing for subtask
        open_comment_listing_page_for_subtask
      else
        open_comment_listing_page_for_file
      end

      assert(is_element_not_present("//tr[@id='warning_#{warning_id}']"))
    end
  end

  
   #Check if the specified comment appears in analysis result report
  
  def check_comment_exist_in_result_report(warning_id, comment_text, comment_status)
    open_analysis_result_report_page
    click(element_xpath("show_comments_button"))
    sleep 2

     #Three buttons Comment, Edit and Delete must appears
    warning_xpath = "//div[@id='warning_#{warning_id}']"
    if (comment_status) then
      assert_equal("[Comment]", get_text("#{warning_xpath}/a[1]"))
      assert_equal("["+_("Edit")+"]", get_text("#{warning_xpath}/a[2]"))
      assert_equal("["+_("Delete")+"]", get_text("#{warning_xpath}/a[3]"))
      assert_equal(comment_text, get_text("#{warning_xpath}/div[1]/div[2]"))
    else
      assert_equal("["+_("Edit")+"]", get_text("#{warning_xpath}/a[1]"))
      assert_equal("["+_("Delete")+"]", get_text("#{warning_xpath}/a[2]"))
    end
  end

  def check_comment_not_exist_in_result_report(warning_id)
    open_analysis_result_report_page

    warning_xpath = "//div[@id='warning_#{warning_id}']"
   assert_equal("["+_("Add")+"]", get_text("#{warning_xpath}/a[1]"))
  end

  def test_223
    login_as_reviewer

    for i in (3871..3875)
      warning_id = i
      comment_text = "description of warning (#{warning_id})"

      if i == 3871 then
        open_analysis_result_report_page
        sleep 20
        click "//div[@id='warning_#{warning_id}']/a[1]"
        sleep 20
      elsif i == 3872 then
        open_warning_listing_page_for_subtask
        click "//tr[@id='warning_#{warning_id}']/td[13]/a[1]"
      elsif i == 3873 then
        open_warning_listing_page_for_file
        click "//tr[@id='warning_#{warning_id}']/td[10]/a[1]"
      elsif i == 3874 then
        warning_id = 3871
        open_comment_listing_page_for_subtask
        click "//tr[@id='warning_#{warning_id}']/td[13]/a[1]"
        comment_text = "new description of warning (#{warning_id})"
      else
        warning_id = 3872
        open_comment_listing_page_for_file
        click "//tr[@id='warning_#{warning_id}']/td[10]/a[1]"
        comment_text = "new description of warning (#{warning_id})"
      end

      register_comment(comment_text, true)
      check_comment_exist_in_warning_list(warning_id, comment_text, true)
      check_comment_exist_in_comment_list(warning_id, comment_text, true)
      check_comment_exist_in_result_report(warning_id, comment_text, true)
    end

    logout
  end

  def test_224
    login_as_reviewer

    for i in (3871..3875)
      warning_id = i
      comment_text = "description of warning (#{warning_id})"

      if i == 3871 then
        open_analysis_result_report_page
        click "//div[@id='warning_#{warning_id}']/a[1]"
      elsif i == 3872 then
        open_warning_listing_page_for_subtask
        click "//tr[@id='warning_#{warning_id}']/td[13]/a[1]"
      elsif i == 3873 then
        open_warning_listing_page_for_file
        click "//tr[@id='warning_#{warning_id}']/td[10]/a[1]"
      elsif i == 3874 then
        warning_id = 3871
        open_comment_listing_page_for_subtask
        click "//tr[@id='warning_#{warning_id}']/td[13]/a[1]"
        comment_text = "new description of warning (#{warning_id})"
      else
        warning_id = 3872
        open_comment_listing_page_for_file
        click "//tr[@id='warning_#{warning_id}']/td[10]/a[1]"
        comment_text = "new description of warning (#{warning_id})"
      end

      register_comment(comment_text, false)
      check_comment_exist_in_warning_list(warning_id, comment_text, false)
      check_comment_exist_in_comment_list(warning_id, comment_text, false)
      check_comment_exist_in_result_report(warning_id, comment_text, false)
    end

    logout
  end

  def test_225
    # create some comment
    $warnings = Warning.find(:all,
                            :joins        => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                            :limit        => 10,
                            :conditions   => { "source_codes.result_id" => RESULT_ID })

    $warnings.each do |warning|
      warning.comment = Comment.create(:risk_type_id        => 1,
                                       :warning_id          => warning.id,
                                       :warning_description => "original description for warning (#{warning.id})",
                                       :sample_source_code  => "original sample source code for warning (#{warning.id})",
                                       :status              => true)
    end

    # delete comments and check the consistency between pages
    login_as_reviewer

    for warning_id in (3871..3875)
      if warning_id == 3871 then
        open_analysis_result_report_page
        click "//div[@id='warning_#{warning_id}']/a[3]"
      elsif warning_id == 3872 then
        open_warning_listing_page_for_subtask
        click "//tr[@id='warning_#{warning_id}']/td[13]/a[2]"
      elsif warning_id == 3873 then
        open_warning_listing_page_for_file
        click "//tr[@id='warning_#{warning_id}']/td[10]/a[2]"
      elsif warning_id == 3874 then
        open_comment_listing_page_for_subtask
        click "//tr[@id='warning_#{warning_id}']/td[13]/a[2]"
      else
        open_comment_listing_page_for_file
        click "//tr[@id='warning_#{warning_id}']/td[10]/a[2]"
      end
      sleep 5
      assert_equal($messages["comment_deleting_confirmation"], get_confirmation)
      choose_ok_on_next_confirmation
      wait_for_text_present($messages["delete_comment_successfully"])

      check_comment_not_exist_in_warning_list(warning_id)
      check_comment_not_exist_in_comment_list(warning_id)
      check_comment_not_exist_in_result_report(warning_id)
    end

    logout
  end

  def test_226 # Performance test
    login_as_reviewer
    time1 = Time.now
    open_analysis_result_report_page
    time2 = Time.now

    assert(time2 - time1 < 15) # Render time < 15 seconds
  end
end