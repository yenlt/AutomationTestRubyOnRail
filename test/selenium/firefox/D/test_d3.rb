require File.dirname(__FILE__) + "/test_d_setup" unless defined? TestDSetup

class TestD < Test::Unit::TestCase
  include TestDSetup
  def test_030
    # selenium does not support downloading files
    printf "\n+ Selenium does not support this test case!"
    assert(true)
  end

  def test_031
    test_030
  end

  def test_032
    test_030
  end

  def test_033
    test_030
  end

  def test_034
    test_030
  end

end
