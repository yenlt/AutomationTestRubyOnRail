require File.dirname(__FILE__) + "/test_d_setup" unless defined? TestDSetup

class TestD < Test::Unit::TestCase
  include TestDSetup

  NEW_MASTER_NAME = "new master name"
  NEW_MASTER_EXPLANATION = "new master explanation"
  NEW_MASTER_FILE = MASTER_FILES["normal"]

  def test_039
    register_master("New_master",MASTER_FILES["tar"])

    open_master_change_subwindow

    logout
  end

  def test_040
    register_master("New_master",MASTER_FILES["tar"])
    open_master_change_subwindow

    # master's name must be similar to data in database
    expected_master_name  = Master.find(:last).name
    master_name           = get_value(element_locator("master_name_textbox"))

    assert_equal(expected_master_name, master_name)

    logout
  end

  def test_041
    register_master("New_master",MASTER_FILES["tar"])
    open_master_change_subwindow

    # master's explanation must be similar to data in database
    expected_master_explanation = Master.last.expl
    master_explanation          = get_text(element_locator("master_explanation_textarea"))

    assert_equal(expected_master_explanation, master_explanation)

    logout
  end

  def test_042
    register_master("New_master",MASTER_FILES["tar"])
    open_master_change_subwindow

    # file input is initialized empty
    master_file = get_value(element_locator("master_file_input"))

    assert_equal("", master_file)

    logout
  end

  def test_043
    register_master("New_master",MASTER_FILES["tar"])
    change_master(NEW_MASTER_NAME)

    # a successful message must be displayed
    wait_for_text_present($messages["update_master_successfully"])

    # data in database is changed
    master_name = Master.last.name
    assert_equal(NEW_MASTER_NAME, master_name)

    # master on the list is changed
    #old_total_masters = count_matched_masters
    #master_name = get_text("//tbody[@id='master_list']/tr[#{old_total_masters}]/td[2]")
    #assert_equal(NEW_MASTER_NAME, master_name)
    logout
  end

  def test_044
    register_master("New_master",MASTER_FILES["tar"])
    change_master(nil, NEW_MASTER_EXPLANATION, nil)

    # a successful message must be displayed
    wait_for_text_present($messages["update_master_successfully"])

    # master's explanation in database must be changed
    master_explanation = Master.last.expl
    assert_equal(master_explanation,
                 NEW_MASTER_EXPLANATION)
    logout
  end

  def test_045
    register_master("New_master",MASTER_FILES["tar"])
    change_master(nil, nil, NEW_MASTER_FILE)

    # a successful message must be displayed
    wait_for_text_present(_("was registered"))

    # old file must be replaced by new file
    master_file = Master.last.filename

    expected_master_file = File.basename(NEW_MASTER_FILE)
    assert_equal(expected_master_file, master_file)

    logout
  end

  def test_046
    register_master("New_master",MASTER_FILES["tar"])
    # updates a master without master's name
    change_master("")

    # a successful message must be displayed
    wait_for_text_present($messages["register_master_failed"])


    master_name = Master.last.name

    assert_not_equal("", master_name)
    logout
  end

end
