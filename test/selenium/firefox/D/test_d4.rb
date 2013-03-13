require File.dirname(__FILE__) + "/test_d_setup" unless defined? TestDSetup

class TestD < Test::Unit::TestCase
  include TestDSetup
  def test_035
    login
    register_master("New_master",MASTER_FILES["tar"])
    # before clicking on Delete link
    old_total_masters = count_matched_masters

    access_master_management_page

    # clicks Cancel button on next Confirmation dialog
    choose_cancel_on_next_confirmation

    # clicks on Delete link
    click("//tbody[@id='master_list']/tr[#{old_total_masters}]/td[6]/a[1]")

    # makes sure that there is a confirmation
    get_confirmation

    # no master is delete
    new_total_masters = count_matched_masters
    assert_equal(old_total_masters, new_total_masters)

    logout
  end

  def test_036
    # test/unit/del_master_test.rb is missing
    printf "\n+ This is not a test case!"
    assert(true)
  end

  def test_037
    test_036
  end

  def test_038
    test_036
  end
end
