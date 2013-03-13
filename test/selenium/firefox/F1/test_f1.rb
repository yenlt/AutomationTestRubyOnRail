require File.dirname(__FILE__) + "/test_f1_setup" unless defined? TestF1Setup

class TestF1 < Test::Unit::TestCase
  include TestF1Setup
  fixtures :pus , :pjs , :tasks
  @@pu = 0
  @@pj = 0
  @@task = 0
  ## Setup
  def setup
    @verification_errors = []
	if $lang == "en"
    		@individual = "Individual Analyze"
	else 
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
  # The registration page of an analysis task.
  # "Registration of task" link is clicked from an analysis task management page,
  #  and it moves to the registration page of an analysis task.
  def test_001

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU
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

    #   A page is displayed normally. It becomes like the right.
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    # test display of Task registration
    assert is_text_present(_("Details of an analysis task"))
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 1 }

    @@pu.destroy
    #  logout
    logout

  end

  # F-002
  # The registration page of an analysis task.
  # "Registration of analysis task" page is displayed.

  def test_002

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU
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

    #   A page is displayed normally. It becomes like the right.
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    # test display of Task registration
    assert is_text_present(_("Details of an analysis task"))
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 1 }
    # The tab which can be chosen is three kinds, a "general control",
    #  "an execution setup", and "registration of a master."
    #General control
    assert is_text_present(_("Basic Setting"))
    #An execution setup
    assert is_text_present(_("Analysis Tool Setting"))
    #Registration of a master
    assert is_text_present(_("Master"))

    @@pu.destroy
    #  logout
    logout

  end

  # F-003
  # The registration page of an analysis task.
  # "Registration of analysis task" page is displayed,
  #with condition: The master registered into the object PJ is 0.

  def test_003

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU
    #Pu created
    pu_name = 'pu_last'
    register_pu(pu_name)
    sleep 2
    @@pu = Pu.find(:last)
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)
    pj_name = 'last_pj'
    register_pj(pj_name)
    sleep 2
    @@pj = Pj.find(:last)
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    # The master registered into the object PJ is 0
    wait_for_text_present("PJ: #{pj_name}")
    click  $xpath["task"]["master_control"]
    assert !60.times{ break if (is_text_present(_("A master is unregistered.")) rescue false); sleep 1 }
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    wait_for_text_present(_("Details of an analysis task"))
    click $xpath["task"]["main_area_td4"]

    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 1 }
    #A click of each tab will change the contents of a display to the thing according to a tab.
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 1 }
    assert is_text_present(_("Master"))
    #The master registered into the object PJ is 0.
    assert_equal [""], get_select_options("master_id")
    #General control tab

    click $xpath["task"]["general_control_tab"]
    assert !60.times{ break if (is_text_present(_("Basic Setting")) rescue false); sleep 1 }
    sleep 3

    #Execution setup tab
    click $xpath["task"]["execution_setup_tab"]
    assert !60.times{ break if (is_text_present(_("Executing Setting")) rescue false); sleep 1 }

    #Master tab
    click $xpath["task"]["master_tab"]
    sleep 3
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 1 }

    @@pu.destroy
    #  logout
    logout

  end
  # F-004
  # The registration page of an analysis task.
  # "Registration of analysis task" page is displayed with no condition

  def test_004

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

    # The master registered into the object PJ is 0
    assert is_text_present("PJ: SamplePJ1")
    click  $xpath["task"]["master_control"]
    assert !60.times{ break if (is_text_present(_("Master Administration")) rescue false); sleep 1 }
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    assert is_text_present(_("Details of an analysis task"))
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 1 }
    #A click of each tab will change the contents of a display to the thing according to a tab.
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 1 }
    assert is_text_present(_("Master"))
    #with master registered
    assert_equal ["sample_c_cpp"], get_select_options("master_id")
    #General control tab
    click $xpath["task"]["general_control_tab"]
    assert !60.times{ break if (is_text_present(_("Basic Setting")) rescue false); sleep 1 }

    #Execuiton setup tab
    click $xpath["task"]["execution_setup_tab"]
    assert !60.times{ break if (is_text_present(_("Executing Setting")) rescue false); sleep 1 }

    sleep 3
    #Master tab
    click $xpath["task"]["master_tab"]
    sleep 3
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 1 }

    #  logout
    logout

  end

  #    # F-005
  # The registration page of an analysis task.
  # "Registration of analysis task" page is displayed with no condition

  def test_005

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

    # The master registered into the object PJ is 0
    assert is_text_present("PJ: SamplePJ1")
    click  $xpath["task"]["master_control"]
    assert !60.times{ break if (is_text_present(_("Master Administration")) rescue false); sleep 1 }
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    assert is_text_present(_("Details of an analysis task"))
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 1 }
    #A click of each tab will change the contents of a display to the thing according to a tab.
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 1 }
    assert is_text_present(_("Master"))
    #with master registered
    assert_equal ["sample_c_cpp"], get_select_options("master_id")
    #General control tab
    click $xpath["task"]["general_control_tab"]
    assert !60.times{ break if (is_text_present(_("Basic Setting")) rescue false); sleep 1 }
    sleep 3#
    #Execuiton setup tab
    click $xpath["task"]["execution_setup_tab"]
    assert !60.times{ break if (is_text_present(_("Executing Setting")) rescue false); sleep 1 }#
    #Master tab
    click $xpath["task"]["master_tab"]
    sleep 3
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 1 }

    #  logout
    logout

  end

  # F-006
  # The registration page of an analysis task.
  # "Registration of analysis task" page is displayed.
  #It logs in by PJ member authority.

  def test_006

    # log in by PJ member authority.
    open "/auth/login"
    type "login", "pj_member"
    type "password", "pj_member"
    click "commit"

    #Find a PU
    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 2

    #Find a PJ of PU
    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"
    assert !60.times{ break if (is_text_present(_("Analysis Task Administration")) rescue false); sleep 1 }
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 1 }
    assert_equal [@individual], get_select_options("analyze_type")
    #  logout
    logout

  end

  #F-007
  # Default configuration.
  # "Registration of analysis task" page
  #A "general control" tab is displayed.

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

    # The master registered into the object PJ is 0
    assert is_text_present("PJ: SamplePJ1")
    click  $xpath["task"]["master_control"]
    assert !60.times{ break if (is_text_present(_("Master Administration")) rescue false); sleep 1 }
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    assert is_text_present(_("Details of an analysis task"))
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 1 }
    #A click of each tab will change the contents of a display to the thing according to a tab.
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 1 }
    assert is_text_present(_("Master"))
    #with master registered
    assert_equal ["sample_c_cpp"], get_select_options("master_id")
    #General control tab
    click $xpath["task"]["general_control_tab"]
    assert !60.times{ break if (is_text_present(_("Basic Setting")) rescue false); sleep 1 }
    sleep 3
    assert is_text_present(_("Name"))
    assert is_element_present($xpath["task"]["task_information"])
    assert is_text_present(_("Register Analysis Task"))
    assert is_text_present(_("Select Analysis Tools and Rule Level"))
    assert is_text_present(_("Analysis Rule Setting"))
    assert is_text_present("qac")
    assert is_text_present("qacpp")

    #  logout
    logout
  end

  #F-008
  # Default configuration.
  # "Registration of analysis task" page
  #A "general control" tab is displayed.

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
    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    # The master registered into the object PJ is 0
    assert is_text_present("PJ: SamplePJ1")
    click  $xpath["task"]["master_control"]
    assert !60.times{ break if (is_text_present(_("Master Administration")) rescue false); sleep 1 }
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    assert is_text_present(_("Details of an analysis task"))
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 1 }
    #A click of each tab will change the contents of a display to the thing according to a tab.
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 1 }
    assert is_text_present(_("Master"))
    #with master registered
    assert_equal ["sample_c_cpp"], get_select_options("master_id")
    #General control tab
    click $xpath["task"]["general_control_tab"]
    assert !60.times{ break if (is_text_present(_("Basic Setting")) rescue false); sleep 1 }
    sleep 3
    assert is_text_present(_("Name"))
    assert is_element_present($xpath["task"]["task_information"])
    assert is_text_present(_("Register Analysis Task"))
    assert is_text_present(_("Select Analysis Tools and Rule Level"))
    assert is_text_present(_("Analysis Rule Setting"))
    assert is_text_present("qac")
    assert is_text_present("qacpp")
    #Execuiton setup tab
    click $xpath["task"]["execution_setup_tab"]
    assert !60.times{ break if (is_text_present(_("Executing Setting")) rescue false); sleep 1 }
    select "tool_name", "qac"
    assert is_text_present("qac " + _("setting"))
    assert is_text_present(_("Make options"))
    assert is_text_present(_("Environment variables"))
    assert is_text_present(_("Header file at analyze"))
    assert is_text_present(_("Analyze tool config"))
    assert is_text_present(_("Others"))
    select "tool_name", "label=qacpp"
    sleep 3
    assert is_text_present("qacpp " + _("setting"))
    assert is_text_present(_("Make options"))
    assert is_text_present(_("Environment variables"))
    assert is_text_present(_("Header file at analyze"))
    assert is_text_present(_("Analyze tool config"))
    assert is_text_present(_("Others"))
    sleep 3

    #  logout
    logout
  end

  #F-009
  # Default configuration.
  # "Registration of analysis task" page
  #A "general control" tab is displayed.

  def test_009

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

    # The master registered into the object PJ is 0
    assert is_text_present("PJ: SamplePJ1")
    click  $xpath["task"]["master_control"]
    assert !60.times{ break if (is_text_present(_("Master Administration")) rescue false); sleep 1 }
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    assert is_text_present(_("Details of an analysis task"))
    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 1 }
    #A click of each tab will change the contents of a display to the thing according to a tab.
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 1 }
    assert is_text_present(_("Master"))
    #with master registered
    assert_equal ["sample_c_cpp"], get_select_options("master_id")
    #Master tab
    click $xpath["task"]["master_tab"]
    sleep 3
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 1 }
    #make root is empty.
    #analyze_allow_files and analyze_deny_files are "un-setting up."
    assert is_text_present(_("Make root")+":")
    click $xpath["task"]["analyze_allow_file_link"]
    assert !60.times{ break if (is_text_present(_("Unsetting")) rescue false); sleep 1 }
    run_script "destroy_subwindow()"
    click $xpath["task"]["analyze_deny_files"]
    assert !60.times{ break if (is_text_present(_("Unsetting")) rescue false); sleep 1 }
    run_script "destroy_subwindow()"

    #  logout
    logout

  end


  # F-010
  # The registration page of an analysis task.
  # The existing task is diverted.

  def test_010

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

    # The master registered
    assert is_text_present("PJ: SamplePJ1")
    click  $xpath["task"]["master_control"]
    assert !60.times{ break if (is_text_present(_("Master Administration")) rescue false); sleep 1 }
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")

    # the existing task is diverted
    @@task = Task.find_by_pj_id(@@pj.id)
    click "//tr[@id='task_id#{@@task.id}']"
    assert !60.times{ break if (is_text_present(_("Action")) rescue false); sleep 1 }
    sleep 5
    #The details of arbitrary tasks are expressed as an analysis task management page,
    #and it moves to the registration page of an analysis task from a reuse button.
    click $xpath["task"]["add_task"]
    wait_for_text_present(_("Select Analysis Tools and Rule Level"))
    #  logout
    logout

  end

  #F-011
  #The registration page of an analysis task.
  #The existing task is diverted.

  def test_011

    #login
    login

    # Open PU management page
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

    #The master registered
    assert is_text_present("PJ: SamplePJ1")
    click  $xpath["task"]["master_control"]
    assert !60.times{ break if (is_text_present(_("Master Administration")) rescue false); sleep 1 }
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")

    #the existing task is diverted
    @@task = Task.find_by_pj_id(@@pj.id)
    click "//tr[@id='task_id#{@@task.id}']"
    assert !60.times{ break if (is_text_present(_("Action")) rescue false); sleep 1 }
    sleep 5
    #The details of arbitrary tasks are expressed as an analysis task management page,
    #and it moves to the registration page of an analysis task from a reuse button.
    click $xpath["task"]["add_task"]
    wait_for_text_present(_("Select Analysis Tools and Rule Level"))
    type "task_name", "sample_c_cpp_1_1"
    assert is_text_present(_("Select Analysis Tools and Rule Level"))
    assert is_text_present("qac")
    assert is_text_present(_("Normal"))
    assert is_element_present("qac_rule1")

    click $xpath["task"]["general_control_tab"]
    assert !60.times{ break if (is_text_present(_("Basic Setting")) rescue false); sleep 1 }
    assert is_text_present(_("Name"))
    assert is_element_present($xpath["task"]["task_information"])
    assert is_text_present(_("Register Analysis Task"))
    assert is_text_present(_("Select Analysis Tools and Rule Level"))
    assert is_text_present(_("Analysis Rule Setting"))
    assert is_text_present("qac")
    assert is_text_present("qacpp")

    #logout
    logout

  end

  # F-012
  # The registration page of an analysis task.
  # The existing task is diverted.

  def test_012

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

    # The master registered
    assert is_text_present("PJ: SamplePJ1")
    click  $xpath["task"]["master_control"]
    assert !60.times{ break if (is_text_present(_("Master Administration")) rescue false); sleep 1 }
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")

    # the existing task is diverted
    @@task = Task.find_by_pj_id(@@pj.id)
    click "//tr[@id='task_id#{@@task.id}']"
    assert !60.times{ break if (is_text_present(_("Action")) rescue false); sleep 1 }
    sleep 5
    #The details of arbitrary tasks are expressed as an analysis task management page,
    #and it moves to the registration page of an analysis task from a reuse button.
    click $xpath["task"]["add_task"]
    wait_for_text_present(_("Select Analysis Tools and Rule Level"))
    type "task_name", "sample_c_cpp_1_1"
    assert is_text_present(_("Select Analysis Tools and Rule Level"))
    assert is_text_present("qac")
    assert is_text_present(_("Normal"))
    assert is_element_present("qac_rule1")
    click $xpath["task"]["general_control_tab"]
    assert !60.times{ break if (is_text_present(_("Basic Setting")) rescue false); sleep 1 }
    assert is_text_present(_("Name"))
    assert is_element_present($xpath["task"]["task_information"])
    assert is_text_present(_("Register Analysis Task"))
    assert is_text_present(_("Select Analysis Tools and Rule Level"))
    assert is_text_present(_("Analysis Rule Setting"))
    assert is_text_present("qac")
    assert is_text_present("qacpp")
    #Execuiton setup tab
    click $xpath["task"]["execution_setup_tab"]
    assert !60.times{ break if (is_text_present(_("Executing Setting")) rescue false); sleep 1 }
    select "tool_name", "qac"
    assert is_text_present("qac " + _("setting"))
    assert is_text_present(_("Make options"))
    assert is_text_present(_("Environment variables"))
    assert is_text_present(_("Header file at analyze"))
    assert is_text_present(_("Analyze tool config"))
    assert is_text_present(_("Others"))
    select "tool_name", "label=qacpp"
    sleep 3
    assert is_text_present("qacpp " + _("setting"))
    assert is_text_present(_("Make options"))
    assert is_text_present(_("Environment variables"))
    assert is_text_present(_("Header file at analyze"))
    assert is_text_present(_("Analyze tool config"))
    assert is_text_present(_("Others"))
    sleep 3
    #  logout
    logout

  end

  # F-013
  # The registration page of an analysis task.
  # The existing task is diverted.

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

    # The master registered
    assert is_text_present("PJ: SamplePJ1")
    click  $xpath["task"]["master_control"]
    assert !60.times{ break if (is_text_present(_("Master Administration")) rescue false); sleep 1 }
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")

    # the existing task is diverted
    @@task = Task.find_by_pj_id(@@pj.id)
    click "//tr[@id='task_id#{@@task.id}']"
    assert !60.times{ break if (is_text_present(_("Action")) rescue false); sleep 1 }
    sleep 5
    #The details of arbitrary tasks are expressed as an analysis task management page,
    #and it moves to the registration page of an analysis task from a reuse button.
    click $xpath["task"]["add_task"]
    wait_for_text_present(_("Select Analysis Tools and Rule Level"))
    type "task_name", "sample_c_cpp_1_1"
    assert is_text_present(_("Select Analysis Tools and Rule Level"))
    assert is_text_present("qac")
    assert is_text_present(_("Normal"))
    assert is_element_present("qac_rule1")
    click $xpath["task"]["general_control_tab"]
    assert !60.times{ break if (is_text_present(_("Basic Setting")) rescue false); sleep 1 }


    #  logout
    logout

  end

  # F-014
  # The registration page of an analysis task.
  # The existing task is diverted.

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

    # The master registered
    assert is_text_present("PJ: SamplePJ1")
    click  $xpath["task"]["master_control"]
    assert !60.times{ break if (is_text_present(_("Master Administration")) rescue false); sleep 1 }
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")

    # the existing task is diverted
    @@task = Task.find_by_pj_id(@@pj.id)
    click "//tr[@id='task_id#{@@task.id}']"
    assert !60.times{ break if (is_text_present(_("Action")) rescue false); sleep 1 }
    sleep 5
    #The details of arbitrary tasks are expressed as an analysis task management page,
    #and it moves to the registration page of an analysis task from a reuse button.
    click $xpath["task"]["add_task"]
    wait_for_text_present(_("Select Analysis Tools and Rule Level"))
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 1 }
    click $xpath["task"]["analyze_allow_file_link"]
    assert !60.times{ break if (is_text_present("analyze_allow_files(qac)") rescue false); sleep 1 }
    run_script "destroy_subwindow()"
    click $xpath["task"]["analyze_deny_files"]
    assert !60.times{ break if (is_text_present("analyze_deny_files(qac)") rescue false); sleep 1 }
    run_script "destroy_subwindow()"

    #  logout
    logout

  end

end
