require File.dirname(__FILE__) + '/../test_helper'
require 'misc_controller'

class MiscControllerTest < ActionController::TestCase

  include AuthenticatedTestHelper

  fixtures :users
  fixtures :privileges
  fixtures :privileges_users

  def setup
    @controller = MiscController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env["HTTP_REFERER"] = "www.google.com"

    @user = { :name => "pj_member", :id   => 2 } # ログインするユーザ
    @privileges  = [:admin, :pum, :pjm, :pumem, :pjmem] # 権限の一覧
  end

  def test_index
    login_as @user[:name]
    action = :index

    p "test_index"

    # 権限のテスト
    responses = [:success, :success, :success, :success, :success]
    for i in 0..4
      p @privileges[i]
      set_privilege(@privileges[i], 1, 1)
      get action
      assert_response responses[i]
    end

    # パラメータテスト
    # 余分なパラメータ
    set_privilege(:admin, 0, 0)
    get action, :id => 100
    assert_response :success
  end

  def test_adminmenu
    login_as @user[:name]
    action = :adminmenu

    p "test_adminmenu"

    # 権限のテスト
    responses = [:success, :redirect, :redirect, :redirect, :redirect]
    for i in 0..4
      p @privileges[i]
      set_privilege(@privileges[i], 1, 1)
      get action
      assert_response responses[i]
    end

    # パラメータテスト
    # 余分なパラメータ
    set_privilege(:admin, 0, 0)
    get action, :id => 100
    assert_response :success
  end

  def test_setting
    login_as @user[:name]
    action = :setting

    p "test_setting"

    # 権限のテスト
    responses = [:success, :redirect, :redirect, :redirect, :redirect]
    for i in 0..4
      p @privileges[i]
      set_privilege(@privileges[i], 1, 1)
      get action
      assert_response responses[i]
    end

    # パラメータテスト
    # postリクエスト
    set_privilege(:admin, 0, 0)
    get action, :setting => {:display_group => 1}
    # Settingsテーブルにレコードが追加されたことを確認する
    assert_valid Setting.find_by_setting_key_and_setting_value("display_group",1)
  end

  def test_view_glossary
    login_as @user[:name]
    action = :view_glossary

    p "test_view_glossary"

    # 権限のテスト
    responses = [:success, :success, :success, :success, :success]
    for i in 0..4
      p @privileges[i]
      set_privilege(@privileges[i], 1, 1)
      get action
      assert_response responses[i]
    end

    # パラメータテスト
    # 余分なパラメータ
    set_privilege(:admin, 0, 0)
    get action, :id => 100
    assert_response :success
  end

  def set_privilege(privilege, pu, pj)

    # 既存の権限情報を破棄
    PrivilegesUsers.delete_all
    PusUsers.destroy_all
    PjsUsers.destroy_all

    # 権限を設定
    case privilege
    when :admin
      user_privilege = PrivilegesUsers.new
      user_privilege.user_id      = @user[:id]
      user_privilege.privilege_id = 1
      user_privilege.pu_id        = 0
      user_privilege.pj_id        = 0
      user_privilege.save 
    when :pum
      user_privilege = PrivilegesUsers.new
      user_privilege.user_id      = @user[:id]
      user_privilege.privilege_id = 2
      user_privilege.pu_id        = pu
      user_privilege.pj_id        = 0
      user_privilege.save
    when :pjm
      user_privilege = PrivilegesUsers.new
      user_privilege.user_id      = @user[:id]
      user_privilege.privilege_id = 3
      user_privilege.pu_id        = pu
      user_privilege.pj_id        = pj
      user_privilege.save
    when :pumem
      pu_user = PusUsers.new
      pu_user.pu_id   = pu
      pu_user.user_id = @user[:id]
      pu_user.save
    when :pjmem
      pj_user = PjsUsers.new
      pj_user.pj_id   = pj
      pj_user.user_id = @user[:id]
      pj_user.save
    else
      # do nothing
      p "no privilege assigned"
    end
  end
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
