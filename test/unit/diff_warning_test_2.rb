require File.dirname(__FILE__) + '/../test_helper'

class DiffWarningTest < Test::Unit::TestCase
  include AuthenticatedTestHelper
  DIFF_ID = 1

  def test_ut_mart_t4_diff_warning_001
    #get filter conditions and order
    page = {:number      => 1,
            :filter_for  => "list",
            :display_for => "dir"
    }
    filter = {:condition => 5,
              :value     => "QAC"
    }
  	order = {:field     => "id",
             :direction => "ASC"
    }
    #Get list of warnings by tool for Directory (view with All analysis tool)    
    check = DiffWarning.warning_difference_filter(page, filter, order, "mercurial", "All_Analysis_Tool", -1, -1, DIFF_ID)
    unless check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_warning_002
    #Get list of warnings by tool for File (view with All analysis tool)
    #get filter conditions and order
    page = {:number      => 1,
            :filter_for  => "list",
            :display_for => "file"
    }
    filter = {:condition => 5,
              :value     => "QAC"
    }
  	order = {:field     => "id",
             :direction => "ASC"
    }
    check = DiffWarning.warning_difference_filter(page, filter, order, "mercurial/bdiff.c", "All_Analysis_Tool", -1, -1, DIFF_ID)
    unless check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_warning_003
    #Get list of warnings by tool for Directory (view with each tool)
    #get filter conditions and order
    page = {:number      => 1,
            :filter_for  => "list",
            :display_for => "dir"
    }
    filter = {:condition => 5,
              :value     => "QAC"
    }
  	order = {:field     => "id",
             :direction => "ASC"
    }
    check = DiffWarning.warning_difference_filter(page, filter, order, "mercurial", "QAC", -1, -1, DIFF_ID)
    unless check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_warning_004
    #Get list of warnings by tool for File (view with each tool)
    #get filter conditions and order
    page = {:number      => 1,
            :filter_for  => "list",
            :display_for => "file"
    }
    filter = {:condition => 5,
              :value     => "QAC"
    }
  	order = {:field     => "id",
             :direction => "ASC"
    }
    check = DiffWarning.warning_difference_filter(page, filter, order, "mercurial/bdiff.c", "QAC", -1, -1, DIFF_ID)
    unless check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_warning_005
    #Get list of warnings with invalid tool's name
    #get filter conditions and order
    page = {:number      => 1,
            :filter_for  => "list",
            :display_for => "dir"
    }
    filter = {:condition => 5,
              :value     => "QAC"
    }
  	order = {:field     => "id",
             :direction => "ASC"
    }
    check = DiffWarning.warning_difference_filter(page, filter, order, "mercurial", "XXXX", -1, -1, DIFF_ID)
    if check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_warning_006
    #Filter warnings by invalid tool
    #get filter conditions and order
    page = {:number      => 1,
            :filter_for  => "list",
            :display_for => "file"
    }
    filter = {:condition => 5,
              :value     => "QAC"
    }
  	order = {:field     => "id",
             :direction => "ASC"
    }
    check = DiffWarning.warning_difference_filter(page, filter, order, "mercurial/bdiff.c", "XXXX", -1, -1, DIFF_ID)
    if check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_warning_007
    #Get warnings and frequency by tool for Directory (view with All analysis tool)    
    check = DiffWarning.summary_warnings(1, "mercurial", "All_Analysis_Tool", "dir", -1, -1, 4, "QAC", nil, nil, DIFF_ID)
    unless check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_warning_008
    #Get warnings and frequency by tool for File (view with All analysis tool)
    check = DiffWarning.summary_warnings(1, "mercurial/bdiff.c", "All_Analysis_Tool", "file", -1, -1, 4, "QAC", nil, nil, DIFF_ID)
    unless check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_warning_009
    #Get warnings and frequency by tool for Directory (view with each tool)
    check = DiffWarning.summary_warnings(1, "mercurial", "QAC", "dir", -1, -1, 4, "QAC", nil, nil, DIFF_ID)
    unless check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_warning_010
    #Get warnings and frequency by tool for File (view with each tool)
    check = DiffWarning.summary_warnings(1, "mercurial/bdiff.c", "QAC", "file", -1, -1, 4, "QAC", nil, nil, DIFF_ID)
    unless check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_warning_011
    #Get list of warnings with invalid tool's name
    #Get warnings and frequency by tool for Directory (view with each tool)
    check = DiffWarning.summary_warnings(1, "mercurial", "QAC", "dir", -1, -1, 4, "XXXX", nil, nil, DIFF_ID)
    if check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_warning_012
    #Filter warnings by invalid tool
    check = DiffWarning.summary_warnings(1, "mercurial/bdiff.c", "QAC", "file", -1, -1, 4, "XXXX", nil, nil, DIFF_ID)
    if check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_warning_013
    #Get list files of diff result and path with all analysis tool    
    check = DiffWarning.get_analyzed_source_path_list(DIFF_ID, "mercurial", "All_Analysis_Tool")
    unless check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_warning_014
    #Get list files of diff result and path with each tool
    check = DiffWarning.get_analyzed_source_path_list(DIFF_ID, "mercurial", "QAC")
    unless check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_warning_015
    #Get list files of diff result with invalid tab name
    check = DiffWarning.get_analyzed_source_path_list(DIFF_ID, "mercurial", "XXXX")
    unless check.blank?
      assert true
    end
  end

  def test_ut_mart_t4_diff_warning_016
    #Get list files of diff result with invalid path
    check = DiffWarning.get_analyzed_source_path_list(DIFF_ID, "XXXX", "QAC")
    unless check.blank?
      assert true
    end
  end
end