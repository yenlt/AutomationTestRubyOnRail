require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < Test::Unit::TestCase
  include AuthenticatedTestHelper
	EXTRACTED_SUBTASK_ID = 10


	# test : count_on_file_by_rule_level_and_counter_task
	def test_ut_rsf10a_t3_com_001
		counter_task = [1]
		path_file = "sample_cpp/Common/src/AnzException.cpp"
		rule_level = "1"
		count_comments = Comment.count_on_file_by_rule_level_and_counter_task(EXTRACTED_SUBTASK_ID, path_file, rule_level, counter_task)
		assert_equal 1,count_comments
  end

	def test_ut_rsf10a_t3_com_002
		counter_task = [1,2]*','
		path_file = "sample_cpp/Common/src/AnzException.cpp"
		rule_level = "1"
		count_comments = Comment.count_on_file_by_rule_level_and_counter_task(EXTRACTED_SUBTASK_ID, path_file, rule_level, counter_task)
		assert_equal 4,count_comments
  end

	def test_ut_rsf10a_t3_com_003
		counter_task = [1,2]*','
		path_file = "sample_cpp/Common/src/AnzException.cpp"
		rule_level = "-1"
		count_comments = Comment.count_on_file_by_rule_level_and_counter_task(EXTRACTED_SUBTASK_ID, path_file, rule_level, counter_task)
		assert_equal 0,count_comments
  end

	def test_ut_rsf10a_t3_com_004
		counter_task = [1,2]*','
		path_file = "abc/def/ghi/jkl"
		rule_level = "1"
		count_comments = Comment.count_on_file_by_rule_level_and_counter_task(EXTRACTED_SUBTASK_ID, path_file, rule_level, counter_task)
		assert_equal 0,count_comments
  end

	def test_ut_rsf10a_t3_com_005
		counter_task = [1,2]*','
		path_file = "abc/def/ghi/jkl"
		rule_level = "-1"
		count_comments = Comment.count_on_file_by_rule_level_and_counter_task(EXTRACTED_SUBTASK_ID, path_file, rule_level, counter_task)
		assert_equal 0,count_comments
  end

	def test_ut_rsf10a_t3_com_006
		counter_task = [-1]
		path_file = "abc/def/ghi/jkl"
		rule_level = "1"
		count_comments = Comment.count_on_file_by_rule_level_and_counter_task(EXTRACTED_SUBTASK_ID, path_file, rule_level, counter_task)
		assert_equal 0,count_comments
  end

	#test : count_on_directory_by_rule_level_and_counter_task
	def test_ut_rsf10a_t3_com_007
		directory_id = 26
		rule_level = "1"
		counter_task = [1]
		count_comments = Comment.count_on_directory_by_rule_level_and_counter_task(EXTRACTED_SUBTASK_ID, directory_id, '1', counter_task)
		assert_equal 3,count_comments
  end

	def test_ut_rsf10a_t3_com_008
		directory_id = 26
		rule_level = "1"
		counter_task = [1,2]*','
		count_comments = Comment.count_on_directory_by_rule_level_and_counter_task(EXTRACTED_SUBTASK_ID, directory_id, '1', counter_task)
		assert_equal 6,count_comments
  end

	def test_ut_rsf10a_t3_com_009
		directory_id = -1
		rule_level = "1"
		counter_task = [1,2]*','
		count_comments = Comment.count_on_directory_by_rule_level_and_counter_task(EXTRACTED_SUBTASK_ID, directory_id, '1', counter_task)
		assert_equal 0,count_comments
  end

	def test_ut_rsf10a_t3_com_010
		directory_id = -1
		rule_level = "-1"
		counter_task = [1,2]*','
		count_comments = Comment.count_on_directory_by_rule_level_and_counter_task(EXTRACTED_SUBTASK_ID, directory_id, '1', counter_task)
		assert_equal 0,count_comments
  end

	def test_ut_rsf10a_t3_com_011
		directory_id = 26
		rule_level = "1"
		counter_task = [-1]
		count_comments = Comment.count_on_directory_by_rule_level_and_counter_task(EXTRACTED_SUBTASK_ID, directory_id, '1', counter_task)
		assert_equal 0,count_comments
  end

	    # Valid input
  def test_ut_rsf10a_t3_com_012
    # gets a list of comments
    comments = Comment.paginate_by_pj_id_and_rule(1,
                                                  "2017",
                                                  1)

    # all comments belong to a PJ, their warnings have the same rule: "2017", and they are registered
    comments.each do |comment|
      assert_equal(5,
                   comment.warning.subtask_id)

      assert_equal("2017",
                   Warning.find_by_id(comment.warning_id).rule)

      assert_equal(true, comment.status)
    end
  end

   # Invalid pj_id
  def test_ut_rsf10a_t3_com_013
    # gets a list of comments
    comments = Comment.paginate_by_pj_id_and_rule(-1,
                                                  "2017",
                                                  1)


    # an empty list
    assert_equal(0, comments.count)
  end

   # Invalid rule
  def test_ut_rsf10a_t3_com_014
    # gets a list of comments
    comments = Comment.paginate_by_pj_id_and_rule(1,
                                                  "-1",
                                                  1)


    # an empty list
    assert_equal(0, comments.size)
  end

   # Page <= 0
  def test_ut_rsf10a_t3_com_015
    begin
      # gets a list of comments
      comments = Comment.paginate_by_pj_id_and_rule(1,
                                                    "2017",
                                                    0)
    rescue => error
      assert_equal("0 given as value, which translates to '0' as page number",error.message)
    end
  end

   # Page exceeds the maximum value
  def test_ut_rsf10a_t3_com_016
    # gets a list of comments
    comments = Comment.paginate_by_pj_id_and_rule(1,
                                                  "2017",
                                                  1000)


    # an empty list
    assert_equal(0,
                 comments.size)
  end

	    # Valid input
  def test_ut_bec10a_t4_com_01
    # gets a list of comments
    comments = Comment.bulk_paginate_by_pj_id_and_rule(1,
                                                  "2017",
                                                  1)

    # all comments belong to a PJ, their warnings have the same rule: "2017", and they are registered
    comments.each do |comment|
      assert_equal(5,
                   comment.warning.subtask_id)

      assert_equal("2017",
                   Warning.find_by_id(comment.warning_id).rule)

      assert_equal(true, comment.status)
    end
  end

   # Invalid pj_id
  def test_ut_bec10a_t4_com_02
    # gets a list of comments
    comments = Comment.bulk_paginate_by_pj_id_and_rule(-1,
                                                  "2017",
                                                  1)


    # an empty list
    assert_equal(0, comments.count)
  end

   # Invalid rule
  def test_ut_bec10a_t4_com_03
    # gets a list of comments
    comments = Comment.bulk_paginate_by_pj_id_and_rule(1,
                                                  "-1",
                                                  1)


    # an empty list
    assert_equal(0, comments.size)
  end

   # Page <= 0
  def test_ut_bec10a_t4_com_04
    begin
      # gets a list of comments
      comments = Comment.bulk_paginate_by_pj_id_and_rule(1,
                                                    "2017",
                                                    0)
    rescue => error
      assert_equal("0 given as value, which translates to '0' as page number",error.message)
    end
  end

   # Page exceeds the maximum value
  def test_ut_bec10a_t4_com_05
    # gets a list of comments
    comments = Comment.bulk_paginate_by_pj_id_and_rule(1,
                                                  "2017",
                                                  1000)


    # an empty list
    assert_equal(0,
                 comments.size)
  end

  ## Test update_status(status_id)
  #
  # + Comment is temporary saved.
  # + status_id is new.
  def test_ut_bec10a_t4_com_06
    #create a temporary saved comment with a status_id
    comment = Comment.create( :status       => 0,
                                  :risk_type_id => 1)
    begin
      comment.update_status(2)
      comment.save
      assert_equal(comment.status, 1)
      assert_equal(comment.risk_type_id, 2)
    rescue => err
    end
    comment.delete
  end
  # + Comment is temporary saved.
  # + status_id is the same.
  def test_ut_bec10a_t4_com_07
    #create a temporary saved comment with a status_id
    comment = Comment.create( :status       => 0,
                                  :risk_type_id => 1)
    begin
      comment.update_status(1)
      comment.save
      assert_equal(comment.status, 1)
      assert_equal(comment.risk_type_id, 1)
    rescue => err
    end
    comment.delete
  end
  # + Comment is saved.
  # + status_id is new.
  def test_ut_bec10a_t4_com_08
    #create a saved comment with a status_id
    comment = Comment.create( :status       => 1,
                              :risk_type_id => 1)
    begin
      comment.update_status(2)
      comment.save
      assert_equal(comment.status, 1)
      assert_equal(comment.risk_type_id, 2)
    rescue => err
    end
    comment.delete
  end
  # + Comment is saved.
  # + status_id is the same.
  def test_ut_bec10a_t4_com_09
    #create a saved comment with a status_id
    comment = Comment.create( :status       => 1,
                              :risk_type_id => 1)
    begin
      comment.update_status(1)
      comment.save
      assert_equal(comment.status, 1)
      assert_equal(comment.risk_type_id, 1)
    rescue => err
    end
    comment.delete
  end

  ## Test create_new_with_status(status_id, warning_id)
  #
  def test_ut_bec10a_t4_com_10
    comment = Comment.new
    begin
      comment.create_new_with_status(1, 1234)
      comment.save
      assert_equal(comment.status, 1)
      assert_equal(comment.warning_description, "")
      assert_equal(comment.sample_source_code, "")
    rescue => err
    end
    comment.delete
  end
end