require File.dirname(__FILE__) + '/../test_helper'
require 'auth_controller'

# Re-raise errors caught by the controller.
class AuthController; def rescue_action(e) raise e end; end

class AuthControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :users
  fixtures :privileges_users

  def setup
    @controller = AuthController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # index�ւ̃A�N�Z�X
  def test_get_index_page
    get :index
    assert_redirected_to :action => "login"
  end

  # ���O�C���y�[�W�ւ̃A�N�Z�X
  def test_get_login_form
    get :login
    assert_response :success
  end

  # �L��ȃ��O�C����,�p�X���[�h
  def test_login
    post :login, :login => 'root', :password => 'root'
    assert_redirected_to :controller => "misc", :action => "index"
  end

  # ����ȃ��O�C����
  def test_invalid_login
    post :login, :login => 'unknown', :password => 'invalid'
    assert_template "login"
  end

  # ����ȃp�X���[�h
  def test_invalid_password
    post :login, :login => 'root', :password => 'invalid'
    assert_template "login"
  end

  # �폜���ꂽ���[�U�ɂ�郍�O�C��
  def test_deleted_user_login
    post :login, :login => 'cheeter', :password => 'test'
    assert_template "login"
  end

  # ���O�A�E�g
  def test_logout
    login_as :root
    post :logout
    assert_redirected_to :controller => "auth", :action => 'login'

    login_as :root
    get :logout
    assert_redirected_to :controller => "auth", :action => 'login'
  end
  
  def test_truth
    assert true
  end
end
