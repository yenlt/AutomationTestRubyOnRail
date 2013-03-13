require File.dirname(__FILE__) + '/../test_helper'

class MasterTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_valid_with_exist_attributes
    master = Master.new
    assert_equal nil,master.revision
    assert_equal nil,master.repo_path
  end
end
