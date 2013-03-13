require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < Test::Unit::TestCase
  include AuthenticatedTestHelper
  RULE = [3305, 3347]
	    # Valid input
  def test_ut_t4_mart_comment_001
    # gets a list of comments
    comments = Comment.paginate_by_pj_id_and_rule(1,
                                                  RULE,
                                                  1)

    # all comments belong to a PJ, their warnings have the same rule: "2017", and they are registered
    comments.each do |comment|
      assert_equal(1,
                   comment.warning.subtask_id)
      assert_equal(true, comment.status)
    end
  end

   # Invalid pj_id
  def test_ut_t4_mart_comment_002
    # gets a list of comments with invalid pj id
    comments = Comment.paginate_by_pj_id_and_rule(-1,
                                                  RULE,
                                                  1)


    # an empty list
    assert_equal(0, comments.count)
  end

   # Invalid rule
  def test_ut_t4_mart_comment_003
    # gets a list of comments with invalid rule
    comments = Comment.paginate_by_pj_id_and_rule(1,
                                                  [-1, -1],
                                                  1)


    # an empty list
    assert_equal(0, comments.size)
  end
end