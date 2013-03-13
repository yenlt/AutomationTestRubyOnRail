require File.dirname(__FILE__) + '/../test_helper'

class AnalyzeConfigTest < ActiveSupport::TestCase
  # Fixtures
  fixtures :users
  fixtures :privileges
  fixtures :privileges_users
  #
  OUT_SIDE_NUMBER = 1000
  PU_ID = 1
  PJ_ID = 1
  ATS_ID = 1
  TCANA_ADMIN_ID = 1
  PU_ADMIN_ID = 2
  PJ_ADMIN_ID = 3
  TCANA_MEMBER_ID = 4
  
  ##
  # Test paginate_ats()
  #
  # Input: No ATS is exited.
  # Output: ats list = []
  #
  def test_ut_t2_ats_ac_001
    AnalyzeConfig.delete_all()
    ats_list = AnalyzeConfig.paginate_ats(1,nil,nil)
    assert_equal 0, ats_list.size
  end

  #
  # Input: paginate ats with an out side number (very large)
  # Output: ats list = []
  #
  def test_ut_t2_ats_ac_002
    ats_list = AnalyzeConfig.paginate_ats(OUT_SIDE_NUMBER,nil,nil )
    assert_equal 0, ats_list.size
  end

  #
  # Input: 15 ats is exited in ATS data table
  # Output: + number of ats in the first page is 10
  #         + number of the second page is 5
  #
  def test_ut_t2_ats_ac_003
    create_ats_data(15)
    ats_1 = AnalyzeConfig.paginate_ats(1,nil,nil )
    assert_equal ats_1.size,10
    ats_2 = AnalyzeConfig.paginate_ats(2,nil,nil )
    assert_equal ats_2.size,5
  end

  #
  # Input: paginate ats with sort condition (ASC) for each field
  # Output: ats list is sorted.
  #
  def test_ut_t2_ats_ac_004
    create_ats_data(15)
    # sort with id
    atss = AnalyzeConfig.paginate_ats(1,"id","ASC" )
    if atss[1].id <= atss[2].id
      assert true
    else
      assert false
    end
    # sort with name
    atss = AnalyzeConfig.paginate_ats(1,"name","ASC" )
    if atss[1].name <= atss[2].name
      assert true
    else
      assert false
    end
    # sort with description
    atss = AnalyzeConfig.paginate_ats(1,"description","ASC" )
    if atss[1].description <= atss[2].description
      assert true
    else
      assert false
    end
    # sort with created at
    atss = AnalyzeConfig.paginate_ats(1,"created_at","ASC" )
    if atss[1].created_at <= atss[2].created_at
      assert true
    else
      assert false
    end
    # sort with updated at
    atss = AnalyzeConfig.paginate_ats(1,"updated_at","ASC" )
    if atss[1].updated_at <= atss[2].updated_at
      assert true
    else
      assert false
    end
  end

  #
  # Input: paginate ats with sort condition (DESC) for each field
  # Output: ats list is sorted.
  #
  def test_ut_t2_ats_ac_005
    create_ats_data(15)
    #sort with id
    atss = AnalyzeConfig.paginate_ats(1,"id","DESC" )
    if atss[1].id >= atss[2].id
      assert true
    else
      assert false
    end
    #sort with name
    atss = AnalyzeConfig.paginate_ats(1,"name","DESC" )
    if atss[1].name >= atss[2].name
      assert true
    else
      assert false
    end
    #sort with description
    atss = AnalyzeConfig.paginate_ats(1,"description","DESC" )
    if atss[1].description >= atss[2].description
      assert true
    else
      assert false
    end
    #sort with created at
    atss = AnalyzeConfig.paginate_ats(1,"created_at","DESC" )
    if atss[1].created_at >= atss[2].created_at
      assert true
    else
      assert false
    end
    #sort with updated at
    atss = AnalyzeConfig.paginate_ats(1,"updated_at","DESC" )
    if atss[1].updated_at >= atss[2].updated_at
      assert true
    else
      assert false
    end
  end

  ##
  # Test get_ats_detail()
  #
  # Input: Find a ats detail with a specific ats id, tool id
  # Output: return a ats
  #
  def test_ut_t2_ats_ac_006
    ats = AnalyzeConfig.new()
    ats_detail = ats.get_ats_details(ATS_ID,1)
    assert_not_nil ats_detail
    assert_equal ATS_ID, ats_detail.analyze_config_id
  end
  
  #
  # Input: Find a ats detail with ats id
  # Output: return nil value
  #
  def test_ut_t2_ats_ac_007
    ats = AnalyzeConfig.new()
    ats_detail = ats.get_ats_details(nil, 1)
    assert_nil ats_detail.id
  end

  #
  # Input: + No ATS detail is existed.
  #        + Request to find ATS detail with a ATS id
  # Output: return nil value
  #
  def test_ut_t2_ats_ac_008
    ats = AnalyzeConfig.new()
    AnalyzeConfigDetail.delete_all(:analyze_config_id => ATS_ID)
    ats_detail = ats.get_ats_details(ATS_ID,1)
    assert_nil ats_detail.id
  end

  ##
  # Test editable?()
  #
  # Input:  + Logged in as TCANA admin.
  #         + Check editable for a specific ats id
  # Output: return true
  #
  def test_ut_t2_ats_ac_009
    current_user = User.find_by_id(TCANA_ADMIN_ID)
    ats = AnalyzeConfig.find(:first)
    assert ats.editable?(current_user,PU_ID,PJ_ID)
  end

  #
  # Input:  + Logged in as TCANA member.
  #         + Check editable for a specific ats id
  # Output: return false
  #
  def test_ut_t2_ats_ac_010
    current_user = User.find_by_id(TCANA_MEMBER_ID)
    ats = AnalyzeConfig.find(:first)
    assert !ats.editable?(current_user,PU_ID,PJ_ID)
  end

  #
  # Input:  + Logged in as PU admin.
  #         + Check editable for the setting of his PU
  # Output: return true
  #
  def test_ut_t2_ats_ac_011
    # pu admin
    current_user = User.find_by_id(PU_ADMIN_ID)
    # pu ats
    pu_id = PrivilegesUsers.find_all_by_user_id(current_user.id)[0].pu_id
    ats = Pu.find_by_id(pu_id).analyze_configs[0]
    #
    assert ats.editable?(current_user,pu_id,nil)
  end

  #
  # Input:  + Logged in as PU admin.
  #         + Check editable for the setting which is created by him/her
  # Output: return true
  #
  def test_ut_t2_ats_ac_012
    # pu admin
    current_user = User.find_by_id(PU_ADMIN_ID)
    # ats created by pu
    pu_id = PrivilegesUsers.find_all_by_user_id(current_user.id)[0].pu_id
    ats = Pu.find_by_id(pu_id).analyze_configs[0]
    ats.created_by = current_user.id
    ats.save
    #
    assert ats.editable?(current_user,pu_id,nil)
  end

  #
  # Input:  + Logged in as PJ admin.
  #         + Check editable for the setting of his PJ
  # Output: return true
  #
  def test_ut_t2_ats_ac_013
    # pu admin
    current_user = User.find_by_id(PU_ADMIN_ID)
    # pj ats
    pu_id = PrivilegesUsers.find_all_by_user_id(current_user.id)[0].pu_id
    pu_pj = Pu.find_by_id(pu_id).pjs[0]
    ats = Pj.find_by_id(pu_pj.id).analyze_configs[0]
    #
    assert ats.editable?(current_user,pu_id,nil)
  end

  #
  # Input:  + Logged in as PU admin.
  #         + Check editable of the unused ATS with a pu id
  # Output: return false
  #
  def test_ut_t2_ats_ac_014
    # pu admin
    current_user = User.find_by_id(PU_ADMIN_ID)
    # no right to edit
    pu_id = PrivilegesUsers.find_all_by_user_id(current_user.id)[0].pu_id
    pu_pj = Pu.find_by_id(pu_id).pjs[0]
    ats = AnalyzeConfig.create()
    #
    assert !ats.editable?(current_user,pu_id,nil)
  end

  #
  # Input:  + Logged in as PJ admin.
  #         + Check editable of the ATS of the PJ
  # Output: return true
  #
  def test_ut_t2_ats_ac_015
    # pj admin
    current_user = User.find_by_id(PJ_ADMIN_ID)
    # pj ats
    pj_id = PrivilegesUsers.find_all_by_user_id(current_user.id)[0].pj_id
    pu_id = Pj.find_by_id(pj_id).pu
    ats = Pj.find_by_id(pj_id).analyze_configs[0]
    #
    assert ats.editable?(current_user,pu_id,pj_id)
  end

  #
  # Input:  + Logged in as PU admin.
  #         + Check editable for the setting which is created by him
  # Output: return true
  #
  def test_ut_t2_ats_ac_016
    # pj admin
    current_user = User.find_by_id(PJ_ADMIN_ID)
    # pj ats
    pj_id = PrivilegesUsers.find_all_by_user_id(current_user.id)[0].pj_id
    pu_id = Pj.find_by_id(pj_id).pu
    ats = Pj.find_by_id(pj_id).analyze_configs[0]
    ats.created_by = current_user.id
    ats.save
    #
    assert ats.editable?(current_user,pu_id,pj_id)
  end

  #
  # Input:  + Logged in as PJ admin.
  #         + Check editable for the setting which is unused
  # Output: return false
  #
  def test_ut_t2_ats_ac_017
    # pj admin
    current_user = User.find_by_id(PJ_ADMIN_ID)
    # pj ats
    pj_id = PrivilegesUsers.find_all_by_user_id(current_user.id)[0].pj_id
    pu_id = Pj.find_by_id(pj_id).pu
    ats = AnalyzeConfig.create()
    #
    assert !ats.editable?(current_user,pu_id,pj_id)
  end

  ##
  # Test: deletable?()
  #
  # Input:  + Logged in as TCANA admin.
  #         + Check deletable for the setting which is being used
  # Output: return false
  #
  def test_ut_t2_ats_ac_018
    # tcana admin
    current_user = User.find_by_id(TCANA_ADMIN_ID)
    ats = Pu.find_by_id(PU_ID).analyze_configs[0] # ats being used
    assert !ats.deletable?(current_user, PU_ID, PJ_ID)
  end

  #
  # Input:  + Logged in as TCANA admin.
  #         + Check deletable for the setting which is unused
  # Output: return true
  #
  def test_ut_t2_ats_ac_019
    # tcana admin
    current_user = User.find_by_id(TCANA_ADMIN_ID)
    ats = AnalyzeConfig.create() # ats is not being used.
    assert ats.deletable?(current_user, PU_ID, PJ_ID)
  end

  #
  # Input:  + Logged in as PU admin.
  #         + Check deletable for the setting which is not being used and created by him
  # Output: return true
  #
  def test_ut_t2_ats_ac_020
    # tcana admin
    current_user = User.find_by_id(PU_ADMIN_ID)
    ats = AnalyzeConfig.create() # ats is not being used.
    ats.created_by = current_user.id
    ats.save
    assert ats.deletable?(current_user, PU_ID, nil)
  end

  #
  # Input:  + Logged in as PU admin.
  #         + Check deletable for the setting which is not being used
  # Output: return false
  #
  def test_ut_t2_ats_ac_021
    # tcana admin
    current_user = User.find_by_id(PU_ADMIN_ID)
    ats = AnalyzeConfig.create() # ats is not being used.
    assert !ats.deletable?(current_user, PU_ID, nil)
  end

  #
  # Input:  + Logged in as TCANA member.
  #         + Check deletable for the setting which is not being used
  # Output: return false
  #
  def test_ut_t2_ats_ac_022
    # tcana admin
    current_user = User.find_by_id(TCANA_MEMBER_ID)
    ats = AnalyzeConfig.create() # ats is not being used.
    assert !ats.deletable?(current_user, PU_ID, nil)
  end

  ##
  # Test: clone_content
  #
  # Input: clone_content an ATS
  # Output: a new ATS is created.
  #
  def test_ut_t2_ats_ac_023
    ats = AnalyzeConfig.find_by_id(ATS_ID)
    ats_new = ats.clone_content
    assert_not_nil !ats_new.id
  end

  protected
  # create a number of ats to test.
  def create_ats_data(number_ats)
    AnalyzeConfig.delete_all()
    AnalyzeConfigsPus.delete_all()
    AnalyzeConfigsPjs.delete_all()
    Pu.create(:id  => 1,
              :name => "sample pu") unless Pu.find_by_id(1)
    Pj.create(:id  => 1,
              :name => "sample pj") unless Pj.find_by_id(1)
    ##
    (1..number_ats).each do |i|
      ats = AnalyzeConfig.create(:id  =>  i,
                                 :name  => "ats #{i}",
                                 :description  => "sample description #{i}")
      if i.odd?
        AnalyzeConfigsPus.create(:pu_id =>  1,
                                 :analyze_config_id => ats.id)
      else
        AnalyzeConfigsPjs.create(:pj_id =>  1,
                                 :analyze_config_id => ats.id)
      end
    end

  end
end
