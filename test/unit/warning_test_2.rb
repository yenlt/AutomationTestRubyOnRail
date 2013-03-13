require File.dirname(__FILE__) + '/../test_helper'

class WarningTest < Test::Unit::TestCase
  include AuthenticatedTestHelper
   SUBTASK = 7

  def test_ut_mart_t4_warning_001
    #Get warnings according with array of subtask id (according with all tool) of directory
    warning = Warning.paginate_by_subtask_id(SUBTASK, 1, nil, nil, nil, nil, "mercurial", 3, false, false)
    unless warning.blank?
      assert true
    end
  end

  def test_ut_mart_t4_warning_002
    #Get warnings according with array of subtask id (according with all tool) of all directory
    warning = Warning.paginate_by_subtask_id(SUBTASK, 1, nil, nil, nil, nil, "all directory", 3, false, false)
    unless warning.blank?
      assert true
    end
  end

  def test_ut_mart_t4_warning_003
    #Filter warnings (when user viewing all analysis tool)
    warning = Warning.paginate_by_subtask_id(SUBTASK, 1, nil, nil, "analyze_tools.name", "qac", "all directory", 3, false, false)
    unless warning.blank?
      assert true
    end
  end

  def test_ut_mart_t4_warning_004
    #Filter warnings (when user viewing all analysis tool) with disabled tool
    warning = Warning.paginate_by_subtask_id(SUBTASK, 1, nil, nil, "analyze_tools.name", "pgrelief", "all directory", 3, false, false)
    if warning.blank?
      assert true
    end
  end

  def test_ut_mart_t4_warning_005
    #Filter warnings (when user viewing all analysis tool) with invalid tool
    warning = Warning.paginate_by_subtask_id(SUBTASK, 1, nil, nil, "analyze_tools.name", "xxxx", "all directory", 3, false, false)
    if warning.blank?
      assert true
    end
  end

  def test_ut_mart_t4_warning_006
    #Get warnings according with array of subtask id (according with all tool) of directory
    warning = Warning.find_all_by_subtask_id(SUBTASK, nil, nil, nil, nil, "mercurial", 3, false, false)
    unless warning.blank?
      assert true
    end
  end

  def test_ut_mart_t4_warning_007
    #Get warnings according with array of subtask id (according with all tool) of all directory
    warning = Warning.find_all_by_subtask_id(SUBTASK, nil, nil, nil, nil, "all directory", 3, false, false)
    unless warning.blank?
      assert true
    end
  end

  def test_ut_mart_t4_warning_008
    #Filter warnings (when user viewing all analysis tool)
    warning = Warning.find_all_by_subtask_id(SUBTASK, nil, nil, "analyze_tools.name", "qac", "all directory", 3, false, false)
    unless warning.blank?
      assert true
    end
  end

  def test_ut_mart_t4_warning_009
    #Filter warnings (when user viewing all analysis tool) with disabled tool
    warning = Warning.find_all_by_subtask_id(SUBTASK, nil, nil, "analyze_tools.name", "pgrelief", "all directory", 3, false, false)
    if warning.blank?
      assert true
    end
  end

  def test_ut_mart_t4_warning_010
    #Filter warnings (when user viewing all analysis tool) with invalid tool
    warning = Warning.find_all_by_subtask_id(SUBTASK, nil, nil, "analyze_tools.name", "xxxx", "all directory", 3, false, false)
    if warning.blank?
      assert true
    end
  end
end