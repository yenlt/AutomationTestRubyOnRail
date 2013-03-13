require File.dirname(__FILE__) + "/test_a_setup" unless defined? TestASetup

class TestA4 < Test::Unit::TestCase
  include TestASetup
  fixtures :pus
  @@pu = 0
  @@pu2 = 0
  @@pu3 = 0

    # A-28
    # Deletion of PU
    def test_028

      #  login
      login
      #  Open PU management page
      open_pu_management_page
      #  Get total rows in PU table
      total_rows = get_xpath_count($xpath["pu"]["pu_list_row"])
      #  delete pu
      row_xpath         = $xpath["pu"]["pu_list_row"] + "[#{total_rows}]"
      result_link_xpath = row_xpath + "/td[5]/a[2]"
      result_name_xpath = row_xpath + "/td[2]"
      # clicks on link to delete PU
      click(result_link_xpath)
      # The dialog which checks deletion comes out.
      pj_name = get_text(result_name_xpath)
      strmsg1 = _("All information of ")
      strmsg2 = _(" will be deleted.\n<PJ,master, analysis task, analysis result, analysis log>\n")
      strmsg3 = _("Really")
      strmsg4 = _("Are you sure you want to delete")
      strmsg = ''
      if $lang == 'ja'
        strmsg = "#{pj_name}" +strmsg1 + strmsg2 + strmsg3 + "#{pj_name}" + strmsg4  +"?"
      else
        strmsg = strmsg1 + "#{pj_name}" + strmsg2 + strmsg4 + " #{pj_name}" +"?"
      end
      assert_equal(strmsg , get_confirmation)
      #  logout
      logout
      make_original_pus
    end

    # A-29
    # Deletion of PU
    def test_029

      #  login
      login

      #  Open PU management page
      open_pu_management_page_1
      #Register a new PU
      pu_name = 'pu'
      register_pu(pu_name)
      @@pu = Pu.find(:last)

      #  Get total rows in PU table
      total_rows = get_xpath_count($xpath["misc"]["result_list_PU_row"])

      #    for all table...
      (1..total_rows).each do |row_index|
        row_xpath         = $xpath["misc"]["result_list_PU_row"] + "[#{row_index}]"
        result_link_xpath = row_xpath + "/td[5]/a[2]"
        result_name_xpath = row_xpath + "/td[2]"
        get_text(result_name_xpath)

        if row_index == 1
          choose_cancel_on_next_confirmation()
        else
          # PU name is deleted.
          choose_ok_on_next_confirmation()
        end

        # clicks on link to delete PU
        click(result_link_xpath)

        pj_name = get_text(result_name_xpath)
        strmsg1 = _("All information of ")
        strmsg2 = _(" will be deleted.\n<PJ,master, analysis task, analysis result, analysis log>\n")
        strmsg3 = _("Really")
        strmsg4 = _("Are you sure you want to delete")
        strmsg = ''
        if $lang == 'ja'
          strmsg = "#{pj_name}" +strmsg1 + strmsg2 + strmsg3 + "#{pj_name}" + strmsg4  +"?"
        else
          strmsg = strmsg1 + "#{pj_name}" + strmsg2 + strmsg4 + " #{pj_name}" +"?"
        end

        # The dialog which checks deletion comes out.
        assert_equal( strmsg,get_confirmation)

        @@pu.destroy

      end
      #  logout
      logout
      make_original_pus
    end
    def test_030
      printf "\n+ This is not a test case!"
      assert true
    end
  #  A-31
  #  Sorting of PU list. ID column of PU list is clicked
  def test_031
    #  login
    login

    #  Two PUs are created
    Pu.destroy_all
    pu_name_a = 'puA'
    pu_name_b = 'puB'
    create_pu(pu_name_a)
    create_pu(pu_name_b)


    # Count all records
    pus = Pu.find(:all)
    @@no_pu = pus.length

    #  Open PU management page
    open_pu_management_page_1


    for i in 1..@@no_pu
      assert_equal pus[i-1].name, get_table("//div[@id='right_contents']/div[1]/table[2].#{i}.1")
    end

    # firtly, sort by ID
    pus = Pu.find(:all,:order => 'id')

    #  click ID link
    click $xpath["misc"]["id_link"]
    sleep 2

    if pus[0].id.to_s == get_table("//div[@id='right_contents']/div[1]/table[2].1.0")
      pus = Pu.find(:all,:order => 'id')
      pus_second = Pu.find(:all,:order => 'id DESC')
    else
      pus = Pu.find(:all,:order => 'id DESC')
      pus_second = Pu.find(:all,:order => 'id')
    end
    for j in 1..@@no_pu
      assert_equal pus[j-1].name, get_table("//div[@id='right_contents']/div[1]/table[2].#{j}.1")
    end
    # Click PU ID
    click $xpath["misc"]["id_link"]
    sleep 2
    for k in 1..@@no_pu
      assert_equal pus_second[k-1].name, get_table("//div[@id='right_contents']/div[1]/table[2].#{k}.1")
    end

    #  Delete created data

    @@pu= Pu.find_by_name('puA')
    @@pu2= Pu.find_by_name('puB')
    @@pu.destroy
    @@pu2.destroy


    #  Logout
    logout
    make_original_pus
  end

  #A-32
  #  Sorting of PU list. The column of PU name is clicked
  def test_032
    #  login
    login

    #  Two PUs are created
    Pu.destroy_all
    create_pu('SampleA')
    create_pu('SampleB')

    # Count all records
    pus = Pu.find(:all)
    @@no_pu = pus.length

    # Open PU management page
    open_pu_management_page_1

    for i in 1..@@no_pu
      assert_equal pus[i-1].name, get_table("//div[@id='right_contents']/div[1]/table[2].#{i}.1")
    end

    # Sort by name
    pus = Pu.find(:all,:order => 'name')

    # Click PU name

    click $xpath["misc"]["name_link"]
    sleep 2

    if pus[0].id.to_s == get_table("//div[@id='right_contents']/div[1]/table[2].1.0")
      pus = Pu.find(:all,:order => 'name')
      pus_second = Pu.find(:all,:order => 'name DESC')
    else
      pus = Pu.find(:all,:order => 'name DESC')
      pus_second = Pu.find(:all,:order => 'name')
    end

    for l in 1..@@no_pu
      assert_equal pus[l-1].name, get_table("//div[@id='right_contents']/div[1]/table[2].#{l}.1")
    end
    # secondly, sort by PU's name
    click $xpath["misc"]["name_link"]
    sleep 2
    for m in 1..@@no_pu
      assert_equal pus_second[m-1].name, get_table("//div[@id='right_contents']/div[1]/table[2].#{m}.1")
    end

    # Delete created data
    @@pu= Pu.find_by_name('SampleA')
    @@pu2= Pu.find_by_name('SampleB')
    @@pu.destroy
    @@pu2.destroy

    # Logout
    logout
    make_original_pus
  end

  #A-33
  # Sorting of PU list. The column of registration date is clicked
  def test_033
    # login
    login

    # Two PUs are created
    Pu.destroy_all
    create_pu('SampleA')
    create_pu('SampleB')

    # Count all records
    pus = Pu.find(:all)
    @@no_pu = pus.length

    #Open PU management page
    open_pu_management_page_1


    for i in 1..@@no_pu
      assert_equal pus[i-1].name, get_table("//div[@id='right_contents']/div[1]/table[2].#{i}.1")
    end

    # firtly, sort by PU's registration date
    pus = Pu.find(:all,:order => 'created_at')

    #Click registration date link
    click $xpath["misc"]["registration_link"]

    sleep 2

    if pus[0].id.to_s == get_table("//div[@id='right_contents']/div[1]/table[2].1.0")
      pus = Pu.find(:all,:order => 'created_at')
      pus_second = Pu.find(:all,:order => 'created_at DESC')
    else
      pus = Pu.find(:all,:order => 'created_at DESC')
      pus_second = Pu.find(:all,:order => 'created_at')
    end

    for n in 1..@@no_pu
      assert_equal pus[n-1].name, get_table("//div[@id='right_contents']/div[1]/table[2].#{n}.1")
    end

    # secondly, sort by PU's registration date
    click $xpath["misc"]["registration_link"]
    sleep 2
    for p in 1..@@no_pu
      assert_equal pus_second[p-1].name, get_table("//div[@id='right_contents']/div[1]/table[2].#{p}.1")
    end

    # Delete created data
    @@pu= Pu.find_by_name('SampleA')
    @@pu2= Pu.find_by_name('SampleB')
    @@pu.destroy
    @@pu2.destroy

    # Logout
    logout
    make_original_pus
  end

  #A-34
  #Sorting of PU list. Sorting is performed immediately after adding PU. Any column is good
  def test_034
    #login
    login

    # Two PUs are created
    Pu.destroy_all
    create_pu('SampleA')
    create_pu('SampleB')

    # Count all records
    pus = Pu.find(:all)
    @@no_pu = pus.length

    # Open PU management page
    open_pu_management_page_1

    for i in 1..@@no_pu
      assert_equal pus[i-1].name, get_table("//div[@id='right_contents']/div[1]/table[2].#{i}.1")
    end
    sleep 2

    # register a pu
    create_pu('SampleC')

    sleep 2

    #Sort by ID
    pus = Pu.find(:all)

    click $xpath["misc"]["PU_link"]
    sleep 2

    #Click ID link
    click $xpath["misc"]["id_link"]
    sleep 2

    if pus[0].id.to_s == get_table("//div[@id='right_contents']/div[1]/table[2].1.0")
      pus = Pu.find(:all,:order => 'id')
      pus_second = Pu.find(:all,:order => 'id DESC')
    else
      pus = Pu.find(:all,:order => 'id DESC')
      pus_second = Pu.find(:all,:order => 'id')
    end

    for j in 1..@@no_pu
      assert_equal pus[j-1].name, get_table("//div[@id='right_contents']/div[1]/table[2].#{j}.1")
    end

    # secondly, sort by ID
    click $xpath["misc"]["id_link"]
    sleep 2
    for k in 1..@@no_pu
      assert_equal pus_second[k-1].name, get_table("//div[@id='right_contents']/div[1]/table[2].#{k}.1")
    end

    # Sort by name
    pus = Pu.find(:all,:order => 'name')

    # Click PU name link
    click $xpath["misc"]["name_link"]
    sleep 2

    if pus[0].id.to_s == get_table("//div[@id='right_contents']/div[1]/table[2].1.0")
      pus = Pu.find(:all,:order => 'name')
      pus_second = Pu.find(:all,:order => 'name DESC')
    else
      pus = Pu.find(:all,:order => 'name DESC')
      pus_second = Pu.find(:all,:order => 'name')
    end

    for l in 1..@@no_pu
      assert_equal pus[l-1].name, get_table("//div[@id='right_contents']/div[1]/table[2].#{l}.1")
    end
    sleep 2
    # secondly, sort by PU's name
    click $xpath["misc"]["name_link"]
    sleep 2
    for m in 1..@@no_pu
      assert_equal pus_second[m-1].name, get_table("//div[@id='right_contents']/div[1]/table[2].#{m}.1")
    end

    # firtly, sort by PU's registration date
    pus = Pu.find(:all,:order => 'created_at')

    #Click registration date link
    click $xpath["misc"]["registration_link"]
    sleep 2
    if pus[0].id.to_s == get_table("//div[@id='right_contents']/div[1]/table[2].1.0")
      pus = Pu.find(:all,:order => 'created_at')
      pus_second = Pu.find(:all,:order => 'created_at DESC')
    else
      pus = Pu.find(:all,:order => 'created_at DESC')
      pus_second = Pu.find(:all,:order => 'created_at')
    end
    for n in 1..@@no_pu
      assert_equal pus[n-1].name, get_table("//div[@id='right_contents']/div[1]/table[2].#{n}.1")
    end

    # secondly, sort by PU's registration date
    click $xpath["misc"]["registration_link"]
    sleep 2
    for p in 1..@@no_pu
      assert_equal pus_second[p-1].name, get_table("//div[@id='right_contents']/div[1]/table[2].#{p}.1")
    end


    #    Delete created data
    @@pu= Pu.find_by_name('SampleA')
    @@pu2= Pu.find_by_name('SampleB')
    @@pu3=Pu.find_by_name('SampleC')
    @@pu.destroy
    @@pu2.destroy
    @@pu3.destroy

    # Logout
    logout
    make_original_pus   
  end

  #A-35
  #Filltering of PU list. The columns which can be chosen as a candidate for filtering
  #are PU name a registration date.
  def test_035

    login

    # Create some PUs

    for i in 0..2
      create_pu('sample_pu'+i.to_s)
    end

    pus = Pu.find_all_by_name('sample_pu1')
    pu = pus.last
    pu.created_at ="2009-05-08 11:30:50"
    pu.save
    pus = Pu.find_all_by_name('sample_pu2')
    pu = pus.last
    pu.created_at ="2008-05-08 14:30:50"
    pu.save
    @@year = "2009"
    @@hour = "14"

    # Open PU management page
    open_pu_management_page_1

    #      Selection for filtering
    assert_equal [_("PU name"), _("Registration date")], get_select_options("find_box")

    #    Delete created data
    @@pu= Pu.find_by_name('sample_pu1')
    @@pu2= Pu.find_by_name('sample_pu2')
    @@pu.destroy
    @@pu2.destroy
    logout

  end

  #A-36
  # Filltering of PU list. Arbitrary filtering is performed to PU name.
  def test_036

    login

    #Create some PUs

    for i in 0..2
      create_pu('sample_pu'+i.to_s)
    end

    pus = Pu.find_all_by_name('sample_pu1')
    pu = pus.last
    pu.created_at ="2009-05-08 11:30:50"
    pu.save
    pus = Pu.find_all_by_name('sample_pu2')
    pu = pus.last
    pu.created_at ="2008-05-08 14:30:50"
    pu.save
    @@year = "2009"
    @@hour = "14"

    # Open PU management page
    open_pu_management_page_1

    # Arbitrary filtering is performed to PU name.
    assert_equal _("PU name"), get_selected_label("find_box")

    filtering('1')
    assert is_text_present('sample_pu1')
    assert !is_text_present('sample_pu2')

    sleep 2

    #    Delete created data
    @@pu= Pu.find_by_name('sample_pu1')
    @@pu2= Pu.find_by_name('sample_pu2')
    @@pu.destroy
    @@pu2.destroy
    logout
  end
  #A-37
  #Filltering of PU list. When you have no relevance,
  #"A project unit like search does not exist" is displayed.
  def test_037

    login

    #Create some PUs

    for i in 0..2
      create_pu('sample_pu'+i.to_s)
    end

    pus = Pu.find_all_by_name('sample_pu1')
    pu = pus.last
    pu.created_at ="2009-05-08 11:30:50"
    pu.save
    pus = Pu.find_all_by_name('sample_pu2')
    pu = pus.last
    pu.created_at ="2008-05-08 14:30:50"
    pu.save
    @@year = "2009"
    @@hour = "14"

    # Open PU management page
    open_pu_management_page_1

    # Arbitrary filtering is performed to PU name.
    assert_equal _("PU name"), get_selected_label("find_box")


    # you have no relevance
    filtering('3')
    assert !is_text_present('sample_pu1')
    assert !is_text_present('sample_pu2')
    assert is_text_present(_('A PU does not exist.'))
    sleep 2

    #    Delete created data
    @@pu= Pu.find_by_name('sample_pu1')
    @@pu2= Pu.find_by_name('sample_pu2')
    @@pu.destroy
    @@pu2.destroy
    logout
  end
  #A-38
  # Filltering of PU list. To a registration date,
  # the date is inputted for arbitration and filtering is performed.
  def test_038

    login

    # Create some PUs

    for i in 1..2
      create_pu('sample_pu'+i.to_s)
    end

    pus = Pu.find_all_by_name('sample_pu1')
    pu = pus.last
    pu.created_at ="2009-05-08 11:30:50"
    pu.save
    pus = Pu.find_all_by_name('sample_pu2')
    pu = pus.last
    pu.created_at ="2008-05-08 14:30:50"
    pu.save
    @@year = "2009"
    @@hour = "14"

    # Open PU management page
    open_pu_management_page_1

    # Arbitrary filtering is performed to date.
    select "find_box", "label=#{_('Registration date')}"
    assert_equal _("Registration date"), get_selected_label("find_box")

    # filtering
    filtering(@@year)
    assert is_text_present("2009-05-08")
    assert !is_text_present("2008-05-08")
    # you have no relevance
    filtering(@@year+'a')
    assert !is_text_present("2009-05-08")
    assert !is_text_present("2008-05-08")
    filtering(@@hour)
    assert is_text_present("2008-05-08")
    sleep 2

    #    Delete created data
    @@pu= Pu.find_by_name('sample_pu1')
    @@pu2= Pu.find_by_name('sample_pu2')
    @@pu.destroy
    @@pu2.destroy
    logout
  end

  #A-39
  #Filltering of PU list. A retrieval key word is emptied and is searched.
  def test_039

    login

    #Create some PUs

    for i in 0..2
      create_pu('sample_pu'+i.to_s)
    end

    pus = Pu.find_all_by_name('sample_pu1')
    pu = pus.last
    pu.created_at ="2009-05-08 11:30:50"
    pu.save
    pus = Pu.find_all_by_name('sample_pu2')
    pu = pus.last
    pu.created_at ="2008-05-08 14:30:50"
    pu.save
    @@year = "2009"
    @@hour = "14"

    #Open PU management page
    open_pu_management_page_1

    filtering("")
    assert is_text_present('sample_pu1')
    assert is_text_present('sample_pu2')

    sleep 2

    #    Delete created data
    @@pu= Pu.find_by_name('sample_pu1')
    @@pu2= Pu.find_by_name('sample_pu2')
    @@pu.destroy
    @@pu2.destroy
    logout
  end
end
