require File.dirname(__FILE__) + "/test_a_setup" unless defined? TestASetup

class TestA1 < Test::Unit::TestCase
  include TestASetup
  # global variable
  @@no_pu = 0
  # A-1
  # PU has not been registered
  def test_001
    # delete all existed projects
    delete_all_pus
    begin
      # there is no project
      open_pu_management_page
      wait_for_text_present(_("No PU has been registered"))
      logout
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    # return the original data (2 pus)
    make_original_pus
  end

  # A-2
  # A search box and a table are not displayed.
  def test_002
    # delete all existed projects
    delete_all_pus
    begin
      # there is no project
      open_pu_management_page
      assert is_element_not_present(xpath["pu_management"]["search_box"])
      assert is_element_not_present(xpath["pu_management"]["pu_table"])
      logout
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    # return the original data (2 pus)
    make_original_pus
  end
  # A-3
  # A search box are displayed.
  def test_003
    open_pu_management_page
    assert is_element_present(xpath["pu_management"]["search_box"])
    assert is_element_present(xpath["pu_management"]["pu_table"])
    logout
  end

  # A-4
  # a table are displayed.
  def test_004
    open_pu_management_page
    assert is_element_present(xpath["pu_management"]["pu_table"])
    logout
end

  # A-5
  # Compare with the number of Pu member on a database.
  def test_005
    open_pu_management_page
    pus = Pu.find(:all)
    @@no_pu = pus.length
    assert_equal @@no_pu, get_xpath_count(xpath["pu_management"]["pu_list"])
    logout
  end

  # A-6
  # Compare with the registration number on a database
  def test_006
    open_pu_management_page
    assert_equal _("Number of users"), get_table("//div[@id='right_contents']/div[1]/table[2].0.2")
    for i in 1..@@no_pu
      pu_id = get_table("//div[@id='right_contents']/div[1]/table[2].#{i}.0").to_i
      pu_users = PusUsers.find_all_by_pu_id(pu_id)
      assert_equal pu_users.length.to_s, get_table("//div[@id='right_contents']/div[1]/table[2].#{i}.2")
    end
    logout
  end

end
