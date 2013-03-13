require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/setup'

# Test SCM Corporation function
class SCMCorporationTest < ActionController::IntegrationTest
  fixtures :scm_configs
  fixtures :masters
  fixtures :tasks
  fixtures :subtasks
  fixtures :users

  def setup
    @master_name = "pj_master"
    @user = { :name => "root", :id => 1 }
    @privileges  = [:admin, :pum, :pjm, :pumem, :pjmem]
  end

  def teardown
    Scheduler.instance.unregister_all_schedules
    ScmConfig.delete_all
  end

  def test_000
    import_sql
  end

  #############################################################################
  # SUBVERSION
  #############################################################################

  # If a config is saved, the source code will be checked out
  # A base revision is specified, tool = qac
  def test_it_scm_001
    login('root', 'root')
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'SVN',
                       :repo_path => SVN_REPO_PATH,
                       :user => SVN_USER,
                       :password => SVN_PASSWORD,
                       :base_revision => SVN_PROJ1_BASE_REVISION,
                       :qac => "1",
                       :qacpp => "0",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
		assert_response :success
    assert_equal _('SCM configuration was saved.'), flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)

    # Some time to checkout
    sleep 5

    check_local_repo(1)
    check_masters_and_tasks(1, @master_name, SVN_REPO_PATH, 1, SVN_PROJ1_BASE_REVISION)
  end

  # No base revision is specified, tool = qac
  def test_it_scm_002
    login('root', 'root')
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'SVN',
                       :repo_path => SVN_REPO_PATH,
                       :user => SVN_USER,
                       :password => SVN_PASSWORD,
                       :qac => "1",
                       :qacpp => "0",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
		assert_response :success
    assert_equal 'SCM configuration was saved.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)

    # Some time to checkout
    sleep 5

    check_local_repo(1)
    check_masters_and_tasks(1, @master_name, SVN_REPO_PATH, 1)
  end

  # No base revision is specified, tool = qacpp
  def test_it_scm_003
    login('root', 'root')
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'SVN',
                       :repo_path => SVN_REPO_PATH,
                       :user => SVN_USER,
                       :password => SVN_PASSWORD,
                       :qac => "0",
                       :qacpp => "1",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
		assert_response :success
    assert_equal 'SCM configuration was saved.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)

    # Some time to checkout
    sleep 5

    check_local_repo(1)
    check_masters_and_tasks(1, @master_name, SVN_REPO_PATH, 1)
  end

  # No base revision is specified, tool = qacpp and qac
  def test_it_scm_004
    login('root', 'root')
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'SVN',
                       :repo_path => SVN_REPO_PATH,
                       :user => SVN_USER,
                       :password => SVN_PASSWORD,
                       :qac => "1",
                       :qacpp => "1",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
		assert_response :success
    assert_equal 'SCM configuration was saved.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)

    # Some time to checkout
    sleep 5

    check_local_repo(1)
    check_masters_and_tasks(1, @master_name, SVN_REPO_PATH, 2)
  end

  # Delete a configuration
  def test_it_scm_005
    login('root', 'root')
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'SVN',
                       :repo_path => SVN_REPO_PATH,
                       :user => SVN_USER,
                       :password => SVN_PASSWORD,
                       :qac => "1",
                       :qacpp => "0",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
		assert_response :success
    assert_equal 'SCM configuration was saved.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)

    # Delete after 1 second
    sleep 1
    post "/devgroup/delete_pj_scm_config", :pj => 1
    assert_response :success
    assert_equal 'SCM configuration was saved.SCM configuration was deleted.', flash[:notice]

    # Check that the local repository is deleted
    sleep 5
    check_local_repo(1, false)
  end

  # Delete a configuration that takes long time to checkout
  def test_it_scm_006
    login('root', 'root')
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'SVN',
                       :repo_path => SVN_REPO_PATH_LONG_CHECKOUT,
                       :user => SVN_USER,
                       :password => SVN_PASSWORD,
                       :qac => "1",
                       :qacpp => "0",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
		assert_response :success
    assert_equal 'SCM configuration was saved.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)

    # Delete after 1 second
    sleep 1
    post "/devgroup/delete_pj_scm_config", :pj => 1
    assert_response :success
    assert_equal 'SCM configuration was saved.SCM configuration was deleted.', flash[:notice]

    # Check that the local repository is deleted
    sleep 30
    check_local_repo(1, false)
    check_masters_and_tasks(1, @master_name, SVN_REPO_PATH_LONG_CHECKOUT, 1)
  end

  # Edit a configuration (old repository path)
  def test_it_scm_007
    login('root', 'root')
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'SVN',
                       :repo_path => SVN_REPO_PATH,
                       :user => SVN_USER,
                       :password => SVN_PASSWORD,
                       :qac => "1",
                       :qacpp => "0",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
    assert_response :success
    assert_equal 'SCM configuration was saved.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)

    # Edit after 1 second, change master name
    sleep 1
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'SVN',
                       :repo_path => SVN_REPO_PATH,
                       :user => SVN_USER,
                       :password => SVN_PASSWORD,
                       :qac => "1",
                       :qacpp => "0",
                       :upload_preprocess => nil,
                       :master_name => "new_master",
                       :interval => "*/30 * * * *"
      }
    assert_response :success
    assert_equal 'SCM configuration was saved.SCM configuration was updated.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)
    assert_equal(config.repo_path, SVN_REPO_PATH)

    # Check that the master is not created
    sleep 5
    masters = Master.find(
      :all,
      :conditions => {
        "filename"  => "new_master.tar.gz",
        "repo_path" => SVN_REPO_PATH,
        "pj_id"     => 1
      }
    )
    assert_equal 0, masters.length
  end

  # Edit a configuration (new repository path)
  def test_it_scm_008
    login('root', 'root')
    post "/devgroup/save_pj_scm_config", :pj => 2,
      :scm_config => { :tool => 'SVN',
                       :repo_path => SVN_REPO_PATH,
                       :user => SVN_USER,
                       :password => SVN_PASSWORD,
                       :qac => "1",
                       :qacpp => "0",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
    assert_response :success
    assert_equal 'SCM configuration was saved.', flash[:notice]
    config = ScmConfig.find_by_pj_id(2)
    assert_not_nil(config)

    post "/devgroup/save_pj_scm_config", :pj => 2,
      :scm_config => { :tool => 'SVN',
                       :repo_path => SVN_REPO_PATH_LONG_CHECKOUT,
                       :user => SVN_USER,
                       :password => SVN_PASSWORD,
                       :qac => "1",
                       :qacpp => "0",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
    assert_response :success
    assert_equal 'SCM configuration was saved.SCM configuration was updated.', flash[:notice]

    sleep 2
    config = ScmConfig.find_by_pj_id(2)
    assert_not_nil(config)
    assert_equal(config.repo_path, SVN_REPO_PATH_LONG_CHECKOUT)

    # Check that the local repository is deleted
    sleep 70
    check_local_repo(2, true)
    check_masters_and_tasks(2, @master_name, SVN_REPO_PATH_LONG_CHECKOUT, 1)
  end

  # Edit a configuration (new repository path during checking out)
  def test_it_scm_009
    login('root', 'root')
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'SVN',
                       :repo_path => SVN_REPO_PATH_LONG_CHECKOUT,
                       :user => SVN_USER,
                       :password => SVN_PASSWORD,
                       :qac => "1",
                       :qacpp => "0",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
    assert_response :success
    assert_equal 'SCM configuration was saved.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)

    # Edit after 1 second
    sleep 1
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'SVN',
                       :repo_path => SVN_REPO_PATH,
                       :user => SVN_USER,
                       :password => SVN_PASSWORD,
                       :qac => "1",
                       :qacpp => "0",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
    assert_response :success
    assert_equal 'SCM configuration was saved.SCM configuration was updated.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)
    assert_equal(config.repo_path, SVN_REPO_PATH)

    # Check that the local repository is deleted
    sleep 40
    check_local_repo(1, true)
    check_masters_and_tasks(1, @master_name, SVN_REPO_PATH, 1)
  end

  # Check execution of preprocess file
  def test_it_scm_010
    login('root', 'root')
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'SVN',
                       :repo_path => SVN_REPO_PATH,
                       :user => SVN_USER,
                       :password => SVN_PASSWORD,
                       :qac => "0",
                       :qacpp => "1",
                       :upload_preprocess => fixture_file_upload("files/scm/preprocess.rb"),
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      },
			:html => {:multipart => true}

		assert_response :success
    assert_equal 'SCM configuration was saved.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)

    # Some time to checkout
    sleep 5

    check_local_repo(1)
    # If the preprocess file is executed, a new "new_dir" will be created inside
  	# the local directory
  	assert_equal(true, File.exist?("#{RAILS_ROOT}/lib/task_register/repo/1/new_dir"))
  end

  #############################################################################
  # CVS TESTS
  #############################################################################

  # If a config is saved, the source code will be checked out
  # A base revision is specified, tool = qac
  def test_it_scm_016
    login('root', 'root')
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'CVS',
                       :repo_path => CVS_REPO_PATH,
                       :cvs_module => CVS_MODULE,
                       :user => CVS_USER,
                       :password => CVS_PASSWORD,
                       :cvs_access_method => CVS_ACCESS_TYPE,
                       :base_revision => "1",
                       :qac => "1",
                       :qacpp => "0",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
		assert_response :success
    assert_equal 'SCM configuration was saved.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)

    # Some time to checkout
    sleep 5

    check_local_repo(1)
    check_masters_and_tasks(1, @master_name, "#{CVS_REPO_PATH}/#{CVS_MODULE}", 1, 1)
  end

  # No base revision is specified, tool = qac
  def test_it_scm_017
    login('root', 'root')
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'CVS',
                       :repo_path => CVS_REPO_PATH,
                       :cvs_module => CVS_MODULE,
                       :cvs_access_method => CVS_ACCESS_TYPE,
                       :user => CVS_USER,
                       :password => CVS_PASSWORD,
                       :qac => "1",
                       :qacpp => "0",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
		assert_response :success
    assert_equal 'SCM configuration was saved.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)

    # Some time to checkout
    sleep 5

    check_local_repo(1)
    check_masters_and_tasks(1, @master_name, "#{CVS_REPO_PATH}/#{CVS_MODULE}", 1)
  end

  # No base revision is specified, tool = qacpp
  def test_it_scm_018
    login('root', 'root')
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'CVS',
                       :repo_path => CVS_REPO_PATH,
                       :cvs_module => CVS_MODULE,
                       :cvs_access_method => CVS_ACCESS_TYPE,
                       :user => CVS_USER,
                       :password => CVS_PASSWORD,
                       :qac => "0",
                       :qacpp => "1",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
		assert_response :success
    assert_equal 'SCM configuration was saved.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)

    # Some time to checkout
    sleep 5

    check_local_repo(1)
    check_masters_and_tasks(1, @master_name, "#{CVS_REPO_PATH}/#{CVS_MODULE}", 1)
  end

  # No base revision is specified, tool = qacpp and qac
  def test_it_scm_019
    login('root', 'root')
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'CVS',
                       :repo_path => CVS_REPO_PATH,
                       :cvs_module => CVS_MODULE,
                       :cvs_access_method => CVS_ACCESS_TYPE,
                       :user => CVS_USER,
                       :password => CVS_PASSWORD,
                       :qac => "1",
                       :qacpp => "1",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
		assert_response :success
    assert_equal 'SCM configuration was saved.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)

    # Some time to checkout
    sleep 5

    check_local_repo(1)
    check_masters_and_tasks(1, @master_name, "#{CVS_REPO_PATH}/#{CVS_MODULE}", 2)
  end

  # Delete a configuration
  def test_it_scm_020
    login('root', 'root')
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'CVS',
                       :repo_path => CVS_REPO_PATH,
                       :cvs_module => CVS_MODULE,
                       :cvs_access_method => CVS_ACCESS_TYPE,
                       :user => CVS_USER,
                       :password => CVS_PASSWORD,
                       :qac => "1",
                       :qacpp => "0",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
		assert_response :success
    assert_equal 'SCM configuration was saved.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)

    # Delete after 1 second
    sleep 1
    post "/devgroup/delete_pj_scm_config", :pj => 1
    assert_response :success
    assert_equal 'SCM configuration was saved.SCM configuration was deleted.', flash[:notice]

    # Check that the local repository is deleted
    sleep 5
    check_local_repo(1, false)
  end

  # Delete a configuration that takes long time to checkout
  def test_it_scm_021
    login('root', 'root')
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'CVS',
                       :repo_path => CVS_REPO_PATH,
                       :cvs_module => CVS_MODULE_LONG_CHECKOUT,
                       :cvs_access_method => CVS_ACCESS_TYPE,
                       :user => CVS_USER,
                       :password => CVS_PASSWORD,
                       :qac => "1",
                       :qacpp => "0",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
		assert_response :success
    assert_equal 'SCM configuration was saved.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)

    # Delete after 1 second
    sleep 1
    post "/devgroup/delete_pj_scm_config", :pj => 1
    assert_response :success
    #assert_equal 'SCM configuration was deleted.', flash[:notice]

    # Check that the local repository is deleted
    sleep 30
    check_local_repo(1, false)
  end

  # Edit a configuration (old repository path)
  def test_it_scm_022
    login('root', 'root')
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'CVS',
                       :repo_path => CVS_REPO_PATH,
                       :cvs_module => CVS_MODULE,
                       :cvs_access_method => CVS_ACCESS_TYPE,
                       :user => CVS_USER,
                       :password => CVS_PASSWORD,
                       :qac => "1",
                       :qacpp => "0",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
    assert_response :success
    assert_equal 'SCM configuration was saved.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)

    # Edit after 1 second
    sleep 1
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'CVS',
                       :repo_path => CVS_REPO_PATH,
                       :cvs_module => CVS_MODULE,
                       :cvs_access_method => CVS_ACCESS_TYPE,
                       :user => CVS_USER,
                       :password => CVS_PASSWORD,
                       :qac => "1",
                       :qacpp => "0",
                       :upload_preprocess => nil,
                       :master_name => "new_master",
                       :interval => "*/30 * * * *"
      }
    assert_response :success
    assert_equal 'SCM configuration was saved.SCM configuration was updated.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)
    assert_equal(config.cvs_module, CVS_MODULE)

    # Check that there is no new checkout
    sleep 5
    masters = Master.find(
      :all,
      :conditions => {
        "filename"  => "new_master.tar.gz",
        "repo_path" => CVS_REPO_PATH,
        "pj_id"     => 1
      }
    )
    assert_equal 0, masters.length
  end

  # Edit a configuration (new repository path)
  def test_it_scm_023
    login('root', 'root')
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'CVS',
                       :repo_path => CVS_REPO_PATH,
                       :cvs_module => CVS_MODULE,
                       :cvs_access_method => CVS_ACCESS_TYPE,
                       :user => CVS_USER,
                       :password => CVS_PASSWORD,
                       :qac => "1",
                       :qacpp => "0",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
    assert_response :success
    assert_equal 'SCM configuration was saved.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)

    # Edit after 1 second
    sleep 1
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'CVS',
                       :repo_path => CVS_REPO_PATH,
                       :cvs_module => CVS_MODULE_LONG_CHECKOUT,
                       :cvs_access_method => CVS_ACCESS_TYPE,
                       :user => CVS_USER,
                       :password => CVS_PASSWORD,
                       :qac => "1",
                       :qacpp => "0",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
    assert_response :success
    assert_equal 'SCM configuration was saved.SCM configuration was updated.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)
    assert_equal(config.cvs_module, CVS_MODULE_LONG_CHECKOUT)

    # Check that the local repository is deleted
    sleep 70
    check_local_repo(1, true)
    check_masters_and_tasks(1, @master_name, "#{CVS_REPO_PATH}/#{CVS_MODULE_LONG_CHECKOUT}", 1)
  end

  # Edit a configuration (new repository path during checking out)
  def test_it_scm_024
    login('root', 'root')
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'CVS',
                       :repo_path => CVS_REPO_PATH,
                       :cvs_module => CVS_MODULE_LONG_CHECKOUT,
                       :cvs_access_method => CVS_ACCESS_TYPE,
                       :user => CVS_USER,
                       :password => CVS_PASSWORD,
                       :qac => "1",
                       :qacpp => "0",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
    assert_response :success
    assert_equal 'SCM configuration was saved.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)

    # Edit after 1 second
    sleep 1
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'CVS',
                       :repo_path => CVS_REPO_PATH,
                       :cvs_module => CVS_MODULE,
                       :cvs_access_method => CVS_ACCESS_TYPE,
                       :user => CVS_USER,
                       :password => CVS_PASSWORD,
                       :qac => "1",
                       :qacpp => "0",
                       :upload_preprocess => nil,
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
    assert_response :success
    assert_equal 'SCM configuration was saved.SCM configuration was updated.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)
    assert_equal(config.cvs_module, CVS_MODULE)

    # Check that the local repository is deleted
    sleep 30
    check_local_repo(1, true)
    check_masters_and_tasks(1, @master_name, "#{CVS_REPO_PATH}/#{CVS_MODULE}", 1)
  end

  # Check execution of preprocess file
  def test_it_scm_025
    login('root', 'root')
    post "/devgroup/save_pj_scm_config", :pj => 1,
      :scm_config => { :tool => 'CVS',
                       :repo_path => CVS_REPO_PATH,
                       :cvs_module => CVS_MODULE,
                       :cvs_access_method => CVS_ACCESS_TYPE,
                       :user => CVS_USER,
                       :password => CVS_PASSWORD,
                       :qac => "0",
                       :qacpp => "1",
                       :upload_preprocess => fixture_file_upload("files/scm/preprocess.rb"),
                       :master_name => @master_name,
                       :interval => "*/30 * * * *"
      }
		assert_response :success
    assert_equal 'SCM configuration was saved.', flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_not_nil(config)

    # Some time to checkout
    sleep 60

    check_local_repo(1)
    # If the preprocess file is executed, a new "new_dir" will be created inside
    # the local directory
  	assert_equal(true, File.exist?("#{RAILS_ROOT}/lib/task_register/repo/1/new_dir"))
  end

  def check_local_repo(pj_id, exist = true)
    # Check the existence of checkout folder
    assert_equal(exist, File.exist?("#{RAILS_ROOT}/lib/task_register/repo/#{pj_id}"))
    assert_equal(exist, File.exist?("#{RAILS_ROOT}/lib/task_register/log/log_#{pj_id}.txt"))
  end

  def check_masters_and_tasks(pj_id, master_name, master_repo, subtasks_num = 1, revision = nil)
    # Check the existence of master, tasks and subtasks
    masters = Master.find(
      :all,
      :conditions => {
        "filename"  => "#{master_name}.tar.gz",
        "repo_path" => master_repo,
        "pj_id"     => pj_id#,
        #"user_id"   => @user.id
      }
    )

    assert_equal(1, masters.size)
    master = masters[masters.size - 1]
    assert_equal(revision, master.revision) if revision

    tasks = Task.find(
      :all,
      :conditions => {
        "pj_id" => pj_id,
        "master_id" => master.id
      }
    )
    assert_equal(1, tasks.size)

    subtasks = Subtask.find(
      :all,
      :conditions => {
        "task_id"   => tasks[0].id,
        "master_id" => master.id,
      }
    )
    assert_equal(subtasks_num, subtasks.size)
  end

  def login(user, pass)
    get "/auth/login"
    assert_response :success
    post "/auth/login", :login => user, :password => pass
    assert_redirected_to :controller => "misc", :action => "index"
    get "/misc"
    assert_response :success
  end

end
