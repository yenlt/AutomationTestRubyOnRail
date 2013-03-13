require File.dirname(__FILE__) + '/../test_helper'

class AnalyzeConfigDetailTest < ActiveSupport::TestCase
  fixtures :users
  fixtures :privileges
  fixtures :privileges_users
  
  def setup
    #create sample AnalyzeConfigDetail
    @acd_last = AnalyzeConfigDetail.create(:analyze_tool_id => 1,
                                           :make_root       => "root",
                                           :make_options    => "-i",
                                           :environment_variables => "lang=C",
                                           :analyze_allow_files   => "sample_c/allow.h",
                                           :analyze_deny_files    => "sample_c/deny.c",
                                           :analyze_tool_config   => "-max 0",
                                           :header_file_at_analyze => "#define QAC 1",
                                           :others                 => "0")
  end

  ##
  # Test column names
  #
  # Input: N/A
  # Output: return column names of AnalyzeConfigDetail
  #
  def test_ut_t2_ats_acd_001
    assert_equal ['make_options',
                  'environment_variables',
                  'header_file_at_analyze',
                  'analyze_tool_config',
                  'others'],AnalyzeConfigDetail.column_names
  end

  ##
  # Test tool id
  #
  # Input: get id of analyze tool (QAC)
  # Output: return 1
  #
  def test_ut_t2_ats_acd_002
    ats_detail = @acd_last.tool_id()
    assert_equal ats_detail, 1
  end

  #
  # Input: save a new config detail
  # Output: return true for saved
  #
  def test_ut_t2_ats_acd_003
    new = AnalyzeConfigDetail.create()
    data = {"analyze_tool_id" => 2,
            "make_root"       => "new root",
            "make_options"    => "-ii",
            "environment_variables" => "lang=CPP",
            "analyze_allow_files"   => "sample_cpp/allow.h",
            "analyze_deny_files"    => "sample_cpp/deny.c",
            "analyze_tool_config"   => "-max 1",
            "header_file_at_analyze" => "#define QACPP 1",
            "others"                 => "1"}
    saved = new.save_from_task(data)

    assert_equal saved, true
    AnalyzeConfigDetail.delete(:last)
  end

  #
  # Input: copy a config detail
  # Output: return none
  #
  def test_ut_t2_ats_acd_004    
    new = AnalyzeConfigDetail.create()
    new.copy(@acd_last)

    assert_equal @acd_last.analyze_tool_id, new.analyze_tool_id
    assert_equal @acd_last.make_root, new.make_root
    assert_equal @acd_last.make_options, new.make_options
    assert_equal @acd_last.environment_variables, new.environment_variables
    assert_equal @acd_last.analyze_allow_files, new.analyze_allow_files
    assert_equal @acd_last.analyze_deny_files, new.analyze_deny_files
    assert_equal @acd_last.analyze_tool_config, new.analyze_tool_config
    assert_equal @acd_last.header_file_at_analyze, new.header_file_at_analyze
    assert_equal @acd_last.others, new.others

    AnalyzeConfigDetail.delete(:last)
  end
end
