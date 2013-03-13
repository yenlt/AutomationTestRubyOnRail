require File.dirname(__FILE__) + '/../test_helper'
require 'diff/lcs/array'
class DiffFileTest < ActiveSupport::TestCase
  INVALID_DIFF_FILE_ID = 10000
  INVALID_FILE_ID      = 10000
  def setup
    @last = DiffFile.find(:last)
    @diff_file_test = DiffFile.create(:diff_result_id => 18,
                                      :old_original_file_id => 110,
                                      :new_original_file_id => 98)
  end

  def test_ut_rrf10b_t3_01
    #TEST IMPORT_DIFF_FILE_CONTENT FUNCTION
    rule_levels = {"critical" => 3, "hirisk" => 2, "normal" => 1}
    check = DiffFile.find(:last)
    DiffFile.update(@last.id, :critical_contents => "",
                              :hirisk_contents   => "",
                              :normal_contents   => "")

    @last.import_diff_file_contents(rule_levels)

    assert_equal @last.critical_contents, check.critical_contents
    assert_equal @last.hirisk_contents, check.hirisk_contents
    assert_equal @last.normal_contents, check.normal_contents
  end

  def test_ut_rrf10b_t3_02
    #TEST CREATE_PAGE_BODY FUNCTION
    rule_levels = {"critical" => 3, "hirisk" => 2, "normal" => 1}
    rule_levels.each_value do |v|
      created = @last.create_page_body(@last.id, v)
      assert_equal @last.critical_contents, created if v == 3
      assert_equal @last.hirisk_contents, created if v == 2
      assert_equal @last.normal_contents, created if v == 1
    end
  end

  def test_ut_rrf10b_t3_03
    #TEST CREATE_PAGE_BODY FUNCTION: IVALID DIFF FILE ID
    #RETURN IS ''
    rule_levels = {"critical" => 3, "hirisk" => 2, "normal" => 1}
    rule_levels.each_value do |v|
      created = @last.create_page_body(INVALID_DIFF_FILE_ID, v)
      assert_equal created, ''
      assert_not_equal @last.critical_contents, created if v == 3
      assert_not_equal @last.hirisk_contents, created if v == 2
      assert_not_equal @last.normal_contents, created if v == 1
    end
  end

  def test_ut_rrf10b_t3_04
    #TEST GET_SOURCE_CODE_FROM_RESULT FUNCTION
    rule_levels = {"critical" => 3, "hirisk" => 2, "normal" => 1}
    rule_levels.each_value do |v|
      old_source = @last.get_source_code_from_result(@last.id, @last.old_original_file_id, v)
      new_source = @last.get_source_code_from_result(@last.id, @last.new_original_file_id, v)
      old_check = OriginalSourceCode.find(:all,
        :conditions => "original_file_id = #{@last.old_original_file_id} and
                        error_line in (0, #{v})")
      new_check = OriginalSourceCode.find(:all,
        :conditions => "original_file_id = #{@last.new_original_file_id} and
                        error_line in (0, #{v})")
      #CHECK RETURN OF FUCNTION
      old_check.each do |ock|
        if old_source.include?(ock.line_content)
          assert true
        end
      end
      new_check.each do |nck|
        if new_source.include?(nck.line_content)
          assert true
        end
      end
    end
  end

  def test_ut_rrf10b_t3_05
    #TEST GET_SOURCE_CODE_FROM_RESULT FUNCTION: INVALID INPUT OLD FILE AND NEW FILE
    #RETURN RESULT IS ''
    rule_levels = {"critical" => 3, "hirisk" => 2, "normal" => 1}
    rule_levels.each_value do |v|
      old_source = @last.get_source_code_from_result(@last.id, INVALID_FILE_ID, v)
      new_source = @last.get_source_code_from_result(@last.id, INVALID_FILE_ID, v)
      assert_equal old_source, ''
      assert_equal new_source, ''
    end
  end

  def test_ut_rrf10b_t3_06
    #TEST MODIFY_LINE_OF_CODE FUNCTION
    f1 = OriginalFile.find_by_id(@last.old_original_file_id)
    f2 = OriginalFile.find_by_id(@last.new_original_file_id)
    result1 = Result.find_by_id(f1.critical_result_id)
    result2 = Result.find_by_id(f2.critical_result_id)
    old_line = DiffSourceCode.find_by_diff_file_id_and_original_file_id(@last.id, @last.old_original_file_id)
    new_line = DiffSourceCode.find_by_diff_file_id_and_original_file_id(@last.id, @last.new_original_file_id)
    modified1 = @last.modify_line_of_code(result1, @last.id, @last.old_original_file_id)
    modified2 = @last.modify_line_of_code(result2, @last.id, @last.new_original_file_id)

    del_line = old_line.deleted_lines.split(/;/)
    add_line = new_line.added_lines.split(/;/)

    del_line.each do |d|
      if modified1.include?("<td id=\"#{d}\" class=\"deleted_line\">")
        assert true
      end
    end
    add_line.each do |a|
      if modified2.include?("<td id=\"#{a}\" class=\"added_line\">")
        assert true
      end
    end
  end

  def test_ut_rrf10b_t3_07
    #TEST MODIFY_LINE_OF_CODE FUNCTION: INVALID INPUT RESULT
    #RETURN ""
    result1 = ""
    result2 = ""
    modified1 = @last.modify_line_of_code(result1, @last.id, @last.old_original_file_id)
    modified2 = @last.modify_line_of_code(result2, @last.id, @last.new_original_file_id)

    assert modified1, ""
    assert modified2, ""
  end

  def test_ut_rrf10b_t3_08
    #TEST MODIFY_WARNING_OF_CODE FUNCTION
    f1 = OriginalFile.find_by_id(@last.old_original_file_id)
    result1 = Result.find_by_id(f1.critical_result_id)
    modified1 = @last.modify_line_of_code(result1, @last.id, @last.old_original_file_id)
    modified = @last.modify_warning_of_code(modified1, f1.id, @last.id, 3)
    status = {"deleted" => 3, "added" => 2, "common" => 1}
    status.each_value do |ds|
      warnings = DiffWarning.find_all_by_diff_file_id_and_original_file_id_and_diff_status_id_and_rule_set(@last.id, f1.id, ds, 3)
      warnings.each do |w|
        if modified.include?("<div class=\"deleted_warning\" id=\"warning_#{w.warning_id}\">")
          assert true
        elsif modified.include?("<div class=\"added_warning\" id=\"warning_#{w.warning_id}\">")
          assert true
        elsif modified.include?("<div class=\"common_warning\" id=\"warning_#{w.warning_id}\">")
          assert true
        end
      end

    end
  end

  def test_ut_rrf10b_t3_09
    #TEST MODIFY_WARNING_OF_CODE FUNCTION: INVALID INPUT RESULT
    #RETURN ""
    f1 = OriginalFile.find_by_id(@last.old_original_file_id)
    result1 = ""
    modified1 = @last.modify_line_of_code(result1, @last.id, @last.old_original_file_id)
    modified2 = @last.modify_warning_of_code(modified1, f1.id, @last.id, 3)

    assert_equal modified2, ""
  end

  def test_ut_rrf10b_t3_10
    #TEST CREATE_TABLE_OF_DIFF FUNCTION
    diff_file = DiffFile.find_by_id(@last.id)
    old_file = Array.new
    new_file = Array.new
    #GET SOURCE CODE
    x = diff_file.get_source_code_from_result(@last.id, @last.old_original_file_id, 3)
    y = diff_file.get_source_code_from_result(@last.id, @last.new_original_file_id, 3)
    #PUT SOURCE CODE INTO ARRAY OF [<TD>...</TD>, ..]
    #OLD FILE
    x.scan(/(<\s*td[^>]*>.*?<\s*\/\s*td>)/) { |sx|
      if !sx[0].include?("ERR_LINE")
        old_file = old_file.push("#{sx}")
      else
        old_file.delete_at(old_file.length-1)
      end
    }
    #NEW FILE
    y.scan(/(<\s*td[^>]*>.*?<\s*\/\s*td>)/) { |sy|
      if !sy[0].include?("ERR_LINE")
        new_file = new_file.push("#{sy}")
      else
        new_file.delete_at(new_file.length-1)
      end
    }

    created = @last.create_table_of_diff(old_file, new_file)

    assert_equal @last.critical_contents, created
  end

  def test_ut_rrf10b_t3_11
    #TEST CREATE_TABLE_OF_DIFF FUNCTION: INVALID INPUT
    #RETURN RESULT IS ''
    created = @last.create_table_of_diff("", [])

    assert_equal created, ""
  end

  def test_ut_rrf10b_t3_12
    #TEST INSERT_LINE FUNCTION
    check1 = ["LINE", "CODE"]
    insert = ["", ""]
    inserted = @last.insert_line(insert, 0, "LINE", "CODE")

    assert_equal check1[0], inserted[0]
    assert_equal check1[1], inserted[1]
  end

  def test_ut_rrf10b_t3_13
    #TEST PUSH_WARNING_LINE FUNCTION
    old_ck = ["LINE1","CODE1",
              "","deleted_warning",
              "","",
              "LINE2","CODE2",
              "", "added_warning"]
    new_ck = ["LINE1","CODE1",
              "","deleted_warning",
              "","",
              "LINE2","CODE2",
              "", "added_warning"]
    check1 = @last.push_warning_line("", old_ck, new_ck, 1)
    check2 = @last.push_warning_line("", old_ck, new_ck, 5)

    if check1.include?("deleted_warning")
      assert true
    end
    assert_equal "<tr>LINE2CODE2LINE2CODE2</tr>\n", check2
  end

   ###********** Test UT T3  2010B ************####
	## ******** Comment Succession ******####
	##************************************************##
	## Test classify_warnings
  #  Input: + Exist two original comment have status is common
  #         + Comment Succession status is true
  #  Output: + Have two new comment is create
  #          + Content of each comment is match with corresponding comment
  #
  def notest_ut_t3_cs_dfi_001
     original_comment = Comment.new(:warning_description => "test warning description",
																							 :status							=> 1,
																							 :risk_type_id				=> 3,
																							 :warning_id					=> 8021,
																							 :sample_source_code	=> "sample source code")
		 # save original comment to database
		 assert original_comment.save
     @diff_file_test.send :classify_warnings, 'true', 1
     copying_comment = Comment.find_by_warning_id(8967)
     assert_equal original_comment.risk_type_id, copying_comment.risk_type_id
     assert_equal original_comment.status, copying_comment.status
     assert_equal original_comment.warning_description, copying_comment.warning_description
     assert_equal original_comment.sample_source_code, copying_comment.sample_source_code
     assert_equal 8967, copying_comment.warning_id

     original_comment1 = Comment.new(:warning_description => "test warning description1",
																							 :status							=> 1,
																							 :risk_type_id				=> 3,
																							 :warning_id					=> 8022,
																							 :sample_source_code	=> "sample source code1")
		 # save original comment 1 to database
		 assert original_comment1.save
     @diff_file_test.send :classify_warnings, 'true', 1
     copying_comment1 = Comment.find_by_warning_id(8968)
     assert_equal original_comment1.risk_type_id, copying_comment1.risk_type_id
     assert_equal original_comment1.status, copying_comment1.status
     assert_equal original_comment1.warning_description, copying_comment1.warning_description
     assert_equal original_comment1.sample_source_code, copying_comment1.sample_source_code
     assert_equal 8968, copying_comment1.warning_id

  end

  #  Input: + Have no exist original comment have status is common
  #         + Comment Succession status is true
  #  Output: + Have no new comment is create
  #
  def notest_ut_t3_cs_dfi_002

     @diff_file_test.send :classify_warnings, 'true', 1
     copying_comment = Comment.find_by_warning_id(8968)
     copying_comment1 = Comment.find_by_warning_id(8967)
     assert_equal true, copying_comment.nil?
     assert_equal true, copying_comment1.nil?
  end

  #  Input: + Exist original comment have status is common
  #         + Exist corresponding comment with original comment
  #         + Comment Succession status is true
  #  Output: + Have no change with two exist comment
  #
  def notest_ut_t3_cs_dfi_003
     original_comment = Comment.new(:warning_description => "test warning description",
																							 :status							=> 1,
																							 :risk_type_id				=> 3,
																							 :warning_id					=> 8021,
																							 :sample_source_code	=> "sample source code")
		 # save original comment to database
		 assert original_comment.save

     corresponding_comment = Comment.new(:warning_description => "corresponding test warning description",
																							 :status							=> 5,
																							 :risk_type_id				=> 2,
																							 :warning_id					=> 8967,
																							 :sample_source_code	=> "corresponding sample source code")
		 # save corresponding comment to database
		 assert corresponding_comment.save
     @diff_file_test.send :classify_warnings, 'true', 1

     assert_not_equal original_comment.risk_type_id, corresponding_comment.risk_type_id
     assert_not_equal original_comment.status, corresponding_comment.status
     assert_not_equal original_comment.warning_description, corresponding_comment.warning_description
     assert_not_equal original_comment.sample_source_code, corresponding_comment.sample_source_code

     original_comment.destroy
     corresponding_comment.destroy
  end

  #  Input: + Exist two original comment have status is common
  #         + Comment Succession status is false
  #  Output: + Have no new comment is create
  #
  def notest_ut_t3_cs_dfi_004
     original_comment = Comment.new(:warning_description => "test warning description",
																							 :status							=> 1,
																							 :risk_type_id				=> 3,
																							 :warning_id					=> 8021,
																							 :sample_source_code	=> "sample source code")
		 # save original comment to database
		 assert original_comment.save
     @diff_file_test.send :classify_warnings, 'false', 1
     copying_comment = Comment.find_by_warning_id(8967)

     original_comment1 = Comment.new(:warning_description => "test warning description1",
																							 :status							=> 1,
																							 :risk_type_id				=> 3,
																							 :warning_id					=> 7998,
																							 :sample_source_code	=> "sample source code1")
		 # save original comment 1 to database
		 assert original_comment1.save
     @diff_file_test.send :classify_warnings, 'false', 1
     copying_comment1 = Comment.find_by_warning_id(8944)
     assert_equal true, copying_comment.nil?
     assert_equal true, copying_comment1.nil?
  end

  #  Input: + Exist two original comment have status is not common
  #         + Comment Succession status is true
  #  Output: + Have two new comment is create
  #
  def notest_ut_t3_cs_dfi_005
     original_comment = Comment.new(:warning_description => "test warning description",
																							 :status							=> 0,
																							 :risk_type_id				=> 3,
																							 :warning_id					=> 8021,
																							 :sample_source_code	=> "sample source code")
		 # save original comment to database
		 assert original_comment.save
     @diff_file_test.send :classify_warnings, 'true', 1
     copying_comment = Comment.find_by_warning_id(8967)

     original_comment1 = Comment.new(:warning_description => "test warning description1",
																							 :status							=> 0,
																							 :risk_type_id				=> 3,
																							 :warning_id					=> 7998,
																							 :sample_source_code	=> "sample source code1")
		 # save original comment 1 to database
		 assert original_comment1.save
     @diff_file_test.send :classify_warnings, 'true', 1
     copying_comment1 = Comment.find_by_warning_id(8944)
     assert_equal true, copying_comment.nil?
     assert_equal true, copying_comment1.nil?
  end

  #  Input: + Exist two original comment: one comment have status is common and the other is not
  #         + Comment Succession status is true
  #  Output: + Have new comment is create: new comment match with comment have status is common
  #
  def notest_ut_t3_cs_dfi_006
     original_comment = Comment.new(:warning_description => "test warning description",
																							 :status							=> 0,
																							 :risk_type_id				=> 3,
																							 :warning_id					=> 8021,
																							 :sample_source_code	=> "sample source code")
		 # save original comment to database
		 assert original_comment.save
     @diff_file_test.send :classify_warnings, 'true', 1
     copying_comment = Comment.find_by_warning_id(8967)

     original_comment1 = Comment.new(:warning_description => "test warning description1",
																							 :status							=> 1,
																							 :risk_type_id				=> 3,
																							 :warning_id					=> 8022,
																							 :sample_source_code	=> "sample source code1")
		 # save original comment 1 to database
		 assert original_comment1.save
     @diff_file_test.send :classify_warnings, 'true', 1
     copying_comment1 = Comment.find_by_warning_id(8968)
     assert_equal true, copying_comment.nil?
     assert_equal true, !copying_comment1.nil?
  end

   #  Input: + Exist two original comment: one comment have status is common and the other is not
  #         + Comment Succession status is false
  #  Output: + Have new comment is create: new comment match with comment have status is common
  #
  def notest_ut_t3_cs_dfi_007
     original_comment = Comment.new(:warning_description => "test warning description",
																							 :status							=> 0,
																							 :risk_type_id				=> 3,
																							 :warning_id					=> 7998,
																							 :sample_source_code	=> "sample source code")
		 # save original comment to database
		 assert original_comment.save
     @diff_file_test.send :classify_warnings, 'false', 1
     copying_comment = Comment.find_by_warning_id(8944)

     copying_comment1 = Comment.new(:warning_description => "test warning description1",
																							 :status							=> 1,
																							 :risk_type_id				=> 3,
																							 :warning_id					=> 8022,
																							 :sample_source_code	=> "sample source code1")
		 # save original comment 1 to database
		 assert copying_comment1.save
     @diff_file_test.send :classify_warnings, 'false', 1
     copying_comment1 = Comment.find_by_warning_id(8968)

     assert_equal true, copying_comment.nil?
     assert_equal true, copying_comment1.nil?
  end


#  def test_000
#    import_sql
#  end
#
#  #test the validations inside the model
#  def test_ut_rrf10b_t3_01
#    assert @diff_file.save
#    diff_file_copy = DiffFile.find(@diff_file.id)
#    assert_equal @diff_file.old_original_file_id, diff_file_copy.old_original_file_id
#    @diff_file.old_original_file_id = 1
#    assert @diff_file.valid?
#    assert @diff_file.destroy
#  end
#
#  #test initialization of difffile'model.
#  def test_ut_rrf10b_t3_02
#    diff_file = DiffFile.new(:diff_result_id =>2,
#      :old_original_file_id =>3,
#      :new_original_file_id =>4)
#    assert_equal(2,diff_file.diff_result_id)
#    assert_equal(3,diff_file.old_original_file_id)
#    assert_equal(4,diff_file.new_original_file_id)
#  end
#
#  # test function:execute_diff
#  # Return:
#  #   Two recored in diff_source_codes table was created to store the result
#  #   of diff algorithm
#  #   Status of all warnings belong to each file in pair was decided
#  def test_ut_rrf10b_t3_ex_03
#    assert true # manual test
#  end
end
