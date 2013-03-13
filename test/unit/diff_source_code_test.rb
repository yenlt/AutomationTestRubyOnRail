require File.dirname(__FILE__) + '/../test_helper'
require 'diff/lcs/array'
class DiffSourceCodeTest < ActiveSupport::TestCase 
  def setup
    @diff_source_code_1 = DiffSourceCode.new(
                                           :diff_result_id =>1,
                                           :diff_file_id =>1,
                                           :original_file_id =>1,
                                           :added_lines => nil,
                                           :deleted_lines => "7;8;9;25;390;396;397;400;404" ,
                                           :common_lines => "1,1;2,2;3,3;4,4;6,6;10,10;11,11;12,12;13,13;14,14;15,15;")
   @diff_source_code_2 = DiffSourceCode.new(
                                             :diff_result_id =>1,
                                             :diff_file_id =>1,
                                             :original_file_id =>2,
                                             :added_lines => "5;7;8;9;25;390;396;397;400;404",
                                             :deleted_lines => nil ,
                                             :common_lines => "1,;2,3;3,7;4,8;6,6;10,10;11,11;12,12;13,13;14,14;15,15;")
   @diff_source_code_3 = DiffSourceCode.new(
                                             :diff_result_id =>1,
                                             :diff_file_id =>1,
                                             :original_file_id =>2,
                                             :added_lines => nil,
                                             :deleted_lines => nil ,
                                             :common_lines =>nil)

    @diff_source_code_4 = DiffSourceCode.new(
                                           :diff_result_id =>1,
                                           :diff_file_id =>1,
                                           :original_file_id =>1,
                                           :added_lines => "5.9   ;7.9 ;800000;9;250;390,9;39600;397;400;404",
                                           :deleted_lines => "7;  8; 0.9,25;000 ;396;397;400;404" ,
                                           :common_lines => "1,01;2,02;3,3;5,4;6,6;19,10;11,0.0;12;12;13,13;000014,140000;15000,15;")
  end
  def test_000
    import_sql
  end
  #test the validations inside the model
  def test_ut_diff_source_code_o1
    assert @diff_source_code_1.save
    diff_source_code_copy = DiffSourceCode.find(@diff_source_code_1.id)
    assert_equal @diff_source_code_1.diff_file_id, diff_source_code_copy.diff_file_id    
    assert @diff_source_code_1.valid?
    assert @diff_source_code_1.destroy
  end

   #test initialization of DiffSourceCode model.
  def test_ut_diff_source_code_02
    assert_equal(1,@diff_source_code_1.diff_result_id)
    assert_equal(1,@diff_source_code_1.original_file_id)
    assert_equal(1,@diff_source_code_1.diff_file_id)
    assert_equal(nil,@diff_source_code_1.added_lines)
    assert_equal("7;8;9;25;390;396;397;400;404",@diff_source_code_1.deleted_lines)
    assert_equal("1,1;2,2;3,3;4,4;6,6;10,10;11,11;12,12;13,13;14,14;15,15;",@diff_source_code_1.common_lines)
  end

    #Test function: get_common_lines
    # Return the common line in the Hash format:
    #   {old_position => new_position,.....}
  def test_get_common_lines_03
    #Test case: field common_lines != nil
    common_lines_1 = @diff_source_code_1.get_common_lines
    test_common_lines_1 = {11=>11, 6=>6, 12=>12, 1=>1, 13=>13, 2=>2, 14=>14, 3=>3, 15=>15, 4=>4, 10=>10}
    assert_equal test_common_lines_1,common_lines_1
    common_lines_2 = @diff_source_code_2.get_common_lines
    test_common_lines_2 = {11=>11, 6=>6, 12=>12, 1=>0, 13=>13, 2=>3, 14=>14, 3=>7, 15=>15, 4=>8, 10=>10}
    assert_equal test_common_lines_2,common_lines_2

    #Test case: field common_lines = nil
    common_lines_3 = @diff_source_code_3.get_common_lines
    test_common_lines_3 = {}
    assert_equal test_common_lines_3,common_lines_3

    #Test case: field common_lines != nil and It is special case
    common_lines_4 = @diff_source_code_4.get_common_lines
    test_common_lines_4 = {5=>4, 11=>0, 6=>6, 12=>0, 1=>1, 15000=>15, 13=>13, 2=>2, 19=>10, 14=>140000, 3=>3}
    assert_equal test_common_lines_4,common_lines_4
  end

  def test_get_deleted_lines_04
    #Test case: field deleted_lines !=nil,  Return the array of deleted lines
    test_get_deleted_lines = [7, 8, 9, 25, 390, 396, 397, 400, 404]
    get_deleted_lines_1 =  @diff_source_code_1.get_deleted_lines
    assert_equal test_get_deleted_lines,get_deleted_lines_1

    #Test case: fild deleted_lines ==nil, Return nil
    get_deleted_lines_2 =  @diff_source_code_2.get_deleted_lines
    assert_nil get_deleted_lines_2

    #Test case: fild :deleted_lines.length == 0, Return nil
    get_deleted_lines_3 =  @diff_source_code_3.get_deleted_lines
    assert_nil get_deleted_lines_3
    #Test case: field deleted_lines != nil and It is special case
    get_deleted_lines_4 =  @diff_source_code_4.get_deleted_lines
    test_get_deleted_lines_1 = [7, 8, 0, 0, 396, 397, 400, 404]
    assert_equal test_get_deleted_lines_1,get_deleted_lines_4
  end

  def test_get_added_lines_05
    #Test case: fild added_lines ==nil, Return nil
    get_added_lines_1 =  @diff_source_code_1.get_added_lines
    assert_nil get_added_lines_1

    #Test case: fild deleted_lines !=nil, Return the array of added lines
    get_added_lines_2 =  @diff_source_code_2.get_added_lines
    test_get_added_lines =[5, 7, 8, 9, 25, 390, 396, 397, 400, 404]
    assert_equal test_get_added_lines,get_added_lines_2

    #Test case: fild added_lines.length == 0, Return nil
    get_added_lines_3 = @diff_source_code_3.get_added_lines
    assert_nil get_added_lines_3

    #Test case: fild deleted_lines !=nil and It is special case.
    get_added_lines_4 =  @diff_source_code_4.get_added_lines
    test_get_added_lines_1 =[5, 7, 800000, 9, 250, 390, 39600, 397, 400, 404]
    assert_equal test_get_added_lines_1,get_added_lines_4
  end
end