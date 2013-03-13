require File.dirname(__FILE__) + '/../test_helper'

class SubtaskTest < ActiveSupport::TestCase
  include AuthenticatedTestHelper
  UNEXTRACTED_SUBTASK = 7
  EXTRACTED_SUBTASK = 11
  ## setup
  def setup
    @unextracted_subtask = Subtask.find_by_id(UNEXTRACTED_SUBTASK)
    @extracted_subtask = Subtask.find_by_id(EXTRACTED_SUBTASK)
  end
  ## teardown
  def teardown
  end
  ## load fixtures
  def test_ut_rsf10a_t3_sub_000
    #system "rake db:fixtures:load"
  end
  ## Test: create_results
  #  - subtask is unextracted
  def test_ut_rsf10a_t3_sub_001
    assert_nil(Result.find_by_subtask_id(UNEXTRACTED_SUBTASK))
    assert_nil(Summary.find_by_subtask_id(UNEXTRACTED_SUBTASK))
    @unextracted_subtask.create_results
    assert_not_nil(Result.find_by_subtask_id(UNEXTRACTED_SUBTASK))
    assert_not_nil(Summary.find_by_subtask_id(UNEXTRACTED_SUBTASK))
  end
  ## Test: create_results
  #  - subtask is extracted
  def test_ut_rsf10a_t3_sub_002
    old_results = Result.find_all_by_subtask_id(EXTRACTED_SUBTASK)
    old_summaries = Summary.find_all_by_subtask_id(EXTRACTED_SUBTASK)
    @extracted_subtask.create_results
    new_results = Result.find_all_by_subtask_id(EXTRACTED_SUBTASK)
    new_summaries = Summary.find_all_by_subtask_id(EXTRACTED_SUBTASK)
    ## assert
    assert_equal old_results.size, new_results.size
    assert_equal old_summaries.size, new_summaries.size
  end
  ## Test: generate_result
  #  - subtask is unextracted
  def test_ut_rsf10a_t3_sub_003
    assert_nil(Result.find_by_subtask_id(UNEXTRACTED_SUBTASK))
    @unextracted_subtask.generate_result
    assert_not_nil(Result.find_by_subtask_id(UNEXTRACTED_SUBTASK))
  end
  ## Test: generate_result
  #  - subtask is extracted
  def test_ut_rsf10a_t3_sub_004
    old_results = Result.find_all_by_subtask_id(EXTRACTED_SUBTASK)
    @extracted_subtask.generate_result
    new_results = Result.find_all_by_subtask_id(EXTRACTED_SUBTASK)
    assert_equal old_results.size, new_results.size
  end
  ## Test: source_files_from_warnings
  #
  def test_ut_rsf10a_t3_sub_005
    source_files = @unextracted_subtask.source_files_from_warnings
    assert_not_nil source_files
    random_number = rand(source_files.size)
    assert_not_nil(source_files[random_number]["path"])
    assert_not_nil(source_files[random_number]["name"])
  end
  ## Test: rule_level_name
  #
  def test_ut_rsf10a_t3_sub_006
    ## Normal
    normal_name = @unextracted_subtask.rule_level_name(1)
    assert_equal(".Normal.html",normal_name)
    ## Hirisk
    hirisk_name = @unextracted_subtask.rule_level_name(2)
    assert_equal(".Hirisk.html",hirisk_name)
    hirisk_name = @unextracted_subtask.rule_level_name(3)
    assert_equal(".Critical.html",hirisk_name)
  end
  ## Test: publicize
  #  - No comment
  #
  def test_ut_rsf10a_t3_sub_007
    ## initialize
    old_result_body = []
    new_result_body = []
    ## get old value
    (1..3).each do |rule_level|
      old_result_body[rule_level] = Result.find_by_subtask_id_and_rule_set(EXTRACTED_SUBTASK,rule_level).updated_at
    end
    ## unpublicize
    @extracted_subtask.publicize
    ## get new value
    (1..3).each do |rule_level|
      new_result_body[rule_level] = Result.find_by_subtask_id_and_rule_set(EXTRACTED_SUBTASK,rule_level).updated_at
      assert_equal(old_result_body[rule_level], new_result_body[rule_level])
    end
  end
  ## Test: publicize
  #  - Normal, Hirisk and Critical wanrings is commented
  #  -
  def test_ut_rsf10a_t3_sub_008_010
    ## initialize
    old_result_body = []
    new_result_body = []
    source_path     = []
    source_name     = []
    ## create comment
    (1..3).each do |rule_level|
      warning = Warning.find_by_subtask_id_and_rule_level(EXTRACTED_SUBTASK,rule_level)
      source_path[rule_level] = warning.source_path
      source_name[rule_level] = warning.source_name
      ##
      new_comment = Comment.new
      new_comment.risk_type_id = 1
      new_comment.status = 1
      new_comment.warning_id = warning.id
      new_comment.warning_description = "sample description"
      new_comment.sample_source_code = "sample sample source code"
      new_comment.save!
      ## get old value
      old_result_body[rule_level] = Result.find_by_subtask_id_and_rule_set_and_path_and_source_name(EXTRACTED_SUBTASK,rule_level,source_path[rule_level],source_name[rule_level]).updated_at
    end
    ## extract
    @extracted_subtask.publicize
    ## get new value
    (1..3).each do |rule_level|
      new_result_body[rule_level] = Result.find_by_subtask_id_and_rule_set_and_path_and_source_name(EXTRACTED_SUBTASK,rule_level,source_path[rule_level],source_name[rule_level]).updated_at
      assert_not_equal(old_result_body[rule_level], new_result_body[rule_level])
    end
  end
  ## Test: unpublicize
  #  - No comment
  #
  def test_ut_rsf10a_t3_sub_011
    ## initialize
    old_result_body = []
    new_result_body = []
    ## publicize
    @extracted_subtask.publicize
    ## get old value
    (1..3).each do |rule_level|
      old_result_body[rule_level] = Result.find_by_subtask_id_and_rule_set(EXTRACTED_SUBTASK,rule_level).updated_at
    end
    ## unpublicize
    @extracted_subtask.unpublicize
    ## get new value
    (1..3).each do |rule_level|
      new_result_body[rule_level] = Result.find_by_subtask_id_and_rule_set(EXTRACTED_SUBTASK,rule_level).updated_at
      assert_equal(old_result_body[rule_level], new_result_body[rule_level])
    end
  end
  ## Test: unpublicize
  #  - Normal, Hirisk and Critical wanrings is commented
  #  -
  def test_ut_rsf10a_t3_sub_012_014
    ## initialize
    old_result_body = []
    new_result_body = []
    source_path     = []
    source_name     = []
    ## create comment
    (1..3).each do |rule_level|
      warning = Warning.find_by_subtask_id_and_rule_level(EXTRACTED_SUBTASK,rule_level)
      source_path[rule_level] = warning.source_path
      source_name[rule_level] = warning.source_name
      ##
      new_comment = Comment.new
      new_comment.risk_type_id = 1
      new_comment.status = 1
      new_comment.warning_id = warning.id
      new_comment.warning_description = "sample description"
      new_comment.sample_source_code = "sample sample source code"
      new_comment.save!
    end
    ## publicize
    @extracted_subtask.publicize
    sleep 2
    ## get old value
    (1..3).each do |rule_level|
      old_result_body[rule_level] = Result.find_by_subtask_id_and_rule_set_and_path_and_source_name(EXTRACTED_SUBTASK,rule_level,source_path[rule_level],source_name[rule_level]).updated_at
    end
    ## extract
    @extracted_subtask.unpublicize
    ## get new value
    (1..3).each do |rule_level|
      new_result_body[rule_level] = Result.find_by_subtask_id_and_rule_set_and_path_and_source_name(EXTRACTED_SUBTASK,rule_level,source_path[rule_level],source_name[rule_level]).updated_at
      assert_not_equal(old_result_body[rule_level], new_result_body[rule_level])
    end
  end
  ## Test: get_comment_list
  #
  def test_ut_rsf10a_t3_sub_015
    ## create comment
    (1..3).each do |rule_level|
      warning = Warning.find_by_subtask_id_and_rule_level(EXTRACTED_SUBTASK,rule_level)
      new_comment = Comment.new
      new_comment.risk_type_id = 1
      new_comment.status = 1
      new_comment.warning_id = warning.id
      new_comment.warning_description = "sample description"
      new_comment.sample_source_code = "sample sample source code"
      new_comment.save!
    end
    ## Some comments
    comment_list = @extracted_subtask.get_comment_list
    assert_not_nil comment_list
  end
  ## Test: get_comment_list
  #
  def test_ut_rsf10a_t3_sub_016
    ## no comment
    Comment.delete_all
    comment_list = @extracted_subtask.get_comment_list
    assert_equal comment_list,[]
  end
end
