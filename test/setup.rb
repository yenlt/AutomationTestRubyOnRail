# General test functions and general test parameters used for all tests
# are put here

#############################################################################
# General test parameters

# SCM Corporation testing parameters
SVN_REPO_PATH = 'svn://192.168.4.53/proj1'               # A small repository
SVN_REPO_PATH_LONG_CHECKOUT = 'svn://192.168.4.53/proj2' # A big repository
SVN_PROJ1_BASE_REVISION = 100 # The first revision in which SVN_REPO_PATH exists
SVN_PROJ2_BASE_REVISION = 100 # The first revision in which SVN_REPO_PATH_LONG_CHECK_OUT exists
SVN_USER = 'angq'          # User to test svn repository
SVN_PASSWORD = 'angq'      # Password to test svn repository

CVS_REPO_PATH = '192.168.4.53/cvs'  # CVS ROOT
CVS_MODULE = 'proj1'                # CVS Module of small project
CVS_MODULE_LONG_CHECKOUT = 'proj2'  # CVS Module of big project
CVS_USER = 'harry'                  # CVS user name
CVS_PASSWORD = 'harry'              # CVS password
CVS_ACCESS_TYPE = 'pserver'         # CVS access type

TEST_DATABASE = Rails.root + "/test/fixtures/files/toscana_test.sql"

#############################################################################
# General functions used for all test cases

def import_sql(file = TEST_DATABASE)
  #p "IMPORT DATA..."
  conf = ActiveRecord::Base.configurations[RAILS_ENV]
  cmd_line = "mysql -h " + conf["host"] +" -D "+conf["database"] + " --user=" + conf["username"] + " --password=" + conf["password"] + " < " + file
  raise Exception, "Error executing " + cmd_line unless system(cmd_line)
end

def login
  get "/auth/login"
  assert_response :success
  post "/auth/login", :login => 'root', :password => 'root'
  assert_redirected_to :controller => "misc", :action => "index"
  get "/misc"
  assert_response :success
  get "review/index"
  assert_response :success
end

def logout
  get "/auth/logout"
  assert_redirected_to :controller => 'auth', :action => 'login'
  post "/auth/login"
  assert_response :success
end

def login_as_user(user,password)
  get "/auth/login"
  assert_response :success
  post "/auth/login", :login => user, :password => password
end

## Set privilege
def set_privilege(privilege, pu, pj)
  # 既存の権限情報を破棄
  PrivilegesUsers.delete_all
  PusUsers.delete_all
  PjsUsers.delete_all

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