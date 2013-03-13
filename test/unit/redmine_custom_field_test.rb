require File.dirname(__FILE__) + '/../test_helper'

class RedmineCustomFieldTest < Test::Unit::TestCase
  def setup
  end

  def teardown
#    Comment.delete_all
  end

  #########################################################
	##				Test Task5 2011A														###
	#########################################################
  # test create_new_custom_field
  # custom fields have not existed
  def test_ut_cbtt11a_t5_rcf_001
      redmine_pj_id = 1
      RedmineCustomField.create_new_custom_fields(redmine_pj_id)
      # check existence of new custom field
      RedmineCustomField::NEW_CUSTOM_FIELDS.each do |custom_field|
          assert_equal(custom_field[0], RedmineCustomField.find_by_name(custom_field[0]).name)
      end
  end

  # custom fields has existed
  def test_ut_cbtt11a_t5_rcf_002
      parent_pj_id = 1
      child_pj_id = 3
      # delete redmine setting
      redmine_settings = RedmineSetting.find(:all)
      redmine_settings.each do |redmine_setting|
          redmine_setting.destroy
      end
      # delete custom field project
      redmine_custom_fields_project = RedmineCustomFieldProject.find(:all)
      redmine_custom_fields_project.each do |custom_field|
          RedmineCustomFieldProject.delete_all(:custom_field_id => custom_field.custom_field_id)
      end
      # delete custom field
      redmine_custom_fields = RedmineCustomField.find(:all)
      redmine_custom_fields.each do |custom_field|
          custom_field.destroy
      end


      
      RedmineCustomField.create_new_custom_fields(child_pj_id)
      # check existence of new custom field
      new_custom_fields = []
      RedmineCustomField::NEW_CUSTOM_FIELDS.each do |custom_field|
          new_custom_fields << RedmineCustomField.find_by_name(custom_field[0]).id
      end
      # test existence of custom field project for this project and all its hierachy
      new_custom_fields.each do |new|
          assert_equal(child_pj_id, RedmineCustomFieldProject.find_by_project_id_and_custom_field_id(child_pj_id, new).project_id)
          assert_equal(parent_pj_id, RedmineCustomFieldProject.find_by_project_id_and_custom_field_id(parent_pj_id, new).project_id)
      end
  end

   # new custom fields for this project and its hierachies has existed
  def test_ut_cbtt11a_t5_rcf_003
      parent_pj_id = 1
      child_pj_id = 3
      # create new custom fields
      RedmineCustomField.create_new_custom_fields(child_pj_id)
      # check existence of new custom field
      new_custom_fields = []
      RedmineCustomField::NEW_CUSTOM_FIELDS.each do |custom_field|
          new_custom_fields << RedmineCustomField.find_by_name(custom_field[0]).id
      end
      # recall to create function
      RedmineCustomField.create_new_custom_fields(parent_pj_id)
      RedmineCustomField.create_new_custom_fields(child_pj_id)
      # test existence of custom field project for this project and all its hierachy
      new_custom_fields.each do |new|
          assert_equal(child_pj_id, RedmineCustomFieldProject.find_by_project_id_and_custom_field_id(child_pj_id, new).project_id)
          assert_equal(parent_pj_id, RedmineCustomFieldProject.find_by_project_id_and_custom_field_id(parent_pj_id, new).project_id)
      end
  end

   # new custom fields for this project has existed
  def test_ut_cbtt11a_t5_rcf_004
      parent_pj_id = 5
      child_pj_id = 3
      # create new custom fields
      RedmineCustomField.create_new_custom_fields(child_pj_id)
      # check existence of new custom field
      new_custom_fields = []
      RedmineCustomField::NEW_CUSTOM_FIELDS.each do |custom_field|
          new_custom_fields << RedmineCustomField.find_by_name(custom_field[0]).id
      end
      # recall to create function
      RedmineCustomField.create_new_custom_fields(parent_pj_id)
      RedmineCustomField.create_new_custom_fields(child_pj_id)
      # test existence of custom field project for this project and all its hierachy
      new_custom_fields.each do |new|
          assert_equal(child_pj_id, RedmineCustomFieldProject.find_by_project_id_and_custom_field_id(child_pj_id, new).project_id)
          assert_equal(parent_pj_id, RedmineCustomFieldProject.find_by_project_id_and_custom_field_id(parent_pj_id, new).project_id)
      end
  end

  # new custom fields for hierachy of this project has existed
  def test_ut_cbtt11a_t5_rcf_005
      parent_pj_id = 1
      child_pj_id = 6
      # create new custom fields
      RedmineCustomField.create_new_custom_fields(child_pj_id)
      # check existence of new custom field
      new_custom_fields = []
      RedmineCustomField::NEW_CUSTOM_FIELDS.each do |custom_field|
          new_custom_fields << RedmineCustomField.find_by_name(custom_field[0]).id
      end
      # recall to create function
      RedmineCustomField.create_new_custom_fields(parent_pj_id)
      RedmineCustomField.create_new_custom_fields(child_pj_id)
      # test existence of custom field project for this project and all its hierachy
      new_custom_fields.each do |new|
          assert_equal(child_pj_id, RedmineCustomFieldProject.find_by_project_id_and_custom_field_id(child_pj_id, new).project_id)
          assert_equal(parent_pj_id, RedmineCustomFieldProject.find_by_project_id_and_custom_field_id(parent_pj_id, new).project_id)
      end
  end



end
