require File.dirname(__FILE__) + "/test_d_setup" unless defined? TestDSetup

class TestD < Test::Unit::TestCase
  include TestDSetup

  def test_010
    open_master_registration_subwindow
    logout
  end

  def test_011
    # registers a master without master's name and file
    register_master("", "")

    # the failed message must be displayed
    assert(is_text_present($messages["register_master_failed"]))

    # logout
    logout
  end

  def test_012
    # before trying to upload
    old_total_masters = count_matched_masters

    # tries to uploas without master's name
    register_master("", MASTER_FILES["normal"])

    # after clicking on "Register button"
    new_total_masters = count_matched_masters

    # the failed message must be displayed
    assert(is_text_present($messages["register_master_failed"]))

    # no new master is registered
    assert_equal(new_total_masters, old_total_masters)

    logout
  end

  def test_013
    # before trying to upload
    old_total_masters = count_matched_masters

    # tries to uploas without master's file
    register_master("normal", "")

    # after clicking on "Register button"
    new_total_masters = count_matched_masters

    # the failed message must be displayed
    wait_for_text_present($messages["register_master_failed"])

    # no new master is registered
    assert_equal(new_total_masters, old_total_masters)

    logout
  end

  def test_014
    # before trying to upload
    old_total_masters = count_matched_masters

    # tries to uploas without master's file
    register_master("normal", MASTER_FILES["normal"])

    # waits for uploading file
    while (old_total_masters == count_matched_masters)
      sleep 1
    end

    # backs to Master management screen
    assert(!is_text_present($window_titles["master_registration"]))

    # a new master row is added into the master list
    new_total_masters = count_matched_masters

    assert_equal(old_total_masters + 1, new_total_masters)

    sleep 2
    # the successful message must be displayed
    assert(is_text_present($messages["register_master_successfully"]))

    logout
  end

  def test_015
    old_total_masters = count_matched_masters
    # tries to uploas without master's file
    register_master("zip", MASTER_FILES["zip"])

    sleep 3

    # the error message is displayed
    assert(is_text_present($messages["master_invalid_filetype"]))

    # no new master is registered
    new_total_masters = count_matched_masters
    assert_equal(old_total_masters, new_total_masters)

    logout
  end

  def test_016
    old_total_masters = count_matched_masters
    # tries to uploas without master's file
    register_master("lzh", MASTER_FILES["lzh"])

    # the error message is displayed
    assert(is_text_present($messages["master_invalid_filetype"]))

    # no new master is registered
    new_total_masters = count_matched_masters
    assert_equal(old_total_masters, new_total_masters)

    logout
  end

  def test_017
    old_total_masters = count_matched_masters
    # tries to uploas without master's file
    register_master("tar", MASTER_FILES["tar"])

    # the error message is displayed
    wait_for_text_present($messages["register_master_successfully"])

    # no new master is registered
    new_total_masters = count_matched_masters
    assert_equal(old_total_masters + 1, new_total_masters)

    logout
  end

  def test_018
    register_large_master("100mb")
    logout
  end

  def test_019
    register_large_master("100mb")

    master_id = Master.last.id
    segments  = Segment.find(:all,
                             :conditions  => { :fk_id => master_id },
                             :select      => :sequence_id)
    assert_not_nil(segments)

    logout
  end

  def test_020
    register_large_master("100mb")

    master_id = Master.last.id
    segments  = Segment.find(:all,
                             :conditions  => { :fk_id => master_id },
                             :select      => :sequence_id)
    assert_not_nil(segments)

    logout
  end

  def test_021
    register_large_master("800mb")
    logout
  end

  def test_022
    register_large_master("800mb")

    master_id = Master.find(:last).id
    segments  = Segment.find(:all,
                             :conditions  => { :fk_id => master_id },
                             :select      => :sequence_id)
    assert_not_nil(segments)

    logout
  end

  def test_023
    register_large_master("800mb")

    master_id = Master.find(:last).id
    segments  = Segment.find(:all,
                             :conditions  => { :fk_id => master_id },
                             :select      => :sequence_id)
    assert_not_nil(segments)

    logout
  end

  def test_024
    register_large_master("1000mb")
    logout
  end

  def test_025
    register_large_master("1000mb")

    master_id = Master.find(:last).id
    segments  = Segment.find(:all,
                             :conditions  => { :fk_id => master_id },
                             :select      => :sequence_id)
    assert_not_nil(segments)

    logout
  end

  def test_026
    register_large_master("1000mb")

    master_id = Master.find(:last).id
    segments  = Segment.find(:all,
                             :conditions  => { :fk_id => master_id },
                             :select      => :sequence_id)
    assert_not_nil(segments)

    logout
  end

  def test_027
    register_large_master("1200mb")
    logout
  end

  def test_028
    register_large_master("1200mb")

    master_id = Master.find(:last).id
    segments  = Segment.find(:all,
                             :conditions  => { :fk_id => master_id },
                             :select      => :sequence_id)
    assert_not_nil(segments)

    logout
  end

  def test_029
    register_large_master("1200mb")

    master_id = Master.find(:last).id
    segments  = Segment.find(:all,
                             :conditions  => { :fk_id => master_id },
                             :select      => :sequence_id)
    assert_not_nil(segments)

    logout
  end

end
