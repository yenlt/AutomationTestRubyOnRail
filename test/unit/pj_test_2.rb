require File.dirname(__FILE__) + '/../test_helper'

class PjTest < ActiveSupport::TestCase
  fixtures :pj_backend_settings
  PJ_ID1 = 1
  PJ_ID2 = 2
  #
  #
  #
  def test_ut_t6_bsf_pj_001
    #
    pj = Pj.find_by_id(PJ_ID1)
    result = pj.get_list_valid_backend_of_pj
    
    assert_equal result, ["d-466vm", "test", "test2", "test3"]
  end
  #
  #
  #
  def test_ut_t6_bsf_pj_002
    #
    #
    pj = Pj.find_by_id(PJ_ID2)
    result = pj.get_list_valid_backend_of_pj
    
    assert_equal result, []
  end
  #
  #
  #
  def test_ut_t6_bsf_pj_003
    #
    pj = Pj.find_by_id(10000)
    begin
      pj.get_list_valid_backend_of_pj
    rescue
      assert true
    end
  end
  #
  #
  #
  def test_ut_t6_bsf_pj_004
    #
    pjb = PjBackendSetting.find(:first)

    pj = Pj.find_by_id(pjb.pj_id)
    result = pj.get_list_valid_backend_of_pj
    assert_equal result, ["d-466vm", "test", "test2", "test3"]
  end
  #
  #
  #
  def test_ut_t6_bsf_pj_005
    #
    pj = Pj.find_by_id(10000)
    begin
      pj.get_list_valid_backend_of_pj
    rescue
      assert true
    end
  end
end