require File.dirname(__FILE__) + '/../test_helper'

class ResultDirectoryTest < ActiveSupport::TestCase
  include AuthenticatedTestHelper
	# test: get_file_paths
	def test_ut_rsf10a_t3_resd_001
		children = ResultDirectory.find(:all,
																		:conditions => {:id => 3})
    subtask_id = 1
		file_paths = ResultDirectory.get_file_paths(1)
		assert_equal children, file_paths
	end

	def test_ut_rsf10a_t3_resd_002
		children = []
		subtask_id = -1
		file_paths = ResultDirectory.get_file_paths(-1)
		assert_equal children, file_paths
	end
end