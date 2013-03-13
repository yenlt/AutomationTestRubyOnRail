require File.dirname(__FILE__) + '/../test_helper'

class DiffFilesDetailsTest < Test::Unit::TestCase
  include AuthenticatedTestHelper
  DIFF_ID = 1
  FILE_DETAILS = 1
  SELECTED_SUBTASK   = 9
  INVALID_TASK  = 10000

  def test_ut_mart_t4_diff_files_details_001
    #Get source code according with file name and subtask id
    df_details = DiffFilesDetails.find_by_id(FILE_DETAILS)
    check = df_details.get_diff_input(df_details.file_name, df_details.old_subtask_id)
    unless check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_files_details_002
    #Get line number according with file name and subtask id
    df_details = DiffFilesDetails.find_by_id(FILE_DETAILS)
    check = DiffFilesDetails.get_line_number(df_details.file_name, df_details.old_subtask_id)
    unless check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_files_details_003
    #Find all file according with diff result id (for diff with all analysis tool)
    df_details = DiffFilesDetails.find_by_id(FILE_DETAILS)
    check = DiffFilesDetails.find_by_diff_result_id(DIFF_ID, nil)
    unless check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_files_details_004
    #Find all file according with diff result id (for diff with each analysis tool)
    df_details = DiffFilesDetails.find_by_id(FILE_DETAILS)
    check = DiffFilesDetails.find_by_diff_result_id(DIFF_ID, 1)
    unless check.blank?
      assert true
    end
  end
end