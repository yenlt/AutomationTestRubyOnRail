require File.dirname(__FILE__) + '/../test_helper'
require 'task_controller'


class TaskControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  fixtures :users
  fixtures :privileges

  fixtures :privileges_users
  fixtures :pus
  fixtures :pjs

  fixtures :analyze_types
  fixtures :masters

  def setup
    @controller = TaskController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env["HTTP_REFERER"] = "www.google.com"
    
    @user = { :name => "pj_member", :id   => 2 } # ログインするユーザ
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
      #assert_response responses[i]
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
  # get:
  #  :pu, :pj,
  # post:
  #  [:pu]
  #  [:pj]
  #  [:task][:tool_1]
  #         [:tool_2]
  #         [:name]
  #         [:expl]
  #         [:update_user]
  #         [:state]
  #         [:master]
  #  [:message_list][:qac]
  #                 [:qac_pp]
  #  [:QAC]
  #  [:QACPP]
#  def test_add_task
#    login_as @user[:name]
#    action = :add_task
#
#    p "add_task"
#
#    # 権限のテスト
#    # 自分の所属するPUまたはPJ
#    responses = [:success, :success, :success, :success, :redirect]
#    for i in 0..4
#      p @privileges[i]
#      set_privilege(@privileges[i], 1, 1)
#      get action, :pu=>1, :pj => 1
#      assert_response responses[i]
#    end
#    # 自分の所属しないPUまたはPJ
#    responses = [:success, :redirect, :redirect, :redirect, :redirect]
#    for i in 0..4
#      p @privileges[i]
#      set_privilege(@privileges[i], 1, 1)
#      get action, :pu=>2, :pj => 4 # pu:banana, pj:sapphire
#      #assert_response responses[i]
#    end
#
#    # パラメータテスト
#    set_privilege(:admin, 0, 0)
#    # パラメータ無し
#    get action
#    assert_response :redirect
#    # 範囲外のパラメータ
#    get action, :pu => 100, :pj => 1
#    assert_response :redirect
#
#    get action, :pu => 1, :pj => 100
#    assert_response :redirect
#  end
end
