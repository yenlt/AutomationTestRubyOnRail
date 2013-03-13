require File.dirname(__FILE__) + '/../test_helper'

class RedmineProjectTest < Test::Unit::TestCase
  def setup

  end

  def teardown
#    Comment.delete_all
  end

  #########################################################
	##				Test Task5 2011A														###
	#########################################################
  # test get_users
  # existed various member of this PJ
  def test_ut_cbtt11a_t5_rp_001
      redmine_pj_id = 1
      project = RedmineProject.find(redmine_pj_id)
      users = project.get_users
      # check existence of users who are member of this Pj
      assert_equal(users.nil?, false)
  end

  # existed a member of this PJ
  def test_ut_cbtt11a_t5_rp_002
      redmine_pj_id = 3
      project = RedmineProject.find(redmine_pj_id)
      users = project.get_users
      # check existence of users who are member of this Pj
      assert_equal(users.nil?, false)
  end

  # not existed member of this PJ
  def test_ut_cbtt11a_t5_rp_003
      # delete all user of system
      members = RedmineMember.find(:all)
      members.each do |member|
          member.destroy
      end
      redmine_pj_id = 1
      project = RedmineProject.find(redmine_pj_id)
      users = project.get_users
      # check existence of users who are member of this Pj
      assert_equal(users.blank?, true)
  end

  # test check_is_children?
  # is children
  def test_ut_cbtt11a_t5_rp_004
      parent_pj_id = 1
      children_pj_id_1 = 3
      children_pj_id_2 = 4
      children_pj_id_3 = 1

      # check is children
      assert_equal(RedmineProject.check_is_children?(parent_pj_id, children_pj_id_1), true)
      assert_equal(RedmineProject.check_is_children?(parent_pj_id, children_pj_id_2), true)
      assert_equal(RedmineProject.check_is_children?(parent_pj_id, children_pj_id_3), false)
  end

  # is not children
  def test_ut_cbtt11a_t5_rp_005
      parent_pj_id = 6
      children_pj_id_1 = 3
      children_pj_id_2 = 4
      children_pj_id_3 = 1

      # check is children
      assert_equal(RedmineProject.check_is_children?(parent_pj_id, children_pj_id_1), false)
      assert_equal(RedmineProject.check_is_children?(parent_pj_id, children_pj_id_2), false)
      assert_equal(RedmineProject.check_is_children?(parent_pj_id, children_pj_id_3), false)
  end

  # is not children
  def test_ut_cbtt11a_t5_rp_006
      parent_pj_id = 6
      children_pj_id_2 = 4
      children_pj_id_3 = 1

      # check is children
      assert_equal(RedmineProject.check_is_children?(parent_pj_id, parent_pj_id), false)
      assert_equal(RedmineProject.check_is_children?(children_pj_id_2, children_pj_id_2), false)
      assert_equal(RedmineProject.check_is_children?(children_pj_id_3, children_pj_id_3), false)
  end

  # test children function
  # have enormous children
  def test_ut_cbtt11a_t5_rp_007
      parent_pj_id_1 = 1
      parent_pj_id_2 = 5
      parent_pj_id_3 = 6

      # check children
      assert_equal(RedmineProject.children(parent_pj_id_1).blank?, false)
      assert_equal(RedmineProject.children(parent_pj_id_2).blank?, false)
      assert_equal(RedmineProject.children(parent_pj_id_3).blank?, true)
  end

  # have a children
  def test_ut_cbtt11a_t5_rp_008
      parent_pj_id_1 = 1
      parent_pj_id_2 = 3
      parent_pj_id_3 = 6

      # check children
      assert_equal(RedmineProject.children(parent_pj_id_1).blank?, false)
      assert_equal(RedmineProject.children(parent_pj_id_2).blank?, true)
      assert_equal(RedmineProject.children(parent_pj_id_3).blank?, true)
  end

  # have not children
  def test_ut_cbtt11a_t5_rp_009
      parent_pj_id_1 = 2
      parent_pj_id_2 = 4
      parent_pj_id_3 = 5

      # check children
      assert_equal(RedmineProject.children(parent_pj_id_1).blank?, true)
      assert_equal(RedmineProject.children(parent_pj_id_2).blank?, true)
      assert_equal(RedmineProject.children(parent_pj_id_3).blank?, false)
  end

  # test parents function
  # have many parents
  def test_ut_cbtt11a_t5_rp_010
      children_pj_id_1 = 1
      children_pj_id_2 = 4
      children_pj_id_3 = 5

      # check children
      assert_equal(RedmineProject.parents(children_pj_id_1).blank?, true)
      assert_equal(RedmineProject.parents(children_pj_id_2).blank?, false)
      assert_equal(RedmineProject.parents(children_pj_id_3).blank?, false)
  end

  # have a parents
  def test_ut_cbtt11a_t5_rp_011
      children_pj_id_1 = 1
      children_pj_id_2 = 2
      children_pj_id_3 = 3

      # check children
      assert_equal(RedmineProject.parents(children_pj_id_1).blank?, true)
      assert_equal(RedmineProject.parents(children_pj_id_2).blank?, true)
      assert_equal(RedmineProject.parents(children_pj_id_3).blank?, false)
  end

  # have not parents
  def test_ut_cbtt11a_t5_rp_012
      children_pj_id_1 = 1
      children_pj_id_2 = 2
      children_pj_id_3 = 6
      
      # check children
      assert_equal(RedmineProject.parents(children_pj_id_1).blank?, true)
      assert_equal(RedmineProject.parents(children_pj_id_2).blank?, true)
      assert_equal(RedmineProject.parents(children_pj_id_3).blank?, false)
  end
end
