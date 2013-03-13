require File.dirname(__FILE__) + '/../test_helper'
require 'diff/lcs/array'

class DiffResultTest < ActiveSupport::TestCase
  fixtures :diff_results
  fixtures :original_files
  fixtures :subtasks
  
  def setup
    @diff_result = DiffResult.new( :old_task_id =>3,
      :new_task_id =>1,
      :new_pu_id =>1,
      :new_pj_id =>1,
      :analyze_tool_id =>1,
      :diff_state_id =>5,
      :old_pu_id =>1,
      :old_pj_id =>1 )
  end

  def test_000
    import_sql
  end
  
  #test the validations inside the model
  def test_ut_diff_result_01
    diff_result = diff_results(:diff_results_001)
    assert diff_result.save
    diff_result_copy = DiffResult.find(diff_result.id)
    assert_equal diff_result.old_pu_id, diff_result_copy.old_pu_id
    assert diff_result.valid?
    assert diff_result.destroy
  end

  #test initialization of diffresult'model.
  def test_ut_diff_result_02
    first_diffresult = DiffResult.new(
      :old_pj_id => 10,
      :old_pu_id => 349898,
      :old_task_id => 4564,
      :new_pu_id => 2,
      :new_pj_id => 3,
      :new_task_id => 1,
      :analyze_tool_id => 4,
      :diff_state_id => 5
    )
    assert_equal(10,first_diffresult.old_pj_id)
    assert_equal(349898,first_diffresult.old_pu_id)
    assert_equal(4564,first_diffresult.old_task_id)
    assert_equal(2,first_diffresult.new_pu_id)
    assert_equal(3,first_diffresult.new_pj_id)
    assert_equal(4,first_diffresult.analyze_tool_id)
    assert_equal(5,first_diffresult.diff_state_id)
    assert_equal(1,first_diffresult.new_task_id)

  end
  
  # Test function extract_data
  #test case: subtask != nil & !subtask.review = 1
  # this test case: there is a recode in table original file is created.
  #  this test case don't need load fixture:review
  def test_ut_diff_result_extract_data_03
    diff_result = diff_results(:diff_results_001)

    subtask_old = Subtask.find_by_task_id_and_analyze_tool_id(diff_result.old_task_id,diff_result.analyze_tool_id)
    assert_not_nil(subtask_old)
    subtask_new = Subtask.find_by_task_id_and_analyze_tool_id(diff_result.new_task_id,diff_result.analyze_tool_id)
    assert_not_nil(subtask_new)
    diff_result.extract_data
    review_old = Review.find(:all,
      :conditions => {
        :subtask_id => subtask_old.id,
        :extracted  => 1,
        :analyzed => 1}
    )
    assert_not_equal [],review_old
    old_original_file = OriginalFile.find(:all,
      :conditions => {
        :subtask_id => subtask_old.id,
        :source_name => "analyzeme.c",
        :path => "sample_c/src",
        :normal_result_id => 69,
        :hirisk_result_id => 68,
        :critical_result_id => 67}
    )
    assert_not_equal [],old_original_file
    review_new = Review.find(:all,
      :conditions => { :subtask_id => subtask_new.id,
        :extracted  => 1,
        :analyzed => 1}
    )
    assert_not_equal [],review_new
    new_original_file = OriginalFile.find(:all,
      :conditions => {
        :subtask_id => subtask_new.id,
        :source_name => "analyzeme.c",
        :path => "sample_c/src",
        :normal_result_id => 9,
        :hirisk_result_id => 8,
        :critical_result_id => 7}
    )
    assert_not_equal [],new_original_file
  end

  # Test case: subtask != nil & subtask.review = 1
  # this case test that: there is a recode in table original file is created.
  # don't exit  a recode in table Review that its subtask_id fild = subtask's id
  # and then there is a recode in table Review that its subtask_id fild = subtask's id  
  def test_ut_diff_result_extract_data_04
    diff_result = diff_results(:diff_results_001)
    subtask_old = Subtask.find_by_task_id_and_analyze_tool_id(diff_result.old_task_id,diff_result.analyze_tool_id)
    subtask_new = Subtask.find_by_task_id_and_analyze_tool_id(diff_result.new_task_id,diff_result.analyze_tool_id)
    diff_result.extract_data
    review_old = Review.find(:all,
      :conditions => {
        :subtask_id => subtask_old.id,
        :extracted  => 1,
        :analyzed => 1}
    )
    assert_not_equal [],review_old
    old_original_file = OriginalFile.find(:all,
      :conditions => {
        :subtask_id => subtask_old.id,
        :source_name => "analyzeme.c",
        :path => "sample_c/src",
        :normal_result_id => 69,
        :hirisk_result_id => 68,
        :critical_result_id => 67}
    )
    assert_not_equal [],old_original_file
    review_new = Review.find(:all,
      :conditions => { :subtask_id => subtask_new.id,
        :extracted  => 1,
        :analyzed => 1}
    )
    assert_not_equal [],review_new
    new_original_file = OriginalFile.find(:all,
      :conditions => {
        :subtask_id => subtask_new.id,
        :source_name => "analyzeme.c",
        :path => "sample_c/src",
        :normal_result_id => 9,
        :hirisk_result_id => 8,
        :critical_result_id => 7}
    )
    assert_not_equal [],new_original_file
  end

  # Test function: get_diff_files
  # there is a recode in table diff file is created.
  #  require load fixture :original_file
  def test_ut_diff_result_get_diff_files_05
    diff_result = diff_results(:diff_results_001)
    old_subtask = Subtask.find_by_task_id_and_analyze_tool_id(diff_result.old_task_id,diff_result.analyze_tool_id)
    new_subtask = Subtask.find_by_task_id_and_analyze_tool_id(diff_result.new_task_id,diff_result.analyze_tool_id)
    diff_result.get_diff_files
    old_original_file =  OriginalFile.find_by_subtask_id(old_subtask.id)
    new_original_file = OriginalFile.find_by_subtask_id(new_subtask.id)
    diff_file =     DiffFile.find(:all,
      :conditions => { :diff_result_id => diff_result.id ,
        :old_original_file_id => old_original_file.id,
        :new_original_file_id => new_original_file.id }
    )
    assert_not_equal [],diff_file
  end

  # Test function get_diff_result_list.
  # id of the user is “1”, version of the task that the user want to sort is “new”,
  # the field that want to sort is “nil”, the direction that the user want to sort is “ASC”
  def test_ut_diff_result_get_diff_result_list_06
    all_diff_results = DiffResult.get_diff_result_list(1, "new", nil)
    i = 0
    all_diff_results.each do |t|
      t.each do |key,value|
        test_case_get_diff_result_old(i,key,value)
      end
      i = i+1
    end
  end
 
  # id of the user is “1”, version of the task that the user want to sort is “new”,
  # the field that want to sort is “pus.name”, the direction that the user want to sort is “ASC”
  def test_ut_diff_result_get_diff_result_list_07
    all_diff_results_1 = DiffResult.get_diff_result_list(1, "new",
      DiffState::DIFF_COMPLETED, "pus.name","ASC")
    k = 0
    all_diff_results_1.each do |t|
      t.each do |key,value|
        test_case_get_diff_result_old(k,key,value)
      end
      k = k+1
    end
  end
 
  # id of the user is “1”, version of the task that the user want to sort is “new”,
  # the field that want to sort is “old”, the direction that the user want to sort is “ASC”
  def test_ut_diff_result_get_diff_result_list_08
    all_diff_results_2 = DiffResult.get_diff_result_list(1, "old")
    n = 0
    all_diff_results_2.each do |t|
      t.each do |key,value|
        test_case_get_diff_result_old(n,key,value)
      end
      n = n+1
    end
  end

  # id of the user is “1”, version of the task that the user want to sort is “old”,
  # the field that want to sort is “old”, the direction that the user want to sort is “DESC”
  def test_ut_diff_result_get_diff_result_list_9
    all_diff_results_3 = DiffResult.get_diff_result_list(1,"old",
      DiffState::DIFF_COMPLETED, "pus.name","DESC")
    p = 0
    all_diff_results_3.each do |t|
      t.each do |key,value|
        test_case_get_diff_result_old(p,key,value)
      end
      p = p+1
    end
  end
  def test_case_get_diff_result_old(i,key,value)
    case i
    when 0
      case key
      when "task1"
        assert_equal value,"sample_c_cpp_1_1"
      when "new_pj"
        assert_equal value,"SamplePJ1"
      when "tool"
        assert_equal value,"QAC"
      when "old_task"
        assert_equal value,"test1"
      end
    when 1
      case key
      when "task1"
        assert_equal value,"sample_c_cpp_1_1"
      when "new_pj"
        assert_equal value,"SamplePJ1"
      when  "tool"
        assert_equal value,"QAC++"
      when "old_task"
        assert_equal value,"sample_c_cpp_1_1"
      end
    end
  end
end

