require File.dirname(__FILE__) + '/../test_helper'

class ReviewTest < Test::Unit::TestCase
  include AuthenticatedTestHelper
  PUBLICIZED_TASK   = 1
  UNPUBLICIZED_TASK = 2
  NOT_CREATED_TASK  = 3
  INVALID_TASK      = 10000
  def test_ut_mart_t4_review_001
      #test data of selected task created and unpublicized
      check = Review.check_review_task(UNPUBLICIZED_TASK)
      assert_equal 1, check
  end

  def test_ut_mart_t4_review_002
      #test data of selected task created and publicized
      check = Review.check_review_task(PUBLICIZED_TASK)
      assert_equal 2, check
  end

  def test_ut_mart_t4_review_003
      #Data of selected task has not created yet
      check = Review.check_review_task(NOT_CREATED_TASK)
      assert_equal 3, check
  end

  def test_ut_mart_t4_review_004
      #Data of selected task has not created yet
      check = Review.check_review_task(INVALID_TASK)
      assert_equal 0, check
  end
end