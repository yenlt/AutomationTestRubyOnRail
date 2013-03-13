require File.dirname(__FILE__) + '/../test_helper'
require 'user_controller'

# Re-raise errors caught by the controller.
class UserController; def rescue_action(e) raise e end; end

class UserControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :users

  def setup
    @controller = UserController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env["HTTP_REFERER"] = "www.google.com"
    @user = { :name => "pj_member", :id   => 2 } # ログインするユーザ
    @privileges  = [:admin, :pum, :pjm, :pumem, :pjmem] # 権限の一覧
  end

  def test_index
    login_as @user[:name]
    action = :index

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

    # 余分なパラメータを与えた場合
    get action, :id => 1, :pu => 1, :pj => 1
    assert_response :success
  end

  def test_add_user
    login_as @user[:name]
    action = :add_user

    # 権限のテスト
    responses = [:success, :redirect, :redirect, :redirect, :redirect]
    for i in 0..4
      set_privilege(@privileges[i], 1, 1)
      get action
      assert_response responses[i]
    end

    # getリクエスト
    # パラメータのテスト
    set_privilege(:admin, 0, 0)
    get action, {}
    assert_response :success

    # 余分なパラメータを与えた場合
    get action, :id => 1, :pu => 1, :pj => 1
    assert_response :success

    # postリクエスト
    # パラメータのテスト
    post action, :user => { :account_name => "koga1",
                            :first_name   => "yohichiro",
                            :middle_name  => "oyamada",
                            :last_name    => "koga",
                            :nick_name    => "kg416",
                            :email        => "youichir@swc.toshiba.co.jp",
                            :password     => "root"}

    # Userテーブルにレコードが追加されていることを確認
    assert_response :redirect
    assert_valid User.find_by_nick_name("kg416")
    user =  User.find_by_nick_name("kg416")
  end

  def test_delete_user
    login_as @user[:name]
    action = :delete_user

    # ユーザの削除
    set_privilege(:admin, 0, 0)

    assert_valid User.find(10)
    assert_nil User.find(10).deleted_at

    post action, :id => 10 # tiger

    assert_valid User.find(10)
    assert_not_nil User.find(10).deleted_at

    # パラメータのテスト
    post action, :id => 100 # 範囲外ID
    assert_response :redirect

    # パラメータのテスト
    post action, :id => -100 # 範囲外ID
    assert_response :redirect

  end

  def test_self_change_user
    login_as @user[:name]
    action = :self_change_user

    # 権限のテスト + getリクエスト
    responses = [:success, :success, :success, :success, :success]
    for i in 0..4
      set_privilege(@privileges[i], 1, 1)
      get action, :id => @user[:id]
      assert_response responses[i]
    end
    # self_change_userを実行できるのは本人のみ
    responses = [:redirect, :redirect, :redirect, :redirect, :redirect]
    for i in 0..4
      set_privilege(@privileges[i], 1, 1)
      get action, :id => 4 # fox
      assert_response responses[i]
    end

    set_privilege(:admin, 0, 0)

    # postリクエスト
    # 変更前
    dog = User.find(2)
    assert_equal "dog", dog.account_name
    assert_equal "snoopy", dog.first_name
    assert_equal "white", dog.middle_name
    assert_equal "dog"  , dog.last_name
    assert_equal "snoop", dog.nick_name
    assert_equal "dog@example.com", dog.email

    post action, :user => { :id           => 2,
                            :account_name => "baba",
                            :first_name   => "shigeo",
                            :middle_name  => "skyflyer",
                            :last_name    => "baba",
                            :nick_name    => "shige",
                            :email        => "shige@swc.toshiba.co.jp",
                            :password     => "root"}
    assert_response :redirect

    # 変更後
    baba = User.find(2)
    assert_equal "baba", baba.account_name
    assert_equal "shigeo", baba.first_name
    assert_equal "skyflyer", baba.middle_name
    assert_equal "baba"  , baba.last_name
    assert_equal "shige", baba.nick_name
    assert_equal "shige@swc.toshiba.co.jp", baba.email

    # パラメータのテスト、範囲外のid
    post action, :user => { :id           => -100,
                            :account_name => "baba",
                            :first_name   => "shigeo",
                            :middle_name  => "skyflyer",
                            :last_name    => "baba",
                            :nick_name    => "shige",
                            :email        => "shige@swc.toshiba.co.jp",
                            :password     => "root"}
    assert_response :redirect

  end

  def test_change_user
    login_as @user[:name]
    action = :change_user

    # 権限のテスト + getリクエスト
    responses = [:success, :redirect, :redirect, :redirect, :redirect]
    for i in 0..4
      set_privilege(@privileges[i], 1, 1)
      get action, :id => 4 # id=4,fox
      assert_response responses[i]
    end

    set_privilege(:admin, 0, 0)

    # postリクエスト
    # 変更前
    fox = User.find(4)
    assert_equal "fox", fox.account_name
    assert_equal "foxhaund", fox.first_name
    assert_equal "the", fox.middle_name
    assert_equal "sniper"  , fox.last_name
    assert_equal "fox1", fox.nick_name
    assert_equal "fox@example.com", fox.email

    post action, :user => { :id           => 4,
                            :account_name => "baba",
                            :first_name   => "shigeo",
                            :middle_name  => "skyflyer",
                            :last_name    => "baba",
                            :nick_name    => "shige",
                            :email        => "shige@swc.toshiba.co.jp",
                            :password     => "root" }
    assert_response :redirect

    # 変更後
    baba = User.find(4)
    assert_equal "baba", baba.account_name
    assert_equal "shigeo", baba.first_name
    assert_equal "skyflyer", baba.middle_name
    assert_equal "baba"  , baba.last_name
    assert_equal "shige", baba.nick_name
    assert_equal "shige@swc.toshiba.co.jp", baba.email

    # 所属グループの変更により古いGroupsUsersレコードが削除されるか？
    post action, :user => { :id           => 4,
                            :account_name => "baba",
                            :first_name   => "shigeo",
                            :middle_name  => "skyflyer",
                            :last_name    => "baba",
                            :nick_name    => "shige",
                            :email        => "shige@swc.toshiba.co.jp",
                            :password     => "root" }

    # パラメータのテスト、範囲外のid
    post action, :user => { :id           => -100,
                            :account_name => "baba",
                            :first_name   => "shigeo",
                            :middle_name  => "skyflyer",
                            :last_name    => "baba",
                            :nick_name    => "shige",
                            :email        => "shige@swc.toshiba.co.jp",
                            :password     => "root"}
    assert_response :redirect
  end

  def test_admin_privileges
    login_as @user[:name]
    action = :admin_privileges

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

    # 余分なパラメータを与えた場合
    get action, :id => 1, :pu => 1, :pj => 1
    assert_response :success
  end

  def test_add_administrators
    login_as @user[:name]
    action = :add_administrators

    set_privilege(:admin, 0, 0)

    # 権限が設定されたかを確認
    assert_equal nil, PrivilegesUsers.find_by_user_id_and_privilege_id(3,1)
    assert_equal nil, PrivilegesUsers.find_by_user_id_and_privilege_id(4,1)
    assert_equal nil, PrivilegesUsers.find_by_user_id_and_privilege_id(5,1)

    post action, :add => {:managers => [3,4,5]} # cat, fox, monkeyにadmin権限を付与

    assert_valid PrivilegesUsers.find_by_user_id_and_privilege_id(3,1)
    assert_valid PrivilegesUsers.find_by_user_id_and_privilege_id(4,1)
    assert_valid PrivilegesUsers.find_by_user_id_and_privilege_id(5,1)

    # パラメータのテスト
    post action, :add => {:managers => [100,-100,0]} # 範囲外のid
    assert_response :redirect
  end

  def test_del_administrators
    login_as @user[:name]
    action = :del_administrators

    set_privilege(:admin, 0, 0)

    # 権限が削除されたかを確認
    post :add_administrators, :add => {:managers => [3,4,5]} # cat, fox, monkeyにadmin権限を付与

    assert_valid PrivilegesUsers.find_by_user_id_and_privilege_id(3,1)
    assert_valid PrivilegesUsers.find_by_user_id_and_privilege_id(4,1)
    assert_valid PrivilegesUsers.find_by_user_id_and_privilege_id(5,1)

    post action, :del => {:managers => [3,4,5]} # cat, fox, monkeyからadmin権限を削除

    assert_equal nil, PrivilegesUsers.find_by_user_id_and_privilege_id(3,1)
    assert_equal nil, PrivilegesUsers.find_by_user_id_and_privilege_id(4,1)
    assert_equal nil, PrivilegesUsers.find_by_user_id_and_privilege_id(5,1)

    # パラメータのテスト
    post action, :del => {:managers => [100,-100,0]} # 範囲外のid
    assert_response :redirect
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
end
