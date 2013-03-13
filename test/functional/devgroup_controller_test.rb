require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../integration/setup'
require 'devgroup_controller'

# General settings for the tests
class DevgroupControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  fixtures :users
  fixtures :privileges
  fixtures :privileges_users
  fixtures :pus
  fixtures :pjs
  fixtures :settings
  fixtures :display_metrics

  def test_000
    #import_sql
  end

  def setup
    @controller = DevgroupController.new
    @request    = ActionController::TestRequest.new
    @request.env["HTTP_REFERER"] = "www.google.com"
    @response   = ActionController::TestResponse.new
    @user = { :name => "root", :id => 1 }
    @privileges  = [:admin, :pum, :pjm, :pumem, :pjmem]

    login_as @user[:name]
    set_privilege(@privileges[0], 1, 2)
    post :save_pj_scm_config, :pj => 2,
      :scm_config => {
      :tool => "SVN",
      :repo_path => SVN_REPO_PATH,
      :base_revision => SVN_PROJ1_BASE_REVISION,
      :user => SVN_USER,
      :password => SVN_PASSWORD,
      :qac => "1",
      :qacpp => "0",
      :master_name => "master_pj2",
      :interval => "*/30 * * * *"
    }
  end

  def teardown
    Scheduler.instance.unregister_all_schedules
    ScmConfig.delete_all
    FileUtils.rm_rf("#{RAILS_ROOT}/lib/task_register/repo/1")
    FileUtils.rm_rf("#{RAILS_ROOT}/lib/task_register/repo/2")
  end
end

class DevgroupControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  def test_admin_pu
    login_as @user[:name]
    action = :admin_pu

    # 権限のテスト
    responses = [:success, :redirect, :redirect, :redirect, :redirect]
    for i in 0..4
      set_privilege(@privileges[i], 1, 1)
      get action
      assert_response responses[i]
    end

    # パラメータのテスト
    set_privilege(:admin, 0, 0)
    get action, {}
    assert_response :success
  end

  def test_admin_pj
    login_as @user[:name]
    action = :admin_pj

    # 権限のテスト + getリクエスト
    responses = [:success, :success, :redirect, :redirect, :redirect]
    for i in 0..4
      set_privilege(@privileges[i], 1, 1)
      get action, :pu => 1
      assert_response responses[i]
    end
  end

  def test_add_pu
    login_as @user[:name]
    action = :add_pu

    # postリクエスト
    # berryという名前のPUが新たに追加されたことを確認
    post action, :project_unit => {:name => "berry"}
    assert_valid Pu.find_by_name("berry")

    # PU設定を保存したレコードがあることを確認する
    pu = Pu.find_by_name("berry")
    assert_valid Setting.find_by_setting_key_and_pu_id_and_pj_id("rule_level", pu.id, 0)
    assert_valid Setting.find_by_setting_key_and_pu_id_and_pj_id("message_nums_qac", pu.id, 0)
    assert_valid Setting.find_by_setting_key_and_pu_id_and_pj_id("message_nums_qac_pp", pu.id, 0)
    assert_valid Setting.find_by_setting_key_and_pu_id_and_pj_id_and_tool_id("tool_configuration", pu.id, 0, 1)
    assert_valid Setting.find_by_setting_key_and_pu_id_and_pj_id_and_tool_id("tool_configuration", pu.id, 0, 2)

  end

  def test_add_pj
    login_as @user[:name]
    action = :add_pj

    # postリクエスト
    # jadeという名前のPJが新たに追加されたことを確認
    post :add_pu, :project_unit => {:name => "berry"}
    pu = Pu.find_by_name("berry")

    post action, :pu => pu.id, :project => {:name => "jade"}, :pjs => ""
    assert_valid Pj.find_by_name("jade")

    # PU設定を保存したレコードがあることを確認する
    pj = Pj.find_by_name("jade")
    assert_valid Setting.find_by_setting_key_and_pu_id_and_pj_id("rule_level", pu.id, pj.id)
    assert_valid Setting.find_by_setting_key_and_pu_id_and_pj_id("message_nums_qac", pu.id, pj.id)
    assert_valid Setting.find_by_setting_key_and_pu_id_and_pj_id("message_nums_qac_pp", pu.id, pj.id)
    assert_valid Setting.find_by_setting_key_and_pu_id_and_pj_id_and_tool_id("tool_configuration", pu.id, pj.id, 1)
    assert_valid Setting.find_by_setting_key_and_pu_id_and_pj_id_and_tool_id("tool_configuration", pu.id, pj.id, 2)
  end

  def test_del_pu
    login_as @user[:name]
    action = :del_pu

    # 権限のテスト + getリクエスト
    responses = [:success, :redirect, :redirect, :redirect, :redirect]
    for i in 1..4
      set_privilege(@privileges[i], 1, 1)
      get action
      assert_response responses[i]
    end

    set_privilege(:admin, 0, 0)

    # postリクエスト
    # adminによりPuが確実に削除されたかを確認
    assert_valid Pu.find_by_id(1)
    post action, :id => 1
    assert_equal nil, Pu.find_by_id(1)

    # admin以外がPuを削除できないことを確認
    #    for i in 1..4
    #      assert_valid Pu.find_by_id(2) # banana
    #      set_privilege(@privileges[i], 2, 4)
    #      post action, :id => 2
    #      assert_valid Pu.find_by_id(2) # banana
    #    end
  end

  def test_del_pj
    login_as @user[:name]
    action = :del_pj

    # 権限のテスト + getリクエスト
    responses = [:success, :redirect, :redirect, :redirect, :redirect]
    for i in 1..4
      set_privilege(@privileges[i], 1, 1)
      get action
      assert_response responses[i]
    end

    # postリクエスト
    # adminによりPjが確実に削除されることを確認
    set_privilege(:admin, 0, 0)
    assert_valid Pj.find_by_id(1) # ruby
    post action, :pu => 1, :id => 1
    assert_equal nil, Pj.find_by_id(1)

    #    # pumによりPjが確実に削除されることを確認
    #    set_privilege(:pum, 1, 0)
    #    assert_valid Pj.find_by_id(2) # topaz
    #    post action, :pu => 1, :id => 2
    #    assert_equal nil, Pj.find_by_id(2)
    #
    #    # PJL以下の権限でPjを削除できないことを確認
    #    for i in 2..4
    #      assert_valid Pj.find_by_id(5) # silver
    #      set_privilege(@privileges[i], 2, 5)
    #      post action, :pu => 2, :id => 5
    #      assert_valid Pj.find_by_id(5)
    #    end
  end

  def test_change_pu
    login_as @user[:name]
    action = :change_pu

    # 権限テスト + getリクエスト
    responses = [:success, :redirect, :redirect, :redirect, :redirect]
    for i in 1..4
      set_privilege(@privileges[i], 1, 1)
      get action, :id => 1 # apple(ここでは:idがpuのidを指している
      assert_response responses[i]
    end

    set_privilege(:admin, 0, 0)

    # postリクエスト
    assert_equal "SamplePU1", Pu.find_by_id(1).name
    post action, :id => 1, :change_pu => {:name => "melon"}
    assert_equal "melon", Pu.find_by_id(1).name

    #    # admin以外がPu情報を変更できないことを確認
    #    for i in 1..4
    #      assert_equal "banana", Pu.find_by_id(2).name
    #      set_privilege(@privileges[i], 2, 4)
    #      post action, :id => 2, :pu => {:name => "mango"}
    #      assert_equal "banana", Pu.find_by_id(2).name
    #    end
  end

  def test_change_pj
    login_as @user[:name]
    action = :change_pj

    # 権限テスト + getリクエスト
    responses = [:success, :success, :redirect, :redirect, :redirect]
    for i in 0..4
      set_privilege(@privileges[i], 1, 1)
      get action, :pu => 1, :id => 1 # apple, ruby(ここでは:idがpjのidを指している
      assert_response responses[i]
    end

    # postリクエスト, admin, pumは実行できる
    assert_equal "SamplePJ1", Pj.find_by_id(1).name
    set_privilege(:admin, 0, 0)
    post action, :id => 1, :change_pj => {:name => "jade"}
    assert_equal "jade", Pj.find_by_id(1).name

    #    assert_equal "topaz", Pj.find_by_id(2).name
    #    set_privilege(:pum, 1, 0)
    #    post action, :pj => 2, :change => {:name => "amber"}
    #    assert_equal "amber", Pj.find_by_id(2).name
    #
    #    # pum以下の権限がPj情報を変更できないことを確認
    #    for i in 2..4
    #      assert_equal "silver", Pu.find_by_id(5).name
    #      set_privilege(@privileges[i], 2, 5)
    #      post action, :id => 5, :pu => {:name => "stone"}
    #      assert_equal "silver", Pu.find_by_id(5).name
    #    end
  end

  def test_pu_index
    login_as @user[:name]
    action = :pu_index

    # 権限テスト + getリクエスト
    responses = [:success, :success, :success, :success, :success]
    for i in 0..4
      set_privilege(@privileges[i], 1, 1)
      get action, :pu => 1, :pj => 1 # apple
      assert_response responses[i]
    end
  end

  def test_pj_index
    login_as @user[:name]
    action = :pj_index

    # 権限テスト + getリクエスト
    responses = [:success, :success, :success, :redirect, :success]
    for i in 0..4
      set_privilege(@privileges[i], 1, 1)
      get action, :pu => 1, :pj => 1 # apple, ruby
      assert_response responses[i]
    end
  end

  def test_show_pu_member
    login_as @user[:name]
    action = :show_pu_members

    # 権限テスト + getリクエスト
    responses = [:success, :success, :success, :success, :success]
    for i in 0..4
      set_privilege(@privileges[i], 1, 0)
      get action, :pu => 1, :pj => 0 # apple
      assert_response responses[i]
    end
  end

  def test_show_pj_member
    login_as @user[:name]
    action = :show_pj_members

    # 権限テスト + getリクエスト
    responses = [:success, :success, :success, :success, :success]
    for i in 0..4
      set_privilege(@privileges[i], 1, 1)
      get action, :pu => 1, :pj => 1 # apple, ruby
      assert_response responses[i]
    end
  end

  def test_admin_pu_members
    login_as @user[:name]
    action = :admin_pu_members

    # 権限テスト + getリクエスト
    responses = [:success, :success, :redirect, :redirect, :redirect]
    for i in 0..4
      set_privilege(@privileges[i], 1, 0)
      get action, :pu => 1 # apple
      assert_response responses[i]
    end
  end

  def test_admin_pj_members
    login_as @user[:name]
    action = :admin_pj_members

    # 権限テスト + getリクエスト
    responses = [:success, :success, :success, :redirect, :redirect]
    for i in 0..4
      set_privilege(@privileges[i], 1, 1)
      get action, :pu => 1, :pj => 1 # apple, ruby
      assert_response responses[i]
    end
  end

  def test_admin_pu_admins
    login_as @user[:name]
    action = :admin_pu_admins

    # 権限テスト + getリクエスト
    responses = [:success, :success, :redirect, :redirect, :redirect]
    for i in 0..4
      set_privilege(@privileges[i], 1, 0)
      get action, :pu => 1 # apple
      assert_response responses[i]
    end
  end

  def test_admin_pj_admins
    login_as @user[:name]
    action = :admin_pj_admins

    # 権限テスト + getリクエスト
    responses = [:success, :success, :success, :redirect, :redirect]
    for i in 0..4
      set_privilege(@privileges[i], 1, 1)
      get action, :pu => 1, :pj => 1 # apple, ruby
      assert_response responses[i]
    end
  end

  def test_setting_pu
    login_as @user[:name]
    action = :setting_pu

    # Settingsテーブルをテストするため、PUを追加する
    # PU "berry"
    set_privilege(:admin, 0, 0)
    post :add_pu, :project_unit => {:name => "berry"}
    pu = Pu.find_by_name("berry")


    # postリクエスト                                     # パラメータに統一性が無い
    post action, :pu => pu.id, :setting_pj => {:rule_level_normal => "1",
      :rule_level_hirisk => "1",
      :rule_level_critical => "0"},
      :message_list => {:qac => "1,2,3,4,5",
      :qac_pp => "6,7,8,9,10"},
      :configuration => {:QAC => "test_qac",
      :QACPP => "test_qac_pp"}
    # Setting情報が登録されているかを確認する
    assert_equal "0,1", Setting.find_by_setting_key_and_pu_id("rule_level", pu.id).setting_value
    #    assert_equal "1,2,3,4,5", Setting.find_by_setting_key_and_pu_id("message_nums_qac",pu.id).setting_value
    #    assert_equal "6,7,8,9,10", Setting.find_by_setting_key_and_pu_id("message_nums_qac_pp",pu.id).setting_value
    #    assert_equal "test_qac", Setting.find_by_setting_key_and_pu_id_and_tool_id("tool_configuration", pu.id, 1).setting_value
    #    assert_equal "test_qac_pp", Setting.find_by_setting_key_and_pu_id_and_tool_id("tool_configuration", pu.id, 2).setting_value
  end

  def test_setting_pj
    login_as @user[:name]
    action = :setting_pj

    # Settingsテーブルをテストするため、PU,PJを追加する
    # PU "berry"のPJ "turquoise"
    set_privilege(:admin, 0, 0)
    post :add_pu, :project_unit => {:name => "berry"}
    pu = Pu.find_by_name("berry")
    post :add_pj, :pu => pu.id, :project => {:name => "turquoise"}, :pjs => ""
    pj = Pj.find_by_name("turquoise")

    set_privilege(:admin, 0, 0)

    # postリクエスト
    # # パラメータに統一性が無い
    post action, :pu => pu.id, :pj => pj.id, :setting_pj => {:rule_level_normal => "1",
      :rule_level_hirisk => "1",
      :rule_level_critical => "0"},
      :message_list => {:qac => "1,2,3,4,5",
      :qac_pp => "6,7,8,9,10"},
      :configuration => {:QAC => "test_qac",
      :QACPP => "test_qac_pp"}
    # Setting情報が登録されているかを確認する
    assert_equal "0,1", Setting.find_by_setting_key_and_pu_id_and_pj_id("rule_level", pu.id, pj.id).setting_value
    #    assert_equal "1,2,3,4,5", Setting.find_by_setting_key_and_pu_id_and_pj_id("message_nums_qac",pu.id, pj.id).setting_value
    #    assert_equal "6,7,8,9,10", Setting.find_by_setting_key_and_pu_id_and_pj_id("message_nums_qac_pp",pu.id, pj.id).setting_value
    #    assert_equal "test_qac", Setting.find_by_setting_key_and_pu_id_and_pj_id_and_tool_id("tool_configuration", pu.id, pj.id, 1).setting_value
    #    assert_equal "test_qac_pp", Setting.find_by_setting_key_and_pu_id_and_pj_id_and_tool_id("tool_configuration", pu.id, pj.id, 2).setting_value
  end



  ##############################################################################
  # Setup
  ##############################################################################
  ## get user id
  def get_user_id(account_name)
    user_id = User.find_by_account_name(account_name).id || 0
    return user_id
  end
end

# Test ScmSetting tab
class DevgroupControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  def setup
    @controller = DevgroupController.new
    @request    = ActionController::TestRequest.new
    @request.env["HTTP_REFERER"] = "www.google.com"
    @response   = ActionController::TestResponse.new
    @user = { :name => "root", :id => 1 }
    @privileges  = [:admin, :pum, :pjm, :pumem, :pjmem]

    login_as @user[:name]
    set_privilege(@privileges[0], 1, 2)
    post :save_pj_scm_config,:pu => 1,:pj => 2,
      :scm => {
      :tool => "SVN",
      :repo_path => SVN_REPO_PATH,
      :base_revision => SVN_PROJ1_BASE_REVISION,
      :user => SVN_USER,
      :password => SVN_PASSWORD,
      :tool_ids =>  ["1","2"],
      :master_name => "master_pj2",
      :interval => "*/30 * * * *"
    }
  end

  def teardown
    Scheduler.instance.unregister_all_schedules
    ScmConfig.delete_all
    FileUtils.rm_rf("#{RAILS_ROOT}/lib/task_register/repo/1")
    FileUtils.rm_rf("#{RAILS_ROOT}/lib/task_register/repo/2")
  end

  def save_scm_config_template(pu_id, pj_id, scm_config, notice, success = true)
    login_as @user[:name]
    set_privilege(@privileges[0], 1, pj_id)
    action = :save_pj_scm_config
    post action,:pu => pu_id , :pj => pj_id, :scm => scm_config
    assert_response :success
    assert flash[:notice].include?(notice)

    # If success, the config should be saved
    if (success)
      configs = ScmConfig.find(
        :all,
        :conditions => {
          "pj_id" => pj_id,
          "user_id" => @user[:id],
          "tool" => scm_config[:tool],
          "base_revision" => scm_config[:base_revision],
          "cvs_module" => scm_config[:cvs_module],
          "user" => scm_config[:user],
          "master_name" => scm_config[:master_name],
          "tool_ids" => scm_config[:tool_ids].join(","),
          "interval" => scm_config[:interval]
        }
      )
      assert_equal(1, configs.size)

      if (scm_config[:upload_preprocess])
        assert_not_nil(configs[0].file_name)
      end
    end
  end

  #Test that config can be saved (new) if all parameters are correct (SVN) OK
  def test_it_scm_c_01
    save_scm_config_template(1,1,
      { :tool => "SVN",
        :repo_path => SVN_REPO_PATH,
        :base_revision => SVN_PROJ1_BASE_REVISION,
        :user => SVN_USER,
        :password => SVN_PASSWORD,
        :tool_ids => ["1","2"],
        :master_name => "periodical_master",
        :interval => "*/30 * * * *",
        :upload_preprocess =>fixture_file_upload("files/scm/preprocess.rb")
      },
      "SCM configuration was saved.",
      true
    )

    sleep 1
  end

  # Test that config can be saved (edit) if all parameters are correct (SVN) OK
  def test_it_scm_c_02
    config = ScmConfig.find_by_pj_id(2)
    assert_not_nil(config)
    assert_equal("master_pj2", config.master_name)

    save_scm_config_template(1,2,
      { :tool => "SVN",
        :repo_path => SVN_REPO_PATH,
        :base_revision => SVN_PROJ1_BASE_REVISION,
        :user => SVN_USER,
        :password => SVN_PASSWORD,
        :tool_ids => ["1","2"],
        :master_name => "periodical_master",
        :interval => "*/30 * * * *",
        :upload_preprocess => fixture_file_upload("files/scm/preprocess.rb")
      },
      "SCM configuration was updated.",
      true
    )
  end

  # Test that config can be saved even if base revision is nil(SVN) OK
  def test_it_scm_c_03
    config = ScmConfig.find_by_pj_id(2)
    assert_not_nil(config)
    save_scm_config_template(1,2,
      { :tool => "SVN",
        :repo_path => SVN_REPO_PATH,
        :base_revision => nil,
        :user => SVN_USER,
        :password => SVN_PASSWORD,
        :tool_ids => ["1","2"],
        :master_name => "periodical_master",
        :cvs_module => nil,
        :interval => "*/30 * * * *",
        :upload_preprocess =>fixture_file_upload("files/scm/preprocess.rb")
      },
      "SCM configuration was updated.",
      true
    )
  end

  #Test that config can be saved (new) if all parameters are correct: cvs_access_method = "pserver"(CVS) OK
  def notest_it_scm_c_04
    save_scm_config_template(1,1,
      { :tool => "CVS",
        :repo_path => CVS_REPO_PATH,
        :cvs_module => CVS_MODULE,
        :cvs_access_method => "pserver",
        :base_revision => 1,
        :user => CVS_USER,
        :password => CVS_PASSWORD,
        :tool_ids => ["1","2"],
        :master_name => "periodical_master",
        :interval => "*/30 * * * *",
        :upload_preprocess =>fixture_file_upload("files/scm/preprocess.rb")
      },
      "SCM configuration was saved.",
      true
    )
  end


  # Test that config can be saved (edit) if all parameters are correct (CVS) OK
  def notest_it_scm_c_05
    config = ScmConfig.find_by_pj_id(2)
    assert_not_nil(config)
    assert_equal("master_pj2", config.master_name)

    save_scm_config_template(1,2,
      { :tool => "CVS",
        :repo_path => CVS_REPO_PATH,
        :cvs_module => CVS_MODULE,
        :cvs_access_method => CVS_ACCESS_TYPE,
        :base_revision => 1,
        :user => CVS_USER,
        :password => CVS_PASSWORD,
        :tool_ids => ["1","2","3"],
        :master_name => "periodical_master",
        :interval => "*/30 * * * *",
        :upload_preprocess =>fixture_file_upload("files/scm/preprocess.rb")
      },
      "SCM configuration was updated.",
      true
    )
  end

  # Test that config can be saved even if base revision is nil (CVS) OK
  def notest_it_scm_c_06
    config = ScmConfig.find_by_pj_id(2)
    assert_not_nil(config)

    save_scm_config_template(1,2,
      { :tool => "CVS",
        :repo_path => CVS_REPO_PATH,
        :cvs_access_method => CVS_ACCESS_TYPE,
        :cvs_module => CVS_MODULE,
        :base_revision => nil,
        :user => CVS_USER,
        :password => CVS_PASSWORD,
        :tool_ids => ["1","2"],
        :master_name => "periodical_master",
        :interval => "*/30 * * * *",
        :upload_preprocess =>fixture_file_upload("files/scm/preprocess.rb")
      },
      "SCM configuration was updated.",
      true
    )
  end

  # Test that config can be saved even if preprocess file is nil
  def test_it_scm_c_07
    save_scm_config_template(1,2,
      { :tool => "SVN",
        :repo_path => SVN_REPO_PATH,
        :base_revision => SVN_PROJ1_BASE_REVISION,
        :cvs_module => nil,
        :user => SVN_USER,
        :password => SVN_PASSWORD,
        :tool_ids => ["1","2"],
        :master_name => "periodical_master",
        :interval => "*/30 * * * *",
        :upload_preprocess => fixture_file_upload("files/scm/preprocess.rb")
        #:upload_preprocess => nil
      },
      "SCM configuration was updated.",
      true
    )
  end

  # Test that config cannot be saved if repo path is wrong (SVN) OK
  def test_it_scm_c_08
    save_scm_config_template(1,2,
      { :tool => "SVN",
        :repo_path => "http://abc/yyy/uyuy",
        :base_revision => nil,
        :user => SVN_USER,
        :password => SVN_PASSWORD,
        :tool_ids => ["1","2"],
        :master_name => "periodical_master",
        :interval => "*/30 * * * *",
        :upload_preprocess =>fixture_file_upload("files/scm/preprocess.rb")
      },
      "Incorrect repo_path or username, password or base revision.",
      false
    )
  end

  # Test that config cannot be saved if user is wrong (SVN)
  def test_it_scm_c_09
    save_scm_config_template(1,2,
      { :tool => "SVN",
        :repo_path => SVN_REPO_PATH,
        :base_revision => nil,
        :CVS_MODULE => nil,
        :user => "team8dssd",
        :password => SVN_PASSWORD,
        :tool_ids => ["1","2"],
        :master_name => "periodical_master",
        :interval => "*/30 * * * *",
        :upload_preprocess =>fixture_file_upload("files/scm/preprocess.rb")
      },
      "Incorrect repo_path or username, password or base revision.",
      false
    )
  end

  # Test that config cannot be saved if password is wrong (SVN)
  def test_it_scm_c_10
    save_scm_config_template(1,2,
      { :tool => "SVN",
        :repo_path => SVN_REPO_PATH,
        :base_revision => nil,
        :user => SVN_USER,
        :cvs_module => nil,
        :password => "123456789",
        :tool_ids => ["1","2"],
        :master_name => "periodical_master",
        :interval => "*/30 * * * *",
        :upload_preprocess => nil
      },
      "Incorrect repo_path or username, password or base revision.",
      false
    )
  end

  # Test that config cannot be saved if base revision is wrong (SVN) OK
  def test_it_scm_c_11
    save_scm_config_template(1,2,
      { :tool => "SVN",
        :repo_path => SVN_REPO_PATH,
        :base_revision => -1,
        :user => SVN_USER,
        :password => SVN_PASSWORD,
        :tool_ids => ["1","2","3"],
        :master_name => "periodical_master",
        :interval => "*/30 * * * *",
        :upload_preprocess =>fixture_file_upload("files/scm/preprocess.rb")
      },
      "Incorrect repo_path or username, password or base revision.",#don't have error message for this case.
      false
    )
  end

  # Test that config cannot be saved if repo path is wrong (CVS)
  def notest_it_scm_c_12
    save_scm_config_template(1,2,
      { :tool => "CVS",
        :repo_path => "dsfashttp://abc/yyy/uyuy",
        :base_revision => nil,
        :user => CVS_USER,
        :password => CVS_PASSWORD,
        :cvs_access_method => CVS_ACCESS_TYPE,
        :tool_ids => ["1","2","4"],
        :master_name => "periodical_master",
        :interval => "*/30 * * * *",
        :upload_preprocess =>fixture_file_upload("files/scm/preprocess.rb")
      },
      "Incorrect repo_path or username, password or base revision.",
      false
    )
  end

  # Test that config cannot be saved if password is wrong (CVS [Not OK ]
  def notest_it_scm_c_13
    save_scm_config_template(1,2,
      { :tool => "CVS",
        :repo_path => CVS_REPO_PATH,
        :cvs_module => CVS_MODULE,
        :base_revision => nil,
        :user => CVS_USER,
        :cvs_access_method => CVS_ACCESS_TYPE,
        :password => 'CVS_PAS',
        :tool_ids => ["1","2"],
        :master_name => "periodical_master",
        :interval => "*/30 * * * *",
        :upload_preprocess =>fixture_file_upload("files/scm/preprocess.rb")
      },
      "Incorrect repo_path or username, password or base revision.",
      false
    )
  end

  # Test that config cannot be saved if module name is wrong (CVS)
  def notest_it_scm_c_14
    save_scm_config_template(1,2,
      { :tool => "CVS",
        :repo_path => CVS_REPO_PATH,
        :cvs_module => "Wrong module",
        :base_revision => nil,
        :user => CVS_USER,
        :password => CVS_PASSWORD,
        :cvs_access_method => CVS_ACCESS_TYPE,
        :tool_ids => ["1","2"],
        :master_name => "periodical_master",
        :interval => "*/30 * * * *",
        :upload_preprocess =>fixture_file_upload("files/scm/preprocess.rb")
      },
      "Incorrect repo_path or username, password or base revision.",
      false
    )
  end

  # Test that config cannot be saved if interval has wrong format
  def test_it_scm_c_15
    save_scm_config_template(1,2,
      { :tool => "SVN",
        :repo_path => SVN_REPO_PATH,
        :base_revision => SVN_PROJ1_BASE_REVISION,
        :user => SVN_USER,
        :password => SVN_PASSWORD,
        :tool_ids => ["1","2"],
        :master_name => "periodical_master",
        :interval => "*/3 *",
        :upload_preprocess =>fixture_file_upload("files/scm/preprocess.rb")
      },
      "Invalid crontab format.",
      false
    )
  end

  # Test that config cannot be saved if preprocess file is not a ruby file
  def test_it_scm_c_16
    save_scm_config_template(1,1,
      { :tool => "SVN",
        :repo_path => SVN_REPO_PATH,
        :base_revision => SVN_PROJ1_BASE_REVISION,
        :user => SVN_USER,
        :password => SVN_PASSWORD,
        :tool_ids => ["1","2"],
        :master_name => "periodical_master",
        :interval => "*/30 * * * *",
        :upload_preprocess =>fixture_file_upload("files/scm/preprocess.abc")
      },
      "Invalid preprocess file.",
      false
    )
  end


  # Test that config cannot be saved if no qac/qacpp tool is chosen
  def test_it_scm_c_19
    save_scm_config_template(1,2,
      { :tool => "SVN",
        :repo_path => SVN_REPO_PATH,
        :base_revision => SVN_PROJ1_BASE_REVISION,
        :user => SVN_USER,
        :password => SVN_PASSWORD,
        :tool_ids => [],
        :master_name => "periodical_master",
        :interval => "*/30 * * * *",
        :upload_preprocess =>fixture_file_upload("files/scm/preprocess.rb")
      },
      "Please select analysis tools.",
      false
    )
  end

  # Test that config cannot be saved if no maser is chosen [ OK]
  def test_it_scm_c_20
    save_scm_config_template(1,2,
      { :tool => "SVN",
        :repo_path => SVN_REPO_PATH,
        :base_revision => SVN_PROJ1_BASE_REVISION,
        :user => SVN_USER,
        :password => SVN_PASSWORD,
        :tool_ids => ["1","2"],
        :master_name => nil,
        :interval => "*/30 * * * *",
        :upload_preprocess =>fixture_file_upload("files/scm/preprocess.rb")
      },
      "Invalid master name.",
      false
    )
  end

  # Test that config can be deleted
  def test_it_scm_c_21
    # Add a config
    save_scm_config_template(1,1,
      { :tool => "SVN",
        :repo_path => SVN_REPO_PATH,
        :base_revision => SVN_PROJ1_BASE_REVISION,
        :user => SVN_USER,
        :password => SVN_PASSWORD,
        :tool_ids => ["1","2"],
        :master_name => "temp_master",
        :interval => "*/30 * * * *",
        :upload_preprocess =>fixture_file_upload("files/scm/preprocess.rb")
      },
      "SCM configuration was saved.",
      true
    )

    # Delete a config
    post :delete_pj_scm_config, :pu => 1, :pj => 1
    assert_response :success
    assert_equal "SCM configuration was saved.SCM configuration was saved.SCM configuration was deleted.", flash[:notice]
    config = ScmConfig.find_by_pj_id(1)
    assert_nil(config)
  end

  #Test that config cannot be saved if cvs_access_method is local (CVS) OK
  def notest_it_scm_c_25
    save_scm_config_template(1,1,
      { :tool => "CVS",
        :repo_path => CVS_REPO_PATH,
        :cvs_module => CVS_MODULE,
        :cvs_access_method => "local",
        :base_revision => SVN_PROJ1_BASE_REVISION,
        :user => CVS_USER,
        :password => CVS_PASSWORD,
        :tool_ids => ["1","2"],
        :master_name => "periodical_master",
        :interval => "*/30 * * * *",
        :upload_preprocess =>fixture_file_upload("files/scm/preprocess.rb")
      },
      "Incorrect repo_path or username, password or base revision.",
      false
    )
  end
  #Test that config cannot be saved if cvs_access_method is fork (CVS) OK
  def notest_it_scm_c_26
    save_scm_config_template(1,1,
      { :tool => "CVS",
        :repo_path => CVS_REPO_PATH,
        :cvs_module => CVS_MODULE,
        :cvs_access_method => "fork",
        :base_revision => SVN_PROJ1_BASE_REVISION,
        :user => CVS_USER,
        :password => CVS_PASSWORD,
        :tool_ids => ["1","2"],
        :master_name => "periodical_master",
        :interval => "*/30 * * * *",
        :upload_preprocess =>fixture_file_upload("files/scm/preprocess.rb")
      },
      "Incorrect repo_path or username, password or base revision.",
      false
    )

  end
  #Test that config cannot be saved if cvs_access_method is ext (CVS) OK
  def notest_it_scm_c_27
    save_scm_config_template(1,2,
      { :tool => "CVS",
        :repo_path => CVS_REPO_PATH,
        :cvs_module => CVS_MODULE,
        :cvs_access_method => "ext",
        :base_revision => SVN_PROJ1_BASE_REVISION,
        :user => CVS_USER,
        :password => CVS_PASSWORD,
        :tool_ids => ["1","2"],
        :master_name => "periodical_master",
        :interval => "*/30 * * * *",
        :upload_preprocess =>fixture_file_upload("files/scm/preprocess.rb")
      },
      "Incorrect repo_path or username, password or base revision.",
      false
    )
  end
end
