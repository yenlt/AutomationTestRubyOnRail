require File.dirname(__FILE__) + "/test_a_setup" unless defined? TestASetup

class TestA2 < Test::Unit::TestCase
  include TestASetup
  FIRST_PU_ID = 1
  # name of pu which will be added to test
  NEW_PU_NAME = "Sample"
  FILTER_NAME = "SamplePU1"

  # A-7
  # a subwindow is displayed
  def test_007
    open_pu_registration_page
    assert is_text_present(_("Create New PU"))

    # return the parent page
    run_script "destroy_subwindow()"
    wait_for_element_text("//div[@id='right_contents']/div/h3", _("PU Administration"))
    logout
  end
  # A-8
  # Only "not inheritance" is displayed as a choice of PU inheritance.
  def test_008
    # delete all existed projects
    delete_all_pus
    begin
      open_pu_registration_page
      xp_tmp = "//div[@id='add_pu_window']/form/table[2]/tbody/tr[2]/td[1]/ul/li"
      assert_equal 1,get_xpath_count(xp_tmp)
      wait_for_element_text(xp_tmp, _("Not inherit"))

      # return the parent page
      run_script "destroy_subwindow()"
      wait_for_element_text("//div[@id='right_contents']/div/h3", _("PU Administration"))
      logout
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    # return original data
    make_original_pus
  end
  # A-9
  # "not inheritance" and admin_pu page are displayed as choices for PU inheritance
  def test_009
    open_pu_registration_page
    pus = Pu.find(:all)
    no_line = pus.length + 1
    xp_tmp = "//div[@id='add_pu_window']/form/table[2]/tbody/tr[2]/td[1]/ul/li"
    assert_equal no_line,get_xpath_count(xp_tmp)
    wait_for_element_text(xp_tmp + "[1]", _("Not inherit"))

    # the format of PU's name must be similar to pus.yml (SamplePUn: n = 1, 2, ...)
    for n in 1..2
      assert_equal "SamplePU" + n.to_s,get_text("//div[@id='add_pu_window']/form/table[2]/tbody/tr[2]/td[1]/ul/li[#{n+1}]")
    end
    # return the parent page
    run_script "destroy_subwindow()"
    assert_equal _("PU Administration"), get_text("//div[@id='right_contents']/div/h3")#
    logout
  end

  # A-10
  # PU which can be chosen as a inheritance agency includes "it does not inherit", and is only one project.
  def test_010
    printf "\n+ This is not a test case!"
    assert true
  end


  # A-11
  # We have two cases: - There is not any remained project after filtering
  #                   - There is one or some PJ after filtering
  def test_011
    open_pu_management_page
    filtering(FILTER_NAME)
    fil_rlt_no = get_xpath_count("//tbody[@id='pu_list']/tr")

    # get names of all PUs after filtering

    isPuEmpty = is_text_present(_("A PU does not exist."))

    if (!isPuEmpty) # if the result of filtering is not empty
      arr = Array.new
      for i in 1..fil_rlt_no
        arr[i] = get_text("//tbody[@id='pu_list']/tr[" + i.to_s + "]/td[2]")
      end
    end

    click "link=[#{_("Register")}]"
    sleep 2

    xp_tmp = "//div[@id='add_pu_window']/form/table[2]/tbody/tr[2]/td[1]/ul/li"
    if (!isPuEmpty) # if the result of filtering is not empty
      assert_equal fil_rlt_no + 1, get_xpath_count(xp_tmp)
      assert_equal _("Not inherit"), get_text(xp_tmp + "[1]")
      for j in 2..fil_rlt_no
        assert_equal arr[j-1], get_text(xp_tmp + "[" + j.to_s + "]")
      end
    else
      assert_equal 1, get_xpath_count(xp_tmp)
      assert_equal _("Not inherit"), get_text(xp_tmp + "[1]")
    end

    # return the parent page
    run_script "destroy_subwindow()"
    logout
  end

  # A-12
  # Selection of the item to inherit
  def test_012
    open_pu_registration_page
    assert is_text_present(_("Administrator and member"))
    assert is_text_present(_("Analysis Tool setting"))
    # return the parent page
    run_script "destroy_subwindow()"
    wait_for_element_text("//div[@id='right_contents']/div/h3", _("PU Administration"))
    logout
  end
  # A-13
  # PU is registered
  def test_013
    # delete all existed projects
    delete_all_pus
    begin
      # create data for testing
      register_pu(NEW_PU_NAME)
      assert is_text_present(NEW_PU_NAME)
      new_pu = Pu.find(:last)

      # A search box and a table are displayed.
      wait_for_element_present('class=form1')
      wait_for_element_present('query')

      # assert get_text("log_contents").include?('プロジェクトユニット「'+ NEW_PU_NAME +'」登録.')

      # PU list are displayed on a screen
      wait_for_element_present(xpath["pu_management"]["search_box"])
      wait_for_element_present(xpath["pu_management"]["pu_table"])
      assert_equal NEW_PU_NAME, get_table("//div[@id='right_contents']/div/table[2].1.1")

      logout
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    make_original_pus
  end

  # A-14
  # It is "project unit registration failure . to a log part
  def test_014
    # PU's registration without inputting PU name
    register_pu('')
    assert get_text("log_contents").include?(_("Failed to register project. PU name is not specified."))
    # The message "PU is not registered" is displayed
    wait_for_text_present(_("Failed to register project. PU name is not specified."))
    logout
  end

  # A-15
  # PU is not added
  def test_015
    old_pu = Pu.find(:all)
    register_pu('')
    pu = Pu.find(:all)
    assert_equal old_pu.length, pu.length
    logout
  end

  #A-16
  def test_016
    printf "\n+ This is not a test case!"
    assert true
  end

  # A-17
  # inheritance agency PU un-choosing
  def test_017
    register_pu(NEW_PU_NAME)
    new_pu=Pu.find(:last)
    last_row = get_xpath_count($xpath["pu"]["pu_list_row"])
    assert_equal NEW_PU_NAME,@selenium.get_text($xpath["pu"]["pu_list_row"]+"[#{last_row}]/td[2]")
    open_pu_setting_page(NEW_PU_NAME)
    # the thing of system construction is inherited, each setting item is blank
    assert_equal _("Analysis Rule Setting"), get_text("//table[@id='analyze_rule_numbers']/tbody/tr[1]/th")
    for j in 1..3
      assert_equal "", get_value("qac_rule" + j.to_s)
      assert_equal "", get_value("qacpp_rule" + j.to_s)
    end
    click "link=#{_('Execution Setting')}"
    wait_for_element_text("//div[@id='tool_setting']/table[1]/tbody/tr[1]/th", _("Executing Setting"))
    check_pu_setting_blank

    select "tool_name", "label=QAC++"
    qacpp = "QAC++ "+_("setting")
    wait_for_element_text("target_tool", qacpp)
    check_pu_setting_blank
    logout
    Pu.delete(new_pu.id)
  end

  # A-18
  # chooses "it does not inherit" as the inheritance agency PU
  def test_018
    register_pu(NEW_PU_NAME, ["project_unit_original_0", "project_unit_member", "project_unit_tool_conf"])
    new_pu=Pu.find(:last)
    last_row = get_xpath_count($xpath["pu"]["pu_list_row"])
    assert_equal NEW_PU_NAME,@selenium.get_text($xpath["pu"]["pu_list_row"]+"[#{last_row}]/td[2]")
    open_pu_setting_page(NEW_PU_NAME)

    # the thing of system construction is inherited
    # each setting item is blank
    assert_equal _("Analysis Rule Setting"), get_text("//table[@id='analyze_rule_numbers']/tbody/tr[1]/th")
    for j in 1..3
      assert_equal "", get_value("qac_rule" + j.to_s)
      assert_equal "", get_value("qacpp_rule" + j.to_s)
    end

    click "link=#{_('Execution Setting')}"
    wait_for_element_text("//div[@id='tool_setting']/table[1]/tbody/tr[1]/th", _("Executing Setting"))
    qac = "QAC "+"#{_('setting')}"
    assert is_text_present(qac)
    check_pu_setting_blank

    qacpp = "QAC++ "+"#{_('setting')}"
    select "tool_name", "label=QAC++"
    wait_for_element_text("target_tool", qacpp)
    check_pu_setting_blank
    logout
    Pu.delete(new_pu.id)

  end

  # A-19
  # chooses project unit "pu" as the inheritance agency PU
  # but don't choose any inheritance item
  def test_019
    old_pu= Pu.find(:first)
    register_pu(NEW_PU_NAME, ["project_unit_original_" + FIRST_PU_ID.to_s])
    new_pu=Pu.find(:last)

    last_row = get_xpath_count($xpath["pu"]["pu_list_row"])
    assert_equal NEW_PU_NAME,@selenium.get_text($xpath["pu"]["pu_list_row"]+"[#{last_row}]/td[2]")
    open_pu_setting_page(NEW_PU_NAME)

    # the thing of system construction is inherited, each setting item is blank
    assert_equal _("Analysis Rule Setting"), get_text("//table[@id='analyze_rule_numbers']/tbody/tr[1]/th")
    for j in 1..3
      assert_equal "", get_value("qac_rule" + j.to_s)
      assert_equal "", get_value("qacpp_rule" + j.to_s)
    end

    click "link=#{_('Execution Setting')}"
    assert_equal _("Executing Setting"), get_text("//div[@id='tool_setting']/table[1]/tbody/tr[1]/th")
    qac = "QAC "+"#{_('setting')}"
    assert is_text_present(qac)
    check_pu_setting_blank

    qacpp = "QAC++ "+"#{_('setting')}"
    select "tool_name", "label=QAC++"
    wait_for_element_text("target_tool", qacpp)
    check_pu_setting_blank

    # Pu member list, not inherited
    click "link=#{_('PU Member Listing')}"
    wait_for_text_present(_("No PU has been registered."))
    logout
    Pu.delete(new_pu.id)

  end

  # A-20
  # chooses project unit "pu" as the inheritance agency PU
  # choose only tools setting as inheritance item
  def test_020
    old_pu= Pu.find(:first)
    register_pu(NEW_PU_NAME,["project_unit_original_" + FIRST_PU_ID.to_s, "project_unit_tool_conf"])
    new_pu=Pu.find(:last)

    last_row = get_xpath_count($xpath["pu"]["pu_list_row"])
    assert_equal NEW_PU_NAME,@selenium.get_text($xpath["pu"]["pu_list_row"]+"[#{last_row}]/td[2]")
    open_pu_setting_page(NEW_PU_NAME)

    # the thing of system construction is inherited, each setting item is inherited
    wait_for_element_text("//table[@id='analyze_rule_numbers']/tbody/tr[1]/th", _("Analysis Rule Setting"))
    for j in 1..3
      assert_equal old_pu.analyze_rule_configs[j-1].rule_numbers||'', get_value("qac_rule" + j.to_s) # 0 to 2
      assert_equal old_pu.analyze_rule_configs[j+2].rule_numbers||'', get_value("qacpp_rule" + j.to_s) # 3 to 5
    end

    click "link=#{_('Execution Setting')}"
    wait_for_element_text("//div[@id='tool_setting']/table[1]/tbody/tr[1]/th", _("Executing Setting"))
    qac = "QAC "+"#{_('setting')}"
    wait_for_text_present(qac)
    check_pu_setting_value( old_pu, 0)

    select "tool_name", "label=QAC++"
    qacpp = "QAC++ "+"#{_('setting')}"
    wait_for_element_text("target_tool", qacpp)
    check_pu_setting_value( old_pu, 1)

    # Pu member list, not inherited
    click "link=#{_('PU Member Listing')}"
    wait_for_text_present(_("No PU has been registered."))
    logout
    Pu.delete(new_pu.id)
    logout
  end
end