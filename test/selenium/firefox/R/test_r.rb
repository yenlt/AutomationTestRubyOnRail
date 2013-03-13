require File.dirname(__FILE__) + "/test_r_setup" unless defined? TestRSetup

class TestR < Test::Unit::TestCase

  fixtures :subtasks, :comments, :reviews
  include TestRSetup

    RULE_NUMBER = "2017"

  def test_001
    printf "\n+ Test 001"
    # accesses Analysis Result Report List page as a reviewer
    access_analysis_result_report_list_as_reviewer

    # checks if "Publicize / Unpublicize" button exists
    assert(is_element_present($xpath["review"]["publicize_button"]) || is_element_present($xpath["review"]["unpublicize_button"]))

    # checks if "WarningListing" button exists
    assert(is_element_present($xpath["review"]["warning_listing_button"]))

    # checks if "Result Download" button exists
    assert(is_element_present($xpath["review"]["result_download_button"]))

    # log out
    logout
  end

  def test_002
    printf "\n+ Test 002"
    # accesses Analysis Result Report List page as a pj member (general user)
    access_analysis_result_report_list_as_pj_member

    # checks if "WarningListing" button exists
    assert(is_element_present($xpath["review"]["warning_listing_button"]))

    # log out
    logout
  end
  #false when test = lang = ja
  def test_003
    printf "\n+ Test 003"
    # accesses Analysis Result Report List page as a reviewer
    access_analysis_result_report_list_as_reviewer

    # checks if "WarningListing" button exists
    assert(is_element_present($xpath["review"]["warning_listing_button"]))
     i = 0
    # checks all headeres of the result list table
    if $lang == 'en'
    $xpath["review"]["result_list_headers"].each_with_index do |header, index|
      i = i+1
      assert_equal(RESULT_LIST_HEADERS_EN[index],get_text(header))
    end
    else
      $xpath["review"]["result_list_headers"].each_with_index do |header, index|
      i = i+1

      assert_equal(RESULT_LIST_HEADERS_JA[index],get_text(header))
    end
    end

    logout

    # accesses Analysis Result Report List page as a pj member (general user)
    access_analysis_result_report_list_as_pj_member

    # checks if "WarningListing" button exists
    assert(is_element_present($xpath["review"]["warning_listing_button"]))

    # checks all headeres of the result list table
     if $lang == 'en'
    $xpath["review"]["result_list_headers"].each_with_index do |header, index|
      i = i+1
      assert_equal(RESULT_LIST_HEADERS_EN[index],get_text(header))
    end
    else
      $xpath["review"]["result_list_headers"].each_with_index do |header, index|
      i = i+1
      assert_equal(RESULT_LIST_HEADERS_JA[index],get_text(header))
    end
    end

    logout
  end

   def test_004
     printf "\n+ Test 004"
    # accesses Analysis Result Report List page as a reviewer
    access_analysis_result_report_list_as_reviewer

    total_rows = get_xpath_count($xpath["review"]["result_list_body_row"])

    # all rows is a result report of the subtask
    #
    (1..total_rows).each do |row_index|
      row_xpath         = $xpath["review"]["result_list_body_row"] + "[#{row_index}]"
      result_link_xpath = row_xpath + "/td/a"

      if is_element_present(result_link_xpath)
        # gets result's id
        href      = get_attribute(result_link_xpath,
                                  "href")

        href      =~ /.*?result_id=(\d+).*?/
        result_id = $1

        # gets information of the result
        result    = Result.find_by_id(result_id)

        # this result belongs to the subtask
        assert_equal(SUB_ID,
                     result.subtask_id)
      end
    end
    logout

    # accesses Analysis Result Report List page as a pj member (general user)
    access_analysis_result_report_list_as_pj_member

    total_rows = get_xpath_count($xpath["review"]["result_list_body_row"])

    # all rows is a result report of the subtask
    #
    (1..total_rows).each do |row_index|
      row_xpath         = $xpath["review"]["result_list_body_row"] + "[#{row_index}]"
      result_link_xpath = row_xpath + "/td/a"

      if is_element_present(result_link_xpath)
        # gets result's id
        href      = get_attribute(result_link_xpath, "href")

        href      =~ /.*?result_id=(\d+).*?/
        result_id = $1

        # gets information of the result
        result    = Result.find_by_id(result_id)

        # this result belongs to the subtask
        assert_equal(SUB_ID,
          result.subtask_id)
      end
    end
    logout
  end

  def test_005
    printf "\n+ Test 005"
    # accesses Analysis Result Report List page as a reviewer
    access_analysis_result_report_list_as_reviewer

    total_rows = get_xpath_count($xpath["review"]["result_list_body_row"])

    # all rows is a result report of the subtask
    #
    (1..total_rows).each do |row_index|
      row_xpath         = $xpath["review"]["result_list_body_row"] + "[#{row_index}]"
      result_link_xpath = row_xpath + "/td[1]/a"

      if is_element_present(result_link_xpath)
        # gets "href" attribute of the link in "File name" column
        href      = get_attribute(result_link_xpath,
          "href")

        # gets result_id from "href" attribute
        href      =~ /.*?result_id=(\d+).*?/
        result_id = $1

        expected_href = url_for(:controller => "review",
          :action     => "view_result_report",
          :pu         => PU_ID,
          :pj         => PJ_ID,
          :id         => ID,
          :sub_id     => SUB_ID,
          :result_id  => result_id)

        assert_equal(expected_href,
          href)
      end
    end
    logout

    # accesses Analysis Result Report List page as a pj member
    access_analysis_result_report_list_as_pj_member

    total_rows = get_xpath_count($xpath["review"]["result_list_body_row"])

    # all rows is a result report of the subtask
    #
    (1..total_rows).each do |row_index|
      row_xpath         = $xpath["review"]["result_list_body_row"] + "[#{row_index}]"
      result_link_xpath = row_xpath + "/td[1]/a"

      if is_element_present(result_link_xpath)
        # gets "href" attribute of the link in "File name" column
        href  = get_attribute(result_link_xpath,"href")

        # gets result_id from "href" attribute
        href  =~ /.*?result_id=(\d+).*?/
        result_id = $1

        expected_href = url_for(:controller => "review",
                                :action     => "view_result_report",
                                :pu         => PU_ID,
                                :pj         => PJ_ID,
                                :id         => ID,
                                :sub_id     => SUB_ID,
                                :result_id  => result_id)

        assert_equal(expected_href,
                     href)
      end
    end
    logout
  end

  def test_006
    printf "\n+ Test 006"
    # accesses Analysis Result Report List page as a reviewer
    access_analysis_result_report_list_as_reviewer

    total_rows = get_xpath_count($xpath["review"]["result_list_body_row"])

    # all rows is a result report of the subtask
    #
    (1..total_rows).each do |row_index|
      row_xpath         = $xpath["review"]["result_list_body_row"] + "[#{row_index}]"
      result_link_xpath = row_xpath + "/td[1]/a"

      if is_element_present(result_link_xpath)
        # gets "href" attribute of the link in "File name" column
        href      = get_attribute(result_link_xpath,
                                  "href")

        # gets result_id from "href" attribute
        href      =~ /.*?result_id=(\d+).*?/
        result_id = $1

        expected_href = url_for(:controller => "review",
                                :action     => "view_result_report",
                                :pu         => PU_ID,
                                :pj         => PJ_ID,
                                :id         => ID,
                                :sub_id     => SUB_ID,
                                :result_id  => result_id)

        assert_equal(expected_href,
                     href)
      end
    end
    logout

    # accesses Analysis Result Report List page as a pj member
    access_analysis_result_report_list_as_pj_member

    total_rows = get_xpath_count($xpath["review"]["result_list_body_row"])

    # all rows is a result report of the subtask
    #
    (1..total_rows).each do |row_index|
      row_xpath         = $xpath["review"]["result_list_body_row"] + "[#{row_index}]"
      result_link_xpath = row_xpath + "/td[1]/a"

      if is_element_present(result_link_xpath)
        # gets "href" attribute of the link in "File name" column
        href      = get_attribute(result_link_xpath,
                                  "href")

        # gets result_id from "href" attribute
        if href      =~ /.*?result_id=(\d+).*?/
          result_id = $1
        end

        expected_href = url_for(:controller => "review",
                                :action     => "view_result_report",
                                :pu         => PU_ID,
                                :pj         => PJ_ID,
                                :id         => ID,
                                :sub_id     => SUB_ID,
                                :result_id  => result_id)

        assert_equal(expected_href,
                     href)
      end
    end
    logout
  end

  def test_007_a
    printf "\n+ Test 007_a"
    # accesses Analysis Result Report List page as a reviewer
    access_analysis_result_report_list_as_reviewer

    total_rows = get_xpath_count($xpath["review"]["result_list_body_row"])

    # all rows is a result report of the subtask
    #
    (1..total_rows).each do |row_index|
      row_xpath         = $xpath["review"]["result_list_body_row"] + "[#{row_index}]"
      result_link_xpath = row_xpath + "/td[1]/a"

      if is_element_present(result_link_xpath)
        # gets "href" attribute of the link in "File name" column
        href      = get_attribute(result_link_xpath,
                                  "href")

        # gets result_id from "href" attribute
        if href      =~ /.*?result_id=(\d+).*?/
          result_id = $1
        end

        risk_type_ids = RiskType.all.collect { |risk_type| risk_type.id}

        risk_type_ids.each do |risk_type_id|
          expected_total_registered_comments = Comment.count_by_result_id_and_status_and_risk_type_id(result_id,
                                                                                                      true,
                                                                                                      risk_type_id)
          cell_xpath = row_xpath + "/td[#{risk_type_id}]"
          displayed_total_registered_comments = get_text(cell_xpath).to_i

          assert_equal(expected_total_registered_comments,
                       displayed_total_registered_comments)
        end
      end
    end
    logout

    # accesses Analysis Result Report List page as a pj member
    access_analysis_result_report_list_as_pj_member

    total_rows = get_xpath_count($xpath["review"]["result_list_body_row"])

    # all rows is a result report of the subtask
    #
    (1..total_rows).each do |row_index|
      row_xpath         = $xpath["review"]["result_list_body_row"] + "[#{row_index}]"
      result_link_xpath = row_xpath + "/td[1]/a"

      if is_element_present(result_link_xpath)
        # gets "href" attribute of the link in "File name" column
        href      = get_attribute(result_link_xpath,
                                  "href")

        # gets result_id from "href" attribute
        href      =~ /.*?result_id=(\d+).*?/
        result_id = $1

        expected_href = url_for(:controller => "review",
                                :action     => "view_result_report",
                                :pu         => PU_ID,
                                :pj         => PJ_ID,
                                :id         => ID,
                                :sub_id     => SUB_ID,
                                :result_id  => result_id)

        assert_equal(expected_href,
                     href)
      end
    end
    logout

    # accesses Analysis Result Report List page as a pj member
    access_analysis_result_report_list_as_pj_member

    total_rows = get_xpath_count($xpath["review"]["result_list_body_row"])

    # all rows is a result report of the subtask
    #
    (1..total_rows).each do |row_index|
      row_xpath         = $xpath["review"]["result_list_body_row"] + "[#{row_index}]"
      result_link_xpath = row_xpath + "/td[1]/a"

      if is_element_present(result_link_xpath)
        # gets "href" attribute of the link in "File name" column
        href      = get_attribute(result_link_xpath,
                                  "href")

        # gets result_id from "href" attribute
        href      =~ /.*?result_id=(\d+).*?/
        result_id = $1

        expected_href = url_for(:controller => "review",
                                :action     => "view_result_report",
                                :pu         => PU_ID,
                                :pj         => PJ_ID,
                                :id         => ID,
                                :sub_id     => SUB_ID,
                                :result_id  => result_id)

        assert_equal(expected_href,
                     href)
      end
    end
    logout
  end

  def test_007_b
    printf "\n+ Test 007_b"
    # accesses Analysis Result Report List page as a reviewer
    access_analysis_result_report_list_as_reviewer

    total_rows = get_xpath_count($xpath["review"]["result_list_body_row"])

    # all rows is a result report of the subtask
    #
    (1..total_rows).each do |row_index|
      row_xpath         = $xpath["review"]["result_list_body_row"] + "[#{row_index}]"
      result_link_xpath = row_xpath + "/td[1]/a"

      if is_element_present(result_link_xpath)
        # gets "href" attribute of the link in "File name" column
        href      = get_attribute(result_link_xpath,
                                  "href")

        # gets result_id from "href" attribute
        href      =~ /.*?result_id=(\d+).*?/
        result_id = $1

        risk_type_ids = RiskType.all.collect { |risk_type| risk_type.id}

        risk_type_ids.each do |risk_type_id|
          expected_total_registered_comments = Comment.count_by_result_id_and_status_and_risk_type_id(result_id,
                                                                                                      true,
                                                                                                      risk_type_id)

          cell_xpath = row_xpath + "/td[#{risk_type_id}]"
          displayed_total_registered_comments = get_text(cell_xpath).to_i

          assert_equal(expected_total_registered_comments,
                       displayed_total_registered_comments)
        end
      end
    end
    logout

    # accesses Analysis Result Report List page as a pj member
    access_analysis_result_report_list_as_pj_member

    total_rows = get_xpath_count($xpath["review"]["result_list_body_row"])

    # all rows is a result report of the subtask
    #
    (1..total_rows).each do |row_index|
      row_xpath         = $xpath["review"]["result_list_body_row"] + "[#{row_index}]"
      result_link_xpath = row_xpath + "/td[1]/a"

      if is_element_present(result_link_xpath)
        # gets "href" attribute of the link in "File name" column
        href      = get_attribute(result_link_xpath,
          "href")

        # gets result_id from "href" attribute
        href      =~ /.*?result_id=(\d+).*?/
        result_id = $1

        risk_type_ids = RiskType.all.collect { |risk_type| risk_type.id}

        risk_type_ids.each do |risk_type_id|
          expected_total_registered_comments = Comment.count_by_result_id_and_status_and_risk_type_id(result_id,
                                                                                                      true,
                                                                                                      risk_type_id)

          cell_xpath = row_xpath + "/td[#{risk_type_id}]"
          displayed_total_registered_comments = get_text(cell_xpath).to_i

          assert_equal(expected_total_registered_comments,
                       displayed_total_registered_comments)
        end
      end
    end
    logout
  end

  def test_007_c
    printf "\n+ Test 007_c"
    # accesses Analysis Result Report List page as a reviewer
    access_analysis_result_report_list_as_reviewer

    total_rows = get_xpath_count($xpath["review"]["result_list_body_row"])

    # all rows is a result report of the subtask
    #
    (1..total_rows).each do |row_index|
      row_xpath         = $xpath["review"]["result_list_body_row"] + "[#{row_index}]"
      result_link_xpath = row_xpath + "/td[1]/a"

      if is_element_present(result_link_xpath)
        # gets "href" attribute of the link in "File name" column
        href      = get_attribute(result_link_xpath,
                                  "href")

        # gets result_id from "href" attribute
        href      =~ /.*?result_id=(\d+).*?/
        result_id = $1
        result    = Result.find_by_id(result_id)

        # clicks on link to view Analysis Result Report page
        result_link_xpath
        click(result_link_xpath)

        # waits until the page title of "Analysis Result Report" page appears

        page_title = $page_titles["review_view_result_report"].sub("__FILE_NAME__", result.file_name)
        p page_title
        wait_for_text_present(page_title)
        #Analysis Result Report (analyzeme.c.Critical.html)
        #"Analysis result report(analyzeme.c.Critical.html)"
       # Analysis result report(analyzeme.c.Critical.html)"
        break
      end
    end
    logout

    # accesses Analysis Result Report List page as a reviewer
    access_analysis_result_report_list_as_pj_member

    total_rows = get_xpath_count($xpath["review"]["result_list_body_row"])

    # all rows is a result report of the subtask
    #
    (1..total_rows).each do |row_index|
      row_xpath         = $xpath["review"]["result_list_body_row"] + "[#{row_index}]"
      result_link_xpath = row_xpath + "/td[1]/a"

      if is_element_present(result_link_xpath)
        # gets "href" attribute of the link in "File name" column
        href      = get_attribute(result_link_xpath,
                                  "href")

        # gets result_id from "href" attribute
        href      =~ /.*?result_id=(\d+).*?/
        result_id = $1
        result    = Result.find_by_id(result_id)

        # clicks on link to view Analysis Result Report page
        result_link_xpath
        click(result_link_xpath)

        # waits until the page title of "Analysis Result Report" page appears
        page_title = $page_titles["review_view_result_report"].sub("__FILE_NAME__",
          result.file_name)
        wait_for_text_present(page_title)

        break
      end
    end
    logout
  end

  def test_008
    printf "\n+ Test 008"
    # accesses Analysis Result Report List page as a reviewer
    access_analysis_result_report_list_as_reviewer

    # checks if "WarningListing" button exists
    assert(is_element_present($xpath["review"]["warning_listing_button"]))

    # switches to "Warning Listing Page" for a subtask by clicking on WarningListing button
    click($xpath["review"]["warning_listing_button"])

    wait_for_page_to_load(30000)

    # checks the page title of "Warning Listing Page" for a subtask
    assert(is_text_present($page_titles["warning_listing_page"]))

    # log out
    logout

    # accesses Analysis Result Report List page as a pj member
    access_analysis_result_report_list_as_pj_member

    # checks if "WarningListing" button exists
    assert(is_element_present($xpath["review"]["warning_listing_button"]))

    # switches to "Warning Listing Page" for a subtask by clicking on WarningListing button
    click($xpath["review"]["warning_listing_button"])

    wait_for_page_to_load(30000)

    # checks the page title of "Warning Listing Page" for a subtask
    assert(is_text_present($page_titles["warning_listing_page"]))

    # log out
    logout
  end

  def test_009
    printf "\n+ Test 009"
    # accesses Analysis Result Report List page as a reviewer
    access_analysis_result_report_list_as_reviewer

    # switches to "Warning Listing Page" for a subtask by clicking on WarningListing button
    assert(is_element_present(element_xpath("publicize_button")))
    click(element_xpath("publicize_button"))

    wait_for_page_to_load(30000)

    # publicize_button is changed to Unpublicized button
    assert(!is_element_present(element_xpath("publicize_button")))
    assert(is_element_present(element_xpath("unpublicize_button")))

    # log out
    logout

    # accesses Analysis Result Report List page as a pj_member
    access_analysis_result_report_list_as_pj_member

    # log out
    logout

    # accesses comment listing page as a pj member
    access_comment_listing_page_for_subtask_as_pj_member
    logout
  end

  def test_010
    printf "\n+ Test 010"
    subtask = Subtask.find(SUB_ID)
    # accesses Analysis Result Report List page as a reviewer
    access_analysis_result_report_list_as_reviewer

    # switches to "Warning Listing Page" for a subtask by clicking on WarningListing button
    assert(is_element_present(element_xpath("publicize_button")))
    click(element_xpath("publicize_button"))

    wait_for_page_to_load(30000)
    assert(is_element_present(element_xpath("unpublicize_button")))

    # switches to "Review Administration" pagge
    open_review_administration_page
    row_xpath         = element_xpath("review_list_row") + "[@id='task_#{subtask.task_id}']"
    analyze_tool_name = subtask.analyze_tool.name
    cell_xpath        = row_xpath + "/td[@id='tool_#{analyze_tool_name}']"

    review_link_xpath = cell_xpath + "/a"

    link_text         = get_text(review_link_xpath)

    # link text must be "Reviewed"
    assert_equal(_("Reviewed"),
                 link_text)

    # log out
    logout
  end

  def test_011
    printf "\n+ Test 011"
    # makes sure that the wanted subtask is publiczed
    subtask                   = Subtask.find(SUB_ID)
    subtask.review.publicized = true
    subtask.review.save!

    # accesses Analysis Result Report List page as a reviewer
    access_analysis_result_report_list_as_reviewer

    # unpublicize the subtask
    #
    assert(is_element_present(element_xpath("unpublicize_button")))
    click(element_xpath("unpublicize_button"))

    # Unpublicize button is changed to publiczed button
    wait_for_page_to_load(30000)
    assert(is_element_present(element_xpath("publicize_button")))

    # log out
    logout


    # try accesses Comment Listing Page as a pj member
    access_comment_listing_page_for_subtask_as_pj_member

    # but pj member can not view comments of an unpublicized subtask
    # he is kicked back to "Review Administration" page with a notice
    assert(is_text_present($messages["unpubliczed_subtask"]))

    logout
  end

  def test_012
    printf "\n+ Test 012"
    # makes sure that the wanted subtask is publiczed
    subtask                   = Subtask.find(SUB_ID)
    subtask.review.publicized = true
    subtask.review.save!

    # accesses Analysis Result Report List page as a reviewer
    access_analysis_result_report_list_as_reviewer

    # unpublicize the subtask
    #
    assert(is_element_present(element_xpath("unpublicize_button")))
    click(element_xpath("unpublicize_button"))

    ## switches to "Review Administration" pagge
    open_review_administration_page
    row_xpath         = element_xpath("review_list_row") + "[@id='task_#{subtask.task_id}']"
    analyze_tool_name = subtask.analyze_tool.name
    cell_xpath        = row_xpath + "/td[@id='tool_#{analyze_tool_name}']"

    review_link_xpath = cell_xpath + "/a"

    link_text         = get_text(review_link_xpath)

    # the link text must be "Review"
    assert_equal(_("Review"),
      link_text)

    logout
  end

#  def test_013
#    # selenium does not support testing download functions
#    assert(false)
#  end
#
#  def test_014
#    # selenium does not support testing download functions
#    assert(false)
#  end

  def test_015
    printf "\n+ Test 015"
    access_analysis_result_report_page_as_reviewer

    # checks "WarningListing" button
    assert(is_element_present(element_xpath("warning_listing_button")))

    # "Show comments" button must exist
    assert(is_element_present(element_xpath("show_comments_button")))

    logout
  end

  def test_016
    printf "\n+ Test 016"
    access_analysis_result_report_page_as_pj_member

    # pj_member can see WarningListing button
    assert(is_element_present(element_xpath("warning_listing_button")))
    # but he can not see links to add / edit / delete comment
    assert(is_element_not_present("//a[@class='operation']"))
    logout
  end


  def test_017
    printf "\n+ Test 017"
    # makes sure that the subtask is publicized
    subtask                   = Subtask.find(SUB_ID)
    subtask.review.publicized = true
    subtask.review.save

    # prepares some registered comments for the report
    warnings = Warning.find(:all,
                            :joins        => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                            :limit        => 10,
                            :conditions   => { "source_codes.result_id" => RESULT_ID })

    warnings.each do |warning|
      warning.comment = Comment.create(:risk_type_id        => 1,
                                       :warning_id          => warning.id,
                                       :warning_description => "description for warning (#{warning.id})",
                                       :sample_source_code  => "sample source code for warning (#{warning.id})",
                                       :status              => true)
    end

    access_analysis_result_report_page_as_pj_member

    # pj_member can see WarningListing button
    assert(is_element_present(element_xpath("warning_listing_button")))
    # he can also see "Show comments" button
    assert(is_element_present(element_xpath("show_comments_button")))
    # he can also see the red link "[Comment]" if there is any registered
    # comments in this result report
    total_registered_comments =  Comment.count_by_result_id_and_status(RESULT_ID,
      true)
    if total_registered_comments > 0
      assert(is_element_present("link=[Comment]"))
    end

    logout
  end

  def test_018
    printf "\n+ Test 018"
    # makes sure that our analysis result report is of an empty source file
    source_codes = SourceCode.find(:all,
                                   :conditions => { :result_id => RESULT_ID })
    source_codes.each do |source_code|
      source_code.result_id = 0
      source_code.save
    end

    begin
    access_analysis_result_report_page_as_reviewer
    # the notice must be displayed
    verify(is_text_present($messages["report_of_empty_source_file"]))
    # logout
    logout

    access_analysis_result_report_page_as_pj_member
    # the notice must be displayed

    verify(is_text_present($messages["report_of_empty_source_file"]))
    logout
    rescue => error
    end

    source_codes.each do |source_code|
      source_code.result_id = RESULT_ID
      source_code.save
    end
  end

  def test_019
    printf "\n+ Test 019"
    # gets an uncommented warning
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    # open an Analysis Result Report page
    access_analysis_result_report_page_as_reviewer

    warning_div_tag_id = "warning_#{warning.id}"

    # on Analysis Result Report page, the warning follows an "[Add]" link
    add_link_xpath      = "//div[@id='#{warning_div_tag_id}']/a[1]"
    warning_body_xpath  =  "//div[@id='#{warning_div_tag_id}']/a[2]/b"

    assert_equal("["+_("Add")+"]",get_text(add_link_xpath))

    expected_warning_body = warning.body
    warning_body          = get_text(warning_body_xpath)
    assert(expected_warning_body,
           warning_body)

    logout
  end

  def test_020
    printf "\n+ Test 020"
    # gets an uncommented warning
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    # creates an unregistered comment for this warning
    Comment.destroy_all(:warning_id         => warning.id)
    warning.comment = Comment.create(:risk_type_id          => 1,
                                     :warning_id            => warning.id,
                                     :warning_description   => "warning description for warning #{warning.id}",
                                     :sample_source_code    => "sample source code for warning #{warning.id}",
                                     :status                => false)
    warning.comment.save

    # open an Analysis Result Report page
    access_analysis_result_report_page_as_reviewer

    warning_div_tag_id = "warning_#{warning.id}"

    # on Analysis Result Report page, the warning follows an "[Add]" link
    edit_link_xpath       = "//div[@id='#{warning_div_tag_id}']/a[1]"
    delete_link_xpath     = "//div[@id='#{warning_div_tag_id}']/a[2]"
    warning_body_xpath    = "//div[@id='#{warning_div_tag_id}']/a[3]/b"
    # the first is an [Edit] link
    assert_equal("["+_("Edit")+"]", get_text(edit_link_xpath))
    # the second is a [Delete] link
    assert_equal("["+_("Delete")+"]", get_text(delete_link_xpath))



    # the last is body of the warning
    expected_warning_body = warning.body
    warning_body          = get_text(warning_body_xpath)
    assert(expected_warning_body,
           warning_body)
    logout
  end

  def test_021
     printf "\n+ Test 021"
    # gets an uncommented warning
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    # creates a registered comment for this warning
    warning.comment = Comment.create(:risk_type_id          => 1,
                                     :warning_id            => warning.id,
                                     :warning_description   => "warning description for warning #{warning.id}",
                                     :sample_source_code    => "sample source code for warning #{warning.id}",
                                     :status                => true)
    warning.comment.save

    # open an Analysis Result Report page
    access_analysis_result_report_page_as_reviewer

    warning_div_tag_id = "warning_#{warning.id}"

    # on Analysis Result Report page, the warning follows an "[Add]" link
    comment_link_xpath    = "//div[@id='#{warning_div_tag_id}']/a[1]"
    edit_link_xpath       = "//div[@id='#{warning_div_tag_id}']/a[2]"
    delete_link_xpath     = "//div[@id='#{warning_div_tag_id}']/a[3]"
    warning_body_xpath    = "//div[@id='#{warning_div_tag_id}']/a[4]/b"

    assert("[Comment]",
           get_text(comment_link_xpath))
      assert_equal("["+_("Edit")+"]", get_text(edit_link_xpath))
      assert_equal("["+_("Delete")+"]", get_text(delete_link_xpath))

    # the last is body of the warning
    expected_warning_body = warning.body
    warning_body          = get_text(warning_body_xpath)
    assert(expected_warning_body,
           warning_body)

    logout
  end

  def test_022
     printf "\n+ Test 022"
    # makes sure that the subtask is unpublicized
    subtask                   = Subtask.find_by_id(SUB_ID)
    subtask.review.publicized = true
    subtask.review.save

    # gets an uncommented warning
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    # creates a registered comment for this warning
    warning.comment = Comment.create(:risk_type_id          => 1,
                                     :warning_id            => warning.id,
                                     :warning_description   => "warning description for warning #{warning.id}",
                                     :sample_source_code    => "sample source code for warning #{warning.id}",
                                     :status                => true)
    warning.comment.save

    # open an Analysis Result Report page
    access_analysis_result_report_page_as_reviewer

    warning_div_tag_id = "warning_#{warning.id}"

    # on Analysis Result Report page, the warning follows an "[Add]" link
    comment_link_xpath    = "//div[@id='#{warning_div_tag_id}']/a[1]"
    warning_body_xpath    = "//div[@id='#{warning_div_tag_id}']/a[2]/b"

    assert("[Comment]",
           get_text(comment_link_xpath))

    # the last is body of the warning
    expected_warning_body = warning.body
    warning_body          = get_text(warning_body_xpath)
    assert(expected_warning_body,
           warning_body)

    logout
  end

  def test_023
     printf "\n+ Test 023"
    subtask = Subtask.find(SUB_ID)
    # all links are red if their class is 'operation'
    expected_class = "operation"

    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    warning_div_tag_id = "warning_#{warning.id}"

    # verifies color of an [Add] link when subtask is unpublicized
    access_analysis_result_report_page_as_reviewer
    add_link_xpath    = "//div[@id='#{warning_div_tag_id}']/a[1]"
    add_link_class    = get_attribute(add_link_xpath,
                                      "class")

    assert(expected_class,
           add_link_class)

    # verifies color of [Edit], [Delete] links when the comment is unregistered and
    #  subtask is unpubliczed
    warning.comment = Comment.create(:risk_type_id          => 1,
                                     :warning_id            => warning.id,
                                     :warning_description   => "warning description for warning #{warning.id}",
                                     :sample_source_code    => "sample source code for warning #{warning.id}",
                                     :status                => false)
    warning.comment.save

    open_analysis_result_report_page

    edit_link_xpath   = "//div[@id='#{warning_div_tag_id}']/a[1]"
    delete_link_xpath = "//div[@id='#{warning_div_tag_id}']/a[2]"
    edit_link_class   = get_attribute(edit_link_xpath, "class")
    delete_link_xpath = get_attribute(delete_link_xpath, "class")

    assert(expected_class,
           edit_link_class)
    assert(expected_class,
           delete_link_xpath)

    # verifies color of [Comment], [Edit], [Delete] links when the comment is
    # registered and the subtask is unpubliczed
    warning.comment.status = true
    warning.comment.save

    open_analysis_result_report_page
    comment_link_xpath  = "//div[@id='#{warning_div_tag_id}']/a[1]"
    edit_link_xpath     = "//div[@id='#{warning_div_tag_id}']/a[2]"
    delete_link_xpath   = "//div[@id='#{warning_div_tag_id}']/a[3]"

    comment_link_class  = get_attribute(comment_link_xpath,
                                        "class")
    edit_link_class     = get_attribute(edit_link_xpath, "class")
    delete_link_xpath   = get_attribute(delete_link_xpath, "class")

    assert(expected_class, comment_link_class)
    assert(expected_class, edit_link_class)
    assert(expected_class, delete_link_xpath)

    # verifies color of [Comment] link when the comment is
    # registered and the subtask is publicized
    subtask.review.publicized = true
    subtask.review.save

    open_analysis_result_report_page
    comment_link_xpath  = "//div[@id='#{warning_div_tag_id}']/a[1]"

    comment_link_class  = get_attribute(comment_link_xpath,
      "class")
    assert(expected_class, comment_link_class)

    logout

    access_analysis_result_report_page_as_pj_member
    comment_link_xpath  = "//div[@id='#{warning_div_tag_id}']/a[1]"

    comment_link_class  = get_attribute(comment_link_xpath,
      "class")
    assert(expected_class, comment_link_class)
    logout
  end

  def test_024
    printf "\n+ Test 024"
    # publicizes subtask
    subtask = Subtask.find(SUB_ID)
    subtask.review.publicized = true
    subtask.review.save

    access_analysis_result_report_list_as_reviewer
    assert_equal(0, get_xpath_count("//a[@class='operation']"))
    logout

    access_analysis_result_report_list_as_pj_member
    assert_equal(0, get_xpath_count("//a[@class='operation']"))
    logout
  end

#  def test_025 # this test case is a clone of test_018
#    test_018
#  end

  def test_026
    printf "\n+ Test 026"
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    warning_div_tag_id = "warning_#{warning.id}"

    access_analysis_result_report_page_as_reviewer

    # click [Add] link to open a comment editor
    add_link_xpath = "//div[@id='#{warning_div_tag_id}']/a[1]"
    click(add_link_xpath)
    comment_editor
    logout
  end

  def test_027
    printf "\n+ Test 027"
    # publicizes a subtask
    subtask                    = Subtask.find_by_id(SUB_ID)
    subtask.review.publicized  = true
    subtask.review.save

    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    # creates a registered comment for our warning
    warning.comment = Comment.create(:risk_type_id          => 1,
                                     :warning_id            => warning.id,
                                     :warning_description   => "warning description for warning #{warning.id}",
                                     :sample_source_code    => "sample source code for warning #{warning.id}",
                                     :status                => true)

    warning.comment.save

    warning_div_tag_id = "warning_#{warning.id}"


    access_analysis_result_report_page_as_reviewer

    # clicks [Add] link to open a comment editor
    comment_link_xpath = "//div[@id='#{warning_div_tag_id}']/a[1]"
    comment_xpath      = "//div[@id='comment_#{warning.comment.id}']"

    click comment_link_xpath
    # the content of comment must be displayed

    expected_style = ""
    comment_style  = (get_attribute(comment_xpath, "style") rescue "")

    assert(expected_style, comment_style)

    logout

    access_analysis_result_report_page_as_pj_member

    # clicks [Add] link to open a comment editor
    comment_link_xpath = "//div[@id='#{warning_div_tag_id}']/a[1]"
    comment_xpath      = "//div[@id='comment_#{warning.comment.id}']"

    click comment_link_xpath
    # the content of comment must be displayed

    expected_style = ""
    comment_style  = (get_attribute(comment_xpath, "style") rescue "")

    assert(expected_style, comment_style)

    logout
  end

  def test_028
    printf "\n+ Test 028"
    # publicizes a subtask
    subtask = Subtask.find_by_id(SUB_ID)
    subtask.review.publicized = true
    subtask.review.save

    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    # creates a registered comment for our warning
    warning.comment = Comment.create(:risk_type_id          => 1,
                                     :warning_id            => warning.id,
                                     :warning_description   => "warning description for warning #{warning.id}",
                                     :sample_source_code    => "sample source code for warning #{warning.id}",
                                     :status                => true)
    warning.comment.save

    warning_div_tag_id = "warning_#{warning.id}"

    access_analysis_result_report_page_as_reviewer

    comment_link_xpath  = "//div[@id='#{warning_div_tag_id}']/a[1]"
    comment_xpath       = "//div[@id='comment_#{warning.comment.id}']"

    # shows the comment
    click comment_link_xpath
    # the content of comment must be displayed
    expected_style  = ""
    comment_style   = (get_style(comment_xpath, "style") rescue "")
    assert(expected_style, comment_style)

    # hides the comment
    click comment_link_xpath
    expected_style = "display: none;"
    comment_style = get_style(comment_xpath)
    assert_equal(expected_style, comment_style)

    logout

    access_analysis_result_report_page_as_reviewer

    # clicks [Add] link to open a comment editor
    comment_link_xpath  = "//div[@id='#{warning_div_tag_id}']/a[1]"
    comment_xpath   = "//div[@id='comment_#{warning.comment.id}']"

    # shows the comment
    click comment_link_xpath
    # the content of comment must be displayed

    expected_style    = ""
    comment_style     = (get_attribute(comment_xpath, "style") rescue "")
    assert(expected_style, comment_style)

    # hides the comment
    click comment_link_xpath
    expected_style    = "display: none;"
    comment_style     = get_style(comment_xpath)
    assert_equal(expected_style, comment_style)

    logout
  end

  def test_029
    printf "\n+ Test 029"
    # gets a warning of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    warning_div_tag_id = "warning_#{warning.id}"
    # creates a comment for the warning
    warning.comment = Comment.create(:risk_type_id          => 2,
                                     :warning_id            => warning.id,
                                     :warning_description   => "warning description for warning #{warning.id}",
                                     :sample_source_code    => "sample source code for warning #{warning.id}",
                                     :status                => false)

    access_analysis_result_report_page_as_reviewer

    # clicks [Edit] link to open a comment editor
    edit_link_xpath = "//div[@id='#{warning_div_tag_id}']/a[1]"
    click(edit_link_xpath)
    comment_editor
    # verifies that the comment's old contents are used
    ## risk type
    risk_type_id          = get_value(element_xpath("risk_type_combobox")).to_i
    expected_risk_type_id = warning.comment.risk_type_id
    assert_equal(expected_risk_type_id,
                 risk_type_id)

    expected_warning_description  = warning.comment.warning_description
    expected_sample_source_code   = warning.comment.sample_source_code

    ## read initialized values of warning description and sample source code
    sleep 5
    warning_description, sample_source_code = get_comment_editor_contents

    assert_equal(expected_sample_source_code, sample_source_code)
    assert_equal(expected_warning_description, warning_description)

    logout
  end

  def test_030
    printf "\n+ Test 030"
    # gets a warning of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    warning_div_tag_id = "warning_#{warning.id}"
    Comment.destroy_all(:warning_id         => warning.id)

    # creates a comment for the warning
    warning.comment = Comment.create(:risk_type_id          => 2,
                                     :warning_id            => warning.id,
                                     :warning_description   => "warning description for warning #{warning.id}",
                                     :sample_source_code    => "sample source code for warning #{warning.id}",
                                     :status                => false)

    access_analysis_result_report_page_as_reviewer

    # clicks [Delete] link to open a comment editor
    delete_link_xpath = "//div[@id='#{warning_div_tag_id}']/a[2]"

    choose_cancel_on_next_confirmation

    click delete_link_xpath

    expected_confirmation_message = $messages["comment_deleting_confirmation"]
    confirmation_message          = get_confirmation

    assert_equal(expected_confirmation_message,
                 confirmation_message)

    logout
  end

  def test_031
    warning_listing_button_xpath = element_xpath("warning_listing_button")
    # opens an "Analysis Result Report" page as a reviewer
    access_analysis_result_report_page_as_reviewer
    # on this page, there is a "WarningListing" button
    assert(is_element_present(warning_listing_button_xpath))
    # switches to Warning Listing Page for a file by clicking on "WarningListing" button
    click(warning_listing_button_xpath)
    result = Result.find(RESULT_ID)
    expected_page_title = $page_titles["review_view_report_warning_list"].sub("__FILE_NAME__",
      result.file_name)
    wait_for_text_present(expected_page_title)
    logout
    # opens an "Analysis Result Report" page as a pj member
    access_analysis_result_report_page_as_reviewer
    # on this page, there is a "WarningListing" button
    assert(is_element_present(warning_listing_button_xpath))
    # switches to Warning Listing Page for a file by clicking on "WarningListing" button
    click(warning_listing_button_xpath)
    result = Result.find(RESULT_ID)
    expected_page_title = $page_titles["review_view_report_warning_list"].sub("__FILE_NAME__",
      result.file_name)

    wait_for_text_present(expected_page_title)
    logout
  end

  def test_032
    # publicize the subtask
    subtask                   = Subtask.find_by_id(SUB_ID)
    subtask.review.publicized = true
    subtask.review.save
    # gets warnings of the report
    warnings = Warning.find(:all,
                            :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                            :conditions  => {"source_codes.result_id" => RESULT_ID},
                            :limit       => 10)

    # prepares some registered comment
    warnings.each do |warning|
      warning.comment = Comment.create(:risk_type_id          => 2,
                                       :warning_id            => warning.id,
                                       :warning_description   => "warning description for warning #{warning.id}",
                                       :sample_source_code    => "sample source code for warning #{warning.id}",
                                       :status                => true)

      warning.comment.save
    end

    access_analysis_result_report_page_as_reviewer
    show_comments_button_xpath = element_xpath("show_comments_button")
    click(show_comments_button_xpath)
    # all registered comments must be showed
    expected_style = ""
    warnings.each do |warning|
      comment_div_id    = "comment_#{warning.comment.id}"
      comment_div_xpath = "//div[@id='#{comment_div_id}']"
      comment_div_style = (get_style(comment_div_xpath) rescue "")
      assert_equal(expected_style,
        comment_div_style)
    end
    logout

    # pj member
    access_analysis_result_report_page_as_reviewer
    show_comments_button_xpath = element_xpath("show_comments_button")
    click(show_comments_button_xpath)
    # all registered comments must be showed
    expected_style = ""
    warnings.each do |warning|
      comment_div_id    = "comment_#{warning.comment.id}"
      comment_div_xpath = "//div[@id='#{comment_div_id}']"
      comment_div_style = (get_style(comment_div_xpath) rescue "")
      assert_equal(expected_style,
        comment_div_style)
    end
    logout
  end

  def test_033
    # publicize the subtask
    subtask                   = Subtask.find_by_id(SUB_ID)
    subtask.review.publicized = true
    subtask.review.save
    # gets warnings of the report
    warnings = Warning.find(:all,
                            :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                            :conditions  => {"source_codes.result_id" => RESULT_ID},
                            :limit       => 10)

    # prepares some registered comment
    warnings.each do |warning|
      warning.comment = Comment.create(:risk_type_id          => 2,
                                       :warning_id            => warning.id,
                                       :warning_description   => "warning description for warning #{warning.id}",
                                       :sample_source_code    => "sample source code for warning #{warning.id}",
                                       :status                => true)

      warning.comment.save
    end
    access_analysis_result_report_page_as_reviewer

    show_comments_button_xpath = element_xpath("show_comments_button")
    if ($lang == 'en')
    hide_comments_button_xpath = element_xpath("hide_comments_button")
    else
      hide_comments_button_xpath = element_xpath("hide_comments_button_ja")
    end
    # shows all comments
    click(show_comments_button_xpath)

    assert(is_element_present(hide_comments_button_xpath))
    # hides all comments
    click(hide_comments_button_xpath)

    # all registered comments must be hidden
   #  wait_for_style(element_xpath("comment_editor_div"),
   #      "display: none;")
    expected_style = "display: none;"
    warnings.each do |warning|
      comment_div_id    = "comment_#{warning.comment.id}"
      comment_div_xpath = "//div[@id='#{comment_div_id}']"
      comment_div_style = (get_style(comment_div_xpath) rescue "")
      assert_equal(expected_style,
        comment_div_style)
    end
    logout

    access_analysis_result_report_page_as_pj_member
     show_comments_button_xpath = element_xpath("show_comments_button")
    if ($lang == 'en')
    hide_comments_button_xpath = element_xpath("hide_comments_button")
    else
      hide_comments_button_xpath = element_xpath("hide_comments_button_ja")
    end
    # shows all comments
    click(show_comments_button_xpath)
    assert(is_element_present(hide_comments_button_xpath))
    # hides all comments
    click(hide_comments_button_xpath)
    # all registered comments must be hidden
    expected_style = "display: none;"
    warnings.each do |warning|
      comment_div_id    = "comment_#{warning.comment.id}"
      comment_div_xpath = "//div[@id='#{comment_div_id}']"
      comment_div_style = (get_style(comment_div_xpath))
     assert_equal(expected_style,comment_div_style)
    end
    logout
  end

  def test_034
    # gets warnings of the report
    warning = Warning.find(:first,
                          :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                          :conditions  => {"source_codes.result_id" => RESULT_ID})

    access_analysis_result_report_page_as_reviewer

    warning_div_tag_id  = "warning_#{warning.id}"
    add_link_xpath      = "//div[@id='#{warning_div_tag_id}']/a[1]"

    click(add_link_xpath)
     comment_editor

    # the risk type combobox must be displayed
    assert(is_element_present(element_xpath("risk_type_combobox")))

    logout
  end

  def test_035
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    access_analysis_result_report_page_as_reviewer

    warning_div_tag_id  = "warning_#{warning.id}"
    add_link_xpath      = "//div[@id='#{warning_div_tag_id}']/a[1]"

    click(add_link_xpath)
    comment_editor

    # changes the selected risk type
    new_risk_type_id = 5
    risk_type_combobox_xpath = element_xpath("risk_type_combobox")
    select(risk_type_combobox_xpath,
      "value=#{new_risk_type_id}")

    # the risk type description is updated
    expected_risk_type_description = RiskType.find(new_risk_type_id).description
    risk_type_description = get_text(element_xpath("risk_type_description"))
    assert_equal(expected_risk_type_description,
      risk_type_description)

    logout
  end

  def test_036
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    access_analysis_result_report_page_as_reviewer

    warning_div_tag_id  = "warning_#{warning.id}"
    add_link_xpath      = "//div[@id='#{warning_div_tag_id}']/a[1]"

    click(add_link_xpath)

   comment_editor

    # the "Reference" button is displayed
    assert(is_element_present(element_xpath("reference_button")))

    logout
  end

  def test_037
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    access_analysis_result_report_page_as_reviewer

    warning_div_tag_id  = "warning_#{warning.id}"
    add_link_xpath      = "//div[@id='#{warning_div_tag_id}']/a[1]"

    click(add_link_xpath)

     comment_editor
     sleep 5

    # there is a text box for entering warning description
    assert(is_element_present(element_xpath("warning_description_editor_frame")))
    # there is a "Show toolbar" for this text box
    assert(is_element_present(element_xpath("warning_description_show_toolbar_button")))

    # but the toolbar is initialy hidden
    select_frame(element_xpath("warning_description_frame"))

    expected_style  = /display: none/
    assert(is_element_present(element_xpath("warning_description_toolbar")))
    toolbar_style   = get_style(element_xpath("warning_description_toolbar"))
    assert_match(expected_style,toolbar_style)

    logout
  end

  def test_038
    ## gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    access_analysis_result_report_page_as_reviewer

    warning_div_tag_id  = "warning_#{warning.id}"
    add_link_xpath      = "//div[@id='#{warning_div_tag_id}']/a[1]"

    click(add_link_xpath)

       comment_editor
    sleep 5

    # there is a text box for entering sample source code
    assert(is_element_present(element_xpath("sample_source_code_editor_frame")))

    # there is a "Show toolbar" for this text box
    assert(is_element_present(element_xpath("sample_source_code_show_toolbar_button")))

    # but the toolbar is initialy hidden
    expected_style  = /display: none/
    select_frame(element_xpath("sample_source_code_frame"))
    toolbar_style   = get_style(element_xpath("sample_source_code_toolbar"))


    assert_match(expected_style,toolbar_style)

    logout
  end

  def test_039
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    access_analysis_result_report_page_as_reviewer

    warning_div_tag_id  = "warning_#{warning.id}"
    add_link_xpath      = "//div[@id='#{warning_div_tag_id}']/a[1]"

    click(add_link_xpath)
    comment_editor
    sleep 5

    # all text boxes are initially blank
    expected_content = ""
    warning_description, sample_source_code = get_comment_editor_contents

    assert_equal(expected_content, warning_description)
    assert_equal(expected_content, sample_source_code)

    logout
  end

  def test_040
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    access_analysis_result_report_page_as_reviewer

    warning_div_tag_id  = "warning_#{warning.id}"
    add_link_xpath      = "//div[@id='#{warning_div_tag_id}']/a[1]"

    click(add_link_xpath)

       comment_editor

    # the "Register" button is displayed
    assert(is_element_present(element_xpath("register_button")))

    logout
  end

  def test_041
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    access_analysis_result_report_page_as_reviewer

    warning_div_tag_id  = "warning_#{warning.id}"
    add_link_xpath      = "//div[@id='#{warning_div_tag_id}']/a[1]"

    click(add_link_xpath)

     comment_editor

    # the "Temporary Save" button is displayed
    assert(is_element_present(element_xpath("temporary_save_button")))

    logout
  end

  def test_042
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    access_analysis_result_report_page_as_reviewer

    warning_div_tag_id  = "warning_#{warning.id}"
    add_link_xpath      = "//div[@id='#{warning_div_tag_id}']/a[1]"

    click(add_link_xpath)

     comment_editor

    # the "Cancel" link is displayed
    assert(is_element_present(element_xpath("cancel_link")))

    logout
  end

  def test_043
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    # creates a comment for the warning
    warning.comment = Comment.create(:risk_type_id        => 1,
                                     :warning_id          => warning.id,
                                     :warning_description => "description for warning (#{warning.id})",
                                     :sample_source_code  => "sample source code for warning (#{warning.id})",
                                     :status              => true)

    access_analysis_result_report_page_as_reviewer

    warning_div_tag_id  = "warning_#{warning.id}"
    edit_link_xpath      = "//div[@id='#{warning_div_tag_id}']/a[2]"

    click(edit_link_xpath)

   comment_editor
    # the "Delete" link is displayed
    assert(is_element_present(element_xpath("delete_link")))

    logout
  end

  def test_044
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    # creates a comment for the warning
    warning.comment = Comment.create(:risk_type_id        => 1,
                                     :warning_id          => warning.id,
                                     :warning_description => "description for warning (#{warning.id})",
                                     :sample_source_code  => "sample source code for warning (#{warning.id})",
                                     :status              => true)

    access_analysis_result_report_page_as_reviewer

    # opens "Comment Editor" subwindow
    warning_div_tag_id  = "warning_#{warning.id}"
    edit_link_xpath      = "//div[@id='#{warning_div_tag_id}']/a[2]"
    click(edit_link_xpath)

     comment_editor
    sleep 5

    expected_warning_description = warning.comment.warning_description
    expected_sample_source_code  = warning.comment.sample_source_code
    # gets contents of the textboxes
    warning_description, sample_source_code = get_comment_editor_contents

    # the contents of the textboxes must be similar to the record in database
    assert_equal(expected_warning_description, warning_description)
    assert_equal(expected_sample_source_code, sample_source_code)
    logout
  end

  def test_045
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    # creates a comment for the warning
    warning.comment = Comment.create(:risk_type_id        => 1,
                                     :warning_id          => warning.id,
                                     :warning_description => "description for warning (#{warning.id})",
                                     :sample_source_code  => "sample source code for warning (#{warning.id})",
                                     :status              => true)

    access_analysis_result_report_page_as_reviewer

    # opens "Comment Editor" subwindow
    warning_div_tag_id  = "warning_#{warning.id}"
    edit_link_xpath      = "//div[@id='#{warning_div_tag_id}']/a[2]"
    click(edit_link_xpath)
    comment_editor
    sleep 5

    # gets data in database
    expected_old_risk_type_id           = warning.comment.risk_type_id.to_s
    expected_old_risk_type_description  = warning.comment.risk_type.description

    # gets displayed contents
    risk_type_combobox_xpath            = element_xpath("risk_type_combobox")
    risk_type_description_xpath         = element_xpath("risk_type_description")
    old_risk_type_id                  = get_value(risk_type_combobox_xpath)
    old_risk_type_description         = get_text(risk_type_description_xpath)

    # displayed contents must be similar to data in database
    assert_equal(expected_old_risk_type_id,
      old_risk_type_id)
    assert_equal(expected_old_risk_type_description,
      old_risk_type_description)

    # changes the selected risk type
    new_risk_type_id = 5
    select(risk_type_combobox_xpath,
      "value=#{new_risk_type_id}")
    # gets description of the new risk type from database
    expected_new_risk_type_description  = RiskType.find_by_id(new_risk_type_id).description
    # and new description on the editor
    new_risk_type_description           = get_text(risk_type_description_xpath)
    # the displayed description must be similar to the one in database
    assert_equal(expected_new_risk_type_description,
      new_risk_type_description)

    logout
  end

  def test_046
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    access_analysis_result_report_page_as_reviewer

    # opens "Comment Editor" subwindow
    warning_div_tag_id  = "warning_#{warning.id}"
    edit_link_xpath      = "//div[@id='#{warning_div_tag_id}']/a[1]"
    click(edit_link_xpath)

     comment_editor
    sleep 5

    # use default risk type
    # makes sure that the warning description textbox empty
    set_comment_editor_contents
    # clicks "Temporary Save" button
    click(element_xpath("register_button"))

    # validates the alert message
    expected_message  = _("Warning description must be filled!")
    message           = get_alert()
    assert_equal(expected_message,
      message)

    # no new comment is record
    assert_equal(0,
                 Comment.count)

    logout
  end
  def test_047
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    access_analysis_result_report_page_as_reviewer

    # opens "Comment Editor" subwindow
    warning_div_tag_id  = "warning_#{warning.id}"
    edit_link_xpath      = "//div[@id='#{warning_div_tag_id}']/a[1]"
    click(edit_link_xpath)

    comment_editor
    sleep 5

    # use default risk type
    # makes sure that the warning description textbox empty
    set_comment_editor_contents
    # clicks "Temporary Save" button
    click(element_xpath("temporary_save_button"))

    # validates the alert message
    expected_message  = _("Warning description must be filled!")
    message           = get_alert()
    assert_equal(expected_message,
      message)

    # no new comment is record
    assert_equal(0,Comment.count)

    logout
  end

  def test_048
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    access_analysis_result_report_page_as_reviewer

    # opens "Comment Editor" subwindow
    warning_div_tag_id  = "warning_#{warning.id}"
    add_link_xpath     = "//div[@id='#{warning_div_tag_id}']/a[1]"
    click(add_link_xpath)

  comment_editor
    sleep 5

    # use default risk type
    # makes sure that the warning description textbox empty
    set_comment_editor_contents("Warning description for warning (#{warning.id})")
    # clicks "Register" button
    click(element_xpath("register_button"))
    wait_for_style(element_xpath("comment_editor_div"), "display: none;")

    # the message “Comment is registered!” must be displayed
    verify(is_text_present($messages["register_comment"]))
    sleep 10

    # the warning on Analysis Result Report page has been updated with [Comment], [Edit], [Delete] links
    comment_link_xpath  = "//div[@id='#{warning_div_tag_id}']/a[1]"
    edit_link_xpath     = "//div[@id='#{warning_div_tag_id}']/a[2]"
    delete_link_xpath   = "//div[@id='#{warning_div_tag_id}']/a[3]"
    verify(is_element_present(comment_link_xpath))
    verify(is_element_present(edit_link_xpath))
    verify(is_element_present(delete_link_xpath))

    logout
  end

  def test_049
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    access_analysis_result_report_page_as_reviewer

    # opens "Comment Editor" subwindow
    warning_div_tag_id  = "warning_#{warning.id}"
    add_link_xpath     = "//div[@id='#{warning_div_tag_id}']/a[1]"
    click(add_link_xpath)

    comment_editor
    sleep 5

    # use default risk type
    # makes sure that the warning description textbox empty
    select_frame(element_xpath("warning_description_frame"))
    select_frame(element_xpath("warning_description_editor_frame"))
    type(element_xpath("warning_description_body"),
      "Warning description for warning (#{warning.id})")
    # back to comment editor
    select_frame("relative=parent")
    select_frame("relative=parent")
    # clicks "Temporary Save" button
    click(element_xpath("temporary_save_button"))
    wait_for_style(element_xpath("comment_editor_div"),
      "display: none;")

    # the message “Comment is registered!” must be displayed
    verify(is_text_present($messages["temporary_save_comment"]))

    # the warning on Analysis Result Report page has been updated with [Edit], [Delete] links
    edit_link_xpath     = "//div[@id='#{warning_div_tag_id}']/a[1]"
    delete_link_xpath   = "//div[@id='#{warning_div_tag_id}']/a[2]"
    verify(is_element_present(edit_link_xpath))

    verify("["+_("Edit")+"]",
      get_text(edit_link_xpath))
    verify(is_element_present(delete_link_xpath))
    verify("["+_("Delete")+"]",
      get_text(edit_link_xpath))
    logout
  end

  def test_050
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    access_analysis_result_report_page_as_reviewer

    # opens "Comment Editor" subwindow
    warning_div_id      = "warning_#{warning.id}"
    warning_div_xpath   = "//div[@id='#{warning_div_id}']"
    add_link_xpath      = "#{warning_div_xpath}/a[1]"
    click(add_link_xpath)

    old_content   = get_text(warning_div_xpath)
    comment_editor
    sleep 5

    # use default risk type
    # makes sure that the warning description textbox not empty
    set_comment_editor_contents("warning descrption for warning #{warning.id}", "")

    # clicks on "Cancel" link
    click(element_xpath("cancel_link"))
    # waits until the Comment Editor is closed

        comment_editor



#    wait_for_style(element_xpath("comment_editor_div"),
#      "display: none;")

    # there is no change
    new_content   = get_text(warning_div_xpath)
    verify_equal(old_content,
                 new_content)

    logout
  end

  def test_051
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    # prepares a comment for this warning
    warning.comment = Comment.create(:risk_type_id        => 1,
                                     :warning_id          => warning.id,
                                     :warning_description => "description for warning (#{warning.id})",
                                     :sample_source_code  => "sample source code for warning (#{warning.id})",
                                     :status              => false)

    access_analysis_result_report_page_as_reviewer

    # opens "Comment Editor" subwindow
    warning_div_id      = "warning_#{warning.id}"
    warning_div_xpath   = "//div[@id='#{warning_div_id}']"
    edit_link_xpath      = "#{warning_div_xpath}/a[1]"
    click(edit_link_xpath)

  comment_editor
    sleep 5

    # makes sure that a "Delete" link exists
    delete_link_xpath = element_xpath("delete_link")
    assert(is_element_present(delete_link_xpath))

    # clicks on "Delete" link
    choose_cancel_on_next_confirmation

    click(delete_link_xpath)

    # the confirmation message must be "Are you sure?"
    expected_confirmation_message = $messages["comment_deleting_confirmation"]
    confirmation_message          = get_confirmation
    assert_equal(expected_confirmation_message,
                 confirmation_message)

    logout
  end

  def test_052
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    # prepares a comment for this warning
    warning.comment = Comment.create(:risk_type_id        => 1,
                                     :warning_id          => warning.id,
                                     :warning_description => "description for warning (#{warning.id})",
                                     :sample_source_code  => "sample source code for warning (#{warning.id})",
                                     :status              => false)

    access_analysis_result_report_page_as_reviewer

    # opens "Comment Editor" subwindow
    warning_div_id      = "warning_#{warning.id}"
    warning_div_xpath   = "//div[@id='#{warning_div_id}']"
    edit_link_xpath     = "#{warning_div_xpath}/a[1]"
    delete_link_xpath   = "#{warning_div_xpath}/a[2]"
    click(edit_link_xpath)
    comment_editor
    sleep 5

    # makes sure that a "Delete" link exists
    delete_link_xpath = element_xpath("delete_link")
    assert(is_element_present(delete_link_xpath))

    # clicks on "Delete" link and confirm
    choose_ok_on_next_confirmation

    click(delete_link_xpath)

    # the confirmation message must be "Are you sure?"
    expected_confirmation_message = $messages["comment_deleting_confirmation"]
    confirmation_message          = get_confirmation
    assert_equal(expected_confirmation_message,
      confirmation_message)

    # waits until the Comment Editor is closed

        comment_editor

    expected_message = $messages["delete_comment_successfully"]
    wait_for_text_present(expected_message)
    sleep 5

    # the warning is updated
    ## delete link dissappeared
    assert_not_equal("["+_("Delete")+"]",
      get_text(delete_link_xpath))
    # [Edit] link was changed to [Add] link
    assert_equal("["+_("Add")+"]",
      get_text(edit_link_xpath))

    logout
  end

  def test_053
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    access_analysis_result_report_page_as_reviewer

    # opens "Comment Editor" subwindow
    warning_div_id      = "warning_#{warning.id}"
    warning_div_xpath   = "//div[@id='#{warning_div_id}']"
    add_link_xpath      = "#{warning_div_xpath}/a[1]"
    click(add_link_xpath)

   comment_editor
    sleep 5

    # the toolbar is showed if its style does not match the followed unexpected style
    unexpected_style = /display: none;/
    # displays the toolbar of warning description textbox by clicking on
    # corresponding "Show toolbar" button
    click element_xpath("warning_description_show_toolbar_button")
    select_frame(element_xpath("warning_description_frame"))
    warning_description_toolbar_xpath   = element_xpath("warning_description_toolbar")
    warning_description_toolbar_style   = get_style(warning_description_toolbar_xpath)

    assert_no_match(unexpected_style,
      warning_description_toolbar_style)

    select_frame("relative=parent")

    # displays the toolbar of warning description textbox by clicking on
    # corresponding "Show toolbar" button
    click element_xpath("sample_source_code_show_toolbar_button")
    select_frame(element_xpath("sample_source_code_frame"))
    sample_source_code_toolbar_xpath = element_xpath("sample_source_code_toolbar")
    sample_source_code_toolbar_style = get_style(sample_source_code_toolbar_xpath)
    assert_no_match(unexpected_style,
                    sample_source_code_toolbar_style)

    logout
  end

  def test_054
    # gets warnings of the report
    warning = Warning.find(:first,
      :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
      :conditions  => {"source_codes.result_id" => RESULT_ID})

    access_analysis_result_report_page_as_reviewer

    # opens "Comment Editor" subwindow
    warning_div_id      = "warning_#{warning.id}"
    warning_div_xpath   = "//div[@id='#{warning_div_id}']"
    add_link_xpath      = "#{warning_div_xpath}/a[1]"
    click(add_link_xpath)

    comment_editor
    sleep 5

    # the toolbar is hidden if its style matches the followed unexpected style
    expected_style = /display: none;/
    # displays the toolbar of warning description textbox by clicking on
    # corresponding "Show toolbar" button
    click element_xpath("warning_description_show_toolbar_button")
    # then clicks on "Hide toolbar" button to hide corresponding toolbar
    if ($lang == 'en')
    click element_xpath("warning_description_hide_toolbar_button_en")
    else
      click element_xpath("warning_description_hide_toolbar_button_ja")
    end


    select_frame(element_xpath("warning_description_frame"))
    warning_description_toolbar_xpath   = element_xpath("warning_description_toolbar")
    warning_description_toolbar_style   = get_style(warning_description_toolbar_xpath)

    assert_match(expected_style,
      warning_description_toolbar_style)

    select_frame("relative=parent")

    # displays the toolbar of warning description textbox by clicking on
    ## corresponding "Show toolbar" button

    click element_xpath("sample_source_code_show_toolbar_button")
    ## then hides this toolbar by clicking on "Hide toolbar"
    if ($lang =='en')
    click element_xpath("sample_source_code_hide_toolbar_button_en")
    else
    click element_xpath("sample_source_code_hide_toolbar_button_ja")
    end

    select_frame(element_xpath("sample_source_code_frame"))
    sample_source_code_toolbar_xpath = element_xpath("sample_source_code_toolbar")
    sample_source_code_toolbar_style = get_style(sample_source_code_toolbar_xpath)
    assert_match(expected_style,
                 sample_source_code_toolbar_style)

    logout
  end

  def test_055
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    access_analysis_result_report_page_as_reviewer

    # opens "Comment Editor" subwindow
    warning_div_id      = "warning_#{warning.id}"
    warning_div_xpath   = "//div[@id='#{warning_div_id}']"
    add_link_xpath      = "#{warning_div_xpath}/a[1]"
    click(add_link_xpath)
    comment_editor
    sleep 5

    # clicks on "Reference" button to open "Referred comment list" subwindow
    click element_xpath("reference_button")
   referred_commen_list


    logout
  end

  def test_056
    subtask = Subtask.find(SUB_ID)
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    access_analysis_result_report_page_as_reviewer

    # opens "Comment Editor" subwindow
    warning_div_id      = "warning_#{warning.id}"
    warning_div_xpath   = "//div[@id='#{warning_div_id}']"
    add_link_xpath      = "#{warning_div_xpath}/a[1]"
    click(add_link_xpath)
    comment_editor
    sleep 5

    # clicks on "Reference" button to open "Referred comment list" subwindow
    click element_xpath("reference_button")
    referred_commen_list
    # the rule number must be displayed
    expected_rule_number  = warning.rule
    Message.find(:first,
                 :conditions => {:tools_message_id => warning.rule,
                 :analyze_tool_id => subtask.analyze_tool_id}).contents =~ /.*e?<td valign=top width="70%"><b>(.*)?<\/b><\/td>.*?/

    expected_rule_message = $1

    rule_number           = get_text(element_xpath("referred_rule_number"))
    rule_message          = get_text(element_xpath("referred_rule_message"))

    assert_equal(expected_rule_message,
      rule_message)

    assert_equal(expected_rule_number,
                 rule_number)

    logout
  end

  def test_057# gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id"  => RESULT_ID,
                                            "warnings.rule"           => "2017"})

     #prepares some registered comments for warnings which have the same rule
    warnings = Warning.find(:all,
                            :limit      => 3,
                            :joins      => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                            :conditions => {"source_codes.result_id" => RESULT_ID,
                                            "warnings.rule"          => warning.rule})

    warnings.each do |w|
      w.comment = Comment.create(:risk_type_id        => 1,
                                 :warning_id          => w.id,
                                 :warning_description => "description for warning (#{w.id})",
                                 :sample_source_code  => "sample source code for warning (#{w.id})",
                                 :status              => true)
    end

    access_analysis_result_report_page_as_reviewer

     #opens "Comment Editor" subwindow
    warning_div_id      = "warning_#{warning.id}"
    warning_div_xpath   = "//div[@id='#{warning_div_id}']"
    edit_link_xpath     = "#{warning_div_xpath}/a[2]"
    click(edit_link_xpath)
    comment_editor
    sleep 5
     #clicks on "Reference" button to open "Referred comment list" subwindow
    click element_xpath("reference_button")
    referred_commen_list
     #all relating comments must be listed
    warnings.each do |w|
       #warning description
      assert(is_text_present(w.comment.warning_description))
       #sample source code
      assert(is_text_present(w.comment.sample_source_code))
    end

    logout
  end

  def test_058
    # gets a warning of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id"  => RESULT_ID,
                                            "warnings.rule"           => "2017"})

    # prepares a comment for the selected warning
    warning.comment = Comment.create(:risk_type_id        => 1,
                                     :warning_id          => warning.id,
                                     :warning_description => "description for warning (#{warning.id})",
                                     :sample_source_code  => "sample source code for warning (#{warning.id})",
                                     :status              => true)

    access_analysis_result_report_page_as_reviewer

    # opens "Comment Editor" subwindow
    warning_div_id      = "warning_#{warning.id}"
    warning_div_xpath   = "//div[@id='#{warning_div_id}']"
    edit_link_xpath     = "#{warning_div_xpath}/a[2]"
     click(edit_link_xpath)
    comment_editor
    sleep 5
    # clicks on "Reference" button to open "Referred comment list" subwindow
    click element_xpath("reference_button")
    referred_commen_list
    # a radio button is attached to the left-hand side of each comment
    referred_comment_list_xpath = element_xpath("referred_comment_list")
    radio_button_xpath          = "#{referred_comment_list_xpath}/div/div/*[1]"
    warning_description_xpath   = "#{referred_comment_list_xpath}/div/div/*[2]"

    assert(is_element_present(radio_button_xpath))
    assert(is_element_present(warning_description_xpath))

    logout
  end

  def test_059
    # gets warnings of the report
    warning = Warning.find(:first,
      :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
      :conditions  => {"source_codes.result_id"  => RESULT_ID,
        "warnings.rule"           => RULE_NUMBER})

    # prepares some registered comments for warnings which have the same rule
    warnings = Warning.find(:all,
                            :joins      => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
      :conditions => {"source_codes.result_id" => RESULT_ID,
        "warnings.rule"          => warning.rule})

    warnings.each do |w|
      w.comment = Comment.create(:risk_type_id        => 1,
                                 :warning_id          => w.id,
                                 :warning_description => "description for warning (#{w.id})",
                                 :sample_source_code  => "sample source code for warning (#{w.id})",
                                 :status              => true)
    end

    access_analysis_result_report_page_as_reviewer

    # opens "Comment Editor" subwindow
    warning_div_id      = "warning_#{warning.id}"
    warning_div_xpath   = "//div[@id='#{warning_div_id}']"
    edit_link_xpath     = "#{warning_div_xpath}/a[2]"
     click(edit_link_xpath)
    comment_editor
    sleep 5
    # clicks on "Reference" button to open "Referred comment list" subwindow
    click element_xpath("reference_button")
    referred_commen_list
    # page links is displayed
    assert(is_element_present(element_xpath("referred_comment_list_page_links")))

    logout
  end

  def test_060
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id"  => RESULT_ID,
                                            "warnings.rule"           => RULE_NUMBER})

    # prepares some registered comments for warnings which have the same rule
    warnings = Warning.find(:all,
                            :joins      => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                            :conditions => {"source_codes.result_id" => RESULT_ID,
                                            "warnings.rule"          => warning.rule})

    warnings.each do |w|
      w.comment = Comment.create(:risk_type_id        => 1,
                                 :warning_id          => w.id,
                                 :warning_description => "description for warning (#{w.id})",
                                 :sample_source_code  => "sample source code for warning (#{w.id})",
                                 :status              => true)
    end

    access_analysis_result_report_page_as_reviewer

    # opens "Comment Editor" subwindow
    warning_div_id      = "warning_#{warning.id}"
    warning_div_xpath   = "//div[@id='#{warning_div_id}']"
    edit_link_xpath     = "#{warning_div_xpath}/a[2]"
     click(edit_link_xpath)
    comment_editor

    # all text boxes are initially blank
    old_warning_description, old_sample_source_code = get_comment_editor_contents
    # clicks on "Reference" button to open "Referred comment list" subwindow
    click element_xpath("reference_button")
    referred_commen_list
    click(element_xpath("referred_comment_list_cancel_button"))
    # all text boxes are initially blank
    new_warning_description, new_sample_source_code = get_comment_editor_contents

    assert_equal(old_warning_description,new_warning_description)

    assert_equal(old_sample_source_code,new_sample_source_code)

    logout
  end

  def test_061
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id"  => RESULT_ID,
                                            "warnings.rule"           => RULE_NUMBER})

    # prepares some registered comments for warnings which have the same rule
    warnings = Warning.find(:all,
                            :joins      => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                            :conditions => {"source_codes.result_id" => RESULT_ID,
                                            "warnings.rule"          => warning.rule})

    warnings.each do |w|
      w.comment = Comment.create(:risk_type_id        => 1,
                                 :warning_id          => w.id,
                                 :warning_description => "description for warning (#{w.id})",
                                 :sample_source_code  => "sample source code for warning (#{w.id})",
                                 :status              => true)
    end

    access_analysis_result_report_page_as_reviewer

    # opens "Comment Editor" subwindow
    warning_div_id      = "warning_#{warning.id}"
    warning_div_xpath   = "//div[@id='#{warning_div_id}']"
    edit_link_xpath     = "#{warning_div_xpath}/a[2]"
    click(edit_link_xpath)
    comment_editor
    sleep 5
    # Opens "Referred Comment List" window
    click element_xpath("reference_button")
    sleep 5

    referred_comment_list_xpath = element_xpath("referred_comment_list")
    radio_button_xpath          = "#{referred_comment_list_xpath}/div[3]/div/*[1]"

    # clicks on radio button
    click(radio_button_xpath)

    # this radio button is selected
    assert(is_checked(radio_button_xpath))

    logout
  end

  def test_062
    # gets warnings of the report
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id"  => RESULT_ID,
                                            "warnings.rule"           => RULE_NUMBER})

    # prepares some registered comments for warnings which have the same rule
    warnings = Warning.find(:all,
                            :joins      => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                            :conditions => {"source_codes.result_id" => RESULT_ID,
                                            "warnings.rule"          => warning.rule})

    warnings.each do |w|
      w.comment = Comment.create(:risk_type_id        => 1,
                                 :warning_id          => w.id,
                                 :warning_description => "description for warning (#{w.id})",
                                 :sample_source_code  => "sample source code for warning (#{w.id})",
                                 :status              => true)
    end

    access_analysis_result_report_page_as_reviewer

    # opens "Comment Editor" subwindow
    warning_div_id      = "warning_#{warning.id}"
    warning_div_xpath   = "//div[@id='#{warning_div_id}']"
    edit_link_xpath     = "#{warning_div_xpath}/a[2]"
    click(edit_link_xpath)
    click(edit_link_xpath)
    comment_editor
    sleep 5
    # clicks on "Reference" button to open "Referred comment list" subwindow
    click element_xpath("reference_button")
    referred_commen_list
    # selects an existing comment to refer
    referred_comment_list_xpath         = element_xpath("referred_comment_list")
    radio_button_xpath                  = "#{referred_comment_list_xpath}/div[3]/div/*[1]"
    referred_warning_description_xpath  = "#{referred_comment_list_xpath}/div[3]/div/*[2]"
    referred_sample_source_code_xpath   = "#{referred_comment_list_xpath}/div[3]/div[2]"

    ## clicks on radio button
    click(radio_button_xpath)

    ## gets referred contents
    referred_warning_description = get_text(referred_warning_description_xpath)
    referred_sample_source_code  = (get_text(referred_sample_source_code_xpath) rescue "")

    # returns "Comment Editor" window
    #clicks "OK" button
    click(element_xpath("referred_comment_list_ok_button"))
    # waits a little time
    comment_editor
    sleep 5

    # checks the new contents of "Comment Editor" window  get_comment_editor_contents
    new_warning_description, new_sample_source_code = get_comment_editor_contents
    ## new contents must be same to referred contents
    assert_equal(referred_warning_description,
      new_warning_description)
    assert_equal(referred_sample_source_code,
      new_sample_source_code)

    logout
  end

  def test_063
    # accesses "Warning Listing Page" as a reviewer
    access_warning_listing_page_for_subtask_as_reviewer

    # checks the existence of "CommentListing", "Download CSV format", "Upload CSV format" buttons
    ## "CommentListing" button
    assert(is_element_present(element_xpath("comment_listing_button")))
    ## "Download CSV format" button
    assert(is_element_present(element_xpath("download_csv_button")))
    ## "Upload CSV format" button
    assert(is_element_present(element_xpath("upload_csv_button")))
    # logout
    logout
  end

  def test_064
    # makes sure that the wanted subtask is publiczed
    subtask = Subtask.find(SUB_ID)
    subtask.review.publicized = true
    subtask.review.save!

    access_warning_listing_page_for_subtask_as_pj_member
    # the subtask is publicized, pj_member can see "CommentListing" button
    assert(is_element_present(element_xpath("comment_listing_button")))

    logout
  end

  def test_065
    access_warning_listing_page_for_subtask_as_pj_member
    # the subtask is unpublicized, pj_member can not see "CommentListing" button
    assert(is_element_not_present(element_xpath("comment_listing_button")))

    logout
  end

  def test_066
    access_warning_listing_page_for_subtask_as_reviewer
    # checks the existence of elements
    ## "Search" box
    assert(is_element_present(element_xpath("search_button")))
    ## HTML table
    assert(is_element_present(element_xpath("warning_list_table")))
    logout
    access_warning_listing_page_for_subtask_as_pj_member
    # checks the existence of elements
    ## "Search" box
    assert(is_element_present(element_xpath("search_button")))
    ## HTML table
    assert(is_element_present(element_xpath("warning_list_table")))

    logout
  end

  def test_067
    # makes sure that this subtask has no warning
    results = Result.find(:all,
      :conditions => {:subtask_id => SUB_ID})
    results.each do |result|
      result.subtask_id = 1000
      result.save
    end

    access_warning_listing_page_for_subtask_as_reviewer
    # checks the existence of elements
    ## no HTML table
    assert(is_element_not_present(element_xpath("warning_list_table")))
    verify(is_text_present(_("No warning found.")))

    logout

    access_warning_listing_page_for_subtask_as_pj_member
    # checks the existence of elements
    ## no HTML table
    assert(is_element_not_present(element_xpath("warning_list_table")))
   verify(is_text_present(_("No warning found.")))

    logout

    # rollback
    results.each do |result|
      result.subtask_id = SUB_ID
      result.save
    end
  end

  def test_068
    access_warning_listing_page_for_subtask_as_reviewer
    assert(is_element_present(element_xpath("page_links")))
    logout

    access_warning_listing_page_for_subtask_as_pj_member
    assert(is_element_present(element_xpath("page_links")))
    logout
  end

  def test_069
    # makes sure that the wanted subtask is publiczed
    subtask                   = Subtask.find(SUB_ID)
    subtask.review.publicized = true
    subtask.review.save!

    access_warning_listing_page_for_subtask_as_reviewer

    # Show HTML table with conditions below headers:
    # + ID
    # + Directory
    # + Source name
    # + File name
    # + Line number
    # + Character number
    # + Rule number
    # + Warning Message,
    # + Code
    # + Reference
    # + Comment
    header_xpaths     = element_xpath("warning_list_headers")
    header_xpaths[0..10].each do |header_xpath|
      header_index          = header_xpaths.index(header_xpath)
      expected_header_text  = WARNING_LIST_HEADERS[header_index]
      header_text           = get_text(header_xpath)

      assert_equal(expected_header_text,
        header_text)
    end
    logout
  end

  def test_070
    # makes sure that the wanted subtask is unpubliczed
    subtask                   = Subtask.find(SUB_ID)
    old_review_status         = subtask.review.publicized
    subtask.review.publicized = false
    subtask.review.save!

    access_warning_listing_page_for_subtask_as_reviewer

    # Show HTML table with conditions below headers:
    # + ID
    # + Directory
    # + Source name
    # + File name
    # + Line number
    # + Character number
    # + Rule number
    # + Warning Message,
    # + Code
    # + Reference
    # + Comment
    # + Status
    # + Actions
    header_xpaths     = element_xpath("warning_list_headers")
    header_xpaths.each do |header_xpath|
      header_index          = header_xpaths.index(header_xpath)
      expected_header_text  = WARNING_LIST_HEADERS[header_index]
      header_text           = get_text(header_xpath)

      assert_equal(expected_header_text,
        header_text)
    end
    logout

    # rollback
    subtask.review.publicized = old_review_status
    subtask.review.save
  end

  def test_071
    # makes sure that the wanted subtask is publiczed
    subtask                   = Subtask.find(SUB_ID)
    subtask.review.publicized = true
    subtask.review.save!

    access_warning_listing_page_for_subtask_as_pj_member

    # Show HTML table with conditions below headers:
    # + ID
    # + Directory
    # + Source name
    # + File name
    # + Line number
    # + Character number
    # + Rule number
    # + Warning Message,
    # + Code
    # + Reference
    # + Comment
    header_xpaths     = element_xpath("warning_list_headers")
    header_xpaths[0..10].each do |header_xpath|
      header_index          = header_xpaths.index(header_xpath)
      expected_header_text  = WARNING_LIST_HEADERS[header_index]
      header_text           = get_text(header_xpath)

      assert_equal(expected_header_text,
        header_text)
    end
    logout
  end

  def test_072
    access_warning_listing_page_for_subtask_as_pj_member

    # Show HTML table with conditions below headers:
    # + ID
    # + Directory
    # + Source name
    # + File name
    # + Line number
    # + Character number
    # + Rule number
    # + Warning Message,
    # + Code
    # + Reference
    header_xpaths     = element_xpath("warning_list_headers")
    header_xpaths[0..9].each do |header_xpath|
      header_index          = header_xpaths.index(header_xpath)
      expected_header_text  = WARNING_LIST_HEADERS[header_index]
      header_text           = get_text(header_xpath)

      assert_equal(expected_header_text,
        header_text)
    end
    logout
  end

  def test_073
    # gets a warning of this subtask
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})
    # creates a temporary saved comment for this warning
    #
    warning.comment = Comment.create(:risk_type_id        => 1,
                                     :warning_id          => warning.id,
                                     :warning_description => "description for warning (#{warning.id})",
                                     :sample_source_code  => "sample source code for warning (#{warning.id})",
                                     :status              => false)
    access_warning_listing_page_for_subtask_as_reviewer

    warning_xpath = "//tr[@id='warning_#{warning.id}']"

    verify_equal(GRAY_STYLE[BROWSER],
      get_style(warning_xpath))
    logout
  end

  def test_074
    # gets a warning of this subtask
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    access_warning_listing_page_for_subtask_as_reviewer

    warning_xpath   = "//tr[@id='warning_#{warning.id}']"
    add_link_xpath  = "#{warning_xpath}/td[13]/a[1]"

    # the link in "Action" column must be "[Add]"
    assert_equal("["+_("Add")+"]",get_text(add_link_xpath))

    logout
  end

  def test_075
    # gets a warning of this subtask
    warning = Warning.find(:first,
      :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
      :conditions  => {"source_codes.result_id" => RESULT_ID})
    warning.comment = Comment.create(:risk_type_id        => 1,
                                     :warning_id          => warning.id,
                                     :warning_description => "description for warning (#{warning.id})",
                                     :sample_source_code  => "sample source code for warning (#{warning.id})",
                                     :status              => true)
    # creates a comment for this warning
    access_warning_listing_page_for_subtask_as_reviewer

    warning_xpath     = "//tr[@id='warning_#{warning.id}']"
    edit_link_xpath   = "#{warning_xpath}/td[13]/a[1]"
    delete_link_xpath = "#{warning_xpath}/td[13]/a[2]"

    # the link in "Action" column must be "[Add]"
    assert_equal("["+_("Edit")+"]", get_text(edit_link_xpath))
    assert_equal("["+_("Delete")+"]", get_text(delete_link_xpath))

    logout
  end

  def test_076
    # gets a warning of this subtask
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})
    access_warning_listing_page_for_subtask_as_reviewer

    warning_xpath         = "//tr[@id='warning_#{warning.id}']"

    file_name_link_xpath  = "#{warning_xpath}//td[4]/a"

    href = get_attribute(file_name_link_xpath,"href") rescue ""
    expected_href = url_for(:controller => "review",
                            :action     => "view_result_report",
                            :pu         => PU_ID,
                            :pj         => PJ_ID,
                            :id         => ID,
                            :sub_id     => SUB_ID,
                            :result_id => warning.source_code.result_id)
    assert_equal(expected_href,href)

    logout

    access_warning_listing_page_for_subtask_as_pj_member

    warning_xpath         = "//tr[@id='warning_#{warning.id}']"

    file_name_link_xpath  = "#{warning_xpath}//td[4]/a"

    href = get_attribute(file_name_link_xpath,
                         "href") rescue ""
    expected_href = url_for(:controller => "review",
                            :action     => "view_result_report",
                            :pu         => PU_ID,
                            :pj         => PJ_ID,
                            :id         => ID,
                            :sub_id     => SUB_ID,
                            :result_id  => warning.source_code.result_id)
    assert_equal(expected_href,
                 href)

    logout
  end

  def test_077
    subtask                   = Subtask.find(SUB_ID)
    subtask.review.publicized = true
    subtask.review.save!

    access_warning_listing_page_for_subtask_as_reviewer

    click element_xpath("comment_listing_button")

    wait_for_page_to_load 30000

    # makes sure that we are now on "Comment Listing Page" for the subtask
    location          = get_location
    expected_location = SELENIUM_CONFIG["browserURL"] + url_for(:controller => "review",
                                                                :action     => "view_comment_list",
                                                                :pu         => PU_ID,
                                                                :pj         => PJ_ID,
                                                                :id         => ID,
                                                                :sub_id     => SUB_ID)
    assert_equal(expected_location,
      location)

    logout

    access_warning_listing_page_for_subtask_as_pj_member

    click element_xpath("comment_listing_button")

    wait_for_page_to_load 30000

    # makes sure that we are now on "Comment Listing Page" for the subtask
    location          = get_location
    expected_location = SELENIUM_CONFIG["browserURL"] + url_for(:controller => "review",
                                                                :action     => "view_comment_list",
                                                                :pu         => PU_ID,
                                                                :pj         => PJ_ID,
                                                                :id         => ID,
                                                                :sub_id     => SUB_ID)
    assert_equal(expected_location,
                 location)

    logout
  end

  def test_078
    # gets a warning of this subtask
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})
    access_warning_listing_page_for_subtask_as_reviewer

    warning_xpath         = "//tr[@id='warning_#{warning.id}']"
    file_name_link_xpath  = "#{warning_xpath}//td[4]/a"

    click(file_name_link_xpath)

    wait_for_page_to_load(30000)

    expected_new_location = SELENIUM_CONFIG["browserURL"] + url_for(:controller => "review",
                                                                    :action     => "view_result_report",
                                                                    :pu         => PU_ID,
                                                                    :pj         => PJ_ID,
                                                                    :id         => ID,
                                                                    :sub_id     => SUB_ID,
                                                                    :result_id  => warning.source_code.result_id)
    new_location = get_location

    assert_equal(expected_new_location,
      new_location)
    logout

    access_warning_listing_page_for_subtask_as_pj_member

    warning_xpath         = "//tr[@id='warning_#{warning.id}']"
    file_name_link_xpath  = "#{warning_xpath}//td[4]/a"

    click(file_name_link_xpath)

    wait_for_page_to_load(30000)

    expected_new_location = SELENIUM_CONFIG["browserURL"] + url_for(:controller => "review",
                                                                    :action     => "view_result_report",
                                                                    :pu         => PU_ID,
                                                                    :pj         => PJ_ID,
                                                                    :id         => ID,
                                                                    :sub_id     => SUB_ID,
                                                                    :result_id  => warning.source_code.result_id)
    new_location = get_location

    assert_equal(expected_new_location,
      new_location)
    logout
  end
  def test_079
    access_warning_listing_page_for_subtask_as_reviewer

    page_links_xpath    = element_xpath("page_links")
    new_page_link_xpath = "#{page_links_xpath}/a"
    new_page            = get_text(new_page_link_xpath)

    # gets new contents from the database
    warnings = Warning.paginate_by_subtask_id(SUB_ID,
      new_page)

    click new_page_link_xpath

    ## wait a little time for updating the table
    warnings.each do |warning|
      wait_for_text_present(warning.id)
    end
    ## makes sure that the warning list was updated
    warning_list_table_xpath = element_xpath("warning_list_table")
    total_rows = warnings.size
    (1..total_rows).each do |index|
      warning_xpath     = warning_list_table_xpath + "/tbody/tr[#{index}]"
      warning_id_xpath  = warning_xpath + "/td[1]"
      warning_id        = get_text(warning_id_xpath).to_i
      assert_equal(warning_id,
        warnings[index - 1].id)
    end

    logout

    access_warning_listing_page_for_subtask_as_pj_member

    page_links_xpath    = element_xpath("page_links")
    new_page_link_xpath = "#{page_links_xpath}/a"
    new_page            = get_text(new_page_link_xpath)

    # gets new contents from the database
    warnings = Warning.paginate_by_subtask_id(SUB_ID,
      new_page)

    click new_page_link_xpath

    ## wait a little time for updating the table
    warnings.each do |warning|
      wait_for_text_present(warning.id)
    end
    ## makes sure that the warning list was updated
    warning_list_table_xpath = element_xpath("warning_list_table")
    total_rows = warnings.size
    (1..total_rows).each do |index|
      warning_xpath     = warning_list_table_xpath + "/tbody/tr[#{index}]"
      warning_id_xpath  = warning_xpath + "/td[1]"
      warning_id        = get_text(warning_id_xpath).to_i
      assert_equal(warning_id,
        warnings[index - 1].id)
    end
  end

  def test_080
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})
    access_warning_listing_page_for_subtask_as_reviewer
    warning_xpath   = "//tr[@id='warning_#{warning.id}']"
    add_link_xpath  = "#{warning_xpath}/td[13]/a[1]"

    # clicks on "[Add]" link
    click add_link_xpath
    # waits until "Comment Editor" window is opened
    comment_editor

    expected_content = ""
    # all text boxes are initially blank
    warning_description, sample_source_code = get_comment_editor_contents
    assert_equal(expected_content,
      warning_description)
    assert_equal(expected_content,
      sample_source_code)

    # delete link does not exist
    assert(is_element_not_present(element_xpath("delete_link")))
    logout
  end

def test_081
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})
    warning.comment = Comment.create(:risk_type_id        => 1,
                                     :warning_id          => warning.id,
                                     :warning_description => "description for warning (#{warning.id})",
                                     :sample_source_code  => "sample source code for warning (#{warning.id})",
                                     :status              => true)

    access_warning_listing_page_for_subtask_as_reviewer
    warning_xpath   = "//tr[@id='warning_#{warning.id}']"
    edit_link_xpath  = "#{warning_xpath}/td[13]/a[1]"

    # clicks on "[Edit]" link
    click edit_link_xpath
    # waits until "Comment Editor" window is opened
    comment_editor
    wait_for_text_present(warning.comment.warning_description)
    sleep 5
    # all text boxes are similar to data in database
    warning_description, sample_source_code = get_comment_editor_contents
    expected_warning_description = warning.comment.warning_description
    assert_equal(expected_warning_description,
                 warning_description)
    expected_sample_source_code = warning.comment.sample_source_code
    assert_equal(expected_sample_source_code,
                 sample_source_code)
    ## backs to "Comment Editor" window
    select_frame("relative=parent")
    select_frame("relative=parent")

    # delete link exists
    assert(is_element_present(element_xpath("delete_link")))
    logout
  end



  def test_082
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})
    warning.comment = Comment.create(:risk_type_id        => 1,
                                     :warning_id          => warning.id,
                                     :warning_description => "description for warning (#{warning.id})",
                                     :sample_source_code  => "sample source code for warning (#{warning.id})",
                                     :status              => true)

    access_warning_listing_page_for_subtask_as_reviewer
    warning_xpath   = "//tr[@id='warning_#{warning.id}']"
    delete_link_xpath  = "#{warning_xpath}/td[13]/a[2]"

    # clicks on "[Delete]" link
    choose_cancel_on_next_confirmation
    click delete_link_xpath

    expected_confirmation_message = $messages["comment_deleting_confirmation"]
    confirmation_message          = get_confirmation

    assert_equal(expected_confirmation_message,
      confirmation_message)

    logout
  end

  def test_083
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})
    warning.comment = Comment.create(:risk_type_id        => 1,
                                     :warning_id          => warning.id,
                                     :warning_description => "description for warning (#{warning.id})",
                                     :sample_source_code  => "sample source code for warning (#{warning.id})",
                                     :status              => true)

    access_warning_listing_page_for_subtask_as_reviewer
    warning_xpath     = "//tr[@id='warning_#{warning.id}']"
    delete_link_xpath = "#{warning_xpath}/td[13]/a[2]"

    # clicks on "[Delete]" link
    choose_ok_on_next_confirmation
    click delete_link_xpath

    expected_confirmation_message = $messages["comment_deleting_confirmation"]
    confirmation_message          = get_confirmation

    assert_equal(expected_confirmation_message,
      confirmation_message)
    # waits until [Delete] link disappear
    wait_for_element_not_present(delete_link_xpath)
    # checks the message
    assert(is_text_present($messages["delete_comment_successfully"]))

    logout
  end
  def test_084

    ## for reviewers
    access_warning_listing_page_for_subtask_as_reviewer

    # gets all data in column "ID"
    warning_list_table_xpath  = element_xpath("warning_list_table")

    # "ID" column is highlighted as an incrementally-ordered column
    warning_id_header_xpath   = element_xpath("warning_list_headers")[0]
    header_classname          = get_attribute(warning_id_header_xpath,
      "class")
    assert_equal(HEADER_STYLES["sortup"],
      header_classname)
    # while other columns are "no sort" column
    # carefully: Only first 7 column can be sorted
    element_xpath("warning_list_headers")[1..6].each do |header_xpath|
      header_classname = get_attribute(header_xpath,
        "class")
      assert_equal(HEADER_STYLES["nosort"],
        header_classname)
    end

    # column “ID” is used to provide the initial ascending sort
    warning_ids = []
    (1..Warning::per_page).each do |index|
      warning_id_xpath = "#{warning_list_table_xpath}/tbody/tr[#{index}]/td[1]"
      warning_ids << get_text(warning_id_xpath)
    end

    # "id" column is ordered incrementally
    expected_warning_ids = warning_ids.sort { |a, b| a.to_i <=> b.to_i}
    assert_equal(expected_warning_ids,
      warning_ids)
    logout

    ## for pj members
    access_warning_listing_page_for_subtask_as_pj_member

    # gets all data in column "ID"
    warning_list_table_xpath  = element_xpath("warning_list_table")

    # "ID" column is highlighted as an incrementally-ordered column
    warning_id_header_xpath   = element_xpath("warning_list_headers")[0]
    header_classname          = get_attribute(warning_id_header_xpath,
      "class")
    assert_equal(HEADER_STYLES["sortup"],
      header_classname)
    # while other columns are "no sort" column
    # carefully: Only first 7 column can be sorted
    element_xpath("warning_list_headers")[1..6].each do |header_xpath|
      header_classname = get_attribute(header_xpath,
                                       "class")
      assert_equal(HEADER_STYLES["nosort"],
                   header_classname)
    end

    # column “ID” is used to provide the initial ascending sort
    warning_ids = []
    (1..Warning::per_page).each do |index|
      warning_id_xpath = "#{warning_list_table_xpath}/tbody/tr[#{index}]/td[1]"
      warning_ids << get_text(warning_id_xpath)
    end

    # "id" column is ordered incrementally
    expected_warning_ids = warning_ids.sort { |a, b| a.to_i <=> b.to_i}
    assert_equal(expected_warning_ids,
      warning_ids)
    logout
  end

  def test_085
    warning_list_table_xpath  = element_xpath("warning_list_table")
    sortable_headers          = element_xpath("warning_list_headers")[0..6]

    ## for reviewers
    access_warning_listing_page_for_subtask_as_reviewer

    # clicks on a sortable header (except "ID" column" to sort the table
    sortable_headers[1..6].each do |header_xpath|
      # clicks on a header
      header_link_xpath = "#{header_xpath}/a"
      click header_link_xpath
      # waits for sorting
      wait_for_attribute(header_xpath,
        "class",
        HEADER_STYLES["sortup"])
      #
      header_index  = sortable_headers.index(header_xpath)
      values        = []
      (1..Warning::per_page).each do |index|
        value_xpath = "#{warning_list_table_xpath}/tbody/tr[#{index}]/td[#{header_index + 1}]"
        values << get_text(value_xpath)
      end
      # expected values must be ordered incrementally
      if header_index < 7 && header_index > 3 # number columns
        expected_values = values.sort {|a, b| a.to_i <=> b.to_i}
      else # string columns
        expected_values = values.sort {|a, b| a <=> b}
      end

      assert_equal(expected_values,
        values)
    end
    logout

    ## for pj members
    access_warning_listing_page_for_subtask_as_pj_member

    # clicks on a sortable header (except "ID" column" to sort the table
    sortable_headers[1..6].each do |header_xpath|
      # clicks on a header
      header_link_xpath = "#{header_xpath}/a"
      click header_link_xpath
      # waits for sorting
      wait_for_attribute(header_xpath,
        "class",
        HEADER_STYLES["sortup"])
      #
      header_index  = sortable_headers.index(header_xpath)
      values        = []
      (1..Warning::per_page).each do |index|
        value_xpath = "#{warning_list_table_xpath}/tbody/tr[#{index}]/td[#{header_index + 1}]"
        values << get_text(value_xpath)
      end
      # expected values must be ordered incrementally
      if header_index < 7 && header_index > 3 # number columns
        expected_values = values.sort {|a, b| a.to_i <=> b.to_i}
      else # string columns
        expected_values = values.sort {|a, b| a <=> b}
      end

      assert_equal(expected_values,
        values)
    end
    logout
  end

  def test_086
    warning_list_table_xpath  = element_xpath("warning_list_table")
    sortable_headers          = element_xpath("warning_list_headers")[0..6]

    ## for reviewers
    access_warning_listing_page_for_subtask_as_reviewer
    expected_current_page = get_text(element_xpath("current_page"))

    # clicks on a sortable header
    sortable_headers.reverse.each do |header_xpath|
      # clicks on the header
      header_link_xpath = "#{header_xpath}/a"
      click header_link_xpath
      # waits for sorting
      wait_for_attribute(header_xpath,
        "class",
        HEADER_STYLES["sortup"])
      # clicks on the header again
      click header_link_xpath
      # waits for sorting - clicked column header is marked as descrementally-order column
      wait_for_attribute(header_xpath,
        "class",
        HEADER_STYLES["sortdown"])
      # gets values in sorted column
      header_index  = sortable_headers.index(header_xpath)
      values        = []
      (1..Warning::per_page).each do |index|
        value_xpath = "#{warning_list_table_xpath}/tbody/tr[#{index}]/td[#{header_index + 1}]"
        values << get_text(value_xpath)
      end
      # expected values must be ordered incrementally
      if header_index < 7 && header_index > 3 # number columns
        expected_values = values.sort {|a, b| b.to_i <=> a.to_i}
      else # string columns
        expected_values = values.sort {|a, b| b <=> a}
      end

      assert_equal(expected_values,
        values)
      # page must not be change
      current_page = get_text(element_xpath("current_page"))
      assert_equal(expected_current_page,
        current_page)
    end
    logout

    ## for pj members
    access_warning_listing_page_for_subtask_as_pj_member
    expected_current_page = get_text(element_xpath("current_page"))

    # clicks on a sortable header
    sortable_headers.reverse.each do |header_xpath|
      # clicks on the header
      header_link_xpath = "#{header_xpath}/a"
      click header_link_xpath
      # waits for sorting
      wait_for_attribute(header_xpath,
        "class",
        HEADER_STYLES["sortup"])
      # clicks on the header again
      click header_link_xpath
      # waits for sorting - clicked column header is marked as descrementally-order column
      wait_for_attribute(header_xpath,
        "class",
        HEADER_STYLES["sortdown"])
      # gets values in sorted column
      header_index  = sortable_headers.index(header_xpath)
      values        = []
      (1..Warning::per_page).each do |index|
        value_xpath = "#{warning_list_table_xpath}/tbody/tr[#{index}]/td[#{header_index + 1}]"
        values << get_text(value_xpath)
      end
      # expected values must be ordered incrementally
      if header_index < 7 && header_index > 3 # number columns
        expected_values = values.sort {|a, b| b.to_i <=> a.to_i}
      else # string columns
        expected_values = values.sort {|a, b| b <=> a}
      end

      assert_equal(expected_values,
        values)
      # page must not be changed
      current_page = get_text(element_xpath("current_page"))
      assert_equal(expected_current_page,
        current_page)
    end
    logout
  end

  #filtering function

  def test_087
    ## for reviewers
    access_warning_listing_page_for_subtask_as_reviewer

    search_combobox_xpath         = element_xpath("search_combobox")
    search_combobox_option_xpath  = search_combobox_xpath + "/option"
    total_options                 = get_xpath_count(search_combobox_option_xpath)
    # The select option which used to choose the candidate for filtering includes:
    # + “Directory”
    # + “Source Name”
    # + “File Name”
    # + “Rule Number”.
    expected_options = [_("Directory"), _("Source name"), _("File name"), _("Rule number")]
    (1..total_options).each do |index|
      option_xpath = "#{search_combobox_option_xpath}[#{index}]"
      option_label = get_text(option_xpath)
      assert_not_nil(expected_options.index(option_label))
      expected_options -= [option_label]
    end
    logout
    ## for pj members
    access_warning_listing_page_for_subtask_as_pj_member

    search_combobox_xpath         = element_xpath("search_combobox")
    search_combobox_option_xpath  = search_combobox_xpath + "/option"
    total_options                 = get_xpath_count(search_combobox_option_xpath)
    # The select option which used to choose the candidate for filtering includes:
    # + “Directory”
    # + “Source Name”
    # + “File Name”
    # + “Rule Number”.
    expected_options = [_("Directory"), _("Source name"), _("File name"), _("Rule number")]
    (1..total_options).each do |index|
      option_xpath = "#{search_combobox_option_xpath}[#{index}]"
      option_label = get_text(option_xpath)
      # false o day
      assert_not_nil(expected_options.index(option_label))
      expected_options -= [option_label]
    end
    logout
  end

  def test_088
    ## for reviewers
    access_warning_listing_page_for_subtask_as_reviewer
    #
    sleep 10
    # inputs search data
    filter_keyword  = "0240"
    filter_field    = get_value(element_xpath("search_combobox_options")[1]) # Rule Number
    select(element_xpath("search_combobox"),
      "value=#{filter_field}")
    type(element_xpath("search_textbox"),
      filter_keyword)
    click element_xpath("search_button")

    warnings = Warning.paginate_by_subtask_id(SUB_ID,
      1,
      "",
      "",
      filter_field,
      filter_keyword,
      false,
      false)
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    wait_for_xpath_count(warning_xpath,
      warnings.size)
    (1..warnings.size).each do |index|
      cell_xpath = warning_xpath + "[#{index}]/td[7]"
      assert_equal(filter_keyword,
        get_text(cell_xpath))
    end
    logout
    ## for pj members
    access_warning_listing_page_for_subtask_as_pj_member
    #

    # inputs search data
    select(element_xpath("search_combobox"),
      "value=#{filter_field}")
    type(element_xpath("search_textbox"),
      filter_keyword)
    click element_xpath("search_button")

    warnings = Warning.paginate_by_subtask_id(SUB_ID,
                                              1,
                                              "",
                                              "",
                                              filter_field,
                                              filter_keyword,
                                              false,
                                              false)
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    wait_for_xpath_count(warning_xpath,
      warnings.size)
    (1..warnings.size).each do |index|
      cell_xpath = warning_xpath + "[#{index}]/td[7]"
      assert_equal(filter_keyword,
        get_text(cell_xpath))
    end
    logout
  end

  def test_089
    ## for reviewers
    access_warning_listing_page_for_subtask_as_reviewer
    #

    # inputs search data
    filter_keyword  = "*"
    filter_field    = get_value(element_xpath("search_combobox_options")[1]) # Rule Number
    select(element_xpath("search_combobox"),
      "value=#{filter_field}")
    type(element_xpath("search_textbox"),
      filter_keyword)
    click element_xpath("search_button")

    warnings = Warning.paginate_by_subtask_id(SUB_ID,
      1,
      "",
      "",
      filter_field,
      filter_keyword,
      false,
      false)
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    wait_for_xpath_count(warning_xpath,
      warnings.size)
    logout
    ## for pj member
    access_warning_listing_page_for_subtask_as_pj_member
    #

    # inputs search data
    filter_keyword  = "*"
    filter_field    = get_value(element_xpath("search_combobox_options")[1]) # Rule Number
    select(element_xpath("search_combobox"),
      "value=#{filter_field}")
    type(element_xpath("search_textbox"),
      filter_keyword)
    click element_xpath("search_button")

    warnings = Warning.paginate_by_subtask_id(SUB_ID,
                                              1,
                                              "",
                                              "",
                                              filter_field,
                                              filter_keyword,
                                              false,
                                              false)
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    wait_for_xpath_count(warning_xpath,
      warnings.size)
    logout
  end

  def test_090
    ## for reviewers
    access_warning_listing_page_for_subtask_as_reviewer
    #
    filter_keyword  = "asfg"
    filter_field    = get_value(element_xpath("search_combobox_options")[1]) # Rule Number

    # inputs search data
    select(element_xpath("search_combobox"),
      "value=#{filter_field}")
    type(element_xpath("search_textbox"),
         filter_keyword)
    click element_xpath("search_button")

    warnings = Warning.paginate_by_subtask_id(SUB_ID,
                                              1,
                                              "",
                                              "",
                                              filter_field,
                                              filter_keyword,
                                              false,
                                              false)
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    wait_for_xpath_count(warning_xpath,
                         warnings.size)
    assert(is_text_present($messages["no_warning_found"]))
    logout

    ## for pj members
    access_warning_listing_page_for_subtask_as_pj_member
    # inputs search data
    select(element_xpath("search_combobox"),
      "value=#{filter_field}")
    type(element_xpath("search_textbox"),
      filter_keyword)
    click element_xpath("search_button")

    warnings = Warning.paginate_by_subtask_id(SUB_ID,
                                              1,
                                              "",
                                              "",
                                              filter_field,
                                              filter_keyword,
                                              false,
                                              false)
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    wait_for_xpath_count(warning_xpath,
                         warnings.size)
    assert(is_text_present($messages["no_warning_found"]))
    logout
  end

  def test_091
    ## for reviewers
    access_warning_listing_page_for_subtask_as_reviewer
    #
    filter_keyword  = ""
    filter_field    = get_value(element_xpath("search_combobox_options")[1]) # Rule Number

    # inputs search data
    select(element_xpath("search_combobox"),
      "value=#{filter_field}")
    type(element_xpath("search_textbox"),
      filter_keyword)
    click element_xpath("search_button")

    warnings = Warning.paginate_by_subtask_id(SUB_ID,
                                              1,
                                              "",
                                              "",
                                              filter_field,
                                              filter_keyword,
                                              false,
                                              false)
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    wait_for_xpath_count(warning_xpath,
                         warnings.size)
    logout
    ## for pj member
    access_warning_listing_page_for_subtask_as_pj_member
    #

    # inputs search data
    select(element_xpath("search_combobox"),
      "value=#{filter_field}")
    type(element_xpath("search_textbox"),
      filter_keyword)
    click element_xpath("search_button")

    warnings = Warning.paginate_by_subtask_id(SUB_ID,
      1,
      "",
      "",
      filter_field,
      filter_keyword,
      false,
      false)
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    wait_for_xpath_count(warning_xpath,
      warnings.size)
    logout
  end

  def test_092
    # this test cases can not be implemented because Selenium does not support download function
    assert(false)
  end

  def test_093
    # selenium does not support testing download functions
    assert(false)
  end

  def test_094
    access_warning_listing_page_for_subtask_as_reviewer
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])
    type(element_xpath("upload_file_browser"),CSV_FILES["invalid_format"])
    click element_xpath("upload_file_button")
    wait_for_text_not_present($window_titles["upload_csv_file"])
    expected_message  = $messages["no_csv_file_selected"]
    message           = get_alert
    verify_equal(expected_message, message)
    logout
  end

  def test_095
    access_warning_listing_page_for_subtask_as_reviewer
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])
    type(element_xpath("upload_file_browser"),CSV_FILES["no_file"])
    click element_xpath("upload_file_button")
    wait_for_text_not_present($window_titles["upload_csv_file"])
    expected_message  = $messages["no_csv_file_selected"]
    message           = get_alert
    verify_equal(expected_message,
      message)
    logout
  end

  def test_096
    access_warning_listing_page_for_subtask_as_reviewer
    sleep 3
    # selects file to upload
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])
    type_csv_upload_file(CSV_FILES["1mb"],CSV_FILES["1mb_ja"])
    # clicks on "Upload" button
    click element_xpath("upload_file_button")
    # waits untill sucessful message is displayed
    wait_for_text_present($messages["upload_csv_successully"])
    sleep 10

    # the uploaded file contains comments for first 10 warnings
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    (3871..3881).each do |index|
      cell_xpath        = "#{warning_xpath}[#{index}]/td[11]"
      expected_comment  = "description for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment,
        comment)
   end
    logout
  end

  def test_097
    access_warning_listing_page_for_subtask_as_reviewer
    # selects file to upload
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])
    type_csv_upload_file(CSV_FILES["1row"],CSV_FILES["1row_ja"])
    # clicks on "Upload" button
    click element_xpath("upload_file_button")
    # waits untill sucessful message is displayed
    wait_for_text_present($messages["upload_csv_successully"])
    # but no new comment
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    (3871..3881).each do |index|
      cell_xpath        = "#{warning_xpath}[#{index}]/td[11]"
      expected_comment  = ""
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment, comment)
    end

    logout
  end
  def test_098
    access_warning_listing_page_for_subtask_as_reviewer
    # selects file to upload - an error file
    selected_file = CSV_FILES["error_file"]
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])
    type(element_xpath("upload_file_browser"),
      selected_file)
    # clicks on "Upload" button
    click element_xpath("upload_file_button")

    # waits 5s
    sleep 5
    verify_equal(0, Comment.count)
    # waits untill failed message is displayed
    wait_for_text_present($messages["upload_csv_failed3"])
    logout
  end

  def test_099
    test_096 # this test case is duplicated
  end

  def test_100
    access_warning_listing_page_for_subtask_as_reviewer
    # selects file to upload
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])
    type_csv_upload_file(CSV_FILES["1mb"],CSV_FILES["1mb_ja"])
    # clicks on "Upload" button
    click element_xpath("upload_file_button")
    # waits untill sucessful message is displayed
    wait_for_text_present($messages["upload_csv_successully"])
    sleep 3
    # the uploaded file contains comments for first 10 warnings
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    (3871..3881).each do |index|
      cell_xpath        = "#{warning_xpath}[#{index}]/td[12]"
      expected_comment  = _("Registered")
      comment           = get_text(cell_xpath)
      verify_equal(expected_comment,comment)
    end

    logout
  end
  def test_101
    test_100 # this test case is duplicated
  end
  def test_101
    access_warning_listing_page_for_subtask_as_reviewer
    # selects file to upload
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])
    type_csv_upload_file(CSV_FILES["1mb"],CSV_FILES["1mb_ja"])
    # clicks on "Upload" button
    click element_xpath("upload_file_button")
    # waits untill sucessful message is displayed
    wait_for_text_present($messages["upload_csv_successully"])
    sleep 3
    # the uploaded file contains comments for first 10 warnings
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    (3871..3881).each do |index|
      cell_xpath        = "#{warning_xpath}[#{index}]/td[12]"
      expected_comment  = _("Registered")
      comment           = get_text(cell_xpath)
      verify_equal(expected_comment,
        comment)
    end

    logout
  end
   #don't have data "CSV_FILES["2mb"]" for this test case.
  def test_102
     false
    access_warning_listing_page_for_subtask_as_reviewer
    # selects file to upload
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])

    type_csv_upload_file(CSV_FILES["2mb"],CSV_FILES["2mb_ja"])

    # clicks on "Upload" button
    click element_xpath("upload_file_button")
    # waits untill sucessful message is displayed
    wait_for_text_present($messages["upload_csv_successully"])
    sleep 3
    # the uploaded file contains comments for first 10 warnings
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    (3871..3881).each do |index|
      cell_xpath        = "#{warning_xpath}[#{index}]/td[12]"
      expected_comment  = _("Registered")
      comment           = get_text(cell_xpath)
      verify_equal(expected_comment,
        comment)
    end

    logout
  end
   #don't have data "CSV_FILES["5mb"]" for this test case.
  def test_103
    assert false
    access_warning_listing_page_for_subtask_as_reviewer
    # selects file to upload
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])
     type_csv_upload_file(CSV_FILES["5mb"],CSV_FILES["5mb_ja"])
    # clicks on "Upload" button
    click element_xpath("upload_file_button")
    # waits untill sucessful message is displayed
    wait_for_text_present($messages["upload_csv_successully"])
    sleep 3
    # the uploaded file contains comments for first 10 warnings
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    (3871..3881).each do |index|
      cell_xpath        = "#{warning_xpath}[#{index}]/td[12]"
      expected_comment  = _("Registered")
      comment           = get_text(cell_xpath)
      verify_equal(expected_comment,
        comment)
    end

    logout
  end
    #don't have data "CSV_FILES["10mb"]" for this test case.
  def test_104
    assert false
    access_warning_listing_page_for_subtask_as_reviewer
    # selects file to upload
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])
     type_csv_upload_file(CSV_FILES["10mb"],CSV_FILES["10mb_ja"])
    # clicks on "Upload" button
    click element_xpath("upload_file_button")
    # waits untill sucessful message is displayed
    wait_for_text_present($messages["upload_csv_successully"])
    sleep 3
    # the uploaded file contains comments for first 10 warnings
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    (3871..3881).each do |index|
      cell_xpath        = "#{warning_xpath}[#{index}]/td[12]"
      expected_comment  = _("Registered")
      comment           = get_text(cell_xpath)
      verify_equal(expected_comment,
        comment)
    end

    logout
  end

  def test_105
     printf "\n+ Test 105"
    subtask           = Subtask.find(SUB_ID)
    subtask.review.publicized = false
    subtask.review.save

    access_warning_listing_page_for_subtask_as_reviewer

    subtask           = Subtask.find(SUB_ID)
    subtask.review.publicized = true
    subtask.review.save

    # selects file to upload
    click element_xpath("upload_csv_button")
    expected_message  = _("Upload  fails:  The  subtask  is  publicized.")
    wait_for_text_present(expected_message)

    logout
  end

  def test_106
     printf "\n+ Test 106"
    access_warning_listing_page_for_file_as_reviewer
     #checks elements on the page
    # "CommentListing" button
    assert(is_element_present(element_xpath("comment_listing_button")))
    # "Download CSV format" button
    assert(is_element_present(element_xpath("download_csv_button")))
    # "Upload CSV format" button
    assert(is_element_present(element_xpath("upload_csv_button")))
    logout
  end
  def test_107
     printf "\n+ Test 107"
     #this subtask is publicized
    subtask = Subtask.find(SUB_ID)
    subtask.review.publicized = true
    subtask.review.save
    access_warning_listing_page_for_file_as_pj_member
    # checks elements on the pages
    # "CommentListing" button
    assert(is_element_present(element_xpath("comment_listing_button")))
    logout
  end
  def test_108
     printf "\n+ Test 108"
    access_warning_listing_page_for_file_as_pj_member
    # checks elements on the pages
    ## "CommentListing" button is invisible
    assert(is_element_not_present(element_xpath("comment_listing_button")))
    logout
  end
  def test_109
     printf "\n+ Test 109"
    access_warning_listing_page_for_file_as_reviewer
    # checks elements on the pages
    ## Search box
    assert(is_element_present(element_xpath("search_button")))
    logout
    access_warning_listing_page_for_file_as_pj_member
    # checks elements on the pages
    ## Search box
    assert(is_element_present(element_xpath("search_button")))
    logout
  end
  def test_110
     printf "\n+ Test 110"
    access_warning_listing_page_for_file_as_reviewer
    sleep 10
    # checks elements on the pages
    wait_for_text_not_present($messages["warning_list_empty"])
    sleep 20
    logout
    access_warning_listing_page_for_file_as_pj_member
    sleep 10
    # checks elements on the pages
    wait_for_text_not_present($messages["warning_list_empty"])
    sleep 20
    logout
  end
  def test_111
     printf "\n+ Test 111"
    access_warning_listing_page_for_file_as_reviewer
    assert(is_element_present(element_xpath("page_links")))
    logout

    access_warning_listing_page_for_file_as_pj_member
    assert(is_element_present(element_xpath("page_links")))
    logout
  end
  def test_112
     printf "\n+ Test 112"
    # publicizes the subtask
    subtask = Subtask.find(SUB_ID)
    subtask.review.publicized = true
    subtask.review.save

    access_warning_listing_page_for_file_as_reviewer
    # HTML table contains columns:
    # + ID
    # + Line Number
    # + Character Number
    # + Rule Number
    # + Warning Message
    # + Code
    # + Reference
    # + Comment
    headers = WARNING_LIST_HEADERS[0..0] +  WARNING_LIST_HEADERS[4..10]
    headers.each_with_index do |header, column_index|
      header_xpath = element_xpath("warning_list_headers")[column_index]
      assert_equal(header,
        get_text(header_xpath))
    end
    logout
  end

  def test_113
     printf "\n+ Test 113"
    access_warning_listing_page_for_file_as_reviewer
    # HTML table contains columns:
    # + ID
    # + Line Number
    # + Character Number
    # + Rule Number
    # + Warning Message
    # + Code
    # + Reference
    # + Comment
    # + Status
    # + Action
    headers = WARNING_LIST_HEADERS[0..0] +  WARNING_LIST_HEADERS[4..12]
    headers.each_with_index do |header, column_index|
      header_xpath = element_xpath("warning_list_headers")[column_index]
      assert_equal(header,
        get_text(header_xpath))
    end
    logout
  end
  def test_114
     printf "\n+ Test 114"
    # publicizes the subtask
    subtask = Subtask.find(SUB_ID)
    subtask.review.publicized = true
    subtask.review.save

    access_warning_listing_page_for_file_as_pj_member
    # HTML table contains columns:
    # + ID
    # + Line Number
    # + Character Number
    # + Rule Number
    # + Warning Message
    # + Code
    # + Reference
    # + Comment
    headers = WARNING_LIST_HEADERS[0..0] +  WARNING_LIST_HEADERS[4..10]
    headers.each_with_index do |header, column_index|
      header_xpath = element_xpath("warning_list_headers")[column_index]
      assert_equal(header,
        get_text(header_xpath))
    end
    logout
  end
  def test_115
     printf "\n+ Test 115"
    access_warning_listing_page_for_file_as_pj_member
    # HTML table contains columns:
    # + ID
    # + Line Number
    # + Character Number
    # + Rule Number
    # + Warning Message
    # + Code
    # + Reference
    headers = WARNING_LIST_HEADERS[0..0] +  WARNING_LIST_HEADERS[4..9]
    headers.each_with_index do |header, column_index|
      header_xpath = element_xpath("warning_list_headers")[column_index]
      assert_equal(header,
        get_text(header_xpath))
    end
    logout
  end
  def test_116
     printf "\n+ Test 116"
    # gets an uncommented warning
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})

    # creates an unregistered comment for this warning
    warning.comment = Comment.create(:risk_type_id          => 1,
                                     :warning_id            => warning.id,
                                     :warning_description   => "warning description for warning #{warning.id}",
                                     :sample_source_code    => "sample source code for warning #{warning.id}",
                                     :status                => false)
    access_warning_listing_page_for_file_as_reviewer
    warning_xpath = "//tr[@id='warning_#{warning.id}']"
    # the gray row is corresponding to an comment-unregistered warning
    assert_equal(GRAY_STYLE[BROWSER],
      get_style(warning_xpath))
    logout
  end
  def test_117
     printf "\n+ Test 117"
    # gets an uncommented warning
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})
    access_warning_listing_page_for_file_as_reviewer

    warning_xpath = "//tr[@id='warning_#{warning.id}']"
    # "Action" column
    cell_xpath = warning_xpath + "/td[10]"
    ## This column contains only an "[Add]" link
    assert_equal("["+_('Add')+"]",
      get_text(cell_xpath))
    logout
  end
  def test_118
     printf "\n+ Test 118"
    # gets an uncommented warning
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})
    warning.comment = Comment.create(:risk_type_id        => 1,
                                     :warning_id          => warning.id,
                                     :warning_description => "description for warning (#{warning.id})",
                                     :sample_source_code  => "sample source code for warning (#{warning.id})",
                                     :status              => true)

    warning.comment.save


    access_warning_listing_page_for_file_as_reviewer

    warning_xpath = "//tr[@id='warning_#{warning.id}']"
    # "Action" column
    cell_path = warning_xpath + "/td[10]"
    ## This column contains 2 links:  an "[Edit]" link, and a "[Delete]" link
    edit_link_xpath   = cell_path + "/a[1]"
    assert_equal("["+_('Edit')+"]",
      get_text(edit_link_xpath))
    delete_link_xpath = cell_path + "/a[2]"
    assert_equal("["+_('Delete')+"]",
      get_text(delete_link_xpath))
    logout
  end
  def test_119
     printf "\n+ Test 119"
    # publicizes the subtask
    subtask = Subtask.find(SUB_ID)
    subtask.review.publicized = true
    subtask.review.save
    # CommentListing button locator
    comment_listing_button_xpath = element_xpath("comment_listing_button")
    # for reviewers
    access_warning_listing_page_for_file_as_reviewer
    # clicks on "CommentListing" button
    assert(is_element_present(comment_listing_button_xpath))
    click comment_listing_button_xpath
    # to switch to Comment Listing Page for this file
    wait_for_page_to_load 30000
    # checks the new locations
    expected_location = full_url_for(:controller => "review",
                                     :action      => "view_report_comment_list",
                                     :pu          => PU_ID,
                                     :pj          => PJ_ID,
                                     :id          => ID,
                                     :sub_id      => SUB_ID,
                                     :result_id   => RESULT_ID)
    location = get_location
    assert_equal(expected_location,
      location)
    logout
    # for pj members
    access_warning_listing_page_for_file_as_pj_member
    # clicks on "CommentListing" button
    assert(is_element_present(comment_listing_button_xpath))
    click comment_listing_button_xpath
    # to switch to Comment Listing Page for this file
    wait_for_page_to_load 30000
    # checks the new locations
    expected_location = full_url_for(:controller => "review",
                                     :action      => "view_report_comment_list",
                                     :pu          => PU_ID,
                                     :pj          => PJ_ID,
                                     :id          => ID,
                                     :sub_id      => SUB_ID,
                                     :result_id   => RESULT_ID)
    location = get_location
    assert_equal(expected_location,
                 location)
    logout
  end
  def test_120
     printf "\n+ Test 120"
    # page link locator
    page_links_xpath    = element_xpath("page_links")
    new_page_link_xpath = "#{page_links_xpath}/a"

    # for reviewers
    access_warning_listing_page_for_file_as_reviewer
    new_page            = get_text(new_page_link_xpath)
    # gets new contents from the database
    warnings = Warning.paginate_by_subtask_id(SUB_ID,
                                              new_page)
    # clicks on a link to change page
    click new_page_link_xpath
    ## wait a little time for updating the table
    warnings.each do |warning|
      wait_for_text_present(warning.id)
    end
    ## makes sure that the warning list was updated
    warning_list_table_xpath = element_xpath("warning_list_table")
    total_rows = warnings.size
    (1..total_rows).each do |index|
      warning_xpath     = warning_list_table_xpath + "/tbody/tr[#{index}]"
      warning_id_xpath  = warning_xpath + "/td[1]"
      warning_id        = get_text(warning_id_xpath).to_i
      assert_equal(warning_id,
                   warnings[index - 1].id)
    end
    #
    logout

    # for pj members
    access_warning_listing_page_for_file_as_pj_member
    new_page            = get_text(new_page_link_xpath)
    # gets new contents from the database
    warnings = Warning.paginate_by_subtask_id(SUB_ID,
      new_page)
    # clicks on a link to change page
    click new_page_link_xpath
    ## wait a little time for updating the table
    warnings.each do |warning|
      wait_for_text_present(warning.id)
    end
    ## makes sure that the warning list was updated
    warning_list_table_xpath = element_xpath("warning_list_table")
    total_rows = warnings.size
    (1..total_rows).each do |index|
      warning_xpath     = warning_list_table_xpath + "/tbody/tr[#{index}]"
      warning_id_xpath  = warning_xpath + "/td[1]"
      warning_id        = get_text(warning_id_xpath).to_i
      assert_equal(warning_id,
        warnings[index - 1].id)
    end
    #
    logout
  end
  def test_121
     printf "\n+ Test 121"
    access_warning_listing_page_for_file_as_reviewer
    # opens "Comment Editor" by clicking on "[Add]" link
    click element_xpath("warning_row_add_link")
    # waits for opening the window
    wait_for_element_present(element_xpath("warning_description_frame"))
    # gets contents of "Comment Editor" window
    sleep 5
    warning_description, sample_source_code = get_comment_editor_contents
    # there contents are initially black
    assert_equal("", warning_description)
    assert_equal("", sample_source_code)
    # there is no "Delete" link on "Comment Editor"
    assert(is_element_not_present("delete_link"))
    logout
  end
  def test_122
    # prepares a comment for the first warning
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})
    warning.comment = Comment.create(:risk_type_id        => 1,
                                     :warning_id          => warning.id,
                                     :warning_description => "description for warning (#{warning.id})",
                                     :sample_source_code  => "sample source code for warning (#{warning.id})",
                                     :status              => true)
    warning.comment.save

    access_warning_listing_page_for_file_as_reviewer
    # opens "Comment Editor" by clicking on "[Edit]" link
    click element_xpath("warning_row_edit_link")
    # waits for opening the window
    wait_for_element_present(element_xpath("warning_description_frame"))
    # gets contents of "Comment Editor" window
    sleep 5
    warning_description, sample_source_code = get_comment_editor_contents
    # there contents are initially black
    expected_warning_description  = warning.comment.warning_description
    expected_sample_source_code   = warning.comment.sample_source_code
    assert_equal(expected_warning_description,
      warning_description)
    assert_equal(expected_sample_source_code,
      sample_source_code)
    # there is no "Delete" link on "Comment Editor"
    assert(is_element_not_present("delete_link"))
    logout
  end
  def test_123
    # prepares a comment for the first warning
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})
    warning.comment = Comment.create(:risk_type_id        => 1,
                                     :warning_id          => warning.id,
                                     :warning_description => "description for warning (#{warning.id})",
                                     :sample_source_code  => "sample source code for warning (#{warning.id})",
                                     :status              => true)
    warning.comment.save

    access_warning_listing_page_for_file_as_reviewer
    choose_cancel_on_next_confirmation
    click element_xpath("warning_row_delete_link")
    expected_message  = $messages["comment_deleting_confirmation"]
    message           = get_confirmation
    assert_equal(expected_message,
      message)
    logout
  end
  def test_124
    # prepares a comment for the first warning
    warning = Warning.find(:first,
                           :joins       => "INNER JOIN source_codes ON source_codes.id = warnings.source_code_id",
                           :conditions  => {"source_codes.result_id" => RESULT_ID})
    warning.comment = Comment.create(:risk_type_id        => 1,
                                     :warning_id          => warning.id,
                                     :warning_description => "description for warning (#{warning.id})",
                                     :sample_source_code  => "sample source code for warning (#{warning.id})",
                                     :status              => true)
    warning.comment.save

    # opens "Warning Listing Page" for a file
    access_warning_listing_page_for_file_as_reviewer

    # clicks on "Delete" link
    choose_ok_on_next_confirmation
    click element_xpath("warning_row_delete_link")
    get_confirmation

    # waits for deleting the comment, "A comment was deleted successfully!" is displayed
    wait_for_text_present($messages["delete_comment_successfully"])
    # the warning row is updated
    ## "[Delete]" link is removed
    assert(is_element_not_present(element_xpath("warning_row_delete_link")))
    ## "[Edit]" link is changed to an "[Add]" link
    assert_equal("["+_('Add')+"]",
      get_text(element_xpath("warning_row_add_link")))
    # the comment was deleted
    assert_equal(0, Comment.count)
    logout
  end

  def test_125
    ## for reviewers
    access_warning_listing_page_for_file_as_reviewer
    # gets all data in column "ID"
    warning_list_table_xpath  = element_xpath("warning_list_table")

    # "ID" column is highlighted as an incrementally-ordered column
    warning_id_header_xpath   = element_xpath("warning_list_headers")[0]
    header_classname          = get_attribute(warning_id_header_xpath,
                                              "class")
    assert_equal(HEADER_STYLES["sortup"],
                 header_classname)
    # while other columns are "no sort" column
    # carefully: Only first 7 column can be sorted
    element_xpath("warning_list_headers")[1..3].each do |header_xpath|
      header_classname = get_attribute(header_xpath,
                                      "class")
      assert_equal(HEADER_STYLES["nosort"],
                   header_classname)
    end

    # column “ID” is used to provide the initial ascending sort
    warning_ids = []
    (1..Warning::per_page).each do |index|
      warning_id_xpath = "#{warning_list_table_xpath}/tbody/tr[#{index}]/td[1]"
      warning_ids << get_text(warning_id_xpath)
    end

    # "id" column is ordered incrementally
    expected_warning_ids = warning_ids.sort { |a, b| a.to_i <=> b.to_i}
    assert_equal(expected_warning_ids,
      warning_ids)
    logout
    ## for pj members
    access_warning_listing_page_for_file_as_reviewer
    # gets all data in column "ID"
    warning_list_table_xpath  = element_xpath("warning_list_table")

    # "ID" column is highlighted as an incrementally-ordered column
    warning_id_header_xpath   = element_xpath("warning_list_headers")[0]
    header_classname          = get_attribute(warning_id_header_xpath,
                                              "class")
    assert_equal(HEADER_STYLES["sortup"],
                 header_classname)
    # while other columns are "no sort" column
    # carefully: Only first 3 column can be sorted
    element_xpath("warning_list_headers")[1..3].each do |header_xpath|
      header_classname = get_attribute(header_xpath,
        "class")
      assert_equal(HEADER_STYLES["nosort"],
        header_classname)
    end

    # column “ID” is used to provide the initial ascending sort
    warning_ids = []
    (1..Warning::per_page).each do |index|
      warning_id_xpath = "#{warning_list_table_xpath}/tbody/tr[#{index}]/td[1]"
      warning_ids << get_text(warning_id_xpath)
    end

    # "id" column is ordered incrementally
    expected_warning_ids = warning_ids.sort { |a, b| a.to_i <=> b.to_i}
    assert_equal(expected_warning_ids,
      warning_ids)
    logout
  end
  def test_126
    warning_list_table_xpath  = element_xpath("warning_list_table")
    sortable_header_xpaths          = element_xpath("warning_list_headers")[0..3]

    ## for reviewers
    access_warning_listing_page_for_file_as_reviewer
    current_page = get_text(element_xpath("current_page"))

    # clicks on a sortable header (except "ID" column" to sort the table
    sortable_header_xpaths.reverse.each do |header_xpath|
      # clicks on a header
      header_link_xpath = "#{header_xpath}/a"
      click header_link_xpath
      # waits for sorting
      wait_for_attribute(header_xpath,
        "class",
        HEADER_STYLES["sortup"])
      #
      header_index  = sortable_header_xpaths.index(header_xpath)
      values        = []
      (1..Warning::per_page).each do |index|
        value_xpath = "#{warning_list_table_xpath}/tbody/tr[#{index}]/td[#{header_index + 1}]"
        values << get_text(value_xpath)
      end
      # expected values must be ordered incrementally
      expected_values = values.sort {|a, b| a.to_i <=> b.to_i}

      assert_equal(expected_values,
        values)
      # page is not changed
      old_page = current_page
      current_page = get_text(element_xpath("current_page"))
      assert_equal(old_page,
        current_page)
    end
    logout
    ## for pj members
    access_warning_listing_page_for_file_as_pj_member

    current_page = get_text(element_xpath("current_page"))
    # clicks on a sortable header (except "ID" column" to sort the table
    sortable_header_xpaths.reverse.each do |header_xpath|
      # clicks on a header
      header_link_xpath = "#{header_xpath}/a"
      click header_link_xpath
      # waits for sorting
      wait_for_attribute(header_xpath,
        "class",
        HEADER_STYLES["sortup"])
      #
      header_index  = sortable_header_xpaths.index(header_xpath)
      values        = []
      (1..Warning::per_page).each do |index|
        value_xpath = "#{warning_list_table_xpath}/tbody/tr[#{index}]/td[#{header_index + 1}]"
        values << get_text(value_xpath)
      end
      # expected values must be ordered incrementally
      expected_values = values.sort {|a, b| a.to_i <=> b.to_i}

      assert_equal(expected_values,
        values)
      # page is not changed
      old_page = current_page
      current_page = get_text(element_xpath("current_page"))
      assert_equal(old_page,
        current_page)
    end
    logout
  end

  def test_127
    warning_list_table_xpath  = element_xpath("warning_list_table")
    sortable_header_xpaths          = element_xpath("warning_list_headers")[0..3]

    ## for reviewers
    access_warning_listing_page_for_file_as_reviewer

    current_page = get_text(element_xpath("current_page"))
    # clicks on a sortable header (except "ID" column" to sort the table
    sortable_header_xpaths.reverse.each do |header_xpath|
      # clicks on a header
      header_link_xpath = "#{header_xpath}/a"
      click header_link_xpath
      # waits for sorting
      wait_for_attribute(header_xpath,
        "class",
        HEADER_STYLES["sortup"])
      # clicks on the header again
      click header_link_xpath
      # waits for sorting
      wait_for_attribute(header_xpath,
        "class",
        HEADER_STYLES["sortdown"])
      header_index  = sortable_header_xpaths.index(header_xpath)
      values        = []
      (1..Warning::per_page).each do |index|
        value_xpath = "#{warning_list_table_xpath}/tbody/tr[#{index}]/td[#{header_index + 1}]"
        values << get_text(value_xpath)
      end
      # expected values must be ordered incrementally
      expected_values = values.sort {|a, b| b.to_i <=> a.to_i}

      assert_equal(expected_values,
        values)
      # page is not changed
      old_page = current_page
      current_page = get_text(element_xpath("current_page"))
      assert_equal(old_page,
        current_page)
    end
    ## for pj members
    access_warning_listing_page_for_file_as_pj_member

    # clicks on a sortable header (except "ID" column" to sort the table
    sortable_header_xpaths.reverse.each do |header_xpath|
      # clicks on a header
      header_link_xpath = "#{header_xpath}/a"
      click header_link_xpath
      # waits for sorting
      wait_for_attribute(header_xpath,
        "class",
        HEADER_STYLES["sortup"])
      # clicks on the header again
      click header_link_xpath
      # waits for sorting
      wait_for_attribute(header_xpath,
        "class",
        HEADER_STYLES["sortdown"])
      header_index  = sortable_header_xpaths.index(header_xpath)
      values        = []
      (1..Warning::per_page).each do |index|
        value_xpath = "#{warning_list_table_xpath}/tbody/tr[#{index}]/td[#{header_index + 1}]"
        values << get_text(value_xpath)
      end
      # expected values must be ordered incrementally
      expected_values = values.sort {|a, b| b.to_i <=> a.to_i}

      assert_equal(expected_values,
        values)
      # page is not changed
      old_page = current_page
      current_page = get_text(element_xpath("current_page"))
      assert_equal(old_page,
        current_page)
    end
    logout
    logout
  end

  def test_128
    # for reviewers
    access_warning_listing_page_for_file_as_reviewer
    ## combobox contains only one option
    total_options = get_xpath_count(element_xpath("search_combobox") + "/option")
    assert_equal(1,
      total_options)
    ## This option is "Rule Number"
    option_label = get_text(element_xpath("search_combobox_options")[1])
    assert_equal(_("Rule number"),
      option_label)
    logout
    # for pj_member
    access_warning_listing_page_for_file_as_pj_member
    ## combobox contains only one option
    total_options = get_xpath_count(element_xpath("search_combobox") + "/option")
    assert_equal(1,
      total_options)
    ## This option is "Rule Number"
    option_label = get_text(element_xpath("search_combobox_options")[1])
    assert_equal(_("Rule number"),
      option_label)
    logout
  end
  def test_129
    # for reviewers
    access_warning_listing_page_for_file_as_reviewer
    filter_keyword  = RULE_NUMBER
    filter_field    = get_value(element_xpath("search_combobox_options")[1]) # Rule Number
    # gets warnings from database
    warnings        = Warning.paginate_by_result_id(RESULT_ID,
      1,
      "",
      "",
      filter_field,
      filter_keyword,
      false,
      false)
    ## inputs search data
    type(element_xpath("search_textbox"),
      filter_keyword)
    ## clicks on "Search" button
    click(element_xpath("search_button"))

    ## waits for filtering
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    wait_for_xpath_count(warning_xpath,
      warnings.size)

    (1..warnings.size).each do |index|
      cell_xpath = warning_xpath + "[#{index}]/td[4]"
      assert_equal(filter_keyword,
        get_text(cell_xpath))
    end
    # after filtering, the page is "1"
    current_page = get_text(element_xpath("current_page")) rescue "1"
    assert_equal("1",
      current_page)

    logout
    # for pj members
    access_warning_listing_page_for_file_as_pj_member
    filter_keyword  = RULE_NUMBER
    filter_field    = get_value(element_xpath("search_combobox_options")[1]) # Rule Number
    # gets warnings from database
    warnings        = Warning.paginate_by_result_id(RESULT_ID,
                                                    1,
                                                    "",
                                                    "",
                                                    filter_field,
                                                    filter_keyword,
                                                    false,
                                                    false)
    ## inputs search data
    type(element_xpath("search_textbox"),
      filter_keyword)
    ## clicks on "Search" button
    click(element_xpath("search_button"))

    ## waits for filtering
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    wait_for_xpath_count(warning_xpath,
      warnings.size)

    (1..warnings.size).each do |index|
      cell_xpath = warning_xpath + "[#{index}]/td[4]"
      assert_equal(filter_keyword,
        get_text(cell_xpath))
    end
    logout
  end
  def test_130
    # how to implement this test case?
    # for reviewers
    access_warning_listing_page_for_file_as_reviewer
    filter_keyword  = "*"
    filter_field    = get_value(element_xpath("search_combobox_options")[1]) # Rule Number
    # gets warnings from database
    warnings        = Warning.paginate_by_result_id(RESULT_ID,
      1,
      "",
      "",
      filter_field,
      filter_keyword,
      false,
      false)
    ## inputs search data
    type(element_xpath("search_textbox"),
      filter_keyword)
    ## clicks on "Search" button
    click(element_xpath("search_button"))

    ## waits for filtering
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    wait_for_xpath_count(warning_xpath,
      warnings.size)
    logout
    # for pj members
    access_warning_listing_page_for_file_as_pj_member
    filter_keyword  = "*"
    filter_field    = get_value(element_xpath("search_combobox_options")[1]) # Rule Number
    # gets warnings from database
    warnings        = Warning.paginate_by_result_id(RESULT_ID,
                                                    1,
                                                    "",
                                                    "",
                                                    filter_field,
                                                    filter_keyword,
                                                    false,
                                                    false)
    ## inputs search data
    type(element_xpath("search_textbox"),
      filter_keyword)
    ## clicks on "Search" button
    click(element_xpath("search_button"))

    ## waits for filtering
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    wait_for_xpath_count(warning_xpath,
      warnings.size)
    logout
  end
  def test_131
    # for reviewers
    access_warning_listing_page_for_file_as_reviewer
    filter_keyword  = "wxyz"
    ## inputs search data
    type(element_xpath("search_textbox"),
         filter_keyword)
    ## clicks on "Search" button
    click(element_xpath("search_button"))

    ## waits for filtering, "No warning found." message is displayed
    wait_for_text_present($messages["no_warning_found"])
    logout
  end
  def test_132
    # how to inplement this test case?
    # for reviewers
    access_warning_listing_page_for_file_as_reviewer
    filter_keyword  = "*"
    filter_field    = get_value(element_xpath("search_combobox_options")[1]) # Rule Number
    # gets warnings from database
    warnings        = Warning.paginate_by_result_id(RESULT_ID,
                                                    1,
                                                    "",
                                                    "",
                                                    filter_field,
                                                    filter_keyword,
                                                    false,
                                                    false)
    ## inputs search data
    type(element_xpath("search_textbox"),
      filter_keyword)
    ## clicks on "Search" button
    click(element_xpath("search_button"))

    ## waits for filtering
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    wait_for_xpath_count(warning_xpath,
      warnings.size)
    logout
    # for pj members
    access_warning_listing_page_for_file_as_pj_member
    filter_keyword  = "*"
    filter_field    = get_value(element_xpath("search_combobox_options")[1]) # Rule Number
    # gets warnings from database
    warnings        = Warning.paginate_by_result_id(RESULT_ID,
                                                    1,
                                                    "",
                                                    "",
                                                    filter_field,
                                                    filter_keyword,
                                                    false,
                                                    false)
    ## inputs search data
    type(element_xpath("search_textbox"),
      filter_keyword)
    ## clicks on "Search" button
    click(element_xpath("search_button"))

    ## waits for filtering
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    wait_for_xpath_count(warning_xpath,
                         warnings.size)
    logout
  end
  def test_133
    assert(false) # selenium does not support downloading function
  end
  def test_134
    # selenium does not support testing download functions
    assert(false)
  end
  def test_135
    access_warning_listing_page_for_file_as_reviewer
    # clicks on "Upload CSV format" button
    click element_xpath("upload_csv_button")
    # waits for opening the window
    wait_for_text_present($window_titles["upload_csv_file"])
    # select no file
    type(element_xpath("upload_file_browser"),CSV_FILES["invalid_format"])
    # clicks on "Upload" button
    click element_xpath("upload_file_button")
    # a failed message must be displayed
    message           = get_alert
    expected_message  = $messages["no_csv_file_selected"]
    assert_equal(expected_message,
      message)
    logout
  end

  def test_136
    access_warning_listing_page_for_file_as_reviewer
    # clicks on "Upload CSV format" button
    click element_xpath("upload_csv_button")
    # waits for opening the window
    wait_for_text_present($window_titles["upload_csv_file"])
    # select no file
    type(element_xpath("upload_file_browser"), CSV_FILES["no_file"])
    # clicks on "Upload" button
    click element_xpath("upload_file_button")
    message           = get_alert
    expected_message  = $messages["no_csv_file_selected"]
    assert_equal(expected_message,
      message)
    logout
  end

  def test_137
    access_warning_listing_page_for_file_as_reviewer
     #clicks on "Upload CSV format" button
    click element_xpath("upload_csv_button")
    # waits for opening the window
    wait_for_text_present($window_titles["upload_csv_file"])
     #select no file

     type_csv_upload_file(CSV_FILES["1mb"],CSV_FILES["1mb_ja"])
    sleep 50
    # clicks on "Upload" button
    click element_xpath("upload_file_button")
    wait_for_text_present($messages["upload_csv_successully"])

     #the uploaded file contains comments for first 10 warnings
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    (3871..3881).each do |index|
      cell_xpath        = "#{warning_xpath}[#{index}]/td[8]"
      expected_comment  = "description for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment,
        comment)
    end
    logout
  end

  def test_138
        printf "\n+ Test 138"
    access_warning_listing_page_for_file_as_reviewer
    # selects file to upload
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])
     type_csv_upload_file(CSV_FILES["1row"],CSV_FILES["1row_ja"])
    # clicks on "Upload" button
    click element_xpath("upload_file_button")
    # waits untill sucessful message is displayed
    wait_for_text_present($messages["upload_csv_successully"])
    sleep 20
    # but no new comment
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    (3871..3881).each do |index|
      cell_xpath        = "#{warning_xpath}[#{index}]/td[8]"
      expected_comment  = ""
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment,
        comment)
    end
    logout
  end

  def test_139
    printf "\n+ Test 139"
    access_warning_listing_page_for_file_as_reviewer
    # selects file to upload
    selected_file = CSV_FILES["error_file"]
    click element_xpath("upload_csv_button")
    wait_for_text_present($window_titles["upload_csv_file"])
    type(element_xpath("upload_file_browser"), selected_file)
    # clicks on "Upload" button
    click element_xpath("upload_file_button")

    # waits untill failed message is displayed
    wait_for_text_present($messages["upload_csv_failed3"])
    verify_equal(0, Comment.count)
    logout
  end

  def test_140
    printf "\n+ Test 140"
    access_warning_listing_page_for_file_as_reviewer

    old_rule_numbers = []
    (1..Warning.per_page).each do |index|
      rule_number_cell_xpath = "//tr[@id='warning_#{index}']/td[7]"
      old_rule_numbers << get_text(rule_number_cell_xpath)
    end
    # clicks on "Upload CSV format" button
    click element_xpath("upload_csv_button")
    # waits for opening the window
    wait_for_text_present($window_titles["upload_csv_file"])
    # select no file
     type_csv_upload_file(CSV_FILES["1mb"],CSV_FILES["1mb_ja"])
    # clicks on "Upload" button
    click element_xpath("upload_file_button")
    wait_for_text_present($messages["upload_csv_successfully"])

    sleep 30

    # rule numbers must be not changed
    new_rule_numbers = []
    (1..Warning.per_page).each do |index|
      rule_number_cell_xpath = "//tr[@id='warning_#{index}']/td[7]"
      new_rule_numbers << get_text(rule_number_cell_xpath)
    end
    assert_equal(old_rule_numbers, new_rule_numbers)
    sleep 5
    # the uploaded file contains comments for first 10 warnings
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    (3871..3881).each do |index|
      cell_xpath        = "#{warning_xpath}[#{index}]/td[11]"
      expected_comment  = "description for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment,
        comment)
    end
    logout
  end
  
  def test_141
    printf "\n+ Test 141"
    access_warning_listing_page_for_file_as_reviewer

    # clicks on "Upload CSV format" button
    click element_xpath("upload_csv_button")
    # waits for opening the window
    wait_for_text_present($window_titles["upload_csv_file"])
    # select no file
    type_csv_upload_file(CSV_FILES["1mb"],CSV_FILES["1mb_ja"])
    # clicks on "Upload" button
    click element_xpath("upload_file_button")
    wait_for_text_present($messages["upload_csv_successfully"])
    sleep 30

    # the uploaded file contains comments for first 10 warnings
    #expected_status = "Registered"
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    (3871..3881).each do |index|
      cell_xpath        = "#{warning_xpath}[#{index}]/td[12]"
       expected_status = _("Registered")
      status            = get_text(cell_xpath)
      assert_equal(expected_status,
        status)
    end
    logout
  end

  def test_142
    printf "\n+ Test 142"
    access_warning_listing_page_for_file_as_reviewer
    # clicks on "Upload CSV format" button
    click element_xpath("upload_csv_button")
    # waits for opening the window
    wait_for_text_present($window_titles["upload_csv_file"])
    # select no file
     type_csv_upload_file(CSV_FILES["1mb"],CSV_FILES["1mb_ja"])
    # clicks on "Upload" button
    click element_xpath("upload_file_button")
    sleep 10

    # the uploaded file contains comments for first 10 warnings
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    (3871..3881).each do |index|
      cell_xpath        = "#{warning_xpath}[#{index}]/td[11]"
      expected_comment  = "description for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment, comment)
    end
    logout
  end

  def test_143
    printf "\n+ Test 143"
    #test fales
    assert false
    access_warning_listing_page_for_file_as_reviewer
    # clicks on "Upload CSV format" button
    click element_xpath("upload_csv_button")
    # waits for opening the window
    wait_for_text_present($window_titles["upload_csv_file"])
    # select no file
    type(element_xpath("upload_file_browser"),CSV_FILES["2mb"])
    # clicks on "Upload" button
    click element_xpath("upload_file_button")
    sleep 10

    # the uploaded file contains comments for first 10 warnings
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    (3871..3881).each do |index|
      cell_xpath        = "#{warning_xpath}[#{index}]/td[8]"
      expected_comment  = "description for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment,
        comment)
    end
    logout
  end

  def test_144
    printf "\n+ Test 144"
    #test false
    assert false
    access_warning_listing_page_for_file_as_reviewer
    # clicks on "Upload CSV format" button
    click element_xpath("upload_csv_button")
    # waits for opening the window
    wait_for_text_present($window_titles["upload_csv_file"])
    # select no file
    type(element_xpath("upload_file_browser"),CSV_FILES["5mb"])
    # clicks on "Upload" button
    click element_xpath("upload_file_button")
    sleep 10

    # the uploaded file contains comments for first 10 warnings
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    (3871..3881).each do |index|
      cell_xpath        = "#{warning_xpath}[#{index}]/td[8]"
      expected_comment  = "description for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment,
        comment)
    end
    logout
  end

  def test_145
    printf "\n+ Test 145"
    access_warning_listing_page_for_file_as_reviewer
    # clicks on "Upload CSV format" button
    click element_xpath("upload_csv_button")
    # waits for opening the window
    wait_for_text_present($window_titles["upload_csv_file"])
    # select no file
     type_csv_upload_file(CSV_FILES["1mb"],CSV_FILES["1mb_ja"])
    # clicks on "Upload" button
    click element_xpath("upload_file_button")
    sleep 10

    # the uploaded file contains comments for first 10 warnings
    warning_xpath = "//tr[contains(@id, 'warning_')]"
    (3871..3881).each do |index|
      cell_xpath        = "#{warning_xpath}[#{index}]/td[11]"
      expected_comment  = "description for warning (#{index})"
      comment           = get_text(cell_xpath)
      assert_equal(expected_comment,
        comment)
    end
    logout
  end

  def test_146
    printf "\n+ Test 146"
    expected_message  = _("Upload  fails:  The  subtask  is  publicized.")

    access_warning_listing_page_for_file_as_reviewer

    subtask           = Subtask.find(SUB_ID)
    subtask.review.publicized = true
    subtask.review.save

    # selects file to upload
    click element_xpath("upload_csv_button")
    wait_for_text_present(expected_message)
  end
end

