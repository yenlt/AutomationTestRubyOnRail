require File.dirname(__FILE__) + '/../test_helper'

class SourceCodeTest < ActiveSupport::TestCase
  include AuthenticatedTestHelper
  UNEXTRACTED_SUBTASK = 5
  EXTRACTED_SUBTASK = 11
  INVALID_SUBTASK = 10000
  ## setup
  def setup
  end
  ## teardown
  def teardown
  end
  ## Test: warnings
  #
  def test_ut_rsf10a_t3_sou_017
    source_code = SourceCode.find_by_subtask_id(EXTRACTED_SUBTASK)
    (1..3).each do |rule_level|
      assert_not_nil source_code.warnings(rule_level)
    end
  end

  def test_ut_rrf10b_t3_23
    #TEST COMBINE_SOURCE_CODE FUNCTION
    source = SourceCode.new
    src = source.combine_source_code(EXTRACTED_SUBTASK, "sample_c/src", "analyzeme.c")
    assert_not_equal src, ""
  end

  def test_ut_rrf10b_t3_24
    #TEST COMBINE_SOURCE_CODE FUNCTION: IVALID PATH and FILE NAME
    #RETURN RESULT IS ''
    source = SourceCode.new
    src = source.combine_source_code(EXTRACTED_SUBTASK, "invalid/path", "ivalid/name")
    assert_equal src, ""
  end

  def test_ut_rrf10b_t3_25
    #TEST COMBINE_SOURCE_CODE FUNCTION: IVALID SUBTASK
    #RETURN RESULT IS ''
    source = SourceCode.new
    src = source.combine_source_code(INVALID_SUBTASK, "sample_c/src", "analyzeme.c")
    assert_equal src, ""
  end

  def test_ut_rrf10b_t3_26
    #TEST CREATE_SOURCECODE_BODY FUNCTION
    source = SourceCode.new
    expl = SourceCode.find_by_subtask_id(EXTRACTED_SUBTASK)
    src = source.create_sourcecode_body(expl)
    assert_not_equal src, ""
  end

  def test_ut_rrf10b_t3_27
    #TEST CREATE_SOURCECODE_BODY FUNCTION: IVALID SUBTASK
    #RETURN RESULT IS ''
    source = SourceCode.new
    expl = SourceCode.find_by_subtask_id(INVALID_SUBTASK)
    src = source.create_sourcecode_body(expl)
    assert_not_equal src, ""
  end
end
