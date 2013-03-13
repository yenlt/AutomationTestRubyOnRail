require File.dirname(__FILE__) + '/../test_helper'

class WarningTest < Test::Unit::TestCase
  def setup
    warning = Warning.find(1)
    warning.comment = Comment.create(:risk_type_id        => 1,
                                     :warning_id          => warning.id,
                                     :warning_description => "original description for warning (#{warning.id})",
                                     :sample_source_code  => "original sample source code for warning (#{warning.id})",
                                     :status              => true)
  end

  def teardown
    Comment.delete_all
  end

#  def test_000
#    import_sql
#  end

   # Valid inputs
  def test_ut_rsf10a_t3_wam_01_001
    # gets a list of warnings from database
    warnings = Warning.paginate_by_subtask_id(5,
                                              1,
                                              "",
                                              "",
                                              "",
                                              "",
                                              false,
                                              false)

    # there are 10 warnings in this list
    assert(warnings.size == Warning.per_page)

    # all these warnings belong to analysis results of a subtask (id = 5)
    subtask = Subtask.find(5)
    warnings.each do |warning|
       assert(subtask == warning.subtask)
    end
  end

 # Valid inputs. But the subtask has no warning
 # But now, we don't have data for this test case. so we choose one Invalid subtask_id
  def test_ut_rsf10a_t3_wam_01_002
    # gets a list of warnings from database
    warnings = Warning.paginate_by_subtask_id(3,
                                              1,
                                              "",
                                              "",
                                              "",
                                              "",
                                              false,
                                              false)

    # the list must be empty
     assert(warnings.size == 0)
  end

  #Invalid subtask_id
  def test_ut_rsf10a_t3_wam_01_003
    # gets a list of warnings from database
    warnings = Warning.paginate_by_subtask_id(15,
                                              1,
                                              "",
                                              "",
                                              "",
                                              "",
                                              false,
                                              false)

    # the list must be empty
    assert(warnings.size == 0)
  end

   # Invalid page. Page <= 0
  def test_ut_rsf10a_t3_wam_01_004
    # gets a list of warnings from database
    begin
    Warning.paginate_by_subtask_id(1,
                                   0,
                                   "",
                                   "",
                                   "",
                                   "",
                                   false,
                                   false)
    rescue => error
      assert_equal(error.message,
                   "0 given as value, which translates to '0' as page number")
    end
  end

   #Invalid page which exceeds the maximum value
  def test_ut_rsf10a_t3_wam_01_005
    # gets a list of warnings from database
    warnings = Warning.paginate_by_subtask_id(5,
                                              388,
                                              "",
                                              "",
                                              "",
                                              "",
                                              false,
                                              false)

    # the list must be empty
    assert(warnings.size == 0)
  end

    #Valid inputs
  def test_ut_rsf10a_t3_wam_01_006
    # gets a list of warnings from database
    warnings = Warning.paginate_by_subtask_id(5,
                                              1,
                                              "row",
                                              "asc",
                                              "",
                                              "",
                                              false,
                                              false)

    # the list must be not empty
    assert(warnings.size != 0)

    # the list must be ordered incrementally by values of "warnings.row"
    (1..warnings.size - 1).each do |i|
      assert(warnings[i].row >= warnings[i-1].row)
    end
  end

   #Invalid order_field
  def test_ut_rsf10a_t3_wam_01_007
    # gets a list of warnings from database
    begin
      Warning.paginate_by_subtask_id(5,
                                     1,
                                     "xyz", # invalid ordered field
                                     "asc",
                                     "",
                                     "",
                                     false,
                                     false)
    rescue => error
      assert_match(/Unknown column 'xyz' in 'order clause'.*/, error.message)
    end
  end

   #Invalid order_direction
  def test_ut_rsf10a_t3_wam_01_008
    # gets a list of warnings from database
    begin
      Warning.paginate_by_subtask_id(5,
                                     1,
                                     "row",
                                     "xyz", # invalid order direction
                                     "",
                                     "",
                                     false,
                                     false)
    rescue => error
      assert_match(/You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'xyz LIMIT 0, 10'.*/, error.message)
    end
  end

   #Valid inputs
  def test_ut_rsf10a_t3_wam_01_009
    # gets a list of warnings from database
    warnings = Warning.paginate_by_subtask_id(5,
                                              1,
                                              "row",
                                              "desc",
                                              "",
                                              "",
                                              false,
                                              false)

    # the list must be not empty
    assert(warnings.size != 0)

    # the list must be ordered incrementally by values of "warnings.row"
    (1..warnings.size - 1).each do |i|
      assert(warnings[i].row <= warnings[i-1].row)
    end
  end

 #  Invalid flag field
  def test_ut_rsf10a_t3_wam_01_010
    # gets a list of warnings from database
    begin
      Warning.paginate_by_subtask_id(5,
                                     1,
                                     "xyz", # invalid ordered field
                                     "desc",
                                     "",
                                     "",
                                     false,
                                     false)
    rescue => error
      assert_match(/Unknown column 'xyz' in 'order clause'.*/, error.message)
    end
  end

  # invalid input. Flag field is incorrect.
  def test_ut_rsf10a_t3_wam_01_011
    # gets a list of warnings from database
    begin
      Warning.paginate_by_subtask_id(5,
                                     1,
                                     "row",
                                     "xyz", # invalid order direction
                                     "",
                                     "",
                                     false,
                                     false)
    rescue => error
      assert_match(/You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'xyz LIMIT 0, 10'.*/, error.message)
    end
  end

  #Valid filter_field, filter_keyword is empty
  def test_ut_rsf10a_t3_wam_01_012
    # gets a list of warnings
    warnings = Warning.paginate_by_subtask_id(5,
                                              1,
                                              "",
                                              "",
                                              "warnings.rule",
                                              "",
                                              false,
                                              false)

    # a normal list of warnings
    assert_equal(warnings.size,
                 10)

    # warnings in the list may have different rules
    different = true
    rules = warnings.collect { |warning| warning.rule}
    rules[1..9].each do |rule|
      if rule != rules[0]
        different = false
        break;
      end
    end
    assert(different == false)
  end

  #Valid filter_field, filter_keyword is a single word
  def test_ut_rsf10a_t3_wam_01_013
    # gets a list of warnings
    warnings = Warning.paginate_by_subtask_id(5,
                                              1,
                                              "",
                                              "",
                                              "warnings.rule",
                                              "0240",
                                              false,
                                              false)

    # all warnings in the list have the same rule: "0240"
    warnings.each do |warning|
      assert_equal(warning.rule,
                   "0240")
    end
  end

   #Valid filter_field, filter_keyword is multiple words containing super characters
  def test_ut_rsf10a_t3_wam_01_014
    # gets a list of warnings
    warnings = Warning.paginate_by_subtask_id(5,
                                              1,
                                              "",
                                              "",
                                              "warnings.rule",
                                              "0240 2017 2159",
                                              false,
                                              false)

    # all warnings in the list have the same rule: "0240"
    warnings.each do |warning|
      assert_not_nil "0240 2017 2159".index(warning.rule)
    end
  end

  def test_ut_rsf10a_t3_wam_01_015
    # gets a list of warnings
    warnings = Warning.paginate_by_subtask_id(5,
                                              1,
                                              "",
                                              "",
                                              "warnings.rule",
                                              "02*",
                                              false,
                                              false)

    # all warnings in the list have the rul matching to /02.*/
    warnings.each do |warning|
      assert(warning.rule =~ /02.*/ )
    end
  end

  def test_ut_rsf10a_t3_wam_01_016
    warnings = Warning.paginate_by_subtask_id(5,
                                              1,
                                              "",
                                              "",
                                              "warnings.rule",
                                              "*24* *50*",
                                              false,
                                              false)

    # all warnings in the list have the rule matching to /.*24.*|.*50.*/
    warnings.each do |warning|
      assert(warning.rule =~ /.*24.*|.*50.*/ )
    end
  end

  def test_ut_rsf10a_t3_wam_01_017
    warnings = Warning.paginate_by_subtask_id(5,
                                              1,
                                              "row",
                                              "asc",
                                              "warnings.rule",
                                              "*24* *50*",
                                              false,
                                              false)

    # all warnings in the list have the rule matching to /.*24.*|.*50.*/
    warnings.each do |warning|
      assert(warning.rule =~ /.*24.*|.*50.*/ )
    end

    # this list is also ordered incrementally by "row" field
    (1..warnings.size - 1).each do |i|
      assert(warnings[i].row >= warnings[i - 1].row)
    end
  end

  def test_ut_rsf10a_t3_wam_01_018
    warnings = Warning.paginate_by_subtask_id(5,
                                              1,
                                              "row",
                                              "asc",
                                              "warnings.rule",
                                              "*24* *50*",
                                              true,
                                              false)

    # these warnings have been already commented
    warnings.each do |warning|
      assert_not_nil(warning.comment)
    end
  end

  def test_ut_rsf10a_t3_wam_01_019
    warnings = Warning.paginate_by_subtask_id(5,
                                              1,
                                              "",
                                              "",
                                              "",
                                              "",
                                              true,
                                              true)

    # these warnings have registered comments
    warnings.each do |warning|
      assert_not_nil(warning.comment)
      assert_equal(true,
                   warning.comment.status)
    end
  end

   #Valid inputs
  def test_ut_rsf10a_t3_wam_02_001
    # gets a list of warnings of an analysis result from database
    warnings = Warning.paginate_by_result_id(1,
                                             1,
                                             "",
                                             "",
                                             "",
                                             "",
                                             false,
                                             false)

    # this list contains 10 warnings
    assert_equal(Warning.per_page,
                 warnings.length)

    # all warnings belong to the same analysis result
    warnings.each do |warning|
      assert_equal("1", warning.result_id)
    end
  end

    #Valid inputs. But the result has no warning
    # But now, we don't have data for this test case. so we choose one Invalid result_id
  def test_ut_rsf10a_t3_wam_02_002
    # gets a list of warnings of an analysis result from database
    warnings = Warning.paginate_by_result_id(100,
                                             1,
                                             "",
                                             "",
                                             "",
                                             "",
                                             false,
                                             false)

    # this list is empty
    assert_equal(0,
                 warnings.length)
  end

   #Invalid result_id
  def test_ut_rsf10a_t3_wam_02_003
    # gets a list of warnings of an analysis result from database
    warnings = Warning.paginate_by_result_id(-1,
                                             1,
                                             "",
                                             "",
                                             "",
                                             "",
                                             false,
                                             false)

    # this list is empty
    assert_equal(0,
                 warnings.length)
  end

    #Invalid page. Page <= 0
  def test_ut_rsf10a_t3_wam_02_004
    # gets a list of warnings from database
    begin
    Warning.paginate_by_result_id(1,
                                  0,
                                  "",
                                  "",
                                  "",
                                  "",
                                  false,
                                  false)
    rescue => error
      assert_equal(error.message,
                   "0 given as value, which translates to '0' as page number")
    end
  end

    # Invalid page which exceeds the maximum value
  def test_ut_rsf10a_t3_wam_02_005
    # page exceeds the maximum value
    warnings = Warning.paginate_by_result_id(1,
                                             130,
                                             "",
                                             "",
                                             "",
                                             "",
                                             false,
                                             false)

    # this list is empty
    assert_equal(0,
                 warnings.size)
  end

     #Valid inputs
  def test_ut_rsf10a_t3_wam_02_006
    # gets a list of warnings ordered incrementally by row
    warnings = Warning.paginate_by_result_id(1,
                                             1,
                                             "row",
                                             "asc",
                                             "",
                                             "",
                                             false,
                                             false)

    # all warnings belong to the same analysis result
    warnings.each do |warning|
      assert_equal("1", warning.result_id)
    end

    # this list is empty
    assert_equal(Warning.per_page,
                 warnings.size)

    # this list must be sorted incrementally by row
    (1..warnings.size - 1).each do |i|
      assert(warnings[i].row >= warnings[i - 1].row)
    end
  end

# Invalid order_field
  def test_ut_rsf10a_t3_wam_02_007
    begin
      # invalid order field
      warnings = Warning.paginate_by_result_id(1,
                                               1,
                                               "xyz",
                                               "asc",
                                               "",
                                               "",
                                               false,
                                               false)
    rescue => error
      assert_match(/Unknown column 'xyz' in 'order clause'.*/,
                   error.message)
    end
  end

  # Invalid order_direction
  def test_ut_rsf10a_t3_wam_02_008
    begin
      # invalid order field
      warnings = Warning.paginate_by_result_id(1,
                                               1,
                                               "row",
                                               "xyz",
                                               "",
                                               "",
                                               false,
                                               false)
    rescue => error
      assert_match(/You have an error in your SQL syntax;.*/,
                   error.message)
    end
  end

    #valid inputs
  def test_ut_rsf10a_t3_wam_02_009
    warnings = Warning.paginate_by_result_id(1,
                                             1,
                                             "row",
                                             "desc",
                                             "",
                                             "",
                                             false,
                                             false)

    # the list is not empty
    assert_not_equal(0,
                     warnings.size)
    # all warnings belong to the same analysis result
    warnings.each do |warning|
      assert_equal("1", warning.result_id)
    end

    # this list is sorted decrementally by row
    (1..warnings.size - 1).each do |i|
      assert(warnings[i].row <= warnings[i - 1].row)
    end
  end

   # invalid flag field
  def test_ut_rsf10a_t3_wam_02_010
    begin
      warnings = Warning.paginate_by_result_id(1,
                                               1,
                                               "xyz",
                                               "desc",
                                               "",
                                               "",
                                               false,
                                               false)
    rescue => error
      assert_match(/Unknown column 'xyz' in 'order clause'.*/,
                   error.message)
    end
  end

    # Invalid input, Flag field is correct.
  def test_ut_rsf10a_t3_wam_02__011
    begin
      warnings = Warning.paginate_by_result_id(1,
                                               1,
                                               "row",
                                               "xyz",
                                               "",
                                               "",
                                               false,
                                               false)

    rescue => error
      assert_match(/You have an error in your SQL syntax;.*/,
                   error.message)
    end
  end

    #Valid filter_field, filter_keyword is empty
  def test_ut_rsf10a_t3_wam_02012
    warnings = Warning.paginate_by_result_id(1,
                                             1,
                                             "",
                                             "",
                                             "warnings.rule",
                                             "",
                                             false,
                                             false)

    # the list is not empty. It is a normal list
    assert_not_equal(0,
                     warnings.size)
    # all warnings belong to the same analysis result
    warnings.each do |warning|
      assert_equal("1", warning.result_id)
    end
  end

    #Valid filter field, filter_keyword is a single.
  def test_ut_rsf10a_t3_wam_02013
    warnings = Warning.paginate_by_result_id(1,
                                             1,
                                             "",
                                             "",
                                             "warnings.rule",
                                             "0240",
                                             false,
                                             false)

    # all warnings belong to the same analysis result
    warnings.each do |warning|
      assert_equal("1",warning.result_id)
    end

    # all warnings of this list have the same rule: "0240"
    warnings.each do |warning|
      assert_equal("0240", warning.rule)
    end
  end

    # valid filter field, filter _keyword is multiple words separate by space
  def test_ut_rsf10a_t3_wam_02014
    warnings = Warning.paginate_by_result_id(1,
                                             1,
                                             "",
                                             "",
                                             "warnings.rule",
                                             "0240 0217 0157",
                                             false,
                                             false)

    # all warnings belong to the same analysis result
    warnings.each do |warning|
      assert_equal("1",warning.result_id)
    end

    # all warnings of this list have the rule matching to "0240", "0217" or "0157"
    warnings.each do |warning|
      assert_not_nil(["0240", "0217", "0157"].index(warning.rule))
    end
  end

     # Valid filter_field, filter_keyword is a single word which contains super characters
  def test_ut_rsf10a_t3_wam_02_015
    warnings = Warning.paginate_by_result_id(1,
                                             1,
                                             "",
                                             "",
                                             "warnings.rule",
                                             "02*",
                                             false,
                                             false)

    # all warnings belong to the same analysis result
    warnings.each do |warning|
      assert_equal("1",warning.result_id)
    end

    # all warnings of this list have the rule matching to /02.*/
    warnings.each do |warning|
      assert_match(/02.*/,
                   warning.rule)
    end
  end

   # Valid filter_field, filter_keyword is multiple words containing super characters
  def test_ut_rsf10a_t3_wam_02_016
    warnings = Warning.paginate_by_result_id(1,
                                             1,
                                             "",
                                             "",
                                             "warnings.rule",
                                             "*24* *50*",
                                             false,
                                             false)

    # all warnings of this list have the rule matching to /.*24.*|.*50.*/
    warnings.each do |warning|
      assert_match(/.*24.*|.*50.*/,
                   warning.rule)
    end
  end

    # Get a filtered and ordered list of warnings of an analysis result
  def test_ut_rsf10a_t3_wam_017
    warnings = Warning.paginate_by_result_id(1,
                                             1,
                                             "row",
                                             "asc",
                                             "warnings.rule",
                                             "*24* *50*",
                                             false,
                                             false)

    # all warnings of this list have the rule matching to /.*24.*|.*50.*/
    warnings.each do |warning|
      assert_match(/.*24.*|.*50.*/,
                   warning.rule)
    end

    # the list is also sorted incrementally by row
    (1..warnings.size - 1).each do |i|
      warnings[i].row >= warnings[i - 1].row
    end
  end

  # Get a list of commented warnings
  # (both comment-saved temporarily and comment-registered) of an analysis result
  def test_ut_rsf10a_t3_wam_02_018
    warnings = Warning.paginate_by_result_id(1,
                                             1,
                                             "",
                                             "",
                                             "",
                                             "",
                                             true,
                                             false)
    # all warnings belong to the same analysis result
    warnings.each do |warning|
      assert_equal("1",warning.result_id)
    end

    # these warnings have already been commented
    warnings.each do |warning|
      assert_not_nil(warning.comment)
    end
  end

   # Get a list of comment-registered warnings of an analysis result
  def test_ut_rsf10a_t3_wam_02_019
    warnings = Warning.paginate_by_result_id(1,
                                             1,
                                             "",
                                             "",
                                             "",
                                             "",
                                             true,
                                             true)
    # all warnings belong to the same analysis result
    warnings.each do |warning|
      assert_equal("1", warning.result_id)
    end

    warnings.each do |warning|
      # these warnings have already been commented
      assert_not_nil(warning.comment)
      # each comment is registered
      assert_equal(true,
                   warning.comment.status)
    end
  #ends ordered incrementally by row
    warnings = Warning.paginate_by_result_id(1,
                                             1,
                                             "row",
                                             "asc",
                                             "",
                                             "",
                                             false,
                                             false)

    # all warnings belong to the same analysis result
    warnings.each do |warning|
      assert_equal("1", warning.result_id)
    end

    # this list is empty
    assert_equal(Warning.per_page,
                 warnings.size)

    # this list must be sorted incrementally by row
    (1..warnings.size - 1).each do |i|
      assert(warnings[i].row >= warnings[i - 1].row)
    end
  end

   # valid inputs
  def test_ut_rsf10a_t3_wam_03_001

    counted_value = Warning.count_by_result_id(1)
    assert_equal(1290, counted_value)
  end

   # Analysis result contains no warning
  def test_ut_rsf10a_t3_wam_03_002
    assert_equal(0, Warning.count_by_result_id(999))
  end

    # Result's id exceed the maximum value
  def test_ut_rsf10a_t3_wam_03_003
    assert_equal(0, Warning.count_by_result_id(1000))
  end

    # Result's id <= 0
  def test_ut_rsf10a_t3_wam_03_004
    assert_equal(0, Warning.count_by_result_id(0))
  end

    # To change test data to enable this
    # Get a warning with its comment
    # Valid id. Warning is commented
  def test_ut_rsf10a_t3_wam_04_001
    # gets a commented warning
    warning = Warning.find_with_comment(1)
    # this comment has already been commented
    assert_not_nil(warning.comment)
  end

    # Valid id. Warning is uncommented
  def test_ut_rsf10a_t3_wam_04_002
    # gets a commented warning
    warning = Warning.find_with_comment(100)
    # this comment has not been commented yet
    assert_nil(warning.comment)
  end

  #invalid id
  def test_ut_rsf10a_t3_wam_04_003
    # gets a warning with an invalid id
    warning = Warning.find_with_comment(-1)

    # this warning does not exist
    assert_nil(warning)
  end

   # To change test data to enable this
   # Get a warning with full information
   # valid id
  def test_ut_rsf10a_t3_wam_05_001
    warning = Warning.find_with_full_information(1)

    assert_not_nil(warning)

    assert(!warning.comment_warning_description.blank?)
    assert(!warning.source_code_body.blank?)
  end

    # invalid id
  def test_ut_rsf10a_t3_wam_05_002
    warning = Warning.find_with_full_information(-1)

    assert_nil(warning)
  end

    # Get all warnings of analysis results of a subtask
    # valid subtask's id'
  def test_ut_rsf10a_t3_wam_06_001
    warnings = Warning.find_all_by_subtask_id(5,
                                              "",
                                              "",
                                              "",
                                              "",
                                              false,
                                              false)

    # all warnings belong to the same subtask
    warnings.each do |warning|
      assert_equal(5,warning.subtask_id.to_i)
    end

    # this list contains all warnings of the subtask (id=5)
    total_warnings = Warning.count(:all, :conditions => "subtask_id = 1")
    assert_equal(total_warnings,warnings.size)
  end

    # Invalid subtask's id
  def test_ut_rsf10a_t3_wam_06_002
    warnings = Warning.find_all_by_subtask_id(-1,
                                              "",
                                              "",
                                              "",
                                              "",
                                              false,
                                              false)

    # this list is empty
    assert_equal(0, warnings.size)
  end

    # Valid subtask's id
  def test_ut_rsf10a_t3_wam_06_003
    warnings = Warning.find_all_by_subtask_id(5,
                                              "row",
                                              "asc",
                                              "",
                                              "",
                                              false,
                                              false)

    # this list must be not empty
    assert_not_equal(0,
                     warnings.size)

    # this list is sorted incrementally by row
    warnings.each_cons(2) { |a, b| assert(b.row >= a.row)}
  end

    # Invalid order field
  def test_ut_rsf10a_t3_wam_06_004
    begin
      warnings = Warning.find_all_by_subtask_id(5,
                                                "xyz",
                                                "asc",
                                                "",
                                                "",
                                                false,
                                                false)
    rescue => error
      assert_match(/Unknown column 'xyz' in 'order clause'.*/,
                   error.message)
    end
  end

   # Invalid order direction
  def test_ut_rsf10a_t3_wam_06_005
    begin
      warnings = Warning.find_all_by_subtask_id(1,
                                                "row",
                                                "xyz",
                                                "",
                                                "",
                                                false,
                                                false)
    rescue => error
      assert_match(/You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'xyz'.*/,
                   error.message)
    end
  end

      # Valid subtask's id
   def test_ut_rsf10a_t3_wam_06_006
    warnings = Warning.find_all_by_subtask_id(5,
                                              "row",
                                              "desc",
                                              "",
                                              "",
                                              false,
                                              false)

    # this list must be not empty
    assert_not_equal(0,
                     warnings.size)

    # this list is sorted incrementally by row
    warnings.each_cons(2) { |a, b| assert(b.row <= a.row)}
  end

     # Invalid order field
  def test_ut_rsf10a_t3_wam_06_007
    begin
      warnings = Warning.find_all_by_subtask_id(5,
                                                "xyz",
                                                "desc",
                                                "",
                                                "",
                                                false,
                                                false)
    rescue => error
      assert_match(/Unknown column 'xyz' in 'order clause'.*/,
                   error.message)
    end
  end

    # Invalid order direction
  def test_ut_rsf10a_t3_wam_06_008
    begin
      warnings = Warning.find_all_by_subtask_id(5,
                                                "row",
                                                "xyz",
                                                "",
                                                "",
                                                false,
                                                false)
    rescue => error
      assert_match(/You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'xyz'.*/,
                   error.message)
    end
  end

   # Invalid filter_field
  def test_ut_rsf10a_t3_wam_06_009
    begin
      warnings = Warning.find_all_by_subtask_id(5,
                                                "",
                                                "",
                                                "xyz",
                                                "0240",
                                                false,
                                                false)
    rescue => error
      assert_match(/.Unknown column 'xyz' in 'where clause'.*/,
                   error.message)
    end
  end

   # Valid filter_field, filter_keyword is empty
  def test_ut_rsf10a_t3_wam_06_010
    # filter with empty keyword
    warnings = Warning.find_all_by_subtask_id(5,
                                              "",
                                              "",
                                              "warnings.rule",
                                              "",
                                              false,
                                              false)

    # this list must contain all warnings of analysis results of this subtask
   total_warnings = Warning.count(:all, :conditions => {:subtask_id => 5} )

    assert_equal(total_warnings,warnings.size)
  end

    # Valid filter_field, filter_keyword is a single word
  def test_ut_rsf10a_t3_wam_06_011
    # gets a list of filtered warnings of analysis results of a subtask
    warnings = Warning.find_all_by_subtask_id(5,
                                              "",
                                              "",
                                              "warnings.rule",
                                              "0240",
                                              false,
                                              false)

    # all warnings belong a subtask
    warnings.each do |warning|
      assert_equal(5, warning.subtask_id.to_i)
    end
    # this list contains all filtered warnings
     total_warnings = Warning.count(:all,
                                    :conditions => {:subtask_id => 5,
                                                    :rule => "0240"} )
    assert_equal(total_warnings,
                 warnings.size)

    # all warnings have the same rule: "0240"
    warnings.each do |warning|
      assert_equal("0240",
                    warning.rule)
    end
  end

     # Valid filter_field, filter_keyword contains multiple words separated by spaces
  def test_ut_rsf10a_t3_wam_06_012
    # gets a list of filtered warnings of analysis results of a subtask
    warnings = Warning.find_all_by_subtask_id(5,
                                              "",
                                              "",
                                              "warnings.rule",
                                              "0240 2017",
                                              false,
                                              false)

    # all warnings belong a subtask
    warnings.each do |warning|
      assert_equal(5,
                   warning.subtask_id.to_i)
    end
    # this list contains all filtered warnings
    total_warnings = Warning.count(:all,
                                    :conditions => {:subtask_id => 5,
                                                   :rule => ["0240", "2017"]} )

    assert_equal(total_warnings,
                 warnings.size)

    # rules must be "0240" or "2017"
    warnings.each do |warning|
      assert_not_nil(["0240", "2017"].index(warning.rule))
    end
  end

     # Valid filter_field, filter_keyword contains super characters
   def test_ut_rsf10a_t3_wam_06_013
    # gets a list of filtered warnings of analysis results of a subtask
    warnings = Warning.find_all_by_subtask_id(5,
                                              "",
                                              "",
                                              "warnings.rule",
                                              "*02*",
                                              false,
                                              false)

    # all warnings belong a subtask
    warnings.each do |warning|
      assert_equal(5,
                   warning.subtask_id.to_i)
    end
    # this list contains all filtered warnings
    total_warnings = Warning.count(:all,
                                     :conditions => "subtask_id = 5 AND warnings.rule RLIKE '^.*02.*$'")

    assert_equal(total_warnings,
                 warnings.size)

       # rules must match to /02.*/
     warnings.each do |warning|
      assert(warning.rule =~ /02.*/ )
    end
   end

   # Valid filter_field, filter_keyword contains multiple words having super characters
  def test_ut_rsf10a_t3_wam_06_014
    # gets a list of filtered warnings of analysis results of a subtask
    warnings = Warning.find_all_by_subtask_id(5,
                                              "",
                                              "",
                                              "warnings.rule",
                                              "*24* *50*",
                                              false,
                                              false)

    # all warnings belong a subtask
    warnings.each do |warning|
      assert_equal(5,
                   warning.subtask_id.to_i)
    end
    # this list contains all filtered warnings
    total_warnings = Warning.count(:all,
                                   :conditions => "subtask_id = 5 AND rule RLIKE '^.*24.*$|^.*50.*$'")

    assert_equal(total_warnings,
                 warnings.size)

    # rules must match to /02.*/
    warnings.each do |warning|
      assert_match(/.*24.*|.*50.*/,
                   warning.rule)
    end
  end

   # Valid filter_field, filter_keyword contains multiple words having super characters
  def test_ut_rsf10a_t3_wam_06_015
    # gets a list of filtered warnings of analysis results of a subtask
    warnings = Warning.find_all_by_subtask_id(5,
                                              "row",
                                              "asc",
                                              "warnings.rule",
                                              "*24* *50*",
                                              false,
                                              false)

    # all warnings belong a subtask
    warnings.each do |warning|
      assert_equal(5,
                   warning.subtask_id.to_i)
    end
    # this list contains all filtered warnings
    total_warnings = Warning.count(:all,
                                   :conditions => "subtask_id = 5 AND rule RLIKE '^.*24.*$|^.*50.*$'")

    assert_equal(total_warnings,
                 warnings.size)

    # rules must match to /.*24.*|.*50.*/
    warnings.each do |warning|
      assert_match(/.*24.*|.*50.*/,
                   warning.rule)
    end

    # this list is also sorted incrementally by row
    warnings.each_cons(2) { |a, b| assert(a.row <= b.row)}
  end

   # valid input
  def test_ut_rsf10a_t3_wam_06_016
    # gets a list of filtered warnings of analysis results of a subtask
    warnings = Warning.find_all_by_subtask_id(5,
                                              "",
                                              "",
                                              "",
                                              "",
                                              true,
                                              false)

    # all warnings belong a subtask
    warnings.each do |warning|
      assert_equal(5,
                   warning.subtask_id.to_i)
    end
    # this list contains all filtered warnings
    total_warnings = Warning.count(:joins      => "INNER JOIN comments     ON warnings.id      = comments.warning_id",
                                   :conditions => "warnings.subtask_id = 5")

    assert_equal(total_warnings,
                 warnings.size)

    # this list must only contain commented warnings
    warnings.each do |warning|
      assert_not_nil(warning.comment)
    end
  end

   # valid input
  def test_ut_rsf10a_t3_wam_06_017
    # gets a list of filtered warnings of analysis results of a subtask
    warnings = Warning.find_all_by_subtask_id(5,
                                              "",
                                              "",
                                              "",
                                              "",
                                              true,
                                              true)

    # all warnings belong a subtask
    warnings.each do |warning|
      assert_equal(5,
                   warning.subtask_id.to_i)
    end
    # this list contains all filtered warnings
    total_warnings = Warning.count(:joins      => "INNER JOIN comments     ON warnings.id      = comments.warning_id",
                                   :conditions => "warnings.subtask_id = 5 AND comments.status = true")

    assert_equal(total_warnings,
                 warnings.size)

    # this list must only contain comment-registered warnings
    warnings.each do |warning|
      assert_not_nil(warning.comment)
      assert(warning.comment.status)
    end
  end

    # Get all warnings of an analysis result
    #  Valid result's id
  def test_ut_rsf10a_t3_wam_07_001
    # gets a list of warnings of an analysis result
    warnings = Warning.find_all_by_result_id(1,
                                             "",
                                             "",
                                             "",
                                             "",
                                             false,
                                             false)

    # all warnings in this list belong to an analysis result
    warnings.each do |warning|
      assert_equal("1",
                   warning.result_id)
    end
    total_warnings = Warning.count(:joins      => "INNER JOIN warnings_results     ON warnings_results.warning_id      = warnings.id",
                                   :conditions => "result_id = 1")

    # this list contains all warnings of the analysis result
    assert_equal(total_warnings,
                 warnings.size)
  end

   # Invalid result's id
  def test_ut_rsf10a_t3_wam_07_002
    # gets a list of warnings of an analysis result with invalid result's id
    warnings = Warning.find_all_by_result_id(-1,
                                             "",
                                             "",
                                             "",
                                             "",
                                             false,
                                             false)


    # this list is empty
    assert_equal(0,
                 warnings.size)
  end

   # Valid order direction, valid order field
  def test_ut_rsf10a_t3_wam_07_003
    # gets a list of warnings of an analysis result with invalid result's id
    warnings = Warning.find_all_by_result_id(1,
                                             "row",
                                             "asc",
                                             "",
                                             "",
                                             false,
                                             false)


    # all warnings in this list belong to an analysis result
    warnings.each do |warning|
      assert_equal("1",
                   warning.result_id)
    end
    total_warnings = Warning.count(:joins      => "INNER JOIN warnings_results     ON warnings_results.warning_id      = warnings.id",
                                   :conditions => "result_id = 1")

    # this list contains all warnings of the analysis result
    assert_equal(total_warnings,
                 warnings.size)

    # this list is sorted incrementally by row
    warnings.each_cons(2) {|a, b| a.row <= b.row}
  end

   # Invalid order field
  def test_ut_rsf10a_t3_wam_07_004
    begin
      # gets a list of warnings of an analysis result with invalid filter_field
      warnings = Warning.find_all_by_result_id(1,
                                               "xyz",
                                               "asc",
                                               "",
                                               "",
                                               false,
                                               false)
    rescue => error
      assert_match(/Unknown column 'xyz' in 'order clause'.*/, error.message)
    end
  end

    #  Invalid order direction
  def test_ut_rsf10a_t3_wam_07_005
    begin
      # gets a list of warnings of an analysis result with invalid filter_direction
      warnings = Warning.find_all_by_result_id(7,
                                               "row",
                                               "xyz",
                                               "",
                                               "",
                                               false,
                                               false)
    rescue => error
      assert_match(/You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'xyz'/,
                    error.message)
    end
  end

    # Valid subtask's id
  def test_ut_rsf10a_t3_wam_07_006
    # gets a list of warnings of an analysis result with invalid result's id
    warnings = Warning.find_all_by_result_id(1,
                                             "row",
                                             "desc",
                                             "",
                                             "",
                                             false,
                                             false)


    # all warnings in this list belong to an analysis result
    warnings.each do |warning|
      assert_equal("1",
                   warning.result_id)
    end
    total_warnings = Warning.count(:joins      => "INNER JOIN warnings_results     ON warnings_results.warning_id      = warnings.id",
                                   :conditions => "result_id = 1")

    # this list contains all warnings of the analysis result
    assert_equal(total_warnings,
                 warnings.size)

    # this list is sorted decrementally by row
    warnings.each_cons(2) {|a, b| a.row >= b.row}
  end

    # Invalid order field
  def test_ut_rsf10a_t3_wam_07_007
    begin
      # gets a list of warnings of an analysis result with invalid filter_field
      warnings = Warning.find_all_by_result_id(1,
                                               "xyz",
                                               "desc",
                                               "",
                                               "",
                                               false,
                                               false)
    rescue => error
      assert_match(/Unknown column 'xyz' in 'order clause'.*/, error.message)
    end
  end

   # Invalid order direction
  def test_ut_rsf10a_t3_wam_07_008
    begin
      # gets a list of warnings of an analysis result with invalid filter_direction
      warnings = Warning.find_all_by_result_id(1,
                                               "row",
                                               "xyz",
                                               "",
                                               "",
                                               false,
                                               false)
    rescue => error
      assert_match(/You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'xyz'/,
                    error.message)
    end
  end

   #  Invalid filter_field
  def test_ut_rsf10a_t3_wam_07_009
    begin
      # gets a list of filtered warnings of an analysis result with invalid filter_field
      warnings = Warning.find_all_by_result_id(1,
                                               "",
                                               "",
                                               "xyz",
                                               "2040",
                                               false,
                                               false)
    rescue => error
      assert_match(/Unknown column 'xyz' in 'where clause'.*/, error.message)
    end
  end

   #  Valid filter_field, filter_keyword is empty
  def test_ut_rsf10a_t3_wam_07_010
    # gets a list of filtered warnings of an analysis result with empty filter_keyword
    warnings = Warning.find_all_by_result_id(1,
                                             "",
                                             "",
                                             "warnings.rule",
                                             "",
                                             false,
                                             false)

    # all warnings in this list belong to an analysis result
    warnings.each do |warning|
      assert_equal("1",
                   warning.result_id)
    end

    total_warnings = Warning.count(:joins      => "INNER JOIN warnings_results     ON warnings_results.warning_id      = warnings.id",
                                   :conditions => "result_id = 1")

    # this list contains all warnings of the analysis result
    assert_equal(total_warnings,
                 warnings.size)
  end

   # Valid filter_field, filter_keyword is a single word
  def test_ut_rsf10a_t3_wam_07_011
    # gets a list of filtered warnings
    warnings = Warning.find_all_by_result_id(1,
                                             "",
                                             "",
                                             "warnings.rule",
                                             "0240",
                                             false,
                                             false)

    # all warnings in this list belong to an analysis result
    warnings.each do |warning|
      assert_equal("1",
                   warning.result_id)
    end
    total_warnings = Warning.count(:all,
                                   :joins      => "INNER JOIN warnings_results     ON warnings_results.warning_id      = warnings.id",
                                   :conditions => {"warnings_results.result_id" => 1,
                                                     "warnings.rule"            => "0240"} )



    # this list contains all filtered warnings of the analysis result
    assert_equal(total_warnings,
                 warnings.size)

    # warnings' rule must be the same: "0240"
    warnings.each do |warning|
      assert_equal("0240",
                   warning.rule)
    end
  end

    # Valid filter_field, filter_keyword contains multiple words separated by spaces
  def test_ut_rsf10a_t3_wam_07_012
    # gets a list of filtered warnings, filter_keyword contains multple words
    warnings = Warning.find_all_by_result_id(1,
                                             "",
                                             "",
                                             "warnings.rule",
                                             "0240 2017",
                                             false,
                                             false)

    # all warnings in this list belong to an analysis result
    warnings.each do |warning|
      assert_equal("1",
                   warning.result_id)
    end
    total_warnings = Warning.count(:all,
                                   :joins      => "INNER JOIN warnings_results     ON warnings_results.warning_id      = warnings.id",
                                   :conditions => {"warnings_results.result_id" => 1,
                                                     "warnings.rule"            => ["0240", "2017"]})

    # this list contains all filtered warnings of the analysis result
    assert_equal(total_warnings,
                 warnings.size)

    # warnings' rule must be "0240" or "2017"
    warnings.each do |warning|
      assert_not_nil(["0240", "2017"].index(warning.rule))
    end
  end

  #  Valid filter_field, filter_keyword contains super characters
  def test_ut_rsf10a_t3_wam_07_013
    # gets a list of filtered warnings, filter_keyword contains multple words
    warnings = Warning.find_all_by_result_id(1,
                                             "",
                                             "",
                                             "warnings.rule",
                                             "02*",
                                             false,
                                             false)

    # all warnings in this list belong to an analysis result
    warnings.each do |warning|
      assert_equal("1",
                   warning.result_id)
    end
    total_warnings = Warning.count(:all,
                                   :joins      => "INNER JOIN warnings_results     ON warnings_results.warning_id      = warnings.id",
                                   :conditions => "warnings_results.result_id = 1 AND warnings.rule RLIKE '^02.*$'")


    # this list contains all filtered warnings of the analysis result
    assert_equal(total_warnings,
                 warnings.size)

    # warnings' rule must match to /02.*/
    warnings.each do |warning|
      assert_match(/02.*/,
                   warning.rule)
    end
  end

   # Valid filter_field, filter_keyword contains multiple words having super characters
  def test_ut_rsf10a_t3_wam_07_014
    # gets a list of filtered warnings, filter_keyword contains multple words
    warnings = Warning.find_all_by_result_id(1,
                                             "",
                                             "",
                                             "warnings.rule",
                                             "*24* *50*",
                                             false,
                                             false)

    # all warnings in this list belong to an analysis result
    warnings.each do |warning|
      assert_equal("1",
                   warning.result_id)
    end

    total_warnings = Warning.count(:all,
                                   :joins      => "INNER JOIN warnings_results     ON warnings_results.warning_id      = warnings.id",
                                   :conditions => "warnings_results.result_id = 1 AND warnings.rule RLIKE '^.*24.*$|^.*50.*$'")

    # this list contains all filtered warnings of the analysis result
    assert_equal(total_warnings,
                 warnings.size)

    # warnings' rule must match to /.*24.*|.*50.*/
    warnings.each do |warning|
      assert_match(/.*24.*|.*50.*/,
                   warning.rule)
    end
  end

   # Valid filter_field, filter_keyword contains multiple words having super characters
  def test_ut_rsf10a_t3_wam_07_015
    # gets a list of filtered warnings, filter_keyword contains multple words having super characters
    # this list is also ordered
    warnings = Warning.find_all_by_result_id(1,
                                             "row",
                                             "asc",
                                             "warnings.rule",
                                             "*24* *50*",
                                             false,
                                             false)

    # all warnings in this list belong to an analysis result
    warnings.each do |warning|
      assert_equal("1",
                   warning.result_id)
    end
    total_warnings = Warning.count(:all,
                                   :joins      => "INNER JOIN warnings_results     ON warnings_results.warning_id      = warnings.id",
                                   :conditions => "warnings_results.result_id = 1 AND warnings.rule RLIKE '^.*24.*$|^.*50.*$'")

    # this list contains all filtered warnings of the analysis result
    assert_equal(total_warnings,
                 warnings.size)

    # warnings' rule must match to /.*24.*|.*50.*/
    warnings.each do |warning|
      assert_match(/.*24.*|.*50.*/,
                   warning.rule)
    end

    # this list is sorted incrementally by row
    warnings.each_cons(2) do |a, b|
      assert(a.row <= b.row)
    end
  end

   # Valid inputs
  def test_ut_rsf10a_t3_wam_07_016
#
    warnings = Warning.find_all_by_result_id(1,
                                             "",
                                             "",
                                             "",
                                             "",
                                             true,
                                             false)

    # all warnings in this list belong to an analysis result
    warnings.each do |warning|
      assert_equal("1",
                   warning.result_id)
    end

    # this list must contain all commented warnings
    total_warnings = Warning.count(:all,
                                   :joins      => "INNER JOIN warnings_results     ON warnings_results.warning_id      = warnings.id
                                                   INNER JOIN comments     ON warnings.id     = comments.warning_id#",
                                   :conditions => "warnings_results.result_id = 1")

    assert_equal(total_warnings, warnings.size)

    # all warnings are commented
    warnings.each do |warning|
      assert_not_nil(warning.comment)
    end
  end

   # Valid filter_field, filter_keyword contains multiple words having super characters
  def test_ut_rsf10a_t3_wam_07_017
#
    warnings = Warning.find_all_by_result_id(7,
                                             "",
                                             "",
                                             "",
                                             "",
                                             true,
                                             true)

    # all warnings in this list belong to an analysis result
    warnings.each do |warning|
      assert_equal("1",
                   warning.result_id)
    end

    # this list must contain all comment-registered warnings
    total_warnings = Warning.count(:all,
                                   :joins      => "INNER JOIN warnings_results     ON warnings_results.warning_id      = warnings.id
                                                   INNER JOIN comments     ON warnings.id     = comments.warning_id#",
                                   :conditions => "warnings_results.result_id = 1 AND comments.status = true")

    assert_equal(total_warnings,
                 warnings.size)

    # all warnings have a registered comment
    warnings.each do |warning|
      assert_not_nil(warning.comment)
      assert(warning.comment.status)
    end
  end


  #########################################################
	##				Test Task3 2010A														###
	#########################################################
	# test: find_all_source_files_having_warnings

	def test_ut_rsf10a_t3_wam_08_001
		subtask_id = 9
		source_files = ResultDirectory.find(:all,
																				:conditions => {:id => 42},
																			:select			=> "id, subtask_id, parent_id, name, path")
		found_source_files = Warning.find_all_source_files_having_warnings(subtask_id)
		assert_equal source_files, found_source_files
	end

	def test_ut_rsf10a_t3_wam_08_002
		source_files = []
		subtask_id = -1
		found_source_files = Warning.find_all_source_files_having_warnings(subtask_id)
		assert_equal source_files, found_source_files
	end

	def test_ut_rsf10a_t3_wam_08_003
		directories = []
		directory1 = ResultDirectory.find(:all,
												 :conditions => {:id => 40},
																				:select			=> "id, subtask_id, parent_id, name, path")
    directory2 = ResultDirectory.find(:all,
												 :conditions => {:id => 41},
																				:select			=> "id, subtask_id, parent_id, name, path")
		directories += directory1
		directories += directory2
		subtask_id = 9
		found_directory = Warning.find_all_directories_having_warnings(subtask_id)
		assert_equal directories, found_directory
	end

	def test_ut_rsf10a_t3_wam_08_004
		directories = []
		subtask_id = -1
		found_directory = Warning.find_all_directories_having_warnings(-1)
		assert_equal directories, found_directory
	end

  #########################################################
	##				Test Task5 2011A														###
	#########################################################
  # test check_existence_issue?
  # corresponding issue has existed
  def test_ut_cbtt11a_t5_001
    warning = Warning.find(169)
    new_issue = RedmineIssue.new
    new_issue.tracker_id = 1
    new_issue.project_id = 1
    new_issue.subject = "[contrib/hgsh/hgsh.c] / [145] / [11] / [3204]"
    new_issue.description = "[Warning message]"
    new_issue.status_id = 6
    new_issue.priority_id = 5
    new_issue.author_id = 1
    new_issue.lock_version = 2
    new_issue.save
    #
    # create new warning issue
    new_warning_issue = WarningIssue.new
    new_warning_issue.warning_id = 169
    new_warning_issue.redmine_issue_id = new_issue.id
    new_warning_issue.save
    # check existence
    assert_equal(warning.check_existence_issue?, true)
  end

  # corresponding issue has not existed
  def test_ut_cbtt11a_t5_002
    warning = Warning.find(198)
    # check existence
    assert_equal(warning.check_existence_issue?, false)
  end

  # test create issue
  # corresponding Issue has existed
  def test_ut_cbtt11a_t5_003
     warning = Warning.find(179)
    new_issue = RedmineIssue.new
    new_issue.tracker_id = 1
    new_issue.project_id = 1
    new_issue.subject = "[contrib/hgsh/hgsh.c] / [145] / [11] / [3204]"
    new_issue.description = "[Warning message]"
    new_issue.status_id = 6
    new_issue.priority_id = 5
    new_issue.author_id = 1
    new_issue.lock_version = 2
    new_issue.save
    #
    # create new warning issue
    new_warning_issue = WarningIssue.new
    new_warning_issue.warning_id = 179
    new_warning_issue.redmine_issue_id = new_issue.id
    new_warning_issue.save

    # create issue
    warning.create_issues
    assert true
  end

  # corresponding Issue has not existed
  def test_ut_cbtt11a_t5_004
    warning = Warning.find(3425)
      # create result id
    warning_result = WarningsResult.new
    warning_result.warning_id = warning.id
    warning_result.result_id = 123
    warning_result.rule_level = Warning.find(warning).rule_level
    warning_result.save
    # create issue
    warning.create_issues
    corresponding_issue = WarningIssue.find_by_warning_id(warning.id)
    new_issue = RedmineIssue.find(corresponding_issue.redmine_issue_id)
    assert_equal(new_issue.id, corresponding_issue.redmine_issue_id)
  end

  # corresponding Issue has not existed
  # Note for issue is not created
  def test_ut_cbtt11a_t5_005
    warning = Warning.find(3425)
     # delete all Warning Issue
    warning_issues = WarningIssue.find(:all)
    warning_issues.each do |warning_issue|
        WarningIssue.delete_all(:warning_id => warning_issue.warning_id)
    end
      # create result id
    warning_result = WarningsResult.new
    warning_result.warning_id = warning.id
    warning_result.result_id = 123
    warning_result.rule_level = Warning.find(warning).rule_level
    warning_result.save
    # create issue
    warning.create_issues
    corresponding_issue = WarningIssue.find_by_warning_id(warning.id)
    new_issue = RedmineIssue.find(corresponding_issue.redmine_issue_id)
    issue_note = RedmineJournal.find_by_journalized_id(corresponding_issue.redmine_issue_id)
    assert_equal(issue_note, nil)
    assert_equal(new_issue.id, corresponding_issue.redmine_issue_id)
  end

  # corresponding Issue has not existed
  # Action Status of new Issue is New
  def test_ut_cbtt11a_t5_006
    warning = Warning.find(3425)
      # create result id
    warning_result = WarningsResult.new
    warning_result.warning_id = warning.id
    warning_result.result_id = 123
    warning_result.rule_level = Warning.find(warning).rule_level
    warning_result.save
    # create issue
    warning.create_issues
    corresponding_issue = WarningIssue.find_by_warning_id(warning.id)
    new_issue = RedmineIssue.find(corresponding_issue.redmine_issue_id)
    assert_equal(new_issue.status_id, 1)
    assert_equal(new_issue.id, corresponding_issue.redmine_issue_id)
  end

  # corresponding Issue has not existed
  # Action Status of new Issue is New
  def test_ut_cbtt11a_t5_007
    warning = Warning.find(3425)
    # create comment for warning
    new_comment = Comment.new
    new_comment.warning_description = "warning samdsfdf"
    new_comment.status = 1
    new_comment.risk_type_id = 2
    new_comment.warning_id = 3425
    new_comment.sample_source_code = "sample source code"
    new_comment.save
      # create result id
    warning_result = WarningsResult.new
    warning_result.warning_id = warning.id
    warning_result.result_id = 123
    warning_result.rule_level = Warning.find(warning).rule_level
    warning_result.save
    # create issue
    warning.create_issues
    corresponding_issue = WarningIssue.find_by_warning_id(warning.id)
    new_issue = RedmineIssue.find(corresponding_issue.redmine_issue_id)
    assert_equal(new_issue.status_id, 1)
    assert_equal(new_issue.id, corresponding_issue.redmine_issue_id)
  end

  # corresponding Issue has not existed
  # Comment for warning has existed
  # Action Status of new Issue is New
  def test_ut_cbtt11a_t5_008
    warning = Warning.find(3425)
    # create comment for warning
    new_comment = Comment.new
    new_comment.warning_description = "warning samdsfdf"
    new_comment.status = 1
    new_comment.risk_type_id = 4
    new_comment.warning_id = 3425
    new_comment.sample_source_code = "sample source code"
    new_comment.save
      # create result id
    warning_result = WarningsResult.new
    warning_result.warning_id = warning.id
    warning_result.result_id = 123
    warning_result.rule_level = Warning.find(warning).rule_level
    warning_result.save
    # create issue
    warning.create_issues
    corresponding_issue = WarningIssue.find_by_warning_id(warning.id)
    new_issue = RedmineIssue.find(corresponding_issue.redmine_issue_id)
    assert_equal(new_issue.status_id, 1)
    assert_equal(new_issue.id, corresponding_issue.redmine_issue_id)
  end

  # corresponding Issue has not existed
  # Comment for warning has existed
  # New note for Issue is created
  def test_ut_cbtt11a_t5_009
    warning = Warning.find(3425)
    # create comment for warning
    new_comment = Comment.new
    new_comment.warning_description = "warning samdsfdf"
    new_comment.status = 1
    new_comment.risk_type_id = 4
    new_comment.warning_id = 3425
    new_comment.sample_source_code = "sample source code"
    new_comment.save
    # create result id
    warning_result = WarningsResult.new
    warning_result.warning_id = warning.id
    warning_result.result_id = 123
    warning_result.rule_level = Warning.find(warning).rule_level
    warning_result.save
    # create issue
    warning.create_issues
    corresponding_issue = WarningIssue.find_by_warning_id(warning.id)
    new_issue = RedmineIssue.find(corresponding_issue.redmine_issue_id)
    # create issue note for Issue
    note_issue = RedmineJournal.new
    note_issue.journalized_id = new_issue.id
    note_issue.journalized_type = "Issue"
    note_issue.user_id = 1
    note_issue.notes = new_comment.warning_description
    note_issue.save
#    issue_note = RedmineJournal.find_by_journalized_id(corresponding_issue.redmine_issue_id)
    assert_equal(note_issue.journalized_id, new_issue.id)
    assert_equal(new_issue.id, corresponding_issue.redmine_issue_id)
  end

  # corresponding Issue has not existed
  # Comment for warning has existed
  # New note for Issue is created
  # The content of Note is the same that of comment
  def test_ut_cbtt11a_t5_010
    warning = Warning.find(3425)
    # create comment for warning
    new_comment = Comment.new
    new_comment.warning_description = "warning samdsfdf"
    new_comment.status = 1
    new_comment.risk_type_id = 4
    new_comment.warning_id = 3425
    new_comment.sample_source_code = "sample source code"
    new_comment.save
      # create result id
    warning_result = WarningsResult.new
    warning_result.warning_id = warning.id
    warning_result.result_id = 123
    warning_result.rule_level = Warning.find(warning).rule_level
    warning_result.save
    # create issue
    warning.create_issues
    corresponding_issue = WarningIssue.find_by_warning_id(warning.id)
    new_issue = RedmineIssue.find(corresponding_issue.redmine_issue_id)
     # create issue note for Issue
    note_issue = RedmineJournal.new
    note_issue.journalized_id = new_issue.id
    note_issue.journalized_type = "Issue"
    note_issue.user_id = 1
    note_issue.notes = new_comment.warning_description
    note_issue.save
    issue_note = RedmineJournal.find_by_journalized_id(corresponding_issue.redmine_issue_id)
    assert_equal(note_issue.journalized_id, new_issue.id)
    assert_equal(issue_note.notes, new_comment.warning_description)
    assert_equal(new_issue.id, corresponding_issue.redmine_issue_id)
  end

  # test create issue note
  # Issue note has not created
  def test_ut_cbtt11a_t5_011
    # delete all Warning Issue
    warning_issues = WarningIssue.find(:all)
    warning_issues.each do |warning_issue|
        WarningIssue.delete_all(:warning_id => warning_issue.warning_id)
    end
    warning = Warning.find(3427)
      # create result id
    warning_result = WarningsResult.new
    warning_result.warning_id = warning.id
    warning_result.result_id = 123
    warning_result.rule_level = Warning.find(warning).rule_level
    warning_result.save
    # create issue
    warning.create_issues
    issue = WarningIssue.find_by_warning_id(warning.id)
    warning.create_issue_note(issue.redmine_issue_id)
    issue_note = RedmineJournal.find_by_journalized_id(issue.redmine_issue_id)
    assert_equal(issue_note, nil)
  end

   # Action Status of Comment for Warning is Temporary
   # Issue note has not created
  def test_ut_cbtt11a_t5_012
    warning = Warning.find(3428)
    # create comment for warning
    new_comment = Comment.new
    new_comment.warning_description = "warning samdsfdf"
    new_comment.status = false
    new_comment.risk_type_id = 1
    new_comment.warning_id = 3428
    new_comment.sample_source_code = "sample source code"
    new_comment.save
      # create result id
    warning_result = WarningsResult.new
    warning_result.warning_id = warning.id
    warning_result.result_id = 123
    warning_result.rule_level = Warning.find(warning).rule_level
    warning_result.save
    # create issue
    warning.create_issues
    issue = WarningIssue.find_by_warning_id(warning.id)
#    warning.create_issue_note(issue.redmine_issue_id)
    issue_note = RedmineJournal.find_by_journalized_id(issue.redmine_issue_id)
    assert_equal(nil, issue_note)
  end

  # Comment for Warning has existed
   # Note for Issue has existed
   # The content of Comment and Note are the same
  def test_ut_cbtt11a_t5_013
    warning = Warning.find(3428)
    # create comment for warning
    new_comment = Comment.new
    new_comment.warning_description = "warning samdsfdf"
    new_comment.status = false
    new_comment.risk_type_id = 1
    new_comment.warning_id = 3428
    new_comment.sample_source_code = "sample source code"
    new_comment.save
      # create result id
    warning_result = WarningsResult.new
    warning_result.warning_id = warning.id
    warning_result.result_id = 123
    warning_result.rule_level = Warning.find(warning).rule_level
    warning_result.save
    # create issue
    warning.create_issues
    issue = WarningIssue.find_by_warning_id(warning.id)
    warning.create_issue_note(issue.redmine_issue_id)
    issue_note = RedmineJournal.find_by_journalized_id(issue.redmine_issue_id)
    assert_equal(nil, issue_note)
  end

   # corresponding Issue has existed
  # Comment for warning has existed
  # New note for Issue is created
  # The content of Note is the same that of comment
  def test_ut_cbtt11a_t5_014
    warning = Warning.find(3425)
    # create comment for warning
    new_comment = Comment.new
    new_comment.warning_description = "warning samdsfdf"
    new_comment.status = 1
    new_comment.risk_type_id = 4
    new_comment.warning_id = 3425
    new_comment.sample_source_code = "sample source code"
    new_comment.save
      # create result id
    warning_result = WarningsResult.new
    warning_result.warning_id = warning.id
    warning_result.result_id = 123
    warning_result.rule_level = Warning.find(warning).rule_level
    warning_result.save
    # create issue
    warning.create_issues
    corresponding_issue = WarningIssue.find_by_warning_id(warning.id)
    new_issue = RedmineIssue.find(corresponding_issue.redmine_issue_id)
    # create issue note for Issue
    note_issue = RedmineJournal.new
    note_issue.journalized_id = new_issue.id
    note_issue.journalized_type = "Issue"
    note_issue.user_id = 1
    note_issue.notes = new_comment.warning_description
    note_issue.save
    issue_note = RedmineJournal.find_by_journalized_id(corresponding_issue.redmine_issue_id)
    assert_equal(note_issue.journalized_id, new_issue.id)
    assert_equal(issue_note.notes, new_comment.warning_description)
    assert_equal(new_issue.id, corresponding_issue.redmine_issue_id)
  end

  # test synchronize Issue
  # new Issue is created
  def test_ut_cbtt11a_t5_015
    warning = Warning.find(3429)
      # create result id
    warning_result = WarningsResult.new
    warning_result.warning_id = warning.id
    warning_result.result_id = 123
    warning_result.rule_level = Warning.find(warning).rule_level
    warning_result.save
    warning.synchronize_issues
    corresponding_issue = WarningIssue.find_by_warning_id(warning.id)
    issue = RedmineIssue.find(corresponding_issue.redmine_issue_id)
    assert_equal(issue.id, corresponding_issue.redmine_issue_id)
  end

  # status of new Issue is REJECTED
  def test_ut_cbtt11a_t5_016
    warning = Warning.find(3440)
      # create result id
    warning_result = WarningsResult.new
    warning_result.warning_id = warning.id
    warning_result.result_id = 123
    warning_result.rule_level = Warning.find(warning).rule_level
    warning_result.save
    warning.create_issues
    # create comment for warning
    new_comment = Comment.new
    new_comment.warning_description = "warning samdsfdf"
    new_comment.status = 1
    new_comment.risk_type_id = 2
    new_comment.warning_id = 3440
    new_comment.sample_source_code = "sample source code"
    new_comment.save
    # synchronize issue
    warning.synchronize_issues
    corresponding_issue = WarningIssue.find_by_warning_id(warning.id)
    issue = RedmineIssue.find(corresponding_issue.redmine_issue_id)
    assert_equal(issue.status_id, 6)
  end

   # status of new Issue is updated
  def test_ut_cbtt11a_t5_017
    warning = Warning.find(3440)
      # create result id
    warning_result = WarningsResult.new
    warning_result.warning_id = warning.id
    warning_result.result_id = 123
    warning_result.rule_level = Warning.find(warning).rule_level
    warning_result.save
    warning.create_issues
    # create comment for warning
    new_comment = Comment.new
    new_comment.warning_description = "warning samdsfdf"
    new_comment.status = 1
    new_comment.risk_type_id = 2
    new_comment.warning_id = 3440
    new_comment.sample_source_code = "sample source code"
    new_comment.save
    # synchronize issue
    warning.synchronize_issues
    corresponding_issue = WarningIssue.find_by_warning_id(warning.id)
    issue = RedmineIssue.find(corresponding_issue.redmine_issue_id)
    assert_equal(issue.status_id, 6)
  end

  # issue note is not created
  def test_ut_cbtt11a_t5_018
    warning = Warning.find(3441)
      # create result id
    warning_result = WarningsResult.new
    warning_result.warning_id = warning.id
    warning_result.result_id = 123
    warning_result.rule_level = Warning.find(warning).rule_level
    warning_result.save
    warning.create_issues
    corresponding_issue = WarningIssue.find_by_warning_id(warning.id)
    # create note for Issue
    note = RedmineJournal.new
    note.journalized_id = corresponding_issue.redmine_issue_id
    note.journalized_type = "Issue"
    note.notes = "test"
    note.save
    # synchronize issue
    warning.synchronize_issues
    issue = RedmineIssue.find(corresponding_issue.redmine_issue_id)
    assert true
  end

  # Note for Issue has existed
  # issue note is not created
  def test_ut_cbtt11a_t5_019
    warning = Warning.find(3441)
      # create result id
    warning_result = WarningsResult.new
    warning_result.warning_id = warning.id
    warning_result.result_id = 123
    warning_result.rule_level = Warning.find(warning).rule_level
    warning_result.save
    warning.create_issues
    corresponding_issue = WarningIssue.find_by_warning_id(warning.id)
    # create note for Issue
    note = RedmineJournal.new
    note.journalized_id = corresponding_issue.redmine_issue_id
    note.journalized_type = "Issue"
    note.notes = "test"
    note.save
    # synchronize issue
    warning.synchronize_issues
    issue = RedmineIssue.find(corresponding_issue.redmine_issue_id)
    assert true
  end

   # status of new Issue is updated
   # the content of Note and comment are the same
  def test_ut_cbtt11a_t5_020
    warning = Warning.find(3442)
      # create result id
    warning_result = WarningsResult.new
    warning_result.warning_id = warning.id
    warning_result.result_id = 123
    warning_result.rule_level = Warning.find(warning).rule_level
    warning_result.save
    warning.create_issues
    # create comment for warning
    new_comment = Comment.new
    new_comment.warning_description = "warning samdsfdf"
    new_comment.status = 1
    new_comment.risk_type_id = 2
    new_comment.warning_id = 3442
    new_comment.sample_source_code = "sample source code"
    new_comment.save
    # synchronize issue
    warning.synchronize_issues
    corresponding_issue = WarningIssue.find_by_warning_id(warning.id)
    issue = RedmineIssue.find(corresponding_issue.redmine_issue_id)
    note = RedmineJournal.find_by_journalized_id(issue.id)
    assert_equal(note.notes, new_comment.warning_description)
  end

  # test action status
  # return action status
  def test_ut_cbtt11a_t5_021
    warning = Warning.find(3443)
    # create comment for warning
    new_comment = Comment.new
    new_comment.warning_description = "warning samdsfdf"
    new_comment.status = 1
    new_comment.risk_type_id = 3
    new_comment.warning_id = 3443
    new_comment.sample_source_code = "sample source code"
    new_comment.save
    assert_equal(warning.action_status, new_comment.risk_type_id)
    warning.action_status
  end
  
  # there is no comment for Warning
  # return 0
  def test_ut_cbtt11a_t5_022
    warning = Warning.find(3448)
    #
    assert_equal(warning.action_status, 0)
  end

  # test tool name
  # return tool name
  def test_ut_cbtt11a_t5_023
    warning = Warning.find(3444)
    # create comment for warning
    tool_id = warning.subtask.analyze_tool_id
    tool_name = AnalyzeTool.find(tool_id).name
    assert_equal(tool_name, warning.tool_name)
  end

end
