require File.dirname(__FILE__) + "/test_b_setup" unless defined? TestBSetup

# Displaying and registration test cases

class TestB1 < Test::Unit::TestCase
  include TestBSetup
  PU_ID2=2
  PU_ID1=1
  NEW_PU_NAME = "SamplePU"
  NEW_PJ_NAME = "SamplePJ"
  FILTER_NAME = "SamplePJ1"
  ## First PU must have at least 1 PJ with the name contains "SamplePJ1"
  # B-01
  # no existed project: The message "PJ is not registered" is displayed.
  def test_001
    Pj.destroy_all
    open_pj_management_page(PU_ID2)
    begin
      wait_for_text_present(_("PJ Administration"))
      wait_for_text_present(_("No PJ has been registered"))
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    make_original
  end

  # B-02
  # no existed project: A search box and a table are not displayed.
  def test_002
    Pj.destroy_all
    open_pj_management_page(PU_ID2)
    begin
      wait_for_element_not_present('find_box')
      wait_for_element_not_present("//table[contains(@class, 'form1')]")
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    make_original
  end

  # B-03
  # A search box is displayed.
  def test_003
    # SamplePU1 (first PU) has 1 pj
    open_pj_management_page(PU_ID1)
    wait_for_element_present('find_box')
    logout
  end

  # B-04
  # A table of project is displayed
  def test_004
    # SamplePU1 (first PU) has 1 pj
    open_pj_management_page(PU_ID1)
    wait_for_element_present("//table[contains(@class, 'form1')]")
    logout
  end

  # B-05
  # Compare with the number of Pj on a database.
  def test_005
    # SamplePU1 (first PU) has 1 pj
    pu = Pu.find(:first)
    pjs = Pj.find_all_by_pu_id(pu.id)
    no_pj = pjs.length

    open_pj_management_page(pu.id)
    assert_equal no_pj, get_xpath_count("//div[@id='right_contents']/div[1]/div[2]/table[2]/tbody[2]/tr")
    logout
  end

  # B-6
  # Compare with the number of Pj member on a database.
  def test_006
    # SamplePU1 (first PU) has 1 pj
    pu = Pu.find(:first)
    pjs = Pj.find_all_by_pu_id(pu.id)
    no_pj = pjs.length

    open_pj_management_page(pu.id)
    assert_equal _("Number of users"), get_table("//div[@id='right_contents']/div[1]/div[2]/table[2].0.2")

    for i in 1..no_pj
      pj_id = get_table("//div[@id='right_contents']/div[1]/div[2]/table[2].#{i}.0").to_i
      pj_users = PjsUsers.find_all_by_pj_id(pj_id)
      assert_equal pj_users.length.to_s, get_table("//div[@id='right_contents']/div[1]/div[2]/table[2].#{i}.2")
    end
    logout
  end

  # B-7
  # a subwindow is displayed
  def test_007
    # SamplePU1 (first PU) has 1 pj
    pu = Pu.find(:first)

    open_pj_registration_page(pu.id)
    wait_for_text_present(_("Create New Project"))
    logout
  end

  # B-8
  # no existed project
  # Only "not inheritance" is displayed as a choice of PJ inheritance.
  def test_008
    # SamplePU2 (last PU) has no pj
    Pj.destroy_all
    pu = Pu.find(:last)

    open_pj_registration_page(pu.id)
    xp_tmp = "//div[@id='add_pj_window']/form/table[2]/tbody/tr[2]/td[1]/ul/li"
    begin
      assert_equal 1, get_xpath_count(xp_tmp)
      wait_for_element_text(xp_tmp, _("Not inherit."))
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    make_original
  end

  # B-9
  # "not inheritance" +admin_pu page are displayed as choices for PU inheritance
  def test_009
    # SamplePU1 (first PU) has at least 1 pj
    pu = Pu.find(:first)
    open_pj_registration_page(pu.id)

    pjs = Pj.find_all_by_pu_id(pu.id)
    no_line = pjs.length
    xp_tmp = "//div[@id='add_pj_window']/form/table[2]/tbody/tr[2]/td[1]/ul/li"
    assert_equal no_line + 1, get_xpath_count(xp_tmp)
    wait_for_element_text(xp_tmp + "[#{1}]", _("Not inherit."))

    for n in 1..no_line
      wait_for_element_text("//div[@id='add_pj_window']/form/table[2]/tbody/tr[2]/td[1]/ul/li[#{n+1}]", "SamplePJ" + n.to_s)
    end
    logout
  end

  def test_010
    printf "\n+ This is not a test case!"
    assert true
  end

  # B-11
  # filtering
  def test_011
    # SamplePU1 (first PU) has at least 1 pj
    pu = Pu.find(:first)
    open_pj_management_page(pu.id)
    filtering(FILTER_NAME)
    fil_rlt_no = get_xpath_count("//tbody[@id='pj_list']/tr")

    bEmpty = is_text_present(_("A project does not exist"))

    # get names of all pjs after filtering
    if (!bEmpty) # if the result of filtering is not empty
      arr = Array.new
      for i in 1..fil_rlt_no
        arr[i] = get_text("//tbody[@id='pj_list']/tr[" + i.to_s + "]/td[2]")
      end
    end

    # go to registration page
    click "link=[#{_('Register')}]"
    sleep 2

    xp_tmp = "//div[@id='add_pj_window']/form/table[2]/tbody/tr[2]/td[1]/ul/li"
    if (!bEmpty) # if the result of filtering is not empty
      assert_equal fil_rlt_no + 1, get_xpath_count(xp_tmp)
      wait_for_element_text(xp_tmp + "[1]", _("Not inherit."))
      for j in 2..fil_rlt_no
        wait_for_element_text(xp_tmp + "[" + j.to_s + "]", arr[j-1])
      end
    else
      assert_equal 1, get_xpath_count(xp_tmp)
      wait_for_element_text(xp_tmp + "[1]", _("Not inherit."))
    end

    logout
  end

  # B-12
  # Selection of the item to inherit
  def test_012
    pu = Pu.find(:first)
    open_pj_registration_page(pu.id)
    wait_for_text_present(_("Administrator and member"))
    wait_for_text_present(_("Analysis tool setting."))
    logout
  end

  # B-13
  # No existed project: register new project successfully
  def test_013
    pu = Pu.find(:last)
    register_pj(pu.id, NEW_PJ_NAME)
    assert !@selenium.is_text_present(_("No PJ has been registered"))
    pj = Pj.find(:last)
    # A search box and a table are displayed.
    wait_for_element_present('find_box')
    wait_for_element_present("//table[contains(@class, 'form1')]")
    sleep 10
    # PJ list are displayed on a screen
    assert get_text("log_contents").include?(_('Project')+' 「' + NEW_PJ_NAME + '」 '+_('register-.'))
    last_pj = get_xpath_count("//tbody[@id='pj_list']/tr")
    wait_for_element_text("//tbody[@id='pj_list']/tr[#{last_pj}]/td[2]", NEW_PJ_NAME)
    logout
    Pj.delete(pj.id)
  end

  # B-14
  # Project registration is failed (because of empty name)
  def test_014
    pu = Pu.find(:first)
    old_pjs = Pj.find_all_by_pu_id(pu.id)
    register_pj(pu.id,'')
    assert get_text("log_contents").include?(_("Failed to register project. Project name is not specified. "))

    # PJ is not added
    new_pjs = Pj.find_all_by_pu_id(pu.id)
    assert_equal old_pjs.count, new_pjs.count
  end

  def test_015
    printf "\n+ This is not a test case!"
    assert true
  end

  # B-16
  # inheritance agency PJ un-choosing.
  def test_016
    pu = Pu.find(:first)
    register_pj(pu.id, NEW_PJ_NAME)
    last_row = get_xpath_count($xpath["pj"]["pj_list_row"])
    assert_equal NEW_PJ_NAME,@selenium.get_text($xpath["pj"]["pj_list_row"]+"[#{last_row}]/td[2]")
    pj = Pj.find(:last)
    # open PJ setting page after registering PJ
    open_pj_setting_page(pu.id, pj.id)
    # the parents' PU thing is inherited
    assert_equal _("Analysis Rule Setting"), get_text("//table[@id='analyze_rule_numbers']/tbody/tr[1]/th")
    for j in 1..3
      assert_equal pu.analyze_rule_configs[j-1].rule_numbers||'', get_value("qac_rule" + j.to_s) # 0 to 2
      assert_equal pu.analyze_rule_configs[j+2].rule_numbers||'', get_value("qacpp_rule" + j.to_s) # 3 to 5
    end

    click "link=#{_('Execution Setting')}"
    assert_equal _("Executing Setting"), get_text("//div[@id='tool_setting']/table[1]/tbody/tr[1]/th")
    assert is_text_present("QAC " + _("setting"))
    check_pu_setting_value(pu, 0)

    select "tool_name", "label=QAC++"
    wait_for_element_text("target_tool", "QAC++ " + _("setting"))
    check_pu_setting_value(pu, 1)

    Pj.delete(pj.id)
    logout
  end

  # B-17
  # chooses "no inheritance" as the inheritance agency PJ
  def test_017
    pu = Pu.find(:first)
    register_pj(pu.id, NEW_PJ_NAME, ["project_original_0"])
    last_row = get_xpath_count($xpath["pj"]["pj_list_row"])
    assert_equal NEW_PJ_NAME,@selenium.get_text($xpath["pj"]["pj_list_row"]+"[#{last_row}]/td[2]")
    pj = Pj.find(:last)
    # open PJ setting page after registering PJ
    open_pj_setting_page(pu.id, pj.id)

    # the parents' PU thing is inherited
    assert_equal _("Analysis Rule Setting"), get_text("//table[@id='analyze_rule_numbers']/tbody/tr[1]/th")
    for j in 1..3
      assert_equal pu.analyze_rule_configs[j-1].rule_numbers||'', get_value("qac_rule" + j.to_s) # 0 to 2
      assert_equal pu.analyze_rule_configs[j+2].rule_numbers||'', get_value("qacpp_rule" + j.to_s) # 3 to 5
    end

    click "link=#{_('Execution Setting')}"
    assert_equal _("Executing Setting"), get_text("//div[@id='tool_setting']/table[1]/tbody/tr[1]/th")
    assert is_text_present("QAC " + _("setting"))
    check_pu_setting_value(pu, 0)

    select "tool_name", "label=QAC++"
    wait_for_element_text("target_tool", "QAC++ " + _("setting"))
    check_pu_setting_value(pu, 1)

    logout
    Pj.delete(pj.id)
  end

  # B-18
  # chooses project "pj" as the inheritance agency PJ
  # but don't choose any inheritance item
  def test_018
    pu = Pu.find(:first)
    old_pj = Pj.find(:first)

    register_pj(pu.id, NEW_PJ_NAME, ["project_original_" + old_pj.id.to_s])
    last_row = get_xpath_count($xpath["pj"]["pj_list_row"])
    assert_equal NEW_PJ_NAME,@selenium.get_text($xpath["pj"]["pj_list_row"]+"[#{last_row}]/td[2]")
    new_pj = Pj.find(:last)

    # open PJ setting page after registering PJ
    open_pj_setting_page(pu.id, new_pj.id)

    wait_for_element_text("//table[@id='analyze_rule_numbers']/tbody/tr[1]/th", _("Analysis Rule Setting"))
    for j in 1..3
      assert_equal pu.analyze_rule_configs[j-1].rule_numbers||'', get_value("qac_rule" + j.to_s) # 0 to 2
      assert_equal pu.analyze_rule_configs[j+2].rule_numbers||'', get_value("qacpp_rule" + j.to_s) # 3 to 5
    end

    click "link=#{_('Execution Setting')}"
    wait_for_element_text("//div[@id='tool_setting']/table[1]/tbody/tr[1]/th", _("Executing Setting"))
    assert is_text_present("QAC " + _("setting"))
    check_pu_setting_value(pu, 0)

    select "tool_name", "label=QAC++"
    wait_for_element_text("target_tool", "QAC++ " + _("setting"))
    check_pu_setting_value(pu, 1)

    # Pj member list is not inherited
    click "link=#{_('PJ Member Listing')}"
    sleep 2
    assert is_text_present(_("PJ member is not registered."))

    logout
    Pj.delete(new_pj.id)
  end

  # B-19
  # chooses "it does not inherit" as the inheritance agency PJ
  # go to PJ setting page
  def test_019
    pu = Pu.find(:first)

    register_pj(pu.id, NEW_PJ_NAME, ["project_original_0", "project_member", "project_tool_conf"])
    last_row = get_xpath_count($xpath["pj"]["pj_list_row"])
    assert_equal NEW_PJ_NAME,@selenium.get_text($xpath["pj"]["pj_list_row"]+"[#{last_row}]/td[2]")
    new_pj = Pj.find(:last)

    # open PJ setting page after registering PJ
    open_pj_setting_page(pu.id, new_pj.id)

    # the parents' PU thing is inherited
    wait_for_element_text("//table[@id='analyze_rule_numbers']/tbody/tr[1]/th", _("Analysis Rule Setting"))
    for j in 1..3
      assert_equal pu.analyze_rule_configs[j-1].rule_numbers||'', get_value("qac_rule" + j.to_s) # 0 to 2
      assert_equal pu.analyze_rule_configs[j+2].rule_numbers||'', get_value("qacpp_rule" + j.to_s) # 3 to 5
    end

    click "link=#{_('Execution Setting')}"
    wait_for_element_text("//div[@id='tool_setting']/table[1]/tbody/tr[1]/th", _("Executing Setting"))
    wait_for_text_present("QAC " + _("setting"))
    check_pu_setting_value(pu, 0)

    select "tool_name", "label=QAC++"
    wait_for_element_text("target_tool", "QAC++ " + _("setting"))
    check_pu_setting_value(pu, 1)

    # Pj member list, not inherited
    click "link=#{_('PJ Member Listing')}"
    wait_for_text_present(_("PJ member is not registered."))

    logout
    Pj.delete(new_pj.id)
  end

  # B-20
  # chooses project "pj" as the inheritance agency PJ
  # choose only tools setting as inheritance item
  def test_020
    pu = Pu.find(:first)
    old_pj = Pj.find(:first)

    register_pj(pu.id, NEW_PJ_NAME, ["project_original_" + old_pj.id.to_s, "project_tool_conf"])
    last_row = get_xpath_count($xpath["pj"]["pj_list_row"])
    assert_equal NEW_PJ_NAME,@selenium.get_text($xpath["pj"]["pj_list_row"]+"[#{last_row}]/td[2]")
    new_pj = Pj.find(:last)

    # open PJ setting page after registering PJ
    open_pj_setting_page(pu.id, new_pj.id)

    # the thing of system construction is inherited
    # each setting item is inherited
    wait_for_element_text("//table[@id='analyze_rule_numbers']/tbody/tr[1]/th", _("Analysis Rule Setting"))
    for j in 1..3
      assert_equal pu.analyze_rule_configs[j-1].rule_numbers||'', get_value("qac_rule" + j.to_s) # 0 to 2
      assert_equal pu.analyze_rule_configs[j+2].rule_numbers||'', get_value("qacpp_rule" + j.to_s) # 3 to 5
    end

    click "link=#{_('Execution Setting')}"
    wait_for_element_text("//div[@id='tool_setting']/table[1]/tbody/tr[1]/th", _("Executing Setting"))
    wait_for_text_present("QAC " + _("setting"))
    check_pj_setting_value(new_pj, 0)

    select "tool_name", "label=QAC++"
    wait_for_element_text("target_tool", "QAC++ " + _("setting"))
    check_pj_setting_value(new_pj, 1)

    # Pj member list, not inherited
    click "link=#{_('PJ Member Listing')}"
    wait_for_text_present(_("PJ member is not registered."))

    logout
    Pj.delete(new_pj.id)
  end

  # B-21
  # chooses project "pj" as the inheritance agency PJ
  # choose only Pj members & admins as inheritance item
  def test_021
    pu = Pu.find(:first)
    old_pj = Pj.find(:first)
    pj_user = PjsUsers.find_by_pj_id(old_pj.id)
    user = User.find(pj_user.user_id)

    register_pj(pu.id, NEW_PJ_NAME, ["project_original_" + old_pj.id.to_s, "project_member"])
    last_row = get_xpath_count($xpath["pj"]["pj_list_row"])
    assert_equal NEW_PJ_NAME,@selenium.get_text($xpath["pj"]["pj_list_row"]+"[#{last_row}]/td[2]")
    new_pj = Pj.find(:last)

    # open PJ setting page after registering PJ
    open_pj_setting_page(pu.id, new_pj.id)

    wait_for_element_text("//table[@id='analyze_rule_numbers']/tbody/tr[1]/th", _("Analysis Rule Setting"))
    for j in 1..3
      assert_equal pu.analyze_rule_configs[j-1].rule_numbers||'', get_value("qac_rule" + j.to_s) # 0 to 2
      assert_equal pu.analyze_rule_configs[j+2].rule_numbers||'', get_value("qacpp_rule" + j.to_s) # 3 to 5
    end

    click "link=#{_('Execution Setting')}"
    wait_for_element_text("//div[@id='tool_setting']/table[1]/tbody/tr[1]/th", _("Executing Setting"))
    wait_for_text_present("QAC " + _("setting"))
    check_pu_setting_value(pu, 0)

    select "tool_name", "label=QAC++"
    wait_for_element_text("target_tool", "QAC++ " + _("setting"))
    check_pu_setting_value(pu, 1)

    # Pj member list
    click "link=#{_('PJ Member Listing')}"
    sleep 2

    # inherit member
    assert_equal user.id.to_s, get_text("//div[@id='right_contents']/div/table/tbody/tr[2]/td[1]")
    assert_equal user.account_name, get_text("//div[@id='right_contents']/div/table/tbody/tr[2]/td[2]")
    assert_equal user.fullname(1), get_text("//div[@id='right_contents']/div/table/tbody/tr[2]/td[3]")
    assert_equal user.nick_name, get_text("//div[@id='right_contents']/div/table/tbody/tr[2]/td[4]")
    assert_equal user.email, get_text("//div[@id='right_contents']/div/table/tbody/tr[2]/td[5]")

    logout
    Pj.delete(new_pj.id)
  end

  # B-22
  # chooses project "pj" as the inheritance agency PJ
  # choose both of inheritance items
  def test_022
    pu = Pu.find(:first)
    old_pj = Pj.find(:first)
    pj_user = PjsUsers.find_by_pj_id(old_pj.id)
    user = User.find(pj_user.user_id)

    register_pj(pu.id, NEW_PJ_NAME, ["project_original_" + old_pj.id.to_s, "project_member", "project_tool_conf"])
    last_row = get_xpath_count($xpath["pj"]["pj_list_row"])
    assert_equal NEW_PJ_NAME,@selenium.get_text($xpath["pj"]["pj_list_row"]+"[#{last_row}]/td[2]")
    new_pj = Pj.find(:last)

    # open PJ setting page after registering PJ
    open_pj_setting_page(pu.id, new_pj.id)

    # each setting item is inherited
    wait_for_element_text("//table[@id='analyze_rule_numbers']/tbody/tr[1]/th", _("Analysis Rule Setting"))
    for j in 1..3
      assert_equal pu.analyze_rule_configs[j-1].rule_numbers||'', get_value("qac_rule" + j.to_s) # 0 to 2
      assert_equal pu.analyze_rule_configs[j+2].rule_numbers||'', get_value("qacpp_rule" + j.to_s) # 3 to 5
    end

    click "link=#{_('Execution Setting')}"
    wait_for_element_text("//div[@id='tool_setting']/table[1]/tbody/tr[1]/th", _("Executing Setting"))
    wait_for_text_present("QAC " + _("setting"))
    check_pj_setting_value(old_pj, 0)

    select "tool_name", "label=QAC++"
    wait_for_element_text("target_tool", "QAC++ " + _("setting"))
    check_pj_setting_value(old_pj, 1)

    # Pj member list
    click "link=#{_('PJ Member Listing')}"
    sleep 2
    assert_equal user.id.to_s, get_text("//div[@id='right_contents']/div/table/tbody/tr[2]/td[1]")
    assert_equal user.account_name, get_text("//div[@id='right_contents']/div/table/tbody/tr[2]/td[2]")
    assert_equal user.fullname(1), get_text("//div[@id='right_contents']/div/table/tbody/tr[2]/td[3]")
    assert_equal user.nick_name, get_text("//div[@id='right_contents']/div/table/tbody/tr[2]/td[4]")
    assert_equal user.email, get_text("//div[@id='right_contents']/div/table/tbody/tr[2]/td[5]")

    logout
    Pj.delete(new_pj.id)
  end

  # B-23
  # It returns to PJ management screen when X button of the subwindow upper part is clicked.
  def test_023
    pu = Pu.find(:last)
    open_pj_registration_page(pu.id)
    window_id = get_attribute("//body/div[2]", "id")
    click window_id + "_close"
    wait_for_element_text("//div[@id='right_contents']/div/h3", _("PJ Administration"))
    logout
  end

  def test_024
    printf "\n+ This is not a test case!"
    assert true
  end

  # B-25
  # Compare with the number of Pj on a database.
  def test_025
    pu = Pu.find(:first)
    pjs = Pj.find_all_by_pu_id(pu.id)
    no_pj = pjs.length
    open_pj_management_page(pu.id)
    assert_equal no_pj, get_xpath_count("//div[@id='right_contents']/div[1]/div[2]/table[2]/tbody[2]/tr")
    logout
  end

  # B-26
  # Compare with the number of Pj member on a database.
  def test_026
    pu = Pu.find(:first)
    pjs = Pj.find_all_by_pu_id(pu.id)
    no_pj = pjs.length

    open_pj_management_page(pu.id)
    assert_equal _("Number of users"), get_table("//div[@id='right_contents']/div[1]/div[2]/table[2].0.2")
    for i in 1..no_pj
      pj_id = get_table("//div[@id='right_contents']/div[1]/div[2]/table[2].#{i}.0").to_i
      pj_users = PjsUsers.find_all_by_pj_id(pj_id)
      assert_equal pj_users.length.to_s, get_table("//div[@id='right_contents']/div[1]/div[2]/table[2].#{i}.2")
    end
    logout
  end

end