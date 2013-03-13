require File.dirname(__FILE__) + '/../test_helper'
require 'diff/lcs/array'
class OriginalSourceCodeTest < ActiveSupport::TestCase
  def test_000
    import_sql
  end
    #test the validations inside the model
  def test_original_source_code_01
    original_source_code = OriginalSourceCode.new(:original_file_id => 1,
                                                  :line_number => 2,
                                                  :line_content => "y1",
                                                  :error_line => 45)
    assert original_source_code.save
    orginal_source_code_copy = OriginalSourceCode.find(original_source_code.id)
    assert_equal original_source_code.line_number,orginal_source_code_copy.line_number    
    assert original_source_code.valid?
    assert original_source_code.destroy
  end  
  
    #test initialization of OriginalSourceCodeTest'model.
  def test_ut_diff_result_02
    original_source_code = OriginalSourceCode.new(
      :original_file_id => 10,
      :line_number => 349898,
      :error_line => 4564,
      :line_content => "123456"
    )
    assert_equal(10,original_source_code.original_file_id)
    assert_equal(349898,original_source_code.line_number)
    assert_equal(4564,original_source_code.error_line)
    assert_equal("123456",original_source_code.line_content)
  end
end
