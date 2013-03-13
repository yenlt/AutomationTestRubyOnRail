require File.dirname(__FILE__) + '/../test_helper'
require 'diff/lcs/array'
class OriginalFileTest < ActiveSupport::TestCase
  fixtures :original_files
  fixtures :original_source_codes
 def setup
    @original_file = OriginalFile.new(:subtask_id => 5,
                                      :source_name => "analyzeme.c",
                                      :path => "sample_c/src",
                                      :normal_result_id => 67,
                                      :hirisk_result_id => 68,
                                      :critical_result_id => 69
                                    )
   @original_file_1 = OriginalFile.new(:subtask_id => 1,
                                      :source_name => "analyzeme.c",
                                      :path => "sample_c/src",
                                      :normal_result_id => 9,
                                      :hirisk_result_id => 8,
                                      :critical_result_id => 7
                                    )
  end
  def test_000
    import_sql
  end
  #test the validations inside the model
  def test_ut_original_file_01
    assert @original_file.save
    original_file_copy = OriginalFile.find(@original_file.id)
    assert_equal @original_file.normal_result_id, original_file_copy.normal_result_id
    assert @original_file.valid?
    assert @original_file.destroy
  end
    #test initialization of OriginalFile'model.
  def test_ut_diff_result_02
    original_file = OriginalFile.new(
                         :source_name => "simple 1",
                         :path => "http",
                         :normal_result_id => 349898,
                         :hirisk_result_id => 4564,
                         :critical_result_id => 45 )
    assert_equal("simple 1",original_file.source_name)
    assert_equal(349898,original_file.normal_result_id)
    assert_equal(4564,original_file.hirisk_result_id)
    assert_equal(45,original_file.critical_result_id)
    assert_equal("http",original_file.path)
  end

    # Return:
    # Array of all the lines in the chosen file
  def test_get_line_number_03
    old_positions = OriginalFile.get_line_number(1)
    old_array_line_number=[1, 2, 3, 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52]
    assert_equal old_array_line_number,old_positions.values_at(0..50)

    new_positions = OriginalFile.get_line_number(2)
    new_array_line_number=[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51]
    assert_equal new_array_line_number,new_positions.values_at(0..50)
  end
   # Return:
   # Array of all the line_content in the chosen file
  def test_get_diff_lcs_format_04
    file_input_1 = OriginalFile.get_diff_lcs_format(1)
    test_get_array_diff_lcs_format_1 = ["\t File:\r", "\t      analyzeme.c\r", "\t Copyright:\r", "\t Product:\r", "\t      AnsdfgsdfgeMe\r", "\t Abstract:\r", "\t      Analyzsdfgsdfgsdfgイン関数を定義する\r", "\t Author:\r", "\t      zhang-gh\r", "\t Date:\r", "\t      2004/08/20\r", "\t REVISION HISTORY:\r", "\t\r", "\t*/\r", "\t\r", "\t/*\r", "\t    $AnalyzeMe 1.0.0.1$\r\n", "\t*/\r", "\t#include \"analyzeme.h\"\r", "\t#include \"common.h\"\r", "\t#include \"memory_manage.h\"\r", "\t#include \"parse_cmdline.h\"\r", "\t#include \"comsdfgsdfgsdfgmon_measure.h\"\r", "\t#include \"trend_measure.h\"\r", "\t#include \"make_file_list.h\"\r", "\t#include \"output.h\"\r\n", "\t#include \"get_process_macro.h\"\r", "\t#include &lt;signal.h&gt;\r", "\t\r", "\t/****************************************************/\r", "\t/*              定数宣言                            */\r", "\t/****************************************************/\r", "\tconst char* TRACEFILE = \"analyzeme_trace.txt\";\r", "\tconst char* APPLOGFILE = \"analyzeme_log.txt\";\r", "\t\r", "\t/****************************************************/\r", "\t/*              グローバル変数宣言                  */\r", "\t/****************************************************/\r", "\t/* いろいろのFileのハンドルを保存するグローバル変数の宣言 */\r", "\t\r", "\t/* Log File */\r\n", "\tFILE *g_fpLogFile = NULL;       /* Log File pointer */\r", "\t/*  Trace File */\r\n", "\tFILE *g_fpTraceFile = NULL;     /* Trace File pointer */\r", "\t/* エラーFile */\r\n", "\tFILE *g_fpErrorFile = NULL;\r", "\t\r\n", "\tbool g_bTrace           = false;    /* Trace flag */\r", "\tchar g_szNVPath[MAX_PATH] = {0};\r", "\tchar g_szOVPath[MAX_PATH] = {0};\r"]
    assert_equal test_get_array_diff_lcs_format_1,file_input_1.values_at(1..50)
    assert_equal 660,file_input_1.size

    file_input_2 = OriginalFile.get_diff_lcs_format(2)
    test_get_array_diff_lcs_format_2 = ["\t File:\r", "\t      analyzeme.c\r", "\t Copyright:\r", "\t      Copyright (C) 2004 TOSHIBA CORPORATION. All Rights Reserved.\r", "\t Product:\r", "\t      AnalyzeMe\r", "\t Abstract:\r\n", "\t      AnalyzeMeのメイン関数を定義する\r", "\t Author:\r", "\t      zhang-gh\r", "\t Date:\r", "\t      2004/08/20\r", "\t REVISION HISTORY:\r", "\t\r", "\t*/\r", "\t\r", "\t/*\r", "\t    $AnalyzeMe 1.0.0.1$\r\n", "\t*/\r", "\t#include \"analyzeme.h\"\r", "\t#include \"common.h\"\r", "\t#include \"memory_manage.h\"\r", "\t#include \"parse_cmdline.h\"\r", "\t#include \"common_measure.h\"\r", "\t#include \"trend_measure.h\"\r", "\t#include \"make_file_list.h\"\r", "\t#include \"output.h\"\r\n", "\t#include \"get_process_macro.h\"\r", "\t#include &lt;signal.h&gt;\r", "\t\r", "\t/****************************************************/\r", "\t/*              定数宣言                            */\r", "\t/****************************************************/\r", "\tconst char* TRACEFILE = \"analyzeme_trace.txt\";\r", "\tconst char* APPLOGFILE = \"analyzeme_log.txt\";\r", "\t\r", "\t/****************************************************/\r", "\t/*              グローバル変数宣言                  */\r", "\t/****************************************************/\r", "\t/* いろいろのFileのハンドルを保存するグローバル変数の宣言 */\r", "\t\r", "\t/* Log File */\r\n", "\tFILE *g_fpLogFile = NULL;       /* Log File pointer */\r", "\t/*  Trace File */\r\n", "\tFILE *g_fpTraceFile = NULL;     /* Trace File pointer */\r", "\t/* エラーFile */\r\n", "\tFILE *g_fpErrorFile = NULL;\r", "\t\r\n", "\tbool g_bTrace           = false;    /* Trace flag */\r", "\tchar g_szNVPath[MAX_PATH] = {0};\r"]
    assert_equal test_get_array_diff_lcs_format_2,file_input_2.values_at(1..50)
    assert_equal 661,file_input_2.size
  end

  #Return:
  #   the table result's id of the chosen rule level of this file
  def test_result_id_05
   id_1 = original_files(:original_files_001).id
   id_2 = original_files(:original_files_002).id
    # case rule level = 1.
    old_result_id = OriginalFile.find(id_1).result_id(1)
    assert_equal 69,old_result_id
    new_result_id = OriginalFile.find(id_2).result_id(1)
    assert_equal OriginalFile.find(id_2).normal_result_id,new_result_id
   # case rule level = 2
    old_result_id = OriginalFile.find(id_1).result_id(2)
    assert_equal 68,old_result_id
     new_result_id = OriginalFile.find(id_2).result_id(2)
    assert_equal OriginalFile.find(2).hirisk_result_id,new_result_id
   # case rule level = 3
    old_result_id = OriginalFile.find(id_1).result_id(3)
    assert_equal 67,old_result_id
    new_result_id = OriginalFile.find(id_2).result_id(3)
    assert_equal OriginalFile.find(id_2).critical_result_id,new_result_id
   # case rule level != 1,2,3
    old_result_id = OriginalFile.find(id_1).result_id(4)
    assert_equal 69,old_result_id
    result_id = OriginalFile.find(id_2).result_id(4)
    assert_equal OriginalFile.find(id_2).normal_result_id,result_id
  end

  # Return:
  #   If this function execute successfully, the information was filled in table
  #   original_source_codes
  def test_extract_data_06
    OriginalSourceCode.destroy_all
    file =  original_files(:original_files_002)
    assert file.extract_data(file.normal_result_id)
    original_source_code_1 = OriginalSourceCode.find(:all,
      :conditions => {
        :original_file_id => file.id,
        :line_number => 1,
        :line_content => "\t/*\r",
        :error_line => 1}
    )
    assert_not_equal [],original_source_code_1
    original_source_code_2 = OriginalSourceCode.find(:all,
      :conditions => {
        :original_file_id =>file.id,
        :line_number => 2,
        :line_content => "\t File:\r",
        :error_line => 0}
    )
    assert_not_equal [],original_source_code_2
  end
end
 