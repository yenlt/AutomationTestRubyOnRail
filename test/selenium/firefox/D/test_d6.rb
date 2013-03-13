require File.dirname(__FILE__) + "/test_d_setup" unless defined? TestDSetup
class TestD < Test::Unit::TestCase
  include TestDSetup

  FILTER_NAME         = 'sample_c'
  INVALID_FILTER_NAME = 'xyztuv'
  REGISTRANT_ID       = '1'
  INVALID_REGISTRANT_ID = '100'

  DATE          = "2009-05-08"
  PART_OF_DATE  = "2009"

  def test_047
    filter_master('name',
      FILTER_NAME)

    # number row of master list must equal in the database
    expected_total_masters = count_matched_masters('name',
                                                   FILTER_NAME)
    get_xpath_count(element_locator('master_list_row'))
    wait_for_xpath_count(element_locator('master_list_row'),
                         expected_total_masters)

    # name of master in the list must match the FILTER_NAME
    (1..expected_total_masters).each do |row_index|
      cell_xpath = element_locator("master_list_row") + "[#{row_index}]/td[2]"
      master_name = get_text(cell_xpath)
      assert_not_nil(master_name.index(FILTER_NAME))
    end

    logout
  end

  def test_048
    filter_master('name',
                  INVALID_FILTER_NAME)

    # a notice is displayed
    wait_for_text_present($messages['no_matched_master'])
    logout
  end

  def test_049
    filter_master('master_status_id',
                  '1')
    # only used masters are displayed
    total_masters = count_matched_masters('master_status_id',
                                          '1')
    #wait_for_xpath_count(element_locator('master_list_row'),
    #                     total_masters)
    (1..total_masters).each do |row_index|
      cell_xpath = element_locator("master_list_row") + "[#{row_index}]/td[1]"
      master_id = get_text(cell_xpath)
      master = Master.find(master_id)
      assert_equal(1, master.master_status_id)
    end
    logout
  end

  def test_050
    filter_master('master_status_id',
                  '2')
    # only used masters are displayed
    total_masters = count_matched_masters('master_status_id',
                                          '2')
    wait_for_xpath_count(element_locator('master_list_row'),
                         total_masters)
    (1..total_masters).each do |row_index|
      cell_xpath = element_locator("master_list_row") + "[#{row_index}]/td[1]"
      master_id = get_text(cell_xpath)
      master = Master.find(master_id)
      assert_equal(2,
                   master.master_status_id)
    end
    logout
  end

  def test_051
    filter_master('master_status_id',
                  '5')
    # no master found, and a message is displayed
    wait_for_text_present($messages['no_matched_master'])
    logout
  end

  def test_052
    filter_master('master_status_id',
                  '')
    total_masters = count_matched_masters('master_status_id',
                                          '')
    # all masters of this PJ is displayed
    wait_for_xpath_count(element_locator('master_list_row'),
                         total_masters)
    expected_total_masters = count_matched_masters('1', '1')
    assert_equal(expected_total_masters,
                 total_masters)
    logout
  end

  def test_053
    # changes registrant of the last master
    master = Master.last
    master.user_id = 2
    master.save

    filter_master('user_id',
                  '1')
    total_masters = count_matched_masters('user_id',
                                          '1')

    wait_for_xpath_count(element_locator('master_list_row'),
                         total_masters)

    logout
  end

  def test_054
    filter_master('user_id',
                  'xyztuv')

    wait_for_text_present($messages['no_matched_master'])
    logout
  end

  def test_055
    filter_master('created_at',
                  DATE)
    total_masters = count_matched_masters('created_at', DATE)

    wait_for_xpath_count(element_locator('master_list_row'),
                         total_masters)
    (1..total_masters).each do |row_index|
      cell_xpath = element_locator('master_list_row') + "[#{row_index}]/td[5]"
      date = get_text(cell_xpath)
      assert_match(Regexp.new(DATE), date)
    end
    logout
  end

  def test_056
    filter_master('created_at',
                  PART_OF_DATE)
    total_masters = count_matched_masters('created_at', PART_OF_DATE)

    wait_for_xpath_count(element_locator('master_list_row'),
                         total_masters)
    (1..total_masters).each do |row_index|
      cell_xpath = element_locator('master_list_row') + "[#{row_index}]/td[5]"
      date = get_text(cell_xpath)
      assert_match(Regexp.new(PART_OF_DATE), date)
    end
    logout
  end

end

