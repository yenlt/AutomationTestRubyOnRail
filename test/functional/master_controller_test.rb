require File.dirname(__FILE__) + '/../test_helper'
require 'master_controller'

class MasterControllerTest < ActionController::TestCase

  include AuthenticatedTestHelper

  fixtures :users
  fixtures :privileges

  fixtures :privileges_users
  fixtures :pus
  fixtures :pjs

  fixtures :analyze_types
  fixtures :masters

  def setup
    @controller = MasterController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env["HTTP_REFERER"] = "www.google.com"

    @user = { :name => "pj_member", :id   => 4 } # ログインするユーザ
    @privileges  = [:admin, :pum, :pjm, :pumem, :pjmem] # 権限の一覧
  end

  # 必要なパラメータ
  # :pu, :pj
  def test_index
    login_as @user[:name]
    action = :index

    p "test_index"

    # 権限のテスト
    # 自分の所属するPUまたはPJ
    responses = [:success, :success, :success, :success, :success]
    for i in 0..4
      p @privileges[i]
      set_privilege(@privileges[i], 1, 1)
      get action, :pu=>1, :pj => 1
      assert_response responses[i]
    end
    # 自分の所属しないPUまたはPJ
    responses = [:success, :redirect, :redirect, :redirect, :redirect]
    for i in 0..4
      p @privileges[i]
      set_privilege(@privileges[i], 1, 1)
      get action, :pu=>2, :pj => 4 # pu:banana, pj:sapphire
      assert_response responses[i]
    end

    # パラメータテスト
    set_privilege(:admin, 0, 0)
    # パラメータ無し
    get action
    assert_response :redirect

    # 範囲外のパラメータ
    get action, :pu => 100, :pj => 1
    assert_response :redirect

    get action, :pu => 1, :pj => 100
    assert_response :redirect
  end

  # 必要なパラメータ
  # get
  #  :pu, :pj
  # post
  #  :pu, :pj,
  #  :master => {:file, :name, expl}
  def test_add_master
    login_as @user[:name]
    action = :add_master

    p "test_add_master"

    # 権限のテスト
    # 自分の所属するPUまたはPJ
    responses = [:success, :success, :success, :redirect, :redirect]
    for i in 0..4
      p @privileges[i]
      set_privilege(@privileges[i], 1, 1)
      get action, :pu=>1, :pj => 1
      assert_response responses[i]
    end
    # 自分の所属しないPUまたはPJ
    responses = [:success, :redirect, :redirect, :redirect, :redirect]
    for i in 0..4
      p @privileges[i]
      set_privilege(@privileges[i], 1, 1)
      get action, :pu=>2, :pj => 4 # pu:banana, pj:sapphire
      assert_response responses[i]
    end

    # パラメータテスト
    set_privilege(:admin, 0, 0)
    # getリクエスト
    # パラメータ無し
    get action
    assert_response :redirect
    # 範囲外のパラメータ
    get action, :pu=>100, :pj => 1
    assert_response :redirect

    get action, :pu=>1, :pj => 100
    assert_response :redirect

    # postリクエスト
    # ファイルアップロードが特殊なのでテストしにくい
  end

  # 必要なパラメータ
  # get
  #  :pu, :pj, :id
  # post
  #  :pu, :pj
  #  :master => {:id, :file, :name, expl}
  def test_change_master
    login_as @user[:name]
    action = :add_master

    p "test_change_master"

    # 権限のテスト
    # 自分の所属するPUまたはPJ
    responses = [:success, :success, :success, :redirect, :redirect]
    for i in 0..4
      p @privileges[i]
      set_privilege(@privileges[i], 1, 1)
      get action, :pu=>1, :pj => 1, :id => 1
      assert_response responses[i]
    end
    # 自分の所属しないPUまたはPJ
    responses = [:success, :redirect, :redirect, :redirect, :redirect]
    for i in 0..4
      p @privileges[i]
      set_privilege(@privileges[i], 1, 1)
      get action, :pu=>2, :pj => 4 # pu:banana, pj:sapphire
      assert_response responses[i]
    end

    # パラメータテスト
    set_privilege(:admin, 0, 0)
    # getリクエスト
    # パラメータ無し
    get action
    assert_response :redirect
    # 範囲外のパラメータ
    get action, :pu=>100, :pj => 1, :id => 1
    assert_response :redirect

    get action, :pu=>1, :pj => 100
    assert_response :redirect
    # postリクエスト
    # ファイルアップロードが特殊なのでテストしにくい
  end

  # 必要なパラメータ
  # :id, :pu, :pj
  def test_del_master
    login_as @user[:name]
    action = :del_master

    p "test_del_master"

    # 権限のテスト
    # 自分の所属するPUまたはPJ
    results   = [0, 0, 0, 1, 1] # 0:レコード削除, 1:レコード未削除
    for i in 0..4
      p @privileges[i]
      set_privilege(@privileges[i], 1, 1)
      post action, :pu=>1, :pj => 1, :id => i+1
      if results[i] == 0
        assert_nil Master.find_by_id(i+1)
      else
        assert_valid Master.find_by_id(i+1)
      end
    end
    # 自分の所属しないPUまたはPJ
    results   = [0, 1, 1, 1, 1] # 0:レコード削除, 1:レコード未削除
    for i in 0..4
      p @privileges[i]
      set_privilege(@privileges[i], 1, 1)
      post action, :pu=>2, :pj => 5, :id => 7+i # pu:banana, pj:silver
      if results[i] == 0
        assert_nil Master.find_by_id(7+i)
      else
        assert_valid Master.find_by_id(7+i)
      end
    end

    # パラメータテスト
    set_privilege(:admin, 0, 0)
    # パラメータ無し
    get action
    assert_response :redirect
    # 範囲外のパラメータ
    post action, :pu=>2, :pj => 5, :id => 100 # pu:banana, pj:silver
    assert_response :redirect

    post action, :pu=>100, :pj => 5, :id => 10 # pu:banana, pj:silver
    assert_valid Master.find_by_id(10)
    assert_response :redirect

    post action, :pu=>2, :pj => 100, :id => 10 # pu:banana, pj:silver
    assert_valid Master.find_by_id(10)
    assert_response :redirect
  end

  # 必要なパラメータ
  #  :id, :pu, :pj
  def test_master_detail
    login_as @user[:name]
    action = :master_detail

    p "test_master_detail"

    # 権限のテスト
    # 自分の所属するPUまたはPJ
    responses = [:success, :success, :success, :success, :success]
    for i in 0..4
      p @privileges[i]
      set_privilege(@privileges[i], 1, 1)
      get action, :pu=>1, :pj => 1, :id => 1
      assert_response responses[i]
    end
    # 自分の所属しないPUまたはPJ
    responses = [:success, :redirect, :redirect, :redirect, :redirect]
    for i in 0..4
      p @privileges[i]
      set_privilege(@privileges[i], 1, 1)
      get action, :pu=>1, :pj => 2, :id => 1 # pu:banana, pj:sapphire
      assert_response responses[i]
    end

    # パラメータテスト
    # 範囲外のパラメータ
    set_privilege(:admin, 0, 0)
    post action, :pu=>1, :pj => 2, :id => 100 # pu:banana, pj:silver
    assert_response :redirect

    post action, :pu=>200, :pj => 2, :id => 10 # pu:banana, pj:silver
    assert_response :redirect

    post action, :pu=>1, :pj => 500, :id => 10 # pu:banana, pj:silver
    assert_response :redirect
  end
end
