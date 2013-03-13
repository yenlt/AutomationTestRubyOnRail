require File.dirname(__FILE__) + '/setup'
require File.dirname(__FILE__) + '/../test_helper'

class ToscanaTest < ActionController::IntegrationTest
	def test_rsf_it_fa_074_to_078
		login
		get URL_WARNING_LIST_PAGE
		assert_response :success

		#Display Comment Editor subwindow
		post "comment/view_comment_editor/1/1?p1=2&sub_id=5&warning_id=2"
		assert_response :success
		assert_template "comment/_comment_editor_subwindow"
		assert_select "input[type = 'submit'][value = '#{_('Temporary Save')}']"
		assert_select "input[type = 'submit'][value = '#{_('Register')}']"
		assert_select "a[class = 'cancel_link']"

		#Add and save a comment: Warning Id = 2
		get URL_WARNING_LIST_PAGE
		assert_response :success
		post "comment/add_or_edit/1/1?p1=2&sub_id=5&warning_id=2",
				 :risk_type_id					=> "1",
				 :warning_description 	=> "Warning example",
				 :sample_source_code		=> "Source code example",
				 :status								=> "true"
		assert_response :success
		get URL_WARNING_LIST_PAGE
		assert_response :success
		assert_equal _("A comment was registered successfully!"), flash[:notice]

		#Edit comment at Warning Id = 2. Temporary save
		post "comment/add_or_edit/1/1?p1=2&sub_id=5&warning_id=2",
				 :risk_type_id					=> "1",
				 :warning_description 	=> "Warning example 2",
				 :sample_source_code		=> "Source code example 2",
				 :status								=> "false"
		assert_response :success
		get URL_WARNING_LIST_PAGE
		assert_response :success
		assert_equal _("A comment was registered successfully!"), flash[:notice]

		#Edit comment at Warning Id = 2. Regiter comment
		post "comment/add_or_edit/1/1?p1=2&sub_id=5&warning_id=2",
				 :risk_type_id					=> "1",
				 :warning_description 	=> "Warning example 1",
				 :sample_source_code		=> "Source code example 1",
				 :status								=> "true"
		assert_response :success
		get URL_WARNING_LIST_PAGE
		assert_response :success
		assert_equal _("A comment was registered successfully!"), flash[:notice]
	end

	def test_rsf_it_fa_080
		login
		# Display Comment Editor subwindow
		post "comment/view_comment_editor/1/1?p1=2&sub_id=5&warning_id=3"
		assert_response :success

		#Display Referred window
		post "comment/view_referred_comment_list/1/1?rule=2017&sub_id=5&warning_id=3"
		assert_select "input[type = 'button'][value = 'Cancel']"

    #Add and save a comment: Warning Id = 3
		get URL_WARNING_LIST_PAGE
		assert_response :success
		post "comment/add_or_edit/1/1?p1=2&sub_id=5&warning_id=3",
				 :risk_type_id					=> "1",
				 :warning_description 	=> "Warning example 3",
				 :sample_source_code		=> "Source code example 3",
				 :status								=> "true"
		assert_response :success

		#Display Referred window
		post "comment/view_referred_comment_list/1/1?rule=2017&sub_id=5&warning_id=3"
		assert_select "input[type = 'button'][value = 'OK']"
		assert_select "input[type = 'button'][value = 'Cancel']"

		#Display Comment Editor subwindow
		post "comment/view_comment_editor/1/1?p1=2&sub_id=5&warning_id=3"
		assert_response :success
		assert_select "a[class = 'delete_link']"

		#Delete comment at Warning Id = 3. [Delete] link in comment editor subwindow
		post "comment/delete/1/1?p1=2&sub_id=5&warning_id=3"
  	assert_response :success
		get URL_WARNING_LIST_PAGE
		assert_response :success
		assert_equal _("A comment was deleted successfully!"), flash[:notice]

		#Delete comment at Warning Id = 2. [Delete] link in warning page
		post "comment/delete/1/1?p1=2&sub_id=5&warning_id=2"
  	assert_response :success
		get URL_WARNING_LIST_PAGE
		assert_response :success
		assert_equal _("A comment was deleted successfully!"), flash[:notice]

	end
end
