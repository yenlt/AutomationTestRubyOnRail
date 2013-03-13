require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/setup'
require 'ats_controller'

class AtsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  fixtures :users
  fixtures :privileges
  fixtures :privileges_users
  fixtures :analyze_configs
  fixtures :analyze_configs_pus
  fixtures :analyze_configs_pjs
  fixtures :analyze_config_details

  ADMIN = "root"
  PU_ADMIN = "pu_admin"
  PJ_ADMIN = "pj_admin"
  INVALID = 10000
  
  def setup
    @controller = AtsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_it_t2_ats_001
    #test INDEX function
    #request view ATS page from Admin menu
    login_as ADMIN
    post :index
    assert_response :success
    assert_template "index"
    ats = AnalyzeConfig.paginate_ats(1, nil, nil)
    @page_title = @controller.instance_variable_get "@page_title"
    assert_equal _("Analysis Tool Setting Administration"), @page_title
    ats.each do |a|
      assert_select "tr#setting_#{a.id}"
    end
  end

  def test_it_t2_ats_002
    #test INDEX function
    #request view ATS as PU
    login_as PU_ADMIN
    post :index, :pu => 1, :old_window => true
    assert_response :success
    assert_template "index"
    ats = AnalyzeConfig.paginate_ats(1, nil, nil)
    @page_title = @controller.instance_variable_get "@page_title"
    assert_equal _("Analysis Tool Setting Administration"), @page_title
    ats.each do |a|
      assert_select "tr#setting_#{a.id}"
    end
  end

  def test_it_t2_ats_003
    #test INDEX function
    #request view ATS as PJ
    login_as PJ_ADMIN
    post :index, :pj => 1, :old_window => true
    assert_response :success
    assert_template "index"
    ats = AnalyzeConfig.paginate_ats(1, nil, nil)
    @page_title = @controller.instance_variable_get "@page_title"
    assert_equal _("Analysis Tool Setting Administration"), @page_title
    ats.each do |a|
      assert_select "tr#setting_#{a.id}"
    end
  end

  def test_it_t2_ats_004
    #test CREATE_ATS function
    login_as ADMIN
    post :create_ats
    assert_response :success
    ats = @controller.instance_variable_get "@ats"
    title = @controller.instance_variable_get "@page_title"
    assert_template "ats/_edit_ats.rhtml"
    assert_equal _("Creating New Analysis Tool Setting"), title
    assert_equal nil, ats.id
    assert_select "input[type = 'button'][value = '#{_('Save')}']"
    assert_select "input[type = 'button'][value = '#{_('Cancel')}']"
  end

  def test_it_t2_ats_005
    #test EDIT_ATS function
    #correct ID
    login_as ADMIN
    ats = AnalyzeConfig.find(:first)
    post :edit_ats, :id => ats.id
    assert_response :success
    p_ats = @controller.instance_variable_get "@ats"
    p_title = @controller.instance_variable_get "@page_title"
    assert_template "ats/_edit_ats.rhtml"
    assert_equal _("Editing Analysis Tool Setting"), p_title    
    assert_select "input[type = 'button'][value = '#{_('Save')}']"
    assert_select "input[type = 'button'][value = '#{_('Cancel')}']"
    assert_equal ats, p_ats
  end

  def test_it_t2_ats_006
    #test EDIT_ATS function
    #invalid id
    login_as ADMIN
    post :edit_ats, :id => INVALID
    #response not found
    assert_response 200
  end

  def test_it_t2_ats_007
    #test SHOW_ATS function
    #correct ID
    login_as ADMIN
    ats = AnalyzeConfig.find(:last)
    post :show_ats, :id => ats.id
    assert_response :success
    p_ats = @controller.instance_variable_get "@ats"
    p_title = @controller.instance_variable_get "@page_title"
    assert_template "ats/_show_ats.rhtml"
    assert_equal _("Analysis Tool Setting Information"), p_title
    assert_select "table#tool_configuration" do
      assert_select "td.ats-attribute-header"
    end
    assert_equal ats, p_ats
  end

  def test_it_t2_ats_008
    #test SHOW_ATS function
    #invalid ID
    login_as ADMIN
    post :show_ats, :id => INVALID
    #response not found
    assert_response 200
  end

  def test_it_t2_ats_009
    #test UPDATE_ATS function
    #update successful
    login_as ADMIN
    ats = AnalyzeConfig.find(:first)
    post :update_ats, :id => ats.id
    assert_response :success
    assert_equal _("Analyze tool setting was updated successful."), flash[:notice]
    p_title = @controller.instance_variable_get "@page_title"
    assert_template "ats/_index.rhtml"
    assert_equal _("Analysis Tool Setting Administration"), p_title
  end

  def test_it_t2_ats_010
    #test UPDATE_ATS function
    #update successful when ats detail blank
    login_as ADMIN
    ats = AnalyzeConfig.find(:last)
    post :update_ats, :id => ats.id
    assert_response :success
    assert_equal _("Analyze tool setting was updated successful."), flash[:notice]
    p_title = @controller.instance_variable_get "@page_title"
    assert_template "ats/_index.rhtml"
    assert_equal _("Analysis Tool Setting Administration"), p_title
  end

  def test_it_t2_ats_011
    #test UPDATE_ATS function
    #update fail
    login_as ADMIN
    ats = AnalyzeConfig.find(:last)
    p_ats = {"name"=>"", "description"=>"ATS setting", "analyze_tool_id"=>"1"}
    post :update_ats, :id => ats.id, :ats => p_ats
    assert_response :success
    assert_equal _("Analyze config name is required."), flash[:notice]
    assert_template ""
  end

  def test_it_t2_ats_012
    #test UPDATE_ATS function: login as PU ADMIN
    #update successful
    login_as PU_ADMIN
    post :update_ats, :id => 1, :pu => 1
    assert_response :success    
    assert_equal _("Analyze tool setting was updated successful."), flash[:notice]
    p_title = @controller.instance_variable_get "@page_title"    
    assert_template "index"
    assert_equal _("Analysis Tool Setting Administration"), p_title    
  end

  def test_it_t2_ats_013
    #test UPDATE_ATS function: login as PJ ADMIN
    #update successful
    login_as PJ_ADMIN
    post :update_ats, :id => 2, :pj => 1
    assert_response :success
    assert_equal _("Analyze tool setting was updated successful."), flash[:notice]
    p_title = @controller.instance_variable_get "@page_title"
    assert_template "index"
    assert_equal _("Analysis Tool Setting Administration"), p_title
  end

  def test_it_t2_ats_014
    #test SAVE_ATS function
    #save successful 
    login_as ADMIN
    p_ats = {"name"=>"New ATS", "description"=>"ATS setting", "analyze_tool_id"=>"1"}
    p_pgr = {"make_options"=>"", "others"=>"",
             "analyze_tool_config"=>"",
             "environment_variables"=>"",
             "header_file_at_analyze"=>""}
    p_qac = {"make_options"=>"new options", "others"=>"",
             "analyze_tool_config"=>"",
             "environment_variables"=>"new env",
             "header_file_at_analyze"=>""}
    p_qacpp = {"make_options"=>"", "others"=>"",
               "analyze_tool_config"=>"",
               "environment_variables"=>"",
               "header_file_at_analyze"=>""}
    post :save_ats,
         :ats => p_ats, "ats_pgr" => p_pgr, "ats_qac" => p_qac, "ats_qacpp" => p_qacpp
    assert_response :success
    assert_equal _("Analyze tool setting was created successful."), flash[:notice]
    p_title = @controller.instance_variable_get "@page_title"
    assert_template "ats/_index.rhtml"
    assert_equal _("Analysis Tool Setting Administration"), p_title
    AnalyzeConfig.delete(:last)
  end

  def test_it_t2_ats_015
    #test SAVE_ATS function
    #save fail
    login_as ADMIN
    p_ats = {"name"=>"", "description"=>"ATS setting", "analyze_tool_id"=>"1"}
    p_pgr = {"make_options"=>"", "others"=>"",
             "analyze_tool_config"=>"",
             "environment_variables"=>"",
             "header_file_at_analyze"=>""}
    p_qac = {"make_options"=>"new options", "others"=>"",
             "analyze_tool_config"=>"",
             "environment_variables"=>"new env",
             "header_file_at_analyze"=>""}
    p_qacpp = {"make_options"=>"", "others"=>"",
               "analyze_tool_config"=>"",
               "environment_variables"=>"",
               "header_file_at_analyze"=>""}
    post :save_ats,
         :ats => p_ats, "ats_pgr" => p_pgr, "ats_qac" => p_qac, "ats_qacpp" => p_qacpp
    assert_response :success
    assert_equal _("Analyze config name is required."), flash[:notice]
    assert_template ""
  end

  def test_it_t2_ats_016
    #test COPY_ATS function
    #correct ats id
    login_as ADMIN
    ats = AnalyzeConfig.find(:last)
    post :copy_ats, :id => ats.id
    assert_response :success
    p_ats = @controller.instance_variable_get "@ats"
    p_title = @controller.instance_variable_get "@page_title"
    assert_equal _("Copying Analysis Tool Setting"), p_title
    assert_template "ats/_edit_ats.rhtml"
    assert_equal p_ats.name, ats.name
    assert_equal p_ats.description, ats.description
  end

  def test_it_t2_ats_017
    #test COPY_ATS function
    #invalid ats id
    login_as ADMIN
    ats = AnalyzeConfig.find(:last)
    post :copy_ats, :id => INVALID
    assert_response :success
  end

  def test_it_t2_ats_018
    login_as ADMIN
    #test DELETE_ATS function
    #delete successful
    ats = AnalyzeConfig.find(:last)
    all = AnalyzeConfig.find(:all)
    post :delete_ats, :id => ats.id
    assert_equal _("Analyze Tool Setting was deleted successful."), flash[:notice]
    p_ats = @controller.instance_variable_get "@ats"
    p_title = @controller.instance_variable_get "@page_title"
    assert_template "index"
    assert_equal _("Analysis Tool Setting Administration"), p_title    
    assert_not_equal p_ats.size, all.size
  end

  def test_it_t2_ats_019
    login_as ADMIN
    #test DELETE_ATS function
    #delete successful
    ats = AnalyzeConfig.find(:last)
    all = AnalyzeConfig.find(:all)
    post :delete_ats, :id => ats.id, :page => 2
    assert_equal _("Analyze Tool Setting was deleted successful."), flash[:notice]
    p_ats = @controller.instance_variable_get "@ats"
    p_title = @controller.instance_variable_get "@page_title"
    assert_template "index"
    assert_equal _("Analysis Tool Setting Administration"), p_title
    assert_not_equal p_ats.size, all.size
  end

  def test_it_t2_ats_020
    login_as PU_ADMIN
    #test DELETE_ATS function: login as PU ADMIN/PJ ADMIN
    #delete successful
    ats = AnalyzeConfig.create(:name => "Sample", :created_by => 2)
    all = AnalyzeConfig.find(:all)    
    post :delete_ats, :id => ats.id, :pu => 1
    assert_equal _("Analyze Tool Setting was deleted successful."), flash[:notice]
    p_ats = @controller.instance_variable_get "@ats"
    p_title = @controller.instance_variable_get "@page_title"
    assert_template "index"
    assert_equal _("Analysis Tool Setting Administration"), p_title
    assert_not_equal p_ats.size, all.size
  end

  def test_it_t2_ats_021
    login_as ADMIN
    #test DELETE_ATS function
    #delete fail)
    all = AnalyzeConfig.find(:all)
    post :delete_ats, :id => nil
    assert_equal _("Analyze Tool Setting was failed to delete."), flash[:notice]
    #p_ats = @controller.instance_variable_get "@ats"
    p_ats = AnalyzeConfig.find(:all)
    #p_title = @controller.instance_variable_get "@page_title"
    #assert_template "index"
    #assert_equal _("Analysis Tool Setting Administration"), p_title
    assert_equal p_ats.size, all.size
  end

  def test_it_t2_ats_022
    #test SET_ATS_DEFAULT function
    login_as ADMIN
    ats = AnalyzeConfig.find(:last)
    post :set_ats_default,
         :id => ats.id, :item => "make_options",
         :tool_id => ats.analyze_tool_id,
         :html_id => "ats_qac_make_options"
    assert_template ""
  end

  def test_it_t2_ats_023
    #test SET_ATS_DEFAULT function
    #ats id is nil
    login_as ADMIN
    post :set_ats_default,
         :id => nil, :item => "make_options",
         :tool_id => nil,
         :html_id => "ats_qac_make_options"
    assert_template ""
  end

  def test_it_t2_ats_024
    #test REFER_COPY_ATS function
    #ats id, pj id
    login_as ADMIN
    ats = AnalyzeConfig.find_by_id(2)
    post :refer_copy_ats,
         :id => ats.id, :pj => 1
    ref = @controller.instance_variable_get "@refer"
    assert_equal true, ref
    assert_equal _("Setting was successful copied."), flash[:notice]
  end

  def test_it_t2_ats_025
    #test REFER_COPY_ATS function
    #ats id, pu id
    login_as ADMIN
    ats = AnalyzeConfig.find(:last)
    post :refer_copy_ats,
         :id => ats.id, :pu => 1
    ref = @controller.instance_variable_get "@refer"
    assert_equal true, ref
    assert_equal _("Setting was successful copied."), flash[:notice]
  end

  def test_it_t2_ats_026
    #test REFER_COPY_ATS function
    #refer fail
    login_as ADMIN
    post :refer_copy_ats,
         :id => nil
    ref = @controller.instance_variable_get "@refer"
    assert_equal nil, ref
    assert_equal _("Setting was failed to copy."), flash[:notice]
  end

  def notest_it_t2_ats_027
    #test REFER_EDIT_ATS function
    #pu id
    login_as ADMIN
    ats = AnalyzeConfig.find(:last)
    pu = AnalyzeConfigsPus.find(:first)
    post :refer_edit_ats,
         :id => ats.id, :pu => pu.pu_id
    check = AnalyzeConfigsPus.find_all_by_pu_id_and_analyze_config_id(pu.pu_id, ats.id)
    assert_not_equal nil, check
  end

  def notest_it_t2_ats_028
    #test REFER_EDIT_ATS function
    #pj id
    login_as ADMIN
    ats = AnalyzeConfig.find(:last)
    pj = AnalyzeConfigsPjs.find(:first)
    post :refer_edit_ats,
         :id => ats.id, :pj => pj.pj_id
    check = AnalyzeConfigsPjs.find_all_by_pj_id_and_analyze_config_id(pj.pj_id, ats.id)
    assert_not_equal nil, check
  end

  def notest_it_t2_ats_029
    #test REFER_EDIT_ATS function
    #pu id nil
    login_as ADMIN
    ats = AnalyzeConfig.find(:last)
    post :refer_edit_ats,
         :id => ats.id, :pu => nil
    begin
      check = AnalyzeConfigsPus.find_all_by_pu_id_and_analyze_config_id(nil, ats.id)
    rescue
      assert true
    end
  end

  def notest_it_t2_ats_030
    #test REFER_EDIT_ATS function
    #pj nil
    login_as ADMIN
    ats = AnalyzeConfig.find(:last)
    post :refer_edit_ats,
         :id => ats.id, :pj => nil
    begin
      check = AnalyzeConfigsPjs.find_all_by_pj_id_and_analyze_config_id(nil, ats.id)
    rescue
      assert true
    end
  end
end
