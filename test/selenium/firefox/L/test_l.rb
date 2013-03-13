require File.dirname(__FILE__) + "/test_l_setup" unless defined? TestLSetup
require File.dirname(__FILE__) + "/../K/test_k_setup" unless defined? TestKSetup
#require "test/unit"
class TestL < Test::Unit::TestCase
  include TestKSetup
  include TestLSetup
  # PJ member is added.
  # The selected user moves to PJ registered member list.
  def test_001
    test_000
    login("root","root")
    open_pj_member_page(SAMPLE_PU, SAMPLE_PJ)
    ## assert all members's names are available on the registered member list
    all_members = @selenium.get_select_options($link_texts["pj_user"]["member"])
    assert_not_equal all_members.index(USER_LAST_NAME),nil
    logout
  end
  # PJ member is deleted.
  # The selected user moves to PJ unregistered member list.
  def test_002
    test_000
    login("root","root")
    open_pj_member_page(SAMPLE_PU, SAMPLE_PJ)
    ## remove user "pj_member" from pj member list
    @selenium.add_selection $link_texts["pj_user"]["member"], "label=#{USER_LAST_NAME}"
    @selenium.click($xpath["pj_user"]["remove_user_pj"])
    sleep WAIT_TIME
    all_non_members = @selenium.get_select_options($link_texts["pj_user"]["non_member"])
    assert_not_equal all_non_members.index(USER_LAST_NAME),nil
    logout
  end
  # A setup "member and administrator" of other PJ(s) is inherited at the time of PJ creation.
  # PJ member is deleted.
  # The selected user moves to PJ unregistered member list.
  def test_003
    test_000
    login("root","root")
    ## create 5 more users
    create_many_user(5)
    open_pu_member_page(SAMPLE_PU)
    ## remove admin and pj_member from SamplePU1 member list
    @selenium.add_selection $link_texts["pu_user"]["member"], "label=#{USER_LAST_NAME}"
    @selenium.add_selection $link_texts["pu_user"]["member"], "label=#{MANAGER}"
    @selenium.click($xpath["pu_user"]["remove_user_pu"])
    ## add 5 new users to pu member list
    add_many_pu_mem(SAMPLE_PU)
    ## add 5 new users to new pj member list
    add_many_pj_mem(SAMPLE_PU,SAMPLE_PJ )
    ## create new pj inherit pj
    create_a_pj_inherit_newpj(SAMPLE_PU, NEW_SAMPLE_PJ)
    ## this assert is for breaking test for ie, caused by error on creating new PJ
    assert is_text_present(NEW_SAMPLE_PJ)
    open_pj_member_page(SAMPLE_PU, NEW_SAMPLE_PJ)
    (1..5).each do |i|
      @selenium.add_selection $link_texts["pj_user"]["member"], "label=new#{i}"
    end
    @selenium.click($xpath["pj_user"]["remove_user_pj"])
    sleep WAIT_TIME
    all_non_members = @selenium.get_select_options($link_texts["pj_user"]["non_member"])
    (1..5).each do |i|
      if all_non_members.include?("new#{i}")
        assert true
      end
    end
    all_members = @selenium.get_select_options($link_texts["pj_user"]["member"])
    (1..5).each do |i|
      if !all_members.include?("new#{i}")
        assert true
      end
    end
    logout
  end
  # PU administrator is added.
  # The selected user moves to PJ administrator list.
  # This test is failed, because a PU administrator may not be a PJ administrator
  def test_004
    test_000
    login("root","root")
    ## add user "pj_member" to pu admin list
    add_pu_admin
    ## open pj admin page
    open_pj_admin_page(SAMPLE_PU,SAMPLE_PJ)
    begin
      assert_equal ["#{USER_LAST_NAME}"], @selenium.get_select_options($link_texts["pj_user"]["admin"])
    rescue Test::Unit::AssertionFailedError
      printf "This Test Fail!\n"
      @verification_errors << $!
    end
    logout
  end
  # A setup "member and administrator" of other PJ(s) is inherited at the time of PJ creation.
  # PJ manager authority is deleted.
  # An object user moves to the PJ member list side.
  def test_005
    test_000
    login("root","root")
    ## add user "pj_member" to pu admin list
    add_pu_admin
    ## add user "pj_member" to pj admin list
    add_pj_admin
    ## create a pj inherit pj
    create_a_pj_inherit_newpj(SAMPLE_PU, NEW_SAMPLE_PJ)
    ## this assert is for breaking test for ie, caused by error on creating new PJ
    assert is_text_present(NEW_SAMPLE_PJ)
    open_pj_admin_page(SAMPLE_PU, NEW_SAMPLE_PJ)
    @selenium.add_selection $link_texts["pj_user"]["admin"], "label=#{USER_LAST_NAME}"
    @selenium.click($xpath["pj_user"]["remove_user_pj"])
    sleep WAIT_TIME
    all_admins = @selenium.get_select_options($link_texts["pj_user"]["admin"])
    assert_equal all_admins.index(USER_LAST_NAME), nil
    all_members = @selenium.get_select_options($link_texts["pj_user"]["non_admin"])
    assert_not_equal all_members.index(USER_LAST_NAME), nil
    logout
  end
  # All PJ members are deleted in the state where there is a PJ administrator.
  # PJ registered member list and PJ administrator list become an empty selection box.
  def test_006
    test_000
    login("root","root")
    open_pu_member_page(SAMPLE_PU)
    ## remove admin and pj member
    @selenium.add_selection $link_texts["pu_user"]["member"], "label=#{USER_LAST_NAME}"
    @selenium.add_selection $link_texts["pu_user"]["member"], "label=#{MANAGER}"
    @selenium.click($xpath["pu_user"]["remove_user_pu"])
    ## create 5 new users
    create_many_user(5)
    ## add 5 users to pu member list
    add_many_pu_mem(SAMPLE_PU)
    ## add 5 users to pj member list
    add_many_pj_mem(SAMPLE_PU,SAMPLE_PJ )
    ## add 1 users to pj admin list
    add_a_pj_admin(SAMPLE_PU,SAMPLE_PJ )
    open_pj_member_page(SAMPLE_PU,SAMPLE_PJ)
    (1..5).each do |i|
      @selenium.add_selection $link_texts["pj_user"]["member"], "label=new#{i}"
    end
    @selenium.click($xpath["pj_user"]["remove_user_pj"])
    sleep WAIT_TIME
    all_members = @selenium.get_select_options($link_texts["pj_user"]["member"])
    (1..5).each do |i|
      if !all_members.include?("new#{i}")
        assert true
      end
    end
    @selenium.click($xpath["pj"]["pj_registration_administrator"])
    sleep WAIT_TIME
    all_admins = @selenium.get_select_options($link_texts["pj_user"]["admin"])
    (1..5).each do |i|
      if !all_admins.include?("new#{i}")
        assert true
      end
    end
    logout
  end
  # A "<<" button is repeatedly hit at the time of PJ member addition.
  # This button will be uneditable in fixed time
  def test_007
    test_000
    login("root","root")
    ## open SamplePJ1 member page
    open_pj_member_page(SAMPLE_PU,SAMPLE_PJ)
    @selenium.add_selection $link_texts["pj_user"]["member"], "label=#{USER_LAST_NAME}"
    @selenium.click($xpath["pj_user"]["remove_user_pj"])
    assert !@selenium.is_editable($xpath["pj_user"]["remove_user_pj"])
    sleep WAIT_TIME
    logout
  end
  # A ">>" button is repeatedly hit at the time of PJ member addition.
  # This button will be uneditable in fixed time
  def test_008
    test_000
    login("root","root")
    ## open SamplePJ1 member page
    open_pj_member_page(SAMPLE_PU,SAMPLE_PJ)
    @selenium.add_selection $link_texts["pj_user"]["member"], "label=#{USER_LAST_NAME}"
    @selenium.click($xpath["pj_user"]["remove_user_pj"])
    sleep WAIT_TIME
    @selenium.add_selection $link_texts["pj_user"]["non_member"], "label=#{USER_LAST_NAME}"
    @selenium.click($xpath["pj_user"]["add_user_pj"])
    assert !@selenium.is_editable($xpath["pj_user"]["add_user_pj"])
    sleep WAIT_TIME
    logout
  end
  #A "<<" button is repeatedly hit at the time of PJ administrator addition.
  def test_009
    test_000
    login("root","root")
    open_pj_admin_page(SAMPLE_PU,SAMPLE_PJ)
    @selenium.add_selection $link_texts["pj_user"]["non_admin"], "label=#{USER_LAST_NAME}"
    @selenium.click($xpath["pj_user"]["add_user_pj"])
    sleep WAIT_TIME
    @selenium.add_selection $link_texts["pj_user"]["admin"], "label=#{USER_LAST_NAME}"
    @selenium.click($xpath["pj_user"]["remove_user_pj"])
    assert !@selenium.is_editable($xpath["pj_user"]["remove_user_pj"])
    sleep WAIT_TIME
    logout
  end
  #
  def test_010
    test_000
    login("root","root")
    open_pj_admin_page(SAMPLE_PU,SAMPLE_PJ)
    @selenium.add_selection $link_texts["pj_user"]["non_admin"], "label=#{USER_LAST_NAME}"
    @selenium.click($xpath["pj_user"]["add_user_pj"])
    assert !@selenium.is_editable($xpath["pj_user"]["add_user_pj"])
    sleep WAIT_TIME
    logout
  end
  # The number of PJ members: Zero person
  # PJ member list is displayed.
  # TOSCANA will display "PJメン�?�?�登録�?�れ�?��?��?��?�ん。"
  def test_011
    test_000
    login("root","root")
    open_pu_member_page(SAMPLE_PU)
    ## remove admin and pj member
    @selenium.add_selection $link_texts["pu_user"]["member"], "label=pj_admin"
    @selenium.add_selection $link_texts["pu_user"]["member"], "label=#{USER_LAST_NAME}"
    @selenium.add_selection $link_texts["pu_user"]["member"], "label=#{MANAGER}"
    @selenium.click($xpath["pu_user"]["remove_user_pu"])
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["pu"]["pu_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{SAMPLE_PU}")
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click("link=#{SAMPLE_PJ}")
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["pj_user"]["pj_member_list"])
    wait_for_text_present($messages["pj_member_is_not_registered"])
    logout
  end
  # The number of PJ members: Plurality
  # PJ member list is displayed.
  def test_012
    test_000
    login("root","root")
    @selenium.open($xpath["admin_menu_page"])
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click($xpath["pu"]["pu_management"])
    sleep WAIT_TIME
    @selenium.click("link=#{SAMPLE_PU}")
    @selenium.wait_for_page_to_load PAGE_LOAD_TIME
    @selenium.click("link=#{SAMPLE_PJ}")
    wait_for_element_present($xpath["pj_user"]["pj_member_list"])
    @selenium.click($xpath["pj_user"]["pj_member_list"])
    sleep WAIT_TIME

    (2..5).each do |i|
      assert_equal $link_texts["pu_user"]["pu_user_list_table"][i-1], @selenium.get_text($xpath["pu_user"]["pu_user_list_table"]+"[1]/th[#{i}]")
    end
    (1..5).each do |i|
      assert @selenium.is_element_present($xpath["pu_user"]["pu_user_list_table"]+"[3]/td[#{i}]")
    end
    logout
  end

end
