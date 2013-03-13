require File.dirname(__FILE__) + "/test_c_setup" unless defined? TestCSetup

class TestC1 < Test::Unit::TestCase
  include TestCSetup
  fixtures :pus , :pjs , :tasks  
  @@pu = 0
  @@pj = 0
  @@task = 0

  TAB_STYLES = {
    "focused" => "background-color: rgb(238, 255, 223);",
    "unfocused" => "background-color: rgb(192, 192, 192);"
  }


  # C-002
  # The display of a setting page.
  # Hereafter, it checks on the both sides of PU setup and PJ setup.
  def test_002

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Pu created


    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    #Pu setting page
    click $xpath["misc"]["PU_setting_page"]

    sleep 4

    #PJ created
    open_pj_management_page(@@pu.id)


    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"
    # Pj setting page
    click $xpath["misc"]["PJ_setting_page"]
    sleep 4


    #  logout
    logout

  end

  # C-004
  # The contents of initial setting.
  # In the case of PU - With other PU(s) to no information inheritance
  def test_004

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Pu created


    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    #Open Pu setting page

    click $xpath["misc"]["PU_setting_page"]

    sleep 4

    # the thing of system construction is inherited
    # each setting item is blank
    assert_equal _("Analysis Rule Setting"), get_text("//table[@id='analyze_rule_numbers']/tbody/tr[1]/th")
    assert_equal "", get_value("qac_rule1")
    assert_equal "", get_value("qac_rule2")
    assert_equal "", get_value("qac_rule3")
    assert_equal "", get_value("qacpp_rule1")
    assert_equal "", get_value("qacpp_rule2")
    assert_equal "", get_value("qacpp_rule3")

    click $xpath["misc"]["display_page"]
    assert_equal _("Executing Setting"), get_text("//div[@id='tool_setting']/table[1]/tbody/tr[1]/th")
    assert_equal "", get_value("make_options")
    assert_equal "", get_value("environment_variables")
    assert_equal "", get_value("header_file_at_analyze")
    assert_equal "", get_value("analyze_tool_config")
    assert_equal "", get_value("others")
    select "tool_name", "label=QAC++"
    assert !60.times{ break if ("QAC++ " + _("setting") == get_text("target_tool") rescue false); sleep 1 }
    assert_equal "", get_value("make_options")
    assert_equal "", get_value("environment_variables")
    assert_equal "", get_value("header_file_at_analyze")
    assert_equal "", get_value("analyze_tool_config")
    assert_equal "", get_value("others")

    setup_setting_pu(@@pu.id,'qac_pu','9')


    #  logout
    logout

  end

  #C-005
  #The contents of initial setting.
  #In the case of PJ - With other PJ(s) to no information inheritance
  def test_005

    #  login
    login
    #       Open PU management page
    open_pu_management_page_1

    #Pu created


    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    #Pu setting page
    click $xpath["misc"]["PU_setting_page"]

    sleep 4

    #PJ created

    open_pj_management_page(@@pu.id)


    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"
    # Pj setting page
    click $xpath["misc"]["PJ_setting_page"]
    sleep 4

    # the thing of system construction is inherited
    # each setting item is blank
    assert_equal _("Analysis Rule Setting"), get_text("//table[@id='analyze_rule_numbers']/tbody/tr[1]/th")
    assert_equal "", get_value("qac_rule1")
    assert_equal "", get_value("qac_rule2")
    assert_equal "", get_value("qac_rule3")
    assert_equal "", get_value("qacpp_rule1")
    assert_equal "", get_value("qacpp_rule2")
    assert_equal "", get_value("qacpp_rule3")

    click $xpath["misc"]["display_page"]

    assert_equal _("Executing Setting"), get_text("//div[@id='tool_setting']/table[1]/tbody/tr[1]/th")
    assert_equal "", get_value("make_options")
    assert_equal "", get_value("environment_variables")
    assert_equal "", get_value("header_file_at_analyze")
    assert_equal "", get_value("analyze_tool_config")
    assert_equal "", get_value("others")
    select "tool_name", "label=QAC++"
    assert !60.times{ break if ("QAC++ " + _("setting") == get_text("target_tool") rescue false); sleep 1 }
    assert_equal "", get_value("make_options")
    assert_equal "", get_value("environment_variables")
    assert_equal "", get_value("header_file_at_analyze")
    assert_equal "", get_value("analyze_tool_config")
    assert_equal "", get_value("others")

    setup_setting_pj(@@pj.id,'qac_pj', 'qacpp_pj', '9,40', '10')

    #  logout
    logout

  end

  # C-006
  # The display of a page
  # PU and PJ are created.- Inherit setup information from other PU(s) and PJ.
  def test_006

    #  login
    login
    #Open PU management page
    open_pu_management_page_1
    @@pu=Pu.find_by_name('SamplePU1')
    click $xpath["misc"]["setup_page"]
    sleep 4
    #Inherit setup information from other PU(s)
    pu_inherit_both = "pu_inherit_both"
    type "project_unit_name", pu_inherit_both
    click "project_unit_original_"+@@pu.id.to_s
    click "project_unit_member"
    click "project_unit_tool_conf"
    sleep 4
    click "commit"
    sleep 4
    run_script("destroy_subwindow()")
    sleep 4
    last_row = get_xpath_count($xpath["pu"]["pu_list_row"])
    assert_equal pu_inherit_both,@selenium.get_text($xpath["pu"]["pu_list_row"]+"[#{last_row}]/td[2]")
    pu_inherit_both = Pu.find(:last)
    open"/devgroup/pu_index/#{pu_inherit_both.id}"
    wait_for_page_to_load "30000"

    #Open PJ management page

    open_pj_management_page(@@pu.id)
    @@pj=Pj.find_by_name('SamplePJ1')
    click $xpath["misc"]["setup_page"]
    assert !60.times{ break if (is_text_present(_("PJ name")) rescue false); sleep 1 }
    sleep 4

    #Inherit setup information from other PJ(s)
    pj_inherit_member = "pj_inherit_member"
    type "project_name", pj_inherit_member
    click "project_original_"+@@pj.id.to_s
    click "project_tool_conf"
    click "project_member"
    sleep 4
    click "commit"
    sleep 4
    pj_inherit_member = Pj.find(:last)
    open "/devgroup/pj_index/#{@@pu.id}/#{pj_inherit_member.id}"
    wait_for_page_to_load "30000"

    #@@pu.destroy

    #  logout
    logout

  end

  #C-007
  #The contents of initial setting
  #In the case of PU - From other PU(s) to information inheritance.
  def test_007

    #  login
    login
    #       Open PU management page
    open_pu_management_page_1

    #Pu created


    @@pu = Pu.find_by_name('SamplePU1')

    setup_setting_pu(@@pu.id,'qac_pu','9')

    #Open PU management page
    open_pu_management_page_1

    click $xpath["misc"]["setup_page"]
    sleep 4
    #Inherit setup information from other PU(s)
    pu_inherit_both = "pu_inherit_both"
    type "project_unit_name", pu_inherit_both
    click "project_unit_original_"+@@pu.id.to_s
    click "project_unit_member"
    click "project_unit_tool_conf"
    sleep 4
    click "commit"
    sleep 4
    run_script("destroy_subwindow()")
    sleep 4
    last_row = get_xpath_count($xpath["pu"]["pu_list_row"])
    assert_equal pu_inherit_both,@selenium.get_text($xpath["pu"]["pu_list_row"]+"[#{last_row}]/td[2]")
    pu_inherit_both = Pu.find(:last)
    open"/devgroup/pu_index/#{pu_inherit_both.id}"
    wait_for_page_to_load "30000"



    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4


    assert_equal _("Analysis Rule Setting"), get_text($xpath["misc"]["analyze_rule_numbers_th"])
    assert_equal @@pu.analyze_rule_configs[0].rule_numbers||'', get_value("qac_rule1")
    assert_equal @@pu.analyze_rule_configs[1].rule_numbers||'', get_value("qac_rule2")
    assert_equal @@pu.analyze_rule_configs[2].rule_numbers||'', get_value("qac_rule3")
    assert_equal @@pu.analyze_rule_configs[3].rule_numbers||'', get_value("qacpp_rule1")
    assert_equal @@pu.analyze_rule_configs[4].rule_numbers||'', get_value("qacpp_rule2")
    assert_equal @@pu.analyze_rule_configs[5].rule_numbers||'', get_value("qacpp_rule3")

    click $xpath["misc"]["display_page"]

    assert_equal _("Executing Setting"), get_text($xpath["misc"]["tool_setting_th"])
    assert is_text_present("QAC " + _("setting"))
    assert_equal @@pu.analyze_configs[0].make_options||'', get_value("make_options")
    assert_equal @@pu.analyze_configs[0].environment_variables||'', get_value("environment_variables")
    assert_equal @@pu.analyze_configs[0].header_file_at_analyze||'', get_value("header_file_at_analyze")
    assert_equal @@pu.analyze_configs[0].analyze_tool_config||'', get_value("analyze_tool_config")
    assert_equal @@pu.analyze_configs[0].others||'', get_value("others")
    select "tool_name", "label=QAC++"
    assert !60.times{ break if ("QAC++ " + _("setting") == get_text("target_tool") rescue false); sleep 1 }
    assert_equal @@pu.analyze_configs[1].make_options||'', get_value("make_options")
    assert_equal @@pu.analyze_configs[1].environment_variables||'', get_value("environment_variables")
    assert_equal @@pu.analyze_configs[1].header_file_at_analyze||'', get_value("header_file_at_analyze")
    assert_equal @@pu.analyze_configs[1].analyze_tool_config||'', get_value("analyze_tool_config")
    assert_equal @@pu.analyze_configs[1].others||'', get_value("others")
    pu_inherit_both.destroy



    #  logout
    logout

  end

  #C-008
  #The contents of initial setting
  #In the case of PJ - From other PJ(s) to information inheritance.
  def test_008

    #  login
    login
    #       Open PU management page
    open_pu_management_page_1

    #Pu created


    @@pu = Pu.find_by_name('SamplePU1')

    #Open PJ management page

    open_pj_management_page(@@pu.id)


    @@pj = Pj.find_by_name('SamplePJ1')

    setup_setting_pu(@@pu.id,'qac_pu','9')
    setup_setting_pj(@@pj.id,'qac_pj', 'qacpp_pj', '9,40', '10')

    click $xpath["misc"]["setup_page"]
    assert !60.times{ break if (is_text_present(_("PJ name")) rescue false); sleep 1 }
    sleep 4

    #Inherit setup information from other PJ(s)
    pj_inherit_member = "pj_inherit_member"
    type "project_name", pj_inherit_member
    click "project_original_"+@@pj.id.to_s
    click "project_tool_conf"
    click "project_member"
    sleep 4
    click "commit"
    sleep 4
    run_script("destroy_subwindow()")
    sleep 4
    last_row = get_xpath_count($xpath["pj"]["pj_list_row"])
    assert_equal pj_inherit_member,@selenium.get_text($xpath["pj"]["pj_list_row"]+"[#{last_row}]/td[2]")
    pj_inherit_member = Pj.find(:last)
    open "/devgroup/pj_index/#{@@pu.id}/#{pj_inherit_member.id}"
    wait_for_page_to_load "30000"
    # Pj setting page
    click $xpath["misc"]["PJ_setting_page"]
    sleep 4
    assert_equal _("Analysis Rule Setting"), get_text($xpath["misc"]["analyze_rule_numbers_th"])
    assert_equal @@pj.analyze_rule_configs[0].rule_numbers||'', get_value("qac_rule1")
    assert_equal @@pj.analyze_rule_configs[1].rule_numbers||'', get_value("qac_rule2")
    assert_equal @@pj.analyze_rule_configs[2].rule_numbers||'', get_value("qac_rule3")
    assert_equal @@pj.analyze_rule_configs[3].rule_numbers||'', get_value("qacpp_rule1")
    assert_equal @@pj.analyze_rule_configs[4].rule_numbers||'', get_value("qacpp_rule2")
    assert_equal @@pj.analyze_rule_configs[5].rule_numbers||'', get_value("qacpp_rule3")
    click $xpath["misc"]["display_page"]
    assert_equal _("Executing Setting"), get_text($xpath["misc"]["tool_setting_th"])
    assert is_text_present("QAC " + _("setting"))
    assert_equal @@pj.analyze_configs[0].make_options||'', get_value("make_options")
    assert_equal @@pj.analyze_configs[0].environment_variables||'', get_value("environment_variables")
    assert_equal @@pj.analyze_configs[0].header_file_at_analyze||'', get_value("header_file_at_analyze")
    assert_equal @@pj.analyze_configs[0].analyze_tool_config||'', get_value("analyze_tool_config")
    assert_equal @@pj.analyze_configs[0].others||'', get_value("others")
    select "tool_name", "label=QAC++"
    assert !60.times{ break if ("QAC++ " + _("setting") == get_text("target_tool") rescue false); sleep 1 }
    assert_equal @@pj.analyze_configs[1].make_options||'', get_value("make_options")
    assert_equal @@pj.analyze_configs[1].environment_variables||'', get_value("environment_variables")
    assert_equal @@pj.analyze_configs[1].header_file_at_analyze||'', get_value("header_file_at_analyze")
    assert_equal @@pj.analyze_configs[1].analyze_tool_config||'', get_value("analyze_tool_config")
    assert_equal @@pj.analyze_configs[1].others||'', get_value("others")

    #  logout
    logout

  end

  #C-009
  #The display of a setting page: Task

  def test_009
    #login
    login
    #Click open PU management page
    open_pu_management_page_1

    #Register a PU


    @@pu = Pu.find_by_name('SamplePU1')

    #Open PJ management page
    open_pj_management_page(@@pu.id)


    @@pj = Pj.find_by_name('SamplePJ1')
    setup_setting_pj(@@pj.id,'qac_pj', 'qacpp_pj', '9,40', '10')
    open("/task/add_task2/#{@@pu.id}/#{@@pj.id}")
    wait_for_page_to_load "30000"
    assert_equal _("Registration of an Analysis Task"), get_title


    #logout
    logout
  end

  #C-010
  #The contents of initial setting. A setup of other analysis tasks is not diverted.
  def test_010
    #login
    login
    #  Open PU management page
    open_pu_management_page_1

    #Pu created


    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    #Pu setting page
    click $xpath["misc"]["PU_setting_page"]

    sleep 4

    #PJ created
    open_pj_management_page(@@pu.id)


    @@pj = Pj.find_by_name('SamplePJ1')

    setup_setting_pj(@@pj.id,'qac_pj', 'qacpp_pj', '9,40', '10')
    sleep 4
    open "/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    sleep 4
    click $xpath["misc"]["PJ_setting_page"]
    #Open add task page
    open("/task/add_task2/#{@@pu.id}/#{@@pj.id}")
    wait_for_page_to_load "30000"

    assert_equal _("Analysis Rule Setting"), get_text($xpath["misc"]["analyze_rule_numbers_th"])
    assert_equal @@pj.analyze_rule_configs[0].rule_numbers||'', get_value("qac_rule1")
    assert_equal @@pj.analyze_rule_configs[1].rule_numbers||'', get_value("qac_rule2")
    assert_equal @@pj.analyze_rule_configs[2].rule_numbers||'', get_value("qac_rule3")
    assert_equal @@pj.analyze_rule_configs[3].rule_numbers||'', get_value("qacpp_rule1")
    assert_equal @@pj.analyze_rule_configs[4].rule_numbers||'', get_value("qacpp_rule2")
    assert_equal @@pj.analyze_rule_configs[5].rule_numbers||'', get_value("qacpp_rule3")

    sleep 4

    #Click add task link
    click $xpath["misc"]["execution_setting_tab"]

    sleep 4
    assert !60.times{ break if (_("Executing Setting") == get_text($xpath["misc"]["tool_setting_th"]) rescue false); sleep 1 }
    assert is_text_present("qac " + _("setting"))
    assert_equal @@pj.analyze_configs[0].make_options||'', get_value("make_options")
    assert_equal @@pj.analyze_configs[0].environment_variables||'', get_value("environment_variables")
    assert_equal @@pj.analyze_configs[0].header_file_at_analyze||'', get_value("header_file_at_analyze")
    assert_equal @@pj.analyze_configs[0].analyze_tool_config||'', get_value("analyze_tool_config")
    assert_equal @@pj.analyze_configs[0].others||'', get_value("others")
    select "tool_name", "label=qacpp"
    assert !60.times{ break if ("qacpp " + _("setting") == get_text("target_tool") rescue false); sleep 1 }
    assert_equal @@pj.analyze_configs[1].make_options||'', get_value("make_options")
    assert_equal @@pj.analyze_configs[1].environment_variables||'', get_value("environment_variables")
    assert_equal @@pj.analyze_configs[1].header_file_at_analyze||'', get_value("header_file_at_analyze")
    assert_equal @@pj.analyze_configs[1].analyze_tool_config||'', get_value("analyze_tool_config")
    assert_equal @@pj.analyze_configs[1].others||'', get_value("others")


    #logout
    logout
  end

  #C-011
  #The contents of initial setting.A setup of other analysis tasks is diverted.
  def test_011
    #login
    login
    #  Open PU management page
    open_pu_management_page_1

    #Pu created

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    #Pu setting page
    click $xpath["misc"]["PU_setting_page"]

    sleep 4

    #PJ created
    open_pj_management_page(@@pu.id)
    @@pj = Pj.find_by_name('SamplePJ1')
    #Register a task
    register_task(@@pu.id,@@pj.id)
    @@task = Task.find(:last)

    sleep 4

    #Open add task page
    open("/task/add_task2/#{@@pu.id}/#{@@pj.id}?id=#{@@task.id}")
    wait_for_page_to_load "30000"

    assert_equal _("Analysis Rule Setting"), get_text($xpath["misc"]["analyze_rule_numbers_th"])
    assert_equal '', get_value("qac_rule1")
    assert_equal '', get_value("qac_rule2")
    assert_equal '', get_value("qac_rule3")
    assert_equal '', get_value("qacpp_rule1")
    assert_equal '', get_value("qacpp_rule2")
    assert_equal '', get_value("qacpp_rule3")

    #Click add task link
    click $xpath["misc"]["execution_setting_tab"]
    sleep 4
    assert !60.times{ break if (_("Executing Setting") == get_text($xpath["misc"]["tool_setting_th"]) rescue false); sleep 1 }
    assert is_text_present("qac " + _("setting"))
    assert_equal '', get_value("make_options")
    assert_equal '', get_value("environment_variables")
    assert_equal '', get_value("header_file_at_analyze")
    assert_equal '', get_value("analyze_tool_config")
    assert_equal '', get_value("others")
    select "tool_name", "label=qacpp"
    assert !60.times{ break if ("qacpp " + _("setting") == get_text("target_tool") rescue false); sleep 1 }
    assert_equal '', get_value("make_options")
    assert_equal '', get_value("environment_variables")
    assert_equal '', get_value("header_file_at_analyze")
    assert_equal '', get_value("analyze_tool_config")
    assert_equal '', get_value("others")



    #logout
    logout
  end

  #C-12
  #The change of a tab. PU setting page and PJ setting page
  def test_012
    #login
    login

    #Open PU management page
    open_pu_management_page_1

    #Register a new PU


    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    assert is_text_present _("General Setting")
    assert is_text_present _("Execution Setting")

    # Open PJ management page

    open_pj_management_page(@@pu.id)

    #Register a new PJ



    @@pj = Pj.find_by_name('SamplePJ1')
    open "/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"
    # Pj setting page
    click $xpath["misc"]["PJ_setting_page"]
    sleep 4

    assert_equal _("General Setting"), get_text($xpath["misc"]["tab1_link"])
    assert_equal _("Execution Setting"), get_text($xpath["misc"]["tab2_link"])

    #logout
    logout
  end

  #C-13
  #The change of a tab.
  #PU setting page and PJ setting page.
  #A tab is changed.The change of the contents of a display is possible by clicking the title of a tab.
  def test_013
    #login
    login

    #Open PU management page
    open_pu_management_page_1

    #Register a new PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4

    assert_equal _("General Setting"), get_text($xpath["misc"]["tab1_link"])
    assert_equal _("Execution Setting"), get_text($xpath["misc"]["tab2_link"])

    click $xpath["misc"]["general_control_tab"]
    sleep 4
    assert is_visible("content1")
    assert !is_visible("content2")

    general_tab_style = @selenium.get_attribute($xpath["misc"]["tab1_style"])

    assert_equal TAB_STYLES["focused"],general_tab_style


    execution_tab_style = @selenium.get_attribute($xpath["misc"]["tab2_style"])
    assert_equal TAB_STYLES["unfocused"],execution_tab_style

    #logout
    logout
  end

  #C-14
  #The change of a tab.
  #PU setting page and PJ setting page.
  #A tab is changed.The background color of the tab by which a focus is not carried out is displayed more darkly.
  def test_014
    #login
    login

    #Open PU management page
    open_pu_management_page_1

    #Register a new PU


    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4

    assert_equal _("General Setting"), get_text($xpath["misc"]["tab1_link"])
    assert_equal _("Execution Setting"), get_text($xpath["misc"]["tab2_link"])

    click $xpath["misc"]["display_page"]
    sleep 4
    assert !is_visible("content1")
    assert is_visible("content2")

    general_tab_style = @selenium.get_attribute($xpath["misc"]["tab1_style"])

    assert_equal TAB_STYLES["unfocused"],general_tab_style


    execution_tab_style = @selenium.get_attribute($xpath["misc"]["tab2_style"])
    assert_equal TAB_STYLES["focused"],execution_tab_style

    #logout
    logout
  end

  #C-15
  #The change of a tab. A registration page is displayed.
  def test_015
    #login
    login
    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 4

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"


    open("/task/add_task2/#{@@pu.id}/#{@@pj.id}")
    wait_for_page_to_load "30000"
    # C15
    assert_equal _("General Setting"), get_text($xpath["misc"]["tab1_link"])
    assert_equal _("Analysis Tool Setting"), get_text($xpath["misc"]["tab2_link"])

    #logout
    logout
  end
  #
  #C-16
  #The change of a tab. A registration page is displayed.
  def test_016
    #login
    login
    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 4

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    open("/task/add_task2/#{@@pu.id}/#{@@pj.id}")

    wait_for_page_to_load "30000"

    # There are a "general control" tab and "execution setting tab."
    assert_equal _("General Setting"), get_text($xpath["misc"]["tab1_link"])
    assert_equal _("Analysis Tool Setting"), get_text($xpath["misc"]["tab2_link"])

    # C16
    click $xpath["misc"]["general_control_tab"]
    sleep 4
    assert is_element_present("analyze_rule_numbers")
    assert !is_element_present("tool_setting")

    general_tab_style = @selenium.get_attribute($xpath["misc"]["tab1_style"])
    assert_equal TAB_STYLES["focused"],general_tab_style

    execution_tab_style = @selenium.get_attribute($xpath["misc"]["tab2_style"])
    assert_equal TAB_STYLES["unfocused"],execution_tab_style

    # C16
    click $xpath["misc"]["execution_setting_tab"]
    sleep 4
    assert !is_element_present("analyze_rule_numbers")
    assert is_element_present("tool_setting")

    general_tab_style = @selenium.get_attribute($xpath["misc"]["tab1_style"])
    assert_equal TAB_STYLES["unfocused"],general_tab_style

    execution_tab_style = @selenium.get_attribute($xpath["misc"]["tab2_style"])
    assert_equal TAB_STYLES["focused"],execution_tab_style

    sleep 4

    #logout
    logout
  end

  #C-017
  #The display:"execution setup" tab of a setting page. The change of the tool for a setup
  def test_017
    #login
    login
    #Pu management page
    open_pu_management_page_1
    #A new PU is registered


    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4

    #setting page
    click $xpath["misc"]["display_page"]
    sleep 4
    # QAC and QAC++ can be chosen with the selection box of the directly under "which chooses a tool."
    assert_equal ["QAC", "QAC++"], get_select_options("tool_name")

    #  PJ setting page
    open_pj_management_page(@@pu.id)

    #New PJ is registered


    @@pj = Pj.find_by_name('SamplePJ1')
    open "/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"
    # Pj setting page
    click $xpath["misc"]["PJ_setting_page"]
    sleep 4
    #
    click $xpath["misc"]["display_page"]
    sleep 4
    # QAC and QAC++ can be chosen with the selection box of the directly under "which chooses a tool."
    assert_equal ["QAC", "QAC++"], get_select_options("tool_name")

    #Task setting page
    open("/task/add_task2/#{@@pu.id}/#{@@pj.id}")
    wait_for_page_to_load "30000"
    #Execution setting tab
    click $xpath["misc"]["execution_setting_tab"]
    sleep 4
    # QAC and QAC++ can be chosen with the selection box of the directly under "which chooses a tool."
    assert_equal ["qac", "qacpp"], get_select_options("tool_name")



    #logout
    logout
  end

  #C-018
  #The display:"execution setup" tab of a setting page.The change of the tool for a setup
  #The selection box of the directly under "which chooses a tool" is changed to QAC -> QAC++.
  def test_018
    #login
    login
    #Pu management page
    open_pu_management_page_1
    #A new PU is registered


    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4

    #setting page
    click $xpath["misc"]["display_page"]
    sleep 4
    # The contents of a total of five subsequent text area replace the setup information of QAC++.
    select "tool_name", "label=QAC++"
    assert !60.times{ break if ("QAC++ " + _("setting") == get_text("target_tool") rescue false); sleep 1 }

    #  PJ setting page
    open_pj_management_page(@@pu.id)

    #New PJ is registered


    @@pj = Pj.find_by_name('SamplePJ1')
    open "/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"
    # Pj setting page
    click $xpath["misc"]["PJ_setting_page"]
    sleep 4
    #
    click $xpath["misc"]["display_page"]
    sleep 4
    # The contents of a total of five subsequent text area replace the setup information of QAC++.
    select "tool_name", "label=QAC++"
    assert !60.times{ break if ("QAC++ " + _("setting") == get_text("target_tool") rescue false); sleep 1 }

    #Task setting page
    open("/task/add_task2/#{@@pu.id}/#{@@pj.id}")
    wait_for_page_to_load "30000"
    #Execution setting tab
    click $xpath["misc"]["execution_setting_tab"]
    sleep 4

    # The contents of a total of five subsequent text area replace the setup information of QAC++.
    select "tool_name", "label=qacpp"
    assert !60.times{ break if ("qacpp " + _("setting") == get_text("target_tool") rescue false); sleep 1 }


    #logout
    logout
  end

  #C-019
  #The display:"execution setup" tab of a setting page.The change of the tool for a setup
  #It is a selection box of the directly under "which chooses a tool" QAC++ It changes to -> QAC.
  def test_019
    #login
    login
    #Pu management page
    open_pu_management_page_1
    #A new PU is registered


    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4

    #setting page
    click $xpath["misc"]["display_page"]
    sleep 4

    # The contents of a total of five subsequent text area replace the setup information of QAC.
    select "tool_name", "label=QAC"
    assert !60.times{ break if ("QAC " + _("setting") == get_text("target_tool") rescue false); sleep 1 }

    #  PJ setting page
    open_pj_management_page(@@pu.id)

    #New PJ is registered


    @@pj = Pj.find_by_name('SamplePJ1')
    open "/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"
    # Pj setting page
    click $xpath["misc"]["PJ_setting_page"]
    sleep 4
    #
    click $xpath["misc"]["display_page"]
    sleep 4

    # The contents of a total of five subsequent text area replace the setup information of QAC.
    select "tool_name", "label=QAC"
    assert !60.times{ break if ("QAC " + _("setting") == get_text("target_tool") rescue false); sleep 1 }

    #Task setting page
    open("/task/add_task2/#{@@pu.id}/#{@@pj.id}")
    wait_for_page_to_load "30000"
    #Execution setting tab
    click $xpath["misc"]["execution_setting_tab"]
    sleep 4

    # The contents of a total of five subsequent text area replace the setup information of QAC.
    select "tool_name", "label=qac"
    assert !60.times{ break if ("qac " + _("setting") == get_text("target_tool") rescue false); sleep 1 }


    #logout
    logout
  end
  #C-20
  #The default configuration function to an analytical rule. PU setting page
  def test_020

    #login
    login
    #PU management page
    open_pu_management_page_1
    #A PU name is registered


    @@pu = Pu.find_by_name('SamplePU1')
    setup_setting_pu(@@pu.id,'qac_pu','9')
    #PU page display with a specify PU ID
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    # The contents of input area right above return to the state immediately after a page display.
    for i in 1..3 do
      type "qac_rule#{i}", "5,11,12"
      sleep 4
      click "//table[@id='analyze_rule_numbers']/tbody/tr[3]/td[#{i}]/table/tbody/tr[3]/td/a[2]"
      assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
      sleep 4
      assert_equal @@pu.analyze_rule_configs[i-1].rule_numbers||'', get_value("qac_rule#{i}")
    end
    for j in 1..3 do
      type "qacpp_rule#{j}", "5,11,12"
      sleep 4
      click "//table[@id='analyze_rule_numbers']/tbody/tr[5]/td[#{j}]/table/tbody/tr[3]/td/a[2]"
      assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
      sleep 4
      assert_equal @@pu.analyze_rule_configs[j+2].rule_numbers||'', get_value("qacpp_rule#{j}")
    end


    #logout
    logout

  end
  #C-21
  #The default configuration function to an analytical rule. PJ setting page
  def test_021
    #login
    login
    #PU management page
    open_pu_management_page_1
    #A PU name is registered


    @@pu = Pu.find_by_name('SamplePU1')
    setup_setting_pu(@@pu.id,'qac_pu','9')

    #PJ setting page
    open_pj_management_page(@@pu.id)
    #New PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #Pj index page
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"
    # Pj setting page
    click $xpath["misc"]["PJ_setting_page"]
    sleep 4
    #The contents of the input area of spontaneity return to a setup of the parents PU.
    for i in 1..3 do
      type "qac_rule#{i}", "5,11,12"
      sleep 4
      click "//table[@id='analyze_rule_numbers']/tbody/tr[3]/td[#{i}]/table/tbody/tr[3]/td/a[2]"
      assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
      sleep 4
      assert_equal @@pu.analyze_rule_configs[i-1].rule_numbers||'', get_value("qac_rule#{i}")
    end
    for j in 1..3 do
      type "qacpp_rule#{j}", "5,11,12"
      sleep 4
      click "//table[@id='analyze_rule_numbers']/tbody/tr[5]/td[#{j}]/table/tbody/tr[3]/td/a[2]"
      assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
      sleep 4
      assert_equal @@pu.analyze_rule_configs[j+2].rule_numbers||'', get_value("qacpp_rule#{j}")
    end

  end
  #C-22
  #The default configuration function to a tool setup. PU setting page
  def test_022
    #login
    login
    #PU management page
    open_pu_management_page_1
    #A PU name is registered


    @@pu = Pu.find_by_name('SamplePU1')

    # Pu index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    click $xpath["misc"]["display_page"]
    sleep 4
    # Selec label "QAC"
    # make options
    type "make_options", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr4"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[0].make_options||'', get_value("make_options")
    # environment variables
    type "environment_variables", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr7"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[0].environment_variables||'', get_value("environment_variables")
    # header file
    type "header_file_at_analyze", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr10"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[0].header_file_at_analyze||'', get_value("header_file_at_analyze")
    # analyze tool config
    type "analyze_tool_config", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr13"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[0].analyze_tool_config||'', get_value("analyze_tool_config")
    # other
    type "others", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr16"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[0].others||'', get_value("others")
    # Selec label "QAC++"
    select "tool_name", "label=QAC++"
    sleep 4
    # make options
    type "make_options", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr4"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[1].make_options||'', get_value("make_options")
    # environment variables
    type "environment_variables", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr7"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[1].environment_variables||'', get_value("environment_variables")
    # header file
    type "header_file_at_analyze", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr10"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[1].header_file_at_analyze||'', get_value("header_file_at_analyze")
    # analyze tool config
    type "analyze_tool_config", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr13"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[1].analyze_tool_config||'', get_value("analyze_tool_config")
    # other
    type "others", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr16"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[1].others||'', get_value("others")



  end
  #C-23
  #The default configuration function to a tool setup. PJ setting page
  def test_023
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A PU name is registered


    @@pu = Pu.find_by_name('SamplePU1')#
    #Pj index page
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"
    # Pj setting page
    click $xpath["misc"]["PJ_setting_page"]
    sleep 4
    click $xpath["misc"]["display_page"]
    sleep 4
    # Selec label "QAC"
    # make options
    type "make_options", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr4"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[0].make_options||'', get_value("make_options")
    # environment variables
    type "environment_variables", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr7"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[0].environment_variables||'', get_value("environment_variables")
    # header file
    type "header_file_at_analyze", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr10"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[0].header_file_at_analyze||'', get_value("header_file_at_analyze")
    # analyze tool config
    type "analyze_tool_config", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr13"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[0].analyze_tool_config||'', get_value("analyze_tool_config")
    # other
    type "others", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr16"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[0].others||'', get_value("others")
    # Selec label "QAC++"
    select "tool_name", "label=QAC++"
    sleep 4
    # make options
    type "make_options", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr4"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[1].make_options||'', get_value("make_options")
    # environment variables
    type "environment_variables", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr7"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[1].environment_variables||'', get_value("environment_variables")
    # header file
    type "header_file_at_analyze", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr10"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[1].header_file_at_analyze||'', get_value("header_file_at_analyze")
    # analyze tool config
    type "analyze_tool_config", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr13"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[1].analyze_tool_config||'', get_value("analyze_tool_config")
    # other
    type "others", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr16"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[1].others||'', get_value("others")

  end

  #C-24
  #Check dialog display. When a default link is clicked, a check dialog is certainly displayed.
  def test_024
    #login
    login
    #PU management page
    open_pu_management_page_1
    #A PU name is registered


    @@pu = Pu.find_by_name('SamplePU1')
    #PU page display with a specify PU ID
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    # The contents of input area right above return to the state immediately after a page display.
    for i in 1..3 do
      type "qac_rule#{i}", "5,11,12"
      sleep 4
      click "//table[@id='analyze_rule_numbers']/tbody/tr[3]/td[#{i}]/table/tbody/tr[3]/td/a[2]"
      assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
      sleep 4
      assert_equal @@pu.analyze_rule_configs[i-1].rule_numbers||'', get_value("qac_rule#{i}")
    end
    for j in 1..3 do
      type "qacpp_rule#{j}", "5,11,12"
      sleep 4
      click "//table[@id='analyze_rule_numbers']/tbody/tr[5]/td[#{j}]/table/tbody/tr[3]/td/a[2]"
      assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
      sleep 4
      assert_equal @@pu.analyze_rule_configs[j+2].rule_numbers||'', get_value("qacpp_rule#{j}")
    end

    #PJ setting page
    open_pj_management_page(@@pu.id)
    #New PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #Pj index page
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"
    # Pj setting page
    click $xpath["misc"]["PJ_setting_page"]
    sleep 4
    #The contents of the input area of spontaneity return to a setup of the parents PU.
    for i1 in 1..3 do
      type "qac_rule#{i1}", "5,11,12"
      sleep 4
      click "//table[@id='analyze_rule_numbers']/tbody/tr[3]/td[#{i1}]/table/tbody/tr[3]/td/a[2]"
      assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
      sleep 4
      assert_equal @@pu.analyze_rule_configs[i-1].rule_numbers||'', get_value("qac_rule#{i1}")
    end
    for j1 in 1..3 do
      type "qacpp_rule#{j1}", "5,11,12"
      sleep 4
      click "//table[@id='analyze_rule_numbers']/tbody/tr[5]/td[#{j1}]/table/tbody/tr[3]/td/a[2]"
      assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
      sleep 4
      assert_equal @@pu.analyze_rule_configs[j+2].rule_numbers||'', get_value("qacpp_rule#{j1}")
    end

    # Pu index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    click $xpath["misc"]["display_page"]
    sleep 4
    # Selec label "QAC"
    # make options
    type "make_options", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr4"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[0].make_options||'', get_value("make_options")
    # environment variables
    type "environment_variables", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr7"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[0].environment_variables||'', get_value("environment_variables")
    # header file
    type "header_file_at_analyze", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr10"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[0].header_file_at_analyze||'', get_value("header_file_at_analyze")
    # analyze tool config
    type "analyze_tool_config", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr13"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[0].analyze_tool_config||'', get_value("analyze_tool_config")
    # other
    type "others", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr16"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[0].others||'', get_value("others")
    # Selec label "QAC++"
    select "tool_name", "label=QAC++"
    sleep 4
    # make options
    type "make_options", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr4"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[1].make_options||'', get_value("make_options")
    # environment variables
    type "environment_variables", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr7"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[1].environment_variables||'', get_value("environment_variables")
    # header file
    type "header_file_at_analyze", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr10"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[1].header_file_at_analyze||'', get_value("header_file_at_analyze")
    # analyze tool config
    type "analyze_tool_config", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr13"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[1].analyze_tool_config||'', get_value("analyze_tool_config")
    # other
    type "others", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr16"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[1].others||'', get_value("others")


    #Pj index page
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"
    # Pj setting page
    click $xpath["misc"]["PJ_setting_page"]
    sleep 4
    click $xpath["misc"]["display_page"]
    sleep 4
    # Selec label "QAC"
    # make options
    type "make_options", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr4"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[0].make_options||'', get_value("make_options")
    # environment variables
    type "environment_variables", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr7"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[0].environment_variables||'', get_value("environment_variables")
    # header file
    type "header_file_at_analyze", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr10"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[0].header_file_at_analyze||'', get_value("header_file_at_analyze")
    # analyze tool config
    type "analyze_tool_config", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr13"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[0].analyze_tool_config||'', get_value("analyze_tool_config")
    # other
    type "others", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr16"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[0].others||'', get_value("others")
    # Selec label "QAC++"
    select "tool_name", "label=QAC++"
    sleep 4
    # make options
    type "make_options", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr4"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[1].make_options||'', get_value("make_options")
    # environment variables
    type "environment_variables", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr7"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[1].environment_variables||'', get_value("environment_variables")
    # header file
    type "header_file_at_analyze", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr10"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[1].header_file_at_analyze||'', get_value("header_file_at_analyze")
    # analyze tool config
    type "analyze_tool_config", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr13"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[1].analyze_tool_config||'', get_value("analyze_tool_config")
    # other
    type "others", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr16"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pu.analyze_configs[1].others||'', get_value("others")


  end

  #C-25
  #The default configuration function to an analytical rule.
  def test_025
    #login
    login
    #PU management page
    open_pu_management_page_1
    # New Pu


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)


    @@pj = Pj.find_by_name('SamplePJ1')
    #PJ setting
    setup_setting_pj(@@pj.id,'qac_pj', 'qacpp_pj', '9,40', '10')

    #The registration page of an analysis task is displayed.
    open("/task/add_task2/#{@@pu.id}/#{@@pj.id}")
    # The contents of input area right above return to a setup of the parents PJ.
    for i in 1..3 do
      type "qac_rule#{i}", "5,11,12"
      sleep 4
      click "//table[@id='analyze_rule_numbers']/tbody/tr[3]/td[#{i}]/table/tbody/tr[3]/td/a[2]"
      assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
      sleep 4
      assert_equal @@pj.analyze_rule_configs[i-1].rule_numbers||'', get_value("qac_rule#{i}")
    end
    for j in 1..3 do
      type "qacpp_rule#{j}", "5,11,12"
      sleep 4
      click "//table[@id='analyze_rule_numbers']/tbody/tr[5]/td[#{j}]/table/tbody/tr[3]/td/a[2]"
      assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
      sleep 4
      assert_equal @@pj.analyze_rule_configs[j+2].rule_numbers||'', get_value("qacpp_rule#{j}")
    end

    #logout
    logout
  end

  #C-26
  #The default configuration function to an analytical rule.
  def test_026
    #login
    login
    #PU management page
    open_pu_management_page_1
    # New Pu


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)


    @@pj = Pj.find_by_name('SamplePJ1')
    #PJ setting
    setup_setting_pj(@@pj.id,'qac_pj', 'qacpp_pj', '9,40', '10')

    #The registration page of an analysis task is displayed.
    open("/task/add_task2/#{@@pu.id}/#{@@pj.id}")
    wait_for_page_to_load "30000"
    #Execution setting tab
    click $xpath["misc"]["execution_setting_tab"]
    sleep 4
    # Selec label "QAC"
    # make options
    type "make_options", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr4"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pj.analyze_configs[0].make_options||'', get_value("make_options")
    # environment variables
    type "environment_variables", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr7"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pj.analyze_configs[0].environment_variables||'', get_value("environment_variables")
    # header file
    type "header_file_at_analyze", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr10"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pj.analyze_configs[0].header_file_at_analyze||'', get_value("header_file_at_analyze")
    # analyze tool config
    type "analyze_tool_config", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr13"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pj.analyze_configs[0].analyze_tool_config||'', get_value("analyze_tool_config")
    # other
    type "others", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr16"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pj.analyze_configs[0].others||'', get_value("others")
    # Selec label "QAC++"
    select "tool_name", "label=qacpp"
    sleep 4
    # make options
    type "make_options", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr4"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pj.analyze_configs[1].make_options||'', get_value("make_options")
    # environment variables
    type "environment_variables", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr7"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pj.analyze_configs[1].environment_variables||'', get_value("environment_variables")
    # header file
    type "header_file_at_analyze", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr10"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pj.analyze_configs[1].header_file_at_analyze||'', get_value("header_file_at_analyze")
    # analyze tool config
    type "analyze_tool_config", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr13"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pj.analyze_configs[1].analyze_tool_config||'', get_value("analyze_tool_config")
    # other
    type "others", "5,11,12"
    sleep 4
    click $xpath["misc"]["tool_configuration_table_tr16"]
    assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
    sleep 4
    assert_equal @@pj.analyze_configs[1].others||'', get_value("others")

    #logout
    logout
  end

  #C-27
  #The display of a subwindow.PU setting page
  def test_027
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)
    # A new PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #PU index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    #The subwindow for choosing an analytical rule is displayed.
    sleep 4

    click $xpath["misc"]["analyze_rule_numbers"]
    sleep 4
    assert_equal _("Select Analysis Rule"), get_text($xpath["misc"]["rule_select_window_div"])
    run_script("destroy_subwindow()")
    sleep 4

    click $xpath["misc"]["analytical_rule_setup"]
    sleep 4
    assert_equal _("Select Analysis Rule"), get_text($xpath["misc"]["rule_select_window_div"])
    run_script("destroy_subwindow()")
    sleep 4



    #logout
    logout

  end
  #C-28
  #The display of a subwindow.PJ setting page
  def test_028
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)
    # A new PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #PJ index page
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"
    # Pj setting page
    click $xpath["misc"]["PJ_setting_page"]
    sleep 4
    #The subwindow for choosing an analytical rule is displayed.

    click $xpath["misc"]["analyze_rule_numbers"]
    sleep 4
    assert_equal _("Select Analysis Rule"), get_text($xpath["misc"]["rule_select_window_div"])
    run_script("destroy_subwindow()")
    sleep 4
    click $xpath["misc"]["analytical_rule_setup"]
    sleep 4
    assert_equal _("Select Analysis Rule"), get_text($xpath["misc"]["rule_select_window_div"])
    run_script("destroy_subwindow()")
    sleep 4


    #logout
    logout

  end
  #C-29
  #The display of a subwindow.Task setting page
  def test_029
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)
    # A new PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #Task index page
    open("/task/add_task2/#{@@pu.id}/#{@@pj.id}")
    wait_for_page_to_load "30000"
    # Task setting page
    #The subwindow for choosing an analytical rule is displayed.

    click $xpath["misc"]["analyze_rule_numbers"]
    sleep 4
    assert_equal _("Select Analysis Rule"), get_text($xpath["misc"]["rule_select_window_div"])
    run_script("destroy_subwindow()")
    sleep 4


    click $xpath["misc"]["analytical_rule_setup"]
    sleep 4
    assert_equal _("Select Analysis Rule"), get_text($xpath["misc"]["rule_select_window_div"])
    run_script("destroy_subwindow()")
    sleep 4


    #logout
    logout

  end
  #C-30
  #The display of a subwindow: Selection of an analytical rule
  #The subwindow of analytical rule selection is displayed.
  def test_030
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU

    @@pu = Pu.find_by_name('SamplePU1')

    #PU index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    click $xpath["misc"]["analyze_rule_numbers"]
    sleep 4

    run_script("destroy_subwindow()")
    sleep 4

    #logout
    logout

  end


  #C-31
  #The subwindow of analytical rule selection is displayed.
  #The number link of the analytical rule bottom is clicked.
  def test_031
    #login
    login
    # PU management page
    open_pu_management_page_1
    @@pu = Pu.find_by_name('SamplePU1')

    #PU index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    click $xpath["misc"]["analyze_rule_numbers"]
    sleep 4
    no_link = get_xpath_count($xpath["misc"]["page_list"]).to_i
    for i in 1..no_link do
      link = get_text("//p[@id='page_list']/a[#{i}]")
      rules = link.split('〜')
      click "link=#{link}"
      sleep 4
      no_rule = get_xpath_count($xpath["misc"]["rule_list_tr0"]).to_i
      # An updating indication of the analytical rule corresponding to a number is given on a subwindow.
      # first rule number in current page
      assert_equal rules[0], get_text(($xpath["misc"]["rule_list_tr1"]))
      # last rule number in current page
      assert_equal rules[1], get_text("//tbody[@id='rule_list']/tr[#{no_rule}]/td[2]")
    end
    run_script("destroy_subwindow()")
    sleep 4

    #logout
    logout

  end
  #C-32
  #The subwindow of analytical rule selection is displayed.
  #The number link is clicked.
  def test_032
    #login
    login
    # PU management page
    open_pu_management_page_1
    @@pu = Pu.find_by_name('SamplePU1')

    #PU index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    click $xpath["misc"]["analyze_rule_numbers"]
    sleep 4
    no_link = get_xpath_count($xpath["misc"]["page_list"]).to_i
    for i in 1..no_link do
      link = get_text("//p[@id='page_list']/a[#{i}]")
      #rules = link.split('〜')
      click "link=#{link}"
      sleep 4
      no_rule = get_xpath_count($xpath["misc"]["rule_list_tr0"]).to_i

      #There is no duplication in the analytical rule displayed for every number.
      all_rules = []
      for j in 1..no_rule do
        #assert_equal( "checkbox", get_attribute("//tbody[@id='rule_list']/tr[#{j}]/td[1]/input@type"))
        all_rules << get_text("//tbody[@id='rule_list']/tr[#{j}]/td[2]")
      end
      no_duplication_rules = all_rules.uniq
      assert_equal no_duplication_rules, all_rules

    end
    run_script("destroy_subwindow()")
    sleep 4

    #logout
    logout

  end

  #C-33
  #The "check" button on a subwindow is clicked.
  def test_033
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PU index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    # open a subwindow
    click $xpath["misc"]["analyze_rule_numbers"]
    sleep 4
    all_rules_in_page = []
    no_rule = get_xpath_count($xpath["misc"]["rule_list_tr0"]).to_i
    for i in 1..no_rule
      all_rules_in_page << get_text("//tbody[@id='rule_list']/tr[#{i}]/td[2]")
    end
    # A check is given to all the analytical rules on a subwindow currently displayed.
    #The analytical rule of other numbers is not checked.
    # Click the "check" button
    click $xpath["misc"]["check_button"]
    sleep 4
    # Click the "register" button
    click $xpath["misc"]["register_button"]
    sleep 4
    checked_rules = get_value("qac_rule1").split(',')
    assert_equal checked_rules, all_rules_in_page


    #logout
    logout

  end

  #C-34
  #The "clearance" button on a subwindow is clicked.
  def test_034
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PU index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    # open a subwindow
    click $xpath["misc"]["analyze_rule_numbers"]
    sleep 4
    all_rules_in_page = []
    no_rule = get_xpath_count($xpath["misc"]["rule_list_tr0"]).to_i
    for i in 1..no_rule
      all_rules_in_page << get_text("//tbody[@id='rule_list']/tr[#{i}]/td[2]")
    end
    # The check of all the analytical rules on a subwindow currently displayed is cleared.
    #The analytical rule of other numbers is not cleared.
    # Click the "clearance" button
    click $xpath["misc"]["clearance_button"]
    sleep 4
    # Click the "register" button
    click $xpath["misc"]["register_button"]

    sleep 4
    checked_rules = get_value("qac_rule1").split(',')
    assert_equal checked_rules, []
    click $xpath["misc"]["analyze_rule_numbers"]
    sleep 4
    # Click the "check altogether" button
    click $xpath["misc"]["check_all_button"]
    sleep 4
    # Click the "clearance" button
    click $xpath["misc"]["clearance_button"]
    sleep 4
    # Click the "register" button
    click $xpath["misc"]["register_button"]
    sleep 4
    checked_rules = get_value("qac_rule1").split(',')
    assert_not_equal checked_rules, []


    #logout
    logout

  end

  #C-35
  #The "it is a check altogether" button on a subwindow is clicked.
  def test_035
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PU index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    # open a subwindow
    click $xpath["misc"]["analyze_rule_numbers"]
    sleep 4

    no_link = get_xpath_count($xpath["misc"]["page_list"]).to_i
    all_rules = []
    for i in 1..no_link do
      link = get_text("//p[@id='page_list']/a[#{i}]")
      click "link=#{link}"
      sleep 4
      no_rule = get_xpath_count($xpath["misc"]["rule_list_tr0"]).to_i
      for j in 1..no_rule
        all_rules << get_text("//tbody[@id='rule_list']/tr[#{j}]/td[2]")
      end
    end
    # A check is given to all the analytical rules.
    #The rule displayed by other numbers is included.
    # Click the "check altogether" button
    click $xpath["misc"]["check_all_button"]
    sleep 4
    # Click the "register" button
    click $xpath["misc"]["register_button"]
    sleep 4
    checked_rules = get_value("qac_rule1").split(',')
    assert_equal all_rules, checked_rules


    #logout
    logout

  end

  #C-36
  #The button on a subwindow "cleared altogether" is clicked.
  def test_036
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PU index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    # open a subwindow
    click $xpath["misc"]["analyze_rule_numbers"]
    sleep 4

    no_link = get_xpath_count($xpath["misc"]["page_list"]).to_i
    all_rules = []
    for i in 1..no_link do
      link = get_text("//p[@id='page_list']/a[#{i}]")
      click "link=#{link}"
      sleep 4
      no_rule = get_xpath_count($xpath["misc"]["rule_list_tr0"]).to_i
      for j in 1..no_rule
        all_rules << get_text("//tbody[@id='rule_list']/tr[#{j}]/td[2]")
      end
    end
    # The check of all the analytical rules is cleared.
    #The rule displayed by other numbers is included.
    # Click the "clear altogether" button
    click $xpath["misc"]["clear_all_button"]
    sleep 4
    # Click the "register" button
    click $xpath["misc"]["register_button"]
    sleep 4
    checked_rules = get_value("qac_rule1").split(',')
    assert_equal checked_rules, []


    #logout
    logout

  end

  #C-37
  #"Selection" link under a QAC analytical rule setup is clicked.
  #ID of the analytical rule displayed on the top of the list of numbers 1 is checked.
  def test_037
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PU index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    # open a subwindow
    click $xpath["misc"]["analyze_rule_numbers"]
    sleep 4

    # "Selection" link under a QAC analytical rule setup is clicked.
    #The minimum analytical rule number of QAC is 9.
    # first rule number is checked.
    assert_equal "9", get_text($xpath["misc"]["rule_list_tr1"])


    #logout
    logout

  end
  #C-38
  #"Selection" link under a QAC analytical rule setup is clicked.
  #ID of the analytical rule displayed at the bottom of the list of the last numbers is checked.
  def test_038
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PU index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    # open a subwindow
    click $xpath["misc"]["analyze_rule_numbers"]
    sleep 4
    # The maximum analytical rule number of QAC is 4828.
    # last rule number is checked
    no_link = get_xpath_count($xpath["misc"]["page_list"]).to_i
    last_link = get_text("//p[@id='page_list']/a[#{no_link}]")
    click "link=#{last_link}"
    sleep 4
    no_rule = get_xpath_count($xpath["misc"]["rule_list_tr0"]).to_i
    assert_equal "4828", get_text("//tbody[@id='rule_list']/tr[#{no_rule}]/td[2]")



    #logout
    logout

  end
  #C-39
  #"Selection" link under a QAC++ analytical rule setup is clicked.
  #ID of the analytical rule displayed on the top of the list of numbers 1 is checked.
  def test_039
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PU index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    # "Selection" link under a QAC++ analytical rule setup is clicked.
    click $xpath["misc"]["analytical_rule_setup"]
    sleep 4
    # The minimum analytical rule number of QAC++ is 10.
    # first rule number is checked.
    assert_equal "10", get_text($xpath["misc"]["rule_list_tr1"])


    #logout
    logout

  end
  #C-40
  #"Selection" link under a QAC++ analytical rule setup is clicked.
  #ID of the analytical rule displayed at the bottom of the list of the last numbers is checked.
  def test_040
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PU index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    # open a subwindow
    click $xpath["misc"]["analytical_rule_setup"]
    sleep 4

    # The maximum analytical rule number of QAC++ is 4828.
    # last rule number is checked

    no_link = get_xpath_count($xpath["misc"]["page_list"]).to_i
    last_link = get_text("//p[@id='page_list']/a[#{no_link}]")
    click "link=#{last_link}"
    sleep 4
    no_rule = get_xpath_count($xpath["misc"]["rule_list_tr0"]).to_i
    assert_equal "4828", get_text("//tbody[@id='rule_list']/tr[#{no_rule}]/td[2]")


    #logout
    logout

  end

  # C-41
  # - Enter the rule number in the text area of "selection" link right above beforehand.
  #(Any of PU, PJ, and a task may be sufficient as a page)
  # "Selection" link is clicked and the subwindow of analytical rule selection is displayed.
  def test_041
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PU index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4

    type "qac_rule1", "9"
    # "Selection" link under a QAC analytical rule setup is clicked.
    # open a subwindow
    click $xpath["misc"]["analyze_rule_numbers"]
    sleep 4

    # Finishing [ the rule number corresponding to the rule number of the column pause
    #  included in the text area of "selection" link right above / a check ] already
    assert is_checked("//input[@value='9']")
    # Click the "clear altogether" button
    click $xpath["misc"]["clear_all_button"]
    sleep 4


    #logout
    logout

  end

  #C-42
  #- Enter the rule number in the text area of "selection" link right above beforehand.
  #(Any of PU, PJ, and a task may be sufficient as a page)
  #Only the analytical rule of the top of an analytical rule and the bottom analytical rule
  # which were displayed in a list are checked, and "registration" button is clicked.
  def test_042
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PU index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4

    type "qac_rule1", "9"
    # "Selection" link under a QAC analytical rule setup is clicked.
    # open a subwindow
    click $xpath["misc"]["analyze_rule_numbers"]
    sleep 4

    # Two corresponding analytical rule numbers are substituted for text area by a comma pause.
    # Check the top of an analytical rule and the bottom analytical rule
    top_rule = get_text($xpath["misc"]["rule_list_tr1"])
    #click $xpath["misc"]["rule_list_tr1_input"]
    no_rule = get_xpath_count($xpath["misc"]["rule_list_tr0"]).to_i
    bottom_rule = get_text("//tbody[@id='rule_list']/tr[#{no_rule}]/td[2]")
    click "//tbody[@id='rule_list']/tr[#{no_rule}]/td[1]/input"
    # Click the "register" button
    click $xpath["misc"]["register_button"]
    sleep 4
    assert_equal top_rule + ',' + bottom_rule, get_value("qac_rule1")


    #logout
    logout

  end
  #C-43
  #- Enter the rule number in the text area of "selection" link right above beforehand.
  #(Any of PU, PJ, and a task may be sufficient as a page)
  #"Selection" link is again clicked following the above-mentioned operation, and a subwindow is displayed.
  def test_043
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PU index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4

    type "qac_rule1", "9"
    # "Selection" link under a QAC analytical rule setup is clicked.
    # open a subwindow
    click $xpath["misc"]["analyze_rule_numbers"]
    sleep 4
    # Two corresponding analytical rule numbers are substituted for text area by a comma pause.
    # Check the top of an analytical rule and the bottom analytical rule
    top_rule = get_text($xpath["misc"]["rule_list_tr1"])
    #click $xpath["misc"]["rule_list_tr1_input"]
    no_rule = get_xpath_count($xpath["misc"]["rule_list_tr0"]).to_i
    bottom_rule = get_text("//tbody[@id='rule_list']/tr[#{no_rule}]/td[2]")
    click "//tbody[@id='rule_list']/tr[#{no_rule}]/td[1]/input"
    # The rule applicable to the rule number currently displayed on text area
    #  is already ending with a check.
    assert is_checked("//input[@value='#{top_rule}']")
    assert is_checked("//input[@value='#{bottom_rule}']")

    sleep 4


    #logout
    logout

  end
  #C-44
  #The display of a subwindow.
  #QAC: Click "selection" link in 3, a total of six QAC++:3,
  #and the analytical rule selection area currently prepared,
  #use the analytical rule setting up function on a subwindow for it,
  #and set an analytical rule to it.
  def test_044
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)
    # A new PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #Task index page
    open("/task/add_task2/#{@@pu.id}/#{@@pj.id}")
    wait_for_page_to_load "30000"
    #The subwindow for choosing an analytical rule is displayed.
    sleep 4
    #QAC: An analytical rule different, respectively can be set to 3
    for i in 1..3 do
      click "//table[@id='analyze_rule_numbers']/tbody/tr[3]/td[#{i}]/table/tbody/tr[3]/td/a[1]"
      sleep 4
      assert_equal _("Select Analysis Rule"), get_text($xpath["misc"]["rule_select_window_div"])
      run_script("destroy_subwindow()")
      sleep 4
    end
    #a total of six QAC++3
    for k in 1..3 do
      click "//table[@id='analyze_rule_numbers']/tbody/tr[5]/td[#{k}]/table/tbody/tr[3]/td/a[1]"
      sleep 4
      assert_equal _("Select Analysis Rule"), get_text($xpath["misc"]["rule_select_window_div"])
      run_script("destroy_subwindow()")
      sleep 4
    end


    #logout
    logout

  end
  #C-45
  #Saving of an analytical rule. PU, PJ setting page
  #The button at the upper right of a setting page "which saves all the setup"
  # is suitably pushed for an analytical rule after a setup.

  def test_045
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)
    # A new PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #PU index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4

    click $xpath["misc"]["save_all_setup_button"]
    sleep 4
    assert get_text("log_contents").include?(_("PU setting was saved."))


    #logout
    logout

  end

  #C-46
  #Saving of an analytical rule. PU, PJ setting page
  #The again same setting page is displayed
  #after inheritancely once moving to another page from the above.

  def test_046
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)
    # A new PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #PU index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4

    type "qac_rule1", "9"
    type "qac_rule2", "9"
    type "qac_rule3", "9"
    type "qacpp_rule1", "10"
    type "qacpp_rule2", "10"
    type "qacpp_rule3", "10"
    click $xpath["misc"]["save_all_setup_button"]
    sleep 4
    assert get_text("log_contents").include?(_("PU setting was saved."))


    #logout
    logout

  end

  #C-47
  #Saving of a setup. PU, PJ setting page
  #The setup information of QAC is displayed using a selection box,
  #edit is added, and the button "which saves a setup" is clicked.

  def test_047
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)
    # A new PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #Pu index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    click $xpath["misc"]["display_page"]

    # the button "which saves a setup" is clicked.
    type "make_options", "options"
    click $xpath["misc"]["save_a_setup_button"]
    sleep 4
    #The message which tells saving of an execution setup is displayed on the screen upper left.
    assert get_text("log_contents").include?(_("Execution setting was updated."))

    #PJ setting page
    open "/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"
    # Pj setting page
    click $xpath["misc"]["PJ_setting_page"]
    sleep 4
    click $xpath["misc"]["display_page"]
    sleep 4
    # C47
    type "make_options", "options"
    click $xpath["misc"]["save_a_setup_button"]
    sleep 4
    assert get_text("log_contents").include?(_("Execution setting was updated."))


    #logout
    logout

  end

  #C-48
  #Saving of a setup. PU, PJ setting page
  #It changes to a setup of QAC++ following the above-mentioned operation.

  def test_048
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)
    # A new PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #Pu index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    click $xpath["misc"]["display_page"]

    # The setup information of contents QAC++ of a total of five text area is replaced.
    select "tool_name", "label=QAC++"
    sleep 4
    assert_equal "QAC++ " + _("setting"), get_text("target_tool")
    assert_equal "", get_value("make_options")
    assert_equal "", get_value("environment_variables")
    assert_equal "", get_value("header_file_at_analyze")
    assert_equal "", get_value("analyze_tool_config")
    assert_equal "", get_value("others")

    #PJ setting page
    open "/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"
    # Pj setting page
    click $xpath["misc"]["PJ_setting_page"]
    sleep 4
    click $xpath["misc"]["display_page"]
    sleep 4
    # C48
    select "tool_name", "label=QAC++"
    sleep 4
    assert_equal "QAC++ " + _("setting"), get_text("target_tool")
    assert_equal "", get_value("make_options")
    assert_equal "", get_value("environment_variables")
    assert_equal "", get_value("header_file_at_analyze")
    assert_equal "", get_value("analyze_tool_config")
    assert_equal "", get_value("others")

    #logout
    logout

  end

  #C-49
  #Saving of a setup. PU, PJ setting page
  #It changes to a setup of QAC again following the above-mentioned operation.


  def test_049
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)
    # A new PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #Pu index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    click $xpath["misc"]["display_page"]

    type "make_options", "options"


    # Information when the point is saved is displayed on text area.
    select "tool_name", "label=QAC"
    sleep 4
    assert_equal "QAC " + _("setting"), get_text("target_tool")
    assert_equal "options", get_value("make_options")
    assert_equal "", get_value("environment_variables")
    assert_equal "", get_value("header_file_at_analyze")
    assert_equal "", get_value("analyze_tool_config")
    assert_equal "", get_value("others")

    #PJ setting page
    open "/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"
    # Pj setting page
    click $xpath["misc"]["PJ_setting_page"]
    sleep 4
    click $xpath["misc"]["display_page"]
    sleep 4
    type "make_options", "options"
    # C49
    select "tool_name", "label=QAC"
    sleep 4
    assert_equal "QAC " + _("setting"), get_text("target_tool")
    assert_equal "options", get_value("make_options")
    assert_equal "", get_value("environment_variables")
    assert_equal "", get_value("header_file_at_analyze")
    assert_equal "", get_value("analyze_tool_config")
    assert_equal "", get_value("others")



    #logout
    logout

  end

  #C-50
  #Saving of a setup. PU, PJ setting page
  #The setup information of QAC is changed to a setup of QAC++,
  #without [ a display and ] pushing suitably the button "saves a setup" after edit.
  #Then, it returns to a setup of QAC immediately.


  def test_050
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)
    # A new PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #Pu index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    click $xpath["misc"]["display_page"]

    type "make_options", "options"
    click "//input[@value='#{_('Save Setting')}']"
    sleep 4
    # C50
    select "tool_name", "label=QAC++"
    select "tool_name", "label=QAC"

    sleep 4
    assert_equal "options", get_value("make_options")
    assert_equal "", get_value("environment_variables")
    assert_equal "", get_value("header_file_at_analyze")
    assert_equal "", get_value("analyze_tool_config")
    assert_equal "", get_value("others")

    #PJ setting page
    open "/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"
    # Pj setting page
    click $xpath["misc"]["PJ_setting_page"]
    sleep 4
    click $xpath["misc"]["display_page"]
    sleep 4
    type "make_options", "options"
    click "//input[@value='#{_('Save Setting')}']"
    # C50

    select "tool_name", "label=QAC++"
    select "tool_name", "label=QAC"

    sleep 4
    assert_equal "options", get_value("make_options")
    assert_equal "", get_value("environment_variables")
    assert_equal "", get_value("header_file_at_analyze")
    assert_equal "", get_value("analyze_tool_config")
    assert_equal "", get_value("others")


    #logout
    logout

  end

  #C-51
  #Saving of a setup.Task registration page: A setup of QAC
  #The setup information of QAC is displayed using a selection box,
  # edit is added,
  # and the button "which saves a setup" is clicked.


  def test_051
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)
    # A new PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #Task setting page
    open("/task/add_task2/#{@@pu.id}/#{@@pj.id}")
    wait_for_page_to_load "30000"

    #Execution setting tab
    click $xpath["misc"]["execution_setting_tab"]
    sleep 4
    # The message which tells renewal of an execution setup is displayed on the screen upper left.
    type "make_options", "options"
    #Click save a setup button
    click $xpath["misc"]["save_a_setup_button"]
    sleep 4
    assert get_text("log_contents").include?(_("Execution setting was updated."))



    #logout
    logout

  end
  #C-52
  #Saving of a setup. Task registration page: A setup of QAC
  #Following the above-mentioned operation, after once moving to another page,
  # it returns to a registration page again
  # and the text area where change was added as the point is checked.


  def test_052
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)
    # A new PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #Task setting page
    open("/task/add_task2/#{@@pu.id}/#{@@pj.id}")
    wait_for_page_to_load "30000"

    #Execution setting tab
    click $xpath["misc"]["execution_setting_tab"]
    sleep 4
    # The information set is the same as the parents' PJ information set.
    #(Since the page was moved, the update condition of the setup was cleared)
    open("/misc")
    wait_for_page_to_load "30000"
    open("/task/add_task2/#{@@pu.id}/#{@@pj.id}")
    wait_for_page_to_load "30000"
    click $xpath["misc"]["execution_setting_tab"]
    sleep 4
    assert_equal @@pj.analyze_configs[0].make_options||'', get_value("make_options")
    assert_equal @@pj.analyze_configs[0].environment_variables||'', get_value("environment_variables")
    assert_equal @@pj.analyze_configs[0].header_file_at_analyze||'', get_value("header_file_at_analyze")
    assert_equal @@pj.analyze_configs[0].analyze_tool_config||'', get_value("analyze_tool_config")
    assert_equal @@pj.analyze_configs[0].others||'', get_value("others")


    #logout
    logout

  end
  #C-53
  #Saving of a setup. Task registration page: A setup of QAC
  #After displaying the setup information of QAC using a selection box and adding edit,
  #it changes to a setup of QAC++.


  def test_053
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)
    # A new PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #Task setting page
    open("/task/add_task2/#{@@pu.id}/#{@@pj.id}")
    wait_for_page_to_load "30000"

    #Execution setting tab
    click $xpath["misc"]["execution_setting_tab"]
    sleep 4
    # The setup information of contents QAC++ of a total of five text area is replaced.
    select "tool_name", "label=qacpp"
    assert !60.times{ break if ("qacpp " + _("setting") == get_text("target_tool") rescue false); sleep 1 }
    assert_equal @@pj.analyze_configs[1].make_options||'', get_value("make_options")
    assert_equal @@pj.analyze_configs[1].environment_variables||'', get_value("environment_variables")
    assert_equal @@pj.analyze_configs[1].header_file_at_analyze||'', get_value("header_file_at_analyze")
    assert_equal @@pj.analyze_configs[1].analyze_tool_config||'', get_value("analyze_tool_config")
    assert_equal @@pj.analyze_configs[1].others||'', get_value("others")
    sleep 4


    #logout
    logout

  end

  #C-54
  #Saving of a setup. Task registration page: A setup of QAC
  #It changes to a setup of QAC following the above-mentioned operation.


  def test_054
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)
    # A new PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #Task setting page
    open("/task/add_task2/#{@@pu.id}/#{@@pj.id}")
    wait_for_page_to_load "30000"

    #Execution setting tab
    click $xpath["misc"]["execution_setting_tab"]
    sleep 4
    type "make_options", "options"
    click $xpath["misc"]["save_a_setup_button"]
    sleep 4
    # Text area replaces setup information just before changing to a setup of QAC++.
    select "tool_name", "label=qacpp"
    sleep 4
    select "tool_name", "label=qac"
    sleep 4
    assert_equal "options", get_value("make_options")

    #logout
    logout

  end

  #C-55
  #Saving of a setup. Task registration page: A setup of QAC++
  #The setup information of QAC++ is displayed using a selection box,
  # edit is added, and the button "which saves a setup" is clicked.


  def test_055
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)
    # A new PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #Task setting page
    open("/task/add_task2/#{@@pu.id}/#{@@pj.id}")
    wait_for_page_to_load "30000"

    #Execution setting tab
    click $xpath["misc"]["execution_setting_tab"]
    sleep 4
    select "tool_name", "label=qacpp"
    sleep 4
    # The message which tells renewal of an execution setup is displayed on the screen upper left.
    type "make_options", "options"
    #Click save a setup button
    click $xpath["misc"]["save_a_setup_button"]
    sleep 4
    assert get_text("log_contents").include?(_("Execution setting was updated."))


    #logout
    logout

  end

  #C-56
  #Saving of a setup. Task registration page: A setup of QAC++
  #Following the above-mentioned operation, after once moving to another page,
  # it returns to a registration page again
  # and the text area where change was added as the point is checked.


  def test_056
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)
    # A new PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #Task setting page
    open("/task/add_task2/#{@@pu.id}/#{@@pj.id}")
    wait_for_page_to_load "30000"

    #Execution setting tab
    click $xpath["misc"]["execution_setting_tab"]
    sleep 4
    select "tool_name", "label=qacpp"
    sleep 4
    # The information set is the same as the parents' PJ information set.
    #(Since the page was moved, the update condition of the setup was cleared)
    assert_equal @@pj.analyze_configs[1].make_options||'', get_value("make_options")
    assert_equal @@pj.analyze_configs[1].environment_variables||'', get_value("environment_variables")
    assert_equal @@pj.analyze_configs[1].header_file_at_analyze||'', get_value("header_file_at_analyze")
    assert_equal @@pj.analyze_configs[1].analyze_tool_config||'', get_value("analyze_tool_config")
    assert_equal @@pj.analyze_configs[1].others||'', get_value("others")


    #logout
    logout

  end
  #C-57
  #Saving of a setup. Task registration page: A setup of QAC++
  #After displaying the setup information of QAC++ using a selection box and adding edit,
  #it changes to a setup of QAC.


  def test_057
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)
    # A new PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #Task setting page
    open("/task/add_task2/#{@@pu.id}/#{@@pj.id}")
    wait_for_page_to_load "30000"

    #Execution setting tab
    click $xpath["misc"]["execution_setting_tab"]
    sleep 4
    select "tool_name", "label=qacpp"
    sleep 4
    # The setup information of the contents QAC of a total of five text area is replaced.
    select "tool_name", "label=qac"
    assert !60.times{ break if ("qac " + _("setting") == get_text("target_tool") rescue false); sleep 1 }
    assert_equal @@pj.analyze_configs[0].make_options||'', get_value("make_options")
    assert_equal @@pj.analyze_configs[0].environment_variables||'', get_value("environment_variables")
    assert_equal @@pj.analyze_configs[0].header_file_at_analyze||'', get_value("header_file_at_analyze")
    assert_equal @@pj.analyze_configs[0].analyze_tool_config||'', get_value("analyze_tool_config")
    assert_equal @@pj.analyze_configs[0].others||'', get_value("others")
    sleep 4


    #logout
    logout

  end
  #
  #C-58
  #Saving of a setup. Task registration page: A setup of QAC++
  #It changes to a setup of QAC++ following the above-mentioned operation.

  def test_058
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)
    # A new PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #Task setting page
    open("/task/add_task2/#{@@pu.id}/#{@@pj.id}")
    wait_for_page_to_load "30000"

    #Execution setting tab
    click $xpath["misc"]["execution_setting_tab"]
    sleep 4

    # Text area replaces setup information just before changing to a setup of QAC.
    select "tool_name", "label=qac"
    sleep 4
    select "tool_name", "label=qacpp"
    sleep 4
    type "make_options", "options"
    assert_equal "options", get_value("make_options")


    #logout
    logout



  end

  #C-59
  #Saving of a setup. PU, PJ setting page
  #A setup of an analytical rule and a tool is changed suitably
  # and the button "which saves all the setup" is clicked.

  def test_059
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)
    # A new PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #PU index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    click $xpath["misc"]["display_page"]
    sleep 4
    # The message which tells saving of a setup is displayed on the screen upper left.
    type "make_options", "Pu_options"
    #Save all setup button
    click $xpath["misc"]["save_all_setup_button"]
    sleep 4
    assert get_text("log_contents").include?(_("PU setting was saved."))

    #PJ index page
    open "/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"
    # Pj setting page
    click $xpath["misc"]["PJ_setting_page"]
    sleep 4
    click $xpath["misc"]["display_page"]
    sleep 4
    # The message which tells saving of a setup is displayed on the screen upper left.
    type "make_options", "Pj_options"
    click $xpath["misc"]["save_all_setup_button"]
    sleep 4
    assert get_text("log_contents").include?("プロジェクト設定を保存しました。")


    #logout
    logout

  end

  #C-60
  #Saving of a setup. PU, PJ setting page
  #Following the above-mentioned operation, after moving to other pages,
  # it returns to the page again and the contents of a display are checked.

  def test_060
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)
    # A new PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    #Pu index page
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    click $xpath["misc"]["display_page"]
    sleep 4
    type "make_options", "Pu_options"
    #The contents when the last "save all the setup" button is clicked are displayed.
    #PU setting page
    assert_equal "Pu_options", get_value("make_options")
    assert_equal @@pu.analyze_configs[0].environment_variables||'', get_value("environment_variables")
    assert_equal @@pu.analyze_configs[0].header_file_at_analyze||'', get_value("header_file_at_analyze")
    assert_equal @@pu.analyze_configs[0].analyze_tool_config||'', get_value("analyze_tool_config")
    assert_equal @@pu.analyze_configs[0].others||'', get_value("others")
    select "tool_name", "label=QAC++"
    assert !60.times{ break if ("QAC++ " + _("setting") == get_text("target_tool") rescue false); sleep 1 }
    assert_equal @@pu.analyze_configs[1].make_options||'', get_value("make_options")
    assert_equal @@pu.analyze_configs[1].environment_variables||'', get_value("environment_variables")
    assert_equal @@pu.analyze_configs[1].header_file_at_analyze||'', get_value("header_file_at_analyze")
    assert_equal @@pu.analyze_configs[1].analyze_tool_config||'', get_value("analyze_tool_config")
    assert_equal @@pu.analyze_configs[1].others||'', get_value("others")

    #The contents when the last "save all the setup" button is clicked are displayed.
    #PJ settiong page
    open "/misc"
    wait_for_page_to_load "30000"
    #PJ index page
    open "/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"
    # Pj setting page
    click $xpath["misc"]["PJ_setting_page"]
    sleep 4
    click $xpath["misc"]["display_page"]
    sleep 4
    type "make_options", "Pj_options"

    assert_equal "Pj_options", get_value("make_options")
    assert_equal @@pj.analyze_configs[0].environment_variables||'', get_value("environment_variables")
    assert_equal @@pj.analyze_configs[0].header_file_at_analyze||'', get_value("header_file_at_analyze")
    assert_equal @@pj.analyze_configs[0].analyze_tool_config||'', get_value("analyze_tool_config")
    assert_equal @@pj.analyze_configs[0].others||'', get_value("others")
    select "tool_name", "label=QAC++"
    assert !60.times{ break if ("QAC++ " + _("setting") == get_text("target_tool") rescue false); sleep 1 }
    assert_equal @@pj.analyze_configs[1].make_options||'', get_value("make_options")
    assert_equal @@pj.analyze_configs[1].environment_variables||'', get_value("environment_variables")
    assert_equal @@pj.analyze_configs[1].header_file_at_analyze||'', get_value("header_file_at_analyze")
    assert_equal @@pj.analyze_configs[1].analyze_tool_config||'', get_value("analyze_tool_config")
    assert_equal @@pj.analyze_configs[1].others||'', get_value("others")


    #logout
    logout
  end
  #C-61
  #Saving of a setup. PU, PJ setting page
  #A setup of an analytical rule is changed after change,
  # a tab is suitably changed to an execution setup,
  #  and the button "which saves a setup" is clicked.
  #After changing to other pages, the page is displayed again.

  def test_061
    #login
    login
    # PU management page
    open_pu_management_page_1
    #A new PU


    @@pu = Pu.find_by_name('SamplePU1')
    #PJ management page
    open_pj_management_page(@@pu.id)
    # A new PJ


    @@pj = Pj.find_by_name('SamplePJ1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page
    click $xpath["misc"]["PU_setting_page"]
    sleep 4
    click $xpath["misc"]["display_page"]
    sleep 4

    # Change added to the analytical rule is not reflected.
    click $xpath["misc"]["general_control_tab"]
    sleep 4
    type "qac_rule1", "9"
    type "qac_rule2", "9"
    type "qac_rule3", "9"
    type "qacpp_rule1", "10"
    type "qacpp_rule2", "10"
    type "qacpp_rule3", "10"
    click $xpath["misc"]["display_page"]

    sleep 4
    click $xpath["misc"]["save_a_setup_button"]
    sleep 4
    open "/misc"
    wait_for_page_to_load "30000"
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"
    # Pu setting page

    click $xpath["misc"]["PU_setting_page"]

    sleep 4
    assert_equal '', get_value("qac_rule1")
    assert_equal '', get_value("qac_rule2")
    assert_equal '', get_value("qac_rule3")
    assert_equal '', get_value("qacpp_rule1")
    assert_equal '', get_value("qacpp_rule2")
    assert_equal '', get_value("qacpp_rule3")

    click $xpath["misc"]["general_control_tab"]
    sleep 4
    type "qac_rule1", "9"
    type "qac_rule2", "9"
    type "qac_rule3", "9"
    type "qacpp_rule1", "10"
    type "qacpp_rule2", "10"
    type "qacpp_rule3", "10"
    click $xpath["misc"]["save_a_setup_button"]
    sleep 4

    #Change added to the analytical rule is not reflected.
    #PJ setting page
    open "/misc"
    wait_for_page_to_load "30000"
    open "/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"
    # Pj setting page
    click $xpath["misc"]["PJ_setting_page"]
    sleep 4
    click $xpath["misc"]["display_page"]
    sleep 4
    assert_equal '', get_value("qac_rule1")
    assert_equal '', get_value("qac_rule2")
    assert_equal '', get_value("qac_rule3")
    assert_equal '', get_value("qacpp_rule1")
    assert_equal '', get_value("qacpp_rule2")
    assert_equal '', get_value("qacpp_rule3")

    #logout
    logout
  end

end
