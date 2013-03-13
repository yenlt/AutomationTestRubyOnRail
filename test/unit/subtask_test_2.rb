require File.dirname(__FILE__) + '/../test_helper'

class SubtaskTest < ActiveSupport::TestCase
  #
  #
  #
  def test_ut_t6_bsf_sub_001
    sub = Subtask.new
    backend_name = ""
    result = sub.check_backend(backend_name)
    assert_equal result, false
  end
  #
  #
  #
  def test_ut_t6_bsf_sub_002
    sub = Subtask.find(:first)
    backend_name = "other backend"
    result = sub.check_backend(backend_name)
    assert_equal result, false
  end
  #
  #
  #
  def test_ut_t6_bsf_sub_003
    sub = Subtask.find(:first)
    backend_name = "test"
    result = sub.check_backend(backend_name)
    assert_equal result, true
  end
  #
  #
  #
  def test_ut_t6_bsf_sub_004
    sub = Subtask.find(:last)
    backend_name = "d-466vm"
    result = sub.check_backend(backend_name)
    assert_equal result, false
  end
  #
  #
  #
  def test_ut_t6_bsf_sub_005
    sub = Subtask.find_by_id(10000)
    backend_name = "test"
    begin
      sub.check_backend(backend_name)
    rescue
      assert true
    end
  end
end