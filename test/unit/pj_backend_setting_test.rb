require File.dirname(__FILE__) + '/../test_helper'

class PjBackendSettingTest < ActiveSupport::TestCase
  PJ_ID_1 = 1
  PJ_ID_2 = 3
  #
  #
  #
  def test_ut_t6_bsf_pbs_001
    create_new_pj
    newest_pj = Pj.find(:last)                 
    PjBackendSetting.init_backend_setting_when_new_pj_created(newest_pj.id)                 
    new_setting = PjBackendSetting.find(:last)
    
    assert_equal new_setting.pj_id, newest_pj.id
    assert_equal new_setting.regex_string, ".*"
    assert_equal new_setting.backend_id, nil

    delete_new_pj
  end
  #
  #
  #
  def test_ut_t6_bsf_pbs_002
    # pj_id is nil
    check = PjBackendSetting.init_backend_setting_when_new_pj_created(nil)
    assert_equal check, nil
  end
  #
  #
  #
  def test_ut_t6_bsf_pbs_003
    # pj_id is invalid
    check = PjBackendSetting.init_backend_setting_when_new_pj_created(10000)
    assert_equal check, false
  end
  #
  #
  #
  def test_ut_t6_bsf_pbs_004
    #
    create_new_pj
    pj = Pj.find(:last)
    new = PjBackendSetting.new
    data = "d*"
    type = "regex"
    result = new.save_setting(data, pj.id, type )

    assert_equal result, true

    delete_new_pj
  end
  #
  #
  #
  def test_ut_t6_bsf_pbs_005
    #
    new = PjBackendSetting.new
    data = "d*"
    type = "XXX"
    result = new.save_setting(data, PJ_ID_1, type )

    assert_equal result, false
  end
  #
  #
  #
  def test_ut_t6_bsf_pbs_006
    #
    new = PjBackendSetting.new
    data = "d*"
    type = "regex"
    result = new.save_setting(data, nil, type )

    assert_equal result, false
  end
  #
  #
  #
  def test_ut_t6_bsf_pbs_007
    #
    create_new_pj
    pj = Pj.find(:last)
    new = PjBackendSetting.new
    data = ["2", "3", "4"]
    type = "list"
    result = new.save_setting(data, pj.id, type )

    assert_equal result, true

    delete_new_pj
  end
  #
  #
  #
  def test_ut_t6_bsf_pbs_008
    #
    new = PjBackendSetting.new
    data = ["2", "3", "4"]
    type = "XXX"
    result = new.save_setting(data, PJ_ID_1, type )

    assert_equal result, false
  end
  #
  #
  #
  def test_ut_t6_bsf_pbs_009
    #save setting when list is empty
    new = PjBackendSetting.new
    data = []
    type = "list"
    result = new.save_setting(data, PJ_ID_1, type )
    assert_equal result, true
  end
  #
  #
  #
  def test_ut_t6_bsf_pbs_010
    #
    new = PjBackendSetting.new
    data = ["2", "3", "4"]
    type = "XXX"
    result = new.save_setting(data, PJ_ID_1, type )

    assert_equal result, false
  end
  #
  #
  #
  def test_ut_t6_bsf_pbs_011
    # SamplePJBlank is test PJ: pj_id = 3
    new = PjBackendSetting.new
    new_data = "d*"    
    result = new.save_backend_setting_by_regex(new_data, nil, PJ_ID_2)

    assert_equal result, true

    PjBackendSetting.delete(:last)
  end
  #
  #
  #
  def test_ut_t6_bsf_pbs_012
    # create test data
    new = PjBackendSetting.new
    old_data = "d*"
    new.save_backend_setting_by_regex(old_data, nil, PJ_ID_2)
    
    #update PjBackendSetting
    new_data = "t*"
    new.save_setting(new_data, PJ_ID_2, "regex")

    new_setting = PjBackendSetting.find_by_pj_id(PJ_ID_2)
    assert_equal new_setting.pj_id, PJ_ID_2
    assert_equal new_setting.regex_string, "t*"

    PjBackendSetting.delete_all(:pj_id => PJ_ID_2)
  end
  #
  #
  #
  def test_ut_t6_bsf_pbs_013
    #
    # create test data
    new = PjBackendSetting.new
    old_data = ["2", "3", "4"]
    new.save_backend_setting_by_regex(old_data, nil, PJ_ID_2)
    #update PjBackendSetting
    new_data = "t*"
    new.save_setting(new_data, PJ_ID_2, "regex")

    ns = PjBackendSetting.find_by_pj_id(PJ_ID_2)
    
    assert_equal ns.pj_id, PJ_ID_2
    assert_equal ns.backend_id, nil
    assert_equal ns.regex_string, "t*"

    PjBackendSetting.delete_all(:pj_id => PJ_ID_2)
  end
  #
  #
  #
  def test_ut_t6_bsf_pbs_014
    #
    new = PjBackendSetting.new
    data = nil
    result = new.save_backend_setting_by_list(data, nil, PJ_ID_2)

    assert_equal result, true
  end  
  #
  #
  #
  def test_ut_t6_bsf_pbs_015
    # SamplePJBlank is test PJ: pj_id = 3
    new = PjBackendSetting.new
    new_data = ["1"]
    result = new.save_backend_setting_by_list(new_data, nil, PJ_ID_2)

    assert_equal result, true

    PjBackendSetting.delete_all(:pj_id => PJ_ID_2)
  end
  #
  #
  #
  def test_ut_t6_bsf_pbs_016
    # 
    new = PjBackendSetting.new    
    new_data = [""]
    result = new.save_backend_setting_by_list(new_data, nil, PJ_ID_2)

    new_setting = PjBackendSetting.find_by_pj_id(PJ_ID_2)
    assert_equal result, true
    !assert_equal new_setting.pj_id, PJ_ID_2
  end
  #
  #
  #
  def test_ut_t6_bsf_pbs_017
    #
    #delete old data
    PjBackendSetting.delete_all(:pj_id => PJ_ID_2)
    # create test data
    new = PjBackendSetting.new
    old_data = ".*"
    new.save_backend_setting_by_regex(old_data, nil, PJ_ID_2)
    #update PjBackendSetting
    new_data = ["2", "3"]
    new.save_setting(new_data, PJ_ID_2, "list")

    new_setting = PjBackendSetting.find_all_by_pj_id(PJ_ID_2)
    new_setting.each do |ns|
      assert_equal ns.pj_id, PJ_ID_2
      assert_not_equal ns.backend_id, nil
      assert_equal ns.regex_string, nil
    end

    PjBackendSetting.delete_all(:pj_id => PJ_ID_2)
  end
  #
  #
  #
  def test_ut_t6_bsf_pbs_018
    #
    # create test data
    new = PjBackendSetting.new
    old_data = ".*"
    new.save_backend_setting_by_regex(old_data, nil, PJ_ID_2)
    #update PjBackendSetting
    new_data = []
    result = new.save_setting(new_data, PJ_ID_2, "list")
    assert_equal result, true
    
    new_setting = PjBackendSetting.find_by_pj_id(PJ_ID_2)
    assert_equal new_setting, nil
  end
  #
  #
  #
  def test_ut_t6_bsf_pbs_019
    #
    #delete old data
    PjBackendSetting.delete_all(:pj_id => PJ_ID_2)
    # create test data
    new = PjBackendSetting.new
    old_data = ["2", "3"]
    new.save_backend_setting_by_list(old_data, nil, PJ_ID_2)
    #update PjBackendSetting
    new_data = ["3", "4"]
    new.save_setting(new_data, PJ_ID_2, "list")

    new_setting = PjBackendSetting.find_all_by_pj_id(PJ_ID_2)
    new_setting.each do |ns|
      assert_equal ns.pj_id, PJ_ID_2
      assert_not_equal ns.backend_id, 2
      assert_equal ns.regex_string, nil
    end

    PjBackendSetting.delete_all(:pj_id => PJ_ID_2)
  end
  #
  #
  #
  def test_ut_t6_bsf_pbs_020
    #
    # create test data
    new = PjBackendSetting.new
    old_data = ["2", "3"]
    new.save_backend_setting_by_list(old_data, nil, PJ_ID_2)
    #update PjBackendSetting
    new_data = []
    result = new.save_setting(new_data, PJ_ID_2, "list")
    assert_equal result, true

    new_setting = PjBackendSetting.find_by_pj_id(PJ_ID_2)
    assert_equal new_setting, nil
  end


  def create_new_pj
    #create new PJ
    new_pj = Pj.create(:name => "New PJ",
                       :pu_id => 1,
                       :registry_user => 0)
  end

  def delete_new_pj
    Pj.delete(:last)
  end
end
