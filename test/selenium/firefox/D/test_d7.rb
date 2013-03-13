require File.dirname(__FILE__) + "/test_d_setup" unless defined? TestDSetup

class TestD < Test::Unit::TestCase
   include TestDSetup
    PART_OF_DATE = "2009-05-08"
  def test_057
    access_master_management_page

    sort_master_list(1)
    logout
  end

  def test_058
    access_master_management_page

    sort_master_list(2)

    logout
  end

  def test_059
    access_master_management_page

    sort_master_list(3)

    logout
  end

  def test_060
    access_master_management_page

    sort_master_list(4)

    logout
  end

  def test_061
    access_master_management_page

    sort_master_list(5)

    logout
  end

  def test_062
    filter_master('created_at',
                  PART_OF_DATE)
    sort_master_list(1)
    logout
  end
  def get_column(column_index)
    total_rows = get_xpath_count(element_locator('master_list_row'))
    values = (1..total_rows).collect do |row_index|
      cell_xpath = element_locator('master_list_row') + "[#{row_index}]/td[#{column_index}]"
      get_text(cell_xpath)
    end
  end

  def sort_master_list(column_index)
    values = get_column(column_index)

    # descending sort
    click element_locator("master_list_headers")[column_index - 1]
    sleep 5

    if column_index == 1
      expected_sorted_values = values.sort { |x, y| y.to_i <=> x.to_i }
    else
      expected_sorted_values = values.sort { |x, y| y <=> x}
    end

    sorted_values = get_column(column_index)
    assert_equal(expected_sorted_values, sorted_values)

    # ascending sort
    click element_locator("master_list_headers")[column_index - 1]

    sleep 5

    if column_index == 1
      expected_sorted_values = values.sort { |x, y| x.to_i <=> y.to_i }
    else
      expected_sorted_values = values.sort { |x, y| x <=> y}
    end

    sorted_values = get_column(column_index)
    assert_equal(expected_sorted_values, sorted_values)
  end
end
