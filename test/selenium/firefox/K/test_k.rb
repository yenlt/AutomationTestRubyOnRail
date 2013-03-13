require File.dirname(__FILE__) + "/test_k_setup" unless defined? TestKSetup
#require "test/unit"
class TestK < Test::Unit::TestCase
  include TestKSetup
  # Add a new user to a PU
  # this user will be available on PU registered members list
  def test_001
    test_000
    login("root","root")
    ## open default pu "SamplePU1".
    open_pu_member_page(SAMPLE_PU)
    ## user pj_member has been added in fixtures.
    all_members = @selenium.get_select_options($link_texts["pu_user"]["member"])
    assert_not_equal all_members.index(USER_LAST_NAME),nil
    logout
  end
  # delete a member of PU
  # this user will be removed from PU registered list
  def test_002
    test_000
    login("root","root")
    ## open default pu "SamplePU1".
    open_pu_member_page(SAMPLE_PU)
    ## remove user pj_member
    @selenium.add_selection $link_texts["pu_user"]["member"], "label=#{USER_LAST_NAME}"
    @selenium.click($xpath["pu_user"]["remove_user_pu"])
    sleep WAIT_TIME
    all_non_members = @selenium.get_select_options($link_texts["pu_user"]["non_member"])
    assert_not_equal all_non_members.index(USER_LAST_NAME),nil
    logout
  end
  # Create a new PU called NewPU which inherit member's information from SamplePU1
  # delete member root from NewPU
  # then user root will appear in the non_member list
  def test_003
    test_000
    login("root","root")
    ## create new pu called newPU.
    create_new_pu_inherit_samplepu
    ## this assert is for breaking test for ie, caused by error on creating new PU
    assert is_text_present(NEW_SAMPLE_PU)
    ## open newPU member page
    @selenium.click("link=#{NEW_SAMPLE_PU}")
    sleep WAIT_TIME
    wait_for_element_present($xpath["pu_user"]["pu_member_management"])
    @selenium.click($xpath["pu_user"]["pu_member_management"])
    sleep WAIT_TIME
    @selenium.add_selection $link_texts["pu_user"]["member"], "label=#{MANAGER}"
    @selenium.click($xpath["pu_user"]["remove_user_pu"])
    sleep WAIT_TIME
    assert_equal [MANAGER], @selenium.get_select_options($link_texts["pu_user"]["non_member"])
    sleep WAIT_TIME
    logout
  end
  # PU administrator is added.
  # The selected user moves to PU administrator list.
  def test_004
    test_000
    login("root","root")
    ## open pu-admin page for default pu "SamplePU1".
    open_pu_admin_page(SAMPLE_PU)
    ## add user "pj_member" to administrator list.
    @selenium.add_selection $link_texts["pu_user"]["member"],"label=#{USER_LAST_NAME}"
    @selenium.click($xpath["pu_user"]["add_user_pu"])
    sleep WAIT_TIME
    ## user "pj_member" will be on manager list.
    all_managers = @selenium.get_select_options($link_texts["pu_user"]["manager"])
    assert_not_equal all_managers.index(USER_LAST_NAME),nil
    logout
  end
  # PJ administrator is removed.
  # The selected user moves to PJ administrator list.
  def test_005
    test_000
    login("root","root")
    ## add user "pj_member" to administrator list.
    add_pj_admin
    wait_for_button_enable($xpath["pj_user"]["add_user_pj"])
    ## remove user "pj_member" from administrator list.
    remove_pj_admin
    wait_for_button_enable($xpath["pj_user"]["remove_user_pj"])
    ## user "pj_member" will be on PJ member list side
    all_members = @selenium.get_select_options("members[]")
    assert_not_equal all_members.index(USER_LAST_NAME),nil
    logout
  end
  # A setup "member and administrator" of other PU(s) is inherited at the time of PU creation.
  # PJ manager authority is deleted.
  # An object user moves to the PJ member list side.
  def test_006
    test_000
    login("root","root")
    ## add user "pj_member" to administrator list.
    add_pj_admin
    wait_for_button_enable($xpath["pj_user"]["add_user_pj"])
    ## create newPU inherit SamplePU1
    create_new_pu_inherit_samplepu
    ## this assert is for breaking test for ie, caused by error on creating new PU
    assert is_text_present(NEW_SAMPLE_PU)
    create_a_pj_of_newpu(NEW_SAMPLE_PU,NEW_SAMPLE_PJ)
    @selenium.click("link=#{NEW_SAMPLE_PJ}")
    sleep WAIT_TIME
    @selenium.click($xpath["pj_user"]["pj_member_management"])
    sleep WAIT_TIME
    ## add user "pj_member" to new pj member list
    @selenium.add_selection $link_texts["pj_user"]["non_member"], "label=#{USER_LAST_NAME}"
    @selenium.click($xpath["pj_user"]["add_user_pj"])
    sleep WAIT_TIME
    @selenium.click($xpath["pj"]["pj_registration_administrator"])
    sleep WAIT_TIME
    ## add user "pj_member" to new pj admin list
    @selenium.add_selection $link_texts["pj_user"]["non_admin"],"label=#{USER_LAST_NAME}"
    @selenium.click($xpath["pj_user"]["add_user_pj"])
    sleep WAIT_TIME
    ## remove user "pj_member" from new pj admin list
    @selenium.add_selection $link_texts["pj_user"]["admin"],"label=#{USER_LAST_NAME}"
    @selenium.click($xpath["pj_user"]["remove_user_pj"])
    sleep WAIT_TIME
    # we will check there isn't user "pj_member" in this set
    all_admins = @selenium.get_select_options($link_texts["pj_user"]["admin"])
    assert_equal all_admins.index(USER_LAST_NAME),nil
    # we will check there is user "pj_member" in this set
    all_members = @selenium.get_select_options($link_texts["pj_user"]["non_admin"])
    assert_not_equal all_members.index(USER_LAST_NAME),nil
    logout
  end
  # 5-6 members are registered into PU.
  # All the members make it PU administrator.
  # PJ is created under the PU.
  # All PU members are made into PJ member.
  # All PU members are made into PJ administrator.
  # All PU members are deleted.
  # PU member, PU administrator, PJ member, and PJ administrator become empty.
  # All PU members are deleted in the state where there is a PU administrator.
  # PU registered member list and PU administrator list become an empty selection box.
  def test_007
    test_000
    login("root","root")
    ## create 5 more users.
    create_many_user(5)
    ## add all 5 user to samplepu2 member list
    add_many_pu_mem(SAMPLE_PU2)
    ## add 1 user to samplepu2 admin list
    add_a_pu_admin(SAMPLE_PU2)
    ## delete all 5 more user
    delete_many_user(5)
    ## open samplepu2 member page
    open_pu_member_page(SAMPLE_PU2)
    assert_equal ["#{MANAGER}"],@selenium.get_select_options($link_texts["pu_user"]["member"])
    @selenium.click($xpath["pu"]["pu_registration_administrator"])
    wait_for_element_present($xpath["pu_user"]["add_user_pu"])
    sleep WAIT_TIME
    assert_equal ["#{MANAGER}"],@selenium.get_select_options($link_texts["pu_user"]["manager"])
    logout
  end
  # 5-6 members are registered into PU.
  # All the members make it PU administrator.
  # PJ is created under the PU.
  # All PU members are made into PJ member.
  # All PU members are made into PJ administrator.
  # All PU members are deleted.
  # PU member, PU administrator, PJ member, and PJ administrator become empty.
  def test_008
    test_000
    login("root","root")
    open_pu_member_page(SAMPLE_PU)
    ## remove admin and pj_member from SamplePU1 member list
    @selenium.add_selection $link_texts["pu_user"]["member"], "label=pj_admin"
    @selenium.add_selection $link_texts["pu_user"]["member"], "label=#{USER_LAST_NAME}"
    @selenium.add_selection $link_texts["pu_user"]["member"], "label=#{ MANAGER}"
    @selenium.click($xpath["pu_user"]["remove_user_pu"])
    ## create 5 more users
    create_many_user(5)
    ## add 5 users to member list of SamplePU1
    add_many_pu_mem(SAMPLE_PU)
    ## add 5 users to admin list of SamplePU1
    add_many_pu_admin(SAMPLE_PU)
    ## add 5 users to member list of new pj
    add_many_pj_mem(SAMPLE_PU, SAMPLE_PJ)
    ## add 5 user to admin list of new pj
    add_many_pj_admin(SAMPLE_PU, SAMPLE_PJ)
    ## delete all 5 users
    delete_many_user(5)
    open_pu_member_page(SAMPLE_PU)
    pu_member = @selenium.get_select_options($link_texts["pu_user"]["member"])
    5.times do |i|
      assert_equal pu_member.include?("newuser#{i}"), false
    end
    ## assert all PU admins is deleted
    @selenium.click($xpath["pu"]["pu_registration_administrator"])
    sleep WAIT_TIME
    pu_manager = @selenium.get_select_options($link_texts["pu_user"]["manager"])
    5.times do |i|
      assert_equal pu_manager.include?("newuser#{i}"), false
    end
    open_pj_member_page(SAMPLE_PU, SAMPLE_PJ)
    sleep WAIT_TIME
    assert_equal [""],@selenium.get_select_options($link_texts["pj_user"]["member"])
    ## assert all Pj admins is deleted
    @selenium.click($xpath["pj"]["pj_registration_administrator"])
    sleep WAIT_TIME
    assert_equal [""],@selenium.get_select_options($link_texts["pj_user"]["admin"])
    logout
  end
  # A "<<" button is repeatedly hit at the time of PU member addition.
  # This button will be uneditable in fixed time
  def test_009
    test_000
    login("root","root")
    open_pu_member_page(SAMPLE_PU)
    @selenium.add_selection $link_texts["pu_user"]["member"], "label=#{USER_LAST_NAME}"
    @selenium.click($xpath["pu_user"]["remove_user_pu"])
    assert !@selenium.is_editable($xpath["pu_user"]["remove_user_pu"])
    sleep WAIT_TIME
    logout
  end
  # A ">>" button is repeatedly hit at the time of PU member addition.
  # This button will be uneditable in fixed time
  def test_010
    test_000
    login("root","root")
    open_pu_member_page(SAMPLE_PU)
    ## remove user "pj_member" from pu member list
    @selenium.add_selection $link_texts["pu_user"]["member"], "label=#{USER_LAST_NAME}"
    @selenium.click($xpath["pu_user"]["remove_user_pu"])
    sleep WAIT_TIME
    @selenium.add_selection $link_texts["pu_user"]["non_member"], "label=#{USER_LAST_NAME}"
    @selenium.click($xpath["pu_user"]["add_user_pu"])
    assert !@selenium.is_editable($xpath["pu_user"]["add_user_pu"])
    sleep WAIT_TIME
    logout
  end
  #A "<<" button is repeatedly hit at the time of PU administrator addition.
  def test_011
    test_000
    login("root","root")
    open_pu_admin_page(SAMPLE_PU)
    ## add user "pj_member" to pu member list
    @selenium.add_selection $link_texts["pu_user"]["member"], "label=#{USER_LAST_NAME}"
    @selenium.click($xpath["pu_user"]["add_user_pu"])
    sleep WAIT_TIME
    @selenium.add_selection $link_texts["pu_user"]["manager"], "label=#{USER_LAST_NAME}"
    @selenium.click($xpath["pu_user"]["remove_user_pu"])
    assert !@selenium.is_editable($xpath["pu_user"]["remove_user_pu"])
    sleep WAIT_TIME
    logout
  end
  #
  def test_012
    test_000
    login("root","root")
    open_pu_admin_page(SAMPLE_PU)
    @selenium.add_selection $link_texts["pu_user"]["member"], "label=#{USER_LAST_NAME}"
    @selenium.click($xpath["pu_user"]["add_user_pu"])
    assert !@selenium.is_editable($xpath["pu_user"]["add_user_pu"])
    sleep WAIT_TIME
    logout
  end
  # The number of PU members: Zero person
  # PU member list is displayed.
  # There will be a message: "PUメン�?�?�登録�?�れ�?��?��?��?�ん。"
  def test_013
    #test_000
    login("root","root")
    open_pu_member_page(SAMPLE_PU2)
    ## remove admin and pj member
    @selenium.add_selection $link_texts["pu_user"]["member"], "label=#{MANAGER}"
    @selenium.click($xpath["pu_user"]["remove_user_pu"])
    ## open pu member list page
    @selenium.open($xpath["admin_menu_page"])
    sleep WAIT_TIME
    wait_for_element_present($xpath["pu"]["pu_management"])
    @selenium.click($xpath["pu"]["pu_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{SAMPLE_PU2}")
    wait_for_element_present($xpath["pu_user"]["pu_member_list"])
    @selenium.click($xpath["pu_user"]["pu_member_list"])
    sleep 30
    wait_for_text_present($messages["pu_member_is_not_registered"]))
    logout
  end
  # The number of PU members: Plurality
  # PU member list is displayed.
  def test_014
    test_000
    login("root","root")
    ## create 5 more users
    create_many_user(5)
    ## add 5 users to SamplePU member list
    add_many_pu_mem(SAMPLE_PU)
    open_pu_member_page(SAMPLE_PU)
    @selenium.click($xpath["pu_user"]["pu_member_list"])
    sleep WAIT_TIME
    (1..4).each do |i|
      assert_equal $link_texts["pu_user"]["pu_user_list_table"][i-1], @selenium.get_text($xpath["pu_user"]["pu_user_list_table"]+"[1]/th[#{i}]")
    end
    assert_equal $link_texts["pu_user"]["pu_user_list_table"][4], @selenium.get_text("thline-right")
    (1..5).each do |i|
      assert @selenium.is_element_present($xpath["pu_user"]["pu_user_list_table"]+"[6]/td[#{i}]")
    end
    logout
  end
end
