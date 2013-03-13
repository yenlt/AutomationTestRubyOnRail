require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../integration/setup'
require 'misc_controller'
require 'pu_controller'
require 'pj_controller'

class MiscControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  ##############################################################################
  # Setup
  ##############################################################################
  fixtures :users
  #  fixtures :privileges
  #  fixtures :privileges_users
  fixtures :pus
  fixtures :pjs
  fixtures :tasks
  fixtures :subtasks  
  CHECKED           = "1"
  UNCHECKED         = "2"
  TCANA_admin = "root"
  PU_admin = "pu_admin"
  PJ_admin = "pj_admin"
  CONTROLLER_MISC = "misc"
  CONTROLLER_PU   = "pu"
  CONTROLLER_PJ   = "pj" 
  NO_subtask        = []
  SELECTED_SUBTASK  = ["1"]
  PU_ID = 1
  SELECTED_PJ = 1
  All_SUBTASK_in_TASK  = ["1", "2"]

  ## SETUP
  #
  #
  def setup
    @controller = MiscController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  #  
  ############################################################################
  # Display Data Administration page.
  # Test function: data_admin
  #############################################################################
  # Input:  + User has not logged in.
  #         + Request to call "data_admin" function to view LDAP administration page.
  # Expected: Redirected back to login page.
  #
  def test_it_t1_ucm_ddf_001
    # User has not logged in
    p "Test 01"
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get  :data_admin
    assert_redirected_to :controller => "auth", :action => 'login'
  end
  # Test function: data_admin
  # controller:misc
  # The user (PU admin) isn't successfully authenticated
  # PU admin hasn't privilege to access into action data_admin
  def test_it_t1_ucm_ddf_002
    p "Test 02"
    login_as PU_admin
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get  :data_admin
    assert_redirected_to :controller => 'misc', :action => 'index'
  end


  # Test function: data_admin
  # controller:misc
  # The user (PJ admin) isn't successfully authenticated
  # PJ admin hasn't privilege to access into action data_admin
  def test_it_t1_ucm_ddf_003
    p "Test 03"
    login_as PJ_admin
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get  :data_admin
    assert_redirected_to :controller => 'misc', :action => 'index'
  end

 # Test function: data_admin
  # controller:pu
  # The user (PJ admin) isn't successfully authenticated
  # PJ admin hasn't privilege to access into action data_admin
  def test_it_t1_ucm_ddf_004
    p "Test 04"
    @controller = PuController.new
    @request    =  ActionController::TestRequest.new
    @response   =  ActionController::TestResponse.new
    login_as PJ_admin
    @request.session["selected_subtask_#{CONTROLLER_PU}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_PU}"] = Array.new
    get  :data_admin,
      :pu => 1
    assert_redirected_to :controller => 'misc', :action => 'index'
  end

  # Test function: data_admin
  # controller:misc
  # The user (TCANA admin) is successfully authenticated
  def test_it_t1_ucm_ddf_005
    p "Test 05"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    #call function
    get  :data_admin
    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "misc/_data_tcana_admin"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
  end

  # Test function: data_admin
  # controller:pu
  # The user (TCANA admin) is successfully authenticated
  def test_it_t1_ucm_ddf_006
    p "Test 06"
    @controller = PuController.new
    @request    =  ActionController::TestRequest.new
    @response   =  ActionController::TestResponse.new
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_PU}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_PU}"] = Array.new
    #call function
    get  :data_admin,
      :pu => 1

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "devgroup/_data_pu_admin"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
  end

  # Test function: data_admin
  # controller:pu
  # The user (PU admin) is successfully authenticated
  def test_it_t1_ucm_ddf_007
    p "Test 07"
    @controller = PuController.new
    @request    =  ActionController::TestRequest.new
    @response   =  ActionController::TestResponse.new
    login_as PU_admin
    @request.session["selected_subtask_#{CONTROLLER_PU}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_PU}"] = Array.new
    get  :data_admin,
      :pu => 1
    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "devgroup/_data_pu_admin"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
  end

  # Test function: data_admin
  # controller:pj
  # The user (TCANA admin) is successfully authenticated
  def test_it_t1_ucm_ddf_008
    p "Test 08"
    @controller = PjController.new
    @request    =  ActionController::TestRequest.new
    @response   =  ActionController::TestResponse.new
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_PJ}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_PJ}"] = Array.new
    #call function
    get  :data_admin,
      :pu => 1,
      :pj => 1

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "devgroup/_data_pj_admin"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
  end

  # Test function: data_admin
  # controller:pj
  # The user (PU admin) is successfully authenticated
  def test_it_t1_ucm_ddf_009
    p "Test 09"
    @controller = PjController.new
    @request    =  ActionController::TestRequest.new
    @response   =  ActionController::TestResponse.new
    login_as PU_admin
    @request.session["selected_subtask_#{CONTROLLER_PJ}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_PJ}"] = Array.new
    get  :data_admin,
      :pu => 1,
      :pj => 1
    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "devgroup/_data_pj_admin"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
  end

  # Test function: data_admin
  # controller:pj
  # The user (PJ admin) is successfully authenticated
  def test_it_t1_ucm_ddf_010
    p "Test 10"
    @controller = PjController.new
    @request    =  ActionController::TestRequest.new
    @response   =  ActionController::TestResponse.new
    login_as PJ_admin
    @request.session["selected_subtask_#{CONTROLLER_PJ}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_PJ}"] = Array.new
    get  :data_admin,
      :pu => 1,
      :pj => 1
    assert_template "devgroup/_data_pj_admin"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
  end
  ############################################################################
  # Test function: check_all_subtasks
  #############################################################################

  # Test function: check_all_subtasks
  # Case TCANA admin want to choose all subtasks in TCANA system.
  def test_it_t1_ucm_ddf_011
    p "Test 11"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :check_all_subtasks,
      :pu => 0,
      :page => 1,
      :order_field => "",
      :order_direction => "ASC"
     # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    subtasks = Subtask.find(:all,
      :conditions => "task_state_id != 2")

    #@subtask will contain all of subtasks, that are contained TCANA system
    assert_equal subtasks.size,(@controller.instance_variable_get "@subtasks").length
  end

  # Case TCANA/PU admin want to choose all subtasks belong to selected pu.
  def test_it_t1_ucm_ddf_012
    p "Test 12"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :check_all_subtasks,
      :pu => 1,
      :pj => 0,
      :page => 1,
      :order_field => "",
      :order_direction => "ASC"

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
      # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"

    #@subtask will contain all of subtasks, that belong to selected pu
    # Count number of subtask belong to selected pu
    #pjs belong to pu
    subtask_list = []
    pj_list = Pj.find_all_by_pu_id(PU_ID)
    unless pj_list.blank?
      pj_list.each do |pj|
        task_list = Task.find_all_by_pj_id(pj.id)
        task_list.each do |task|
          subtask_list << Subtask.find(:all,
            :conditions => "task_state_id != 2 AND task_id = #{task.id}")
        end
      end
    end
    subtasks = subtask_list.flatten!
    assert_equal subtasks.size,(@controller.instance_variable_get "@subtasks").length
    # Expected the session variable will store all of subtask's id,
    # that corresponding to subtask,which belong to selected pu
    expected_session = subtasks.map {|s|s.id.to_s}
    assert_equal expected_session,@request.session["selected_subtask_#{CONTROLLER_MISC}"]
  end

  # Case TCANA/PU/PJ admin want to choose all subtasks belong to selected pj.
  # All of subtask's id  belong to selected pj will be stored in session variable
  def test_it_t1_ucm_ddf_013
    p "Test 13"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :check_all_subtasks,
      :pu => 1,
      :pj => 1,
      :page => 1,
      :order_field => "",
      :order_direction => "ASC"

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"

    #@subtask will contain all of subtasks, that belong to selected pu
    # Count number of subtask belong to selected pu
    #pjs belong to pu
    subtask_list = []
    pj = Pj.find_by_id(SELECTED_PJ)
    pj_ = Pj.find_all_by_pu_id(PU_ID)
    unless pj.blank?
      task_list = Task.find_all_by_pj_id(pj.id)
      task_list.each do |task|
        subtask_list << Subtask.find(:all,
          :conditions => "task_state_id != 2 AND task_id = #{task.id}")
      end
    end
    subtasks = subtask_list.flatten!
    assert_equal subtasks.size,(@controller.instance_variable_get "@subtasks").length
    expected_session = subtasks.map {|s|s.id.to_s}
    assert_equal expected_session,@request.session["selected_subtask_#{CONTROLLER_MISC}"]
  end
  ###########################################################################
  # Test function: check_all_results
  #############################################################################

  # Test function: check_all_results
  # Case TCANA admin want to choose all results in TCANA system.
  def test_it_t1_ucm_ddf_014
    p "Test 14"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :check_all_results,
      :pu => 0,
      :page => 1,
      :order_field => "",
      :order_direction => "ASC"

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"

  end

  # Case TCANA/PU admin want to choose all results belong to selected pu.
  def test_it_t1_ucm_ddf_015
    p "Test 15"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :check_all_results,
      :pu => 1,
      :pj => 0,
      :page => 1,
      :order_field => "",
      :order_direction => "ASC"

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"

    #@subtask will contain all of subtasks, that belong to selected pu
    # Count number of subtask belong to selected pu
    #pjs belong to pu
    subtask_list = []
    pj_list = Pj.find_all_by_pu_id(PU_ID)
    unless pj_list.blank?
      pj_list.each do |pj|
        task_list = Task.find_all_by_pj_id(pj.id)
        task_list.each do |task|
          subtask_list << Subtask.find(:all,
            :conditions => "task_state_id = 5 AND task_id = #{task.id}")
        end
      end
    end
    subtasks = subtask_list.flatten!
    assert_equal subtasks.size,(@controller.instance_variable_get "@subtasks").length
    expected_session = subtasks.map {|s|s.id.to_s}
    assert_equal expected_session,@request.session["selected_result_#{CONTROLLER_MISC}"]
  end

  # Case TCANA/PU/PJ admin want to choose all results belong to selected pj.
  # All of subtask's id  belong to selected pj will be stored in session variable
  def test_it_t1_ucm_ddf_016
    p "Test 16"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :check_all_results,
      :pu => 1,
      :pj => 1,
      :page => 1,
      :order_field => "",
      :order_direction => "ASC"

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"

    #@subtask will contain all of subtasks, that belong to selected pu
    # Count number of subtask belong to selected pu
    #pjs belong to pu
    subtask_list = []
    pj = Pj.find_by_id(SELECTED_PJ)
    pj_ = Pj.find_all_by_pu_id(PU_ID)
    unless pj.blank?
      task_list = Task.find_all_by_pj_id(pj.id)
      task_list.each do |task|
        subtask_list << Subtask.find(:all,
          :conditions => "task_state_id = 5 AND task_id = #{task.id}")
      end
    end
    subtasks = subtask_list.flatten!
    assert_equal subtasks.size,(@controller.instance_variable_get "@subtasks").length
    expected_session = subtasks.map {|s|s.id.to_s}
    assert_equal expected_session,@request.session["selected_result_#{CONTROLLER_MISC}"]
  end

  ############################################################################
  # Test function: uncheck_all_subtasks
  ############################################################################

  # Test function: uncheck_all_subtasks
  #
  # Case TCANA admin want to choose all subtasks in TCANA system for uncheck.
  def test_it_t1_ucm_ddf_017
    p "Test 17"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :uncheck_all_subtasks,
      :pu => 0,
      :page => 1,
      :order_field => "",
      :order_direction => "ASC"

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    expected_session = Array.new
    assert_equal expected_session,@request.session["selected_subtask_#{CONTROLLER_MISC}"]
  end

  # Case TCANA/PU admin want to choose all subtasks belong to selected pu for uncheck
  def test_it_t1_ucm_ddf_018
    p "Test 18"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :uncheck_all_subtasks,
      :pu => 1,
      :pj => 0,
      :page => 1,
      :order_field => "",
      :order_direction => "ASC"

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"

    expected_session = Array.new
    assert_equal expected_session,@request.session["selected_subtask_#{CONTROLLER_MISC}"]
  end

  # Case TCANA/PU/PJ admin want to choose all subtasks belong to selected pj for uncheck
  #
  def test_it_t1_ucm_ddf_019
    p "Test 19"

    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :uncheck_all_subtasks,
      :pu => 1,
      :pj => 1,
      :page => 1,
      :order_field => "",
      :order_direction => "ASC"

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    expected_session = Array.new
    assert_equal expected_session,@request.session["selected_subtask_#{CONTROLLER_MISC}"]
  end
  ############################################################################
  # Test function: uncheck_all_results
  ############################################################################

  # Test function: uncheck_all_results
  # Case TCANA admin want to choose all results in TCANA system for uncheck.
  def test_it_t1_ucm_ddf_020
    p "Test 20"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :uncheck_all_results,
      :pu => 0,
      :page => 1,
      :order_field => "",
      :order_direction => "ASC"

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    expected_session = Array.new
    # Check the session variabl is blank
    assert_equal expected_session,@request.session["selected_result_#{CONTROLLER_MISC}"]
  end

  # Case TCANA/PU admin want to choose all results belong to selected pu for uncheck
  def test_it_t1_ucm_ddf_021
    p "Test 21"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :uncheck_all_results,
      :pu => 1,
      :pj => 0,
      :page => 1,
      :order_field => "",
      :order_direction => "ASC"

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    expected_session = Array.new
    assert_equal expected_session,@request.session["selected_result_#{CONTROLLER_MISC}"]
  end

  # Case TCANA/PU/PJ admin want to choose all subtasks belong to selected pj for uncheck
  def test_it_t1_ucm_ddf_022
    p "Test 22"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :uncheck_all_results,
      :pu => 1,
      :pj => 1,
      :page => 1,
      :order_field => "",
      :order_direction => "ASC"

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    expected_session = Array.new
    assert_equal expected_session,@request.session["selected_result_#{CONTROLLER_MISC}"]
  end
  ############################################################################
  # Test function: update_subtask_list
  ############################################################################

  # Test function: update_subtask_list
  # This function will be called when:
  #  actor want to select pu at dropdow list of pu,
  #  actor want to select pj at dropdow list of pj,
  # want to choose sort, want to choose page transfer.
  # Test case :when actor (TCANA admin) want to sort or choose page for all of subtask in TCANA system
  def test_it_t1_ucm_ddf_023
    p "Test 23"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :update_subtask_list,
      :pu => 0,
      :page =>  1,
      :order_field => "",
      :order_direction => "ASC"
    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"

  end

  # Test case :when actor (TCANA/PU admin) want to sort/select page/select pj
  # for all of subtask belong to selected pu
  def test_it_t1_ucm_ddf_024
    p "Test 24"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :update_subtask_list,
      :pu => 1,
      :pj => 0,
      :page => 1,
      :order_field => "",
      :order_direction => "ASC"
    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"

  end

  # Test case :when actor (TCANA/PU/PJ admin) want to sort/slect page/select pj
  # for all of subtask belong to selected pj
  def test_it_t1_ucm_ddf_025
    p "Test 25"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :update_subtask_list,
      :pu => 1,
      :pj => 1,
      :page => 1,
      :order_field => "",
      :order_direction => "ASC"
    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"

   end
  ############################################################################
  # Test function: store_selected_subtasks
  ############################################################################

  #Test function: store_selected_subtasks
  # Test case: Actor check on check box corresponding to subtasks'id = 1
  def test_it_t1_ucm_ddf_026
    p "Test 26"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :store_selected_subtasks,
      :subtask_id => 1,
      :selected_subtask => "true"
    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template ""
    expected_session = ["1"]
    assert_equal expected_session,@request.session["selected_subtask_#{CONTROLLER_MISC}"]

  end

  #Test function: store_selected_subtasks
  # Test case: Actor check on check box corresponding to subtasks'id = 1 and then check for uncheck it
  def test_it_t1_ucm_ddf_027
    p "Test 27"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :store_selected_subtasks,
      :subtask_id => 1,
      :selected_subtask => "true"
    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template ""
    expected_session = ["1"]
    assert_equal expected_session,@request.session["selected_subtask_#{CONTROLLER_MISC}"]
    get :store_selected_subtasks,
        :subtask_id => 1,
        :selected_subtask => "false"
    expected_session = []
    assert_equal expected_session,@request.session["selected_subtask_#{CONTROLLER_MISC}"]

  end
  ############################################################################
  # Test function: store_selected_result
  ############################################################################

  #Test function: store_selected_results
  # Test case: Actor check on check box according to subtasks'id = 1
  def test_it_t1_ucm_ddf_028
    p "Test 28"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :store_selected_results,
      :subtask_id => 1,
      :selected_result => "true"

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template ""
    expected_session = ["1"]
    assert_equal expected_session,@request.session["selected_result_#{CONTROLLER_MISC}"]

  end
  #Test function: store_selected_results
  # Test case: Actor check on check box according to subtasks'id = 1 and then check for uncheck it
  def test_it_t1_ucm_ddf_029
    p "Test 29"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :store_selected_results,
      :subtask_id => 1,
      :selected_result => "true"

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template ""
    expected_session = ["1"]
    assert_equal expected_session,@request.session["selected_result_#{CONTROLLER_MISC}"]
    get :store_selected_results,
      :subtask_id => 1,
      :selected_result => "false"
    expected_session = []
    assert_equal expected_session,@request.session["selected_result_#{CONTROLLER_MISC}"]

  end
  ############################################################################
  # Test function: delete_subtask
  ############################################################################

  # Test function: delete_subtask
  # Case user (tcana admin) want to choose one or more subtasks in all subtasks,
  # that contained in tcana system to delete
  # This case, user choose nothing to delete.
  #
  def test_it_t1_ucm_ddf_030
    p "Test 30"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :delete_subtasks,
                   :pu => 0,
                   :pj => 0

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "misc/_data_tcana_admin"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("No subtask  was  selected!"), flash[:notice]

  end

  # Test function: delete_subtask
  # Case user (tcana admin) want to choose one or more subtasks in all subtasks,
  #that contained in tcana system to delete
  # This case, user choose some subtasks to delete.
  def test_it_t1_ucm_ddf_031
    p "Test 31"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    SELECTED_SUBTASK.each do |subtask_id|
      @request.session["selected_subtask_#{CONTROLLER_MISC}"] << subtask_id
    end
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :delete_subtasks,
                    :pu => 0,
                    :pj => 0

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "misc/_data_tcana_admin"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("Subtask(s) were deleted successfully!"), flash[:notice]

  end
  # Test function: delete_subtask
  # Case user (tcana admin) want to choose one or more subtasks in all subtasks,
  # that contained in tcana system to delete
  # This case, user choose all subtasks in one task to delete.
  def test_it_t1_ucm_ddf_032
    p "Test 32"
    login_as TCANA_admin
    ## initiallize session
    subtask = []
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    All_SUBTASK_in_TASK.each do |subtask_id|
      subtask = Subtask.find_by_id(subtask_id)
      @request.session["selected_subtask_#{CONTROLLER_MISC}"] << subtask_id
    end
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    assert_not_nil Subtask.find_all_by_id(All_SUBTASK_in_TASK)
    task_id = subtask.task.id
    get :delete_subtasks,
        :pu => 0,
        :pj => 0
    # Test conditions
    # The web is request successful.
    assert_response :success
    # Confirm the deletion of subtask records
    assert_equal [], Subtask.find_all_by_id( All_SUBTASK_in_TASK)
    # Confirm the deletion of task records
    assert_equal nil, Task.find_by_id(task_id)
    # The user is redirected to the right page.
    assert_template "misc/_data_tcana_admin"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("Subtask(s) were deleted successfully!"), flash[:notice]
  end
#  # Test function: delete_subtask
#  # Case user (TCANA/PU admin) want to choose one or more subtasks in all subtasks,
#  # that are contained in selected pu to delete
#  # This case, user choose nothing to delete.
#
  def test_it_t1_ucm_ddf_033
    p "Test 33"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :delete_subtasks,
      :pu => 1,
      :pj => 0

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("No subtask  was  selected!"), flash[:notice]

  end

  # Test function: delete_subtask
  # Case user (TCANA/PU admin) want to choose one or more subtasks in all subtasks,
  #  that are contained in selected pu to delete
  # This case, user choose some subtasks to delete.
  def test_it_t1_ucm_ddf_034
    p "Test 34"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    SELECTED_SUBTASK.each do |subtask_id|
      @request.session["selected_subtask_#{CONTROLLER_MISC}"] << subtask_id
    end
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :delete_subtasks,
                    :pu => 1,
                    :pj => 0
    # Test conditions
    # The web is request successful.
    assert_response :success
    # Confirm the deletion of subtask records
    assert_equal nil, Subtask.find_by_id( SELECTED_SUBTASK)

    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("Subtask(s) were deleted successfully!"), flash[:notice]

  end


  # Test function: delete_subtask
  # Case user (TCANA/PU admin) want to choose one or more subtasks in all subtasks,
  # that are contained in selected pu to delete
  # This case, user choose all subtasks in one task to delete.
  def test_it_t1_ucm_ddf_035
    p "Test 35"
    login_as TCANA_admin
    subtask = []
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    All_SUBTASK_in_TASK.each do |subtask_id|
      subtask = Subtask.find_by_id(subtask_id)
      @request.session["selected_subtask_#{CONTROLLER_MISC}"] << subtask_id
    end
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    task_id = subtask.task.id
    get :delete_subtasks,
      :pu => 1,
      :pj => 0
    # Test conditions
    # The web is request successful.
    assert_response :success
    # Confirm the deletion of subtask records
    assert_equal [], Subtask.find_all_by_id(All_SUBTASK_in_TASK)
    # Confirm the deletion of task records
    assert_equal nil, Task.find_by_id(task_id)

    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("Subtask(s) were deleted successfully!"), flash[:notice]
  end

  # Test function: delete_subtask
  # Case user (TCANA/PU/PJ admin) want to choose one or more subtasks in all subtasks,
  # that are contained in selected pj to delete
  # This case, user choose nothing to delete.

  def test_it_t1_ucm_ddf_036
    p "Test 36"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :delete_subtasks,
      :pu => 1,
      :pj => 1
    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    # The appropriate message is displayed to the user in the view
    assert_equal _("No subtask  was  selected!"), flash[:notice]
  end

  # Test function: delete_subtask
  # Case user (TCANA/PU/PJ admin) want to choose one or more subtasks in all subtasks,
  # that are contained in selected pj to delete
  # This case, user choose some subtasks to delete.
  def test_it_t1_ucm_ddf_037
    p "Test 37"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    SELECTED_SUBTASK.each do |subtask_id|
      @request.session["selected_subtask_#{CONTROLLER_MISC}"] << subtask_id
    end
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :delete_subtasks,
      :pu => 1,
      :pj => 1
    # Test conditions
    # The web is request successful.
    assert_response :success
    # Confirm the deletion of subtask records
    assert_equal nil, Subtask.find_by_id( SELECTED_SUBTASK)
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    # The appropriate message is displayed to the user in the view
    assert_equal _("Subtask(s) were deleted successfully!"), flash[:notice]
  end
  #

  # Test function: delete_subtask
  # Case user (TCANA/PU/PJ admin) want to choose one or more subtasks in all subtasks,
  # that are contained in selected pj to delete
  # This case, user choose all subtasks in one task to delete.
  def test_it_t1_ucm_ddf_038
    p "Test 38"
    login_as TCANA_admin
    subtask = []
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    All_SUBTASK_in_TASK.each do |subtask_id|
      subtask = Subtask.find_by_id(subtask_id)
      @request.session["selected_subtask_#{CONTROLLER_MISC}"] << subtask_id
    end
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    task_id = subtask.task.id
    get :delete_subtasks,
      :pu => 1,
      :pj => 1

    # Test conditions
    # The web is request successful.
    assert_response :success
    # Confirm the deletion of subtask records
    assert_equal [], Subtask.find_all_by_id(All_SUBTASK_in_TASK)
    # Confirm the deletion of task records
    assert_equal nil, Task.find_by_id(task_id)

    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("Subtask(s) were deleted successfully!"), flash[:notice]

  end


  # Test function: delete_subtask
  # Controller: pu
  # Case user (TCANA/PU admin) want to choose one or more subtasks in all subtasks,
  # that are contained in selected pu to delete
  # This case, user choose all subtasks in one task to delete.
  def test_it_t1_ucm_ddf_039
    p "Test 39"
    # initialize
    @controller = PuController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    #post_fix = String.new
    post_fix = "_1" # The same :pu
    login_as TCANA_admin
    subtask = []
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    All_SUBTASK_in_TASK.each do |subtask_id|
      subtask = Subtask.find_by_id(subtask_id)
      @request.session["selected_subtask_#{CONTROLLER_PU}#{post_fix}"] << subtask_id
    end
    @request.session["selected_result_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    task_id = subtask.task.id
    get :delete_subtasks,
      :pu => 1,
      :pj => 0
    # Test conditions
    # The web is request successful.
    assert_response :success
    # Confirm the deletion of subtask records
    assert_equal [], Subtask.find_all_by_id(All_SUBTASK_in_TASK)
    # Confirm the deletion of task records
    assert_equal nil, Task.find_by_id(task_id)

    # The user is redirected to the right page.
    assert_template "devgroup/_data_pu_admin"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("Subtask(s) were deleted successfully!"), flash[:notice]

  end

  # Test function: delete_subtask
  # # Controller: pu
  # Case user (TCANA/PU admin) want to choose one or more subtasks in all subtasks,
  # that are contained in selected pu to delete
  # This case, user choose all subtasks in one task to delete.
  def test_it_t1_ucm_ddf_040
    p "Test 40"
    ## initialize
    @controller = PuController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    post_fix = "_1" # The same selected pj
    login_as TCANA_admin
    subtask = []
     ## initiallize session

    @request.session["selected_subtask_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    All_SUBTASK_in_TASK.each do |subtask_id|
      subtask = Subtask.find_by_id(subtask_id)
      @request.session["selected_subtask_#{CONTROLLER_PU}#{post_fix}"] << subtask_id
    end
    @request.session["selected_result_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    task_id = subtask.task.id   
    get :delete_subtasks,
      :pu => 1,
      :pj => 0

    # Test conditions
    # The web is request successful.
    assert_response :success
    # Confirm the deletion of subtask records
    assert_equal [], Subtask.find_all_by_id(All_SUBTASK_in_TASK)
    # Confirm the deletion of task records
    assert_equal nil, Task.find_by_id(task_id)

    # The user is redirected to the right page.
    assert_template "devgroup/_data_pu_admin"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("Subtask(s) were deleted successfully!"), flash[:notice]

  end

  # Test function: delete_subtask
  # Controller: pu
  # Case user (TCANA/PU admin) want to choose one or more subtasks in all subtasks,
  # that are contained in selected pj to delete
  # This case, user choose all subtasks in one task to delete.
  def test_it_t1_ucm_ddf_041
    p "Test 41"
    # initialize
    @controller = PuController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
     post_fix = "_1"
    login_as TCANA_admin
    subtask = []
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    All_SUBTASK_in_TASK.each do |subtask_id|
      subtask = Subtask.find_by_id(subtask_id)
      @request.session["selected_subtask_#{CONTROLLER_PU}#{post_fix}"] << subtask_id
    end
    @request.session["selected_result_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    task_id = subtask.task.id
    get :delete_subtasks,
      :pu => 1,
      :pj => 1
    # Test conditions
    # The web is request successful.
    assert_response :success
    # Confirm the deletion of subtask records
    assert_equal [], Subtask.find_all_by_id(All_SUBTASK_in_TASK)
    # Confirm the deletion of task records
    assert_equal nil, Task.find_by_id(task_id)
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("Subtask(s) were deleted successfully!"), flash[:notice]
  end

  # Test function: delete_subtask
  # Controller: pj
  # Case user (TCANA/PU/PJ admin) want to choose one or more subtasks in all subtasks,
  # that are contained in selected pj to delete
  # This case, user choose all subtasks in one task to delete.
  def test_it_t1_ucm_ddf_042
    p "Test 42"
    ## initialize
    @controller = PjController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
     post_fix = "_1" # The same selected pj
    login_as TCANA_admin
    subtask = []
     ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_PJ}#{post_fix}"] = Array.new
    All_SUBTASK_in_TASK.each do |subtask_id|
      subtask = Subtask.find_by_id(subtask_id)
      @request.session["selected_subtask_#{CONTROLLER_PJ}#{post_fix}"] << subtask_id
    end
    @request.session["selected_result_#{CONTROLLER_PJ}#{post_fix}"] = Array.new
    task_id = subtask.task.id
    get :delete_subtasks,
      :pu => 1,
      :pj => 1
    # Test conditions
    # The web is request successful.
    assert_response :success
    # Confirm the deletion of subtask records
    assert_equal [], Subtask.find_all_by_id(All_SUBTASK_in_TASK)
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    assert_equal nil, Task.find_by_id(task_id)
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("Subtask(s) were deleted successfully!"), flash[:notice]
  end
   #############################################################################
  # Test access right function: delete_subtasks
  # ###########################################################################
  # Test function: delete_subtask
  # Test access right
  # controller:misc
  # The user (PU admin) isn't successfully authenticated
  # PU admin hasn't privilege to access into action data_admin
  def test_it_t1_ucm_ddf_043
    p "Test 043"
    login_as PU_admin
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :delete_subtasks,
      :pu => 1,
      :pj => 1
    # The user is redirected to the right page.
    assert_redirected_to :controller => 'misc', :action => 'index'
    # The correct objects are stored in the response template.
  end

  # Test function: delete_subtask
  # Test access right
  # controller:misc
  # The user (PJ admin) isn't successfully authenticated
  # PJ admin hasn't privilege to access into action data_admin
  def test_it_t1_ucm_ddf_044
    p "Test 044"
    login_as PJ_admin
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :delete_subtasks,
      :pu => 1,
      :pj => 1
    assert_redirected_to :controller => 'misc', :action => 'index'
  end

  # Test function: delete_subtask
  # Test access right
  # controller:pu
  # The user (TCANA admin) is successfully authenticated
  def test_it_t1_ucm_ddf_045
    p "Test 045"
    @controller = PuController.new
    @request    =  ActionController::TestRequest.new
    @response   =  ActionController::TestResponse.new
    post_fix = "_1"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    #call function
    get :delete_subtasks,
      :pu => 1,
      :pj => 1

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
  end

  # Test function: delete_subtask
  # Test access right
  # controller:pu
  # The user (PU admin) is successfully authenticated
  def test_it_t1_ucm_ddf_046
    p "Test 046"
    @controller = PuController.new
    @request    =  ActionController::TestRequest.new
    @response   =  ActionController::TestResponse.new
    post_fix = "_1"
    login_as PU_admin
    @request.session["selected_subtask_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    get :delete_subtasks,
      :pu => 1,
      :pj => 1
    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
  end


  # Test function: delete_subtask
  # Test access right
  # controller:pu
  # The user (PJ admin) isn't successfully authenticated
  # PJ admin hasn't privilege to access into action data_admin
  def test_it_t1_ucm_ddf_047
    p "Test 047"
    @controller = PuController.new
    @request    =  ActionController::TestRequest.new
    @response   =  ActionController::TestResponse.new
    post_fix = "_1"
    login_as PJ_admin
    @request.session["selected_subtask_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    get :delete_subtasks,
      :pu => 1,
      :pj => 1
    assert_redirected_to :controller => 'misc', :action => 'index'
  end

  # Test function: delete_subtask
  # Test access right
  # controller:pj
  # The user (TCANA admin) is successfully authenticated
  def test_it_t1_ucm_ddf_048
    p "Test 048"
    @controller = PjController.new
    @request    =  ActionController::TestRequest.new
    @response   =  ActionController::TestResponse.new
     post_fix = "_1"
    login_as TCANA_admin
    ## initiallize session
     @request.session["selected_subtask_#{CONTROLLER_PJ}#{post_fix}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_PJ}#{post_fix}"] = Array.new
    #call function
    get :delete_subtasks,
      :pu => 1,
      :pj => 1

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
  end

  # Test function: delete_subtask
  # Test access right
  # controller:pj
  # The user (PU admin) is successfully authenticated
  def test_it_t1_ucm_ddf_049
    p "Test 49"
    @controller = PjController.new
    @request    =  ActionController::TestRequest.new
    @response   =  ActionController::TestResponse.new
     post_fix = "_1"
    login_as PU_admin
     @request.session["selected_subtask_#{CONTROLLER_PJ}#{post_fix}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_PJ}#{post_fix}"] = Array.new
    #call function
    get :delete_subtasks,
      :pu => 1,
      :pj => 1
    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
  end

  # Test function: delete_subtask
  # Test access right
  # Controller:pj
  # The user (PJ admin) is successfully authenticated
  def test_it_t1_ucm_ddf_050
    p "Test 050"
    @controller = PjController.new
    @request    =  ActionController::TestRequest.new
    @response   =  ActionController::TestResponse.new
     post_fix = "_1"
    login_as PJ_admin
    @request.session["selected_subtask_#{CONTROLLER_PJ}#{post_fix}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_PJ}#{post_fix}"] = Array.new
    get :delete_subtasks,
      :pu => 1,
      :pj => 1
    # Test conditions
    # The web is request successful.
    assert_response :success
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
    assert_select "input[type = 'button'][value = '#{_('Delete')}']"
  end
##
#  #############################################################################
#  #   # Test function: delete_result
#  #############################################################################

  # Test function: delete_result
  # Case user (tcana admin) want to choose one or more results in all results,
  # that contained in tcana system to delete
  # This case, user choose nothing to delete.
  def test_it_t1_ucm_ddf_051
    p "Test 51"

    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :delete_results,
        :pu => 0,
        :pj => 0
    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_subtask_list"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("No result  was  selected!"), flash[:notice]
  end

  # Test function: delete_results
  # Case user (tcana admin) want to choose one or more results in all results,
  #that contained in tcana system to delete
  # This case, user choose some results to delete.
  def test_it_t1_ucm_ddf_052
    p "Test 52"

    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    SELECTED_SUBTASK.each do |subtask_id|
      @request.session["selected_result_#{CONTROLLER_MISC}"] << subtask_id
    end
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    get :delete_results,
        :pu => 0,
        :pj => 0
    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_subtask_list"
    assert_not_nil Subtask.find_by_id(SELECTED_SUBTASK)
    # task_state_id of selected subtask will be update apter subtask's result were deleted
    assert_equal 6, Subtask.find_by_id(SELECTED_SUBTASK).task_state_id
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("Result(s) were deleted successfully!"), flash[:notice]
  end
  # Test function: delete_result
  # Case user (tcana admin) want to choose one or more results in all result,
  # that contained in tcana system to delete
  # This case, user choose all result of subtasks, that belong to one task to delete.
  def test_it_t1_ucm_ddf_053
    p "Test 53"

    login_as TCANA_admin
    ## initiallize session
    subtask = []
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    All_SUBTASK_in_TASK.each do |subtask_id|
      subtask = Subtask.find_by_id(subtask_id)
      @request.session["selected_result_#{CONTROLLER_MISC}"] << subtask_id
    end
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    task_id = subtask.task.id
    get :delete_results,
      :pu => 0,
      :pj => 0
    # Test conditions
    # The web is request successful.
    assert_response :success
    # Confirm the subtask records aren't deleted
    assert_not_nil Subtask.find_all_by_id( All_SUBTASK_in_TASK)
    #  Confirm all subtasks of task, that have all results of subtask was deleted
    # then update task_state_id = 6 (state: result deleted)
    assert_equal 6, Task.find_by_id(task_id).task_state_id
    # The user is redirected to the right page.
    assert_template "shared/_subtask_list"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("Result(s) were deleted successfully!"), flash[:notice]
  end
  # Test function: delete_results
  # Case user (TCANA/PU admin) want to choose one or more results in all results,
  # that are contained in selected pu to delete
  # This case, user choose nothing to delete.
  def test_it_t1_ucm_ddf_054
    p "Test 54"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :delete_results,
      :pu => 1,
      :pj => 0
    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_subtask_list"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("No result  was  selected!"), flash[:notice]
  end

  # Test function: delete_results
  # Case user (TCANA/PU admin) want to choose one or more results in all results
  #  that are contained in selected pu to delete
  # This case, user choose some results to delete.
  def test_it_t1_ucm_ddf_055
    p "Test 55"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    SELECTED_SUBTASK.each do |subtask_id|
      @request.session["selected_result_#{CONTROLLER_MISC}"] << subtask_id
    end
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    get :delete_results,
      :pu => 1,
      :pj => 0
    # Test conditions
    # The web is request successful.
    assert_response :success
    # Confirm the deletion of subtask records
    assert_not_nil Subtask.find_by_id( SELECTED_SUBTASK)
    assert_equal 6,Subtask.find_by_id( SELECTED_SUBTASK).task_state_id
    # The user is redirected to the right page.
    assert_template "shared/_subtask_list"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("Result(s) were deleted successfully!"), flash[:notice]
  end


  # Test function: delete_results
  # Case user (TCANA/PU admin) want to choose one or more results in all results,
  # that are contained in selected pu to delete
  # This case, user choose all results in one task to delete.
  def test_it_t1_ucm_ddf_056
    p "Test 56"
    login_as TCANA_admin
    subtask = []
    ## initiallize session
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    All_SUBTASK_in_TASK.each do |subtask_id|
      subtask = Subtask.find_by_id(subtask_id)
      @request.session["selected_result_#{CONTROLLER_MISC}"] << subtask_id
    end
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    task_id = subtask.task.id
    get :delete_results,
        :pu => 1,
        :pj => 0

    # Test conditions
    # The web is request successful.
    assert_response :success
    # Confirm the deletion of subtask records
    assert_not_nil Subtask.find_all_by_id(All_SUBTASK_in_TASK)
    # Confirm the deletion of task records
    assert_equal 6, Task.find_by_id(task_id).task_state_id

    # The user is redirected to the right page.
    assert_template "shared/_subtask_list"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("Result(s) were deleted successfully!"), flash[:notice]
  end
  # Test function: delete_results
  # Case user (TCANA/PU admin) want to choose one or more results in all results,
  # that are contained in selected pj to delete
  # This case, user choose nothing to delete.

  def test_it_t1_ucm_ddf_057
    p "Test 57"

    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :delete_results,
      :pu => 1,
      :pj => 1
    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_subtask_list"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    # The appropriate message is displayed to the user in the view
    assert_equal _("No result  was  selected!"), flash[:notice]

  end

  # Test function: delete_results
  # Case user (TCANA/PU admin) want to choose one or more results in all results,
  # that are contained in selected pj to delete
  # This case, user choose some results to delete.
  def test_it_t1_ucm_ddf_058
    p "Test 58"
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    SELECTED_SUBTASK.each do |subtask_id|
      @request.session["selected_result_#{CONTROLLER_MISC}"] << subtask_id
    end
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    get :delete_results,
      :pu => 1,
      :pj => 1
    # Test conditions
    # The web is request successful.
    assert_response :success
    # Confirm the deletion of subtask records
    assert_not_nil Subtask.find_by_id( SELECTED_SUBTASK)
    assert_equal 6,Subtask.find_by_id( SELECTED_SUBTASK).task_state_id
    # The user is redirected to the right page.
    assert_template "shared/_subtask_list"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    # The appropriate message is displayed to the user in the view
    assert_equal _("Result(s) were deleted successfully!"), flash[:notice]
  end

  # Test function: delete_results
  # Case user (TCANA/PU admin) want to choose one or more results in all results,
  # that are contained in selected pj to delete
  # This case, user choose all results in one task to delete.
  def test_it_t1_ucm_ddf_059
    p "Test 59"
    login_as TCANA_admin
    subtask = []
    ## initiallize session
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    All_SUBTASK_in_TASK.each do |subtask_id|
      subtask = Subtask.find_by_id(subtask_id)
      @request.session["selected_result_#{CONTROLLER_MISC}"] << subtask_id
    end
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    task_id = subtask.task.id
    get :delete_results,
      :pu => 1,
      :pj => 1

    # Test conditions
    # The web is request successful.
    assert_response :success
    # Confirm the deletion of subtask records
    assert_not_nil Subtask.find_all_by_id(All_SUBTASK_in_TASK)
    # Confirm the deletion of task records
    assert_equal 6,Task.find_by_id(task_id).task_state_id

    # The user is redirected to the right page.
    assert_template "shared/_subtask_list"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("Result(s) were deleted successfully!"), flash[:notice]
  end

  # Test function: delete_result
  # # Controller: pu
  # Case user (TCANA/PU admin) want to choose one or more results in all results,
  # that are contained in selected pu to delete
  # This case, user choose all results in one task to delete.
  def test_it_t1_ucm_ddf_060
    p "Test 60"
    ## initialize
    @controller = PuController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
   post_fix = "_1"
    login_as TCANA_admin
    subtask = []
    ## initiallize session
    @request.session["selected_result_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    All_SUBTASK_in_TASK.each do |subtask_id|
      subtask = Subtask.find_by_id(subtask_id)
      @request.session["selected_result_#{CONTROLLER_PU}#{post_fix}"] << subtask_id
    end
    @request.session["selected_subtask_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    task_id = subtask.task.id
    get :delete_results,
      :pu => 1,
      :pj => 0
    # Test conditions
    # The web is request successful.
    assert_response :success
    # Confirm the deletion of subtask records
    assert_not_nil Subtask.find_all_by_id(All_SUBTASK_in_TASK)
    # Confirm the deletion of task records
    assert_equal 6, Task.find_by_id(task_id).task_state_id

    # The user is redirected to the right page.
    assert_template "shared/_subtask_list"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("Result(s) were deleted successfully!"), flash[:notice]
  end

#   Test function: delete_result
#   # Controller: pu
#   Case user (TCANA/PU admin) want to choose one or more results in all results
#   that are contained in selected pu to delete
#   This case, user choose all results in one task to delete.
  def test_it_t1_ucm_ddf_061
    p "Test 61"
    ## initialize
    @controller = PuController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    post_fix = "_1"
    login_as TCANA_admin
    subtask = []
    ## initiallize session
    ## initiallize session
    @request.session["selected_result_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    All_SUBTASK_in_TASK.each do |subtask_id|
      subtask = Subtask.find_by_id(subtask_id)
      @request.session["selected_result_#{CONTROLLER_PU}#{post_fix}"] << subtask_id
    end
    @request.session["selected_subtask_#{CONTROLLER_PU}#{post_fix}"] = Array.new
      task_id = subtask.task.id
    get :delete_results,
      :pu => 1,
      :pj => 0
    # Test conditions
    # The web is request successful.
    assert_response :success
    # Confirm the deletion of subtask records
    assert_not_nil Subtask.find_all_by_id(All_SUBTASK_in_TASK)
    # Confirm the deletion of task records
    assert_equal 6, Task.find_by_id(task_id).task_state_id

    # The user is redirected to the right page.
    assert_template "shared/_subtask_list"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("Result(s) were deleted successfully!"), flash[:notice]
  end

  # Test function: delete_result
  # # Controller: pu
  # Case user (TCANA/PU admin) want to choose one or more results in all results,
  # that are contained in selected pj to delete
  # This case, user choose all results in one task to delete.
  def test_it_t1_ucm_ddf_062
    p "Test 62"
    ## initialize
    @controller = PuController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
     post_fix = "_1"
    login_as TCANA_admin
    subtask = []
    ## initiallize session
   ## initiallize session
    @request.session["selected_result_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    All_SUBTASK_in_TASK.each do |subtask_id|
      subtask = Subtask.find_by_id(subtask_id)
      @request.session["selected_result_#{CONTROLLER_PU}#{post_fix}"] << subtask_id
    end
    @request.session["selected_subtask_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    task_id = subtask.task.id
    get :delete_results,
      :pu => 1,
      :pj => 1

    # Test conditions
    # The web is request successful.
    assert_response :success
    # Confirm the deletion of subtask records
    assert_not_nil Subtask.find_all_by_id(All_SUBTASK_in_TASK)
    # Confirm the deletion of task records
    assert_equal 6, Task.find_by_id(task_id).task_state_id

    # The user is redirected to the right page.
    assert_template "shared/_subtask_list"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("Result(s) were deleted successfully!"), flash[:notice]
  end

  # Test function: delete_results
  # # Controller: pj
  # Case user (TCANA/PU admin) want to choose one or more results in all results,
  # that are contained in selected pj to delete
  # This case, user choose all results in one task to delete.
  def test_it_t1_ucm_ddf_063
    p "Test 63"
    ## initialize
    @controller = PjController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    post_fix = "_1"
    login_as TCANA_admin
    subtask = []
    ## initiallize session
   ## initiallize session
    @request.session["selected_result_#{CONTROLLER_PJ}#{post_fix}"] = Array.new
    All_SUBTASK_in_TASK.each do |subtask_id|
      subtask = Subtask.find_by_id(subtask_id)
      @request.session["selected_result_#{CONTROLLER_PJ}#{post_fix}"] << subtask_id
    end
    @request.session["selected_subtask_#{CONTROLLER_PJ}#{post_fix}"] = Array.new
    task_id = subtask.task.id
    get :delete_results,
      :pu => 1,
      :pj => 1
    # Test conditions
    # The web is request successful.
    assert_response :success
    # Confirm the deletion of subtask records
    assert_not_nil Subtask.find_all_by_id(All_SUBTASK_in_TASK)
    # Confirm the deletion of task records
    assert_equal 6, Task.find_by_id(task_id).task_state_id

    # The user is redirected to the right page.
    assert_template "shared/_subtask_list"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
    assert_equal _("Result(s) were deleted successfully!"), flash[:notice]

  end
  #############################################################################
  # Test access right function: delete_result
  # ###########################################################################

  # Test function: delete_result
  # Test access right
  # controller:misc
  # The user (PU admin) isn't successfully authenticated
  # PU admin hasn't privilege to access into action data_admin
  def test_it_t1_ucm_ddf_064
    p "Test 64"
    login_as PU_admin
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :delete_results,
      :pu => 1,
      :pj => 1
    # The user is redirected to the right page.
    assert_redirected_to :controller => 'misc', :action => 'index'
    # The correct objects are stored in the response template.
  end

  # Test function: delete_result
  # Test access right
  # controller:misc
  # The user (PJ admin) isn't successfully authenticated
  # PJ admin hasn't privilege to access into action data_admin
  def test_it_t1_ucm_ddf_065
    p "Test 65"
    login_as PJ_admin
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :delete_results,
      :pu => 1,
      :pj => 1
    assert_redirected_to :controller => 'misc', :action => 'index'
  end

  # Test function: delete_result
  # Test access right
  # controller:pu
  # The user (TCANA admin) is successfully authenticate
  def test_it_t1_ucm_ddf_066
    p "Test 66"
    @controller = PuController.new
    @request    =  ActionController::TestRequest.new
    @response   =  ActionController::TestResponse.new
    post_fix = "_1"
    login_as TCANA_admin
    # initiallize session
    @request.session["selected_result_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    @request.session["selected_subtask_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    #call function
    get :delete_results,
      :pu => 1,
      :pj => 1

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_subtask_list"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
  end

  # Test function: delete_result
  # Test access right
  # controller:pu
  # The user (PU admin) is successfully authenticated
  def test_it_t1_ucm_ddf_067
    p "Test 67"
    @controller = PuController.new
    @request    =  ActionController::TestRequest.new
    @response   =  ActionController::TestResponse.new
    post_fix = "_1"
    login_as PU_admin
    # initiallize session
    @request.session["selected_result_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    @request.session["selected_subtask_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    get :delete_results,
      :pu => 1,
      :pj => 1
    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_subtask_list"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
  end

  # Test function: delete_result
  # Test access right
  # controller:pu
  # The user (PJ admin) isn't successfully authenticated
  # PJ admin hasn't privilege to access into action data_admin
  def test_it_t1_ucm_ddf_068
    p "Test 68"
    @controller = PuController.new
    @request    =  ActionController::TestRequest.new
    @response   =  ActionController::TestResponse.new
     post_fix = "_1"
    login_as PJ_admin
     @request.session["selected_result_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    @request.session["selected_subtask_#{CONTROLLER_PU}#{post_fix}"] = Array.new
    get :delete_results,
      :pu => 1,
      :pj => 1
    assert_redirected_to :controller => 'misc', :action => 'index'
  end

  # Test function: delete_result
  # Test access right
  # controller:pj
  # The user (TCANA admin) is successfully authenticated
  def test_it_t1_ucm_ddf_069
    p "Test 69"
    @controller = PjController.new
    @request    =  ActionController::TestRequest.new
    @response   =  ActionController::TestResponse.new
     post_fix = "_1"
    login_as TCANA_admin
    ## initiallize session
     @request.session["selected_result_#{CONTROLLER_PJ}#{post_fix}"] = Array.new
    @request.session["selected_subtask_#{CONTROLLER_PJ}#{post_fix}"] = Array.new
    #call function
    get :delete_results,
      :pu => 1,
      :pj => 1

    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_subtask_list"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
  end

  # Test function: delete_result
  # Test access right
  # controller:pj
  # The user (PU admin) is successfully authenticated
  def test_it_t1_ucm_ddf_070
    p "Test 70"
    @controller = PjController.new
    @request    =  ActionController::TestRequest.new
    @response   =  ActionController::TestResponse.new
    post_fix = "_1"
    login_as PU_admin
    @request.session["selected_result_#{CONTROLLER_PJ}#{post_fix}"] = Array.new
    @request.session["selected_subtask_#{CONTROLLER_PJ}#{post_fix}"] = Array.new
    #call function
    get :delete_results,
      :pu => 1,
      :pj => 1
    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_subtask_list"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
  end

  # Test function: delete_result
  # Test access right
  # Controller:pj
  # The user (PJ admin) is successfully authenticated
  def test_it_t1_ucm_ddf_071
    p "Test 71"
    @controller = PjController.new
    @request    =  ActionController::TestRequest.new
    @response   =  ActionController::TestResponse.new
     post_fix = "_1"
    login_as PJ_admin
    @request.session["selected_result_#{CONTROLLER_PJ}#{post_fix}"] = Array.new
    @request.session["selected_subtask_#{CONTROLLER_PJ}#{post_fix}"] = Array.new
    get :delete_results,
      :pu => 1,
      :pj => 1
    # Test conditions
    # The web is request successful.
    assert_response :success
    assert_template "shared/_subtask_list"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
  end

  #############################################################################
  # Test access right function: update_pj_list
  # ###########################################################################

  #Test function: update_pj_list
  # Case actor (TCANA admin) want to choose all of subtasks in TCANA system
  # [actor select blank option at dropdown list of pu]
  def test_it_t1_ucm_ddf_072
    p "Test 72"
    ## initialize
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :update_pj_list,
      :pu => 0
    # Test conditions
    # The web is request successful.
    assert_response :success
    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"

  end

  #Test function: update_pj_list
  # Case actor (TCANA admin) want to choose all of subtasks belong to selected pu
  # actor select one pu from dropdown list of pu
  def test_it_t1_ucm_ddf_073
    p "Test 73"
    ## initialize
    login_as TCANA_admin
    ## initiallize session
    @request.session["selected_subtask_#{CONTROLLER_MISC}"] = Array.new
    @request.session["selected_result_#{CONTROLLER_MISC}"] = Array.new
    get :update_pj_list,
      :pu => 1
    # Test conditions
    # The web is request successful.
    assert_response :success

    # The user is redirected to the right page.
    assert_template "shared/_data_listing"
    # The correct objects are stored in the response template.
    assert_select "input[type = 'button'][value = '#{_('Check All')}']"
    assert_select "input[type = 'button'][value = '#{_('Uncheck All')}']"
		assert_select "input[type = 'button'][value = '#{_('Delete')}']"
  end
end

