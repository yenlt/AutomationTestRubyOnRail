require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../integration/setup'
require 'comment_controller'
require 'review_controller'
class CommentControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  ##############################################################################
  # Setup
  ##############################################################################
  fixtures :users
  fixtures :privileges
  fixtures :privileges_users

  fixtures :pus
  fixtures :pjs

  fixtures :comments

  ## user
  REVIEWER_login  = "root"
  PJ_login        = "pj_member"
  ## number of page
  WARNING_LISTING       = 2
  WARNING_LISTING_FILE  = 3
  COMMENT_LISTING       = 4
  COMMENT_LISTING_FILE  = 5
  ## warning list
  NO_WARNING        = []
  SAVED_WARNING     = ["3904","3905","3906","3907"]
  SELECTED_WARNING  = ["1","2","3"]
  SELECTED_WARNING_NO_COMMENT = ["4","5","6"]
  TEMPORARY_WARNING = ["3908", "3909", "3910", "3911"]
  WARNING_NO_COMMENT= ["5194","6484"]
  CHECKED           = "3904"
  UNCHECKED         = "3911"
  WARNING_DESCRIPTION = "Sample warning description"
  SAMPLE_SOURCE_CODE  = "Sample source code"
  SPECIAL_WARNING_DESCRIPTION = "<p>&nbsp;</p>\n<p>&nbsp;</p>\n<p>&nbsp;&nbsp; </p>"
  SPECIAL_SAMPLE_SOURCE_CODE = "<p>&nbsp;</p>\n<p>&nbsp;</p>\n<p>&nbsp;&nbsp; </p>"
  SELECTED_PU       = 1
  SELECTED_PJ       = 1
  SELECTED_TASK     = 1
  SELECTED_SUBTASK  = 1
  SELECTED_RESULT   = 6
  SELECTED_RISK_TYPE = 1
  ## SETUP
  #
  # register comment
  def register_comment(warning_id, risk_type_id, warning_description, sample_source_code, status)
    if comment = Comment.find_by_warning_id(warning_id)
      comment.update_attributes(:risk_type_id         =>  risk_type_id,
                                :warning_description  => warning_description,
                                :sample_source_code   => sample_source_code,
                                :status               => status)
    else
      comment = Comment.new(:warning_id           => warning_id,
                            :risk_type_id         =>  risk_type_id,
                            :warning_description  => warning_description,
                            :sample_source_code   => sample_source_code,
                            :status               => status)
    end
    comment.save
  end
  # delete comment
  def del_comment(warning_id)
    if comment = Comment.find_by_warning_id(warning_id)
      comment.delete
    end
  end

  #
  def setup
    @controller = CommentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## save comments
    SAVED_WARNING.each do |warning_id|
      register_comment(warning_id,2, WARNING_DESCRIPTION,SAMPLE_SOURCE_CODE,1)
    end
    ## temporary save comments
    TEMPORARY_WARNING.each do |warning_id|
      register_comment(warning_id,2, WARNING_DESCRIPTION,SAMPLE_SOURCE_CODE,0)
    end
  end
  #
  def teardown
    ## delete saved comments
    SAVED_WARNING.each do |warning_id|
      del_comment(warning_id)
    end
    ## delete temporary saved comments
    TEMPORARY_WARNING.each do |warning_id|
      del_comment(warning_id)
    end
  end

   ##############################################################################
  # Test display bulk comment editor subwindow
  # Test bulk edit comment
  # Test refer to Bulk Referred Comment List subwindow
  #############################################################################

      # Display Bulk Comment Editor subwindow.
      # belong to "Warning Listing" page for subtask
  def test_it_bec10a_t4_001
    login_as REVIEWER_login
    ## initiallize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
     ## call function
     get  :bulk_view_comment_editor,
          :p1   => WARNING_LISTING,
          :sub_id => 5

    ## test conditions
    assert_response :success
    assert_template "comment/_bulk_comment_editor_subwindow"
    assert_select "input[type = 'submit'][value = '#{_('Temporary Save')}']"
    assert_select "input[type = 'submit'][value = '#{_('Register')}']"
		assert_select "a[class = 'cancel_link']"
  end
     # Display Bulk Comment Editor subwindow
     # belong to "Comment Listing" page for subtask
   def test_it_bec10a_t4_002
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
    end
     ## call function
     get :bulk_view_comment_editor,
      :p1   => COMMENT_LISTING,
      :sub_id => 5
    assert_response :success
    assert_template "comment/_bulk_comment_editor_subwindow"
    assert_select "input[type = 'submit'][value = '#{_('Temporary Save')}']"
    assert_select "input[type = 'submit'][value = '#{_('Register')}']"
		assert_select "a[class = 'cancel_link']"
  end

      # Display Bulk Comment Editor subwindow
      # belong to "Warning Listing" page for file
   def test_it_bec10a_t4_003
      login_as REVIEWER_login
    ## initiallize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
    SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
     ## call function
     get :bulk_view_comment_editor,
      :p1   => WARNING_LISTING_FILE,
      :sub_id => 5
    assert_response :success
    assert_template "comment/_bulk_comment_editor_subwindow"
    assert_select "input[type = 'submit'][value = '#{_('Temporary Save')}']"
    assert_select "input[type = 'submit'][value = '#{_('Register')}']"
		assert_select "a[class = 'cancel_link']"
  end


  # Display Bulk Comment Editor subwindow
  # belong to "Comment Listing" page for file
   def test_it_bec10a_t4_004
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
    end
     ## call function
     get :bulk_view_comment_editor,
      :p1   => COMMENT_LISTING_FILE,
      :sub_id => 5
    #assert_response :success
    assert_template "comment/_bulk_comment_editor_subwindow"
    assert_select "input[type = 'submit'][value = '#{_('Temporary Save')}']"
    assert_select "input[type = 'submit'][value = '#{_('Register')}']"
		assert_select "a[class = 'cancel_link']"
  end

   # Input warning description and register new multiple comments.
  # belong to "Warning Listing" page for subtask
  # Warning description contains all white space.
    def test_it_bec10a_t4_005
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{WARNING_LISTING}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => WARNING_LISTING,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> "<p>&nbsp;&nbsp; </p>",
                       :sample_source_code		=>  "<p>&nbsp;&nbsp; </p>",
                       :status								=> true,
                       :sub_id                => 5

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,""
       assert_equal @comment.sample_source_code,""
      end
    assert_template "review/_warning_row"
		assert_equal _("Comment(s) were registered successfully!"), flash[:notice]
  end

   # Input warning description and register new multiple comments.
   # belong to "Warning Listing" page for subtask
   #  Warning description contains all white space and break
    def test_it_bec10a_t4_006
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{WARNING_LISTING}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => WARNING_LISTING,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> SPECIAL_WARNING_DESCRIPTION,
                       :sample_source_code		=> SPECIAL_SAMPLE_SOURCE_CODE,
                       :status								=> true,
                       :sub_id                => 5

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,""
       assert_equal @comment.sample_source_code,""
      end
    assert_template "review/_warning_row"
		assert_equal _("Comment(s) were registered successfully!"), flash[:notice]
  end

     # Input warning description and register new multiple comments.
   # belong to "Warning Listing" page for subtask
    def test_it_bec10a_t4_007
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{WARNING_LISTING}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => WARNING_LISTING,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> WARNING_DESCRIPTION,
                       :sample_source_code		=>  SAMPLE_SOURCE_CODE,
                       :status								=> true,
                       :sub_id                => 5

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,WARNING_DESCRIPTION
       assert_equal @comment.sample_source_code,SAMPLE_SOURCE_CODE
      end
    assert_template "review/_warning_row"
		assert_equal _("Comment(s) were registered successfully!"), flash[:notice]
  end

      # Input warning description and register new multiple comments.
  # belong to "Comming Listing" page for subtask
  # Warning description contains all white space.
    def test_it_bec10a_t4_008
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{COMMENT_LISTING}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => COMMENT_LISTING,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> "<p>&nbsp;&nbsp; </p>",
                       :sample_source_code		=>  "<p>&nbsp;&nbsp; </p>",
                       :status								=> true,
                       :sub_id                => 5,
                       :filter_keyword   => "",
                       :order_direction   => "ASC",
                       :page => 2,
                       :filter_field     => "",
                       :order_field=>"id"

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,""
       assert_equal @comment.sample_source_code,""
      end
    assert_template "review/_warning_list"
		assert_equal _("Comment(s) were registered successfully!"), flash[:notice]
  end

   # Input warning description and register new multiple comments.
   # belong to "Comming Listing" page for subtask
   #  Warning description contains all white space and break
   def test_it_bec10a_t4_009
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{COMMENT_LISTING}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => COMMENT_LISTING,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> SPECIAL_WARNING_DESCRIPTION,
                       :sample_source_code		=> SPECIAL_SAMPLE_SOURCE_CODE,
                       :status								=> true,
                       :sub_id                => 5,
                       :filter_keyword   => "",
                       :order_direction   => "ASC",
                       :page => 2,
                       :filter_field     => "",
                       :order_field=>"id"

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,""
       assert_equal @comment.sample_source_code,""
      end
    assert_template "review/_warning_list"
		assert_equal _("Comment(s) were registered successfully!"), flash[:notice]
  end

    # Input warning description and register new multiple comments.
    # belong to "Comming Listing" page for subtask
    def test_it_bec10a_t4_010
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{COMMENT_LISTING}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => COMMENT_LISTING,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> WARNING_DESCRIPTION,
                       :sample_source_code		=>  SAMPLE_SOURCE_CODE,
                       :status								=> true,
                       :sub_id                => 5,
                       :filter_keyword   => "",
                       :order_direction   => "ASC",
                       :page => 2,
                       :filter_field     => "",
                       :order_field=>"id"

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,WARNING_DESCRIPTION
       assert_equal @comment.sample_source_code,SAMPLE_SOURCE_CODE
      end
    assert_template "review/_warning_list"
		assert_equal _("Comment(s) were registered successfully!"), flash[:notice]
  end
     # Input warning description and register new multiple comments.
  # belong to "Warning Listing" page for file
  #   # Warning description contains all white space.
    def test_it_bec10a_t4_011
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{WARNING_LISTING_FILE}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => WARNING_LISTING_FILE,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> "<p>&nbsp;&nbsp; </p>",
                       :sample_source_code		=>  "<p>&nbsp;&nbsp; </p>",
                       :status								=> true,
                       :sub_id                => 5,
                       :filter_keyword   => "",
                       :order_direction   => "ASC",
                       :page => 2,
                       :filter_field     => "",
                       :order_field=>"id"

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,""
       assert_equal @comment.sample_source_code,""
      end
    assert_template "review/_report_warning_row"
		assert_equal _("Comment(s) were registered successfully!"), flash[:notice]
  end

   # Input warning description and register new multiple comments.
   # belong to "Warning Listing" page for file
   #  Warning description contains all white space and break
   def test_it_bec10a_t4_012
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{WARNING_LISTING_FILE}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => WARNING_LISTING_FILE,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> SPECIAL_WARNING_DESCRIPTION,
                       :sample_source_code		=> SPECIAL_SAMPLE_SOURCE_CODE,
                       :status								=> true,
                       :sub_id                => 5,
                       :filter_keyword   => "",
                       :order_direction   => "ASC",
                       :page => 2,
                       :filter_field     => "",
                       :order_field=>"id"

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,""
       assert_equal @comment.sample_source_code,""
      end
    assert_template "review/_report_warning_row"
		assert_equal _("Comment(s) were registered successfully!"), flash[:notice]
  end

    # Input warning description and register new multiple comments.
    # belong to "Warning Listing" page for file
    def test_it_bec10a_t4_013
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{WARNING_LISTING_FILE}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => WARNING_LISTING_FILE,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> WARNING_DESCRIPTION,
                       :sample_source_code		=>  SAMPLE_SOURCE_CODE,
                       :status								=> true,
                       :sub_id                => 5

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,WARNING_DESCRIPTION
       assert_equal @comment.sample_source_code,SAMPLE_SOURCE_CODE
      end
    assert_template "review/_report_warning_row"
		assert_equal _("Comment(s) were registered successfully!"), flash[:notice]
  end


      # Input warning description and register new multiple comments.
  # belong to "Comment Listing" page for file
  #   # Warning description contains all white space.
    def test_it_bec10a_t4_014
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => COMMENT_LISTING_FILE,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> "<p>&nbsp;&nbsp; </p>",
                       :sample_source_code		=>  "<p>&nbsp;&nbsp; </p>",
                       :status								=> true,
                       :sub_id                => 5,
                       :filter_keyword   => "",
                       :order_direction   => "ASC",
                       :page => 2,
                       :filter_field     => "",
                       :order_field=>"id"

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,""
       assert_equal @comment.sample_source_code,""
      end
    assert_template "review/_report_warning_list"
		assert_equal _("Comment(s) were registered successfully!"), flash[:notice]
  end

   # Input warning description and register new multiple comments.
   # belong to "Comment Listing" page for file
   #  Warning description contains all white space and break
   def test_it_bec10a_t4_015
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => COMMENT_LISTING_FILE,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> SPECIAL_WARNING_DESCRIPTION,
                       :sample_source_code		=> SPECIAL_SAMPLE_SOURCE_CODE,
                       :status								=> true,
                       :sub_id                => 5,
                       :filter_keyword   => "",
                       :order_direction   => "ASC",
                       :page => 2,
                       :filter_field     => "",
                       :order_field=>"id"

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,""
       assert_equal @comment.sample_source_code,""
      end
    assert_template "review/_report_warning_list"
		assert_equal _("Comment(s) were registered successfully!"), flash[:notice]
  end

    # Input warning description and register new multiple comments.
    # belong to "Comment Listing" page for file
    def test_it_bec10a_t4_016
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => COMMENT_LISTING_FILE,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> WARNING_DESCRIPTION,
                       :sample_source_code		=>  SAMPLE_SOURCE_CODE,
                       :status								=> true,
                       :sub_id                => 5

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,WARNING_DESCRIPTION
       assert_equal @comment.sample_source_code,SAMPLE_SOURCE_CODE
      end
    assert_template "review/_report_warning_list"
		assert_equal _("Comment(s) were registered successfully!"), flash[:notice]
  end


   # Input warning description and temporary save new multiple comments.
  # belong to "Warning Listing" page for subtask
  # Warning description contains all white space.
    def test_it_bec10a_t4_017
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{WARNING_LISTING}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => WARNING_LISTING,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> "<p>&nbsp;&nbsp; </p>",
                       :sample_source_code		=>  "<p>&nbsp;&nbsp; </p>",
                       :status								=> false,
                       :sub_id                => 5

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,""
       assert_equal @comment.sample_source_code,""
      end
    assert_template "review/_warning_row"
		assert_equal _("Comment(s) were temporary saved successfully!"), flash[:notice]
  end

   # Input warning description and temporary save new multiple comments.
   # belong to "Warning Listing" page for subtask
   #  Warning description contains all white space and break
    def test_it_bec10a_t4_018
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{WARNING_LISTING}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => WARNING_LISTING,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> SPECIAL_WARNING_DESCRIPTION,
                       :sample_source_code		=> SPECIAL_SAMPLE_SOURCE_CODE,
                       :status								=> false,
                       :sub_id                => 5

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,""
       assert_equal @comment.sample_source_code,""
      end
    assert_template "review/_warning_row"
		assert_equal _("Comment(s) were temporary saved successfully!"), flash[:notice]
  end

     # Input warning description and temporary save new multiple comments.
   # belong to "Warning Listing" page for subtask
    def test_it_bec10a_t4_019
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{WARNING_LISTING}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => WARNING_LISTING,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> WARNING_DESCRIPTION,
                       :sample_source_code		=>  SAMPLE_SOURCE_CODE,
                       :status								=> false,
                       :sub_id                => 5

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,WARNING_DESCRIPTION
       assert_equal @comment.sample_source_code,SAMPLE_SOURCE_CODE
      end
    assert_template "review/_warning_row"
		assert_equal _("Comment(s) were temporary saved successfully!"), flash[:notice]
  end

      # Input warning description and temporary save new multiple comments.
  # belong to "Comming Listing" page for subtask
  # Warning description contains all white space.
    def test_it_bec10a_t4_020
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{COMMENT_LISTING}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => COMMENT_LISTING,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> "<p>&nbsp;&nbsp; </p>",
                       :sample_source_code		=>  "<p>&nbsp;&nbsp; </p>",
                       :status								=> false,
                       :sub_id                => 5,
                       :filter_keyword   => "",
                       :order_direction   => "ASC",
                       :page => 2,
                       :filter_field     => "",
                       :order_field=>"id"

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,""
       assert_equal @comment.sample_source_code,""
      end
    assert_template "review/_warning_list"
		assert_equal _("Comment(s) were temporary saved successfully!"), flash[:notice]
  end

   # Input warning description and temporary save new multiple comments.
   # belong to "Comming Listing" page for subtask
   #  Warning description contains all white space and break
   def test_it_bec10a_t4_021
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{COMMENT_LISTING}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => COMMENT_LISTING,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> SPECIAL_WARNING_DESCRIPTION,
                       :sample_source_code		=> SPECIAL_SAMPLE_SOURCE_CODE,
                       :status								=> false,
                       :sub_id                => 5,
                       :filter_keyword   => "",
                       :order_direction   => "ASC",
                       :page => 2,
                       :filter_field     => "",
                       :order_field=>"id"

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,""
       assert_equal @comment.sample_source_code,""
      end
    assert_template "review/_warning_list"
		assert_equal _("Comment(s) were temporary saved successfully!"), flash[:notice]
  end

    # Input warning description and temporary save new multiple comments.
    # belong to "Comming Listing" page for subtask
    def test_it_bec10a_t4_022
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{COMMENT_LISTING}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => COMMENT_LISTING,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> WARNING_DESCRIPTION,
                       :sample_source_code		=>  SAMPLE_SOURCE_CODE,
                       :status								=> false,
                       :sub_id                => 5,
                       :filter_keyword   => "",
                       :order_direction   => "ASC",
                       :page => 2,
                       :filter_field     => "",
                       :order_field=>"id"

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,WARNING_DESCRIPTION
       assert_equal @comment.sample_source_code,SAMPLE_SOURCE_CODE
      end
    assert_template "review/_warning_list"
		assert_equal _("Comment(s) were temporary saved successfully!"), flash[:notice]
  end
     # Input warning description and temporary save new multiple comments.
  # belong to "Warning Listing" page for file
  #   # Warning description contains all white space.
    def test_it_bec10a_t4_023
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{WARNING_LISTING_FILE}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => WARNING_LISTING_FILE,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> "<p>&nbsp;&nbsp; </p>",
                       :sample_source_code		=>  "<p>&nbsp;&nbsp; </p>",
                       :status								=> false,
                       :sub_id                => 5,
                       :filter_keyword   => "",
                       :order_direction   => "ASC",
                       :page => 2,
                       :filter_field     => "",
                       :order_field=>"id"

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,""
       assert_equal @comment.sample_source_code,""
      end
    assert_template "review/_report_warning_row"
		assert_equal _("Comment(s) were temporary saved successfully!"), flash[:notice]
  end

   # Input warning description and temporary save new multiple comments.
   # belong to "Warning Listing" page for file
   #  Warning description contains all white space and break
   def test_it_bec10a_t4_024
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{WARNING_LISTING_FILE}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => WARNING_LISTING_FILE,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> SPECIAL_WARNING_DESCRIPTION,
                       :sample_source_code		=> SPECIAL_SAMPLE_SOURCE_CODE,
                       :status								=> false,
                       :sub_id                => 5,
                       :filter_keyword   => "",
                       :order_direction   => "ASC",
                       :page => 2,
                       :filter_field     => "",
                       :order_field=>"id"

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,""
       assert_equal @comment.sample_source_code,""
      end
    assert_template "review/_report_warning_row"
		assert_equal _("Comment(s) were temporary saved successfully!"), flash[:notice]
  end

    # Input warning description and temporary save new multiple comments.
    # belong to "Warning Listing" page for file
    def test_it_bec10a_t4_025
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{WARNING_LISTING_FILE}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => WARNING_LISTING_FILE,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> WARNING_DESCRIPTION,
                       :sample_source_code		=>  SAMPLE_SOURCE_CODE,
                       :status								=> false,
                       :sub_id                => 5

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,WARNING_DESCRIPTION
       assert_equal @comment.sample_source_code,SAMPLE_SOURCE_CODE
      end
    assert_template "review/_report_warning_row"
		assert_equal _("Comment(s) were temporary saved successfully!"), flash[:notice]
  end


      # Input warning description and temporary save new multiple comments.
  # belong to "Comment Listing" page for file
  #   # Warning description contains all white space.
    def test_it_bec10a_t4_026
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => COMMENT_LISTING_FILE,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> "<p>&nbsp;&nbsp; </p>",
                       :sample_source_code		=>  "<p>&nbsp;&nbsp; </p>",
                       :status								=> false,
                       :sub_id                => 5,
                       :filter_keyword   => "",
                       :order_direction   => "ASC",
                       :page => 2,
                       :filter_field     => "",
                       :order_field=>"id"

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,""
       assert_equal @comment.sample_source_code,""
      end
    assert_template "review/_report_warning_list"
		assert_equal _("Comment(s) were temporary saved successfully!"), flash[:notice]
  end

   # Input warning description and temporary save new multiple comments.
   # belong to "Comment Listing" page for file
   #  Warning description contains all white space and break
   def test_it_bec10a_t4_027
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => COMMENT_LISTING_FILE,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> SPECIAL_WARNING_DESCRIPTION,
                       :sample_source_code		=> SPECIAL_SAMPLE_SOURCE_CODE,
                       :status								=> false,
                       :sub_id                => 5,
                       :filter_keyword   => "",
                       :order_direction   => "ASC",
                       :page => 2,
                       :filter_field     => "",
                       :order_field=>"id"

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,""
       assert_equal @comment.sample_source_code,""
      end
    assert_template "review/_report_warning_list"
		assert_equal _("Comment(s) were temporary saved successfully!"), flash[:notice]
  end

    # Input warning description and temporary save new multiple comments.
    # belong to "Comment Listing" page for file
    def test_it_bec10a_t4_028
      login_as REVIEWER_login
      ## initiallize session
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"]
     ## call function
   	 get :bulk_edit_comments,
                       :p1 => COMMENT_LISTING_FILE,
                       :warnings            => ["1"],
                       :risk_type_id					=> "1",
                       :warning_description 	=> WARNING_DESCRIPTION,
                       :sample_source_code		=>  SAMPLE_SOURCE_CODE,
                       :status								=> false,
                       :sub_id                => 5

      # test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,WARNING_DESCRIPTION
       assert_equal @comment.sample_source_code,SAMPLE_SOURCE_CODE
      end
    assert_template "review/_report_warning_list"
		assert_equal _("Comment(s) were temporary saved successfully!"), flash[:notice]
  end
    # Chose to refer referred comment list subwindow and
    # all of rule belong to selected warning have no comment.
    # At "Bulk Referred Comment List" subwindow have just one "Cancel" button is displayed.
  def test_it_bec10a_t4_029
    login_as REVIEWER_login
      ## initiallize session
      # Selected warning have no comment:
      SELECTED_WARNING_NO_COMMENT.each do |warning_id|
      del_comment(warning_id)
     end
      @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
      SELECTED_WARNING_NO_COMMENT.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end

    # Display Bulk Referred Comment List subwindow
     post :bulk_view_referred_comment_list,
                                            :pj        => 1,
                                            :pu        => 1,
                                            :id        => 3,
                                            :sub_id    => 5,
                                            :warnings  => ["1","2","3"],
				                                    :rules     => ["0839","0838","2017"]
    assert_template "comment/_bulk_referred_comment_list_subwindow"
		assert_select "input[type = 'button'][value = 'Cancel']"
  end

  # Create comment for all of rule belong to selected warnings.
  # Chose to refer referred comment list subwindow and all of rule belong to selected warning have comments.
  # Current_rule is nul
	def test_it_bec10a_t4_030
     login_as REVIEWER_login
      # Create comment for all of rule belong to selected warnings.
      ## initiallize session
      @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    warning_ids = @request.session["selected_warnings_#{WARNING_LISTING}"]
   	 get :bulk_edit_comments,
         :p1 => 2,
         :warnings            => ["1","2","3"],
				 :risk_type_id					=> "1",
			   :warning_description 	=> WARNING_DESCRIPTION,
         :sample_source_code		=>  SAMPLE_SOURCE_CODE,
				 :status								=> true,
         :sub_id                => 5
       # Return main window
      assert_template "review/_warning_row"
	    assert_equal _("Comment(s) were registered successfully!"), flash[:notice]
         #test save successfully
      warning_ids.each do |warning_id|
       @comment = Comment.find_by_warning_id(warning_id)
       assert_equal @comment.warning_description,WARNING_DESCRIPTION
       assert_equal @comment.sample_source_code,SAMPLE_SOURCE_CODE
      end
     #  warning_id = 1, 2, 3 are selected.
     # Display Bulk Referred Comment List subwindow
     get :bulk_view_referred_comment_list,
            :pj        => 1,
            :pu        => 1,
            :id        => 3,
            :sub_id    => 5,
            :warnings  => ["1","2","3"],
            :rules     => ["0240", "0288", "2017"],
            :current_rule => nil

    assert_template "comment/_bulk_referred_comment_list_subwindow"
		assert_select "input[type = 'button'][value = 'Cancel']"
    assert_select "input[type = 'button'][value = 'OK']"
  end

  # Create comment for all of rule belong to selected warnings.
  # Chose to refer referred comment list subwindow and all of rule belong to selected warning have comments.
  # Current_rule isn't nil
	def test_it_bec10a_t4_031
     login_as REVIEWER_login
      # Create comment for all of rule belong to selected warnings.
      ## initiallize session
      @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
      SELECTED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
   	 get :bulk_edit_comments,
         :p1 => 2,
         :warnings            => ["1","2","3"],
				 :risk_type_id					=> "1",
			   :warning_description 	=> WARNING_DESCRIPTION,
         :sample_source_code		=>  SAMPLE_SOURCE_CODE,
				 :status								=> true,
         :sub_id                => 5
       # Return main window
      assert_template "review/_warning_row"
	    assert_equal _("Comment(s) were registered successfully!"), flash[:notice]

     #  warning_id = 1, 2, 3 are selected.
     # Display Bulk Referred Comment List subwindow
      get :bulk_view_referred_comment_list,
          :pj        => 1,
          :pu        => 1,
          :id        => 3,
          :sub_id    => 5,
          :warnings  => ["1","2","3"],
          :rules     => ["0240", "0288", "2017"],
          :current_rule => "0288"

    assert_template "comment/_bulk_referred_rule_list"
		assert_select "input[type = 'button'][value = 'Cancel']"
    assert_select "input[type = 'button'][value = 'OK']"
  end

  ##############################################################################
  # Bulk Edit of Multiple Comments
  # Test multiple select warnings
  # Test with Warning Listing Page
  ##############################################################################

  ## Test: Select warnings by clicking checkbox
  ## + Reviewer logged in.
  ## + Subtask is analyzed and unpublicized.
  ## + Test with "Warning Listing" page
  #
  # No warning is selected
  # Check at unchecked checkbox
  #
  def test_it_bec10a_t4_032
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = []
    ## call store selected warning function
    get :store_selected_warning,:warning_id => UNCHECKED,
                                :p1         => WARNING_LISTING,
                                :selected   => "true"
    ## test condition
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"].size, 1
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"], [UNCHECKED]
  end
  # Some warnings are selected
  # Check at unchecked checkbox
  #
  def test_it_bec10a_t4_033
    ## login
    login_as REVIEWER_login
    ## initiallize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    ## call function
    get :store_selected_warning,:warning_id => UNCHECKED,
                                :p1         => WARNING_LISTING,
                                :selected   => "true"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"].size - 1, SAVED_WARNING.size
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"], SAVED_WARNING + [UNCHECKED]
  end
  # Some warnings are selected
  # Check at checked checkbox
  #
  def test_it_bec10a_t4_034
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    ## call function
    get :store_selected_warning,:warning_id => CHECKED,
                                :p1         => WARNING_LISTING,
                                :selected   => "false"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"].size + 1, SAVED_WARNING.size
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"], SAVED_WARNING - [CHECKED]
  end
  # No warning is selected
  # Check at unchecked checkbox
  # Again check at this checkbox
  #
  def test_it_bec10a_t4_035
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = []
    ## call function
    get :store_selected_warning,:warning_id => UNCHECKED,
                                :p1         => WARNING_LISTING,
                                :selected   => "true"
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"].size, 1
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"], [UNCHECKED]
    get :store_selected_warning,:warning_id => UNCHECKED,
                                :p1         => WARNING_LISTING,
                                :selected   => "false"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"].size, 0
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"], []
  end
  ## Test: Unselect all warnings
  ## + Reviewer logged in.
  ## + Subtask is analyzed and unpublicized.
  ## + Test with "Warning Listing" page
  #
  # No warning is selected
  # Call Uncheck All
  #
  def test_it_bec10a_t4_036
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = []
    ## call function
    get :clear_all_checks, :pu  => SELECTED_PU,
                           :pj  => SELECTED_PJ,
                           :id  => SELECTED_TASK,
                           :sub_id  =>  SELECTED_SUBTASK,
                           :p1=> WARNING_LISTING
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"].size, 0
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"], []
  end
  # Some warnings are selected
  # Call Uncheck All
  #
  def test_it_bec10a_t4_037
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    ## call function
    get :clear_all_checks, :pu  => SELECTED_PU,
                           :pj  => SELECTED_PJ,
                           :id  => SELECTED_TASK,
                           :sub_id  =>  SELECTED_SUBTASK,
                           :p1=> WARNING_LISTING
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"].size, 0
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"], []
  end
  ## Test: Select all warnings
  ## + Reviewer logged in.
  ## + Subtask is analyzed and unpublicized.
  ## + Test with "Warning Listing" page
  #
  # No warning is selected
  # Call Check All
  #
  def test_it_bec10a_t4_038
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id  =>  SELECTED_SUBTASK,
                             :p1=> WARNING_LISTING
    ## get all warnings belong to the conditions
    all_warnings = Warning.find_all_by_subtask_id(SELECTED_SUBTASK,
                                                nil,
                                                nil,
                                                nil,
                                                nil,
                                                false,
                                                false)
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"].size, all_warnings.size
  end
  # Some warnings are selected
  # Call Check All
  #
  def test_it_bec10a_t4_039
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id  =>  SELECTED_SUBTASK,
                             :p1      => WARNING_LISTING
    ## get all warnings belong to the conditions
    all_warnings = Warning.find_all_by_subtask_id(SELECTED_SUBTASK,
                                                nil,
                                                nil,
                                                nil,
                                                nil,
                                                false,
                                                false)
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"].size, all_warnings.size
  end
  # No warning is selected
  # Filter with warnings.rule = 0240
  # Call Check All
  #
  def test_it_bec10a_t4_040
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id          =>  SELECTED_SUBTASK,
                             :p1              => WARNING_LISTING,
                             :filter_field    => "warnings.rule",
                             :filter_keyword  =>  "0240"
    ## get all warnings belong to the conditions
    all_warnings = Warning.find_all_by_subtask_id(SELECTED_SUBTASK,
                                                nil,
                                                nil,
                                                "warnings.rule",
                                                "0240",
                                                false,
                                                false)
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"].size, all_warnings.size
  end
  # No warning is selected
  # Filter with wrong warnings.rule = 0000
  # Call Check All
  #
  def test_it_bec10a_t4_041
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id          =>  SELECTED_SUBTASK,
                             :p1              => WARNING_LISTING,
                             :filter_field    => "warnings.rule",
                             :filter_keyword  =>  "0000"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"].size, 0
  end
  # No warning is selected
  # Filter with warnings.source_name = analyzeme.c
  # Call Check All
  #
  def test_it_bec10a_t4_042
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id          =>  SELECTED_SUBTASK,
                             :p1              => WARNING_LISTING,
                             :filter_field    => "warnings.source_name",
                             :filter_keyword  =>  "analyzeme.c"
    ## get all warnings belong to the conditions
    all_warnings = Warning.find_all_by_subtask_id(SELECTED_SUBTASK,
                                                nil,
                                                nil,
                                                "warnings.source_name",
                                                "analyzeme.c",
                                                false,
                                                false)
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"].size, all_warnings.size
  end
  # No warning is selected
  # Filter with wrong warnings.source_name = xxxx
  # Call Check All
  #
  def test_it_bec10a_t4_043
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id          =>  SELECTED_SUBTASK,
                             :p1              => WARNING_LISTING,
                             :filter_field    => "warnings.source_name",
                             :filter_keyword  =>  "xxxx"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"].size, 0
  end
  # No warning is selected
  # Filter with warnings.source_path = sample_c/src
  # Call Check All
  #
  def test_it_bec10a_t4_044
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id          =>  SELECTED_SUBTASK,
                             :p1              => WARNING_LISTING,
                             :filter_field    => "warnings.source_path",
                             :filter_keyword  =>  "sample_c/src"
    ## get all warnings belong to the conditions
    all_warnings = Warning.find_all_by_subtask_id(SELECTED_SUBTASK,
                                                nil,
                                                nil,
                                                "warnings.source_path",
                                                "sample_c/src",
                                                false,
                                                false)
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"].size, all_warnings.size
  end
  # No warning is selected
  # Filter with wrong warnings.source_path 10= xxxx
  # Call Check All
  #
  def test_it_bec10a_t4_045
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id          =>  SELECTED_SUBTASK,
                             :p1              => WARNING_LISTING,
                             :filter_field    => "warnings.source_path",
                             :filter_keyword  =>  "xxxx"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"].size, 0
  end
  # Test reset session when Search function is called.
  #
  def test_it_bec10a_t4_046
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = []
    ## call function
    get :view_warning_list,  :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id          =>  SELECTED_SUBTASK,
                             :p1              => WARNING_LISTING,
                             :filter_field    => "warnings.source_path",
                             :filter_keyword  =>  "sample_c/src"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"].size, 0
  end
  ## Test: Select warnings by clicking checkbox & Check All & Uncheck All function
  ## + PJ member logged in.
  ## + Subtask is analyzed and unpublicized.
  ## + Test with "Warning Listing" page
  #
  # No warning is selected
  # Check at unchecked checkbox
  #
  def test_it_bec10a_t4_047
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = []
    ## call store selected warning function
    get :store_selected_warning,:warning_id => UNCHECKED,
                                :p1         => WARNING_LISTING,
                                :selected   => "true"
    ## test condition
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"].size, 0
  end
  # Some warnings are selected
  # Check at checked checkbox
  #
  def test_it_bec10a_t4_048
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    ## call function
    get :store_selected_warning,:warning_id => CHECKED,
                                :p1         => WARNING_LISTING,
                                :selected   => "false"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"].size, SAVED_WARNING.size
  end
  # Some warnings are selected
  # Call Uncheck All
  #
  def test_it_bec10a_t4_049
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    ## call function
    get :clear_all_checks, :pu  => SELECTED_PU,
                           :pj  => SELECTED_PJ,
                           :id  => SELECTED_TASK,
                           :sub_id  =>  SELECTED_SUBTASK,
                           :p1=> WARNING_LISTING
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"].size, SAVED_WARNING.size
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"], SAVED_WARNING
  end
# No warning is selected
  # Call Check All
  #
  def test_it_bec10a_t4_050
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id  =>  SELECTED_SUBTASK,
                             :p1=> WARNING_LISTING
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING}"].size, 0
  end
  ##############################################################################
  # Bulk Edit of Multiple Comments
  # Test multiple select warnings
  # Test with Comment Listing Page
  ##############################################################################

  ## Test: Select warnings by clicking checkbox
  ## + Reviewer logged in.
  ## + Subtask is analyzed and unpublicized.
  ## + Test with "Comment Listing" page
  #
  # No warning is selected
  # Check at unchecked checkbox
  #
  def test_it_bec10a_t4_051
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = []
    ## call store selected warning function
    get :store_selected_warning,:warning_id => UNCHECKED,
                                :p1         => COMMENT_LISTING,
                                :selected   => "true"
    ## test condition
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"].size, 1
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"], [UNCHECKED]
  end
  # Some warnings are selected
  # Check at unchecked checkbox
  #
  def test_it_bec10a_t4_052
    ## login
    login_as REVIEWER_login
    ## initiallize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
    end
    ## call function
    get :store_selected_warning,:warning_id => UNCHECKED,
                                :p1         => COMMENT_LISTING,
                                :selected   => "true"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"].size - 1, SAVED_WARNING.size
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"], SAVED_WARNING + [UNCHECKED]
  end
  # Some warnings are selected
  # Check at checked checkbox
  #
  def test_it_bec10a_t4_053
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
    end
    ## call function
    get :store_selected_warning,:warning_id => CHECKED,
                                :p1         => COMMENT_LISTING,
                                :selected   => "false"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"].size + 1, SAVED_WARNING.size
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"], SAVED_WARNING - [CHECKED]
  end
  # No warning is selected
  # Check at unchecked checkbox
  # Again check at this checkbox
  #
  def test_it_bec10a_t4_054
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = []
    ## call function
    get :store_selected_warning,:warning_id => UNCHECKED,
                                :p1         => COMMENT_LISTING,
                                :selected   => "true"
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"].size, 1
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"], [UNCHECKED]
    get :store_selected_warning,:warning_id => UNCHECKED,
                                :p1         => COMMENT_LISTING,
                                :selected   => "false"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"].size, 0
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"], []
  end
  ## Test: Unselect all warnings
  ## + Reviewer logged in.
  ## + Subtask is analyzed and unpublicized.
  ## + Test with "Comment Listing" page
  #
  # No warning is selected
  # Call Uncheck All
  #
  def test_it_bec10a_t4_055
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = []
    ## call function
    get :clear_all_checks, :pu  => SELECTED_PU,
                           :pj  => SELECTED_PJ,
                           :id  => SELECTED_TASK,
                           :sub_id  =>  SELECTED_SUBTASK,
                           :p1=> COMMENT_LISTING
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"].size, 0
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"], []
  end
  # Some warnings are selected
  # Call Uncheck All
  #
  def test_it_bec10a_t4_056
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
    end
    ## call function
    get :clear_all_checks, :pu  => SELECTED_PU,
                           :pj  => SELECTED_PJ,
                           :id  => SELECTED_TASK,
                           :sub_id  =>  SELECTED_SUBTASK,
                           :p1=> COMMENT_LISTING
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"].size, 0
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"], []
  end
  ## Test: Select all warnings
  ## + Reviewer logged in.
  ## + Subtask is analyzed and unpublicized.
  ## + Test with "Comment Listing" page
  #
  # No warning is selected
  # Call Check All
  #
  def test_it_bec10a_t4_057
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id  =>  SELECTED_SUBTASK,
                             :p1=> COMMENT_LISTING
    ## get all warnings belong to the conditions
    all_warnings = Warning.find_all_by_subtask_id(SELECTED_SUBTASK,
                                                nil,
                                                nil,
                                                nil,
                                                nil,
                                                false,
                                                false)
    commented_warnings = Array.new
    all_warnings.each do |warning|
      if Comment.find_by_warning_id(warning.id)
        commented_warnings << warning
      end
    end
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"].size, commented_warnings.size
  end
  # Some warnings are selected
  # Call Check All
  #
  def test_it_bec10a_t4_058
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
    end
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id  =>  SELECTED_SUBTASK,
                             :p1      => COMMENT_LISTING
    ## get all warnings belong to the conditions
    all_warnings = Warning.find_all_by_subtask_id(SELECTED_SUBTASK,
                                                nil,
                                                nil,
                                                nil,
                                                nil,
                                                false,
                                                false)
    commented_warnings = Array.new
    all_warnings.each do |warning|
      if Comment.find_by_warning_id(warning.id)
        commented_warnings << warning
      end
    end
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"].size, commented_warnings.size
  end
  # No warning is selected
  # Filter with warnings.rule = 0240
  # Call Check All
  #
  def test_it_bec10a_t4_059
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id          =>  SELECTED_SUBTASK,
                             :p1              => COMMENT_LISTING,
                             :filter_field    => "warnings.rule",
                             :filter_keyword  =>  "0240"
    ## get all warnings belong to the conditions
    all_warnings = Warning.find_all_by_subtask_id(SELECTED_SUBTASK,
                                                nil,
                                                nil,
                                                "warnings.rule",
                                                "0240",
                                                false,
                                                false)
    commented_warnings = Array.new
    all_warnings.each do |warning|
      if Comment.find_by_warning_id(warning.id)
        commented_warnings << warning
      end
    end
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"].size, commented_warnings.size
  end
  # No warning is selected
  # Filter with wrong warnings.rule = 0000
  # Call Check All
  #
  def test_it_bec10a_t4_060
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id          =>  SELECTED_SUBTASK,
                             :p1              => COMMENT_LISTING,
                             :filter_field    => "warnings.rule",
                             :filter_keyword  =>  "0000"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"].size, 0
  end
  # No warning is selected
  # Filter with warnings.source_name = analyzeme.c
  # Call Check All
  #
  def test_it_bec10a_t4_061
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id          =>  SELECTED_SUBTASK,
                             :p1              => COMMENT_LISTING,
                             :filter_field    => "warnings.source_name",
                             :filter_keyword  =>  "analyzeme.c"
    ## get all warnings belong to the conditions
    all_warnings = Warning.find_all_by_subtask_id(SELECTED_SUBTASK,
                                                nil,
                                                nil,
                                                "warnings.source_name",
                                                "analyzeme.c",
                                                false,
                                                false)
    commented_warnings = Array.new
    all_warnings.each do |warning|
      if Comment.find_by_warning_id(warning.id)
        commented_warnings << warning
      end
    end
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"].size, commented_warnings.size
  end
  # No warning is selected
  # Filter with wrong warnings.source_name = xxxx
  # Call Check All
  #
  def test_it_bec10a_t4_062
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id          =>  SELECTED_SUBTASK,
                             :p1              => COMMENT_LISTING,
                             :filter_field    => "warnings.source_name",
                             :filter_keyword  =>  "xxxx"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"].size, 0
  end
  # No warning is selected
  # Filter with warnings.source_path = sample_c/src
  # Call Check All
  #
  def test_it_bec10a_t4_063
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id          =>  SELECTED_SUBTASK,
                             :p1              => COMMENT_LISTING,
                             :filter_field    => "warnings.source_path",
                             :filter_keyword  =>  "sample_c/src"
    ## get all warnings belong to the conditions
    all_warnings = Warning.find_all_by_subtask_id(SELECTED_SUBTASK,
                                                nil,
                                                nil,
                                                "warnings.source_path",
                                                "sample_c/src",
                                                false,
                                                false)
    commented_warnings = Array.new
    all_warnings.each do |warning|
      if Comment.find_by_warning_id(warning.id)
        commented_warnings << warning
      end
    end
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"].size, commented_warnings.size
  end
  # No warning is selected
  # Filter with wrong warnings.source_path 10= xxxx
  # Call Check All
  #
  def test_it_bec10a_t4_064
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id          =>  SELECTED_SUBTASK,
                             :p1              => COMMENT_LISTING,
                             :filter_field    => "warnings.source_path",
                             :filter_keyword  =>  "xxxx"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"].size, 0
  end
  # Test reset session when Search function is called.
  #
  def test_it_bec10a_t4_065
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = []
    ## call function
    get :view_warning_list,  :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id          =>  SELECTED_SUBTASK,
                             :p1              => COMMENT_LISTING,
                             :filter_field    => "warnings.source_path",
                             :filter_keyword  =>  "sample_c/src"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"].size, 0
  end
  ## Test: Select warnings by clicking checkbox & Check All & Uncheck All function
  ## + PJ member logged in.
  ## + Subtask is analyzed and unpublicized.
  ## + Test with "Comment Listing" page
  #
  # No warning is selected
  # Check at unchecked checkbox
  #
  def test_it_bec10a_t4_066
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = []
    ## call store selected warning function
    get :store_selected_warning,:warning_id => UNCHECKED,
                                :p1         => COMMENT_LISTING,
                                :selected   => "true"
    ## test condition
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"].size, 0
  end
  # Some warnings are selected
  # Check at checked checkbox
  #
  def test_it_bec10a_t4_067
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
    end
    ## call function
    get :store_selected_warning,:warning_id => CHECKED,
                                :p1         => COMMENT_LISTING,
                                :selected   => "false"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"].size, SAVED_WARNING.size
  end
  # Some warnings are selected
  # Call Uncheck All
  #
  def test_it_bec10a_t4_068
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
    end
    ## call function
    get :clear_all_checks, :pu  => SELECTED_PU,
                           :pj  => SELECTED_PJ,
                           :id  => SELECTED_TASK,
                           :sub_id  =>  SELECTED_SUBTASK,
                           :p1=> COMMENT_LISTING
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"].size, SAVED_WARNING.size
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"], SAVED_WARNING
  end
# No warning is selected
  # Call Check All
  #
  def test_it_bec10a_t4_069
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id  =>  SELECTED_SUBTASK,
                             :p1=> COMMENT_LISTING
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING}"].size, 0
  end
 ##############################################################################
  # Bulk Edit of Multiple Comments
  # Test multiple select warnings
  # Test with Warning Listing For a File Page
  ##############################################################################

  ## Test: Select warnings by clicking checkbox
  ## + Reviewer logged in.
  ## + Subtask is analyzed and unpublicized.
  ## + Test with "Warning Listing For a File" page
  #
  # No warning is selected
  # Check at unchecked checkbox
  #
  def test_it_bec10a_t4_070
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = []
    ## call store selected warning function
    get :store_selected_warning,:warning_id => UNCHECKED,
                                :p1         => WARNING_LISTING_FILE,
                                :selected   => "true"
    ## test condition
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"].size, 1
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"], [UNCHECKED]
  end
  # Some warnings are selected
  # Check at unchecked checkbox
  #
  def test_it_bec10a_t4_071
    ## login
    login_as REVIEWER_login
    ## initiallize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    ## call function
    get :store_selected_warning,:warning_id => UNCHECKED,
                                :p1         => WARNING_LISTING_FILE,
                                :selected   => "true"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"].size - 1, SAVED_WARNING.size
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"], SAVED_WARNING + [UNCHECKED]
  end
  # Some warnings are selected
  # Check at checked checkbox
  #
  def test_it_bec10a_t4_072
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    ## call function
    get :store_selected_warning,:warning_id => CHECKED,
                                :p1         => WARNING_LISTING_FILE,
                                :selected   => "false"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"].size + 1, SAVED_WARNING.size
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"], SAVED_WARNING - [CHECKED]
  end
  # No warning is selected
  # Check at unchecked checkbox
  # Again check at this checkbox
  #
  def test_it_bec10a_t4_073
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = []
    ## call function
    get :store_selected_warning,:warning_id => UNCHECKED,
                                :p1         => WARNING_LISTING_FILE,
                                :selected   => "true"
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"].size, 1
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"], [UNCHECKED]
    get :store_selected_warning,:warning_id => UNCHECKED,
                                :p1         => WARNING_LISTING_FILE,
                                :selected   => "false"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"].size, 0
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"], []
  end
  ## Test: Unselect all warnings
  ## + Reviewer logged in.
  ## + Subtask is analyzed and unpublicized.
  ## + Test with "Warning Listing For a File" page
  #
  # No warning is selected
  # Call Uncheck All
  #
  def test_it_bec10a_t4_074
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = []
    ## call function
    get :clear_all_checks, :pu  => SELECTED_PU,
                           :pj  => SELECTED_PJ,
                           :id  => SELECTED_TASK,
                           :sub_id  =>  SELECTED_SUBTASK,
                           :p1=> WARNING_LISTING_FILE,
                           :result_id =>  SELECTED_RESULT
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"].size, 0
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"], []
  end
  # Some warnings are selected
  # Call Uncheck All
  #
  def test_it_bec10a_t4_075
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    ## call function
    get :clear_all_checks, :pu  => SELECTED_PU,
                           :pj  => SELECTED_PJ,
                           :id  => SELECTED_TASK,
                           :sub_id  =>  SELECTED_SUBTASK,
                           :p1=> WARNING_LISTING_FILE,
                           :result_id =>  SELECTED_RESULT
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"].size, 0
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"], []
  end
  ## Test: Select all warnings
  ## + Reviewer logged in.
  ## + Subtask is analyzed and unpublicized.
  ## + Test with "Warning Listing For a File" page
  #
  # No warning is selected
  # Call Check All
  #
  def test_it_bec10a_t4_076
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id  =>  SELECTED_SUBTASK,
                             :p1=> WARNING_LISTING_FILE,
                             :result_id =>  SELECTED_RESULT
    ## get all warnings belong to the conditions
    all_warnings = Warning.find_all_by_result_id(  SELECTED_RESULT,
                                                   nil,
                                                   nil,
                                                   nil,
                                                   nil,
                                                   false,
                                                   false)
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"].size, all_warnings.size
  end
  # Some warnings are selected
  # Call Check All
  #
  def test_it_bec10a_t4_077
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id  =>  SELECTED_SUBTASK,
                             :p1      => WARNING_LISTING_FILE,
                             :result_id =>  SELECTED_RESULT
    ## get all warnings belong to the conditions
    all_warnings = Warning.find_all_by_result_id(  SELECTED_RESULT,
                                                   nil,
                                                   nil,
                                                   nil,
                                                   nil,
                                                   false,
                                                   false)
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"].size, all_warnings.size
  end
  # No warning is selected
  # Filter with warnings.rule = 0240
  # Call Check All
  #
  def test_it_bec10a_t4_078
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id          =>  SELECTED_SUBTASK,
                             :p1              => WARNING_LISTING_FILE,
                             :filter_field    => "warnings.rule",
                             :filter_keyword  =>  "0240",
                             :result_id =>  SELECTED_RESULT
    ## get all warnings belong to the conditions
    all_warnings = Warning.find_all_by_result_id(  SELECTED_RESULT,
                                                   nil,
                                                   nil,
                                                   "warnings.rule",
                                                   "0240",
                                                   false,
                                                   false)
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"].size, all_warnings.size
  end
  # No warning is selected
  # Filter with wrong warnings.rule = 0000
  # Call Check All
  #
  def test_it_bec10a_t4_079
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id          =>  SELECTED_SUBTASK,
                             :p1              => WARNING_LISTING_FILE,
                             :filter_field    => "warnings.rule",
                             :filter_keyword  =>  "0000",
                             :result_id =>  SELECTED_RESULT
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"].size, 0
  end
  # Test reset session when Search function is called.
  #
  def test_it_bec10a_t4_080
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = []
    ## call function
    get :view_warning_list,  :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id          =>  SELECTED_SUBTASK,
                             :p1              => WARNING_LISTING_FILE,
                             :filter_field    => "warnings.source_path",
                             :filter_keyword  =>  "sample_c/src",
                           :result_id =>  SELECTED_RESULT

    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"].size, 0
  end
  ## Test: Select warnings by clicking checkbox & Check All & Uncheck All function
  ## + PJ member logged in.
  ## + Subtask is analyzed and unpublicized.
  ## + Test with "Warning Listing For a File" page
  #
  # No warning is selected
  # Check at unchecked checkbox
  #
  def test_it_bec10a_t4_081
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = []
    ## call store selected warning function
    get :store_selected_warning,:warning_id => UNCHECKED,
                                :p1         => WARNING_LISTING_FILE,
                                :selected   => "true"
    ## test condition
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"].size, 0
  end
  # Some warnings are selected
  # Check at checked checkbox
  #
  def test_it_bec10a_t4_082
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    ## call function
    get :store_selected_warning,:warning_id => CHECKED,
                                :p1         => WARNING_LISTING_FILE,
                                :selected   => "false"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"].size, SAVED_WARNING.size
  end
  # Some warnings are selected
  # Call Uncheck All
  #
  def test_it_bec10a_t4_083
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    ## call function
    get :clear_all_checks, :pu  => SELECTED_PU,
                           :pj  => SELECTED_PJ,
                           :id  => SELECTED_TASK,
                           :sub_id  =>  SELECTED_SUBTASK,
                           :p1=> WARNING_LISTING_FILE,
                           :result_id =>  SELECTED_RESULT
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"].size, SAVED_WARNING.size
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"], SAVED_WARNING
  end
# No warning is selected
  # Call Check All
  #
  def test_it_bec10a_t4_084
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id  =>  SELECTED_SUBTASK,
                             :p1=> WARNING_LISTING_FILE,
                           :result_id =>  SELECTED_RESULT
    ## test conditions
    assert_equal @response.session["selected_warnings_#{WARNING_LISTING_FILE}"].size, 0
  end
 ##############################################################################
  # Bulk Edit of Multiple Comments
  # Test multiple select warnings
  # Test with Comment Listing For a File Page
  ##############################################################################

  ## Test: Select warnings by clicking checkbox
  ## + Reviewer logged in.
  ## + Subtask is analyzed and unpublicized.
  ## + Test with "Comment Listing For a File" page
  #
  # No warning is selected
  # Check at unchecked checkbox
  #
  def test_it_bec10a_t4_085
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = []
    ## call store selected warning function
    get :store_selected_warning,:warning_id => UNCHECKED,
                                :p1         => COMMENT_LISTING_FILE,
                                :selected   => "true"
    ## test condition
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"].size, 1
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"], [UNCHECKED]
  end
  # Some warnings are selected
  # Check at unchecked checkbox
  #
  def test_it_bec10a_t4_086
    ## login
    login_as REVIEWER_login
    ## initiallize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
    end
    ## call function
    get :store_selected_warning,:warning_id => UNCHECKED,
                                :p1         => COMMENT_LISTING_FILE,
                                :selected   => "true"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"].size - 1, SAVED_WARNING.size
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"], SAVED_WARNING + [UNCHECKED]
  end
  # Some warnings are selected
  # Check at checked checkbox
  #
  def test_it_bec10a_t4_087
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
    end
    ## call function
    get :store_selected_warning,:warning_id => CHECKED,
                                :p1         => COMMENT_LISTING_FILE,
                                :selected   => "false"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"].size + 1, SAVED_WARNING.size
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"], SAVED_WARNING - [CHECKED]
  end
  # No warning is selected
  # Check at unchecked checkbox
  # Again check at this checkbox
  #
  def test_it_bec10a_t4_088
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = []
    ## call function
    get :store_selected_warning,:warning_id => UNCHECKED,
                                :p1         => COMMENT_LISTING_FILE,
                                :selected   => "true"
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"].size, 1
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"], [UNCHECKED]
    get :store_selected_warning,:warning_id => UNCHECKED,
                                :p1         => COMMENT_LISTING_FILE,
                                :selected   => "false"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"].size, 0
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"], []
  end
  ## Test: Unselect all warnings
  ## + Reviewer logged in.
  ## + Subtask is analyzed and unpublicized.
  ## + Test with "Comment Listing For a File" page
  #
  # No warning is selected
  # Call Uncheck All
  #
  def test_it_bec10a_t4_089
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = []
    ## call function
    get :clear_all_checks, :pu  => SELECTED_PU,
                           :pj  => SELECTED_PJ,
                           :id  => SELECTED_TASK,
                           :sub_id  =>  SELECTED_SUBTASK,
                           :p1=> COMMENT_LISTING_FILE,
                           :result_id =>  SELECTED_RESULT
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"].size, 0
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"], []
  end
  # Some warnings are selected
  # Call Uncheck All
  #
  def test_it_bec10a_t4_090
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
    end
    ## call function
    get :clear_all_checks, :pu  => SELECTED_PU,
                           :pj  => SELECTED_PJ,
                           :id  => SELECTED_TASK,
                           :sub_id  =>  SELECTED_SUBTASK,
                           :p1=> COMMENT_LISTING_FILE,
                           :result_id =>  SELECTED_RESULT
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"].size, 0
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"], []
  end
  ## Test: Select all warnings
  ## + Reviewer logged in.
  ## + Subtask is analyzed and unpublicized.
  ## + Test with "Comment Listing For a File" page
  #
  # No warning is selected
  # Call Check All
  #
  def test_it_bec10a_t4_091
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id  =>  SELECTED_SUBTASK,
                             :p1=> COMMENT_LISTING_FILE,
                           :result_id =>  SELECTED_RESULT
    ## get all warnings belong to the conditions
    all_warnings = Warning.find_all_by_result_id(  SELECTED_RESULT,
                                                   nil,
                                                   nil,
                                                   nil,
                                                   nil,
                                                   false,
                                                   false)
    commented_warnings = Array.new
    all_warnings.each do |warning|
      if Comment.find_by_warning_id(warning.id)
        commented_warnings << warning
      end
    end
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"].size, commented_warnings.size
  end
  # Some warnings are selected
  # Call Check All
  #
  def test_it_bec10a_t4_092
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
    end
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id  =>  SELECTED_SUBTASK,
                             :p1      => COMMENT_LISTING_FILE,
                           :result_id =>  SELECTED_RESULT
    ## get all warnings belong to the conditions
    all_warnings = Warning.find_all_by_result_id(  SELECTED_RESULT,
                                                   nil,
                                                   nil,
                                                   nil,
                                                   nil,
                                                   false,
                                                   false)
    commented_warnings = Array.new
    all_warnings.each do |warning|
      if Comment.find_by_warning_id(warning.id)
        commented_warnings << warning
      end
    end
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"].size, commented_warnings.size
  end
  # No warning is selected
  # Filter with warnings.rule = 0240
  # Call Check All
  #
  def test_it_bec10a_t4_093
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id          =>  SELECTED_SUBTASK,
                             :p1              => COMMENT_LISTING_FILE,
                             :filter_field    => "warnings.rule",
                             :filter_keyword  =>  "0240",
                           :result_id =>  SELECTED_RESULT
    ## get all warnings belong to the conditions
    all_warnings = Warning.find_all_by_result_id(  SELECTED_RESULT,
                                                   nil,
                                                   nil,
                                                   "warnings.rule",
                                                   "0240",
                                                   false,
                                                   false) 
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"].size, all_warnings.size
  end
  # No warning is selected
  # Filter with wrong warnings.rule = 0000
  # Call Check All
  #
  def test_it_bec10a_t4_094
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id          =>  SELECTED_SUBTASK,
                             :p1              => COMMENT_LISTING_FILE,
                             :filter_field    => "warnings.rule",
                             :filter_keyword  =>  "0000",
                             :result_id =>  SELECTED_RESULT
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"].size, 0
  end
  # Test reset session when Search function is called.
  #
  def test_it_bec10a_t4_095
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = []
    ## call function
    get :view_warning_list,  :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id          =>  SELECTED_SUBTASK,
                             :p1              => COMMENT_LISTING_FILE,
                             :filter_field    => "warnings.source_path",
                             :filter_keyword  =>  "sample_c/src",
                           :result_id =>  SELECTED_RESULT
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"].size, 0
  end
  ## Test: Select warnings by clicking checkbox & Check All & Uncheck All function
  ## + PJ member logged in.
  ## + Subtask is analyzed and unpublicized.
  ## + Test with "Comment Listing For a File" page
  #
  # No warning is selected
  # Check at unchecked checkbox
  #
  def test_it_bec10a_t4_096
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = []
    ## call store selected warning function
    get :store_selected_warning,:warning_id => UNCHECKED,
                                :p1         => COMMENT_LISTING_FILE,
                                :selected   => "true"
    ## test condition
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"].size, 0
  end
  # Some warnings are selected
  # Check at checked checkbox
  #
  def test_it_bec10a_t4_097
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
    end
    ## call function
    get :store_selected_warning,:warning_id => CHECKED,
                                :p1         => COMMENT_LISTING_FILE,
                                :selected   => "false"
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"].size, SAVED_WARNING.size
  end
  # Some warnings are selected
  # Call Uncheck All
  #
  def test_it_bec10a_t4_098
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
    end
    ## call function
    get :clear_all_checks, :pu  => SELECTED_PU,
                           :pj  => SELECTED_PJ,
                           :id  => SELECTED_TASK,
                           :sub_id  =>  SELECTED_SUBTASK,
                           :p1=> COMMENT_LISTING_FILE,
                           :result_id =>  SELECTED_RESULT
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"].size, SAVED_WARNING.size
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"], SAVED_WARNING
  end
# No warning is selected
  # Call Check All
  #
  def test_it_bec10a_t4_099
    ## initialize
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = []
    ## call function
    get :check_all_warnings, :pu  => SELECTED_PU,
                             :pj  => SELECTED_PJ,
                             :id  => SELECTED_TASK,
                             :sub_id  =>  SELECTED_SUBTASK,
                             :p1=> COMMENT_LISTING_FILE,
                             :result_id =>  SELECTED_RESULT
    ## test conditions
    assert_equal @response.session["selected_warnings_#{COMMENT_LISTING_FILE}"].size, 0
  end
  ##############################################################################
  # Bulk Edit of Multiple Comments
  # Test Bulk Update Risk Type of Multiple Comments
  # Test with Warning Listing page
  ##############################################################################
  ## Test: Comment Risk Type is Updated Successful
  ## + Reviewer logged in.
  ## + Subtask is analyzed and unpublicized.
  #
  # Some warnings are selected
  # All selected warnings do not have comment
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_100
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    WARNING_NO_COMMENT.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => WARNING_NO_COMMENT,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING,
                                  :status   =>  SELECTED_RISK_TYPE
      ## test condition
      WARNING_NO_COMMENT.each do |warning_id|
        comment = Comment.find_by_warning_id(warning_id)
        assert_equal comment.status, 1 ## saved.
        assert_equal comment.risk_type_id, SELECTED_RISK_TYPE ## risk type id
        assert_equal comment.warning_description, "" ## warning description
        assert_equal comment.sample_source_code, "" ## sample source code
      end
    rescue Exception => e
    end
    ## delete the registered comment.
    WARNING_NO_COMMENT.each do |warning_id|
      Comment.delete_all(:warning_id => warning_id)
    end
  end
  # Some warnings are selected
  # All selected warnings have temporary saved comment
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_101
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    TEMPORARY_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => TEMPORARY_WARNING,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING,
                                  :status   =>  SELECTED_RISK_TYPE
      ## test condition
      TEMPORARY_WARNING.each do |warning_id|
        comment = Comment.find_by_warning_id(warning_id)
        assert_equal comment.status, 1 ## saved.
        assert_equal comment.risk_type_id, SELECTED_RISK_TYPE ## risk type id
        assert_equal comment.warning_description, WARNING_DESCRIPTION ## warning description
        assert_equal comment.sample_source_code, SAMPLE_SOURCE_CODE ## sample source code
      end
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # All selected warnings have saved comment
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_102
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => SAVED_WARNING,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING,
                                  :status   =>  SELECTED_RISK_TYPE
      ## test condition
      SAVED_WARNING.each do |warning_id|
        comment = Comment.find_by_warning_id(warning_id)
        assert_equal comment.status, 1 ## saved.
        assert_equal comment.risk_type_id, SELECTED_RISK_TYPE ## risk type id
        assert_equal comment.warning_description, WARNING_DESCRIPTION ## warning description
        assert_equal comment.sample_source_code, SAMPLE_SOURCE_CODE ## sample source code
      end
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # All selected warnings have saved comment, some are temporary saved, some do no have comment
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_103
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    warning_list = Array.new
    #
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
      warning_list << warning_id
    end
    #
    WARNING_NO_COMMENT.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
      warning_list << warning_id
    end
    #
    TEMPORARY_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
      warning_list << warning_id
    end
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => warning_list,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING,
                                  :status   =>  SELECTED_RISK_TYPE
      ## test condition
      SAVED_WARNING.each do |warning_id|
        comment = Comment.find_by_warning_id(warning_id)
        assert_equal comment.status, 1 ## saved.
        assert_equal comment.risk_type_id, SELECTED_RISK_TYPE ## risk type id
        assert_equal comment.warning_description, WARNING_DESCRIPTION ## warning description
        assert_equal comment.sample_source_code, SAMPLE_SOURCE_CODE ## sample source code
      end
      #
      TEMPORARY_WARNING.each do |warning_id|
        comment = Comment.find_by_warning_id(warning_id)
        assert_equal comment.status, 1 ## saved.
        assert_equal comment.risk_type_id, SELECTED_RISK_TYPE ## risk type id
        assert_equal comment.warning_description, WARNING_DESCRIPTION ## warning description
        assert_equal comment.sample_source_code, SAMPLE_SOURCE_CODE ## sample source code
      end
      #
      WARNING_NO_COMMENT.each do |warning_id|
        comment = Comment.find_by_warning_id(warning_id)
        assert_equal comment.status, 1 ## saved.
        assert_equal comment.risk_type_id, SELECTED_RISK_TYPE ## risk type id
        assert_equal comment.warning_description, "" ## warning description
        assert_equal comment.sample_source_code, "" ## sample source code
      end
    rescue Exception => e
    end
    ## delete the registered comment.
    WARNING_NO_COMMENT.each do |warning_id|
      Comment.delete_all(:warning_id => warning_id)
    end
  end
  # No warning is selected
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_104
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING,
                                  :status   =>  SELECTED_RISK_TYPE
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments, new_comments
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # All selected warnings have saved comment
  # PJ member logged in
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_105
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => SAVED_WARNING,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING,
                                  :status   =>  SELECTED_RISK_TYPE
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments,new_comments
    rescue Exception => e
    end
  end
  ##############################################################################
  # Bulk Edit of Multiple Comments
  # Test Bulk Update Risk Type of Multiple Comments
  # Test with Comment Listing page
  ##############################################################################
  ## Test: Comment Risk Type is Updated Successful
  ## + Reviewer logged in.
  ## + Subtask is analyzed and unpublicized.
  #
  # Some warnings are selected
  # All selected warnings have temporary saved comment
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_106
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
    TEMPORARY_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
    end
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => TEMPORARY_WARNING,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  COMMENT_LISTING,
                                  :status   =>  SELECTED_RISK_TYPE
      ## test condition
      TEMPORARY_WARNING.each do |warning_id|
        comment = Comment.find_by_warning_id(warning_id)
        assert_equal comment.status, 1 ## saved.
        assert_equal comment.risk_type_id, SELECTED_RISK_TYPE ## risk type id
        assert_equal comment.warning_description, WARNING_DESCRIPTION ## warning description
        assert_equal comment.sample_source_code, SAMPLE_SOURCE_CODE ## sample source code
      end
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # All selected warnings have saved comment
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_107
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
    end
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => SAVED_WARNING,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  COMMENT_LISTING,
                                  :status   =>  SELECTED_RISK_TYPE
      ## test condition
      SAVED_WARNING.each do |warning_id|
        comment = Comment.find_by_warning_id(warning_id)
        assert_equal comment.status, 1 ## saved.
        assert_equal comment.risk_type_id, SELECTED_RISK_TYPE ## risk type id
        assert_equal comment.warning_description, WARNING_DESCRIPTION ## warning description
        assert_equal comment.sample_source_code, SAMPLE_SOURCE_CODE ## sample source code
      end
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # All selected warnings have saved comment, some are temporary saved, some do no have comment
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_108
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
    warning_list = Array.new
    #
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
      warning_list << warning_id
    end
    #
    TEMPORARY_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
      warning_list << warning_id
    end
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => warning_list,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  COMMENT_LISTING,
                                  :status   =>  SELECTED_RISK_TYPE
      ## test condition
      SAVED_WARNING.each do |warning_id|
        comment = Comment.find_by_warning_id(warning_id)
        assert_equal comment.status, 1 ## saved.
        assert_equal comment.risk_type_id, SELECTED_RISK_TYPE ## risk type id
        assert_equal comment.warning_description, WARNING_DESCRIPTION ## warning description
        assert_equal comment.sample_source_code, SAMPLE_SOURCE_CODE ## sample source code
      end
      #
      TEMPORARY_WARNING.each do |warning_id|
        comment = Comment.find_by_warning_id(warning_id)
        assert_equal comment.status, 1 ## saved.
        assert_equal comment.risk_type_id, SELECTED_RISK_TYPE ## risk type id
        assert_equal comment.warning_description, WARNING_DESCRIPTION ## warning description
        assert_equal comment.sample_source_code, SAMPLE_SOURCE_CODE ## sample source code
      end
    rescue Exception => e
    end
  end
  # No warning is selected
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_109
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  COMMENT_LISTING,
                                  :status   =>  SELECTED_RISK_TYPE
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments, new_comments
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # All selected warnings have saved comment
  # PJ member logged in
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_110
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
    end
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => SAVED_WARNING,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  COMMENT_LISTING,
                                  :status   =>  SELECTED_RISK_TYPE
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments,new_comments
    rescue Exception => e
    end
  end
  ##############################################################################
  # Bulk Edit of Multiple Comments
  # Test Bulk Update Risk Type of Multiple Comments
  # Test with Warning Listing For a File page
  ##############################################################################
  ## Test: Comment Risk Type is Updated Successful
  ## + Reviewer logged in.
  ## + Subtask is analyzed and unpublicized.
  #
  # Some warnings are selected
  # All selected warnings do not have comment
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_111
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
    WARNING_NO_COMMENT.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => WARNING_NO_COMMENT,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING_FILE,
                                  :status   =>  SELECTED_RISK_TYPE,
                                  :result_id  => SELECTED_RESULT
      ## test condition
      WARNING_NO_COMMENT.each do |warning_id|
        comment = Comment.find_by_warning_id(warning_id)
        assert_equal comment.status, 1 ## saved.
        assert_equal comment.risk_type_id, SELECTED_RISK_TYPE ## risk type id
        assert_equal comment.warning_description, "" ## warning description
        assert_equal comment.sample_source_code, "" ## sample source code
      end
    rescue Exception => e
    end
    ## delete the registered comment.
    WARNING_NO_COMMENT.each do |warning_id|
      Comment.delete_all(:warning_id => warning_id)
    end
  end
  # Some warnings are selected
  # All selected warnings have temporary saved comment
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_112
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
    TEMPORARY_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => TEMPORARY_WARNING,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING_FILE,
                                  :status   =>  SELECTED_RISK_TYPE,
                                  :result_id  => SELECTED_RESULT
      ## test condition
      TEMPORARY_WARNING.each do |warning_id|
        comment = Comment.find_by_warning_id(warning_id)
        assert_equal comment.status, 1 ## saved.
        assert_equal comment.risk_type_id, SELECTED_RISK_TYPE ## risk type id
        assert_equal comment.warning_description, WARNING_DESCRIPTION ## warning description
        assert_equal comment.sample_source_code, SAMPLE_SOURCE_CODE ## sample source code
      end
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # All selected warnings have saved comment
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_113
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => SAVED_WARNING,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING_FILE,
                                  :status   =>  SELECTED_RISK_TYPE,
                                  :result_id  => SELECTED_RESULT
      ## test condition
      SAVED_WARNING.each do |warning_id|
        comment = Comment.find_by_warning_id(warning_id)
        assert_equal comment.status, 1 ## saved.
        assert_equal comment.risk_type_id, SELECTED_RISK_TYPE ## risk type id
        assert_equal comment.warning_description, WARNING_DESCRIPTION ## warning description
        assert_equal comment.sample_source_code, SAMPLE_SOURCE_CODE ## sample source code
      end
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # All selected warnings have saved comment, some are temporary saved, some do no have comment
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_114
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
    warning_list = Array.new
    #
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
      warning_list << warning_id
    end
    #
    WARNING_NO_COMMENT.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
      warning_list << warning_id
    end
    #
    TEMPORARY_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
      warning_list << warning_id
    end
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => warning_list,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING_FILE,
                                  :status   =>  SELECTED_RISK_TYPE,
                                  :result_id  => SELECTED_RESULT
      ## test condition
      SAVED_WARNING.each do |warning_id|
        comment = Comment.find_by_warning_id(warning_id)
        assert_equal comment.status, 1 ## saved.
        assert_equal comment.risk_type_id, SELECTED_RISK_TYPE ## risk type id
        assert_equal comment.warning_description, WARNING_DESCRIPTION ## warning description
        assert_equal comment.sample_source_code, SAMPLE_SOURCE_CODE ## sample source code
      end
      #
      TEMPORARY_WARNING.each do |warning_id|
        comment = Comment.find_by_warning_id(warning_id)
        assert_equal comment.status, 1 ## saved.
        assert_equal comment.risk_type_id, SELECTED_RISK_TYPE ## risk type id
        assert_equal comment.warning_description, WARNING_DESCRIPTION ## warning description
        assert_equal comment.sample_source_code, SAMPLE_SOURCE_CODE ## sample source code
      end
      #
      WARNING_NO_COMMENT.each do |warning_id|
        comment = Comment.find_by_warning_id(warning_id)
        assert_equal comment.status, 1 ## saved.
        assert_equal comment.risk_type_id, SELECTED_RISK_TYPE ## risk type id
        assert_equal comment.warning_description, "" ## warning description
        assert_equal comment.sample_source_code, "" ## sample source code
      end
    rescue Exception => e
    end
    ## delete the registered comment.
    WARNING_NO_COMMENT.each do |warning_id|
      Comment.delete_all(:warning_id => warning_id)
    end
  end
  # No warning is selected
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_115
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING_FILE,
                                  :status   =>  SELECTED_RISK_TYPE,
                                  :result_id  => SELECTED_RESULT
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments, new_comments
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # All selected warnings have saved comment
  # PJ member logged in
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_116
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => SAVED_WARNING,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING_FILE,
                                  :status   =>  SELECTED_RISK_TYPE,
                                  :result_id  => SELECTED_RESULT
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments,new_comments
    rescue Exception => e
    end
  end
  ##############################################################################
  # Bulk Edit of Multiple Comments
  # Test Bulk Update Risk Type of Multiple Comments
  # Test with Comment Listing For a File page
  ##############################################################################
  ## Test: Comment Risk Type is Updated Successful
  ## + Reviewer logged in.
  ## + Subtask is analyzed and unpublicized.
  #
  # Some warnings are selected
  # All selected warnings have temporary saved comment
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_117
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
    TEMPORARY_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
    end
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => TEMPORARY_WARNING,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  COMMENT_LISTING_FILE,
                                  :status   =>  SELECTED_RISK_TYPE,
                                  :result_id  => SELECTED_RESULT
      ## test condition
      TEMPORARY_WARNING.each do |warning_id|
        comment = Comment.find_by_warning_id(warning_id)
        assert_equal comment.status, 1 ## saved.
        assert_equal comment.risk_type_id, SELECTED_RISK_TYPE ## risk type id
        assert_equal comment.warning_description, WARNING_DESCRIPTION ## warning description
        assert_equal comment.sample_source_code, SAMPLE_SOURCE_CODE ## sample source code
      end
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # All selected warnings have saved comment
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_118
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
    end
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => SAVED_WARNING,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  COMMENT_LISTING_FILE,
                                  :status   =>  SELECTED_RISK_TYPE,
                                  :result_id  => SELECTED_RESULT
      ## test condition
      SAVED_WARNING.each do |warning_id|
        comment = Comment.find_by_warning_id(warning_id)
        assert_equal comment.status, 1 ## saved.
        assert_equal comment.risk_type_id, SELECTED_RISK_TYPE ## risk type id
        assert_equal comment.warning_description, WARNING_DESCRIPTION ## warning description
        assert_equal comment.sample_source_code, SAMPLE_SOURCE_CODE ## sample source code
      end
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # All selected warnings have saved comment, some are temporary saved, some do no have comment
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_119
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
    warning_list = Array.new
    #
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
      warning_list << warning_id
    end
    #
    TEMPORARY_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
      warning_list << warning_id
    end
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => warning_list,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  COMMENT_LISTING_FILE,
                                  :status   =>  SELECTED_RISK_TYPE,
                                  :result_id  => SELECTED_RESULT
      ## test condition
      SAVED_WARNING.each do |warning_id|
        comment = Comment.find_by_warning_id(warning_id)
        assert_equal comment.status, 1 ## saved.
        assert_equal comment.risk_type_id, SELECTED_RISK_TYPE ## risk type id
        assert_equal comment.warning_description, WARNING_DESCRIPTION ## warning description
        assert_equal comment.sample_source_code, SAMPLE_SOURCE_CODE ## sample source code
      end
      #
      TEMPORARY_WARNING.each do |warning_id|
        comment = Comment.find_by_warning_id(warning_id)
        assert_equal comment.status, 1 ## saved.
        assert_equal comment.risk_type_id, SELECTED_RISK_TYPE ## risk type id
        assert_equal comment.warning_description, WARNING_DESCRIPTION ## warning description
        assert_equal comment.sample_source_code, SAMPLE_SOURCE_CODE ## sample source code
      end
    rescue Exception => e
    end
  end
  # No warning is selected
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_120
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  COMMENT_LISTING_FILE,
                                  :status   =>  SELECTED_RISK_TYPE,
                                  :result_id  => SELECTED_RESULT
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments, new_comments
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # All selected warnings have saved comment
  # PJ member logged in
  # Call bulk update risk type status
  #
  def test_it_bec10a_t4_121
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
    end
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_set_action_status,:warning_id => SAVED_WARNING,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  COMMENT_LISTING_FILE,
                                  :status   =>  SELECTED_RISK_TYPE,
                                  :result_id  => SELECTED_RESULT
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments,new_comments
    rescue Exception => e
    end
  end
  ##############################################################################
  # Bulk Edit of Multiple Comments
  # Test Bulk Delete Comments
  # Test with Warning Listing page
  ##############################################################################
  ## Test: Bulk Delete Comments Successful
  ## + Reviewer logged in.
  ## + Subtask is analyzed and unpublicized.
  #
  # No warning is selected
  # Call bulk delete comments
  #
  def test_it_bec10a_t4_122
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_delete_comments,  :warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING,
                                  :status   =>  SELECTED_RISK_TYPE
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments, new_comments
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # Those comments are saved
  # Call bulk delete comments
  #
  def test_it_bec10a_t4_123
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_delete_comments,  :warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING,
                                  :status   =>  SELECTED_RISK_TYPE
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments.size, new_comments.size + SAVED_WARNING.size
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # Those comments are temporary saved
  # Call bulk delete comments
  #
  def test_it_bec10a_t4_124
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    TEMPORARY_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_delete_comments,  :warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING,
                                  :status   =>  SELECTED_RISK_TYPE
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments.size, new_comments.size + TEMPORARY_WARNING.size
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # Those comments are saved, temporary saved but some do not have comment
  # Call bulk delete comments
  #
  def test_it_bec10a_t4_125
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    TEMPORARY_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    WARNING_NO_COMMENT.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_delete_comments,  :warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING,
                                  :status   =>  SELECTED_RISK_TYPE
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments.size, new_comments.size + TEMPORARY_WARNING.size + SAVED_WARNING.size
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # PJ member logged in
  # Call bulk delete comments
  #
  def test_it_bec10a_t4_126
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING}"] << warning_id
    end
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_delete_comments,  :warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING,
                                  :status   =>  SELECTED_RISK_TYPE
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments.size, new_comments.size
    rescue Exception => e
    end
  end
  ##############################################################################
  # Bulk Edit of Multiple Comments
  # Test Bulk Delete Comments
  # Test with Comment Listing page
  ##############################################################################
  ## Test: Bulk Delete Comments Successful
  ## + Reviewer logged in.
  ## + Subtask is analyzed and unpublicized.
  #
  # No warning is selected
  # Call bulk delete comments
  #
  def test_it_bec10a_t4_127
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_delete_comments,  :warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  COMMENT_LISTING,
                                  :status   =>  SELECTED_RISK_TYPE
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments, new_comments
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # Those comments are saved
  # Call bulk delete comments
  #
  def test_it_bec10a_t4_128
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
    end
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_delete_comments,  :warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  COMMENT_LISTING,
                                  :status   =>  SELECTED_RISK_TYPE
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments.size, new_comments.size + SAVED_WARNING.size
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # Those comments are temporary saved
  # Call bulk delete comments
  #
  def test_it_bec10a_t4_129
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
    TEMPORARY_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
    end
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_delete_comments,  :warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  COMMENT_LISTING,
                                  :status   =>  SELECTED_RISK_TYPE
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments.size, new_comments.size + TEMPORARY_WARNING.size
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # Those comments are saved, temporary saved
  # Call bulk delete comments
  #
  def test_it_bec10a_t4_130
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
    end
    TEMPORARY_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
    end
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_delete_comments,  :warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  COMMENT_LISTING,
                                  :status   =>  SELECTED_RISK_TYPE
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments.size, new_comments.size + TEMPORARY_WARNING.size + SAVED_WARNING.size
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # PJ member logged in
  # Call bulk delete comments
  #
  def test_it_bec10a_t4_131
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING}"] << warning_id
    end
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_delete_comments,  :warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  COMMENT_LISTING,
                                  :status   =>  SELECTED_RISK_TYPE
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments.size, new_comments.size
    rescue Exception => e
    end
  end
  ##############################################################################
  # Bulk Edit of Multiple Comments
  # Test Bulk Delete Comments
  # Test with Warning Listing For a File page
  ##############################################################################
  ## Test: Bulk Delete Comments Successful
  ## + Reviewer logged in.
  ## + Subtask is analyzed and unpublicized.
  #
  # No warning is selected
  # Call bulk delete comments
  #
  def test_it_bec10a_t4_132
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_delete_comments,  :warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING_FILE,
                                  :status   =>  SELECTED_RISK_TYPE,
                                  :result_id  => SELECTED_RESULT
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments, new_comments
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # Those comments are saved
  # Call bulk delete comments
  #
  def test_it_bec10a_t4_133
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_delete_comments,  :warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING_FILE,
                                  :status   =>  SELECTED_RISK_TYPE,
                                  :result_id  => SELECTED_RESULT
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments.size, new_comments.size + SAVED_WARNING.size
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # Those comments are temporary saved
  # Call bulk delete comments
  #
  def test_it_bec10a_t4_134
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
    TEMPORARY_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_delete_comments,  :warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING_FILE,
                                  :status   =>  SELECTED_RISK_TYPE,
                                  :result_id  => SELECTED_RESULT
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments.size, new_comments.size + TEMPORARY_WARNING.size
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # Those comments are saved, temporary saved but some do not have comment
  # Call bulk delete comments
  #
  def test_it_bec10a_t4_135
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    TEMPORARY_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    WARNING_NO_COMMENT.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_delete_comments,  :warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING_FILE,
                                  :status   =>  SELECTED_RISK_TYPE,
                                  :result_id  => SELECTED_RESULT
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments.size, new_comments.size + TEMPORARY_WARNING.size + SAVED_WARNING.size
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # PJ member logged in
  # Call bulk delete comments
  #
  def test_it_bec10a_t4_136
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{WARNING_LISTING_FILE}"] << warning_id
    end
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_delete_comments,  :warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  WARNING_LISTING_FILE,
                                  :status   =>  SELECTED_RISK_TYPE,
                                  :result_id  => SELECTED_RESULT
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments.size, new_comments.size
    rescue Exception => e
    end
  end
  ##############################################################################
  # Bulk Edit of Multiple Comments
  # Test Bulk Delete Comments
  # Test with Comment Listing FOR a FILE page
  ##############################################################################
  ## Test: Bulk Delete Comments Successful
  ## + Reviewer logged in.
  ## + Subtask is analyzed and unpublicized.
  #
  # No warning is selected
  # Call bulk delete comments
  #
  def test_it_bec10a_t4_137
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_delete_comments,  :warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  COMMENT_LISTING_FILE,
                                  :status   =>  SELECTED_RISK_TYPE,
                                  :result_id  => SELECTED_RESULT
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments, new_comments
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # Those comments are saved
  # Call bulk delete comments
  #
  def test_it_bec10a_t4_138
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
    end
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_delete_comments,  :warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  COMMENT_LISTING_FILE,
                                  :status   =>  SELECTED_RISK_TYPE,
                                  :result_id  => SELECTED_RESULT
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments.size, new_comments.size + SAVED_WARNING.size
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # Those comments are temporary saved
  # Call bulk delete comments
  #
  def test_it_bec10a_t4_139
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
    TEMPORARY_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
    end
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_delete_comments,  :warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  COMMENT_LISTING_FILE,
                                  :status   =>  SELECTED_RISK_TYPE,
                                  :result_id  => SELECTED_RESULT
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments.size, new_comments.size + TEMPORARY_WARNING.size
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # Those comments are saved, temporary saved
  # Call bulk delete comments
  #
  def test_it_bec10a_t4_140
    ## login
    login_as REVIEWER_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
    end
    TEMPORARY_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
    end
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_delete_comments,  :warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  COMMENT_LISTING_FILE,
                                  :status   =>  SELECTED_RISK_TYPE,
                                  :result_id  => SELECTED_RESULT
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments.size, new_comments.size + TEMPORARY_WARNING.size + SAVED_WARNING.size
    rescue Exception => e
    end
  end
  # Some warnings are selected
  # PJ member logged in
  # Call bulk delete comments
  #
  def test_it_bec10a_t4_141
    ## login
    login_as PJ_login
    ## initialize session
    @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] = Array.new
    SAVED_WARNING.each do |warning_id|
      @request.session["selected_warnings_#{COMMENT_LISTING_FILE}"] << warning_id
    end
    old_comments = Comment.find(:all)
    ## call store selected warning function
    begin
      get :bulk_delete_comments,  :warning_id => nil,
                                  :pu  => SELECTED_PU,
                                  :pj  => SELECTED_PJ,
                                  :id  => SELECTED_TASK,
                                  :sub_id   =>  SELECTED_SUBTASK,
                                  :p1       =>  COMMENT_LISTING_FILE,
                                  :status   =>  SELECTED_RISK_TYPE,
                                  :result_id  => SELECTED_RESULT
      ## test condition
      new_comments = Comment.find(:all)
      assert_equal old_comments.size, new_comments.size
    rescue Exception => e
    end
  end
end

