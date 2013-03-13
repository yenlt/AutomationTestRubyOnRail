require File.dirname(__FILE__) + "/test_r_setup" unless defined? TestRSetup


 #Comment Listing Page of a result report

class TestR3A < Test::Unit::TestCase
  include TestRSetup

 def test_186
   printf "\n+ Test 186"
    # accesses Comment Listing page as a reviewer
    old_review_status = set_subtask_publicized(SUB_ID, false)
    access_comment_listing_page_for_file_as_reviewer
    sleep(10)
    # checks if the 3 buttons (WarningListing, Download CSV, Upload CSV exists
    assert(is_element_present($xpath["review"]["warning_listing_button"]))
    assert(is_element_present($xpath["review"]["download_csv_button"]))
    assert(is_element_present($xpath["review"]["upload_csv_button"]))

    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_187
    printf "\n+ Test 187"
    # Make the subtask publicized
    old_review_status = set_subtask_publicized(SUB_ID, true)

    # access Comment Listing page as a Pj member (general viewer)
    access_comment_listing_page_for_file_as_pj_member

    # check if Warning Listing button appears
    assert(is_element_present($xpath["review"]["warning_listing_button"]))
    logout

    # Change back status to original
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_188
    printf "\n+ Test 188"
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
        access_comment_listing_page_for_file_as_reviewer
      else
        access_comment_listing_page_for_file_as_pj_member
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

  def test_189
    printf "\n+ Test 189"
    # Make the subtask publicized
    old_review_status = set_subtask_publicized(SUB_ID, true)
    assert_equal(Comment.count_by_result_id_and_status(RESULT_ID, true), 0)

    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_file_as_reviewer
      else
        access_comment_listing_page_for_file_as_pj_member
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

class TestR3B < Test::Unit::TestCase
  include TestRSetup

  $warnings = []                 # All warnings with comments
  $registered_warnings = []     # Warnings with comments that are not temporarily saved
  NUMBER_OF_COMMENTS = 16       # Total number of warnings with comments

  setup :setup_data
  def setup_data
     #Add warnings for RESULT_ID = 7
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

     #Add some extra warnings for other RESULT_ID, this is to check
     #that the comment list does not contain any warning from other Results
    extra_warnings = Warning.find(:all,
                                  :joins      => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                                  :limit      => NUMBER_OF_COMMENTS / 2,
                                  :conditions => { "source_codes.result_id" => RESULT_ID + 1 })
    extra_warnings.each do |warning|
      warning.comment = Comment.create(:risk_type_id        => i % 7 + 1,
                                       :warning_id          => warning.id,
                                       :warning_description => "original description for warning (#{warning.id})",
                                       :sample_source_code  => "original sample source code for warning (#{warning.id})",
                                       :status              => true)
    end

    $registered_warnings = $warnings
    $registered_warnings.delete_at(5)
    $registered_warnings.delete_at(2)
  end

  def teardown
      deletes all registered comments
    Comment.delete_all
    @selenium.stop unless $selenium
    assert_equal [], @verification_errors
    write_log
  end

  def test_190
    printf "\n+ Test 190"
    old_review_status = set_subtask_publicized(SUB_ID, true)

    for i in [1,2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_file_as_reviewer
      else
        access_comment_listing_page_for_file_as_pj_member
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

  def test_191
    printf "\n+ Test 191"
    old_review_status = set_subtask_publicized(SUB_ID, true)

    access_comment_listing_page_for_file_as_reviewer

    # Check HTML table
    $xpath["review"]["warning_list_headers"].each_with_index do |header, index|
      if index == 0 then
        assert_equal(WARNING_LIST_HEADERS[index], get_text(header))
      elsif (index >= 1 && index <= 7) then # Directory, Source and File name not present
        assert_equal(WARNING_LIST_HEADERS[index + WARNING_LIST_HEADER_SUBTASK_AND_FILE_DIFF],
                    get_text(header))
      else
        assert(is_element_not_present(WARNING_LIST_HEADERS[index]))
      end
    end

    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_192
    printf "\n+ Test 192"
    old_review_status = set_subtask_publicized(SUB_ID, false)

    access_comment_listing_page_for_file_as_reviewer

    # Check HTML table
    $xpath["review"]["warning_list_headers"].each_with_index do |header, index|
      if index == 0 then
        assert_equal(WARNING_LIST_HEADERS[index], get_text(header))
      elsif (index >= 1 && index <= 9) then # Directory, Source and File name not present
        assert_equal(WARNING_LIST_HEADERS[index + WARNING_LIST_HEADER_SUBTASK_AND_FILE_DIFF],
                    get_text(header))
      else
        assert(is_element_not_present(WARNING_LIST_HEADERS[index]))
      end
    end

    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_193
    printf "\n+ Test 193"
    old_review_status = set_subtask_publicized(SUB_ID, true)

    access_comment_listing_page_for_file_as_pj_member

    # Check HTML table
    $xpath["review"]["warning_list_headers"].each_with_index do |header, index|
     if index == 0 then
        assert_equal(WARNING_LIST_HEADERS[index], get_text(header))
      elsif (index >= 1 && index <= 7) then # Directory, Source and File name not present
        assert_equal(WARNING_LIST_HEADERS[index + WARNING_LIST_HEADER_SUBTASK_AND_FILE_DIFF],
                    get_text(header))
      else
        assert(is_element_not_present(WARNING_LIST_HEADERS[index]))
      end
    end

    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_194
    printf "\n+ Test 194"
    old_review_status = set_subtask_publicized(SUB_ID, false)

    access_comment_listing_page_for_file_as_reviewer

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

  def test_195
    printf "\n+ Test 195"
    old_review_status = set_subtask_publicized(SUB_ID, false)

    access_comment_listing_page_for_file_as_reviewer

    # [Edit] and [Delete] links are presented
    for i in ($warning_id_0 .. $warning_id_0+9)
      edit_link_xpath = "//tr[@id='warning_#{i}']/td[10]/a[1]"
      delete_link_xpath = "//tr[@id='warning_#{i}']/td[10]/a[2]"
      assert_equal("["+_("Edit")+"]", get_text(edit_link_xpath))
     assert_equal("["+_("Delete")+"]", get_text(delete_link_xpath))


    end

    click("link=2")
    sleep 3

    for i in ($warning_id_0+10 .. $warning_id_0+NUMBER_OF_COMMENTS-1)
      edit_link_xpath = "//tr[@id='warning_#{i}']/td[10]/a[1]"
      delete_link_xpath = "//tr[@id='warning_#{i}']/td[10]/a[2]"
      assert_equal("["+_('Edit')+"]", get_text(edit_link_xpath))
      assert_equal("["+_('Delete')+"]", get_text(delete_link_xpath))
    end

    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_196
    printf "\n+ Test 196"
    old_review_status = set_subtask_publicized(SUB_ID, true)

    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_file_as_reviewer
      else
        access_comment_listing_page_for_file_as_pj_member
      end
      sleep 3

      # click on Warning Listing button
      click($xpath["review"]["warning_listing_button"])
      wait_for_text_present($page_titles["review_view_warning_list"])

      logout
    end

    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_197
    printf "\n+ Test 197"
    old_review_status = set_subtask_publicized(SUB_ID, true)

    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_file_as_reviewer
      else
        access_comment_listing_page_for_file_as_pj_member
      end

      # The first page displays warning list from 1 to 10
      for j in (0..9)
        assert(is_element_present("//tr[@id='warning_#{$registered_warnings[j].id}']"))
      end

      # Click the next page. Content should be changed
      click "link=2"
      sleep 3
      for k in (10..$registered_warnings.length - 1)
        assert(is_element_present("//tr[@id='warning_#{$registered_warnings[k].id}']"))
      end

      logout
    end

    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_198
    printf "\n+ Test 198"
    old_review_status = set_subtask_publicized(SUB_ID, false)

    # log in to comment listing page
    access_comment_listing_page_for_file_as_reviewer

    # click on edit link
    warning = $warnings[0]
    edit_link_xpath = "//tr[@id='warning_#{warning.id}']/td[10]/a[1]"
    wait_for_element_present(edit_link_xpath)
    click(edit_link_xpath)
    comment_editor

    # The subwindow has "Delete" link
    wait_for_element_present($xpath["review"]["delete_link"])
    sleep 5

    # check the contents of the window
    expected_warning_description = warning.comment.warning_description
    expected_sample_source_code  = warning.comment.sample_source_code

    # gets contents of the textboxes
    warning_description, sample_source_code = get_comment_editor_contents

    # the contents of the textboxes must be similar to the record in database
    assert_equal(expected_warning_description, warning_description)
    assert_equal(expected_sample_source_code, sample_source_code)

    logout

    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_199
    printf "\n+ Test 199"
    old_review_status = set_subtask_publicized(SUB_ID, false)

    # log in to comment listing page
    access_comment_listing_page_for_file_as_reviewer

    # click on delete link
    warning = $warnings[0]
    delete_link_xpath = "//tr[@id='warning_#{warning.id}']/td[10]/a[2]"
    wait_for_element_present(delete_link_xpath)
    click(delete_link_xpath)

    # check that confirmation message is correct
    assert_equal($messages["comment_deleting_confirmation"], get_confirmation())

    choose_cancel_on_next_confirmation
    logout

    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_200
    printf "\n+ Test 200"
    old_review_status = set_subtask_publicized(SUB_ID, false)

    # log in to comment listing page
    access_comment_listing_page_for_file_as_reviewer

    # click on delete link
    warning = $warnings[0]
    delete_link_xpath = "//tr[@id='warning_#{warning.id}']/td[10]/a[2]"
    wait_for_element_present(delete_link_xpath)
    click(delete_link_xpath)
    assert_equal($messages["comment_deleting_confirmation"], get_confirmation())
    choose_ok_on_next_confirmation

    # check that the comment is deleted
    wait_for_element_not_present("//tr[@id='warning_#{warning.id}']")

    logout

    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_201
    printf "\n+ Test 201"
    old_review_status = set_subtask_publicized(SUB_ID, true)

    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_file_as_reviewer
      else
        access_comment_listing_page_for_file_as_pj_member
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

  def test_202
    printf "\n+ Test 202"
    old_review_status = set_subtask_publicized(SUB_ID, true)

    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_file_as_reviewer
      else
        access_comment_listing_page_for_file_as_pj_member
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
      (1..3).each do |j|
        column_header_style = get_attribute($xpath["review"]["warning_list_headers"][j], "class")
        assert_equal(HEADER_STYLES["nosort"], column_header_style)

        click("#{$xpath["review"]["warning_list_headers"][j]}/a")
        wait_for_attribute($xpath["review"]["warning_list_headers"][j], "class", HEADER_STYLES["sortup"])
      end

      logout
    end

    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_203
    printf "\n+ Test 203"
    old_review_status = set_subtask_publicized(SUB_ID, true)

    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_file_as_reviewer
      else
        access_comment_listing_page_for_file_as_pj_member
      end

      # sort all columns down and check style
      for j in (1..3)
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

  def test_204
    printf "\n+ Test 204"
    old_review_status = set_subtask_publicized(SUB_ID, true)

    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_file_as_reviewer
      else
        access_comment_listing_page_for_file_as_pj_member
      end

      # check the search types inside combobox
      wait_for_element_present($xpath["review"]["search_combobox_options"][1])
      assert(is_element_not_present($xpath["review"]["search_combobox_options"][0]))
      assert(is_element_not_present($xpath["review"]["search_combobox_options"][2]))
      assert(is_element_not_present($xpath["review"]["search_combobox_options"][3]))
    end

    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_205
    printf "\n+ Test 205"
    old_review_status = set_subtask_publicized(SUB_ID, true)

    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_file_as_reviewer
      else
        access_comment_listing_page_for_file_as_pj_member
      end

      # Search rule number
      expected_warnings_1 =  Warning.find(
        :all,
        :joins       => "INNER JOIN comments ON comments.warning_id = warnings.id
                         INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
        :conditions  => { "rule" => "0839",
                          "comments.status" => true,
                          "source_codes.result_id" => RESULT_ID}
      )
      check_search_result("Rule number", "    0839  ", expected_warnings_1)
      check_search_result("Rule number", "   0839 0839", expected_warnings_1)
      check_search_result("Rule number", "   00839 0839", expected_warnings_1)
      check_search_result("Rule number", "   01 0839", expected_warnings_1)

      expected_warnings_2 = Warning.find(
        :all,
        :joins      => "INNER JOIN comments ON comments.warning_id = warnings.id
                        INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
        :conditions => [ "(rule = '0839' OR rule = '2017')
                         AND comments.status = true
                         AND source_codes.result_id = #{RESULT_ID}"]
      )
      check_search_result("Rule number", "0839         2017", expected_warnings_2)

      logout
    end

    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_206
    printf "\n+ Test 206"
    old_review_status = set_subtask_publicized(SUB_ID, true)

    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_file_as_reviewer
      else
        access_comment_listing_page_for_file_as_pj_member
      end

      # Search with regular expression
      check_search_result("Rule number", "  *  ", $registered_warnings)
      check_search_result("Rule number", "[0-9]+", $registered_warnings)

      expected_warnings = Warning.find(
        :all,
        :joins      => "INNER JOIN comments ON comments.warning_id = warnings.id
                        INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
        :conditions => ["comments.status = true
                         AND source_codes.result_id = #{RESULT_ID}
                         AND rule REGEXP '08[0-9]+'"]
      )
      check_search_result("Rule number", "08??", expected_warnings)
      check_search_result("Rule number", "08[0-9]*", expected_warnings)

      logout
    end

    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_207
    printf "\n+ Test 207"
    old_review_status = set_subtask_publicized(SUB_ID, true)

    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_file_as_reviewer
      else
        access_comment_listing_page_for_file_as_pj_member
      end

      check_search_result("Rule number", "0", 0)
      check_search_result("Rule number", "839", 0)
      check_search_result("Rule number", "8'39", 0)
      check_search_result("Rule number", "3.6", 0)
      check_search_result("Rule number", "abc 09d ", 0)
      check_search_result("Rule number", "[a-z]+", 0)

      logout
    end

    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_208
    printf "\n+ Test 208"
    old_review_status = set_subtask_publicized(SUB_ID, true)

    for i in [1, 2]
      # login to comment listing page
      if i == 1 then
        access_comment_listing_page_for_file_as_reviewer
      else
        access_comment_listing_page_for_file_as_pj_member
      end

      check_search_result("Rule number", "", $registered_warnings)

      logout
    end

    set_subtask_publicized(SUB_ID, old_review_status)
  end
#
##  def test_209
##    # this test cases can not be implemented because Selenium does not support download function
##    assert(false)
##  end
##
##  def test_210
##    # this test cases can not be implemented because Selenium does not support download function
##    assert(false)
##  end

  def test_211
    printf "\n+ Test 211"
    old_review_status = set_subtask_publicized(SUB_ID, false)

    access_comment_listing_page_for_file_as_reviewer
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])
    type(element_xpath("upload_file_browser"),
         CSV_FILES["invalid_format"])
    click element_xpath("upload_file_button")
    wait_for_text_not_present($window_titles["upload_csv_file"])
    expected_message  = $messages["no_csv_file_selected"]
    message           = get_alert
    verify_equal(expected_message, message)

    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_212
    old_review_status = set_subtask_publicized(SUB_ID, false)

    access_comment_listing_page_for_file_as_reviewer
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

  def test_213
    old_review_status = set_subtask_publicized(SUB_ID, false)

    access_comment_listing_page_for_file_as_reviewer

    # selects file to upload
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])
    type_csv_upload_file(CSV_FILES["r7_1mb"],CSV_FILES["r7_1mb_ja"])
    click element_xpath("upload_file_button")

    # waits untill sucessful message is displayed
    wait_for_text_present($messages["upload_csv_successully"])
    sleep 5

    # the uploaded file contains comments for first 10 warnings
    ($warning_id_0..$warning_id_0+9).each do |index|
      cell_xpath        = "//tr[@id='warning_#{index}']/td[8]"
      expected_comment  = "description for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment, comment)
    end

    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_214
    old_review_status = set_subtask_publicized(SUB_ID, false)
    access_comment_listing_page_for_file_as_reviewer

    # selects file to upload
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])
    if ($lang =='en')
    type(element_xpath("upload_file_browser"),CSV_FILES["1row"])
    else
      type(element_xpath("upload_file_browser"),CSV_FILES["1row_ja"])
    end
    # clicks on "Upload" button
    click element_xpath("upload_file_button")

    # waits untill sucessful message is displayed
    wait_for_text_present($messages["upload_csv_successully"])
    sleep 3

    # but no new comment
    ($warning_id_0..$warning_id_0+9).each do |index|
      cell_xpath        = "//tr[@id='warning_#{index}']/td[8]"
      expected_comment  = "original description for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment, comment)
    end

    assert(is_element_present("link=2"))

    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_215
    old_review_status = set_subtask_publicized(SUB_ID, false)
    access_comment_listing_page_for_file_as_reviewer

    for i in [1,2]
      click element_xpath("upload_csv_button")
      wait_for_text_present($window_titles["upload_csv_file"])
      if i == 1 then
        # upload file with error format
        type(element_xpath("upload_file_browser"), CSV_FILES["error_file"])
      else
        # upload file with error data (data for other RESULTS appear)
        type_csv_upload_file(CSV_FILES["1mb_2"],CSV_FILES["1mb_2_ja"])
      end

      click element_xpath("upload_file_button")

      wait_for_text_present($messages["upload_csv_failed3"])

      # but no new comment
      ($warning_id_0..$warning_id_0+9).each do |index|
        cell_xpath        = "//tr[@id='warning_#{index}']/td[8]"
        expected_comment  = "original description for warning (#{index})"
        comment           = get_text(cell_xpath)
        assert_equal(expected_comment, comment)
      end
    end

    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_216
    test_213 # this is already checked in test_213
  end

  def test_217
    old_review_status = set_subtask_publicized(SUB_ID, false)

    access_comment_listing_page_for_file_as_reviewer
    sleep 5


    # selects file to upload
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])
    if ($lang =='en')
    type(element_xpath("upload_file_browser"), CSV_FILES["r7_data"])
    else
      type(element_xpath("upload_file_browser"), CSV_FILES["r7_data_ja"])
    end
    click element_xpath("upload_file_button")

    # waits untill sucessful message is displayed
    wait_for_text_present($messages["upload_csv_successully"])
    sleep 5

    #the uploaded file contains updated comments for first 10 warnings
    ($warning_id_0..$warning_id_0+9).each do |index|
      cell_xpath        = "//tr[@id='warning_#{index}']/td[8]"
      expected_comment  = "description for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment, comment)
      cell_xpath        = "//tr[@id='warning_#{index}']/td[9]"
      status            = get_text(cell_xpath)
      assert_equal(COMMENT_STATUSES["registered"], status)
    end

    # the uploaded file contains 7 new comments for RESULT_ID = 7
    click ("link=2")
    sleep 5

    ($warning_id_0+10..$warning_id_0+11).each do |index|
      cell_xpath        = "//tr[@id='warning_#{index}']/td[8]"
      expected_comment  = "description for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment, comment)
      cell_xpath        = "//tr[@id='warning_#{index}']/td[9]"
      status            = get_text(cell_xpath)
      assert_equal(COMMENT_STATUSES["registered"], status)
    end
    ($warning_id_0+12..$warning_id_0+NUMBER_OF_COMMENTS-1).each do |index|
      cell_xpath        = "//tr[@id='warning_#{index}']/td[8]"
      expected_comment  = "original description for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment, comment)
      cell_xpath        = "//tr[@id='warning_#{index}']/td[9]"
      status            = get_text(cell_xpath)
      assert_equal(COMMENT_STATUSES["registered"], status)
    end
    ($warning_id_0+1000..$warning_id_0+1003).each do |index|
      cell_xpath        = "//tr[@id='warning_#{index}']/td[8]"
      expected_comment  = "New comment for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment, comment)
      cell_xpath        = "//tr[@id='warning_#{index}']/td[9]"
      status            = get_text(cell_xpath)
      assert_equal(COMMENT_STATUSES["registered"], status)
    end

    assert(is_element_not_present("link=3"))

    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def upload_with_file_size_test(csv_file, sleep_time)
    old_review_status = set_subtask_publicized(SUB_ID, false)

    access_comment_listing_page_for_file_as_reviewer

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
      cell_xpath        = "//tr[@id='warning_#{index}']/td[8]"
      expected_comment  = "description for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment, comment)
    end

    logout
    set_subtask_publicized(SUB_ID, old_review_status)
  end

  def test_218
    if ($lang == 'en')
    upload_with_file_size_test(CSV_FILES["r7_1mb"], 5)
    else
      upload_with_file_size_test(CSV_FILES["r7_1mb_ja"], 5)
    end
  end

#  def test_219
#    test false
#    upload_with_file_size_test(CSV_FILES["r7_2mb"], 2)
#  end
#
#  def test_220
#    test false
#    upload_with_file_size_test(CSV_FILES["r7_5mb"], 5)
#  end
#
#  def test_221
#    test false
#    upload_with_file_size_test(CSV_FILES["r7_10mb"], 10)
#  end

  def test_222
    old_review_status = set_subtask_publicized(SUB_ID, false)
    expected_message  = _("Upload  fails:  The  subtask  is  publicized.")

    access_comment_listing_page_for_file_as_reviewer

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

