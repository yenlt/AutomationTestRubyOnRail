require File.dirname(__FILE__) + "/../E1/test_e1_setup" unless defined? TestE1Setup

class TestE2c < Test::Unit::TestCase
  include TestE1Setup

  self.fixture_path = File.dirname(__FILE__)
  fixtures :all

  def test_058
    login("root",
          "root")

    expected_task_links = 3
    # we are on misc_index
    ## there are links to view waiting tasks (up to 3)
    total_waiting_task_links = get_xpath_count(element_locator('misc')['waiting'])
    assert_equal(expected_task_links, total_waiting_task_links)
    ## there tasks are ordered descending by update date
    task_ids = []
    (1..total_waiting_task_links).each do |index|
      link = element_locator('misc')['waiting'] + "[#{index}]/a"
      href = get_attribute(link, 'href')
      href =~ /.*?id=(\d+)/
      task_ids << $1
    end
    tasks = Task.find(:all,
                      :conditions     => {:pj_id          => 1,
                                          :task_state_id  => 1},
                      :limit          => 3,
                      :order          => 'updated_at desc',
                      :select         => 'id')
    expected_ids = tasks.collect { |task| task.id.to_s }
    assert_equal(expected_ids, task_ids)
    #
    total_waiting_task_links = get_xpath_count(element_locator('misc')['analyzing'])
    assert_equal(expected_task_links, total_waiting_task_links)
    ## there tasks are ordered descending by update date
    task_ids = []
    (1..total_waiting_task_links).each do |index|
      link = element_locator('misc')['analyzing'] + "[#{index}]/a"
      href = get_attribute(link, 'href')
      href =~ /.*?id=(\d+)/
      task_ids << $1
    end
    tasks = Task.find(:all,
                      :conditions     => {:pj_id          => 1,
                                          :task_state_id  => 2},
                      :limit          => 3,
                      :order          => 'updated_at desc',
                      :select         => 'id')
    expected_ids = tasks.collect { |task| task.id.to_s }
    assert_equal(expected_ids, task_ids)
    #
    total_waiting_task_links = get_xpath_count(element_locator('misc')['completed'])
    assert_equal(expected_task_links, total_waiting_task_links)
    ## there tasks are ordered descending by update date
    task_ids = []
    (1..total_waiting_task_links).each do |index|
      link = element_locator('misc')['completed'] + "[#{index}]/a"
      href = get_attribute(link, 'href')
      href =~ /.*?id=(\d+)/
      task_ids << $1
    end
    tasks = Task.find(:all,
                      :conditions     => {:pj_id          => 1,
                                          :task_state_id  => 5},
                      :limit          => 3,
                      :order          => 'updated_at desc',
                      :select         => 'id')
    expected_ids = tasks.collect { |task| task.id.to_s }
    assert_equal(expected_ids, task_ids)

    #########################################################################
    open_pu_index
    ## there are links to view waiting tasks (up to 3)
    total_waiting_task_links = get_xpath_count(element_locator('pu_index')['waiting'])
   # assert_equal(expected_task_links, total_waiting_task_links)
    ## there tasks are ordered descending by update date
    task_ids = []
    (1..total_waiting_task_links).each do |index|
      link = element_locator('pu_index')['waiting'] + "[#{index}]/a"
      href = get_attribute(link, 'href')
      href =~ /.*?id=(\d+)/
      task_ids << $1
    end
    task_ids = task_ids - [nil]
    tasks = Task.find(:all,
                      :conditions     => {:pj_id          => 1,
                                          :task_state_id  => 1},
                      :limit          => 3,
                      :order          => 'updated_at desc',
                      :select         => 'id')
    expected_ids = tasks.collect { |task| task.id.to_s }
    assert_equal(expected_ids, task_ids)
    #
    total_waiting_task_links = get_xpath_count(element_locator('pu_index')['analyzing'])
    #assert_equal(expected_task_links, total_waiting_task_links)
    ## there tasks are ordered descending by update date
    task_ids = []
    (1..total_waiting_task_links).each do |index|
      link = element_locator('pu_index')['analyzing'] + "[#{index}]/a"
      href = get_attribute(link, 'href')
      href =~ /.*?id=(\d+)/
      task_ids << $1
    end
    task_ids = task_ids - [nil]
    tasks = Task.find(:all,
                      :conditions     => {:pj_id          => 1,
                                          :task_state_id  => 2},
                      :limit          => 3,
                      :order          => 'updated_at desc',
                      :select         => 'id')
    expected_ids = tasks.collect { |task| task.id.to_s }
    assert_equal(expected_ids, task_ids)
    #
    total_waiting_task_links = get_xpath_count(element_locator('pu_index')['completed'])
    #assert_equal(expected_task_links, total_waiting_task_links)
    ## there tasks are ordered descending by update date
    task_ids = []
    (1..total_waiting_task_links).each do |index|
      link = element_locator('pu_index')['completed'] + "[#{index}]/a"
      href = get_attribute(link, 'href')
      href =~ /.*?id=(\d+)/
      task_ids << $1
    end
    task_ids = task_ids - [nil]
    tasks = Task.find(:all,
                      :conditions     => {:pj_id          => 1,
                                          :task_state_id  => 5},
                      :limit          => 3,
                      :order          => 'updated_at desc',
                      :select         => 'id')
    expected_ids = tasks.collect { |task| task.id.to_s }
    assert_equal(expected_ids, task_ids)
    #########################################################################
    open_pj_index
    ## there are links to view waiting tasks (up to 3)
    total_waiting_task_links = get_xpath_count(element_locator('pj_index')['waiting'])
    #assert_equal(expected_task_links, total_waiting_task_links)
    ## there tasks are ordered descending by update date
    task_ids = []
    (1..total_waiting_task_links).each do |index|
      link = element_locator('pj_index')['waiting'] + "[#{index}]/a"
      href = get_attribute(link, 'href')
      href =~ /.*?id=(\d+)/
      task_ids << $1
    end
    tasks = Task.find(:all,
                      :conditions     => {:pj_id          => 1,
                                          :task_state_id  => 1},
                      :limit          => 3,
                      :order          => 'updated_at desc',
                      :select         => 'id')
    expected_ids = tasks.collect { |task| task.id.to_s }
    assert_equal(expected_ids, task_ids)
    #
    total_waiting_task_links = get_xpath_count(element_locator('pj_index')['analyzing'])
    #assert_equal(expected_task_links, total_waiting_task_links)
    ## there tasks are ordered descending by update date
    task_ids = []
    (1..total_waiting_task_links).each do |index|
      link = element_locator('pj_index')['analyzing'] + "[#{index}]/a"
      href = get_attribute(link, 'href')
      href =~ /.*?id=(\d+)/
      task_ids << $1
    end
    task_ids = task_ids - [nil]
    tasks = Task.find(:all,
                      :conditions     => {:pj_id          => 1,
                                          :task_state_id  => 2},
                      :limit          => 3,
                      :order          => 'updated_at desc',
                      :select         => 'id')
    expected_ids = tasks.collect { |task| task.id.to_s }
    assert_equal(expected_ids, task_ids)
    #
    total_waiting_task_links = get_xpath_count(element_locator('pj_index')['completed'])
    #assert_equal(expected_task_links, total_waiting_task_links)
    ## there tasks are ordered descending by update date
    task_ids = []
    (1..total_waiting_task_links).each do |index|
      link = element_locator('pj_index')['completed'] + "[#{index}]/a"
      href = get_attribute(link, 'href')
      href =~ /.*?id=(\d+)/
      task_ids << $1
    end
    task_ids = task_ids - [nil]
    tasks = Task.find(:all,
                      :conditions     => {:pj_id          => 1,
                                          :task_state_id  => 5},
                      :limit          => 3,
                      :order          => 'updated_at desc',
                      :select         => 'id')
    expected_ids = tasks.collect { |task| task.id.to_s }
    assert_equal(expected_ids, task_ids)

    logout
  end

  def test_059

    href = ""
    expected_location = full_url_for(:controller => 'task',
                          :action => 'task_detail',
                          :pu => PU_ID,
                          :pj => PJ_ID,
                          :id => TASK_ID)
    if BROWSER == 'ie'
      href = expected_location
    else
      href = url_for(:controller => 'task',
                     :action => 'task_detail',
                     :pu => PU_ID,
                     :pj => PJ_ID,
                     :id => TASK_ID)
    end
    task_link = "//a[@href='#{href}']"
    login("root", "root")

    click task_link
    wait_for_page_to_load 30000
    assert_equal(expected_location,
                 get_location)

    # now pu_index
    open_pu_index
    click task_link
    wait_for_page_to_load 30000
    assert_equal(expected_location,
                 get_location)

    # pj_index
    open_pj_index
    click task_link
    wait_for_page_to_load 30000
    assert_equal(expected_location,
                 get_location)
    logout
  end

  def test_060

    expected_location = full_url_for(:controller => 'task',
                          :action => 'task_detail',
                          :pu => PU_ID,
                          :pj => PJ_ID,
                          :id => TASK_ID)
    if BROWSER == 'ie'
      href = expected_location
    else
      href = url_for(:controller => 'task',
                     :action => 'task_detail',
                     :pu => PU_ID,
                     :pj => PJ_ID,
                     :id => TASK_ID)
    end
    task_link = "//a[@href='#{href}']"
    login("root", "root")

    # opens task details page
    click task_link
    wait_for_page_to_load 30000

    # Except for status not being updated dynamically, all are served like the detailed information of the Management page of an analysis task.
    element_locator('details').each do |key, value|
      assert(is_element_present(value))
    end

    logout
  end

  def test_061
    access_task_detail_page_as_root
    assert(is_element_not_present(element_locator('details')['delete_link']))
    logout
  end

  def test_062
    access_task_detail_page_as_root
    indicators = element_locator('task_indicators')

    # the newest task
    assert(is_element_present(indicators['back']))
    assert(is_element_not_present(indicators['next']))

    logout
  end
  def test_062
    access_task_detail_page_as_root
    indicators = element_locator('task_indicators')

    # the newest task
    assert(is_element_present(indicators['back']))
    assert(is_element_not_present(indicators['next']))

    logout
  end

  def test_063
    access_task_detail_page_as_root
    task = Task.find(2)

    # click on "<-"
    indicators = element_locator('task_indicators')
    back_indicator = indicators['back']
    assert(is_element_present(back_indicator))
    click back_indicator

    # The detailed information of the task registered before [ of the present task ] one is displayed.
    wait_for_text_present(task.name)

    logout
  end

  def test_064
    access_task_detail_page_as_root(PU_ID, PJ_ID, 2)
    task = Task.find(1)
    # click on "<-"
    indicators = element_locator('task_indicators')
    next_indicator = indicators['next']
    assert(is_element_present(next_indicator))

    # The detailed information of the task registered into the next of the present task is displayed.
    click next_indicator
    wait_for_text_present(task.name)

    logout
  end

  def test_065
    access_task_detail_page_as_root
    task = Task.find(:last, :conditions => {:pj_id => PJ_ID})

    # click on "<-"
    indicators = element_locator('task_indicators')
    back_indicator = indicators['back']
    while(is_element_present(back_indicator))
      click back_indicator
      sleep 3
    end

    # The detailed information of the oldest task of the pj
    wait_for_text_present(task.name)

    logout
  end

  def test_066
    expected_location = full_url_for(:controller => 'task',
                          :action => 'task_detail',
                          :pu => PU_ID,
                          :pj => PJ_ID,
                          :id => TASK_ID)
    if BROWSER == 'ie'
      href = expected_location
    else
      href = url_for(:controller => 'task',
                     :action => 'task_detail',
                     :pu => PU_ID,
                     :pj => PJ_ID,
                     :id => TASK_ID)
    end

    # misc
    task_link = "//a[@href='#{href}']"
    login("root", "root")

    click task_link
    wait_for_page_to_load 30000
    assert_equal(expected_location,
                 get_location)

    # pu_index
    open_pu_index
    click task_link
    wait_for_page_to_load 30000
    assert_equal(expected_location,
                 get_location)

    # pj_index
    open_pj_index
    click task_link
    wait_for_page_to_load 30000
    assert_equal(expected_location,
                 get_location)

    logout
  end

  def test_067
    # makes task1 become an individual task
    task = Task.first

    task.analyze_type_id = 2
    task.private_source_id = 7
    task.save

    test_066
  end

  def test_068
    expected_location = full_url_for(:controller => 'task',
                          :action => 'task_detail',
                          :pu => PU_ID,
                          :pj => PJ_ID,
                          :id => TASK_ID)
    if BROWSER == 'ie'
      href = expected_location
    else
      href = url_for(:controller => 'task',
                     :action => 'task_detail',
                     :pu => PU_ID,
                     :pj => PJ_ID,
                     :id => TASK_ID)
    end

    # misc
    task_link = "//a[@href='#{href}']"
    login("pj_member", "pj_member")

    click task_link
    wait_for_page_to_load 30000
    assert_equal(expected_location,
                 get_location)

    # pu_index
    open_pu_index
    click task_link
    wait_for_page_to_load 30000
    assert_equal(expected_location,
                 get_location)

    # pj_index
    open_pj_index
    click task_link
    wait_for_page_to_load 30000
    assert_equal(expected_location,
                 get_location)

    logout

  end

  def test_069
    # makes task1 become an individual task of pj_member
    task = Task.first

    task.analyze_type_id = 2
    task.private_source_id = 7
    task.user_id = 2
    task.save

    test_068
  end

  def test_070
    # makes task (id=1) become an other task of pj_member
    task = Task.first
    task.analyze_type_id = 2
    task.private_source_id = 7
    task.save

    access_task_detail_page_as_pj_member
    assert(is_text_present($messages['task_detail_denied']))
    logout
  end

  def test_071
    login("root", "root")
    # waiting tasks
    task_area = '//div[@id="reserved_task"]'
    pu_xpath = task_area + "/ul"
    total_pus = get_xpath_count(pu_xpath)
    (1..total_pus).each do |pu_index|
      pu = pu_xpath + "[#{pu_index}]"
      pu_link = pu + "/li/a"
      href = get_attribute(pu_link, 'href')
      href =~ /.*?(\d+)/
      pu_id = $1

      pj_xpath = pu + "/ul"
      total_pjs = get_xpath_count(pj_xpath)
      (1..total_pjs).each do |pj_index|
        pj = pj_xpath + "[#{pj_index}]"
        pj_link = pj + "/li/a"
        href = get_attribute(pj_link, "href")
        href =~ /.*?(\d+)/
        pj_id = $1

        task_xpath = pj + "/ul/li"
        total_tasks = get_xpath_count(task_xpath)

        (1..total_tasks).each do |task_index|
          task = task_xpath + "[#{task_index}]/a"
          href = get_attribute(task, "href")
          href =~ /.*?\/(\d+)\/(\d+).*?/
          assert_equal(pu_id, $1)
          assert_equal(pj_id, $2)
        end
      end
    end

    # analyzing tasks
    task_area = '//div[@id="executing_task"]'
    pu_xpath = task_area + "/ul"
    total_pus = get_xpath_count(pu_xpath)
    (1..total_pus).each do |pu_index|
      pu = pu_xpath + "[#{pu_index}]"
      pu_link = pu + "/li/a"
      href = get_attribute(pu_link, 'href')
      href =~ /.*?(\d+)/
      pu_id = $1

      pj_xpath = pu + "/ul"
      total_pjs = get_xpath_count(pj_xpath)
      (1..total_pjs).each do |pj_index|
        pj = pj_xpath + "[#{pj_index}]"
        pj_link = pj + "/li/a"
        href = get_attribute(pj_link, "href")
        href =~ /.*?(\d+)/
        pj_id = $1

        task_xpath = pj + "/ul/li"
        total_tasks = get_xpath_count(task_xpath)

        (1..total_tasks).each do |task_index|
          task = task_xpath + "[#{task_index}]/a"
          href = get_attribute(task, "href")
          href =~ /.*?\/(\d+)\/(\d+).*?/
          assert_equal(pu_id, $1)
          assert_equal(pj_id, $2)
        end
      end
    end
    # completed tasks
    task_area = '//div[@id="recent_task"]'
    pu_xpath = task_area + "/ul"
    total_pus = get_xpath_count(pu_xpath)
    (1..total_pus).each do |pu_index|
      pu = pu_xpath + "[#{pu_index}]"
      pu_link = pu + "/li/a"
      href = get_attribute(pu_link, 'href')
      href =~ /.*?(\d+)/
      pu_id = $1

      pj_xpath = pu + "/ul"
      total_pjs = get_xpath_count(pj_xpath)
      (1..total_pjs).each do |pj_index|
        pj = pj_xpath + "[#{pj_index}]"
        pj_link = pj + "/li/a"
        href = get_attribute(pj_link, "href")
        href =~ /.*?(\d+)/
        pj_id = $1

        task_xpath = pj + "/ul/li"
        total_tasks = get_xpath_count(task_xpath)

        (1..total_tasks).each do |task_index|
          task = task_xpath + "[#{task_index}]/a"
          href = get_attribute(task, "href")
          href =~ /.*?\/(\d+)\/(\d+).*?/
          assert_equal(pu_id, $1)
          assert_equal(pj_id, $2)
        end
      end
    end
    logout
  end

  def test_072
    login("root", "root")
    open_pu_index

    # waiting tasks
    waiting_task_area = '//div[@id="reserved_task"]'
    pj_xpath = waiting_task_area + "/ul"
    total_pjs = get_xpath_count(pj_xpath)
    (1..total_pjs).each do |pj_index|
      pj = pj_xpath + "[#{pj_index}]"
      pj_link = pj + "/li/a"
      href = get_attribute(pj_link, 'href')

      href =~ /.*?(\d+)/
      pj_id = $1
      task_xpath = pj + "/ul/li"
      total_tasks = get_xpath_count(task_xpath)
      task_ids = []
      (1..total_tasks).each do |task_index|
        task_link = task_xpath + "[#{task_index}]/a"
        href = get_attribute(task_link, 'href')
        href =~ /.*?id=(\d+)/
        task_ids << $1
      end
      # all these tasks belong to a pu, and a pj
      Task.find(:all, :conditions => {:id => task_ids}).each do |task|
        assert_equal(pj_id, task.pj_id.to_s)
      end
    end

    # analyzing tasks
    analyzing_task_area = '//div[@id="executing_task"]'
    pj_xpath = analyzing_task_area + "/ul"
    total_pjs = get_xpath_count(pj_xpath)
    (1..total_pjs).each do |pj_index|
      pj = pj_xpath + "[#{pj_index}]"
      pj_link = pj + "/li/a"
      href = get_attribute(pj_link, 'href')

      href =~ /.*?(\d+)/
      pj_id = $1
      task_xpath = pj + "/ul/li"
      total_tasks = get_xpath_count(task_xpath)
      task_ids = []
      (1..total_tasks).each do |task_index|
        task_link = task_xpath + "[#{task_index}]/a"
        href = get_attribute(task_link, 'href')
        href =~ /.*?id=(\d+)/
        task_ids << $1
      end
      # all these tasks belong to a pu, and a pj
      Task.find(:all, :conditions => {:id => task_ids}).each do |task|
        assert_equal(pj_id, task.pj_id.to_s)
      end
    end
    # completed tasks
    completed_task_area = '//div[@id="recent_task"]'
    pj_xpath = completed_task_area + "/ul"
    total_pjs = get_xpath_count(pj_xpath)
    (1..total_pjs).each do |pj_index|
      pj = pj_xpath + "[#{pj_index}]"
      pj_link = pj + "/li/a"
      href = get_attribute(pj_link, 'href')

      href =~ /.*?(\d+)/
      pj_id = $1
      task_xpath = pj + "/ul/li"
      total_tasks = get_xpath_count(task_xpath)
      task_ids = []
      (1..total_tasks).each do |task_index|
        task_link = task_xpath + "[#{task_index}]/a"
        href = get_attribute(task_link, 'href')
        href =~ /.*?id=(\d+)/
        task_ids << $1
      end
      # all these tasks belong to a pu, and a pj
      Task.find(:all, :conditions => {:id => task_ids}).each do |task|
        assert_equal(pj_id, task.pj_id.to_s)
      end
    end
    logout#
  end

  def test_073
    login("root",
          "root")
    open_pj_index
    task_ids = []
    (1..3).each do |index|
      waiting_task_link = element_locator('pj_index')['waiting'] + "[#{index}]/a"
      href = get_attribute(waiting_task_link, 'href')
      href =~ /.*?id=(\d+).*?/
      task_ids << $1

      analyzing_task_link = element_locator('pj_index')['analyzing'] + "[#{index}]/a"
      href = get_attribute(analyzing_task_link, 'href')
      href =~ /.*?id=(\d+).*?/
      task_ids << $1

      completed_task_link = element_locator('pj_index')['completed'] + "[#{index}]/a"
      href = get_attribute(completed_task_link, 'href')
      href =~ /.*?id=(\d+).*?/
      task_ids << $1
    end

    # all tasks belong to this pj
    Task.find(:all, :conditions => {:id => task_ids}).each do |task|
      assert_equal(PJ_ID, task.pj_id)
    end
    logout
  end

  def test_074
    login("root",
          "root")
    # misc
    ## waiting tasks
    task_ids = []
    (1..3).each do |index|
      waiting_task_link = element_locator('misc')['waiting'] + "[#{index}]/a"
      href = get_attribute(waiting_task_link, 'href')
      href =~ /.*?id=(\d+).*?/
      task_ids << $1
    end
    ## all these tasks are waiting tasks
    Task.find(:all, :conditions => {:id => task_ids}).each do |task|
      assert_equal(1, task.task_state_id)
    end

    ## analyzing tasks
    task_ids = []
    (1..3).each do |index|
      analyzing_task_link = element_locator('misc')['analyzing'] + "[#{index}]/a"
      href = get_attribute(analyzing_task_link, 'href')
      href =~ /.*?id=(\d+).*?/
      task_ids << $1
    end
    ## all these tasks are analyzing tasks
    Task.find(:all, :conditions => {:id => task_ids}).each do |task|
      assert_equal(2, task.task_state_id)
    end

    ## completed tasks
    task_ids = []
    (1..3).each do |index|
      completed_task_link = element_locator('misc')['completed'] + "[#{index}]/a"
      href = get_attribute(completed_task_link, 'href')
      href =~ /.*?id=(\d+).*?/
      task_ids << $1
    end
    ## all these tasks are complete tasks
    Task.find(:all, :conditions => {:id => task_ids}).each do |task|
      assert_equal(5, task.task_state_id)
    end
    ##########################################################################
    # pu_index
    open_pu_index
    ## waiting tasks
    task_ids = []
    (1..3).each do |index|
      waiting_task_link = element_locator('pu_index')['waiting'] + "[#{index}]/a"
      href = get_attribute(waiting_task_link, 'href')
      href =~ /.*?id=(\d+).*?/
      task_ids << $1
    end
    ## all these tasks are waiting tasks
    Task.find(:all, :conditions => {:id => task_ids}).each do |task|
      assert_equal(1, task.task_state_id)
    end

    ## analyzing tasks
    task_ids = []
    (1..3).each do |index|
      analyzing_task_link = element_locator('pu_index')['analyzing'] + "[#{index}]/a"
      href = get_attribute(analyzing_task_link, 'href')
      href =~ /.*?id=(\d+).*?/
      task_ids << $1
    end
    ## all these tasks are analyzing tasks
    Task.find(:all, :conditions => {:id => task_ids}).each do |task|
      assert_equal(2, task.task_state_id)
    end

    ## completed tasks
    task_ids = []
    (1..3).each do |index|
      completed_task_link = element_locator('pu_index')['completed'] + "[#{index}]/a"
      href = get_attribute(completed_task_link, 'href')
      href =~ /.*?id=(\d+).*?/
      task_ids << $1
    end
    ## all these tasks are complete tasks
    Task.find(:all, :conditions => {:id => task_ids}).each do |task|
      assert_equal(5, task.task_state_id)
    end

    #########################################################################
    # pj_index
    open_pj_index
    ## waiting tasks
    task_ids = []
    (1..3).each do |index|
      waiting_task_link = element_locator('pj_index')['waiting'] + "[#{index}]/a"
      href = get_attribute(waiting_task_link, 'href')
      href =~ /.*?id=(\d+).*?/
      task_ids << $1
    end
    ## all these tasks are waiting tasks
    Task.find(:all, :conditions => {:id => task_ids}).each do |task|
      assert_equal(1, task.task_state_id)
    end

    ## analyzing tasks
    task_ids = []
    (1..3).each do |index|
      analyzing_task_link = element_locator('pj_index')['analyzing'] + "[#{index}]/a"
      href = get_attribute(analyzing_task_link, 'href')
      href =~ /.*?id=(\d+).*?/
      task_ids << $1
    end
    ## all these tasks are analyzing tasks
    Task.find(:all, :conditions => {:id => task_ids}).each do |task|
      assert_equal(2, task.task_state_id)
    end

    ## completed tasks
    task_ids = []
    (1..3).each do |index|
      completed_task_link = element_locator('pj_index')['completed'] + "[#{index}]/a"
      href = get_attribute(completed_task_link, 'href')
      href =~ /.*?id=(\d+).*?/
      task_ids << $1
    end
    ## all these tasks are complete tasks
    Task.find(:all, :conditions => {:id => task_ids}).each do |task|
      assert_equal(5, task.task_state_id)
    end

    logout
  end
end
