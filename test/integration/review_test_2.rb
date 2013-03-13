require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/setup'
class ReviewTest < ActionController::IntegrationTest

  #  fixtures :source_codes
  #  fixtures :warnings
  #  fixtures :reviews
  
  Admin_login = "root"
  Admin_pass  = "root"

#  def setup
#    import_sql
#  end

  ## Test view_warning_list
  # + User not logged in.
  # + Request to view "warning listing page"
  #
  def test_it_rsf10a_t3_r3_001
    post url_for(:controller => "review", :action => "view_warning_list",
      :pu => 1,
      :pj => 1,
      :id => 3,
      :sub_id => 5
    )
    assert_redirected_to :controller => "auth", :action => "login"
  end

  # + User logged in.
  # + Request to view warning list
  def test_it_rsf10a_t3_r3_002
    login(Admin_login,Admin_pass)
    get URL_WARNING_LIST_PAGE
    assert_response :success
  end

  def test_it_rsf10a_t3_r3_003
		login(Admin_login,Admin_pass)
  	#Get Warning list button
		post URL_WARNING_LIST_PAGE
		assert_response :success
		#Display Warning list page
		get URL_WARNING_LIST_PAGE
		assert_response :success
		assert_select "div#pagetitle", _('Warning Listing Page')
    assert_select "input[type = 'button'][value = '#{_('Comment Listing')}']"
    assert_select "input[type = 'button'][value = '#{_('Download CSV Format')}']"
    assert_select "input[type = 'button'][value = '#{_('Upload CSV Format')}']"
    assert_select "select#search_field" do
      assert_select "option", _("Rule ID")
      assert_select "option", _("Directory")
      assert_select "option", _("File")
    end
    assert_select "input[type = 'text']"
    assert_select "input[type = 'button'][value = '#{_('Search')}']"
	end

	def test_it_rsf10a_t3_r3_014
		login(Admin_login,Admin_pass)		
		#AnzException.cpp.Critical.html warning list page
		xml_http_request :post, URL_REPORT_WARNING_LIST_PAGE
		assert_response :success
		get URL_REPORT_WARNING_LIST_PAGE
		assert_response :success

    assert_select "input[type = 'button'][value = '#{_('Download CSV Format')}']"
    assert_select "input[type = 'button'][value = '#{_('Upload CSV Format')}']"
    assert_select "select#search_field" do
      assert_select "option", _("Rule ID")
    end
    assert_select "input[type = 'text']"
    assert_select "input[type = 'button'][value = '#{_('Search')}']"

		#Get Comment listing page of file analyzyme.c.Critical.html
		post URL_REPORT_COMMENT_LIST_PAGE
		assert_response :success
	end

    #- Get comment listing button
    #- action: view_comment_list
    #- Request: comment listing page
    def test_it_rsf10a_t3_r3_004_021
		login(Admin_login,Admin_pass)
    post url_for(:controller => "review", :action => "view_warning_list",
      :pu => 1,
      :pj => 1,
      :id => 3,
      :sub_id => 5
    )
		assert_response :success
		#Get Comment List button
		xml_http_request :post, URL_COMMENT_LIST_PAGE
		assert_response :success
		#Display Comment list page
		get URL_COMMENT_LIST_PAGE
		assert_response :success
		assert_select "div#pagetitle", _('Comment Listing Page')
    assert_select "input[type = 'button'][value = '#{_('Warning Listing')}']"
    assert_select "input[type = 'button'][value = '#{_('Download CSV Format')}']"
    assert_select "input[type = 'button'][value = '#{_('Upload CSV Format')}']"
    assert_select "select#search_field" do
      assert_select "option", _("Rule ID")
      assert_select "option", _("Directory")
      assert_select "option", _("File")
    end
    assert_select "input[type = 'text']"
    assert_select "input[type = 'button'][value = '#{_('Search')}']"
	end

     # - Get download CSV format button
     # - Action: download_warning_list
     # - Request: download warning list
     # - Expected Output: - Download file warning list
     # - Get upload CSV format button
     # - Action: save_csv_to_db
     # - Request: upload CSV file to DB
     # -Expected Output: - Display Upload CSV file sub window
	def test_it_rsf10a_t3_r3_005_006_007
		login(Admin_login,Admin_pass)
		get URL_WARNING_LIST_PAGE
		assert_response :success
		#Get Download CSV button
		assert_select "input[type = 'button'][value = '#{_('Download CSV Format')}']"
    post URL_DOWNLOAD_CSV
    assert_response :success
		#Get Upload CSV button
		get URL_WARNING_LIST_PAGE
		assert_response :success
		assert_select 	"input[type = 'button'][value = '#{_('Upload CSV Format')}']"
    xml_http_request :post, URL_WARNING_UPLOAD_CSV
    assert_response  :success
    assert_template  "review/_upload_warning_list"
    assert_select  "input[type = 'submit'][value = '#{_('Upload')}']"
	end

  def test_it_rsf10a_t3_r3_008_to_013
		login(Admin_login,Admin_pass)
		#Search warnings: Rule Number = '0999'
		get URL_WARNING_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_WARNING_LIST_PAGE,
      :filter_field 		=> 'warnings.rule',
      :filter_keyword 	=> '0999'
		assert_response  :success

		#Search warnings: Directory = 'sample_cpp/src'
		get URL_WARNING_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_WARNING_LIST_PAGE,
      :filter_field 		=> "warnings.source_path",
      :filter_keyword 	=> "sample_c/src"
		assert_response  :success
		#Search warnings: Source name = 'Preprocessor.cpp'
		get URL_WARNING_LIST_PAGE
		assert_response	 :success
		post URL_SEARCH_WARNING_LIST_PAGE,
      :filter_field 		=> "warnings.source_name",
      :filter_keyword 	=> "Preprocessor.cpp"
		assert_response  :success

		#Search warnings: empty search field => display all warnings
		get URL_WARNING_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_WARNING_LIST_PAGE,
      :filter_keyword 	=> ""
		assert_response  :success

		#Search warnings: type * in search field => display all warnings
		get URL_WARNING_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_WARNING_LIST_PAGE,
      :filter_field 		=> "warnings.rule",
      :filter_keyword 	=> "*"
		assert_response  :success

		#Link to Analysis result report page in Table's File name column
		get URL_WARNING_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_WARNING_LIST_PAGE
		assert_response  :success
	end

	def test_it_rsf10a_t3_r3_015_to_016
		login(Admin_login,Admin_pass)
  	get URL_REPORT_WARNING_LIST_PAGE
		assert_response :success
		#Get Download CSV button
		assert_select "input[type = 'button'][value = '#{_('Download CSV Format')}']"
    post URL_REPORT_WARNING_DOWNLOAD_CSV
    assert_response :success
		#Get Upload CSV button
		get URL_REPORT_WARNING_LIST_PAGE
		assert_response :success
		assert_select 	"input[type = 'button'][value = '#{_('Upload CSV Format')}']"
    xml_http_request :post, URL_REPORT_WARNING_UPLOAD_CSV
    assert_response  :success
    assert_template  "review/_upload_warning_list"
    assert_select    "input[type = 'submit'][value = '#{_('Upload')}']"
		#Upload file to db
		post "review/save_csv_to_db/1/1?id=3&sub_id=5",
      :csv_file 		=> fixture_file_upload("files/review/report_warning_list.csv")
		get URL_REPORT_WARNING_LIST_PAGE
		#Get Comment list button
		assert_select "input[type = 'button'][value = '#{_('Comment Listing')}']"
		post URL_REPORT_COMMENT_LIST_PAGE
		assert_response :success
	end

	def test_it_rsf10a_t3_r3_017_to_020
		#Warning listing page of a file
		login(Admin_login,Admin_pass)
		#Search warnings: Rule Number = '0999'
		get URL_REPORT_WARNING_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_REPORT_WARNING,
      :filter_field 		=> "warnings.rule",
      :filter_keyword 	=> "0999"
		assert_response  :success

		#Search warnings: empty search field => display all warnings
		get URL_REPORT_WARNING_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_REPORT_WARNING,
      :filter_field 		=> "warnings.rule",
      :filter_keyword 	=> ""
		assert_response  :success

		#Search warnings: type * in search field => display all warnings
		get URL_REPORT_WARNING_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_REPORT_WARNING,
      :filter_field 		=> "warnings.rule",
      :filter_keyword 	=> "*"
		assert_response  :success

		#Link to Analysis result report page in Table's File name column
		get URL_REPORT_WARNING_LIST_PAGE
		assert_response  :success
		xml_http_request :post, URL_SEARCH_REPORT_WARNING
		assert_response  :success

		#Get Comment listing button
		get URL_REPORT_WARNING_LIST_PAGE
		assert_response  :success
    assert_select  "input[type = 'button'][value = '#{_('Comment Listing')}']"
    post URL_REPORT_COMMENT_LIST_PAGE
    assert_response :success
    assert_select "div#pagetitle", _("Comment listing of ") + _("analyzeme.c.Normal.html")
	end

	def test_it_rsf10a_t3_r3_022_023_032_033_034_042_043
	  login(Admin_login,Admin_pass)
		get URL_COMMENT_LIST_PAGE
		assert_response :success
		assert_select "div#warning_list", _("No comment found.")

		get URL_REPORT_COMMENT_LIST_PAGE
		assert_response :success
		assert_select "div#report_warning_list", _("No comment found.")

		#Add test comment
		get URL_WARNING_LIST_PAGE
		post "comment/add_or_edit/1/1?p1=2&sub_id=5&warning_id=1",
      :risk_type_id					=> "1",
      :warning_description 	=> "Warning example",
      :sample_source_code		=> "Source code example",
      :status								=> "true"
		assert_response :success

		#Switch to comment list
		get URL_COMMENT_LIST_PAGE
		assert_response :success
		assert_select "table[class = 'review_table']"	do
			assert_select "td", _("Registered")
		end

		#Switch to comment list of file
		get URL_REPORT_COMMENT_LIST_PAGE
		assert_response :success

		#delete test comment
		post "comment/delete/1/1?p1=2&sub_id=5&warning_id=1"
  	assert_response :success


	end

	def test_it_rsf10a_t3_r3_024_025_026
		login(Admin_login,Admin_pass)
		#Comment list page
		get URL_COMMENT_LIST_PAGE
		assert_response :success
		#Get Download CSV button
		assert_select "input[type = 'button'][value = '#{_('Download CSV Format')}']"
    post URL_COMMENT_DOWNLOAD_CSV
    assert_response :success
		#Get Upload CSV button
		get URL_COMMENT_LIST_PAGE
		assert_response :success
		assert_select 	"input[type = 'button'][value = '#{_('Upload CSV Format')}']"
    xml_http_request :post, URL_COMMENT_UPLOAD_CSV
    assert_response  :success
    assert_template  "review/_upload_warning_list"
    assert_select    "input[type = 'submit'][value = '#{_('Upload')}']"
    get URL_COMMENT_LIST_PAGE
		#Get Warning list button
		assert_select "input[type = 'button'][value = '#{_('Warning Listing')}']"
		post URL_WARNING_LIST_PAGE
		assert_response :success
	end

	def test_it_rsf10a_t3_r3_027_to_031
		login(Admin_login,Admin_pass)
		get URL_COMMENT_LIST_PAGE
		assert_response  :success
		#Warning Rule 0999 added comment
		#Search warnings: Rule Number = '0999'
		get URL_COMMENT_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_COMMENT_LIST,
      :filter_field 		=> "warnings.rule",
      :filter_keyword 	=> "0999"
		assert_response  :success

		#Search warnings: Directory = 'sample_cpp/src'
		get URL_COMMENT_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_COMMENT_LIST,
      :filter_field		=> "warnings.source_path",
      :filter_keyword  => "sample_cpp/src"
		assert_response  :success
		#Search warnings: Source name = 'Preprocessor.cpp'
		get URL_COMMENT_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_COMMENT_LIST,
      :filter_field 		=> "warnings.source_name",
      :filter_keyword  => "Preprocessor.cpp"
		assert_response  :success
		assert_select    "div#warning_list", _("No comment found.")

		#Search warnings: empty search field => display all warnings
		get URL_COMMENT_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_COMMENT_LIST,
      :filter_field 		=> "warnings.rule",
      :filter_keyword 	=> ""
		assert_response  :success

		#Search warnings: type * in search field => display all warnings
		get URL_COMMENT_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_COMMENT_LIST,
      :filter_field 		=> "warnings.rule",
      :filter_keyword 	=> "*"
		assert_response  :success
	end

	def test_it_rsf10a_t3_r3_035_to_038
		login(Admin_login,Admin_pass)
		get URL_REPORT_COMMENT_LIST_PAGE
		assert_response :success
		#Get Download CSV button
		assert_select "input[type = 'button'][value = '#{_('Download CSV Format')}']"
    post URL_REPORT_COMMENT_DOWNLOAD_CSV
    assert_response :success
		#Get Upload CSV button
		get URL_REPORT_COMMENT_LIST_PAGE
		assert_response :success
		assert_select 	"input[type = 'button'][value = '#{_('Upload CSV Format')}']"
    xml_http_request :post, URL_REPORT_COMMENT_UPLOAD_CSV
    assert_response  :success
    assert_template  "review/_upload_warning_list"
    assert_select    "input[type = 'submit'][value = '#{_('Upload')}']"
	  get URL_REPORT_COMMENT_LIST_PAGE
		#Get Warning list button
		assert_select "input[type = 'button'][value = '#{_('Warning Listing')}']"
		post URL_REPORT_WARNING_LIST_PAGE
		assert_response :success
	end


	def test_it_rsf10a_t3_r3_039_to_041
		login(Admin_login,Admin_pass)
		get URL_REPORT_COMMENT_LIST_PAGE
		assert_response  :success
		#Warning Rule 0999 added comment
		#Search warnings: Rule Number = '0999'
		get URL_REPORT_COMMENT_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_REPORT_WARNING,
      :filter_field 		=> "warnings.rule",
      :filter_keyword 	=> "0999"
		assert_response  :success
		#Search warnings: empty search field => display all warnings
		get URL_REPORT_COMMENT_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_REPORT_WARNING,
      :filter_field 		=> "warnings.rule",
      :filter_keyword 	=> ""
		assert_response  :success

		#Search warnings: type * in search field => display all warnings
		get URL_REPORT_COMMENT_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_REPORT_WARNING,
      :filter_field 		=> "warnings.rule",
      :filter_keyword 	=> "*"
		assert_response  :success
	end
end
