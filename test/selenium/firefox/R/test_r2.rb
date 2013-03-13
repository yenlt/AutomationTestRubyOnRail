require File.dirname(__FILE__) + "/test_r_setup" unless defined? TestRSetup

 #Comment Listing Page for a subtask tests

class TestR2A < Test::Unit::TestCase
  include TestRSetup

  def test_147
    # accesses Comment Listing page as a reviewer
    old_review_status = set_subtask_publicized(SUB_ID, false)
    access_comment_listing_page_for_subtask_as_reviewer
    # checks if the 3 buttons (WarningListing, Download CSV, Upload CSV exists
    assert(is_element_present($xpath["review"]["warning_listing_button"]))
    assert(is_element_present($xpath["review"]["download_csv_button"]))
    assert(is_element_present($xpath["review"]["upload_csv_button"]))
    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_148
    # Make the subtask publicized
    old_review_status = set_subtask_publicized(SUB_ID, true)
    # access Comment Listing page as a Pj member (general viewer)
    access_comment_listing_page_for_subtask_as_pj_member
    # check if Warning Listing button appears
    assert(is_element_present($xpath["review"]["warning_listing_button"]))
    logout
    # Change back status to original
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_149
    # Make the subtask publicized
    old_review_status = set_subtask_publicized(SUB_ID, true)
    # create a comment for a warning
    warnings = Warning.find_all_by_subtask_id(SUB_ID)
    assert(warnings.length > 0);
    warning = warnings[0];
    warning.comment = Comment.create(:risk_type_id        => 1,
                                     :warning_id          => warning.id,
                                     :warning_description => "description for warning (#{warning.id})",
                                     :sample_source_code  => "sample source code for warning (#{warning.id}",
                                     :status              => true)
    assert_equal(Comment.count_by_result_id_and_status(RESULT_ID, true), 1)
    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_subtask_as_reviewer
      else
        access_comment_listing_page_for_subtask_as_pj_member
      end
      # check the existence of search box
      assert(is_element_present($xpath["review"]["search_combobox"]))
      assert(is_element_present($xpath["review"]["search_textbox"]))
      assert(is_element_present($xpath["review"]["search_button"]))
      # check the existance of HTML table
      assert(is_element_present($xpath["review"]["warning_list_table"]))
      logout
    end
    # rollback
    warning.comment.destroy
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_150
    # Make the subtask publicized
    old_review_status = set_subtask_publicized(SUB_ID, true)
    assert_equal(0, Comment.count_by_result_id_and_status(RESULT_ID, true))
    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_subtask_as_reviewer
      else
        access_comment_listing_page_for_subtask_as_pj_member
      end
      # no comment ==> no comment table. a message appear
      assert(is_element_not_present($xpath["review"]["warning_list_table"]))
      assert(is_text_present($messages["warning_list_empty"]))
      logout
    end
    # rollback
    set_subtask_publicized(SUB_ID, old_review_status)
  end
end

 #These tests require at least 16 comments to run

class TestR2B < Test::Unit::TestCase
  include TestRSetup

  $warnings = []                 # All warnings with comments
  $registered_warnings = []      # Warnings with comments that are not temporarily saved
  NUMBER_OF_COMMENTS = 16       # Total number of warnings with comments

  setup :setup_data
  def setup_data
    # prepares some registered comments
    $warnings = Warning.find(:all,
                            :joins        => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                            :limit        => NUMBER_OF_COMMENTS,
                            :conditions   => { "source_codes.result_id" => RESULT_ID })


    $warning_id_0 = $warnings[0].id
    i = 0
    $warnings.each do |warning|


      status = true
      if i == 2 || i == 5 then
        status = false
      end
      warning.comment = Comment.create(:risk_type_id        => i % 7 + 1,
                                       :warning_id          => warning.id,
                                       :warning_description => "original description for warning (#{warning.id})",
                                       :sample_source_code  => "original sample source code for warning (#{warning.id})",
                                       :status              => status)
      i = i + 1
    end

    $registered_warnings = $warnings
    $registered_warnings.delete_at(5)
    $registered_warnings.delete_at(2)
  end

  def teardown
     # deletes all registered comments
    Comment.delete_all
    @selenium.stop unless $selenium
    assert_equal [], @verification_errors
    write_log
  end

  def test_151
    old_review_status = set_subtask_publicized(SUB_ID, true)
    for i in [1,2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_subtask_as_reviewer
      else
        access_comment_listing_page_for_subtask_as_pj_member
      end
      # Two pages are displayed
      assert(is_element_present(element_xpath("page_links")))
      assert(is_element_present(element_xpath("current_page")))
      assert_equal("1", get_text(element_xpath("current_page")))
      assert(is_element_present(element_xpath("disable_previous_page")))
      assert(is_element_present("link=2"))
      assert(is_element_present("link=Next »"))
      assert(is_element_not_present("link=3"))
      logout
    end
    set_subtask_publicized(SUB_ID, old_review_status)

  end

  def test_152
    old_review_status = set_subtask_publicized(SUB_ID, true)
    access_comment_listing_page_for_subtask_as_reviewer
    # Check HTML table
    $xpath["review"]["warning_list_headers"].each_with_index do |header, index|
      if index < 11 then
        assert_equal(WARNING_LIST_HEADERS[index], get_text(header))
      else # Action and Status not present
        assert(is_element_not_present(WARNING_LIST_HEADERS[index]))
      end
    end
    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end
#
  def test_153
    old_review_status = set_subtask_publicized(SUB_ID, false)
    access_comment_listing_page_for_subtask_as_reviewer
    # Check HTML table
    $xpath["review"]["warning_list_headers"].each_with_index do |header, index|
        assert_equal(WARNING_LIST_HEADERS[index], get_text(header))
    end
    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_154
    old_review_status = set_subtask_publicized(SUB_ID, true)
    access_comment_listing_page_for_subtask_as_pj_member
    # Check HTML table
    $xpath["review"]["warning_list_headers"].each_with_index do |header, index|
      if index < 11 then
        assert_equal(WARNING_LIST_HEADERS[index], get_text(header))
      else # Action and Status not present
        assert(is_element_not_present(WARNING_LIST_HEADERS[index]))
      end
    end
    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_155
    old_review_status = set_subtask_publicized(SUB_ID, false)
    access_comment_listing_page_for_subtask_as_reviewer
    # Comments at row 3 and 6 are temporarily saved - The rows are grey color
    expected_style = GRAY_STYLE[BROWSER]
    for i in [$warning_id_0+2,$warning_id_0+5]
      row_xpath = "//tr[@id='warning_#{i}']"
      row_style = get_attribute(row_xpath, "style")
      assert_equal(expected_style, row_style)
    end
    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_156
    old_review_status = set_subtask_publicized(SUB_ID, false)
    access_comment_listing_page_for_subtask_as_reviewer
    # [Edit] and [Delete] links are presented
    ($warning_id_0 .. $warning_id_0+9).each do |i|
      edit_link_xpath = "//tr[@id='warning_#{i}']/td[13]/a[1]"
      delete_link_xpath = "//tr[@id='warning_#{i}']/td[13]/a[2]"
      assert_equal("["+_("Edit")+"]", get_text(edit_link_xpath))
      assert_equal("["+_("Delete")+"]", get_text(delete_link_xpath))
    end
    click("link=2")
    sleep 5
    ($warning_id_0+10 .. $warning_id_0+NUMBER_OF_COMMENTS-1).each do |i|
      edit_link_xpath = "//tr[@id='warning_#{i}']/td[13]/a[1]"
      delete_link_xpath = "//tr[@id='warning_#{i}']/td[13]/a[2]"
      assert_equal("["+_("Edit")+"]", get_text(edit_link_xpath))
      assert_equal("["+_("Delete")+"]", get_text(delete_link_xpath))
    end
    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_157
    old_review_status = set_subtask_publicized(SUB_ID, true)

    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_subtask_as_reviewer
      else
        access_comment_listing_page_for_subtask_as_pj_member
      end
      # File name link to result report containing the warning
      warning = $warnings[0]
      file_name_link_xpath = "//tr[@id='warning_#{warning.id}']//td[4]/a"
      assert(is_element_present(file_name_link_xpath))
      href = get_attribute(file_name_link_xpath, "href") rescue ""
      expected_href = url_for(:controller => "review",
                              :action     => "view_result_report",
                              :pu         => PU_ID,
                              :pj         => PJ_ID,
                              :id         => ID,
                              :sub_id     => SUB_ID,
                              :result_id => warning.source_code.result_id)
      assert_equal(expected_href, href)
      logout
    end
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_158
    old_review_status = set_subtask_publicized(SUB_ID, true)

    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_subtask_as_reviewer
        sleep 5
      else
        access_comment_listing_page_for_subtask_as_pj_member
        sleep 5
      end
      sleep 2
      # click on Warning Listing button
      click($xpath["review"]["warning_listing_button"])
      wait_for_text_present($page_titles["review_view_warning_list"])
      logout
    end
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_159
    old_review_status = set_subtask_publicized(SUB_ID, true)

    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_subtask_as_reviewer
      else
        access_comment_listing_page_for_subtask_as_pj_member
      end
      # File name link to result report containing the warning
      warning = $warnings[0]
      file_name_link_xpath = "//tr[@id='warning_#{warning.id}']//td[4]/a"
      assert(is_element_present(file_name_link_xpath))
      click file_name_link_xpath
      # gets result_id from "href" attribute
      href = get_attribute(file_name_link_xpath, "href") rescue ""
      href      =~ /.*?result_id=(\d+).*?/
      result_id = $1
      result    = Result.find_by_id(result_id)
      # waits until the page title of "Analysis Result Report" page appears
      page_title = $page_titles["review_view_result_report"].sub("__FILE_NAME__",
                                                                  result.file_name)
      wait_for_text_present(page_title)
      logout
    end
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_160
    old_review_status = set_subtask_publicized(SUB_ID, true)
    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_subtask_as_reviewer
      else
        access_comment_listing_page_for_subtask_as_pj_member
      end
      # The first page displays warning list from 1 to 10
      for j in ($warning_id_0..$warning_id_0+11)
        if (j != $warning_id_0+2 && j != $warning_id_0+5) then # These two are temporarily saved
          wait_for_element_present("//tr[@id='warning_#{j}']")
        end
      end

      # Click the next page. Content should be changed
      click "link=2"
      for k in ($warning_id_0+12..$warning_id_0+NUMBER_OF_COMMENTS-1)
        wait_for_element_present("//tr[@id='warning_#{k}']")
      end
      logout
    end
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_161
    old_review_status = set_subtask_publicized(SUB_ID, false)
    # log in to comment listing page
    access_comment_listing_page_for_subtask_as_reviewer
    # click on edit link
    warning = $warnings[0]
    edit_link_xpath = "//tr[@id='warning_#{warning.id}']/td[13]/a[1]"
    wait_for_element_present(edit_link_xpath)
    click(edit_link_xpath)
    comment_editor
    # The subwindow has "Delete" link
   assert(is_element_present(element_xpath("delete_link")))
    # check the contents of the window
    expected_warning_description = warning.comment.warning_description
    expected_sample_source_code  = warning.comment.sample_source_code
    warning_description, sample_source_code = get_comment_editor_contents
    # the contents of the textboxes must be similar to the record in database
    assert_equal(expected_warning_description, warning_description)
    assert_equal(expected_sample_source_code, sample_source_code)
    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_162
    old_review_status = set_subtask_publicized(SUB_ID, false)
    # log in to comment listing page
    access_comment_listing_page_for_subtask_as_reviewer
    # click on delete link
    warning = $warnings[0]
    delete_link_xpath = "//tr[@id='warning_#{warning.id}']/td[13]/a[2]"
    wait_for_element_present(delete_link_xpath)
    click(delete_link_xpath)
    # check that confirmation message is correct
    assert_equal($messages["comment_deleting_confirmation"], get_confirmation())
    choose_cancel_on_next_confirmation
    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_163
    old_review_status = set_subtask_publicized(SUB_ID, false)
    # log in to comment listing page
    access_comment_listing_page_for_subtask_as_reviewer
    # click on delete link
    warning = $warnings[0]
    delete_link_xpath = "//tr[@id='warning_#{warning.id}']/td[13]/a[2]"
    click(delete_link_xpath)
    assert_equal($messages["comment_deleting_confirmation"], get_confirmation())
    choose_ok_on_next_confirmation
    # check that the comment is deleted
    wait_for_element_not_present("//tr[@id='warning_#{warning.id}']")
    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_164
    old_review_status = set_subtask_publicized(SUB_ID, true)
    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_subtask_as_reviewer
      else
        access_comment_listing_page_for_subtask_as_pj_member
      end
      # by default, ID is sorted ascendingly
      id_header_style = get_attribute($xpath["review"]["warning_list_headers"][0], "class")
      assert_equal(HEADER_STYLES["sortup"], id_header_style)
      # check that the ID column's values are sorted correctly
      for j in (2..9)
        id_text = get_text("//tbody/tr[#{j}]/td[1]")
        id_text_next = get_text("//tbody/tr[#{j+1}]/td[1]")
        assert(Integer(id_text) <= Integer(id_text_next))
      end
      logout
    end
     set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_165
    old_review_status = set_subtask_publicized(SUB_ID, true)
    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_subtask_as_reviewer
      else
        access_comment_listing_page_for_subtask_as_pj_member
      end
      # sort ID column descendingly
      click("#{$xpath["review"]["warning_list_headers"][0]}/a")
      wait_for_attribute($xpath["review"]["warning_list_headers"][0], "class", HEADER_STYLES["sortdown"])
      # check that the ID column's values are sorted correctly
      (2..9).each do |j|
        id_text = get_text("//tbody/tr[#{j}]/td[1]")
        id_text_next = get_text("//tbody/tr[#{j+1}]/td[1]")
        assert(Integer(id_text) >= Integer(id_text_next))
      end
      # sort other columns up and check style
      (1..6).each do |j|
        column_header_style = get_attribute($xpath["review"]["warning_list_headers"][j], "class")
        assert_equal(HEADER_STYLES["nosort"], column_header_style)
        click("#{$xpath["review"]["warning_list_headers"][j]}/a")
        wait_for_attribute($xpath["review"]["warning_list_headers"][j], "class", HEADER_STYLES["sortup"])
      end
      logout
    end
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_166
    old_review_status = set_subtask_publicized(SUB_ID, true)
    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_subtask_as_reviewer
      else
        access_comment_listing_page_for_subtask_as_pj_member
      end
      # sort all columns down and check style
      for j in (1..6)
        column_header_style = get_attribute($xpath["review"]["warning_list_headers"][j], "class")
        assert_equal(HEADER_STYLES["nosort"], column_header_style)
        click("#{$xpath["review"]["warning_list_headers"][j]}/a")
        wait_for_attribute($xpath["review"]["warning_list_headers"][j], "class", HEADER_STYLES["sortup"])
        click("#{$xpath["review"]["warning_list_headers"][j]}/a")
        wait_for_attribute($xpath["review"]["warning_list_headers"][j], "class", HEADER_STYLES["sortdown"])
      end
      logout
    end
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_167
    old_review_status = set_subtask_publicized(SUB_ID, true)
    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_subtask_as_reviewer
      else
        access_comment_listing_page_for_subtask_as_pj_member
      end
      # check the search types inside combobox
      for j in (0..3)
        wait_for_element_present($xpath["review"]["search_combobox_options"][j])
      end
    end
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_168
    old_review_status = set_subtask_publicized(SUB_ID, true)
    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_subtask_as_reviewer
      else
        access_comment_listing_page_for_subtask_as_pj_member
      end
      # Search rule number
      expected_warnings = []
      expected_warnings =  Warning.find(
        :all,
        :joins       => "LEFT OUTER JOIN  comments    ON comments.warning_id  = warnings.id",
        :conditions  => { "rule" => "0839", "comments.status" => true }
      )
      check_search_result(_("Rule number"), "    0839  ", expected_warnings)
      check_search_result(_("Rule number"), "   0839 0839", expected_warnings)
      check_search_result(_("Rule number"), "   00839 0839", expected_warnings)
      check_search_result(_("Rule number"), "   01 0839", expected_warnings)
      expected_warnings.clear
      expected_warnings = Warning.find(
        :all,
        :joins      => "LEFT OUTER JOIN comments ON comments.warning_id = warnings.id",
        :conditions => [ "(rule = '0839' OR rule = '2017') AND comments.status = true"]
      )
      check_search_result(_("Rule number"), "0839         2017", expected_warnings)

      # Search directory
      check_search_result(_("Directory"), "sample_c/src", $registered_warnings)
      check_search_result(_("Directory"), "haha\/\"\\ 'users'", 0)
      # Search file name and source name
      check_search_result(_("File name"), "analyzeme.c.Critical.html", $registered_warnings)
      check_search_result("Source name", "analyzeme.c", $registered_warnings)
      logout
    end

    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_169
    old_review_status = set_subtask_publicized(SUB_ID, true)
    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_subtask_as_reviewer
      else
        access_comment_listing_page_for_subtask_as_pj_member
      end
      # Search with regular expression
      check_search_result(_("Directory"), "*", $registered_warnings)
      check_search_result(_("Directory"), "*src", $registered_warnings)
      check_search_result(_("Source name"), "[a-z\.]+", $registered_warnings)
      expected_warnings = Warning.find(
        :all,
        :joins      => "LEFT OUTER JOIN comments ON comments.warning_id = warnings.id",
        :conditions => ["comments.status = true AND rule REGEXP '08[0-9]+'"]
      )
      check_search_result(_("Rule number"), "08??", expected_warnings)
      check_search_result(_("File name"), "", $registered_warnings)
      logout
    end
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_170
    old_review_status = set_subtask_publicized(SUB_ID, true)
    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_subtask_as_reviewer
      else
        access_comment_listing_page_for_subtask_as_pj_member
      end
      check_search_result(_("Source name"), "[0-9]+", 0)
      check_search_result(_("Directory"), "abc def", 0)
      check_search_result(_("File name"), "*Medium*", 0)
      check_search_result(_("Rule number"), "0", 0)
      logout
    end

    set_subtask_publicized(SUB_ID, old_review_status)
  end
#
  def test_171
    old_review_status = set_subtask_publicized(SUB_ID, true)
    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_subtask_as_reviewer
      else
        access_comment_listing_page_for_subtask_as_pj_member
      end
      check_search_result("Source name", "", $registered_warnings)
      logout
    end
    set_subtask_publicized(SUB_ID, old_review_status)
  end

##  def test_172
##    # this test cases can not be implemented because Selenium does not support download function
##    assert(false)
##  end
##
##  def test_173
##    # this test cases can not be implemented because Selenium does not support download function
##    assert(false)
##  end

  def test_174
    old_review_status = set_subtask_publicized(SUB_ID, false)

    access_comment_listing_page_for_subtask_as_reviewer
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])
    type(element_xpath("upload_file_browser"),
         CSV_FILES["invalid_format"])
    sleep(5)
    click element_xpath("upload_file_button")
    expected_message  = $messages["no_csv_file_selected"]
    message           = get_alert
    verify_equal(expected_message, message)

    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_175
    old_review_status = set_subtask_publicized(SUB_ID, false)
    access_comment_listing_page_for_subtask_as_reviewer
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])
    click element_xpath("upload_file_button")
    wait_for_text_not_present($window_titles["upload_csv_file"])
    expected_message  = $messages["no_csv_file_selected"]
    message           = get_alert
    verify_equal(expected_message, message)
    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_176
    old_review_status = set_subtask_publicized(SUB_ID, false)
    access_comment_listing_page_for_subtask_as_reviewer
    # selects file to upload
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])
    type_csv_upload_file(CSV_FILES["1mb"],CSV_FILES["1mb_ja"])
    click element_xpath("upload_file_button")
    # waits untill sucessful message is displayed
    wait_for_text_present($messages["upload_csv_successully"])
    sleep 2
    # the uploaded file contains comments for first 10 warnings
    ($warning_id_0..$warning_id_0+9).each do |index|
      cell_xpath        = "//tr[@id='warning_#{index}']/td[11]"
      expected_comment  = "description for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment, comment)
    end
    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_177
    old_review_status = set_subtask_publicized(SUB_ID, false)
    access_comment_listing_page_for_subtask_as_reviewer

    # selects file to upload
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])
    if ($lang == 'en')
    type(element_xpath("upload_file_browser"),CSV_FILES["1row"])
    else
      type(element_xpath("upload_file_browser"),CSV_FILES["1row_ja"])
    end
    # clicks on "Upload" button
    click element_xpath("upload_file_button")
    # waits untill sucessful message is displayed
    wait_for_text_present($messages["upload_csv_successully"])
    # but no new comment
    ($warning_id_0..$warning_id_0+9).each do |index|
      cell_xpath        = "//tr[@id='warning_#{index}']/td[11]"
      expected_comment  = "original description for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment, comment)
    end
    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_178
    old_review_status = set_subtask_publicized(SUB_ID, false)
    access_comment_listing_page_for_subtask_as_reviewer
    # selects file to upload
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])
    type(element_xpath("upload_file_browser"),
         CSV_FILES["error_file"])
    # clicks on "Upload" button
    click element_xpath("upload_file_button")

    # waits untill sucessful message is displayed
    wait_for_text_present($messages["upload_csv_failed3"])

    # but no new comment
    ($warning_id_0..$warning_id_0+9).each do |index|
      cell_xpath        = "//tr[@id='warning_#{index}']/td[11]"
      expected_comment  = "original description for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment, comment)
    end
    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_179
    test_176 # this is already checked in test_176
  end

  def test_180
    old_review_status = set_subtask_publicized(SUB_ID, false)
    access_comment_listing_page_for_subtask_as_reviewer
    # selects file to upload
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])

    type_csv_upload_file(CSV_FILES["1mb_2"],CSV_FILES["1mb_2_ja"])

    click element_xpath("upload_file_button")
    # waits until sucessful message is displayed
    wait_for_text_present($messages["upload_csv_successully"])
    # the uploaded file contains updated comments for first 10 warnings
    ($warning_id_0..$warning_id_0+9).each do |index|
      cell_xpath        = "//tr[@id='warning_#{index}']/td[11]"
      expected_comment  = "description for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment, comment)
    end
    # the uploaded file contains 4 new comments for RESULT_ID = 1
    click ("link=2")
    sleep 5
    ($warning_id_0+10..$warning_id_0+NUMBER_OF_COMMENTS-1).each do |index|
      cell_xpath        = "//tr[@id='warning_#{index}']/td[11]"
      expected_comment  = "original description for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment, comment)
      cell_xpath        = "//tr[@id='warning_#{index}']/td[12]"
      status           = get_text(cell_xpath)
      assert_equal(COMMENT_STATUSES["registered"], status)
    end
    ($warning_id_0+1000..$warning_id_0+1002).each do |index|
      cell_xpath        = "//tr[@id='warning_#{index}']/td[11]"
      expected_comment  = "New comment for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment, comment)
      cell_xpath        = "//tr[@id='warning_#{index}']/td[12]"
      status           = get_text(cell_xpath)
      assert_equal(COMMENT_STATUSES["registered"], status)
    end
    # the uploaded file contains 4 new comments for RESULT_ID = 4
    click ("link=3")
    sleep 5
    ($warning_id_0+1290..$warning_id_0+1292).each do |index|
      cell_xpath        = "//tr[@id='warning_#{index}']/td[11]"
      expected_comment  = "New comment for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment, comment)
      cell_xpath        = "//tr[@id='warning_#{index}']/td[12]"
      status           = get_text(cell_xpath)
      assert_equal(COMMENT_STATUSES["registered"], status)
    end
    assert(is_element_not_present("link=4"))
    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end
#
  def upload_with_file_size_test(csv_file, sleep_time)
    old_review_status = set_subtask_publicized(SUB_ID, false)
    access_comment_listing_page_for_subtask_as_reviewer
    # selects file to upload
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])
    type(element_xpath("upload_file_browser"), csv_file)
    click element_xpath("upload_file_button")
    # waits untill sucessful message is displayed
    wait_for_text_present($messages["upload_csv_successully"])
    sleep sleep_time

    # the uploaded file contains comments for first 10 warnings
    ($warning_id_0..$warning_id_0+9).each do |index|
      cell_xpath        = "//tr[@id='warning_#{index}']/td[11]"
      expected_comment  = "description for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment, comment)
    end
    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end
  def test_181
    if ($lang == 'en')
       upload_with_file_size_test(CSV_FILES["1mb"], 5)
    else
      upload_with_file_size_test(CSV_FILES["1mb_ja"], 5)
    end
  end
##  def test_182
##    test false
##    upload_with_file_size_test(CSV_FILES["2mb"], 5)
##  end
##
##  def test_183
##    test false
##    upload_with_file_size_test(CSV_FILES["5mb"], 8)
##  end
##
##  def test_184
##    test false
##    upload_with_file_size_test(CSV_FILES["10mb"], 10)
##  end
  def test_185
    old_review_status = set_subtask_publicized(SUB_ID, false)
    expected_message  = _("Upload  fails:  The  subtask  is  publicized.")
    access_comment_listing_page_for_subtask_as_reviewer
    # not change the task to be publicized
    set_subtask_publicized(SUB_ID, true)
    sleep(1)
    # selects file to upload
    click element_xpath("upload_csv_button")
    wait_for_text_present(expected_message)
    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end
end
