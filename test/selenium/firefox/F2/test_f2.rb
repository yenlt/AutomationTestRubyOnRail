require File.dirname(__FILE__) + "/test_f2_setup" unless defined? TestF2Setup
  MASTER_LOCATION3 =  "/report.tar.gz"
class TestF2 < Test::Unit::TestCase

  include TestF2Setup
  fixtures :pus , :pjs , :tasks
  @@pu = 0
  @@pj = 0
  @@task = 0
  ## Setup
  def setup
    @verification_errors = []
    if $lang == "en"
      @overall = "Overall Analyze"
      @individual= "Individual Analyze"
    elsif $lang == "ja"
      @overall = "全体解析"
      @individual = "個人解析"
    end
    if $selenium
      @selenium = $selenium
    else
      @selenium = Selenium::SeleniumDriver.new(SELENIUM_CONFIG)
      @selenium.start
    end
  end

  def teardown
    @selenium.stop unless $selenium
    assert_equal [], @verification_errors
    write_log
  end
  # F-001
  # Task type: Individual analysis.
  # "Registration of analysis task" page "Master" tab.
  def test_001

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #        #Find a PU
    #Pu created
    pu_name = 'pu'
    register_pu(pu_name)
    @@pu = Pu.find(:last)
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)
    pj_name = 'pj'
    register_pj(pj_name)
    @@pj = Pj.find(:last)
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #   test for individual analysis task
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #    #The contents of a display of a "master" tab become
    # a thing for individual analysis task registration.
    click $xpath["task"]["main_area_td4"]
    wait_for_page_to_load "30000"
    assert is_text_present(_("Registration of an Analysis Task"))
    #    select analyze type: 個人解析
    select "analyze_type", "label=#{@individual}"
    #Click Master tab
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }

    @@pu.destroy
    #  logout
    logout

  end

  # F-002
  # Task type: Individual analysis.
  # "Registration of analysis task" page "Master" tab.
  def test_002

    #  login
    login
    @@pu = 1
    @@pj = 1
    open"/devgroup/pj_index/#{@@pu}/#{@@pj}"
    wait_for_page_to_load "30000"

    #   test for individual analysis task
    open("/task/index2/#{@@pu}/#{@@pj}")
    #The contents of a display of a "master" tab become
    # a thing for individual analysis task registration.
    click $xpath["task"]["main_area_td4"]
    wait_for_page_to_load "30000"
    assert is_text_present(_("Registration of an Analysis Task"))
    #    select analyze type: 個人解析
    select "analyze_type", "label=#{@individual}"
    #Click Master tab
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    #Select "uploading a file individually"
    click "file_upload_upload_way_upload_each"
    assert is_text_present(_("Uploaded individually."))
    click $xpath["task"]["read_tree"]

    assert !60.times{ break if (is_text_present(_("Directory structure")) rescue false); sleep 2 }
    #  logout
    logout

  end
  # F-003
  # Task type: Individual analysis.
  # "Registration of analysis task" page "Master" tab.
  def test_003

    #  login
    login
    @@pu = 1
    @@pj = 1
    open"/devgroup/pj_index/#{@@pu}/#{@@pj}"
    wait_for_page_to_load "30000"

    #   test for individual analysis task
    open("/task/index2/#{@@pu}/#{@@pj}")
    #The contents of a display of a "master" tab become
    # a thing for individual analysis task registration.
    click $xpath["task"]["main_area_td4"]
    wait_for_page_to_load "30000"
    assert is_text_present(_("Registration of an Analysis Task"))
    #    select analyze type: 個人解析
    select "analyze_type", "label=#{@individual}"
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    #    select uploading method in the master tab
    assert is_text_present(_("Select a master"))
    assert is_text_present(_("Master"))
    assert is_text_present(_("Select the upload method of individual analysis files"))
    assert is_text_present(_("Upload of individual analysis files"))

    #Select "uploading a file individually"
    click "file_upload_upload_way_upload_each"
    assert is_text_present(_("Uploaded individually."))
    #Click button Read tree
    click $xpath["task"]["read_tree"]
    assert !60.times{ break if (is_text_present(_("Directory structure")) rescue false); sleep 2 }
    #It will return, if a check is returned for uploading collectively (F2-003)
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    #  logout
    logout

  end
  # F-004
  # Task type: Whole analysis.
  # "Registration of analysis task" page "Master" tab.
  def test_004

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #        #Find a PU
    #Pu created
    pu_name = 'pu'
    register_pu(pu_name)
    @@pu = Pu.find(:last)
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)
    pj_name = 'pj'
    register_pj(pj_name)
    @@pj = Pj.find(:last)
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #   test for individual analysis task
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #The contents of a display of a "master" tab become
    # a thing for individual analysis task registration.
    click $xpath["task"]["main_area_td4"]
    wait_for_page_to_load "30000"
    assert is_text_present(_("Registration of an Analysis Task"))
    #    select analyze type: 全体解析 (Analysis of all)
    select "analyze_type", "label=#{@overall}"
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    #There is no display below "selection of the upload method of an individual analysis file."
    assert !is_text_present(_("Select the upload method of individual analysis files"))

    @@pu.destroy
    #  logout
    logout

  end
  # F-005
  # Task type: Individual analysis.
  # "Registration of analysis task" page "Master" tab.
  def test_005

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #        #Find a PU
    #Pu created
    pu_name = 'pu'
    register_pu(pu_name)
    @@pu = Pu.find(:last)
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)
    pj_name = 'pj'
    register_pj(pj_name)
    @@pj = Pj.find(:last)
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #   test for individual analysis task
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #The contents of a display of a "master" tab become
    # a thing for individual analysis task registration.
    click $xpath["task"]["main_area_td4"]
    wait_for_page_to_load "30000"
    assert is_text_present(_("Registration of an Analysis Task"))
    #    select analyze type: 個人解析
    select "analyze_type", "label=#{@individual}"
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    #    Below "selection of the upload method of an individual analysis file" is displayed.
    assert is_text_present(_("Select a master"))
    assert is_text_present(_("Master"))
    assert is_text_present(_("Select the upload method of individual analysis files"))
    assert is_text_present(_("Upload of individual analysis files"))

    @@pu.destroy
    #  logout
    logout

  end
  # F-006
  # Task type: Individual analysis.
  # "Registration of analysis task" page "Master" tab.
  def test_006

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #A task type is changed into "individual analysis"
    # with a "general control" tab.
    click $xpath["task"]["main_area_td4"]
    wait_for_page_to_load "30000"
    assert is_text_present(_("Registration of an Analysis Task"))
    #    select analyze type: 個人解析 (Individual Analysis)
    select "analyze_type", "label=#{@individual}"
    #Click Master tab
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    assert is_text_present("qac")
    #An option setup of "master: A qac" subwindow is displayed.
    click $xpath["task"]["option_setup_link"]
    # click "link=設定する"
    sleep 3
    #    #wait for loading page
    wait_for_condition("Ajax.Request","30000")

    assert !60.times{ break if (@selenium.is_text_present(_("Optional setting")+":qac") rescue false); sleep 2 }
    sleep 2

    #  logout
    logout

  end

  # F-007
  # Task type: Individual analysis.
  # "Registration of analysis task" page with master is null.
  def test_007

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU
    @@pu = Pu.find_by_name('SamplePU1')

    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)
    @@pj = Pj.find_by_name('SamplePJ1')

    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    # test master of PJ is not registered
    assert is_text_present(_("Details of an analysis task"))
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }

    click $xpath["task"]["general_control_tab"]
    assert !60.times{ break if (is_text_present(_("Basic Setting")) rescue false); sleep 2 }
    sleep 3
    select "analyze_type", "label=#{@individual}"
    sleep 3
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    #    test for value of master into combobox in master tab
    assert_equal ["sample_c_cpp"], get_select_options("master_id")
    assert is_text_present(_("Optional setting"))
    #    click link setup QAC
    assert is_text_present("qac")
    sleep 3
    click $xpath["task"]["option_setup_link"]
    #    check log in the navigation bar
    assert !60.times{ break if (is_text_present(_("It returns to the state before a save.")) rescue false); sleep 2 }
    #    click link setup QAC++
    assert is_text_present("qacpp")
    sleep 3
    click $xpath["task"]["option_setup_link2"]
    sleep 2
    #    check log in the navigation bar
    assert !60.times{ break if (is_text_present(_("It returns to the state before a save.")) rescue false); sleep 2 }


    #  logout
    logout

  end
  # F-008
  # Task type: Individual analysis.
  # "Registration of analysis task" page with master is null.
  def test_008

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)
    @@pj = Pj.find_by_name('SamplePJ1')#
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    # test master of PJ is not registered
    assert is_text_present(_("Details of an analysis task"))
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }

    click $xpath["task"]["general_control_tab"]
    assert !60.times{ break if (is_text_present(_("Basic Setting")) rescue false); sleep 2 }
    sleep 3
    select "analyze_type", "label=#{@individual}"
    sleep 3
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }

    #    test for value of master into combobox in master tab
    assert_equal ["sample_c_cpp"], get_select_options("master_id")
    assert is_text_present(_("Optional setting"))

    click $xpath["task"]["registration_task_button"]
    sleep 2
    #assert !60.times{ break if (is_text_present("解析ツール未選択  入力内容に問題があるためタスクを登録できません。") rescue false); sleep 2 }


    #  logout
    logout

  end

  # F-009
  # Task type: Individual analysis.
  # "Registration of analysis task" page.
  def test_009

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU
    #Pu created

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    # test master of PJ is not registered
    assert is_text_present(_("Details of an analysis task"))
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }

    click $xpath["task"]["general_control_tab"]
    assert !60.times{ break if (is_text_present(_("Basic Setting")) rescue false); sleep 2 }
    sleep 3
    select "analyze_type", "label=#{@individual}"
    sleep 3
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }

    #    click link setup QAC
    assert is_text_present("qac")
    sleep 3
    click $xpath["task"]["analyze_allow_file_link"]
    #    check log in the navigation bar
    assert !60.times{ break if (is_text_present("analyze_allow_files(qac)") rescue false); sleep 2 }
    run_script "destroy_subwindow()"
    #    click link setup QAC++
    assert is_text_present("qacpp")
    sleep 3
    click $xpath["task"]["analyze_allow_file_link2"]
    #    check log in the navigation bar
    sleep 2
    assert !60.times{ break if (is_text_present("analyze_allow_files(qacpp)") rescue false); sleep 2 }
    run_script "destroy_subwindow()"


    #  logout
    logout

  end

  # F-010
  # Task type: Individual analysis.
  # "Registration of analysis task" page with master is null.
  def test_010

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU
    #Pu created


    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    # test master of PJ is not registered
    assert is_text_present(_("Details of an analysis task"))
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }

    click $xpath["task"]["general_control_tab"]
    assert !60.times{ break if (is_text_present(_("Basic Setting")) rescue false); sleep 2 }
    sleep 3
    select "analyze_type", "label=#{@individual}"
    sleep 3
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }

    #    click link setup QAC
    assert is_text_present("qac")
    sleep 3
    click $xpath["task"]["option_setup_link"]
    #    check log in the navigation bar
    assert !60.times{ break if (is_text_present(_("It returns to the state before a save.")) rescue false); sleep 2 }
    run_script "destroy_subwindow()"


    #  logout
    logout

  end

  # F-011
  # Task type: Individual analysis.
  # "Registration of analysis task" page with master is null.
  def test_011

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU
    #Pu created

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    # test master of PJ is not registered
    assert is_text_present(_("Details of an analysis task"))
    click $xpath["task"]["main_area_td4"]
    sleep 2
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }

    click $xpath["task"]["general_control_tab"]
    assert !60.times{ break if (is_text_present(_("Basic Setting")) rescue false); sleep 2 }
    sleep 3
    select "analyze_type", "label=#{@individual}"
    sleep 3
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    #    click link setup QAC++
    assert is_text_present("qacpp")
    sleep 3
    click $xpath["task"]["option_setup_link2"]
    #    check log in the navigation bar
    sleep 2
    assert !60.times{ break if (is_text_present(_("It returns to the state before a save.")) rescue false); sleep 2 }
    run_script "destroy_subwindow()"


    #  logout
    logout

  end

  #F-012
  #Task type: Individual analysis.
  #"Registration of analysis task" page with master is null.
  def test_012

    #login
    login

    #Open PU management page
    open_pu_management_page_1

    # Find a PU
    # Pu created

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #test master of PJ is not registered
    assert is_text_present(_("Details of an analysis task"))
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }

    click $xpath["task"]["general_control_tab"]
    assert !60.times{ break if (is_text_present(_("Basic Setting")) rescue false); sleep 2 }
    sleep 3
    select "analyze_type", "label=#{@individual}"
    sleep 3
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    #test for make root in the master tab & in the popup which is displayed by clicking 設定する
    # click link setup QAC
    assert is_text_present("qac")
    sleep 3
    click $xpath["task"]["option_setup_link"]
    #test for make root
    type "makeroot_qac", "abc"
    run_script "destroy_subwindow()"
    assert is_text_present(_("Make root")+":")
    click $xpath["task"]["option_setup_link"]
    sleep 2
    #wait for loading page
    wait_for_condition("Ajax.Request","30000")
    sleep 3
    assert !60.times{ break if (@selenium.is_text_present(_("Optional setting")+":qac") rescue false); sleep 2 }
    type "makeroot_qac", "abc"
    click $xpath["task"]["back_to_reflect_the_changes"]
    sleep 2
    assert is_text_present(_("Make root")+":")
    click $xpath["task"]["option_setup_link"]
    assert !60.times{ break if (@selenium.is_text_present(_("Optional setting")+":qac") rescue false); sleep 2 }



    #logout
    logout

  end

  # F-013
  # Task type: Individual analysis.
  #The maximize button at the upper right of a subwindow is clicked.
  def test_013

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }
    #Master tab
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    assert is_text_present("qac")
    sleep 3
    #Click link set of qac
    click  $xpath["task"]["set_qac_link"]

    sleep 3
    #wait for loading page
    wait_for_condition("Ajax.Request","30000")


    #Get window id
    window_id      = get_attribute("//body/div[2]", "id")
    window_id        =~ /.*?id=(\d+).*?/

    #Maximize window
    click window_id + "_maximize"

    sleep 3

    run_script "destroy_subwindow()"


    #  logout
    logout

  end

  # F-014
  # Task type: Individual analysis.
  #The deletion button at the upper right of a subwindow is clicked.
  def test_014

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }
    #Master tab
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    assert is_text_present("qac")
    sleep 3
    #Click link set of qac
    click  $xpath["task"]["set_qac_link"]

    sleep 3
    #wait for loading page
    wait_for_condition("Ajax.Request","30000")


    #Get window id
    window_id      = get_attribute("//body/div[2]", "id")
    window_id        =~ /.*?id=(\d+).*?/

    #Maximize window
    click window_id + "_close"

    sleep 3

    run_script "destroy_subwindow()"


    #  logout
    logout

  end

  # F-015
  # Task type: Individual analysis.
  #An option setup was performed once [ at least ] and the information set remains.
  def test_015

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }
    #Master tab
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    assert is_text_present("qac")
    sleep 3
    #Click link set of qac
    click  $xpath["task"]["set_qac_link"]

    sleep 3
    #wait for loading page
    wait_for_condition("Ajax.Request","30000")
    #An option setup was performed

    assert is_checked($xpath["task"]["master_option_chk1"])

    #uncheck an option setup
    click $xpath["task"]["master_option_chk1"]


    #Get window id
    window_id      = get_attribute("//body/div[2]", "id")
    window_id        =~ /.*?id=(\d+).*?/

    #Close window
    click window_id + "_close"

    sleep 3
    #Open popup set again
    #Click link set of qac
    click  $xpath["task"]["set_qac_link"]

    sleep 3
    #wait for loading page
    wait_for_condition("Ajax.Request","30000")
    #the information set remains
    assert is_checked($xpath["task"]["master_option_chk1"])

    run_script "destroy_subwindow()"


    #  logout
    logout

  end

  # F-016
  # Task type: Individual analysis.
  #A check is removed from the check box of a directory.
  def test_016

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }
    #Master tab
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    assert is_text_present("qac")
    sleep 3
    #Click link set of qac
    click  $xpath["task"]["set_qac_link"]

    sleep 3
    #wait for loading page
    wait_for_condition("Ajax.Request","30000")
    #An option setup was performed

    assert is_checked($xpath["task"]["master_option_chk2"])

    #uncheck an option setup of a directory.
    click $xpath["task"]["master_option_chk2"]
    sleep 3

    #Click a directory link
    click $xpath["task"]["master_option_dir1"]
    sleep 2
    assert !is_checked($xpath["task"]["master_option_chk3"])
    assert !is_checked($xpath["task"]["master_option_chk4"])


    run_script "destroy_subwindow()"


    #  logout
    logout

  end


  # F-017
  # Task type: Individual analysis.
  #It checks to the check box of a directory.
  def test_017

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }
    #Master tab
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    assert is_text_present("qac")
    sleep 3
    #Click link set of qac
    click  $xpath["task"]["set_qac_link"]

    sleep 3
    #wait for loading page
    wait_for_condition("Ajax.Request","30000")
    #An option is checked
    assert is_checked($xpath["task"]["master_option_chk2"])
    #Click a directory link
    click $xpath["task"]["master_option_dir1"]
    sleep 2
    #All file of directory is checked.

    assert is_checked($xpath["task"]["master_option_chk3"])
    assert is_checked($xpath["task"]["master_option_chk4"])


    run_script "destroy_subwindow()"


    #  logout
    logout

  end

  # F-018
  # Task type: Individual analysis.
  #A check is removed from the check box of a file.
  def test_018

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }
    #Master tab
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    assert is_text_present("qac")
    sleep 3
    #Click link set of qac
    click  $xpath["task"]["set_qac_link"]

    sleep 3
    #wait for loading page
    wait_for_condition("Ajax.Request","30000")
    #An option is checked
    assert is_checked($xpath["task"]["master_option_chk2"])
    #Click a directory link
    click $xpath["task"]["master_option_dir1"]
    sleep 2
    #Click a sub directory link
    click $xpath["task"]["master_option_file1"]
    sleep 2
    #uncheck a file

    click $xpath["task"]["master_option_chk5"]
    sleep 2

    #The state of other check boxes is not influenced.
    assert is_checked($xpath["task"]["master_option_chk6"])

    run_script "destroy_subwindow()"


    #  logout
    logout

  end


  # F-019
  # Task type: Individual analysis.
  #The link [M] displayed on the right-hand side of a directory is clicked.
  #Any [M] may be sufficient.
  def test_019

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }
    #Master tab
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    assert is_text_present("qac")
    sleep 3
    #Click link set of qac
    click  $xpath["task"]["set_qac_link"]

    sleep 3
    #wait for loading page
    wait_for_condition("Ajax.Request","30000")

    #Click link M of a directory
    click $xpath["task"]["m_link"]
    sleep 2

    #The name of the directory which pushed [M] goes into the field of right-hand side make_root.
    assert_equal "sample_c/", get_value( $xpath["task"]["make_root_link"])

    run_script "destroy_subwindow()"


    #  logout
    logout

  end

  # F-020
  # Task type: Individual analysis.
  #1. Change a check and except [ its ] into the state
  #where it does not check to the directory/file made into an analytical object.
  #2. Set Make_root as a suitable directory.
  #3. The button "which returns reflecting change" is clicked.
  def test_020

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }
    #Master tab
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    assert is_text_present("qac")
    sleep 3
    #Click link set of qac
    click  $xpath["task"]["set_qac_link"]

    sleep 3
    #wait for loading page
    wait_for_condition("Ajax.Request","30000")

    #uncheck an option setup of a directory.
    click $xpath["task"]["master_option_chk2"]
    sleep 3

    #Set Make_root as a suitable directory.
    type "option_makeroot", "public/"

    #The button "which returns reflecting change" is clicked.
    click $xpath["task"]["back_to_reflect_the_changes"]

    #A subwindow carries out fade-out and closes.

    run_script "destroy_subwindow()"


    #  logout
    logout

  end

  # F-021
  # Task type: Individual analysis.
  #1. Change a check and except [ its ] into the state
  #where it does not check to the directory/file made into an analytical object.
  #2. Set Make_root as a suitable directory.
  #3. The button "which returns reflecting change" is clicked.
  def test_021

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }
    #Master tab
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    assert is_text_present("qac")
    sleep 3
    #Click link set of qac
    click  $xpath["task"]["set_qac_link"]

    sleep 3
    #wait for loading page
    wait_for_condition("Ajax.Request","30000")

    #uncheck an option setup of a directory.
    click $xpath["task"]["master_option_chk2"]
    sleep 3

    #Set Make_root as a suitable directory.
    type "option_makeroot", "public/"

    #The button "which returns reflecting change" is clicked.
    click $xpath["task"]["back_to_reflect_the_changes"]
    sleep 3

    #An option setup of the target tool is changed.
    assert is_text_present(_("Make root")+":")

    #  logout
    logout

  end

  # F-022
  # Task type: Individual analysis.
  #1. Change a check and except [ its ] into the state
  #where it does not check to the directory/file made into an analytical object.
  #2. Set Make_root as a suitable directory.
  #3. The button "which returns reflecting change" is clicked.
  def test_022

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }
    #Master tab
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    assert is_text_present("qac")
    sleep 3
    #Click link set of qac
    click  $xpath["task"]["set_qac_link"]

    sleep 3
    #wait for loading page
    wait_for_condition("Ajax.Request","30000")

    #uncheck an option setup of a directory.
    click $xpath["task"]["master_option_chk2"]
    sleep 3

    #Set Make_root as a suitable directory.
    type "option_makeroot", "public/"

    #The button "which returns reflecting change" is clicked.
    click $xpath["task"]["back_to_reflect_the_changes"]
    sleep 3

    #An option setup of the target tool is changed.
    assert is_text_present(_("Make root")+":")

    #The Make root directory set as the make_root field enters.
    assert_equal "public/", get_value($xpath["task"]["make_root_main_link"])

    #  logout
    logout

  end

  # F-023
  # Task type: Individual analysis.
  #1. Change a check and except [ its ] into the state
  #where it does not check to the directory/file made into an analytical object.
  #2. Set Make_root as a suitable directory.
  #3. The button "which returns reflecting change" is clicked.
  def test_023

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }
    #Master tab
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    assert is_text_present("qac")
    sleep 3
    #Click link set of qac
    click  $xpath["task"]["set_qac_link"]

    sleep 3
    #wait for loading page
    wait_for_condition("Ajax.Request","30000")

    #uncheck an option setup of a directory.
    click $xpath["task"]["master_option_chk2"]
    sleep 3

    #Set Make_root as a suitable directory.
    type "option_makeroot", "public/"

    #The button "which returns reflecting change" is clicked.
    click $xpath["task"]["back_to_reflect_the_changes"]
    sleep 3

    #An option setup of the target tool is changed.
    assert is_text_present(_("Make root")+":")

    #The Make root directory set as the make_root field enters.
    assert_equal "public/", get_value($xpath["task"]["make_root_main_link"])

    #The directory/file names which were being changed into the check state
    #at the information dialog which clicks analyze_allow_files
    #and comes out are enumerated.
    click $xpath["task"]["analyze_allow_file_link"]
    sleep 3

    assert !is_text_present("sample_c/Makefile")

    #  logout
    logout

  end

  # F-024
  # Task type: Individual analysis.
  #1. Change a check and except [ its ] into the state
  #where it does not check to the directory/file made into an analytical object.
  #2. Set Make_root as a suitable directory.
  #3. The button "which returns reflecting change" is clicked.
  def test_024

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }
    #Master tab
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    assert is_text_present("qac")
    sleep 3
    #Click link set of qac
    click  $xpath["task"]["set_qac_link"]

    sleep 3
    #wait for loading page
    wait_for_condition("Ajax.Request","30000")

    #uncheck an option setup of a directory.
    click $xpath["task"]["master_option_chk2"]
    sleep 3

    #Set Make_root as a suitable directory.
    type "option_makeroot", "public/"

    #The button "which returns reflecting change" is clicked.
    click $xpath["task"]["back_to_reflect_the_changes"]
    sleep 3

    #An option setup of the target tool is changed.
    assert is_text_present(_("Make root")+":")

    #The Make root directory set as the make_root field enters.
    assert_equal "public/", get_value($xpath["task"]["make_root_main_link"])

    #The directory/file names which were being changed into the state
    #where it does not check at the information dialog
    #which clicks analyze_deny_files and comes out are enumerated.

    click $xpath["task"]["analyze_deny_files"]
    sleep 3

    assert is_text_present("sample_c/Makefile")


    #  logout
    logout

  end

  # F-025
  # Task type: Individual analysis.
  #1. Change a check and except [ its ] into the state
  #where it does not check to the directory/file made into an analytical object.
  #2. Set Make_root as a suitable directory.
  #3. The button "which returns reflecting change" is clicked.
  #4. After Option Setup, Move Tab and it Returns Again.
  def test_025

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }
    #Master tab
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }
    assert is_text_present("qac")
    sleep 3
    #Click link set of qac
    click  $xpath["task"]["set_qac_link"]

    sleep 3
    #wait for loading page
    wait_for_condition("Ajax.Request","30000")

    #uncheck an option setup of a directory.
    click $xpath["task"]["master_option_chk2"]
    sleep 3

    #Set Make_root as a suitable directory.
    type "option_makeroot", "public/"

    #The button "which returns reflecting change" is clicked.
    click $xpath["task"]["back_to_reflect_the_changes"]
    sleep 3

    #An option setup of the target tool is changed.
    assert is_text_present(_("Make root")+":")

    #The Make root directory set as the make_root field enters.
    assert_equal "public/", get_value($xpath["task"]["make_root_main_link"])

    #Move to general control tab
    click $xpath["task"]["general_control_tab"]

    #The information set does not disappear and remains.
    assert_equal "public/", get_value($xpath["task"]["make_root_main_link"])

    #  logout
    logout

  end

  # F-026
  # Task type: Individual analysis.
  #1. Set Analysis Type as Individual Analysis.
  #2. Change Tab into "Master."
  #3. Bundle Up by Selection of the Upload Method of an Individual Analysis File, and Choose Upload する.
  #4. An upload button is clicked after specifying a tar.gz file by reference.
  def test_026

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }

    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }

    #Select "uploading at once"
    type "file_upload_uploaded_master", MASTER_LOCATION3
    click "upload_once_btn"
    assert !60.times{ break if (is_text_present(_("Package upload of the individual analysis file was carried out.")) rescue false); sleep 2 }
    sleep 3

    # Upload to DB of the specified file is performed
    # and the message of "having carried out package upload of the individual analysis file" is displayed on a log viewing area.
    #The file name uploaded again on ID of the master uploaded
    #to ID text field of the upload field and its right is displayed.

    assert_equal "report.tar.gz", get_value($xpath["task"]["upload_once_name"])

    #  logout
    logout

  end

  # F-027
  # Task type: Individual analysis.
  #1. Set Analysis Type as Individual Analysis.
  #2. Change Tab into "Master."
  #3. Bundle Up by Selection of the Upload Method of an Individual Analysis File, and Choose Upload する.
  #4. An upload button is clicked after specifying a tar.gz file by reference.
  #5. Register Analysis Task after Necessary Minimum Setup.
  def test_027

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }

    #Create a new task
    type "task_name", "sample_Task"
    click $xpath["task"]["tool_qac"]
    click $xpath["task"]["high_qac"]

    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    #Set default for high qac tool
    click $xpath["task"]["selected_high_rule"]

    #wait for loading page
    wait_for_condition("Ajax.Request","30000")
    sleep 3
    #    #click "//input[@id='checked_rules[]']"
    click "//input[@value='#{_('Check All Rules in This Page')}']"

    #Register a new task
    click $xpath["task"]["register_task"]
    sleep 2

    #Move to Setup tab
    click $xpath["task"]["execution_setup_tab"]
    assert !60.times{ break if (is_text_present(_("Executing Setting")) rescue false); sleep 2 }
    click $xpath["task"]["save_setting_btn"]
    assert !60.times{ break if (is_text_present(_("Execution setting was updated.")) rescue false); sleep 2 }

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }

    #Select "uploading at once"
    type "file_upload_uploaded_master", MASTER_LOCATION3
    click "upload_once_btn"
    assert !60.times{ break if (is_text_present(_("Package upload of the individual analysis file was carried out.")) rescue false); sleep 2 }
    sleep 3

    # Upload to DB of the specified file is performed
    # and the message of "having carried out package upload of the individual analysis file" is displayed on a log viewing area.
    #The file name uploaded again on ID of the master uploaded
    #to ID text field of the upload field and its right is displayed.

    assert_equal "report.tar.gz", get_value($xpath["task"]["upload_once_name"])

    #It redirects to registration of an analysis task at the Management page
    # of a success and an analysis task.

    click "confirm_task_btn"
    sleep 3
    #Analysis task management.
    #Get window id
    window_id      = get_attribute("//body/div[1]", "id")
    window_id        =~ /.*?id=(\d+).*?/

    #Maximize window
    div_link_id= window_id + "_content"
    div_link = "//div[@id='" + div_link_id +"']"
    register_link= div_link + "/div[@id='confirmation_window']/input[@value='#{_('Register')}']"

    click register_link #$xpath["task"]["register_task"]

    assert !60.times{ break if (is_text_present(_("Analysis Task Administration")) rescue false); sleep 2 }

    task = Task.find(:last)
    task.destroy()

    #  logout
    logout

  end

  # F-028
  # Task type: Individual analysis.
  #1. Set Analysis Type as Individual Analysis.
  #2. Change Tab into "Master."
  #3. Bundle Up by Selection of the Upload Method of an Individual Analysis File, and Choose Upload する.
  #4. An upload button is clicked after specifying a tar.gz file by reference.
  #5. Register Analysis Task after Necessary Minimum Setup.
  #6. Display Individual Analysis Task Tab and Display Detailed Information of Registered Task.
  def test_028

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }

    #Create a new task
    type "task_name", "sample_Task"
    click $xpath["task"]["tool_qac"]
    click $xpath["task"]["high_qac"]

    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    #Set default for high qac tool
    click $xpath["task"]["selected_high_rule"]

    #wait for loading page
    wait_for_condition("Ajax.Request","30000")
    sleep 3
    #    #click "//input[@id='checked_rules[]']"
    click "//input[@value='#{_('Check All Rules in This Page')}']"

    #Register a new task
    click $xpath["task"]["register_task"]
    sleep 2

    #Move to Setup tab
    click $xpath["task"]["execution_setup_tab"]
    assert !60.times{ break if (is_text_present(_("Executing Setting")) rescue false); sleep 2 }
    click $xpath["task"]["save_setting_btn"]
    assert !60.times{ break if (is_text_present(_("Execution setting was updated.")) rescue false); sleep 2 }

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }

    #Select "uploading at once"
    type "file_upload_uploaded_master", MASTER_LOCATION3
    click "upload_once_btn"
    assert !60.times{ break if (is_text_present(_("Package upload of the individual analysis file was carried out.")) rescue false); sleep 2 }
    sleep 3

    # Upload to DB of the specified file is performed
    # and the message of "having carried out package upload of the individual analysis file" is displayed on a log viewing area.
    #The file name uploaded again on ID of the master uploaded
    #to ID text field of the upload field and its right is displayed.

    assert_equal "report.tar.gz", get_value($xpath["task"]["upload_once_name"])

    #It redirects to registration of an analysis task at the Management page
    # of a success and an analysis task.

    click "confirm_task_btn"
    sleep 3
    #Analysis task management.
    #Get window id
    window_id      = get_attribute("//body/div[1]", "id")
    window_id        =~ /.*?id=(\d+).*?/

    #Maximize window
    div_link_id= window_id + "_content"
    div_link = "//div[@id='" + div_link_id +"']"
    register_link= div_link + "/div[@id='confirmation_window']/input[@value='#{_('Register')}']"

    click register_link #$xpath["task"]["register_task"]
    sleep 3

    assert !60.times{ break if (is_text_present(_("Analysis Task Administration")) rescue false); sleep 2 }
    #The details of an analysis task are displayed.
    click $xpath["task"]["individual_task_analysis"]
    sleep 5
    assert is_text_present(_("Analysis task list"))

    task = Task.find(:last)
    task.destroy()
    #  logout
    logout

  end

  # F-029
  # Task type: Individual analysis.
  #1. Set Analysis Type as Individual Analysis.
  #2. Change Tab into "Master."
  #3. Bundle Up by Selection of the Upload Method of an Individual Analysis File, and Choose Upload する.
  #4. An upload button is clicked after specifying a tar.gz file by reference.
  #5. Register Analysis Task after Necessary Minimum Setup.
  #6. Display Individual Analysis Task Tab and Display Detailed Information of Registered Task.
  def test_029

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }

    #Create a new task
    type "task_name", "sample_Task"
    click $xpath["task"]["tool_qac"]
    click $xpath["task"]["high_qac"]

    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    #Set default for high qac tool
    click $xpath["task"]["selected_high_rule"]

    #wait for loading page
    wait_for_condition("Ajax.Request","30000")
    sleep 3
    #    #click "//input[@id='checked_rules[]']"
    click "//input[@value='#{_('Check All Rules in This Page')}']"

    #Register a new task
    click $xpath["task"]["register_task"]
    sleep 2

    #Move to Setup tab
    click $xpath["task"]["execution_setup_tab"]
    assert !60.times{ break if (is_text_present(_("Executing Setting")) rescue false); sleep 2 }
    click $xpath["task"]["save_setting_btn"]
    assert !60.times{ break if (is_text_present(_("Execution setting was updated.")) rescue false); sleep 2 }

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }

    #Select "uploading at once"
    type "file_upload_uploaded_master", MASTER_LOCATION3
    click "upload_once_btn"
    assert !60.times{ break if (is_text_present(_("Package upload of the individual analysis file was carried out.")) rescue false); sleep 2 }
    sleep 3

    # Upload to DB of the specified file is performed
    # and the message of "having carried out package upload of the individual analysis file" is displayed on a log viewing area.
    #The file name uploaded again on ID of the master uploaded
    #to ID text field of the upload field and its right is displayed.

    assert_equal "report.tar.gz", get_value($xpath["task"]["upload_once_name"])

    #It redirects to registration of an analysis task at the Management page
    # of a success and an analysis task.

    click "confirm_task_btn"
    sleep 3

    #Analysis task management.
    #Get window id
    window_id      = get_attribute("//body/div[1]", "id")
    window_id        =~ /.*?id=(\d+).*?/

    #Maximize window
    div_link_id= window_id + "_content"
    div_link = "//div[@id='" + div_link_id +"']"
    register_link= div_link + "/div[@id='confirmation_window']/input[@value='#{_('Register')}']"

    click register_link

    assert !60.times{ break if (is_text_present(_("Analysis Task Administration")) rescue false); sleep 2 }

    sleep 2

    #The details of an analysis task are displayed.
    click $xpath["task"]["individual_task_analysis"]
    sleep 4
    #    test for task detail in the task management page
    wait_for_text_present(_("Analysis task list"))

    task = Task.find(:last)
    click "//tr[@id='task_id#{task.id}']"
    sleep 5
    click $xpath["task"]["task_detail"]
    sleep 2
    assert !60.times{ break if (is_text_present(_("Master Information")) rescue false); sleep 2 }
    run_script "destroy_subwindow()"

    task.destroy
    #  logout
    logout

  end

  # F-030
  # Task type: Individual analysis.
  #1. Set Analysis Type as Individual Analysis.
  #2. Change Tab into "Master."
  #3. Choose Individual Upload する for File by Selection of the Upload Method of
  #an Individual Analysis File.
  def test_030

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }

    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }

    #Select "uploading individual"
    click "file_upload_upload_way_upload_each"

    assert_equal _("Load directory tree."), get_value($xpath["task"]["read_tree_btn"])
    sleep 3


    #  logout
    logout

  end

  # F-031
  # Task type: Individual analysis.
  #1. Set Analysis Type as Individual Analysis.
  #2. Change Tab into "Master."
  #3. Choose Individual Upload する for File by Selection of the Upload Method of
  #an Individual Analysis File.
  def test_031

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }

    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }

    #Select "uploading individual"
    click "file_upload_upload_way_upload_each"

    assert_equal _("Load directory tree."), get_value($xpath["task"]["read_tree_btn"])
    sleep 3
    #An "it is reading about a tree" button is clicked
    #after choosing a master to read directory structure into by selection of a master.

    click $xpath["task"]["read_tree"]
    sleep 2
    assert !60.times{ break if (is_text_present(_("Directory structure")) rescue false); sleep 2 }

    #  logout
    logout

  end

  # F-032
  # Task type: Individual analysis.
  #1. Set Analysis Type as Individual Analysis.
  #2. Change Tab into "Master."
  #3. Choose Individual Upload する for File by Selection of the Upload Method of
  #an Individual Analysis File.
  #Each directory name (link) of directory structure is clicked.
  def test_032

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }

    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }

    #Select "uploading individual"
    click "file_upload_upload_way_upload_each"

    assert_equal _("Load directory tree."), get_value($xpath["task"]["read_tree_btn"])
    sleep 3
    #An "it is reading about a tree" button is clicked
    #after choosing a master to read directory structure into by selection of a master.

    click $xpath["task"]["read_tree"]
    sleep 2
    assert !60.times{ break if (is_text_present(_("Directory structure")) rescue false); sleep 2 }

    #Each directory name (link) of directory structure is clicked.
    click  $xpath["task"]["tree_link_1"]

    sleep 2
    # test right directory structure
    assert is_text_present(_("Replace"))


    #  logout
    logout

  end

  # F-033
  # Task type: Individual analysis.
  #1. Set Analysis Type as Individual Analysis.
  #2. Change Tab into "Master."
  #3. Choose Individual Upload する for File by Selection of the Upload Method of
  #an Individual Analysis File.
  #Each directory name (link) of directory structure is clicked.
  def test_033

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }

    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }

    #Select "uploading individual"
    click "file_upload_upload_way_upload_each"

    assert_equal _("Load directory tree."), get_value($xpath["task"]["read_tree_btn"])
    sleep 3
    #An "it is reading about a tree" button is clicked
    #after choosing a master to read directory structure into by selection of a master.

    click $xpath["task"]["read_tree"]
    sleep 2
    assert !60.times{ break if (is_text_present(_("Directory structure")) rescue false); sleep 2 }

    #Each directory name (link) of directory structure is clicked.
    click $xpath["task"]["tree_link_1"]
    # test right directory structure
    assert is_text_present(_("Replace"))
    assert is_text_present(_("Current Directory")+" : sample_c/")
    sleep 2

    #Current Directory The directory name which
    #the area written to be : moved (click) is replaced.
    click  $xpath["task"]["tree_link_2"]
    sleep 2
    assert is_text_present(_("Current Directory")+" : sample_cpp/")

    #  logout
    logout

  end

  # F-034
  # Task type: Individual analysis.
  #1. Set Analysis Type as Individual Analysis.
  #2. Change Tab into "Master."
  #3. Choose Individual Upload する for File by Selection of the Upload Method of
  #an Individual Analysis File.
  #Each directory name (link) of directory structure is clicked.
  def test_034

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }

    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }

    #Select "uploading individual"
    click "file_upload_upload_way_upload_each"

    assert_equal _("Load directory tree."), get_value($xpath["task"]["read_tree_btn"])
    sleep 3
    #An "it is reading about a tree" button is clicked
    #after choosing a master to read directory structure into by selection of a master.

    click $xpath["task"]["read_tree"]
    sleep 2
    assert !60.times{ break if (is_text_present(_("Directory structure")) rescue false); sleep 2 }

    #Each directory name (link) of directory structure is clicked.
    click $xpath["task"]["tree_link_1"]
    sleep 3

    # test right directory structure
    assert is_text_present(_("Replace"))

    #The file [ directly under ] of the directory is displayed in a list
    #on replacement of a right-hand side file.
    #click "//div[@id='directory_tree_area']/ul[@id='l1p0n1']/ul=[@id='l2p2n1']/li[1]/a"
    click "link=src/"
    sleep 2

    assert is_text_present("analyzeme.c")
    assert is_text_present("Makefile")
    assert is_text_present("common.c")

    #  logout
    logout

  end

  # F-035
  # Task type: Individual analysis.
  #1. Set Analysis Type as Individual Analysis.
  #2. Change Tab into "Master."
  #3. Choose Individual Upload する for File by Selection of the Upload Method of
  #an Individual Analysis File.
  #Each directory name (link) of directory structure is clicked.
  def test_035

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }

    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }

    #Select "uploading individual"
    click "file_upload_upload_way_upload_each"

    assert_equal _("Load directory tree."), get_value($xpath["task"]["read_tree_btn"])
    sleep 3
    #An "it is reading about a tree" button is clicked
    #after choosing a master to read directory structure into by selection of a master.

    click $xpath["task"]["read_tree"]
    sleep 2
    assert !60.times{ break if (is_text_present(_("Directory structure")) rescue false); sleep 2 }

    #Each directory name (link) of directory structure is clicked.
    click $xpath["task"]["tree_link_1"]

    sleep 2
    # test right directory structure
    assert is_text_present(_("Replace"))
    #The file [ directly under ] of the directory is displayed in a list
    #on replacement of a right-hand side file.
    #click "//div[@id='directory_tree_area']/ul[@id='l1p0n1']/ul=[@id='l2p2n1']/li[1]/a"
    click "link=src/"
    sleep 2
    assert is_text_present("analyzeme.c")
    assert is_text_present("Makefile")
    assert is_text_present("common.c")

    #The file displayed in a list has the "reference" field for upload,
    #and a check box for deletion directions, respectively.

    assert !is_checked($xpath["task"]["tree_chk_1"])

    click $xpath["task"]["tree_chk_1"]

    assert is_checked($xpath["task"]["tree_chk_1"])

    #  logout
    logout

  end


  # F-036
  # Task type: Individual analysis.
  #1. Set Analysis Type as Individual Analysis.
  #2. Change Tab into "Master."
  #3. Choose Individual Upload する for File by Selection of the Upload Method of
  #an Individual Analysis File.
  #Each directory name (link) of directory structure is clicked.
  def test_036
    system "rake db:fixtures:load"
    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    sleep 2
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 2 }

    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 2 }

    #Select "uploading individual"
    click "file_upload_upload_way_upload_each"

    assert_equal _("Load directory tree."), get_value($xpath["task"]["read_tree_btn"])
    sleep 3
    #An "it is reading about a tree" button is clicked
    #after choosing a master to read directory structure into by selection of a master.

    click $xpath["task"]["read_tree"]
    sleep 2
    assert !60.times{ break if (is_text_present(_("Directory structure")) rescue false); sleep 2}

    #Each directory name (link) of directory structure is clicked.
    click  $xpath["task"]["tree_link_1"]

    sleep 2
    # test right directory structure
    assert is_text_present(_("Replace"))
    #The file [ directly under ] of the directory is displayed in a list
    #on replacement of a right-hand side file.
    #click "//div[@id='directory_tree_area']/ul[@id='l1p0n1']/ul=[@id='l2p2n1']/li[1]/a"
    click "link=src/"
    sleep 2
    assert is_text_present("analyzeme.c")
    assert is_text_present("Makefile")
    assert is_text_present("common.c")

    sleep 3

    #Initial state,File name < -It has become.
    #Replace file
    input_id      = get_attribute($xpath["task"]["input_field_id_1"], "id")
    type input_id , MASTER_LOCATION3
    click "upload"
    wait_for_text_present("analyzeme.c << report.tar.gz")

    #Remove file
    click $xpath["task"]["tree_chk_1"]
    click "upload"
    wait_for_text_present("analyzeme.c << - ")

    #  logout
    logout

  end
end
