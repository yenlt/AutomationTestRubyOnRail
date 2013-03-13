require File.dirname(__FILE__) + "/test_a_setup" unless defined? TestASetup

class TestA3 < Test::Unit::TestCase
  include TestASetup
  FIRST_PU_ID = 1
  NEW_PU_NAME = "Sample"

  # A-21
  # chooses project unit "pu" as the inheritance agency PU
  # choose "setup of tool"
  def test_021
    old_pu= Pu.find(:first)
    register_pu(NEW_PU_NAME,["project_unit_original_" + FIRST_PU_ID.to_s, "project_unit_tool_conf"])
    new_pu=Pu.find(:last)
    begin
      last_row = get_xpath_count($xpath["pu"]["pu_list_row"])
      assert_equal NEW_PU_NAME,@selenium.get_text($xpath["pu"]["pu_list_row"]+"[#{last_row}]/td[2]")
      open_pu_setting_page(NEW_PU_NAME)
      assert_equal _("Analysis Rule Setting"), get_text("//table[@id='analyze_rule_numbers']/tbody/tr[1]/th")
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
      logout
      Pu.delete(new_pu.id)
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
  end

  # A-22
  # chooses project unit "pu" as the inheritance agency PU
  # choose only Pu members & admins as inheritance item
  def test_022
    old_pu= Pu.find(:first)
    pu_user = PusUsers.find_by_pu_id(  FIRST_PU_ID )
    user = User.find(pu_user.user_id)
    register_pu(NEW_PU_NAME,["project_unit_original_" + FIRST_PU_ID.to_s, "project_unit_member"])
    new_pu=Pu.find(:last)
    begin
      last_row = get_xpath_count($xpath["pu"]["pu_list_row"])
      assert_equal NEW_PU_NAME,@selenium.get_text($xpath["pu"]["pu_list_row"]+"[#{last_row}]/td[2]")
      open_pu_setting_page(NEW_PU_NAME)
      # the thing of system construction isn't inherited
      # each setting item is blank
      assert_equal _("Analysis Rule Setting"), get_text("//table[@id='analyze_rule_numbers']/tbody/tr[1]/th")
      for j in 1..3
        assert_equal "", get_value("qac_rule" + j.to_s)
        assert_equal "", get_value("qacpp_rule" + j.to_s)
      end

      click "link=#{_('Execution Setting')}"
      wait_for_element_text("//div[@id='tool_setting']/table[1]/tbody/tr[1]/th", "#{_('Executing Setting')}")
      qac = "QAC "+"#{_('setting')}"
      wait_for_text_present(qac)
      check_pu_setting_blank

      select "tool_name", "label=QAC++"
      qacpp = "QAC++ "+"#{_('setting')}"
      wait_for_element_text("target_tool", qacpp)
      check_pu_setting_blank

      # Pu member list
      click "link=#{_('PU Member Listing')}"
      sleep 2
      # inherit member
      assert_equal user.id.to_s, get_text("//div[@id='right_contents']/div/table/tbody/tr[2]/td[1]")
      assert_equal user.account_name, get_text("//div[@id='right_contents']/div/table/tbody/tr[2]/td[2]")
      assert_equal user.fullname(1), get_text("//div[@id='right_contents']/div/table/tbody/tr[2]/td[3]")
      assert_equal user.nick_name, get_text("//div[@id='right_contents']/div/table/tbody/tr[2]/td[4]")
      assert_equal user.email, get_text("//div[@id='right_contents']/div/table/tbody/tr[2]/td[5]")
      logout
      Pu.delete(new_pu.id)
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
  end

  # A-23
  # chooses project unit "pu" as the inheritance agency PU
  # choose both of inheritance items
  def test_023
    old_pu= Pu.find(:first)
    pu_user = PusUsers.find_by_pu_id(FIRST_PU_ID)
    user = User.find(pu_user.user_id)
    register_pu(NEW_PU_NAME,["project_unit_original_" + FIRST_PU_ID.to_s, "project_unit_member","project_unit_tool_conf"])
    new_pu=Pu.find(:last)
    begin
      last_row = get_xpath_count($xpath["pu"]["pu_list_row"])
      assert_equal NEW_PU_NAME,@selenium.get_text($xpath["pu"]["pu_list_row"]+"[#{last_row}]/td[2]")
      open_pu_setting_page(NEW_PU_NAME)

      assert_equal _("Analysis Rule Setting"), get_text("//table[@id='analyze_rule_numbers']/tbody/tr[1]/th")
      for j in 1..3
        assert_equal old_pu.analyze_rule_configs[j-1].rule_numbers||'', get_value("qac_rule" + j.to_s) # 0 to 2
        assert_equal old_pu.analyze_rule_configs[j+2].rule_numbers||'', get_value("qacpp_rule" + j.to_s) # 3 to 5
      end

      click "link=#{_('Execution Setting')}"
      wait_for_element_text("//div[@id='tool_setting']/table[1]/tbody/tr[1]/th",_("Executing Setting") )

      qac = "QAC "+"#{_('setting')}"
      wait_for_text_present(qac)
      check_pu_setting_value(old_pu, 0)

      select "tool_name", "label=QAC++"
      qacpp = "QAC++ "+"#{_('setting')}"
      wait_for_element_text("target_tool", qacpp)
      check_pu_setting_value(old_pu, 1)

      # Pu member list
      click "link=#{_('PU Member Listing')}"
      sleep 2
      # inherit member
      assert_equal user.id.to_s, get_text("//div[@id='right_contents']/div/table/tbody/tr[2]/td[1]")
      assert_equal user.account_name, get_text("//div[@id='right_contents']/div/table/tbody/tr[2]/td[2]")
      assert_equal user.fullname(1), get_text("//div[@id='right_contents']/div/table/tbody/tr[2]/td[3]")
      assert_equal user.nick_name, get_text("//div[@id='right_contents']/div/table/tbody/tr[2]/td[4]")
      assert_equal user.email, get_text("//div[@id='right_contents']/div/table/tbody/tr[2]/td[5]")
      logout
      Pu.delete(new_pu.id)
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
  end

  # A-24
  # It returns to PU management screen.
  def test_024
    open_pu_registration_page
    window_id = get_attribute("//body/div[2]", "id")
    click window_id + "_close"
    wait_for_element_text("//div[@id='right_contents']/div/h3", _("PU Administration"))
    logout
  end

  def test_025
    assert true
  end

  # A-26
  # Move to "PU change page" when "PU change" link on PU Management page is clicked.
  def test_026
    open_pu_management_page
    wait_for_element_present("link=#{_('Edit')}")
    click "link=#{_('Edit')}"
    wait_for_page_to_load "30000"

    # moves to the change page of PU name.
    assert_equal _("Edit PU Name"), get_title
    logout
  end

  # A-27
  # Change PU successfully
  def test_027
    create_pu(NEW_PU_NAME)
    new_pu = Pu.find(:last)
    open_pu_management_page
    change_pu_name(new_pu.id, NEW_PU_NAME + "_change")

    # return PU management page
    click "link=#{_('PU Administration')}"
    wait_for_element_text("//a[contains(@href, '/devgroup/pu_index/" + new_pu.id.to_s + "')]", NEW_PU_NAME  + "_change")
    Pu.delete(new_pu.id)
    logout
  end

end