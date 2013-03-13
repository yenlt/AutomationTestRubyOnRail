require File.dirname(__FILE__) + '/../test_helper'

class ResultTest < ActiveSupport::TestCase
  include AuthenticatedTestHelper
  UNEXTRACTED_SUBTASK = 7
  EXTRACTED_SUBTASK = 11
  ERROR_LINE = 35 ## this error line happenned in subtask id = 7
  ## setup
  def setup
    #system "rake db:fixtures:load FIXTURES=reviews,results,summaries"
    @unextracted_subtask = Subtask.find_by_id(UNEXTRACTED_SUBTASK)
    @extracted_subtask = Subtask.find_by_id(EXTRACTED_SUBTASK)
  end
  ## teardown
  def teardown

  end
#  #####################################################################
#  ## Find all results with a wrong keyword.
#   def test_ut_rsf10a_t3_res_001
#     results = Result.find_all_result_by_filter_keyword(1,"3",1,"wrong")
#     assert_equal 0, results.count
#   end
#  ## Find all results with a right keyword.
#   def test_ut_rsf10a_t3_res_002
#     results = Result.find_all_result_by_filter_keyword(1,"3",1,"sample_c/src")
#     assert_not_equal 0, results.count
#   end
#  ## Find all results with a regular expression keyword.
#   def test_ut_rsf10a_t3_res_003
#     results = Result.find_all_result_by_filter_keyword(1,"3",1,"sam*")
#     assert_not_equal 0, results.count
#   end
#   ####################################################################
#   #        Test Task 3 - 2010 A                                      #
#   ####################################################################
#   ## Test: create_result_body(source_file, rule_level)
#   #
#   def test_UT_RSF10A_T3_RES_001
#      source_files = @unextracted_subtask.source_files_from_warnings
#      (1..3).each do |rule_level|
#        result = Result.new
#        result_body = result.create_result_body(source_files[0], rule_level)
#        assert_not_nil result_body
#      end
#   end
#   ## Test: count_line_of_code(source_code)
#   #  source codes
#   def test_UT_RSF10A_T3_RES_002
#      source_code = SourceCode.find_by_subtask_id(UNEXTRACTED_SUBTASK)
#      result = Result.new
#      assert_not_equal result.count_line_of_source_code(source_code),0
#   end
#   ## Test: count_line_of_code(source_code)
#   #  source codes nil
#   def test_UT_RSF10A_T3_RES_003
#      source_code = SourceCode.find_by_subtask_id(UNEXTRACTED_SUBTASK)
#      source_code.body = ""
#      result = Result.new
#      assert_equal result.count_line_of_source_code(source_code),0
#   end
#   ## Test: html_header(source_file)
#   #  source_file = "sample/source"
#   def test_UT_RSF10A_T3_RES_004
#     source_file = "sample/source"
#     result = Result.new
#     assert_not_nil result.html_header(source_file)
#     assert_not_nil result.html_header(source_file)[/<pre style=\"margin-top: 0pt; margin-bottom: 0pt;\">==== Source listing for file: #{source_file} ==== <\/pre>/]
#   end
#   ## Test: html_header(source_file)
#   #  source_file = ""
#   def test_UT_RSF10A_T3_RES_005
#     source_file = ""
#     result = Result.new
#     assert_not_nil result.html_header(source_file)
#     assert_not_nil result.html_header(source_file)[/<pre style=\"margin-top: 0pt; margin-bottom: 0pt;\">==== Source listing for file: /]
#   end
#   ## Test: html_body_with_out_warning(source_code, line_num)
#   #  start line number = 1
#   def test_UT_RSF10A_T3_RES_006
#     source_code = SourceCode.find_by_subtask_id(UNEXTRACTED_SUBTASK)
#     line_number = 1
#     result = Result.new
#     lines = result.count_line_of_source_code(source_code)
#     result_body = result.html_body_with_out_warning(source_code, line_number)
#     assert_not_nil result_body
#     (1..lines).each do |line|
#       assert_not_nil result_body[/#{line}/]
#     end
#   end
#   ## Test: html_body_with_out_warning(source_code, line_num)
#   #  start line number = 10
#   def test_UT_RSF10A_T3_RES_007
#     source_code = SourceCode.find_by_subtask_id(UNEXTRACTED_SUBTASK)
#     line_number = 10
#     result = Result.new
#     lines = result.count_line_of_source_code(source_code) + 9
#     result_body = result.html_body_with_out_warning(source_code, line_number)
#     assert_not_nil result_body
#     (10..lines).each do |line|
#       assert_not_nil result_body[/#{line}/]
#     end
#   end
#   ## Test: html_body_with_out_warning(source_code, line_num)
#   #  start line number = 0
#   def test_UT_RSF10A_T3_RES_008
#     source_code = SourceCode.find_by_subtask_id(UNEXTRACTED_SUBTASK)
#     line_number = 0
#     result = Result.new
#     result_body = result.html_body_with_out_warning(source_code, line_number)
#     assert_equal result_body,""
#   end
#   ## Test: html_body_with_warnings(source_code, rule_level)
#   #  When rule_level = 1, there are 2 warnings for the error line
#   def test_UT_RSF10A_T3_RES_009
#     rule_level = 1
#     source_code = SourceCode.find_by_subtask_id_and_error_line(UNEXTRACTED_SUBTASK,ERROR_LINE)
#     result = Result.new(:subtask_id => UNEXTRACTED_SUBTASK)
#     result_body = result.html_body_with_warnings(source_code,rule_level)
#     assert_not_nil result_body
#     assert_not_nil result_body[/#{source_code.error_line}/] # line number
#     assert_not_nil result_body[/<div id=\"warning/]
#   end
#   ## Test: html_body_with_warnings(source_code, rule_level)
#   #  When rule_level = 3, there are no warnings for the error line
#   #  Redirect to html_body_with_out_warning
#   def test_UT_RSF10A_T3_RES_010
#     rule_level = 3
#     source_code = SourceCode.find_by_subtask_id_and_error_line(UNEXTRACTED_SUBTASK,ERROR_LINE)
#     result = Result.new(:subtask_id => UNEXTRACTED_SUBTASK)
#     result_body = result.html_body_with_warnings(source_code,rule_level)
#     assert_not_nil result_body
#     assert_not_nil result_body[/#{source_code.error_line}/] # line number
#     assert_nil result_body[/<div id=\"warning/]
#   end

  def test_ut_rrf10b_t3_14
    #TEST CREATE_RESULT_BODY FUNCTION
    source = {"path" => "sample_c/src", "name"=> "analyzeme.c"}
    res = Result.find_by_path_and_source_name_and_subtask_id_and_rule_set(source["path"], source["name"], 7, 1)
    created = res.create_result_body(source, 1)

    assert_equal created, res.contents
  end

  def test_ut_rrf10b_t3_15
    #TEST ADD_ID_INTO_SOURCE_CODE_HIGHLIGHTED FUNCTION
    source = ["sample_c/src", "analyzeme.c"]
    test_data = "<ol>\n<li>HIGHLIGHTED1</li>\n<li>HIGHLIGHTED2</li>\n<li>HIGHLIGHTED3</li>\n<ol>"
    res = Result.new()
    added = res.add_id_into_source_code_highlighted(test_data, @extracted_subtask, source[0], source[1])

    check = added.split(/\n/)
    check.each_index do |i|
      if check.include?("<tr id=\"row_#{i}\"><td class=\"line_number\">#{i}</td><td id=\"#{i}\"><pre>HIGHLIGHTED#{i}</pre></td></tr>")
        assert true
      end
    end
  end

  def test_ut_rrf10b_t3_16
    #TEST INSERT_WARNINGS FUNCTION
    source = {"path" => "sample_c/src", "name"=> "analyzeme.c"}
    src = SourceCode.new
    res = src.combine_source_code(@extracted_subtask.id, source["path"], source["name"])
    test = ""
    check = res.split(/\n/)
    check.each_index do |i|
      str = "<tr id=\"row_#{i+1}\"><td class=\"line_number\">#{i+1 if (i+1) != 0}</td><td id=\"#{i+1}\"><pre>#{check[i]}</pre></td></tr>\n"
      test<<str
      i = i+1
    end
    str = "<tr id=\"row_625\"><td class=\"line_number\">625</td><td id=\"625\"><pre></pre></td></tr>\n"
    test<<str
    result = Result.find_by_path_and_source_name_and_subtask_id_and_rule_set(source["path"], source["name"], @extracted_subtask.id, 1)
    inserted = result.insert_warnings(source, test, 1)
    if inserted.include?("ERR_LINE")
      assert true
    end
    if inserted.include?("class=\"warning\"")
      assert true
    end
  end

  def test_ut_rrf10b_t3_17
    #TEST CREATE_DIV_WARNING FUNCTION
    warning = Warning.find_by_id(9800)
    source = {"path" => "sample_c/src", "name"=> "analyzeme.c"}
    res = Result.find_by_path_and_source_name_and_subtask_id_and_rule_set(source["path"], source["name"], 7, 1)
    created = res.create_div_warning(warning)

    if created.include?("<div id=\"warning_#{warning.id}\">")
      assert true
    end
    if created.include?("<b>#{warning.body}</b>")
      assert true
    end
  end

  def test_ut_rrf10b_t3_18
    #TEST CREATE_DIV_WARNING FUNCTION: INVALID INPUT
    warning = []
    res = Result.new
    created = res.create_div_warning(warning)

    assert_equal created, ""
  end

end
