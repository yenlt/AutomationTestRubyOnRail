require File.dirname(__FILE__) + "/../../config/test_helper" unless defined? ENV["RAILS_ENV"]
require File.dirname(__FILE__) + "/../../config/selenium_setup" unless defined? SeleniumSetup
require File.dirname(__FILE__) + "../../run" unless defined? MyTestSuite

unless defined?(TestRSetup)
  module TestRSetup
    include SeleniumSetup
    include GetText
    PJ_MEMBER = {:account_name => "pj_member",
                 :password      => "pj_member",
                 :password_confirmation => "pj_member",
                 :email                 => "pj_member@tsdv.com.vn",
                 }

    REVIEWER_NAME       = "root"
    REVIEWER_PASSWORD   = "root"
    PJ_MEMBER_NAME      = "pj_member"
    PJ_MEMBER_PASSWORD  = "pj_member"
    PU_ID     = 1
    PJ_ID     = 1
    ID        = 1
    SUB_ID    = 1
    RESULT_ID = 7

    RESULT_LIST_HEADERS_EN = [_("Path"),
                           _("File name"),
                           _("Registered comments"),
                           _("Total warnings"),
                           _("Not classified yet"),
                           _("Investigating"),
                           _("Fault warning"),
                           _("Intention"),
                           _("Confirmation required"),
                           _("Critical warning"),
                           _("Bug"),
                           _("Total")]
   RESULT_LIST_HEADERS_JA = [_("Path"),
                           _("File name"),
                           _("Registered comments"),
                           _("Total warnings"),
                           "未分類",
                           "調査中",
                           "致命的な指摘",
                           "意図的",
                           "要確認",
                           "重大な指摘",
                           "バグ",
                           "全ての"]

    # Column headers of CommentListing/WarningListing table
    WARNING_LIST_HEADER_SUBTASK_AND_FILE_DIFF = 3
    WARNING_LIST_HEADERS = ["ID",
                            _("Directory"),      # Not appear in list for file
                            _("Source name"),    # Not appear in list for file
                            _("File name"),      # Not appear in list for file
                            _("Line number"),
                            _("Character number"),
                            _("Rule number"),
                            _("Warning message"),
                            _("Code"),
                            _("Reference"),
                            _("Comment"),
                            _("Status"),
                            _("Action")]

    # style attribute of gray-background row for temporarily-saved comment
    GRAY_STYLE = { "ie" => "background-color: #d8d8d8;",
                   "firefox" => "background-color: rgb(216, 216, 216);"}

    # classname of sortable headers
    HEADER_STYLES = {"nosort"     => "sortable",            # normal column
                     "sortup"     => "sortable sortasc",    # incrementally-ordered column
                     "sortdown"   => "sortable sortdesc"}   # descrementally-ordered column
    CSV_FILES = {"invalid_format" => File.expand_path(File.dirname(__FILE__))   + "/csv/invalid_format",
                 "no_file"        => "",
                 "error_file"     => File.expand_path(File.dirname(__FILE__))   + "/csv/1mb_error.csv", # csv file contains invalid data
                 "1row"           => File.expand_path(File.dirname(__FILE__))   + "/csv/1row.csv",      # this file only contains 1 row containing header row
                 "1row_ja"           => File.expand_path(File.dirname(__FILE__))   + "/csv/1row_ja.csv",
                 "1mb"            => File.expand_path(File.dirname(__FILE__))   + "/csv/1mb.csv",
                 "1mb_ja"            => File.expand_path(File.dirname(__FILE__))   + "/csv/1mb_ja.csv",
                 "1mb_2"          => File.expand_path(File.dirname(__FILE__))   + "/csv/1mb_2.csv",
                 "1mb_2_ja"          => File.expand_path(File.dirname(__FILE__))   + "/csv/1mb_2_ja.csv",
                 "2mb"            => File.expand_path(File.dirname(__FILE__))   + "/csv/2mb.csv",
                 "5mb"            => File.expand_path(File.dirname(__FILE__))   + "/csv/5mb.csv",
                 "10mb"           => File.expand_path(File.dirname(__FILE__))   + "/csv/10mb.csv",
                 "2mb_ja"            => File.expand_path(File.dirname(__FILE__))   + "/csv/2mb_ja.csv",
                 "5mb_ja"            => File.expand_path(File.dirname(__FILE__))   + "/csv/5mb_ja.csv",
                 "10mb_ja"           => File.expand_path(File.dirname(__FILE__))   + "/csv/10mb_ja.csv",
                 "r7_data"        => File.expand_path(File.dirname(__FILE__))   + "/csv/r7_data.csv",
                 "r7_data_ja"        => File.expand_path(File.dirname(__FILE__))   + "/csv/r7_data_ja.csv",
                 "r7_1mb"         => File.expand_path(File.dirname(__FILE__))   + "/csv/r7_1mb.csv",
                 "r7_1mb_ja"      => File.expand_path(File.dirname(__FILE__))   + "/csv/r7_1mb_ja.csv",
                 "r7_2mb"         => File.expand_path(File.dirname(__FILE__))   + "/csv/r7_2mb.csv",
                 "r7_5mb"         => File.expand_path(File.dirname(__FILE__))   + "/csv/r7_5mb.csv",
                 "r7_10mb"        => File.expand_path(File.dirname(__FILE__))   + "/csv/r7_10mb.csv"                 
                 }

    if ENV['OS'] =~ /Windows/
      CSV_FILES.each do |key, value|
        CSV_FILES[key] = value.gsub('/', '\\')
      end
    end

    COMMENT_STATUSES = {"registered" => _("Registered"),      # Registered comments
                        "temporary"  => _("Temporary Save")
    }

    def login_as_reviewer(reviewer_name=REVIEWER_NAME,
                          reviewer_password = REVIEWER_PASSWORD)
      login(reviewer_name,
            reviewer_password)
    end

    def login_as_pj_member(pj_member_name     = PJ_MEMBER_NAME,
                           pj_member_password = PJ_MEMBER_PASSWORD)
      login(pj_member_name,
            pj_member_password)
    end

    # opens an Analysis Result Report List page
    #
    def open_analysis_result_report_list(pu_id = PU_ID, pj_id = PJ_ID, task_id = ID, subtask_id = SUB_ID)
      # requests to open
      # http://localhost:3000/review/view_result_report_list/1/1?id=1&sub_id=1
      open(url_for(:controller  => "review",
                   :action      => "view_result_report_list",
                   :pu          => pu_id,
                   :pj          => pj_id,
                   :id          => task_id,
                   :sub_id      => subtask_id))

      # wait for loading page
      wait_for_page_to_load(60000)
      wait_for_text_present($page_titles["review_view_result_report_list"])
    end

    # accesses an Analysis Result Report List page as a reviewer
    def access_analysis_result_report_list_as_reviewer(pu_id      = PU_ID,
                                                       pj_id      = PJ_ID,
                                                       task_id    = ID,
                                                       subtask_id = SUB_ID)
      login_as_reviewer
      open_analysis_result_report_list(pu_id,
                                       pj_id,
                                       task_id,
                                       subtask_id)
    end

    # accesses an Analysis Result Report List page as a pj member
    def access_analysis_result_report_list_as_pj_member(pu_id       = PU_ID,
                                                        pj_id       = PJ_ID,
                                                        task_id     = ID,
                                                        subtask_id  = SUB_ID)
      login_as_pj_member
      open_analysis_result_report_list(pu_id,
                                       pj_id,
                                       task_id,
                                       subtask_id)
    end

    def open_warning_listing_page_for_subtask(pu_id       = PU_ID,
                                              pj_id       = PJ_ID,
                                              task_id     = ID,
                                              subtask_id  = SUB_ID)
      open(url_for(:controller  => "review",
                   :action      => "view_warning_list",
                   :pu          => pu_id,
                   :pj          => pj_id,
                   :id          => task_id,
                   :sub_id      => subtask_id))

      wait_for_page_to_load(60000)
    end

    # requests to get a Warning Listing Page for a file
    #
    def open_warning_listing_page_for_file(pu_id      = PU_ID,
                                           pj_id      = PJ_ID,
                                           task_id    = ID,
                                           subtask_id = SUB_ID,
                                           result_id  = RESULT_ID)
      open(url_for(:controller  => "review",
                   :action      => "view_report_warning_list",
                   :pu          => pu_id,
                   :pj          => pj_id,
                   :id          => task_id,
                   :sub_id      => subtask_id,
                   :result_id   => result_id))

      wait_for_page_to_load(60000)
    end

    def access_warning_listing_page_for_subtask_as_reviewer(pu_id      = PU_ID,
                                                            pj_id      = PJ_ID,
                                                            task_id    = ID,
                                                            subtask_id = SUB_ID)

      login_as_reviewer

      open_warning_listing_page_for_subtask(pu_id,
                                            pj_id,
                                            task_id,
                                            subtask_id)
    end

    def access_warning_listing_page_for_subtask_as_pj_member(pu_id      = PU_ID,
                                                             pj_id      = PJ_ID,
                                                             task_id    = ID,
                                                             subtask_id = SUB_ID)
      login(PJ_MEMBER_NAME,
            PJ_MEMBER_PASSWORD)

      open_warning_listing_page_for_subtask(pu_id,
                                            pj_id,
                                            task_id,
                                            subtask_id)
    end

    # requests to get a Comment Listing Page for a subtask
    #
    def open_comment_listing_page_for_subtask(pu_id = PU_ID, pj_id = PJ_ID, task_id = ID, subtask_id = SUB_ID)
      open(url_for(:controller  => "review",
                   :action      => "view_comment_list",
                   :pu          => pu_id,
                   :pj          => pj_id,
                   :id          => task_id,
                   :sub_id      => subtask_id))

      wait_for_page_to_load(60000)

      # asserts page's title
      # assert(is_text_present($page_titles["review_view_comment_list"]))
    end

    # requests to get a Comment Listing Page for a file
    #
    def open_comment_listing_page_for_file(pu_id = PU_ID,
                                           pj_id = PJ_ID,
                                           task_id = ID,
                                           subtask_id = SUB_ID,
                                           result_id = RESULT_ID)
      open(url_for(:controller  => "review",
          :action      => "view_report_comment_list",
          :pu          => pu_id,
          :pj          => pj_id,
          :id          => task_id,
          :sub_id      => subtask_id,
          :result_id   => result_id))

      wait_for_page_to_load(60000)
    end

    # accesses "Comment Listing Page" as a reviewer
    #
    def access_comment_listing_page_for_subtask_as_reviewer(pu_id      = PU_ID,
                                                            pj_id      = PJ_ID,
                                                            task_id    = ID,
                                                            subtask_id = SUB_ID)
      login_as_reviewer

      open_comment_listing_page_for_subtask(pu_id,
                                            pj_id,
                                            task_id,
                                            subtask_id)
    end

    # accesses "Comment Listing Page" as a pj member
    #
    def access_comment_listing_page_for_subtask_as_pj_member(pu_id      = PU_ID,
                                                             pj_id      = PJ_ID,
                                                             task_id    = ID,
                                                             subtask_id = SUB_ID)

      login_as_pj_member

      open_comment_listing_page_for_subtask(pu_id,
                                            pj_id,
                                            task_id,
                                            subtask_id)
    end

    def access_comment_listing_page_for_file_as_reviewer(pu_id      = PU_ID,
                                                         pj_id      = PJ_ID,
                                                         task_id    = ID,
                                                         subtask_id = SUB_ID,
                                                         result_id = RESULT_ID)
      login_as_reviewer
      open_comment_listing_page_for_file(pu_id,
                                         pj_id,
                                         task_id,
                                         subtask_id,
                                         result_id)
    end

    def access_comment_listing_page_for_file_as_pj_member(pu_id      = PU_ID,
                                                         pj_id      = PJ_ID,
                                                         task_id    = ID,
                                                         subtask_id = SUB_ID,
                                                         result_id = RESULT_ID)
      login_as_pj_member
      open_comment_listing_page_for_file(pu_id,
                                         pj_id,
                                         task_id,
                                         subtask_id,
                                         result_id)
    end

    # Open Review Administration page
    #
    def open_review_administration_page
      open(url_for(:controller  => "review",
                   :action      => "index"))

      wait_for_page_to_load(60000)      
      assert(is_text_present($page_titles["review_index"]))

    end

    # opens an Analysis Result Report page
    def open_analysis_result_report_page(pu_id      = PU_ID,
                                         pj_id      = PJ_ID,
                                         task_id    = ID,
                                         subtask_id = SUB_ID,
                                         result_id  = RESULT_ID)
      open(url_for(:controller  => "review",
                   :action      => "view_result_report",
                   :pu          => pu_id,
                   :pj          => pj_id,
                   :id          => task_id,
                   :sub_id      => subtask_id,
                   :result_id   => result_id))

      file_name = Result.find(result_id,
                              :select => "file_name").file_name

      page_title = $page_titles["review_view_result_report"].sub("__FILE_NAME__",
                                                                 file_name)
      wait_for_text_present(page_title)
    end

    # accesses an Analysis Result Report page as a reviewer
    #
    def access_analysis_result_report_page_as_reviewer(pu_id      = PU_ID,
                                                       pj_id      = PJ_ID,
                                                       task_id    = ID,
                                                       subtask_id = SUB_ID,
                                                       result_id  = RESULT_ID)
      login_as_reviewer
      open_analysis_result_report_page(pu_id,
                                       pj_id,
                                       task_id,
                                       subtask_id,
                                       result_id)
    end

    def access_analysis_result_report_page_as_pj_member(pu_id       = PU_ID,
                                                        pj_id       = PJ_ID,
                                                        task_id     = ID,
                                                        subtask_id  = SUB_ID,
                                                        result_id   = RESULT_ID)
      login_as_pj_member
      open_analysis_result_report_page(pu_id,
                                       pj_id,
                                       task_id,
                                       subtask_id,
                                       result_id)
    end

    def set_subtask_publicized(subtask_id = SUB_ID,
                               publicized = true)

      subtask = Subtask.find(subtask_id)
      old_review_status = subtask.review.publicized
      subtask.review.publicized = publicized
      subtask.review.save

      return old_review_status
    end

    # This function is used to test comment/warning filtering
    # The function input the search criteria (search_type and filter_text
    # into the search controls. Then it checks whether the filter result
    # is the same as filtered_warnings
    def check_search_result(search_type,
                            filter_text,
                            filtered_warnings = 0)
      # puts "Searching " + filter_text + "..."
      # input the search criteria
      select($xpath["review"]["search_combobox"], "label=#{search_type}")
      type($xpath["review"]["search_textbox"], filter_text)
      click($xpath["review"]["search_button"])
      sleep 5

      # when complete, the page id is 1 or there is no multiple pages
      if (is_element_present(element_xpath("page_links"))) then
        assert_equal("1", get_text(element_xpath("current_page")))
      end

      # check the result
      if (filtered_warnings == 0) then
        assert(is_text_present($messages["warning_list_empty"]))
      else
        i = 1
        filtered_warnings.each do |warning|
          if (i == 11) then # Open next page. Each page can display 10 warnings
            click("link=Next »")
            sleep 5
            i = 1
          end
          #puts "//tr[@id='warning_#{warning.id}']"
          assert(is_element_present("//tr[@id='warning_#{warning.id}']"))
          i = i + 1
        end
      end
    end
    
    # quick accesses to an xpath
    #
    def element_xpath(element)
      $xpath["review"][element]
    end

    # Opens a "Warning Listing Page" for a file (a result report)
    #
    def open_warning_listing_page_for_file(pu_id      = PU_ID,
                                           pj_id      = PJ_ID,
                                           id         = ID,
                                           sub_id     = SUB_ID,
                                           result_id  = RESULT_ID)
      open(url_for(:controller  => "review",
                   :action      => "view_report_warning_list",
                   :pu          => pu_id,
                   :pj          => pj_id,
                   :id          => id,
                   :sub_id      => sub_id,
                   :result_id   => result_id))
      wait_for_page_to_load(60000)
    end

    # accesses a Warning Listing Page for a file as a reviewer
    #
    def access_warning_listing_page_for_file_as_reviewer(pu_id      = PU_ID,
                                                         pj_id      = PJ_ID,
                                                         task_id    = ID,
                                                         subtask_id = SUB_ID,
                                                         result_id  = RESULT_ID)
      login_as_reviewer
      open_warning_listing_page_for_file(pu_id, pj_id, task_id, subtask_id, result_id)
    end

    # accesses a Warning Listing Page for a file as a pj member
    #
    def access_warning_listing_page_for_file_as_pj_member(pu_id      = PU_ID,
                                                          pj_id      = PJ_ID,
                                                          task_id         = ID,
                                                          subtask_id     = SUB_ID,
                                                          result_id  = RESULT_ID)
      login_as_pj_member
      open_warning_listing_page_for_file(pu_id, pj_id, task_id, subtask_id, result_id)
    end

    # gets contents of "Comment Editor"
    #
    # returns an array which contains 2 elements
    # - the first element is warning description
    # - the second element is sample source code
    def get_comment_editor_contents      
      run_script("updates_textareas();")
      warning_description = get_value('warning_description')       
      sample_source_code  = get_value('sample_source_code')
      
      if warning_description =~ /<p>(.*)<\/p>/
        warning_description = $1
      end


      if sample_source_code =~ /<p>(.*)<\/p>/
        sample_source_code = $1
      end

#      if warning_description == ""
#        warning_description = nil
#      end
#      if sample_source_code == ""
#        sample_source_code = nil
#      end
      # returns warning_description, sample_source_code
      [warning_description, sample_source_code]
    end

    # writes into Comment Editor
    #
    def set_comment_editor_contents(warning_description = "",
                                    sample_source_code = "")

      @selenium.run_script("FCKeditorAPI.GetInstance('warning_description').SetHTML('#{warning_description}');")
      @selenium.run_script("FCKeditorAPI.GetInstance('sample_source_code').SetHTML('#{sample_source_code}');")
    end

    # This function is called when Comment Editor Subwindow is opened
    # It will input the comment text into the Subwindow and register the comment
    #
    def register_comment(comment_text = "",
                         comment_status = true)     
      comment_editor
      sleep 5

      set_comment_editor_contents(comment_text)

      # clicks "Register" button
      if (comment_status) then
        click(element_xpath("register_button"))
        wait_for_text_present($messages["register_comment"])
      else
        click(element_xpath("temporary_save_button"))
        wait_for_text_present($messages["temporary_save_comment"])
      end
    end
  def referred_commen_list
    if $lang == 'en'
        wait_for_text_present("Referred Comment List")
     else
        wait_for_text_present("コメント一覧")
    end
  end
  def comment_editor
    if $lang == 'en'
        wait_for_text_present("Comment Editor")
     else
        wait_for_text_present("コメント・エディター")
    end
  end
   def type_csv_upload_file(csv_files_en,csv_files_ja)
    if ($lang == 'en')
    type(element_xpath("upload_file_browser"),csv_files_en)
    else
      type(element_xpath("upload_file_browser"),csv_files_ja)
    end
    end

  end
end
