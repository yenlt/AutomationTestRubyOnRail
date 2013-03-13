require File.dirname(__FILE__) + '/../test_helper'
require 'diff/lcs/array'
class DiffWarningTest < ActiveSupport::TestCase
  def setup
    @diff_warning = DiffWarning.new(
      :diff_file_id => 1,
      :diff_status_id => 2,
      :rule_set => 1,
      :warning_id => 1,
      :original_file_id => 1)
  end

  def test_000
    import_sql
  end
  
  #test the validations inside this model
  def test_ut_diff_warning_01
    assert @diff_warning.save
    assert @diff_warning.valid?
    diff_warning_copy = DiffWarning.find(@diff_warning.id)
    assert_equal @diff_warning.diff_file_id, diff_warning_copy.diff_file_id
    assert @diff_warning.destroy
  end

  #test initialization of DiffWarning'model.
  def test_ut_diff_warning_02
    assert_equal 2,@diff_warning.diff_status_id
    assert_equal 1,@diff_warning.diff_file_id
    assert_equal 1,@diff_warning.rule_set
    assert_equal 1,@diff_warning.warning_id
    assert_equal 1,@diff_warning.original_file_id
  end
  
  # Test With Case: filter id is nil, status ( common, added, deleted ) is nil
  # rule level ( Critical, Hirisk, Normal ) is nil, other ( "", rule_number,  source_name, directory ) is nil, order field isn't nil ( ="status"),
  # order_direction is "ASC", name of directory is true ( "sample_c/src ) .
  def test_summary_warnings_03
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      "status",
      "ASC",
      "1")
    #there are 15 diff_warning per page.
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
      assert_equal diff_warning.source_name,"analyzeme.c"
      assert_equal diff_warning.path,"sample_c/src"
    end
  end

  # warning_directory_summary page. Test With Case: page is nil,name of directory is true ( "sample_c/src ).
  # filter id is dir, status is common, rule level is Critical, other is nil, other_text_nil, order field ="status",
  #order_direction is "ASC", name of directory is true ( "sample_c/src ) .
  def test_summary_warnings_04
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "3",
      "1",
      nil,
      "status",
      "ASC",
      "1")
    # there are 15 diff_warning in this list
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule level is hirisk.
  def test_summary_warnings_05
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "2",
      "1",
      nil,
      "status",
      "ASC",
      "1")
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule level is normal
  def test_summary_warnings_06
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "1",
      "1",
      nil,
      "status",
      "ASC",
      "1")
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule level is Critical,orther is rule_number.
  def test_summary_warnings_07
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "3",
      "2",
      nil,
      "status",
      "ASC",
      "1")
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end
  #all field is the same about except other_text = "3321"
  def test_summary_warnings_08
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "3",
      "2",
      "3321",
      "status",
      "ASC",
      "1")
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other_text is special case.
  def test_summary_warnings_09
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "3",
      "2",
      "*3*",
      "status",
      "ASC",
      "1")
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end
  #all field is the same about except other_text is special case
  def test_summary_warnings_10
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "3",
      "2",
      "*3#",
      "status",
      "ASC",
      "1")
    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #all field is the same about except other_text is special case
  def test_summary_warnings_11
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "3",
      "2",
      "****",
      "status",
      "ASC",
      "1")
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except orther is source_name and other_text is nil.
  def test_summary_warnings_12
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "3",
      "3",
      nil,
      "status",
      "ASC",
      "1")
    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #all field is the same about except other_text don't exist
  def test_summary_warnings_13
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "3",
      "3",
      "analy",
      "status",
      "ASC",
      "1")
    # the list must be empty
    assert(diff_warnings.size == 0)   
  end

  #all field is the same about except other_text is true.
  def test_summary_warnings_14
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "3",
      "3",
      "analyzeme.c",
      "status",
      "ASC",
      "1")

    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule_level is hirisk,other is nil.
  def test_summary_warnings_15
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "2",
      "1",
      "analyzeme.c",
      "status",
      "ASC",
      "1")

    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other is rule_number,other_tex is nil
  def test_summary_warnings_16
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "2",
      "2",
      nil,
      "status",
      "ASC",
      "1")

    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end
   
  #all field is the same about except other_tex dont' exest.
  def test_summary_warnings_17
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "2",
      "2",
      "5972",
      "status",
      "ASC",
      "1")
    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #all field is the same about except other_tex is true
  def test_summary_warnings_18
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "2",
      "2",
      "0286",
      "status",
      "ASC",
      "1")

    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other is source_name, other_text is nil
  def test_summary_warnings_19
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "2",
      "3",
      nil,
      "status",
      "ASC",
      "1")

    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #all field is the same about except other is source_name, other_text is false
  def test_summary_warnings_20
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "2",
      "3",
      "fffff",
      "status",
      "ASC",
      "1")
    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #all field is the same about except other is source_name, other_text is true.
  def test_summary_warnings_21
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "2",
      "3",
      "analyzeme.c",
      "status",
      "ASC",
      "1")
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule_level is normal, other is nil and other_text is wrong value.
  def test_summary_warnings_22
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "1",
      "1",
      "analyzeme.c",
      "status",
      "ASC",
      "1")
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except  other is rule_number and other_text is wrong value.
  def test_summary_warnings_23
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "1",
      "2",
      "ana.c",
      "status",
      "ASC",
      "1")

    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #all field is the same about except  other is rule_number and other_text is wrong value.
  def test_summary_warnings_24
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "1",
      "2",
      "011111",
      "status",
      "ASC",
      "1")

    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #all field is the same about except  other is rule_number and other_text is true value.
  def test_summary_warnings_25
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "1",
      "2",
      "3390",
      "status",
      "ASC",
      "1")

    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except  other is source_name and other_text is nil
  def test_summary_warnings_26
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "1",
      "3",
      nil,
      "status",
      "ASC",
      "1")

    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #all field is the same about except  other is source_name and other_text is wrong value.

  def test_summary_warnings_27
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "1",
      "3",
      "ffff",
      "status",
      "ASC",
      "1")

    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #all field is the same about except  other is source_name and other_text is true value.

  def test_summary_warnings_28
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "1",
      "1",
      "3",
      "analyzeme.c",
      "status",
      "ASC",
      "1")
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #Test With Case: page is nil,name of directory is true ( "sample_c/src ).
  # filter id is dir, status is added, rule level is Critical, other is nil, other_text_nil, order field ="status",
  #order_direction is "ASC", name of directory is true ( "sample_c/src ) .

  def test_summary_warnings_29
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "3",
      "1",
      nil,
      "status",
      "ASC",
      "1")

    # there are 6 diff_warning in this list
    assert_equal(0, diff_warnings.size)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule level is hirisk.
  def test_summary_warnings_30
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "2",
      "1",
      nil,
      "status",
      "ASC",
      "1")
    # there are 6 diff_warning in this list
    assert_equal(0, diff_warnings.size)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule level is normal
  def test_summary_warnings_31
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "1",
      "1",
      nil,
      "status",
      "ASC",
      "1")
    # there are 6 diff_warning in this list
    assert(0, diff_warnings.size)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule level is Critical,orther is rule_number.
  def test_summary_warnings_32
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "3",
      "2",
      nil,
      "status",
      "ASC",
      "1")
    # there are 6 diff_warning in this list
    assert(0, diff_warnings.size)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other_text = "3321"
  def test_summary_warnings_33
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "3",
      "2",
      "3321",
      "status",
      "ASC",
      "1")
    # the list must be empty
    assert_equal(0, diff_warnings.size)
  end

  #all field is the same about except other_text is special case.
  def test_summary_warnings_34
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "3",
      "2",
      "*3*",
      "status",
      "ASC",
      "1")
    # the list must be empty
    assert_equal(0, diff_warnings.size)
  end

  #all field is the same about except other_text is special case
  def test_summary_warnings_35
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "3",
      "2",
      "*3#",
      "status",
      "ASC",
      "1")
    # the list must be empty
    assert_equal(0, diff_warnings.size)
  end

  #all field is the same about except other_text is special case
  def test_summary_warnings_36
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "3",
      "2",
      "****",
      "status",
      "ASC",
      "1")

    # there are 6 diff_warning in this list
    assert(0, diff_warnings.size)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except orther is source_name and other_text is nil.
  def test_summary_warnings_37
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "3",
      "3",
      nil,
      "status",
      "ASC",
      "1")
    # the list must be empty
    assert_equal(0, diff_warnings.size)
  end

  #all field is the same about except other_text don't exist
  def test_summary_warnings_38
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "3",
      "3",
      "analy",
      "status",
      "ASC",
      "1")
    # the list must be empty
    assert_equal(0, diff_warnings.size)
  end

  #all field is the same about except other_text is true.
  def test_summary_warnings_39
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "3",
      "3",
      "analyzeme.c",
      "status",
      "ASC",
      "1")

    # there are 6 diff_warning in this list
    assert_equal(diff_warnings.size, 0)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule_level is hirisk,other is nil.
  def test_summary_warnings_40
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "2",
      "1",
      "analyzeme.c",
      "status",
      "ASC",
      "1")

    # there are 6 diff_warning in this list
    assert_equal(diff_warnings.size, 0)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other is rule_number,other_tex is nil
  def test_summary_warnings_41
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "2",
      "2",
      nil,
      "status",
      "ASC",
      "1")

    # there are 6 diff_warning in this list
    assert_equal(diff_warnings.size, 0)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other_tex dont' exest.
  def test_summary_warnings_42
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "2",
      "2",
      "5972",
      "status",
      "ASC",
      "1")

    # the list must be empty
    assert_equal(0, diff_warnings.size)
  end

  #all field is the same about except other_tex is true
  def test_summary_warnings_43
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "2",
      "2",
      "0286",
      "status",
      "ASC",
      "1")

    # the list must be empty
    assert_equal(0, diff_warnings.size)
  end

  #all field is the same about except other is source_name, other_text is nil
  def test_summary_warnings_44
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "2",
      "3",
      nil,
      "status",
      "ASC",
      "1")

    # the list must be empty
    assert_equal(0, diff_warnings.size)
  end
  #all field is the same about except other is source_name, other_text is false
  def test_summary_warnings_45
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "2",
      "3",
      "fffff",
      "status",
      "ASC",
      "1")
    # the list must be empty
    assert_equal(0, diff_warnings.size)
  end

  #all field is the same about except other is source_name, other_text is true.
  def test_summary_warnings_46
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "2",
      "3",
      "analyzeme.c",
      "status",
      "ASC",
      "1")
                                                       
    # there are 6 diff_warning in this list
    assert_equal(diff_warnings.size, 0)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule_level is normal, other is nil and other_text is wrong value.
  def test_summary_warnings_47
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "1",
      "1",
      "analyzeme.c",
      "status",
      "ASC",
      "1")

    # there are 6 diff_warning in this list
    assert_equal(diff_warnings.size, 3)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except  other is rule_number and other_text is wrong value.
  def test_summary_warnings_48
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "1",
      "2",
      "ana.c",
      "status",
      "ASC",
      "1")

    # the list must be empty
    assert_equal(0, diff_warnings.size)
  end

  #all field is the same about except  other is rule_number and other_text is wrong value.
  def test_summary_warnings_49
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "1",
      "2",
      "011111",
      "status",
      "ASC",
      "1")

    # the list must be empty
    assert_equal(0, diff_warnings.size)
  end

  #all field is the same about except  other is rule_number and other_text is true value.
  def test_summary_warnings_50
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "1",
      "2",
      "3390",
      "status",
      "ASC",
      "1")

    # the list must be empty
    assert_equal(0, diff_warnings.size)
  end

  #all field is the same about except  other is source_name and other_text is nil
  def test_summary_warnings_51
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "1",
      "3",
      nil,
      "status",
      "ASC",
      "1")

    # the list must be empty
    assert_equal(0, diff_warnings.size)
  end

  #all field is the same about except  other is source_name and other_text is wrong value.
  def test_summary_warnings_52
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "1",
      "3",
      "ffff",
      "status",
      "ASC",
      "1")

    # the list must be empty
    assert_equal(0, diff_warnings.size)
  end

  #all field is the same about except  other is source_name and other_text is true value.
  def test_summary_warnings_53
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "2",
      "1",
      "3",
      "analyzeme.c",
      "status",
      "ASC",
      "1")
    # there are 6 diff_warning in this list
    assert_equal(diff_warnings.size, 3)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end
 

  #  Test With Case: page is nil,name of directory is true ( "sample_c/src ).
  #  filter id is dir, status is deleted, rule level is Critical, other is nil, other_text_nil, order field ="status",
  #  order_direction is "ASC", name of directory is true ( "sample_c/src ) .

  def test_summary_warnings_54
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "3",
      "1",
      nil,
      "status",
      "ASC",
      "1")
    # there are 6 diff_warning in this list
    assert_equal(0, diff_warnings.size)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert_equal(1, diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule level is hirisk.
  def test_summary_warnings_55
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "2",
      "1",
      nil,
      "status",
      "ASC",
      "1")
    # there are 6 diff_warning in this list
    assert_equal(0, diff_warnings.size)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert_equal(1, diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule level is normal
  def test_summary_warnings_56
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "1",
      "1",
      nil,
      "status",
      "ASC",
      "1")
    # there are 6 diff_warning in this list
    assert_equal(3, diff_warnings.size)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert_equal(1, diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule level is Critical,orther is rule_number.
  def test_summary_warnings_57
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "3",
      "2",
      nil,
      "status",
      "ASC",
      "1")
    # there are 6 diff_warning in this list
    assert_equal(0, diff_warnings.size)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert_equal(1, diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other_text = "3321"
  def test_summary_warnings_58
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "3",
      "2",
      "3321",
      "status",
      "ASC",
      "1")
    # the list must be empty
    assert_equal(0, diff_warnings.size)
  end

  #all field is the same about except other_text is special case.
  def test_summary_warnings_59
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "3",
      "2",
      "*3*",
      "status",
      "ASC",
      "1")

    # the list must be empty
    assert_equal(0, diff_warnings.size)
  end

  #all field is the same about except other_text is true value
  def test_summary_warnings_60
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "3",
      "2",
      "2209",
      "status",
      "ASC",
      "1")
    # there are 6 diff_warning in this list
    assert_equal(0, diff_warnings.size)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other_text is special case
  def test_summary_warnings_61
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "3",
      "2",
      "****",
      "status",
      "ASC",
      "1")
    # there are 6 diff_warning in this list
    assert_equal(diff_warnings.size, 0)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except orther is source_name and other_text is nil.
  def test_summary_warnings_62
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "3",
      "3",
      nil,
      "status",
      "ASC",
      "1")
    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #all field is the same about except other_text don't exist
  def test_summary_warnings_63
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "3",
      "3",
      "analy",
      "status",
      "ASC",
      "1")
    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #all field is the same about except other_text is true.
  def test_summary_warnings_64
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "3",
      "3",
      "analyzeme.c",
      "status",
      "ASC",
      "1")

    #there are 6 diff_warning in this list
    assert_equal(diff_warnings.size, 0)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule_level is hirisk,other is nil.
  def test_summary_warnings_65
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "2",
      "1",
      "analyzeme.c",
      "status",
      "ASC",
      "1")

    #there are 6 diff_warning in this list
   assert_equal(diff_warnings.size, 0)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other is rule_number,other_tex is nil
  def test_summary_warnings_66
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "2",
      "2",
      nil,
      "status",
      "ASC",
      "1")

    #there are 6 diff_warning in this list
    assert_equal(diff_warnings.size, 0)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other_tex dont' exest.
  def test_summary_warnings_67
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "2",
      "2",
      "5972",
      "status",
      "ASC",
      "1")

    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #all field is the same about except other_tex is true
  def test_summary_warnings_68
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "2",
      "2",
      "0288",
      "status",
      "ASC",
      "1")

    #there are 1diff_warning in this list
   assert_equal(diff_warnings.size, 0)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other is source_name, other_text is nil
  def test_summary_warnings_69
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "2",
      "3",
      nil,
      "status",
      "ASC",
      "1")

    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #all field is the same about except other is source_name, other_text is false
  def test_summary_warnings_70
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "2",
      "3",
      "fffff",
      "status",
      "ASC",
      "1")

    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #all field is the same about except other is source_name, other_text is true.
  def test_summary_warnings_71
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "2",
      "3",
      "analyzeme.c",
      "status",
      "ASC",
      "1")
    #there are 6 diff_warning in this list
    assert_equal(diff_warnings.size, 0)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule_level is normal, other is nil and other_text is wrong value.
  def test_summary_warnings_72
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "1",
      "1",
      "analyzeme.c",
      "status",
      "ASC",
      "1")
    #there are 6 diff_warning in this list
    assert_equal(diff_warnings.size, 3)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except  other is rule_number and other_text is wrong value.
  def test_summary_warnings_73
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "1",
      "2",
      "ana.c",
      "status",
      "ASC",
      "1")
    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #all field is the same about except  other is rule_number and other_text is wrong value.
  def test_summary_warnings_74
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "1",
      "2",
      "011111",
      "status",
      "ASC",
      "1")

    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #all field is the same about except  other is rule_number and other_text is true value.
  def test_summary_warnings_75
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "1",
      "2",
      "2209",
      "status",
      "ASC",
      "1")

    #there are 4 diff_warning in this list
    assert_equal(diff_warnings.size, 1)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except  other is source_name and other_text is nil
  def test_summary_warnings_76
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "1",
      "3",
      nil,
      "status",
      "ASC",
      "1")

    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #all field is the same about except  other is source_name and other_text is wrong value.
  def test_summary_warnings_77
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "1",
      "3",
      "ffff",
      "status",
      "ASC",
      "1")

    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #all field is the same about except  other is source_name and other_text is true value.
  def test_summary_warnings_78
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      @dir,
      false,
      "dir",
      "3",
      "1",
      "3",
      "analyzeme.c",
      "status",
      "ASC",
      "1")
    #there are 6 diff_warning in this list
    assert_equal(diff_warnings.size, 3)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #Test With Case: page is nil,name of directory is false,file_id is file's id,file is file's name,
  # filter id is "file", status is common, rule level is Critical, other is nil, other_text_nil, order field ="status",
  #order_direction is "ASC", name of directory is true ( "sample_c/src ).
  def test_summary_warnings_79
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      false,
      "analyzeme.c",
      "file",
      "1",
      "3",
      "1",
      nil,
      "status",
      "ASC",
      "1")
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule level is hirisk.
  def test_summary_warnings_80
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      false,
      "analyzeme.c",
      "file",
      "1",
      "2",
      "1",
      nil,
      "status",
      "ASC",
      "1")
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule level is normal
  def test_summary_warnings_81
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      false,
      "analyzeme.c",
      "file",
      "1",
      "1",
      "1",
      nil,
      "status",
      "ASC",
      "1")
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule level is Critical,orther is rule_number.
  def test_summary_warnings_82
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      false,
      "analyzeme.c",
      "file",
      "1",
      "3",
      "2",
      nil,
      "status",
      "ASC",
      "1")
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other_text = "3321"
  def test_summary_warnings_83
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      false,
      "analyzeme.c",
      "file",
      "1",
      "3",
      "2",
      "3321",
      "status",
      "ASC",
      "1")
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other_text is special case.
  def test_summary_warnings_84
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      false,
      "analyzeme.c",
      "file",
      "1",
      "3",
      "2",
      "*3*",
      "status",
      "ASC",
      "1")
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other_text is special case
  def test_summary_warnings_85
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      false,
      "analyzeme.c",
      "file",
      "1",
      "3",
      "2",
      "*3#",
      "status",
      "ASC",
      "1")
    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #all field is the same about except other_text is special case
  def test_summary_warnings_86
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      false,
      "analyzeme.c",
      "file",
      "1",
      "3",
      "2",
      "****",
      "status",
      "ASC",
      "1")
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule_level is hirisk,other is nil.
  def test_summary_warnings_87
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(1,
      false,
      "analyzeme.c",
      "file",
      "1",
      "2",
      "1",
      "analyzeme.c",
      "status",
      "ASC",
      "1")

    #there are 15 diff_warning in this list
    assert_equal(diff_warnings.size, 0)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other is rule_number,other_tex is nil
  def test_summary_warnings_88
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(1,
      false,
      "analyzeme.c",
      "file",
      "1",
      "2",
      "2",
      nil,
      "status",
      "ASC",
      "1")
    #there are 15 diff_warning in this list
    assert_equal(diff_warnings.size, 0)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other_tex dont' exest.
  def test_summary_warnings_89
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(nil,
      false,
      "analyzeme.c",
      "file",
      "1",
      "2",
      "2",
      "5972",
      "status",
      "ASC",
      "1")
    # the list must be empty
    assert_equal(diff_warnings.size, 0)
  end

  #all field is the same about except other_tex is true
  def test_summary_warnings_90
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(1,
      false,
      "analyzeme.c",
      "file",
      "1",
      "2",
      "2",
      "0286",
      "status",
      "ASC",
      "1")

    #there are 15 diff_warning in this list
    assert(diff_warnings.size, 0)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule_level is normal, other is nil and other_text is wrong value.
  def test_summary_warnings_91
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(1,
      false,
      "analyzeme.c",
      "file",
      "1",
      "1",
      "1",
      "analyzeme.c",
      "status",
      "ASC",
      "1")
    #there are 15 diff_warning in this list
    assert_equal(diff_warnings.size, DiffWarning.per_page)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #Test With Case: page is nil,name of directory is false,file_id is false,file is false,
  # filter id is "list", status is common, rule level is Critical, other is nil, other_text_nil, order field ="status",
  #order_direction is "ASC", name of directory is true ( "sample_c/src ) .
  def test_summary_warnings_92
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.warning_difference_filter(nil,
      "list",
      "1",
      "3",
      "1",
      nil,
      "status",
      "ASC",
      "1")
    # there are 15 diff_warning in this list
    assert_equal(diff_warnings.size, DiffWarning.per_page)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule level is hirisk.
  def test_summary_warnings_93
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.warning_difference_filter(nil,
      "list",
      "1",
      "2",
      "1",
      nil,
      "status",
      "ASC",
      "1")
    # there are 15 diff_warning in this list
    assert_equal(diff_warnings.size, DiffWarning.per_page)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule level is normal
  def test_summary_warnings_94
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.warning_difference_filter(nil,
      "list",
      "1",
      "1",
      "1",
      nil,
      "status",
      "ASC",
      "1")
    # there are 15 diff_warning in this list
    assert_equal(diff_warnings.size, DiffWarning.per_page)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule level is Critical,orther is rule_number.
  def test_summary_warnings_95
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.warning_difference_filter(nil,
      "list",
      "1",
      "3",
      "2",
      nil,
      "status",
      "ASC",
      "1")
    # there are 15 diff_warning in this list
    assert_equal(diff_warnings.size, DiffWarning.per_page)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other_text = "3321"
  def test_summary_warnings_96
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.warning_difference_filter(nil,
      "list",
      "1",
      "3",
      "2",
      "3321",
      "status",
      "ASC",
      "1")
    # there are 15 diff_warning in this list
    assert_equal(diff_warnings.size, DiffWarning.per_page)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other_text is special case.
  def test_summary_warnings_97
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.warning_difference_filter(nil,
      "list",
      "1",
      "3",
      "2",
      "*3*",
      "status",
      "ASC",
      "1")
    # there are 15 diff_warning in this list
    assert_equal(diff_warnings.size, DiffWarning.per_page)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other_text is special case
  def test_summary_warnings_98
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.warning_difference_filter(nil,
      "list",
      "1",
      "3",
      "2",
      "*3#",
      "status",
      "ASC",
      "1")
    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #all field is the same about except other_text is special case
  def test_summary_warnings_99
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.warning_difference_filter(nil,
      "list",
      "1",
      "3",
      "2",
      "****",
      "status",
      "ASC",
      "1")
    # there are 15 diff_warning in this list
    assert_equal(diff_warnings.size, DiffWarning.per_page)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule_level is hirisk,other is nil.
  def test_summary_warnings_100
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.warning_difference_filter(2,
      "list",
      "1",
      "2",
      "1",
      "analyzeme.c",
      "status",
      "ASC",
      "1")
    #there are 15 diff_warning in this list
    assert_equal(diff_warnings.size, DiffWarning.per_page)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other is rule_number,other_tex is nil
  def test_summary_warnings_101
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.warning_difference_filter(1,
      "list",
      "1",
      "2",
      "2",
      nil,
      "status",
      "ASC",
      "1")

    #there are 15 diff_warning in this list
    assert_equal(diff_warnings.size, DiffWarning.per_page)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other_tex dont' exest.
  def test_summary_warnings_102
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.warning_difference_filter(nil,
      "list",
      "1",
      "2",
      "2",
      "5972",
      "status",
      "ASC",
      "1")

    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #all field is the same about except other_tex is true
  def test_summary_warnings_103
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.warning_difference_filter(1,
      "list",
      "1",
      "2",
      "2",
      "0286",
      "status",
      "ASC",
      "1")

    #there are 15 diff_warning in this list
    assert_equal(diff_warnings.size, DiffWarning.per_page)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except rule_level is normal, other is nil and other_text is wrong value.
  def test_summary_warnings_104
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.warning_difference_filter(1,
      "list",
      "1",
      "1",
      "1",
      "analyzeme.c",
      "status",
      "ASC",
      "1")
    #there are 15 diff_warning in this list
    assert_equal(diff_warnings.size, DiffWarning.per_page)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other directory and other_text is true value.
  def test_summary_warnings_105
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.warning_difference_filter(1,
      "list",
      "1",
      "1",
      "4",
      "sample_c/src",
      "status",
      "ASC",
      "1")
    #there are 15 diff_warning in this list
    assert_equal(diff_warnings.size, DiffWarning.per_page)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except other directory and other_text is true value.
  def test_summary_warnings_106
    @dir = "sample_c/src"
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.warning_difference_filter(nil,
      "list",
      "1",
      "1",
      "4",
      "fffff",
      "status",
      "ASC",
      "1")
    # the list must be empty
    assert(diff_warnings.size == 0)
  end

  #Test With Case: page is 0,name of directory is false,file_id is false,file is false,
  # filter id is "list", status is common, rule level is Critical, other is nil, other_text_nil, order field ="status",
  #order_direction is "ASC", name of directory is true ( "sample_c/src ) .
  def test_summary_warnings_107
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.warning_difference_filter(0,
      "list",
      "1",
      "3",
      "1",
      nil,
      "status",
      "ASC",
      "1")
    # there are 2568 diff_warning in this list
    assert_equal(diff_warnings.size, 2568)
  end

  #all field is the same about except page = 1
  def test_summary_warnings_108
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.warning_difference_filter(1,
      "list",
      "1",
      "3",
      "1",
      nil,
      "status",
      "ASC",
      "1")
    #there are 15 diff_warning in this list
    assert_equal(diff_warnings.size, DiffWarning.per_page)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except page = 171
  def test_summary_warnings_109
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.warning_difference_filter(171,
      "list",
      "1",
      "3",
      "1",
      nil,
      "status",
      "ASC",
      "1")
    #there are 15 diff_warning in this list
    assert_equal(diff_warnings.size, 15)
    # all these warnings belong to analysis results of a diff_result (id = 1)
    diff_warnings.each do |diff_warning|
      assert(1 == diff_warning.diff_file_id)
    end
  end

  #all field is the same about except page = 173
  def test_summary_warnings_110
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.warning_difference_filter(173,
      "list",
      "1",
      "3",
      "1",
      nil,
      "status",
      "ASC",
      "1")
    #there aren't  diff_warning in this list
    assert(diff_warnings.size == 0)
  end

  # download CSV format for dir.
  def test_summary_warnings_111
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(0,
      "sample_c/src",
      false,
      nil,
      nil,
      nil,
      nil,
      nil,
      "status",
      "ASC",
      "1")

    # there are 2568 diff_warning in this list
    assert(3888, diff_warnings.size)
  end

  # download CSV format for dir.
  def test_summary_warnings_112
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(0,
      "sample_c/src",
      false,
      "dir",
      "1",
      "1",
      "1",
      nil,
      "status",
      "ASC",
      "1")
    # there are 1284 diff_warning in this list
    assert(1284, diff_warnings.size)
  end

  #download CSV format for file.
  def test_summary_warnings_113
    # gets a list of diff_warning from database
    diff_warnings = DiffWarning.summary_warnings(0,
      false,
      "analyzeme.c",
      "file",
      "1",
      "1",
      "1",
      nil,
      "status",
      "ASC",
      "1")
    # there are 2568 diff_warning in this list
    assert(1284, diff_warnings.size)
  end
end
