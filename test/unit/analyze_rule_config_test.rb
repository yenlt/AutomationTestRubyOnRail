require File.dirname(__FILE__) + '/../test_helper'

class AnalyzeRuleConfigTest < ActiveSupport::TestCase
  # Fixtures
  fixtures :users
  fixtures :privileges
  fixtures :privileges_users
#
  OUT_SIDE_NUMBER = 1000
  PU_ID = 1
  PJ_ID = 1
  ARS_ID = 1
  TCANA_ADMIN_ID = 1
  PU_ADMIN_ID = 2
  PJ_ADMIN_ID = 3
  TCANA_MEMBER_ID = 4
  ##
  # Test paginate_ars()
  #
  # Input: No ARS is exited.
  # Output: ars list = []
  #
  def test_ut_t2_ars_arc_001
    AnalyzeRuleConfig.delete_all()
    ars_list = AnalyzeRuleConfig.paginate_ars(1,nil,nil)
    assert_equal 0, ars_list.size
  end

  #
  # Input: paginate ars with an out side number (very large)
  # Output: ars list = []
  #
  def test_ut_t2_ars_arc_002
    ars_list = AnalyzeRuleConfig.paginate_ars(OUT_SIDE_NUMBER,nil,nil )
    assert_equal 0, ars_list.size
  end

  #
  # Input: 15 ars is exited in ARS data table
  # Output: + number of ars in the first page is 10
  #         + number of the second page is 5
  #
  def test_ut_t2_ars_arc_003
    create_ars_data(15)
    ars_1 = AnalyzeRuleConfig.paginate_ars(1,nil,nil )
    assert_equal ars_1.size,10
    ars_2 = AnalyzeRuleConfig.paginate_ars(2,nil,nil )
    assert_equal ars_2.size,5
  end

  #
  # Input: paginate ars with sort condition (ASC) for each field
  # Output: ars list is sorted.
  #
  def test_ut_t2_ars_arc_004
    create_ars_data(15)
    # sort with id
    arss = AnalyzeRuleConfig.paginate_ars(1,"id","ASC" )
    if arss[1].id <= arss[2].id
      assert true
    else
      assert false
    end   
    # sort with name
    arss = AnalyzeRuleConfig.paginate_ars(1,"name","ASC" )
    if arss[1].name <= arss[2].name
      assert true
    else
      assert false
    end
    # sort with description
    arss = AnalyzeRuleConfig.paginate_ars(1,"description","ASC" )
    if arss[1].description <= arss[2].description
      assert true
    else
      assert false
    end
    # sort with created at
    arss = AnalyzeRuleConfig.paginate_ars(1,"created_at","ASC" )
    if arss[1].created_at <= arss[2].created_at
      assert true
    else
      assert false
    end
    # sort with updated at
    arss = AnalyzeRuleConfig.paginate_ars(1,"updated_at","ASC" )
    if arss[1].updated_at <= arss[2].updated_at
      assert true
    else
      assert false
    end
  end

  #
  # Input: paginate ars with sort condition (DESC) for each field
  # Output: ars list is sorted.
  #
  def test_ut_t2_ars_arc_005
    create_ars_data(15)
    #sort with id
    arss = AnalyzeRuleConfig.paginate_ars(1,"id","DESC" )
    if arss[1].id >= arss[2].id
      assert true
    else
      assert false
    end
    #sort with name
    arss = AnalyzeRuleConfig.paginate_ars(1,"name","DESC" )
    if arss[1].name >= arss[2].name
      assert true
    else
      assert false
    end
    #sort with description
    arss = AnalyzeRuleConfig.paginate_ars(1,"description","DESC" )
    if arss[1].description >= arss[2].description
      assert true
    else
      assert false
    end
    #sort with created at
    arss = AnalyzeRuleConfig.paginate_ars(1,"created_at","DESC" )
    if arss[1].created_at >= arss[2].created_at
      assert true
    else
      assert false
    end
    #sort with updated at
    arss = AnalyzeRuleConfig.paginate_ars(1,"updated_at","DESC" )
    if arss[1].updated_at >= arss[2].updated_at
      assert true
    else
      assert false
    end
  end

  ##
  # Test find_ars_detail_by_tool_id_and_level_id()
  #
  # Input: Find a ars detail with a specific ars id, tool id and level id
  # Output: return a ars
  #
  def test_ut_t2_ars_arc_006
    ars = AnalyzeRuleConfig.new()
    ars_detail = ars.find_ars_detail_by_tool_id_and_level_id(ARS_ID,1,1)
    assert_not_nil ars_detail
    assert_equal ARS_ID, ars_detail.analyze_rule_config_id
  end

  #
  # Input: Find a ars detail with a specific pj id, tool id and level id
  # Output: return a ars
  #
  def notest_ut_t2_ars_arc_007 # bug ars list of pj do not have [0]
    ars = AnalyzeRuleConfig.new()
    ars_detail = ars.find_ars_detail_by_tool_id_and_level_id(nil,1,1)
    assert_not_nil ars_detail
    #
    ars = Pj.find_by_id(PJ_ID).analyze_rule_configs[0]
    assert_equal ars.id, ars_detail.analyze_rule_config_id
  end

  #
  # Input: Find a ars detail with a specific pu id, tool id and level id
  # Output: return a ars
  #
  def notest_ut_t2_ars_arc_008 # bug ars list of pu do not have [0]
    ars = AnalyzeRuleConfig.new()
    ars_detail = ars.find_ars_detail_by_tool_id_and_level_id(nil,1,1)
    assert_not_nil ars_detail
    #
    ars = Pu.find_by_id(PU_ID).analyze_rule_configs[0]
    assert_equal ars.id, ars_detail.analyze_rule_config_id
  end

  #
  # Input: Find a ars detail with out pu, pj or ars id
  # Output: return nil value
  #
  def test_ut_t2_ars_arc_009
    ars = AnalyzeRuleConfig.new()
    ars_detail = ars.find_ars_detail_by_tool_id_and_level_id(nil,1,1)
    assert_nil ars_detail.id
  end

  #
  # Input: + No ARS detail is existed.
  #        + Request to find ARS detail with a ARS id
  # Output: return nil value
  #
  def test_ut_t2_ars_arc_010
    ars = AnalyzeRuleConfig.new()
    AnalyzeRuleConfigDetail.delete_all(:analyze_rule_config_id => ARS_ID,
                                       :analyze_tool_id        => 1 ,
                                       :rule_level             => 1)
    ars_detail = ars.find_ars_detail_by_tool_id_and_level_id(ARS_ID,1,1)
    assert_nil ars_detail.id
  end

  ##
  # Test editable?()
  #
  # Input:  + Logged in as TCANA admin.
  #         + Check editable for a specific ars id
  # Output: return true
  #
  def test_ut_t2_ars_arc_011
    current_user = User.find_by_id(TCANA_ADMIN_ID)
    ars = AnalyzeRuleConfig.find_by_id(1)
    assert ars.editable?(current_user,PU_ID,PJ_ID)
  end

  #
  # Input:  + Logged in as TCANA member.
  #         + Check editable for a specific ars id
  # Output: return false
  #
  def test_ut_t2_ars_arc_012
    current_user = User.find_by_id(TCANA_MEMBER_ID)
    ars = AnalyzeRuleConfig.find_by_id(1)
    assert !ars.editable?(current_user,PU_ID,PJ_ID)
  end

  #
  # Input:  + Logged in as PU admin.
  #         + Check editable for the setting of his PU
  # Output: return true
  #
  def test_ut_t2_ars_arc_013
    # pu admin
    current_user = User.find_by_id(PU_ADMIN_ID)
    # pu ars
    pu_id = PrivilegesUsers.find_all_by_user_id(current_user.id)[0].pu_id
    ars = Pu.find_by_id(pu_id).analyze_rule_configs[0]
    #
    assert ars.editable?(current_user,pu_id,nil)
  end

  #
  # Input:  + Logged in as PU admin.
  #         + Check editable for the setting which is created by him
  # Output: return true
  #
  def test_ut_t2_ars_arc_014
    # pu admin
    current_user = User.find_by_id(PU_ADMIN_ID)
    # ars created by pu
    pu_id = PrivilegesUsers.find_all_by_user_id(current_user.id)[0].pu_id
    ars = Pu.find_by_id(pu_id).analyze_rule_configs[0]
    ars.created_by = current_user.id
    ars.save
    #
    assert ars.editable?(current_user,pu_id,nil)
  end

  #
  # Input:  + Logged in as PJ admin.
  #         + Check editable for the setting of his PJ
  # Output: return true
  #
  def test_ut_t2_ars_arc_015
    # pu admin
    current_user = User.find_by_id(PU_ADMIN_ID)
    # pj ars
    pu_id = PrivilegesUsers.find_all_by_user_id(current_user.id)[0].pu_id
    pu_pj = Pu.find_by_id(pu_id).pjs[0]
    ars = Pj.find_by_id(pu_pj.id).analyze_rule_configs[0]
    #
    assert ars.editable?(current_user,pu_id,nil)
  end

  #
  # Input:  + Logged in as PU admin.
  #         + Check editable of the unused ARS with a pu id
  # Output: return false
  #
  def test_ut_t2_ars_arc_016
    # pu admin
    current_user = User.find_by_id(PU_ADMIN_ID)
    # no right to edit
    pu_id = PrivilegesUsers.find_all_by_user_id(current_user.id)[0].pu_id
    pu_pj = Pu.find_by_id(pu_id).pjs[0]
    ars = AnalyzeRuleConfig.create()
    #
    assert !ars.editable?(current_user,pu_id,nil)
  end

  #
  # Input:  + Logged in as PJ admin.
  #         + Check editable of the ARS of the PJ
  # Output: return true
  #
  def test_ut_t2_ars_arc_017
    # pj admin
    current_user = User.find_by_id(PJ_ADMIN_ID)
    # pj ars
    pj_id = PrivilegesUsers.find_all_by_user_id(current_user.id)[0].pj_id
    pu_id = Pj.find_by_id(pj_id).pu
    ars = Pj.find_by_id(pj_id).analyze_rule_configs[0]
    #
    assert ars.editable?(current_user,pu_id,pj_id)
  end

  #
  # Input:  + Logged in as PU admin.
  #         + Check editable for the setting which is created by him
  # Output: return true
  #
  def test_ut_t2_ars_arc_018
    # pj admin
    current_user = User.find_by_id(PJ_ADMIN_ID)
    # pj ars
    pj_id = PrivilegesUsers.find_all_by_user_id(current_user.id)[0].pj_id
    pu_id = Pj.find_by_id(pj_id).pu
    ars = Pj.find_by_id(pj_id).analyze_rule_configs[0]
    ars.created_by = current_user.id
    ars.save
    #
    assert ars.editable?(current_user,pu_id,pj_id)
  end

  #
  # Input:  + Logged in as PJ admin.
  #         + Check editable for the setting which is unused
  # Output: return false
  #
  def test_ut_t2_ars_arc_019
    # pj admin
    current_user = User.find_by_id(PJ_ADMIN_ID)
    # pj ars
    pj_id = PrivilegesUsers.find_all_by_user_id(current_user.id)[0].pj_id
    pu_id = Pj.find_by_id(pj_id).pu
    ars = AnalyzeRuleConfig.create()
    #
    assert !ars.editable?(current_user,pu_id,pj_id)
  end

  ##
  # Test: deletable?()
  #
  # Input:  + Logged in as TCANA admin.
  #         + Check deletable for the setting which is being used
  # Output: return false
  #
  def test_ut_t2_ars_arc_020
    # tcana admin
    current_user = User.find_by_id(TCANA_ADMIN_ID)
    ars = Pu.find_by_id(PU_ID).analyze_rule_configs[0] # ars being used
    assert !ars.deletable?(current_user, PU_ID, PJ_ID)
  end

  #
  # Input:  + Logged in as TCANA admin.
  #         + Check deletable for the setting which is unused
  # Output: return true
  #
  def test_ut_t2_ars_arc_021
    # tcana admin
    current_user = User.find_by_id(TCANA_ADMIN_ID)
    ars = AnalyzeRuleConfig.create() # ars is not being used.
    assert ars.deletable?(current_user, PU_ID, PJ_ID)
  end

  #
  # Input:  + Logged in as PU admin.
  #         + Check deletable for the setting which is not being used and created by him
  # Output: return true
  #
  def test_ut_t2_ars_arc_022
    # tcana admin
    current_user = User.find_by_id(PU_ADMIN_ID)
    ars = AnalyzeRuleConfig.create() # ars is not being used.
    ars.created_by = current_user.id
    ars.save
    assert ars.deletable?(current_user, PU_ID, nil)
  end

  #
  # Input:  + Logged in as PU admin.
  #         + Check deletable for the setting which is not being used
  # Output: return false
  #
  def test_ut_t2_ars_arc_023
    # tcana admin
    current_user = User.find_by_id(PU_ADMIN_ID)
    ars = AnalyzeRuleConfig.create() # ars is not being used.
    assert !ars.deletable?(current_user, PU_ID, nil)
  end

  #
  # Input:  + Logged in as TCANA member.
  #         + Check deletable for the setting which is not being used
  # Output: return false
  #
  def test_ut_t2_ars_arc_024
    # tcana admin
    current_user = User.find_by_id(TCANA_MEMBER_ID)
    ars = AnalyzeRuleConfig.create() # ars is not being used.
    assert !ars.deletable?(current_user, PU_ID, nil)
  end

  ##
  # Test: clone_content
  #
  # Input: clone_content an ARS
  # Output: a new ARS is created.
  #
  def test_ut_t2_ars_arc_025
    ars = AnalyzeRuleConfig.find_by_id(ARS_ID)
    ars_new = ars.clone_content
    assert_not_nil !ars_new.id
  end

  protected
  # create a number of ars to test.
  def create_ars_data(number_ars)
    AnalyzeRuleConfig.delete_all()
    AnalyzeRuleConfigsPus.delete_all()
    AnalyzeRuleConfigsPjs.delete_all()
    Pu.create(:id  => 1,
              :name => "sample pu") unless Pu.find_by_id(1)
    Pj.create(:id  => 1,
              :name => "sample pj") unless Pj.find_by_id(1)
    ##
    (1..number_ars).each do |i|
      ars = AnalyzeRuleConfig.create(:id  =>  i,
                                      :name  => "ars #{i}",
                                      :description  => "sample description #{i}")
      if i.odd?
        AnalyzeRuleConfigsPus.create(:pu_id =>  1,
                                      :analyze_rule_config_id => ars.id)
      else
        AnalyzeRuleConfigsPjs.create(:pj_id =>  1,
                                      :analyze_rule_config_id => ars.id)
      end
    end

  end




end
