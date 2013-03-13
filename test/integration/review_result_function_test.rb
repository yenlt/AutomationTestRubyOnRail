require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../integration/setup'
require 'diff_controller'
require 'review_controller'

class ReviewResultFunctionTest < ActionController::IntegrationTest

  Admin_login = "root"
  Admin_pass  = "root"
  Pj_member   = "pj_member"

  VIEW_RESULT_REPORT        = "review/view_result_report"
  ANALYSIS_RESULT_REPORT    = "diff/_analysis_report_list_file_content.rhtml"

  def test_it_rrf10b_t3_001
    get VIEW_RESULT_REPORT
    assert_redirected_to :controller => "auth", :action => "login"
  end

  def test_it_rrf10b_t3_002
    login(Admin_login, Admin_pass)
    get url_for(:controller => "review",
        :action     => "view_result_report",
        :pu         => 1,
        :pj         => 2,
        :id         => 6,
        :sub_id     => 11,
        :result_id  => 825)
      
    assert_response :success
    assert_template VIEW_RESULT_REPORT
  end

  def test_it_rrf10b_t3_003
    login(Pj_member, Pj_member)
    get url_for(:controller => "review",
        :action     => "view_result_report",
        :pu         => 1,
        :pj         => 2,
        :id         => 6,
        :sub_id     => 11,
        :result_id  => 825)
          
    assert_response :success
    assert_template VIEW_RESULT_REPORT
  end

  def test_it_rrf10b_t3_004
    login(Admin_login, Admin_pass)
    get url_for(:controller => "review",
        :action     => "view_result_report",
        :pu         => 1,
        :pj         => 2,
        :id         => 4,
        :sub_id     => 7,
        :result_id  => 831)

    assert_response :success
    assert_template VIEW_RESULT_REPORT
  end

  def test_it_rrf10b_t3_005
    login(Pj_member, Pj_member)
    get url_for(:controller => "review",
        :action     => "view_result_report",
        :pu         => 1,
        :pj         => 2,
        :id         => 4,
        :sub_id     => 7,
        :result_id  => 831)

    assert_response :success
    assert_template VIEW_RESULT_REPORT
  end

  def test_it_rrf10b_t3_006
    get "diff/analysis_report_with_diff"
    assert_redirected_to :controller => "auth", :action => "login"
  end

  def test_it_rrf10b_t3_007
    login(Admin_login, Admin_pass)
    get url_for(:controller => "diff",
        :action     => "filter_by_rule_level",
        :pu         => 1,
        :pj         => 2,
        :diff_id      => 9,
        :diff_file_id => 9)

    assert_response :success
    assert_template ANALYSIS_RESULT_REPORT
  end

  def test_it_rrf10b_t3_008
    login(Admin_login, Admin_pass)
    get url_for(:controller => "diff",
        :action     => "filter_by_rule_level",
        :pu         => 1,
        :pj         => 2,
        :diff_id      => 9,
        :diff_file_id => 9,
        :rule_level   => 2)

    assert_response :success
    assert_template ANALYSIS_RESULT_REPORT
  end
end