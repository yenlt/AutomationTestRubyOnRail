require File.dirname(__FILE__) + "/test_b_setup" unless defined? TestBSetup

# Change/Deletion/Sorting/Filtering

class TestB2 < Test::Unit::TestCase
  include TestBSetup
  NEW_PU_NAME = "SamplePU"
  NEW_PJ_NAME = "SamplePJ"
  FILTER_NAME = "SamplePJ1" # First PU must have at least 1 PJ with the name contains "SamplePJ1"

  # B-27
  # It moves to the change page of PU name.
  def test_027
    # SamplePU1 have 1 pj
    pu = Pu.find(:first)
    open_pj_management_page(pu.id)
    # "PJ change" link on PJ Management page is clicked.
    click "link=#{_('Edit')}"
    wait_for_page_to_load "30000"
    assert_equal _("Change PJ name"), get_title
    logout
  end

  # B-28
  # PJ name is changed successfully
  def test_028
    # SamplePU1 have 1 pj
    pu = Pu.find(:first)
    open_pj_management_page(pu.id)
    # "PJ change" link on PJ Management page is clicked.
    click "link=#{_('Edit')}"
    wait_for_page_to_load "30000"
    type "change_pj_name", NEW_PJ_NAME
    click "//input[@value='#{_('Edit')}']"
    wait_for_page_to_load "30000"
    click "link=#{_('PJ Administration')}"
    sleep 2
    assert_equal NEW_PJ_NAME, get_text($xpath["pj"]["pj_list_row"]+"[1]/td[2]")
    logout
    make_original
  end

  # B-29
  # The dialog which checks deletion comes out.
  def test_029
    pu = Pu.find(:first)
    open_pj_management_page(pu.id)
    # "PJ deletion" link on PJ Management page is clicked.
    click "link=#{_('Delete')}"
    strmsg1 = _("All information of ")
    strmsg2 = _(" will be deleted.\n<master, analysis task, analysis result, analysis log>\n")
    strmsg3 = _("Really")
    strmsg4 = _("Are you sure you want to delete")
    confirm_msg = ''
    if $lang == 'ja'
      confirm_msg = "#{FILTER_NAME}" +strmsg1 + strmsg2 + strmsg3 + "#{FILTER_NAME}" + strmsg4  +"?"
    else
      confirm_msg = strmsg1 + "#{FILTER_NAME}" + strmsg2 + strmsg4 + " #{FILTER_NAME}" +"?"
    end
    assert_equal confirm_msg, get_confirmation
    logout
  end

  def test_030
    # last pu has no existed pj
    pu = Pu.find(:last)
    Pj.destroy_all
    create_pj(pu.id, NEW_PJ_NAME)
    pj = Pj.find(:last)
    open_pj_management_page(pu.id)
    # "PJ deletion" link on PJ Management page is clicked.
	begin
	    click "link=#{_('Delete')}"
	    strmsg1 = _("All information of ")
	    strmsg2 = _(" will be deleted.\n<master, analysis task, analysis result, analysis log>\n")
	    strmsg3 = _("Really")
	    strmsg4 = _("Are you sure you want to delete")
	    confirm_msg = ''
	    if $lang == 'ja'
	      confirm_msg = "#{NEW_PJ_NAME}" +strmsg1 + strmsg2 + strmsg3 + "#{NEW_PJ_NAME}" + strmsg4  +"?"
	    else
	      confirm_msg = strmsg1 + "#{NEW_PJ_NAME}" + strmsg2 + strmsg4 + " #{NEW_PJ_NAME}" +"?"
	    end
	    assert_equal confirm_msg, get_confirmation
	    wait_for_text_not_present(NEW_PJ_NAME)
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    logout
    make_original
  end

  # Sorting by ID
  def test_031
    pu = Pu.find(:last)
    create_pj(pu.id, NEW_PJ_NAME + "1")
    create_pj(pu.id, NEW_PJ_NAME + "2")
    create_pj(pu.id, NEW_PJ_NAME + "3")

    open_pj_management_page(pu.id)
    no = get_xpath_count("//div[@id='right_contents']/div[1]/div[2]/table[2]/tbody[2]/tr")
    arr = Array.new
    arr[0] = ''
    for j in 1..no
      arr[j] = get_text("//div[@id='right_contents']/div[1]/div[2]/table[2]/tbody[2]/tr[" + j.to_s + "]/td[1]")
      # the default order is ascending
      assert arr[j] >= arr[j-1]
    end

    click("link=ID")
    for i in 1..no
      # descending
      wait_for_element_text("//div[@id='right_contents']/div[1]/div[2]/table[2]/tbody[2]/tr[" + i.to_s + "]/td[1]", arr[no - i + 1])
    end

    logout
    for l in 1..3
      pj = Pj.find(:last)
      Pj.delete(pj.id)
    end
  end

  # B-32
  # Sorting by Name
  def test_032
    pu = Pu.find(:last)
    create_pj(pu.id, NEW_PJ_NAME + "1")
    create_pj(pu.id, NEW_PJ_NAME + "2")
    create_pj(pu.id, NEW_PJ_NAME + "3")

    open_pj_management_page(pu.id)
    no = get_xpath_count("//div[@id='right_contents']/div[1]/div[2]/table[2]/tbody[2]/tr")
    arr = Array.new

    click("link=#{_('PJ name')}")
    sleep 4
    for j in 1..no
      arr[j] = get_text("//div[@id='right_contents']/div[1]/div[2]/table[2]/tbody[2]/tr[" + j.to_s + "]/td[2]")
    end

    for k in 2..no-1
      #it is sorting (even in ascending or descending)
      assert_equal false, (arr[k] >= arr[k-1]) ^ (arr[k+1] >= arr[k])
    end

    click("link=#{_('PJ name')}")
    sleep 4
    for i in 1..no
      # descending
      wait_for_element_text("//div[@id='right_contents']/div[1]/div[2]/table[2]/tbody[2]/tr[" + i.to_s + "]/td[2]", arr[no - i + 1])
    end

    logout
    for l in 1..3
      pj = Pj.find(:last)
      Pj.delete(pj.id)
    end
  end

  # B-33
  # Sorting by Register Date
  def test_033
    pu = Pu.find(:last)
    create_pj(pu.id, NEW_PJ_NAME + "1")
    create_pj(pu.id, NEW_PJ_NAME + "2")
    create_pj(pu.id, NEW_PJ_NAME + "3")

    open_pj_management_page(pu.id)
    no = get_xpath_count("//div[@id='right_contents']/div[1]/div[2]/table[2]/tbody[2]/tr")
    arr = Array.new

    click("link=#{_('Registration date')}")
    sleep 4
    for j in 1..no
      arr[j] = get_text("//div[@id='right_contents']/div[1]/div[2]/table[2]/tbody[2]/tr[" + j.to_s + "]/td[3]")
    end

    for k in 2..no-1
      #it is sorting (even in ascending or descending)
      assert_equal false, (arr[k] >= arr[k-1]) ^ (arr[k+1] >= arr[k])
    end

    click("link=#{_('Registration date')}")
    sleep 4
    for i in 1..no
      # descending
      wait_for_element_text("//div[@id='right_contents']/div[1]/div[2]/table[2]/tbody[2]/tr[" + i.to_s + "]/td[3]", arr[no - i + 1])
    end

    logout
    for l in 1..3
      pj = Pj.find(:last)
      Pj.delete(pj.id)
    end
  end

  # B-34
  # Sorting after registering a new pj
  def test_034
    pu = Pu.find(:last)
    begin
      create_pj(pu.id, NEW_PJ_NAME + "1") # add in database
      create_pj(pu.id, NEW_PJ_NAME + "2") # add in database
      register_pj(pu.id, NEW_PJ_NAME + "3") # add by web-application
      last_row = get_xpath_count($xpath["pj"]["pj_list_row"])
      assert_equal NEW_PJ_NAME+"3",@selenium.get_text($xpath["pj"]["pj_list_row"]+"[#{last_row}]/td[2]")
      sleep 4
      no = get_xpath_count("//div[@id='right_contents']/div[1]/div[2]/table[2]/tbody[2]/tr")
      arr = Array.new

      click("link=#{_('Registration date')}")
      sleep 4
      for j in 1..no
        arr[j] = get_text("//div[@id='right_contents']/div[1]/div[2]/table[2]/tbody[2]/tr[" + j.to_s + "]/td[3]")
      end

      for k in 2..no-1
        #it is sorting (even in ascending or descending)
        assert_equal false, (arr[k] >= arr[k-1]) ^ (arr[k+1] >= arr[k])
      end

      click("link=#{_('Registration date')}")
      sleep 4
      for i in 1..no
        # descending
        wait_for_element_text("//div[@id='right_contents']/div[1]/div[2]/table[2]/tbody[2]/tr[" + i.to_s + "]/td[3]", arr[no - i + 1])
      end
      logout
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    make_original
  end

  # B-35
  # "PJ名", "登録日" are options for filtering
  def test_035
    pu = Pu.find(:first)
    open_pj_management_page(pu.id)
    assert_equal [_("PJ name"), _("Registration date")], get_select_options("find_box")
    logout
  end

  # B-36
  # filtering by PJ name
  def test_036
    pu = Pu.find(:first)
    create_pj(pu.id, NEW_PJ_NAME + "36")
    open_pj_management_page(pu.id)
    filtering("36")
    assert_equal 1, get_xpath_count("//div[@id='right_contents']/div[1]/div[2]/table[2]/tbody[2]/tr")
    wait_for_text_present(NEW_PJ_NAME + "36")

    filtering("%^&")
    wait_for_text_present(_("A project does not exist."))

    pj = Pj.find(:last)
    Pj.delete(pj.id)
    logout
  end

  def test_037
    pu = Pu.find(:first)
    pj = Pj.find(:first)

    open_pj_management_page(pu.id)
    select "find_box", "label=#{_('Registration date')}"

    year  = "2009" # similar to the registration date of pj in Test Fixtures/pjs.yml
    month = "05"   # similar to the registration date of pj in Test Fixtures/pjs.yml
    date  = "08"   # similar to the registration date of pj in Test Fixtures/pjs.yml

    filtering(year)
    assert_equal 1, get_xpath_count("//div[@id='right_contents']/div[1]/div[2]/table[2]/tbody[2]/tr")
    wait_for_text_present(pj.name)

    filtering(month)
    assert_equal 1, get_xpath_count("//div[@id='right_contents']/div[1]/div[2]/table[2]/tbody[2]/tr")
    wait_for_text_present(pj.name)

    filtering(date)
    assert_equal 1, get_xpath_count("//div[@id='right_contents']/div[1]/div[2]/table[2]/tbody[2]/tr")
    wait_for_text_present(pj.name)

    filtering(year + "-" + month + "-" + date)
    assert_equal 1, get_xpath_count("//div[@id='right_contents']/div[1]/div[2]/table[2]/tbody[2]/tr")
    wait_for_text_present(pj.name)

    filtering("2000")
    wait_for_text_present(_("A project does not exist."))

    logout
  end

  def test_038
    pu = Pu.find(:first)
    create_pj(pu.id, NEW_PJ_NAME)

    open_pj_management_page(pu.id)
    no = get_xpath_count("//div[@id='right_contents']/div[1]/div[2]/table[2]/tbody[2]/tr")
    filtering("")
    assert_equal no, get_xpath_count("//div[@id='right_contents']/div[1]/div[2]/table[2]/tbody[2]/tr")

    logout
    pj = Pj.find(:last)
    Pj.delete(pj.id)

  end
end
