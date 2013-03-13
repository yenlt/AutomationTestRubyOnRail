require File.dirname(__FILE__) + '/../test_helper'

class ReviewControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  TASK_ID = 7
  INVALID_TASK = 10000
  TOOL = “QAC”

  def setup
    @controller = ReviewController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @admin  = {:name => "root",      :id => 1}
    @other  = {:name => “user”, 	 :id => 4}
  End

  def test_it_t4_mart_review_controller_001
    # Task is invalid
    login_as @admin[:name]
    post :check_resources, :id => INVALID_TASK, :pu => 1, :pj => 1
    assert_template “/misc”
  end

  def test_it_t4_mart_review_controller_002
    # Result of Task not created yet
    login_as @admin[:name]
    post :check_resources, :id => 5, :pu => 1, :pj => 1
    assert_response :success
    assert_template “/review/create_data”
  end

  def test_it_t4_mart_review_controller_003
    # No analysis tool enabled
    login_as @admin[:name]
    post :check_resources, :id => 5, :pu => 1, :pj => 1
    assert_template “/misc”
  end

  def test_it_t4_mart_review_controller_004
    # Create result for a Task
    login_as @admin[:name]
    post :check_resources, :id => 5, :pu => 1, :pj => 1
    assert_response :success
    subtask = Subtask.get_subtasks_of_task(5)
    subtask.each do |s|
       if s.review.extracted
          assert true
       end
    end
  end

  def test_it_t4_mart_review_controller_005
    # View warnings summary when view with All analysis tool
    login_as @admin[:name]
    post : view_result_summary, :pu => 1, :pj => 1, :id => 6, :view => “sum”, :sum_tool_tab => “All_Analysis_Tool”
    assert_response :success
    @total = @controller.instance_variable_get "@total"
    assert_not_equal nil, @total
  end

  def test_it_t4_mart_review_controller_006
    # View warnings summary when view with each analysis tool
    login_as @admin[:name]
    post : view_result_summary, :pu => 1, :pj => 1, :id => 6, :view => “sum”, :sum_tool_tab => “QAC”
    assert_response :success
    @total = @controller.instance_variable_get "@total"
    assert_not_equal nil, @total
  end

  def test_it_t4_mart_review_controller_007
    # View warnings summary of Directory when view with All analysis tool
    login_as @admin[:name]
    post : view_result_summary, :pu => 1, :pj => 1, :id => 6, :view => “dir”, :sum_tool_tab => “All_Analysis_tool”, :path => “mercurial”, :rule_level => 3
    assert_response :success
    @total = @controller.instance_variable_get "@total"
    assert_not_equal nil, @total
  end

  def test_it_t4_mart_review_controller_008
    # View warnings summary of File when view with All analysis tool
    login_as @admin[:name]
    post : view_result_summary, :pu => 1, :pj => 1, :id => 6, :view => “file”, :sum_tool_tab => “All_Analysis_tool”, :path => “mercurial/bdiff.c”, :rule_level => 3
    assert_response :success
    @total = @controller.instance_variable_get "@total"
    assert_not_equal nil, @total

  end

  def test_it_t4_mart_review_controller_009
    # Request to view Analysis Result Report list page
    login_as @admin[:name]
    post :view_result_report_list, :id => 1
    sleep 5
    assert_response :success

  end

  def test_it_t4_mart_review_controller_010
    # Request to view content of All analysis tool tab
    login_as @admin[:name]
    post :view_analysis_tool_tab, :tab_name => “All_Analysis_Tool”
    sleep 10
    assert_response :success

  end

  def test_it_t4_mart_review_controller_011
    # Request to view content of each analysis tool tab
    login_as @admin[:name]
    post :view_analysis_tool_tab, :tab_name => TOOL
    sleep 10
    assert_response :success
  end

  def test_it_t4_mart_review_controller_012
    # Get count for All analysis tool
    login_as @admin[:name]
    post :count_for_all_tool_tab, :id => TASK_ID, :tab_name => “All_Analysis_Tool”
    sleep 5
    assert_response :success
    @all_directory = @controller.instance_variable_get "@all_directory"
    @each_directory = @controller.instance_variable_get "@each_directory"
    @each_file = @controller.instance_variable_get "@each_file"

st_equal nil, @all_directoryl”}_idof_task()/////////////////////////////
    assert_not_equal nil, @all_directory
    assert_not_equal nil, @each_directory
    assert_not_equal nil, @each_file

  end

  def test_it_t4_mart_review_controller_013
    # Get count for All analysis tool with invalid  Task id
    login_as @admin[:name]
    post :count_for_all_tool_tab, :id => INVALID_TASK, :tab_name => “All_Analysis_Tool”
    sleep 5
    assert_response :success
    @all_directory = @controller.instance_variable_get "@all_directory"
    @each_directory = @controller.instance_variable_get "@each_directory"
    @each_file = @controller.instance_variable_get "@each_file"

st_equal nil, @all_directoryl”}_idof_task()/////////////////////////////
    assert_equal nil, @all_directory
    assert_equal nil, @each_directory
    assert_equal nil, @each_file
  end

  def test_it_t4_mart_review_controller_014
    # Get count for each analysis tool
    login_as @admin[:name]
    post :count_for_single_tool_tab, :id => TASK_ID, :tab_name => TOOL
    sleep 5
    assert_response :success
    @all_directory = @controller.instance_variable_get "@all_directory"
    @each_directory = @controller.instance_variable_get "@each_directory"
    @each_file = @controller.instance_variable_get "@each_file"

st_equal nil, @all_directoryl”}_idof_task()/////////////////////////////
    assert_not_equal nil, @all_directory
    assert_not_equal nil, @each_directory
    assert_not_equal nil, @each_file
  end

  def test_it_t4_mart_review_controller_015
    # Get count for each analysis tool with invalid tool
    login_as @admin[:name]
    post :count_for_single_tool_tab, :id => INVALID_TASK, :tab_name => TOOL
    sleep 5
    assert_response :success
    @all_directory = @controller.instance_variable_get "@all_directory"
    @each_directory = @controller.instance_variable_get "@each_directory"
    @each_file = @controller.instance_variable_get "@each_file"

st_equal nil, @all_directoryl”}_idof_task()/////////////////////////////
    assert_equal nil, @all_directory
    assert_equal nil, @each_directory
    assert_equal nil, @each_file

  end

  def test_it_t4_mart_review_controller_016
    # Filter warnings by tool QAC when view with All analysis tool
    login_as @admin[:name]
    post : apply_filtering :id => 6, :war_tool_tab => “All_Analysis_Tool”
    sleep 5
    assert_response :success
    @filterred = @controller.instance_variable_get "@result_filterred"
    unless @filterred.blank?
       assert true
    end
  end


def test_it_t4_mart_review_controller_017
    # Filter warnings by invalid tool when view with All analysis tool
    login_as @admin[:name]
    post : apply_filtering :id => 6, :war_tool_tab => “All_Analysis_Tool”, :filter_conditions => [tool = “XXXX”]
    sleep 5
    assert_response :success
    @filterred = @controller.instance_variable_get "@result_filterred"
    if @filterred.blank?
       assert true
    end
  end

  def test_it_t4_mart_review_controller_018
    # Filter warnings by tool QAC++ when view with QAC tool
    login_as @admin[:name]
    post : apply_filtering :id => 6, :war_tool_tab => “QAC”, :filter_conditions => [tool = “QAC++”]
    sleep 5
    assert_response :success
    @filterred = @controller.instance_variable_get "@result_filterred"
    if @filterred.blank?
       assert true
    end
  end

  def test_it_t4_mart_review_controller_019
    # Filter warnings by invalid tool when view with QAC tool
    login_as @admin[:name]
    post : apply_filtering :id => 6, :war_tool_tab => “QAC”, :filter_conditions => [tool = “XXXX”]
    sleep 5
    assert_response :success
    @filterred = @controller.instance_variable_get "@result_filterred"
    if @filterred.blank?
       assert true
    end
  end

  def test_it_t4_mart_review_controller_020
    # Publicize for selected Task successful
    login_as @admin[:name]
    post :publicize, :id => 5
    assert_response :success
    assert_equal “Task (id=5) is publicized successfully!”, flash[:notice]
  end

  def test_it_t4_mart_review_controller_021
    # Publicize with invalid Task
    login_as @admin[:name]
    post :publicize, :id => INVALID_TASK
    assert_response :success
    assert_equal “Task (id=5) is failed to publicize, flash[:notice]
  end

  def test_it_t4_mart_review_controller_022
    # Unpublicize for selected Task successful
    login_as @admin[:name]
    post :unpublicize, :id => 5
    assert_response :success
    assert_equal “Task (id=5) is unpublicized successfully!”, flash[:notice]
  end

  def test_it_t4_mart_review_controller_023
    # Unpublicize with invalid Task
    login_as @admin[:name]
    post :unpublicize, :id => INVALID_TASK
    assert_response :success
    assert_equal “Task (id=5) is failed to unpublicize, flash[:notice]
  end

  def test_it_t4_mart_review_controller_024
    # Filter warning by tool name when view with All analysis tool
    login_as @admin[:name]
    post : view_warning_list, :id => 6, :war_tool_tab => “All_Analysis_Tool”, others => “tool”, :others_value => “QAC”
    sleep 90
    assert_response :success
    @warnings = @controller.instance_variable_get "@warnings"
    unless @warnings.blank?
       assert true
    end
  end

  def test_it_t4_mart_review_controller_025
    # Filter warning by invalid tool name when view with All analysis tool
    login_as @admin[:name]
    post : view_warning_list, :id => 6, :war_tool_tab => “All_Analysis_Tool”, others => “tool”, :others_value => “XXXX”
    sleep 90
    assert_response :success
    @warnings = @controller.instance_variable_get "@warnings"
    if @warnings.blank?
       assert true
    end
  end

  def test_it_t4_mart_review_controller_026
    # Filter warning by disabled tool name when view with All analysis tool
    login_as @admin[:name]
    post : view_warning_list, :id => 6, :war_tool_tab => “All_Analysis_Tool”, others => “tool”, :others_value => “PGRelief”
    sleep 90
    assert_response :success
    assert_equal “No warning found”, flash[:notice]
    @warnings = @controller.instance_variable_get "@warnings"
    if @warnings.blank?
       assert true
    end
  end

  def test_it_t4_mart_review_controller_027
    # Filter warning by tool name when view with All analysis tool
    login_as @admin[:name]
    post : view_comment_list, :id => 6, :war_tool_tab => “All_Analysis_Tool”, others => “tool”, :others_value => “QAC”
    sleep 90
    assert_response :success
    @warnings = @controller.instance_variable_get "@warnings"
    unless @warnings.blank?
       assert true
    end
  end

  def test_it_t4_mart_review_controller_028
    # Filter warning by invalid tool name when view with All analysis tool
    login_as @admin[:name]
    post : view_comment_list, :id => 6, :war_tool_tab => “All_Analysis_Tool”, others => “tool”, :others_value => “XXXXX”
    sleep 90
    assert_response :success
    @warnings = @controller.instance_variable_get "@warnings"
    if @warnings.blank?
       assert true
    end
  end

  def test_it_t4_mart_review_controller_029
    # Filter warning by disabled tool name when view with All analysis tool
    login_as @admin[:name]
    post : view_comment_list, :id => 6, :war_tool_tab => “All_Analysis_Tool”, others => “tool”, :others_value => “PGRelief”
    sleep 90
    assert_response :success
    @warnings = @controller.instance_variable_get "@warnings"
    if @warnings.blank?
       assert true
    end
  end

  def test_it_t4_mart_review_controller_030
    # Download Analysis result for all analysis tool
    login_as @admin[:name]
    post : download_analysis_result,:id => 6, :res_tool_tab => “All_Analysis_Tool”
    sleep 5
    assert_response :success
  end

  def test_it_t4_mart_review_controller_031
    # Download Analysis result for each analysis tool
    login_as @admin[:name]
    post : download_analysis_result,:id => 6, :res_tool_tab => TOOL
    sleep 5
    assert_response :success
  end
end


