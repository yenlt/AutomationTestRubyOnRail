require File.dirname(__FILE__) + '/setup'
require File.dirname(__FILE__) + '/../test_helper'

class ToscanaTest < ActionController::IntegrationTest

  ANALYSIS_RESULT_REPORT_FILE				= _("Analysis Result Report") + " (analyzeme.c.Critical.html)"
  #  fixtures :source_codes
  #  fixtures :warnings
  #  fixtures :reviews

  def setup
    import_sql
  end
  
	def test_rsf_it_fa_001_002_003_004
		login
		#Invalid PU
		get "review/view_result_report_list/100/1?id=3&sub_id=5"
    assert_equal _("PU (id=") + "100) " + _("not found!"), flash[:notice]
    assert_redirected_to :controller => "misc", :action => "index"
		#Invalid PJ
		get "review/index"
		assert_response :success
		get "review/view_result_report_list/1/100?id=3&sub_id=5"
    assert_equal _("PJ (id=") + "100) " + _("not found!"), flash[:notice]
    assert_redirected_to :controller => "misc", :action => "index"
		#Invalid Task ID
		get "review/index"
		assert_response :success
		get "review/view_result_report_list/1/1?id=100&sub_id=5"
    assert_equal _("Task (id=") + "100) " + _("not found!"), flash[:notice]
    assert_redirected_to :controller => "misc", :action => "index"
		#Invalid Subtask ID
		get "review/index"
		assert_response :success
		get "review/view_result_report_list/1/1?id=1&sub_id=100"
    assert_equal _("Subtask (id=") + "100) " + _("not found!"), flash[:notice]
    assert_redirected_to :controller => "misc", :action => "index"
	end

	def test_rsf_it_fa_005
		#Data unextract
		#Switch to extract page
		login
		get URL_VIEW_RESULT_REPORT_LIST_PAGE
		assert_response :success
    get URL_DATA_UNEXTRACT
    assert_redirected_to :controller => "review", :action => "extract_data"
    get URL_EXTRACT_DATA_PAGE
    assert_select "div#pagetitle", _("Data Extracting Page")
	end

  def test_rsf_it_fa_006_007
  	login
		#Review Administration page
		assert_select "div#right_contents"
		assert_select "table[class = 'review_table']"
    assert_select "thead" do
      assert_select "th", "PU"
      assert_select "th", "PJ"
      assert_select "th", "QAC"
      assert_select "th", "QAC++"
    end

    assert_select "tbody" do
      assert_select "tr"
      assert_select "td", "SamplePU1"
      assert_select "td", "SamplePJ1"
      #Data unpublicize => Review link
      assert_select "td", _("Review")
      assert_select "td", _("Review")
    end
	end

	def test_rsf_it_fa_009_010_019
		login
		#Display Result report list page
		get URL_VIEW_RESULT_REPORT_LIST_PAGE
		assert_response :success
    assert_select "input[type = 'submit'][value = '#{_('Publicize')}']"
    assert_select "input[type = 'submit'][value = '#{_('Warning Listing')}']"
    assert_select "input[type = 'submit'][value = '#{_('Result Download')}']"
  	#Get Warning list button
		xml_http_request :post, URL_WARNING_LIST_PAGE
		assert_response :success
		#Display Warning list page
		get URL_WARNING_LIST_PAGE
		assert_response :success
		assert_select "div#pagetitle", _('Warning Listing Page')
    assert_select "input[type = 'button'][value = '#{_('Comment Listing')}']"
    assert_select "input[type = 'button'][value = '#{_('Download CSV Format')}']"
    assert_select "input[type = 'button'][value = '#{_('Upload CSV Format')}']"
    assert_select "select#search_field" do
      assert_select "option", _("Source name")
      assert_select "option", _("Rule number")
      assert_select "option", _("Directory")
      assert_select "option", _("File name")
    end
    assert_select "input[type = 'text']"
    assert_select "input[type = 'button'][value = '#{_('Search')}']"
	end

	def test_rsf_it_fa_008_011_012_015_016_017_018
		login
		get URL_VIEW_RESULT_REPORT_LIST_PAGE
		assert_response :success

		#Publicize
		xml_http_request :post, URL_PUBLICIZE
		assert_redirected_to :controller => "review", :action => "view_result_report_list"
  	get URL_VIEW_RESULT_REPORT_LIST_PAGE
		assert_response :success
    assert_equal  _("Subtask") + " (id=5) " + _("is publicized successfully!"), flash[:notice]
    assert_select "input[type = 'submit'][value = '#{_('Unpublicize')}']"
		#Reviewed link
		get 'review/index'
		assert_response :success
		assert_select "table[class = 'review_table']" do
			assert_select "td", _("Reviewed")
		end
    
		#User login
		login_as_user("pj_member", "pj_member")
    get URL_VIEW_RESULT_REPORT_LIST_PAGE
    assert_response :success
    assert_select "input[type = 'submit'][value = '#{_('Warning Listing')}']"
    post URL_WARNING_LIST_PAGE
    assert_response :success
    post URL_REPORT_WARNING_LIST_PAGE
    assert_response :success

		#Unpublicize
		login
		xml_http_request :post, URL_UNPUBLICIZE
		assert_redirected_to :controller => "review", :action => "view_result_report_list"
  	get URL_VIEW_RESULT_REPORT_LIST_PAGE
		assert_response :success
    assert_equal  _("Subtask") + " (id=5) " + _("is unpublicized successfully!"), flash[:notice]
    assert_select "input[type = 'submit'][value = '#{_('Publicize')}']"
	end

	def test_rsf_it_fa_013
		#Download Analysis result
		login
		get URL_VIEW_RESULT_REPORT_LIST_PAGE
		assert_response :success
		#Click Result download button
    post URL_RESULT_DOWNLOAD
    assert_response :success
	end

	def test_rsf_it_fa_014_032_033_034
		#Display Analysis Result Report page of a file
		login
		get URL_VIEW_RESULT_REPORT_LIST_PAGE
		assert_response :success

		#AnzException.cpp.Critical.html analysis result report page
		xml_http_request :post, URL_VIEW_RESULT_REPORT_PAGE
		assert_response :success
		get URL_VIEW_RESULT_REPORT_PAGE
		assert_response :success
		assert_select "div#pagetitle", ANALYSIS_RESULT_REPORT_FILE
    assert_select "input[type = 'button'][value = '#{_('Show Comments')}']"
    assert_select "input[type = 'button'][value = '#{_('Warning Listing')}']"

		#AnzException.cpp.Critical.html warning list page
		xml_http_request :post, URL_REPORT_WARNING_LIST_PAGE
		assert_response :success
		get URL_REPORT_WARNING_LIST_PAGE
		assert_response :success

    assert_select "input[type = 'button'][value = '#{_('Download CSV Format')}']"
    assert_select "input[type = 'button'][value = '#{_('Upload CSV Format')}']"
    assert_select "select#search_field" do
      assert_select "option", _("Rule number")
    end
    assert_select "input[type = 'text']"
    assert_select "input[type = 'button'][value = '#{_('Search')}']"

		#Get Comment listing page of file analyzyme.c.Critical.html
		post URL_REPORT_COMMENT_LIST_PAGE
		assert_response :success
	end

	def test_rsf_it_fa_020_045
		login
		get URL_VIEW_RESULT_REPORT_LIST_PAGE
		assert_response :success
		get URL_WARNING_LIST_PAGE
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
      assert_select "option", _("Source name")
      assert_select "option", _("Rule number")
      assert_select "option", _("Directory")
      assert_select "option", _("File name")
    end
    assert_select "input[type = 'text']"
    assert_select "input[type = 'button'][value = '#{_('Search')}']"
	end

	def test_rsf_it_fa_021_022
		login
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
		#Upload file to db
		post "review/save_csv_to_db/1/1?id=3&sub_id=5",
       :csv_file 		=> fixture_file_upload("files/review/warning_list.csv")
		assert_response :success
		get URL_WARNING_LIST_PAGE
		assert_response :success
		assert_select "div#log_area" do
			assert_equal  _("Upload successfully!"), flash[:notice]
		end

	end

	def test_rsf_it_fa_024_to_030
		login
		#Search warnings: Rule Number = '0999'
		get URL_WARNING_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_WARNING_LIST_PAGE,
      :filter_field 		=> 'warnings.rule',
      :filter_keyword 	=> '0999'
		assert_response  :success

		#Search warnings: Directory = 'sample_cpp/Common/src'
		get URL_WARNING_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_WARNING_LIST_PAGE,
      :filter_field 		=> "results.path",
      :filter_keyword 	=> "sample_cpp/Common/src"
		assert_response  :success

		#Search warnings: File name = 'LCSAlgo.cpp.HiRisk.html'
		get URL_WARNING_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_WARNING_LIST_PAGE,
      :filter_field 		=> "results.file_name",
      :filter_keyword 	=> "LCSAlgo.cpp.HiRisk.html"
		assert_response  :success

		#Search warnings: Source name = 'Preprocessor.cpp'
		get URL_WARNING_LIST_PAGE
		assert_response	 :success
		post URL_SEARCH_WARNING_LIST_PAGE,
      :filter_field 		=> "results.source_name",
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

	def test_rsf_it_fa_035_to_036
		login
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
		assert_response :success
		get URL_REPORT_WARNING_LIST_PAGE
		assert_response :success
		assert_select "div#log_area" do
			assert_equal  _("Upload successfully!"), flash[:notice]
		end

		#Get Comment list button
		assert_select "input[type = 'button'][value = '#{_('Comment Listing')}']"
		post URL_REPORT_COMMENT_LIST_PAGE
		assert_response :success
	end

	def test_rsf_it_fa_038_to_044
		#Warning listing page of a file
		login
		#Search warnings: Rule Number = '0999'
		get URL_REPORT_WARNING_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_REPORT_WARNING,
      :filter_field 		=> "warnings.rule",
      :filter_keyword 	=> "0999"
		assert_response  :success

		#Search warnings: Directory = 'sample_cpp/Common/src'
		get URL_REPORT_WARNING_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_REPORT_WARNING,
      :filter_field		=> "results.path",
      :filter_keyword  => "sample_cpp/Common/src"
		assert_response  :success

		#Search warnings: File name = 'LCSAlgo.cpp.HiRisk.html'
		get URL_REPORT_WARNING_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_REPORT_WARNING,
      :filter_field 		=> "results.file_name",
      :filter_keyword  => "LCSAlgo.cpp.HiRisk.html"
    #							 assert_select "id#search_keyword", ""
		assert_response  :success
		assert_select "div#report_warning_list", _("No warning found.")

		#Search warnings: Source name = 'Preprocessor.cpp'
		get URL_REPORT_WARNING_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_REPORT_WARNING,
      :filter_field 		=> "results.source_name",
      :filter_keyword  => "Preprocessor.cpp"
		assert_response  :success
		assert_select "div#report_warning_list", _("No warning found.")

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
    assert_select "div#pagetitle", _("Comment Listing Page") + " (analyzeme.c.Critical.html)"
	end

	def test_rsf_it_fa_046_047_058_059_060_071_072
		login

		get URL_COMMENT_LIST_PAGE
		assert_response :success
		assert_select "div#warning_list", _("No warning found.")

		get URL_REPORT_COMMENT_LIST_PAGE
		assert_response :success
		assert_select "div#report_warning_list", _("No warning found.")

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
		assert_select "table[class = 'review_table']"	do
			assert_select "td", _("Registered")
		end

		#delete test comment
		post "comment/delete/1/1?p1=2&sub_id=5&warning_id=1"
  	assert_response :success


	end

	def test_rsf_it_fa_048_049_050
		login
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
		#Upload file to db
		post "review/save_csv_to_db/1/1?id=3&sub_id=5",
      :csv_file 		=> fixture_file_upload("files/review/comment_list.csv")
		assert_response :success
		get URL_COMMENT_LIST_PAGE
		assert_response :success
		assert_select "div#log_area" do
			assert_equal  _("Upload successfully!"), flash[:notice]
		end

		#Get Warning list button
		assert_select "input[type = 'button'][value = '#{_('Warning Listing')}']"
		post URL_WARNING_LIST_PAGE
		assert_response :success
	end

	def test_rsf_it_fa_052_to_057
		login
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

		#Search warnings: Directory = 'sample_cpp/Common/src'
		get URL_COMMENT_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_COMMENT_LIST,
      :filter_field		=> "results.path",
      :filter_keyword  => "sample_cpp/Common/src"
		assert_response  :success

		#Search warnings: File name = 'LCSAlgo.cpp.HiRisk.html'
		get URL_COMMENT_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_COMMENT_LIST,
      :filter_field 		=> "results.file_name",
      :filter_keyword  => "LCSAlgo.cpp.HiRisk.html"
		assert_response  :success
		assert_select    "div#warning_list", _("No warning found.")

		#Search warnings: Source name = 'Preprocessor.cpp'
		get URL_COMMENT_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_COMMENT_LIST,
      :filter_field 		=> "results.source_name",
      :filter_keyword  => "Preprocessor.cpp"
		assert_response  :success
		assert_select    "div#warning_list", _("No warning found.")

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

	def test_rsf_it_fa_061_to_064
		login
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
		#Upload file to db
		post "review/save_csv_to_db/1/1?id=3&sub_id=5",
      :csv_file 		=> fixture_file_upload("files/review/report_comment_list.csv")
		assert_response :success
		get URL_REPORT_COMMENT_LIST_PAGE
		assert_response :success
		assert_select "div#log_area" do
			assert_equal  _("Upload successfully!"), flash[:notice]
		end

		#Get Warning list button
		assert_select "input[type = 'button'][value = '#{_('Warning Listing')}']"
		post URL_REPORT_WARNING_LIST_PAGE
		assert_response :success
	end

	def test_rsf_it_fa_065_to_070
		login
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

		#Search warnings: Directory = 'sample_cpp/Common/src'
		get URL_REPORT_COMMENT_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_REPORT_WARNING,
      :filter_field		=> "results.path",
      :filter_keyword  => "sample_cpp/Common/src"
		assert_response  :success

		#Search warnings: File name = 'LCSAlgo.cpp.HiRisk.html'
		get URL_REPORT_COMMENT_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_REPORT_WARNING,
      :filter_field 		=> "results.file_name",
      :filter_keyword  => "LCSAlgo.cpp.HiRisk.html"
		assert_response  :success
		assert_select    "div#report_warning_list", _("No warning found.")

		#Search warnings: Source name = 'Preprocessor.cpp'
		get URL_REPORT_COMMENT_LIST_PAGE
		assert_response  :success
		post URL_SEARCH_REPORT_WARNING,
      :filter_field 		=> "results.source_name",
      :filter_keyword  => "Preprocessor.cpp"
		assert_response  :success
		assert_select    "div#report_warning_list", _("No warning found.")

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

	def test_rsf_it_fa_073
		#Extract data
    login
    post URL_DATA_UNEXTRACT
    assert_redirected_to :controller => "review", :action => "extract_data"
    get URL_EXTRACT_DATA_PAGE
    assert_response :success
    assert_select "input[type = 'button'][value = '#{_('Extract')}']"
    xml_http_request :post, URL_EXTRACT_DATA_PAGE
    assert_response :success
	end

end
