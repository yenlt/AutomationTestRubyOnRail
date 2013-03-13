require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../integration/setup'
require 'comment_controller'

class CommentControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  WARNINGS = ["3399", "3400","3405", "3426"]
  RULES    = ["3305", "3347", "703", "3408"]
  def setup
    @controller = CommentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @admin  = {:name => "root",      :id => 1}
    @member = {:name => "pj_member", :id => 2}
  end
  
  def test_it_t4_mart_comment_controller_001
    login_as @admin[:name]
    post :bulk_view_referred_comment_list,
         :pu=>1, :pj=>1, :id=>1, :p1=>2,
         :warnings => WARNINGS,
         :rules => RULES,
         :war_tool_tab => "All_Analysis_Tool"

    sleep 10
    assert_response :success
    @comments = @controller.instance_variable_get "@comments"
    unless @comments.blank?
      assert true
    end
  end

  def test_it_t4_mart_comment_controller_002
    login_as @admin[:name]
    post :bulk_view_referred_comment_list,
         :pu=>1, :pj=>1, :id=>1, :p1=>2,
         :warnings => WARNINGS,
         :rules => RULES,
         :war_tool_tab => "QAC"

    sleep 10
    assert_response :success
    @comments = @controller.instance_variable_get "@comments"
    unless @comments.blank?
      assert true
    end
  end

  def test_it_t4_mart_comment_controller_003
    login_as @admin[:name]
    post :bulk_view_referred_comment_list,
         :pu=>1, :pj=>1, :id=>1, :p1=>2,
         :warnings => WARNINGS,
         :rules => RULES,
         :war_tool_tab => "XXXX"

    sleep 10
    assert_response :success
    @comments = @controller.instance_variable_get "@comments"
    if @comments.blank?
      assert true
    end
  end
end
