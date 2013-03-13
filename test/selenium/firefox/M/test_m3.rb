require File.dirname(__FILE__) + "/test_m_setup" unless defined? TestMSetup
require File.dirname(__FILE__) + "/../D/test_d_setup" unless defined? TestDSetup
#require "test/unit"
class TestM3 < Test::Unit::TestCase
  include TestMSetup
  include TestDSetup
  # Arbitrary masters are chosen and deleted from a "master management" page.
  # Segment record is deleted
  def test_043
    test_000
    login("root","root")
    register_master("normal", MASTER_FILES["normal"])
    master_chosen = Master.find(:last)
    all_segments_of_master = Segment.find_all_by_fk_id(master_chosen)
    assert_not_equal all_segments_of_master, []
    delete_master
    wait_for_text_present(_(" deleted successfully!"))
    all_segments_of_master = Segment.find_all_by_fk_id(master_chosen)
    assert_equal all_segments_of_master, []
    logout
  end

  # Arbitrary masters are chosen and deleted from a "master management" page.
  # Directory tree record is deleted
  def test_044
    test_000
    login("root","root")
    register_master("normal", MASTER_FILES["normal"])
    master_chosen = Master.find(:last)
    all_directory_tree_of_master = DirectoryTree.find_all_by_fk_id(master_chosen)
    assert_not_equal all_directory_tree_of_master, []
    delete_master
    wait_for_text_present(_(" deleted successfully!"))
    all_directory_tree_of_master= DirectoryTree.find_all_by_fk_id(master_chosen)
    assert_equal all_directory_tree_of_master, []
    logout
  end


  # Arbitrary masters are chosen and deleted from a "master management" page.
  # Temp file record is deleted
  def test_045
    test_000
    login("root","root")
    register_master("normal", MASTER_FILES["normal"])
    master_chosen = Master.find(:last)
    all_temp_file_of_master = TempFile.find_all_by_master_id(master_chosen)
    delete_master
    wait_for_text_present(_(" deleted successfully!"))
    all_temp_file_of_master = TempFile.find_all_by_master_id(master_chosen)
    assert_equal all_temp_file_of_master, []
    logout
  end
end
