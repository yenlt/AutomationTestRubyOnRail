require File.dirname(__FILE__) + '/../test_helper'

UNEXTRACTED = 2
EXTRACTED   = 8

class SummaryTest < ActiveSupport::TestCase
  def test_ut_rsf10a_t3_sum_001
    "Test WRS UT 001"
    #subtask unextracted
    sub_result  = ResultDirectory.find_all_by_subtask_id(UNEXTRACTED)
    sub_summary = Summary.find_all_by_subtask_id(UNEXTRACTED)
    #not exist in 2tables
    assert_equal [], sub_result
    assert_equal [], sub_summary
    #input data to ResultDirectory and Summary table
    Summary.input_data_summary_table(UNEXTRACTED)
    sub_result  = ResultDirectory.find_all_by_subtask_id(UNEXTRACTED)
    sub_summary = Summary.find_all_by_subtask_id(UNEXTRACTED)
    #existed in 2 tables
    assert_not_equal [], sub_result
    assert_not_equal [], sub_summary
  end

  def test_ut_rsf10a_t3_sum_002
    "Test WRS UT 002"
    #subtask extracted
    #dont input in ResultDirectory and Summary table
    old_result  = ResultDirectory.find_all_by_subtask_id(EXTRACTED)
    old_summary = Summary.find_all_by_subtask_id(EXTRACTED)
    assert_not_equal [], old_result
    assert_not_equal [], old_summary
    #input data
    Summary.input_data_summary_table(EXTRACTED)
    new_result  = ResultDirectory.find_all_by_subtask_id(EXTRACTED)
    new_summary = Summary.find_all_by_subtask_id(EXTRACTED)
    #data not duplicate
    assert_equal old_result, new_result
    assert_equal old_summary, new_summary
  end

  def test_ut_rsf10a_t3_sum_003
    "Test WRS UT 003"
    #input a hash contains not enogh sub directories
    #return a hash with root and all directory
    sum = {37=>[{3880=>"1"}, {3881=>"1"}, {3871=>"1"}, {3872=>"1"}, {3873=>"1"}],
           32=>[{3892=>"1"}, {3893=>"1"}, {3898=>"1"}, {3899=>"1"}, {3886=>"1"}, {3887=>"1"}]}
    all_dir = Summary.collect_all_directory(sum)
    new_sum = {30=>[{3880=>0}, {3881=>0}, {3871=>0}, {3872=>0}, {3873=>0}, {3892=>0}, {3893=>0}, {3898=>0}, {3899=>0}, {3886=>0}, {3887=>0}],
               36=>[{3880=>0}, {3881=>0}, {3871=>0}, {3872=>0}, {3873=>0}],
               31=>[{3892=>0}, {3893=>0}, {3898=>0}, {3899=>0}, {3886=>0}, {3887=>0}],
               37=>[{3880=>"1"}, {3881=>"1"}, {3871=>"1"}, {3872=>"1"}, {3873=>"1"}],
               32=>[{3892=>"1"}, {3893=>"1"}, {3898=>"1"}, {3899=>"1"}, {3886=>"1"}, {3887=>"1"}]}
    assert_equal new_sum, all_dir
  end

  def test_ut_rsf10a_t3_sum_004
    "Test WRS UT 004"
    #test input data to summary table
    sum = {30=>[{3880=>1}, {3881=>1}, {3871=>1}, {3872=>1}, {3873=>1}, {3892=>1}, {3893=>1}, {3898=>1}, {3899=>1}, {3886=>1}, {3887=>1}],
           36=>[{3880=>1}, {3881=>1}, {3871=>1}, {3872=>1}, {3873=>1}],
           31=>[{3892=>1}, {3893=>1}, {3898=>1}, {3899=>1}, {3886=>1}, {3887=>1}],
           37=>[{3880=>"1"}, {3881=>"1"}, {3871=>"1"}, {3872=>"1"}, {3873=>"1"}],
           32=>[{3892=>"1"}, {3893=>"1"}, {3898=>"1"}, {3899=>"1"}, {3886=>"1"}, {3887=>"1"}]}
    file_of_master = ResultDirectory.find(:all,
        :conditions => ["ftype = 'file'and subtask_id = ?", EXTRACTED],
        :order => "parent_id"
      )

    file = Hash.new #contains all file with warnings and frequency
    file_of_master.each do |f|
      #collect all warning for each file
      warning = Warning.find_by_sql("SELECT   id, subtask_id, rule, message, rule_level, count(*) as frequency
                                     FROM     warnings
                                     WHERE    CONCAT(source_path,'/', source_name) like '#{f.path}'
                                     AND      subtask_id = #{EXTRACTED}
                                     AND      rule_level = 1
                                     GROUP BY rule, message")

      if warning != []
        str = {f.id => warning}
        file = file.merge(str)
      end
    end

    Summary.create_summary_data(file, sum)

    existed = Summary.find_all_by_subtask_id(EXTRACTED)
    assert_not_equal [], existed

  end

  def test_ut_rsf10a_t3_sum_005
    "Test WRS UT 005"
    #test export summary result
    result = Summary.export_summary_results(EXTRACTED, "")
    assert_equal ["sum", "dir", "file"], result.keys
    assert_not_equal nil, result["sum"]
    assert_not_equal nil, result["dir"]
    assert_not_equal nil, result["file"]
  end

  def test_ut_rsf10a_t3_sum_006
    "Test WRS UT 006"
    #test view summary of warnings for a subtask
    view_subtask = Summary.summary_results("sum", EXTRACTED)
    keys = ["sum", "dir", "file"]
    assert_equal keys, view_subtask.keys
  end

  def test_ut_rsf10a_t3_sum_007
    "Test WRS UT 007"
    #test view summary of warnings for all directory
    view_subtask = Summary.summary_results("all", EXTRACTED, 3)
    keys = ["sum", "dir", "file"]
    assert_equal keys, view_subtask.keys
  end

  def test_ut_rsf10a_t3_sum_008
    "Test WRS UT 008"
    #test view summary of warnings for directory
    dir = ResultDirectory.find(:first, :conditions => ["subtask_id = #{EXTRACTED} and parent_id != 0 and ftype = 'directory'"])
    view_subtask = Summary.summary_results("dir", EXTRACTED, 3, dir.id)
    assert_not_equal [], view_subtask["sum"]
    assert_not_equal [], view_subtask["dir"]
    assert_equal nil, view_subtask["file"]
  end

  def test_ut_rsf10a_t3_sum_009
    "Test WRS UT 009"
    #test view summary of warnings for file
    file = ResultDirectory.find(:first, :conditions => ["subtask_id = #{EXTRACTED} and ftype = 'file'"])
    view_subtask = Summary.summary_results("file", EXTRACTED, 3, nil, file.id)

    assert_equal nil, view_subtask["sum"]
    assert_equal nil, view_subtask["dir"]
    assert_not_equal [], view_subtask["file"]
  end

  def test_ut_rsf10a_t3_sum_010
    "Test WRS UT 010"
    #test find summary with sql clauses
    #select all file of summary
    select = "SELECT * FROM summaries"
    join   = "INNER JOIN result_directories ON  result_directories.id = summaries.result_directory_id
                                            AND result_directories.ftype = 'file'"
    condition = "WHERE  summaries.subtask_id = #{EXTRACTED}"
    group = "GROUP BY rule_number, rule_level, message, result_directory_id"

    result = Summary.find_summary_results(select, join, condition, group)
    assert_not_equal [], result
  end

  def test_ut_rsf10a_t3_sum_011
    "Test WRS UT 011"
		directory_id = 26
		rule_level = "1"
		count_warnings = Summary.count_warnings_by_tree_path_and_rule_level(EXTRACTED, directory_id, rule_level)
		assert_equal 125, count_warnings
	end

	def test_ut_rsf10a_t3_sum_012
    "Test WRS UT 012"
		subtask_id = -1
		directory_id = 26
		rule_level = "1"
		count_warnings = Summary.count_warnings_by_tree_path_and_rule_level(subtask_id, directory_id, rule_level)
		assert_equal 0, count_warnings
	end

	def test_ut_rsf10a_t3_sum_013
    "Test WRS UT 013"
		directory_id = -1
		rule_level = "1"
		count_warnings = Summary.count_warnings_by_tree_path_and_rule_level(EXTRACTED, directory_id, rule_level)
		assert_equal 0, count_warnings
	end

	def test_ut_rsf10a_t3_sum_014
    "Test WRS UT 014"
		directory_id = 26
		rule_level = "-1"
		count_warnings = Summary.count_warnings_by_tree_path_and_rule_level(EXTRACTED, directory_id, rule_level)
		assert_equal 0, count_warnings
	end
end
