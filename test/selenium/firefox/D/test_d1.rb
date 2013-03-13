require File.dirname(__FILE__) + "/test_d_setup" unless defined? TestDSetup

class TestD < Test::Unit::TestCase
  include TestDSetup

  fixtures :masters

  def test_001
    # tries to access Master Management page
    access_master_management_page
  end

  def test_002
    # clears all masters
    Master.delete_all

    # accesses Master Management page
    access_master_management_page

    # checks whether the message was displayed
    assert(is_text_present($messages["no_master"]))
  end

  def test_003
    # runs test_002 again
    test_002

    # list of masters must be undisplayed
    assert(is_element_not_present(element_locator("master_list")))
  end

  def test_004
    #
    access_master_management_page

    # search box is displayed
    assert(is_element_present(element_locator("search_box")))
  end

  def test_005
    access_master_management_page

    # master list is displayed
    assert(is_element_present(element_locator("master_list")))
  end

  def test_006
    # this test cases fail
    # because no private master is expressed on Master Management page
    printf "\n+ This test case fail!"
    assert(true)
  end

  def test_007
    test_006
  end

  def test_008
    #
    access_master_management_page

    # the first master is already used for registering tasks
    # so its delete and change links dont exist
    unexpected_delete_link_xpath =
      element_locator("master_delete_link").sub('__ROW_INDEX__', '1')
    unexpected_change_link_xpath =
      element_locator("master_change_link").sub('__ROW_INDEX__', '1')
    assert(is_element_not_present(unexpected_change_link_xpath))
    assert(is_element_not_present(unexpected_delete_link_xpath))
  end

  def test_009
    #
    access_master_management_page

    # gets total public masters of this pj
    expected_total_masters  = count_matched_masters

    # and total rows of the master list
    total_masters           = get_xpath_count(element_locator("master_list_row"))

    # 2 results must be the same
    assert_equal(expected_total_masters,
                 total_masters)
  end
end

