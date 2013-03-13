require File.dirname(__FILE__) + "/test_e1_setup" unless defined? TestDSetup

class TestE1b < Test::Unit::TestCase
  include TestE1Setup

  self.fixture_path = File.dirname(__FILE__)
  fixtures :tasks

  def test_018
    access_task_management_page_as_root

    dates = get_col('overall',
                    'date')
    expected_dates = dates.sort {|x, y| x <=> y}

    assert_equal(expected_dates,
                 dates)

    open_individual_tab

    dates = get_col('individual',
                    'date')
    expected_dates = dates.sort {|x, y| x <=> y}
    assert_equal(expected_dates,
                 dates)

    open_other_tab

    dates = get_col('other',
                    'date')
    expected_dates = dates.sort {|x, y| x <=> y}
    assert_equal(expected_dates,
                 dates)
    logout
  end

  def test_019
    access_task_management_page_as_root

    # overall tab
    indicators = element_locator('indicators')['overall']
    next_indicator = indicators['next']
    back_indicator = indicators['back']
    assert(is_element_not_present(next_indicator))
    assert(is_element_not_present(back_indicator))

    # individual tab
    open_individual_tab
    indicators = element_locator('indicators')['individual']
    next_indicator = indicators['next']
    back_indicator = indicators['back']
    assert(is_element_not_present(next_indicator))
    assert(is_element_not_present(back_indicator))

    # other tab
    open_other_tab
    indicators = element_locator('indicators')['other']
    next_indicator = indicators['next']
    back_indicator = indicators['back']
    assert(is_element_not_present(next_indicator))
    assert(is_element_not_present(back_indicator))

    logout
  end

  def test_020
    access_task_management_page_as_root

    # overall tab
    indicators = element_locator('indicators')['overall']
    next_indicator = indicators['next']
    assert(is_element_present(next_indicator))

    # individual tab
    open_individual_tab
    indicators = element_locator('indicators')['individual']
    next_indicator = indicators['next']
    assert(is_element_present(next_indicator))

    # other tab
    open_other_tab
    indicators = element_locator('indicators')['other']
    next_indicator = indicators['next']
    assert(is_element_not_present(next_indicator))

    logout
  end

  def test_021
    access_task_management_page_as_root

    # overall tab
    indicators = element_locator('indicators')['overall']
    next_indicator = indicators['next']
    assert(is_element_present(next_indicator))
    old_ids = get_col('overall', 'id')
    click next_indicator
    sleep 5
    new_ids = get_col('overall', 'id')
    assert_not_equal(old_ids, new_ids)

    # individual tab
    open_individual_tab
    indicators = element_locator('indicators')['individual']
    next_indicator = indicators['next']
    assert(is_element_present(next_indicator))
    old_ids = get_col('overall', 'id')
    click next_indicator
    sleep 5
    new_ids = get_col('individual', 'id')
    assert_not_equal(old_ids, new_ids)

    # other tab
    open_other_tab
    indicators = element_locator('indicators')['other']
    next_indicator = indicators['next']
    assert(is_element_present(next_indicator))
    old_ids = get_col('other', 'id')
    click next_indicator
    sleep 5
    new_ids = get_col('overall', 'id')
    assert_not_equal(old_ids, new_ids)

    logout
  end

  def test_022
    access_task_management_page_as_root

    # overall tab
    change_page('overall')
    dates = get_col('overall', 'date')
    expected_dates = dates.sort { |x, y| y <=> x}
    assert_equal(expected_dates,
                 dates)
    # individual tab
    change_page('individual')
    dates = get_col('individual', 'date')
    expected_dates = dates.sort { |x, y| y <=> x}
    assert_equal(expected_dates,
                 dates)

    # other tab
    change_page('other')
    dates = get_col('other', 'date')
    expected_dates = dates.sort{|x, y| y <=> x}
    assert_equal(expected_dates,
                 dates)
    logout
  end

  def test_023
    access_task_management_page_as_root

    # overall tab
    change_page('overall')
    assert(is_element_present(element_locator('indicators')['overall']['back']))
    # individual tab
    change_page('individual')
    assert(is_element_present(element_locator('indicators')['individual']['back']))

    # other tab
    change_page('other')
    assert(is_element_present(element_locator('indicators')['other']['back']))
    logout
  end

  def test_024
    access_task_management_page_as_root

    # overall tab
    change_page('overall')
    assert(is_element_present(element_locator('indicators')['overall']['next']))
    # individual tab
    change_page('individual')
    assert(is_element_present(element_locator('indicators')['individual']['next']))

    # other tab
    change_page('other')
    assert(is_element_present(element_locator('indicators')['other']['next']))
    logout
  end

  def test_025
    access_task_management_page_as_root

    # overall tab
    old_ids = get_col('overall', 'id')
    change_page('overall', 'back')
    new_ids = get_col('overall', 'id')
    ## the list is updated
    assert_not_equal(new_ids, old_ids)

    # individual
    old_ids = get_col('individual', 'id')
    change_page('individual', 'back')
    new_ids = get_col('individual', 'id')
    assert_not_equal(new_ids, old_ids)

    # other
    old_ids = get_col('other', 'id')
    change_page('other', 'back')
    new_ids = get_col('individual', 'id')
    assert_not_equal(new_ids, old_ids)

    logout
  end

  def test_026
    access_task_management_page_as_root

    # overall tab
    old_ids = get_col('overall', 'id')
    #change_page('overall')
    change_page('overall', 'back')
    new_ids = get_col('overall', 'id')
    ## the list is updated
    assert_equal(new_ids, old_ids)

    # individual
    old_ids = get_col('individual', 'id')
    #change_page('individual')
    change_page('individual', 'back')
    new_ids = get_col('individual', 'id')
    assert_equal(new_ids, old_ids)

    # other
    old_ids = get_col('other', 'id')
    #change_page('other')
    change_page('other', 'back')
    new_ids = get_col('individual', 'id')
    assert_equal(new_ids, old_ids)

    logout
  end

  def test_027
    access_task_management_page_as_root

    # overall tab
    change_page('overall', 'back')
    assert(is_element_present(element_locator('indicators')['overall']['next']))

    # individual
    old_ids = get_col('individual', 'id')
    change_page('individual', 'back')
    assert(is_element_present(element_locator('indicators')['individual']['next']))

    # other
    old_ids = get_col('other', 'id')
    change_page('other', 'back')
    assert(is_element_present(element_locator('indicators')['other']['next']))

    logout
  end

  def test_028
    access_task_management_page_as_root

    # overall tab
    ids = get_col('overall', 'id')
    while is_element_present(element_locator('indicators')['overall']['back'])
      change_page('overall', 'back')
      ids += get_col('overall', 'id')
    end

    # individual
    open_individual_tab
    ids += get_col('individual', 'id')
    while is_element_present(element_locator('indicators')['individual']['back'])
      change_page('individual', 'back')
      ids += get_col('individual', 'id')
    end
    #
    # other
    open_other_tab
    ids += get_col('other', 'id')
    while is_element_present(element_locator('indicators')['other']['back'])
      change_page('other', 'back')
      ids += get_col('other', 'id')
    end

    # no duplicated task
    assert_equal(ids.uniq, ids)

    logout
  end

  def test_029
    access_task_management_page_as_root

    # overall tab
    ids = get_col('overall', 'id')
    while is_element_present(element_locator('indicators')['overall']['back'])
      change_page('overall', 'back')
      ids += get_col('overall', 'id')
    end

    # individual
    open_individual_tab
    ids += get_col('individual', 'id')
    while is_element_present(element_locator('indicators')['individual']['back'])
      change_page('individual', 'back')
      ids += get_col('individual', 'id')
    end
    #
    # other
    open_other_tab
    ids += get_col('other', 'id')
    while is_element_present(element_locator('indicators')['other']['back'])
      change_page('other', 'back')
      ids += get_col('other', 'id')
    end

    # all tasks are listed in our 3 tab
    tasks = Task.find(:all,
                      :conditions => { :pj_id => PJ_ID} )
    expected_ids = tasks.collect do |task| task.id.to_s end

    assert_equal([], expected_ids - ids)

    logout
  end
end
