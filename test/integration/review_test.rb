require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/setup'

class ReviewTest < ActionController::IntegrationTest
  # fixtures 
#  fixtures :users
#  fixtures :users
#  fixtures :privileges
#  fixtures :privileges_users
#  fixtures :reviews
#  fixtures :results
#  fixtures :warnings_results
#  fixtures :comments
#  fixtures :summaries
#  fixtures :result_directories

  Admin_login = "root"
  Admin_pass  = "root"
  Pj_member   = "pj_member"
  Pj_member_pass   = "pj_member"
  EXTRACTED_SUBTASK = "/review/view_result_report_list/1/2/6?sub_id=11"
  UNEXTRACTED_SUBTASK = "/review/view_result_report_list/1/2/4?sub_id=7" 

  ## Test create data action
  #
  # + User not logged in.
  # + Request create data for unextracted subtask
  def test_IT_RSF10A_T3_R3_001
    get UNEXTRACTED_SUBTASK
    assert_redirected_to :controller => "auth", :action => "login"
  end
  # + User not logged in.
  # + Request create data for extracted subtask
  def test_IT_RSF10A_T3_R3_002
    get EXTRACTED_SUBTASK
    assert_redirected_to :controller => "auth", :action => "login"
  end
  # + User logged in.
  # + Request create data for unextracted subtask
  def test_IT_RSF10A_T3_R3_003
    login(Admin_login,Admin_pass)
    get UNEXTRACTED_SUBTASK
    assert_redirected_to :controller => "review", :action => "create_data",
                                    :pu => 1,
                                    :pj => 2,
                                    :id => 4,
                                    :sub_id => 7
  end
  # + User logged in.
  # + Request create data for extracted subtask
  def test_IT_RSF10A_T3_R3_004
    login(Admin_login,Admin_pass)
    get EXTRACTED_SUBTASK
    assert_response :success
  end
  # + User logged in.
  # + post create data for uncreated subtask
  #
  def test_IT_RSF10A_T3_R3_005
    login(Admin_login,Admin_pass)
    get UNEXTRACTED_SUBTASK
    post url_for(:controller => "review", :action => "create_data", :sub_id => 7)
    assert_response :success
  end
  # + User logged in.
  # + post create data for created subtask
  # + => message of another user created results
  #
  def test_IT_RSF10A_T3_R3_006
    login(Admin_login,Admin_pass)
    get EXTRACTED_SUBTASK
    post url_for(:controller => "review", :action => "create_data", :sub_id => 11)
    assert_response :success
  end
  # + PJ member logged in.
  # + Request to create data for unregistered subtask
  #
  def test_IT_RSF10A_T3_R3_007
    login("pj_member", "pj_member")
    get UNEXTRACTED_SUBTASK
    post url_for(:controller => "review", :action => "create_data", :sub_id => 7)
    !assert_response :success
  end
  ## Test view_result_report
  # + User not logged in.
  # + Request to view view_result_report
  #
  def test_IT_RSF10A_T3_R3_008
    get url_for(:controller => "review", :action => "view_result_report",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :result_id => 7)
    assert_redirected_to :controller => "auth", :action => "login"
  end
  # + User logged in.
  # + Request to view view_result_report
  #
  def test_IT_RSF10A_T3_R3_009
    login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "view_result_report",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :result_id => 7)
    assert_response :success
  end
  # + User logged in.
  # + Request to view view_result_report for unextracted subtask
  #
  def test_IT_RSF10A_T3_R3_010
    login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "view_result_report",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 7,
                                        :result_id => 100)
    assert_redirected_to :controller => "misc", :action => "index"
  end
  # + Not an user of subtask
  # + Request to view view_result_report
  #
  def test_IT_RSF10A_T3_R3_011
    login("pj_member","pj_member")
    get url_for(:controller => "review", :action => "view_result_report",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :result_id => 7)
    assert_redirected_to :controller => "misc", :action => "index"
  end

  # + User logged in.
  # + Subtask is publicized
  # + Request to view view_result_report
  #
  def test_IT_RSF10A_T3_R3_012
    login(Admin_login,Admin_pass)
    post url_for(:controller => "review", :action => "publicize",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11)
    #
    get url_for(:controller => "review", :action => "view_result_report",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :result_id => 7)
    assert_response :success
  end
  ## Test publicize
  #
  # + No user logged in
  # + Request to publicize subtask
  #
  def test_IT_RSF10A_T3_R3_013
    post url_for(:controller => "review", :action => "publicize",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11)
    assert_redirected_to :controller => "auth", :action => "login"
  end

  # + Admin logged in
  # + Request to publicize subtask
  #
  def test_IT_RSF10A_T3_R3_014
    login(Admin_login,Admin_pass)
    get "/review/view_result_report_list/1/2/6?sub_id=11"
    post url_for(:controller => "review", :action => "publicize",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11)
    assert_equal _("Subtask  (id=11)  is publicized successfully!"), flash[:notice]
  end

  # + PJ member logged in
  # + Request to publicize subtask
  #
  def test_IT_RSF10A_T3_R3_015
    login("pj_member","pj_member")
    post url_for(:controller => "review", :action => "publicize",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11)
    assert_not_equal _("Subtask  (id=11)  is publicized successfully!"), flash[:notice]
  end
  ## Test unpublicize
  #
  # + No user logged in
  # + Request to publicize subtask
  #
  def test_IT_RSF10A_T3_R3_016
    post url_for(:controller => "review", :action => "unpublicize",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11)
    assert_redirected_to :controller => "auth", :action => "login"
  end

  # + Admin logged in
  # + Request to publicize subtask
  #
  def test_IT_RSF10A_T3_R3_017
    login(Admin_login,Admin_pass)
    post url_for(:controller => "review", :action => "unpublicize",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11)
    assert_equal _("Subtask  (id=11)  is unpublicized successfully!"), flash[:notice]
  end

  # + PJ member logged in
  # + Request to publicize subtask
  #
  def test_IT_RSF10A_T3_R3_018
    login("pj_member","pj_member")
    post url_for(:controller => "review", :action => "unpublicize",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11)
    assert_not_equal _("Subtask  (id=11)  is unpublicized successfully!"), flash[:notice]
  end
	## Test view_result_report
  # + User not logged in.
  # + Request to view view_result_report_list
  #
	def test_IT_RSF10A_T3_R3_019
    get url_for(:controller => "review", :action => "view_result_report_list",
																				:pu => 1,
																				:pj => 2,
																				:id => 6,
																				:sub_id => 11
                                        )
    assert_redirected_to :controller => "auth", :action => "login"
  end

  # + User logged in.
  # + Request to view view_result_report_list
  #
	def test_IT_RSF10A_T3_R3_020
    login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "view_result_report_list",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11
                                        )
    assert_response :success
  end

	# + User logged in.
  # + Request to view view_result_report_list (with unextracted subtask)
  #
	def test_IT_RSF10A_T3_R3_021
    login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "view_result_report_list",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 7
                                        )
    assert_redirected_to :controller => "misc", :action => "index"
  end

	# + User logged in.
  # + Request to view view_result_report_list (with extracted subtask)
  #
	def test_IT_RSF10A_T3_R3_022
    login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "view_result_report_list",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11
                                        )
    assert_response :success
  end

  ## Test view_result_summary
  # + User not logged in.
  # + Request to view view_result_summary
  #
	def test_IT_RSF10A_T3_R3_023
    get url_for(:controller => "review", :action => "view_result_summary",
																				:pu => 1,
																				:pj => 1,
																				:id => 3,
																				:sub_id => 5
                                        )
    assert_redirected_to :controller => "auth", :action => "login"
end

  # + User logged in.
  # + Request to view view_result_summary
  #
	def test_IT_RSF10A_T3_R3_024
    login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "view_result_summary",
                                        :pu => 1,
                                        :pj => 1,
                                        :id => 3,
                                        :sub_id => 5
                                        )
    assert_response :success
  end

	# + User logged in.
  # + Request to view view_result_summary (with unextracted subtask)
  #
	def test_IT_RSF10A_T3_R3_025
    login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "view_result_summary",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 7
                                        )
    assert_redirected_to :controller => "misc", :action => "index"
  end

	# + Pj member logged in.
  # + Request to view view_result_summary (with extracted subtask)
  #
	def test_IT_RSF10A_T3_R3_026
    login(Pj_member,Pj_member_pass)
    get url_for(:controller => "review", :action => "view_result_summary",
                                        :pu => 1,
                                        :pj => 1,
                                        :id => 3,
                                        :sub_id => 5
                                        )
    assert_response :success
  end

  # Request to download_analysis_result with extracted subtask
  def test_IT_RSF10A_T3_R3_027
    login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "download_analysis_result",
                                        :pu => 1,
                                        :pj => 1,
                                        :id => 3,
                                        :sub_id => 5
                                        )
    assert_response :success
  end

  def login(user, pass)
    get "/auth/login"
    assert_response :success
    post "/auth/login", :login => user, :password => pass
    assert_redirected_to :controller => "misc", :action => "index"
    get "/misc"
    assert_response :success
  end

	###********** Test IT T5  2010A ************####
	## ******** Filtering Display Warnings ******####
	##************************************************##
	 ## Test view_result_report
  # + User not logged in.
  # + Request to view view_result_report
  #
  def test_IT_FDW10A_T5_R1_001
    get url_for(:controller => "review", :action => "view_result_report",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 5,
                                        :sub_id => 10,
                                        :result_id => 25)
    assert_redirected_to :controller => "auth", :action => "login"
  end

  # + User logged in.
  # + Request to view view_result_report
  #
  def test_IT_FDW10A_T5_R1_002
    login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "view_result_report",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 5,
                                        :sub_id => 10,
                                        :result_id => 25)
    assert_response :success
  end

  # + User logged in.
  # + Request to view view_result_report for unextracted subtask
  #
  def test_IT_FDW10A_T5_R1_003
    login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "view_result_report",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 5,
                                        :sub_id => 10,
                                        :result_id => 100)
    assert_redirected_to :controller => "misc", :action => "index"
  end

  # + User logged in
  # + Not an user of subtask
  # + Request to view view_result_report
  #
  def test_IT_FDW10A_T5_R1_004
    login("pj_member","pj_member")
    get url_for(:controller => "review", :action => "view_result_report",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 5,
                                        :sub_id => 10,
                                        :result_id => 25)
    assert_redirected_to :controller => "misc", :action => "index"
  end

  # + User logged in.
  # + Subtask is publicized
  # + Request to view view_result_report
  #
  def test_IT_FDW10A_T5_R1_005
    login(Admin_login,Admin_pass)
    post url_for(:controller => "review", :action => "publicize",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 5,
                                        :sub_id => 10)
    
    get url_for(:controller => "review", :action => "view_result_report",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 5,
                                        :sub_id => 10,
                                        :result_id => 25)
    assert_response :success
  end

	# Test redraw_filtering
  # + User not logged in.
  # + Request to redraw_filtering
  #
  def test_IT_FDW10A_T5_R1_006
    get url_for(:controller => "review", :action => "redraw_filtering",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 5,
                                        :sub_id => 10,
                                        :result_id => 25)
    assert_redirected_to :controller => "auth", :action => "login"
  end

	# + User logged in
	# + Request to redraw_filtering
	#
	def test_IT_FDW10A_T5_R1_007
    login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "redraw_filtering",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 5,
                                        :sub_id => 10,
                                        :result_id => 25)
    assert_response :success
  end

   # + User logged in
	 # + Not an user of subtask
   # + Request to redraw_filtering
   #
  def test_IT_FDW10A_T5_R1_008
    login("pj_member","pj_member")
    get url_for(:controller => "review", :action => "redraw_filtering",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 5,
                                        :sub_id => 10,
                                        :result_id => 25)
    assert_response :success
  end

	# + User logged in.
  # + Subtask is publicized
  # + Request to redraw_filtering
  #
  def test_IT_FDW10A_T5_R1_009
    login(Admin_login,Admin_pass)
    post url_for(:controller => "review", :action => "publicize",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 5,
                                        :sub_id => 10)
    
    get url_for(:controller => "review", :action => "view_result_report",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 5,
                                        :sub_id => 10,
                                        :result_id => 25)
    assert_response :success
  end

	# Test clear_filtering
  # + User not logged in.
  # + Request to clear_filtering
  #
  def test_IT_FDW10A_T5_R1_010
    get url_for(:controller => "review", :action => "clear_filtering",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 5,
                                        :sub_id => 10,
                                        :result_id => 25)
    assert_redirected_to :controller => "auth", :action => "login"
  end

	# + User logged in.
  # + Request to clear_filtering
  #
  def test_IT_FDW10A_T5_R1_011
		login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "clear_filtering",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 5,
                                        :sub_id => 10,
                                        :result_id => 25)
    assert_response :success
  end

	# + Not an user of subtask
  # + Request to clear_filtering
  #
  def test_IT_FDW10A_T5_R1_012
    login("pj_member","pj_member")
    get url_for(:controller => "review", :action => "clear_filtering",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 5,
                                        :sub_id => 10,
                                        :result_id => 25)
    assert_response :success
  end

	# Test apply_filtering
  # + User not logged in.
  # + Request to apply_filtering
  #
  def test_IT_FDW10A_T5_R1_013
    get url_for(:controller => "review", :action => "apply_filtering",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 5,
                                        :sub_id => 10,
                                        :result_id => 25)
    assert_redirected_to :controller => "auth", :action => "login"
  end

	# + User logged in.
  # + Request to apply_filtering
  #
  def test_IT_FDW10A_T5_R1_014
		login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "apply_filtering",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 5,
                                        :sub_id => 10,
                                        :result_id => 25)
    assert_response :success
  end

	# + Not an user of subtask
  # + Request to apply_filtering
  #
  def test_IT_FDW10A_T5_R1_015
    login("pj_member","pj_member")
    get url_for(:controller => "review", :action => "apply_filtering",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 5,
                                        :sub_id => 10,
                                        :result_id => 25)
    assert_response :success
  end

	# Test catch_filter_conditions
  # + User not logged in.
  # + Request to catch_filter_conditions
  #
  def test_IT_FDW10A_T5_R1_016
    get url_for(:controller => "review", :action => "catch_filter_conditions",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 5,
                                        :sub_id => 10,
                                        :result_id => 25)
    assert_redirected_to :controller => "auth", :action => "login"
  end

	 # + User logged in.
  # + Request to catch_filter_conditions
  #
  def test_IT_FDW10A_T5_R1_017
		login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "catch_filter_conditions",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 5,
                                        :sub_id => 10,
                                        :result_id => 25)
    assert_response :success
  end

  ###********** Test IT T3  2010B ************####
	## ******** Result/ Review function,. ******####
	##************************************************##
	 ## Test view_select_item
  # + User logged in.
  # + Request to view_select_item
  #
  def test_IT_T3_WCTI_RIV_001
    login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "view_select_item",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :p1   => 2)
    assert_response :success

    get url_for(:controller => "review", :action => "view_select_item",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :p1   => 3)
    assert_response :success

    get url_for(:controller => "review", :action => "view_select_item",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :p1   => 4)
    assert_response :success

    get url_for(:controller => "review", :action => "view_select_item",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :p1   => 5)
    assert_response :success
  end

  # + User not logged in.
  # + Request to view_select_item
  #
  def test_IT_T3_WCTI_RIV_002
    get url_for(:controller => "review", :action => "view_select_item",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :p1   => 2)
    assert_redirected_to :controller => "auth", :action => "login"

    get url_for(:controller => "review", :action => "view_select_item",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :p1   => 5)
    assert_redirected_to :controller => "auth", :action => "login"
  end

  # + User logged in.
  # + Request to data_for_select
  #
  def test_IT_T3_WCTI_RIV_003
    login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "data_for_select(2)",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :items => nil,
                                        :reset => true,
                                        :p1   => 2)
    assert_response :success

    get url_for(:controller => "review", :action => "data_for_select(5)",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :reset => true,
                                        :items => "id",
                                        :sub_id => 11,
                                        :p1   => 3)
    assert_response :success

    get url_for(:controller => "review", :action => "data_for_select(3)",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :items => nil,
                                        :reset => false,
                                        :p1   => 3)
    assert_response :success
  end

  # + User not logged in.
  # + Request to data_for_select
  #
  def test_IT_T3_WCTI_RIV_004
    get url_for(:controller => "review", :action => "data_for_select(5)",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :items => "id",
                                        :reset => true,
                                        :p1   => 2)
    assert_redirected_to :controller => "auth", :action => "login"
  end

  # + User logged in.
  # + Request to view_warning_list
  #
  def test_IT_T3_WCTI_RIV_005
    login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "view_warning_list",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :items => "id",
                                        :reset => true,
                                        :p1   => 2)
    assert_response :success
  end

  # + User not logged in.
  # + Request to view_warning_list
  #
  def test_IT_T3_WCTI_RIV_006
    get url_for(:controller => "review", :action => "view_warning_list",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :items => "id",
                                        :reset => true,
                                        :p1   => 2)
    assert_redirected_to :controller => "auth", :action => "login"
  end

  # + User logged in
  # + Subtask is publicized
  # + Request to view_warning_list
  #
  def test_IT_T3_WCTI_RIV_007
    login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "view_warning_list",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 4,
                                        :sub_id => 7 ,
                                        :items => nil,
                                        :reset => true,
                                        :p1   => 2)
    assert_response :success
  end

  # + User logged in.
  # + Request to view_comment_list
  #
  def test_IT_T3_WCTI_RIV_008
    login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "view_comment_list",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :items => nil,
                                        :reset => nil,
                                        :p1   => 2)
    assert_response :success
  end

  # + User not logged in.
  # + Request to view_comment_list
  #
  def test_IT_T3_WCTI_RIV_09
    get url_for(:controller => "review", :action => "view_comment_list",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :items => nil,
                                        :reset => nil,
                                        :p1   => 2)
    assert_redirected_to :controller => "auth", :action => "login"
  end

  # + User logged in
  # + Subtask is publicized
  # + Request to view_comment_list
  #
  def test_IT_T3_WCTI_RIV_010
    login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "view_comment_list",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 4,
                                        :sub_id => 7,
                                        :items => "id",
                                        :reset => true,
                                        :p1   => 2)
    assert_response :success
  end

  # + User logged in.
  # + Request to view_report_warning_list
  #
  def test_IT_T3_WCTI_RIV_011
    login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "view_report_warning_list",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :result_id => 825,
                                        :items => "id",
                                        :reset => true,
                                        :p1   => 2)
    assert_response :success
  end

  # + User not logged in.
  # + Request to view_report_warning_list
  #
  def test_IT_T3_WCTI_RIV_012
    get url_for(:controller => "review", :action => "view_report_warning_list",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :items => "id",
                                        :reset => true,
                                        :p1   => 2)
    assert_redirected_to :controller => "auth", :action => "login"
  end

  # + User logged in
  # + Subtask is publicized
  # + Request to view_report_warning_list
  #
  def test_IT_T3_WCTI_RIV_013
    login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "view_report_waning_list",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 4,
                                        :sub_id => 7,
                                        :items => "id",
                                        :reset => true,
                                        :p1   => 2)
    assert_response :success
  end

  # + User logged in.
  # + Request to view_report_comment_list
  #
  def test_IT_T3_WCTI_RIV_014
    login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "view_report_comment_list",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :items => "id",
                                        :result_id => 825,
                                        :reset => true,
                                        :p1   => 2)
    assert_response :success
  end

  # + User not logged in.
  # + Request to view_report_comment_list
  #
  def test_IT_T3_WCTI_RIV_015
    get url_for(:controller => "review", :action => "view_report_comment_list",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :items => "id",
                                        :reset => nil,
                                        :p1   => 2)
    assert_redirected_to :controller => "auth", :action => "login"
  end

  # + User not logged in
  # + Subtask is publicized
  # + Request to view_report_comment_list
  #
   def test_IT_T3_WCTI_RIV_016
    get url_for(:controller => "review", :action => "view_report_comment_list",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 4,
                                        :sub_id => 7,
                                        :items => "id",
                                        :reset => false,
                                        :p1   => 2)
    assert_redirected_to :controller => "auth", :action => "login"
  end

  # + User logged in
  # + Request to render_after_customize_item
  #
   def test_IT_T3_WCTI_RIV_017
    login(Admin_login,Admin_pass)
    get url_for(:controller => "review", :action => "render_after_customize_item(true,[],'warning_list_field','warning_list'",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :sub_id => 11,
                                        :result_id => 825,
                                        :items => "id",
                                        :reset => false,
                                        :p1   => 2)
    assert_response :success
  end

    # + User not logged in
  # + Request to render_after_customize_item
  #
   def test_IT_T3_WCTI_RIV_018
    get url_for(:controller => "review", :action => "render_after_customize_item('true',[],'warning_list_field','warning_list'",
                                        :pu => 1,
                                        :pj => 2,
                                        :id => 6,
                                        :result_id => 825,
                                        :sub_id => 11,
                                        :items => "id",
                                        :reset => false,
                                        :p1   => 2)
    assert_redirected_to :controller => "auth", :action => "login"
  end

end