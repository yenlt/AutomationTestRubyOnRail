require File.dirname(__FILE__) + "/../../../test_helper" unless defined? ENV["RAILS_ENV"]
require File.dirname(__FILE__) + "/../../config/selenium_setup" unless defined? SeleniumSetup
unless defined?(TestSCMSetup)
  module TestSCMSetup
    include SeleniumSetup
    include GetText
LOAD_TIME           = "30000"
SLEEP_TIME          = 3
SELECTED_TAB_COLOR  = "background-color: rgb(238, 255, 223);"

URL_SVN_RIGHT_KEYWORD   = "svn://192.168.4.51/svn/proj1"
WRONG_URL               = "wrong url"
URL_CVS_RIGHT_KEYWORD   = "192.168.4.51/cvs"
LOGIN_RIGHT_KEYWORD     = "harry"
PASSWORD_RIGHT_KEYWORD  = "harry"
LOGIN_WRONG_KEYWORD     = "wrong"
PASSWORD_WRONG_KEYWORD  = "wrong"
CVS_MODULE_RIGHT        = 'proj1'
CVS_MODULE_LONG_CHECKOUT = 'proj2'  # CVS Module of big project
CVS_ACCESS_TYPE          = 'pserver'         # CVS access type
RIGHT_INTERVAL           = "*/20 * * * *"


MASTER_BASE_NAME_RIGHT_KEYWORD = "master1"

SVN_REPO_PATH_LONG_CHECKOUT   = 'svn://192.168.4.51/svn/proj2' # A big repository
SVN_PROJ1_BASE_REVISION       = 1 # The first revision in which SVN_REPO_PATH exists
SVN_PROJ2_BASE_REVISION       = 3 # The first revision in which SVN_REPO_PATH_LONG_CHECK_OUT exists

PJ_MEMBER_USER          = "pj_member"
PJ_MEMBER_PASSWORD      = "pj_member"
NONE_PJ_MEMBER_USER     = "pj_member2"
NONE_PJ_MEMBER_PASSWORD = "pj_member2"
PU_ADMIN_USER           = "pu_admin"
PU_ADMIN_PASSWORD       = "pu_admin"
PJ_ADMIN_USER           = "pj_admin"
PJ_ADMIN_PASSWORD       = "pj_admin"

$display_scm = {
  "scm_tab_name"        =>  _("Periodical Analysis Setting"),
  "url_rule"            =>  "(file:/// ,http:// ,https:// ,svn:// ,svn+[tunnelscheme]://)",
  "user_field"          =>  _("Login"),
  "password_field"      =>  _("Password"),
  "revision_field"      =>  _("Base Revision"),
  "master_field"        =>  _("Master Base Name"),
  "analysis_field"      =>  _("Analysis Tool"),
  "interval_field"      =>  _("Interval"),
  "interval_rule"       =>  "(crontab format :* * * * * )",
  "file_field"          =>  _("Preprocess File"),
  "success_message"     =>  _("SCM configuration was saved."),
  "url_error"           => _("Incorrect repo_path or username, password or base revision."),
  "master_error"        =>  _("Invalid master name."),
  "analysis_error"      =>  _("Please select analysis tools."),
  "interval_error"      =>  _("Invalid crontab format."),
  "update_message"      =>  _("SCM configuration was updated."),
  "success_delete"      =>  _("SCM configuration was deleted."),
  "error_delete"        =>  _("There are no configuration to be deleted."),
  "save_all_success"    =>  _("PJ setting was saved.")
  }

$display_scm_xpath = {
  "menu_link"           =>  "//div[@id = 'main_area']/div/ul/li[8]/a",
  "save_button"         =>  "//input[@value = '#{_('Save')}']",
  "clear_button"        =>  "//input[@value = '#{_('Clear')}']",
  "delete_button"       =>  "//input[@value = '#{_('Delete')}']",
  "save_all_button"     =>  "//input[@value = '#{_('Save All Settings')}']",
  "scm_tab"             =>  "//table[@id = 'tab_title']/tbody/tr[2]/td[3]/a",
  "scm_select_field"    =>  "//select[@id = 'tool']",
  "url_field"           =>  "//input[@id = 'repo_path']",
  "user_field"          =>  "//input[@id = 'user']",
  "password_field"      =>  "//input[@id = 'password' ]",
  "revision_field"      =>  "//input[@id = 'base_revision' ]",
  "master_field"        =>  "//input[@id = 'master_name' ]",
  "qac"                 =>  "//input[@id = 'tool_ids_qac' ]",
  "qacpp"               =>  "//input[@id = 'tool_ids_qacpp' ]",
  "interval_field"      =>  "//input[@id = 'interval' ]",
  "file_field"          =>  "//input[@id = 'upload_preprocess' ]",
  "cvs_access"          =>  "//select[@id = 'cvs_access_method']",
  "cvs_module"          =>  "//input[@id = 'cvs_module']",

  }


    #
    def open_periodical_analysis_setting_tab
      login("root","root")
      open "/devgroup/pj_index/1/1"
      sleep SLEEP_TIME
      click ($display_scm_xpath["menu_link"])
      wait_for_text_present($display_scm["scm_tab_name"])
      click($display_scm_xpath["scm_tab"])
      sleep SLEEP_TIME
    end
    #
    def fill_scm_form(
        scm = "SVN",
        cvs_access = nil,
        cvs_module = nil,
        url = "svn://192.168.4.51/svn/proj1",
        login = "harry",
        password = "harry",
        base_revision = nil,
        master_base_name = "master",
        qac = "1",
        qacpp = "0",
        interval = "*/30 * * * *",
        preprocess = nil
      )
      if (scm == "SVN")
        @selenium.select $display_scm_xpath["scm_select_field"],"SVN"
      else
        @selenium.select $display_scm_xpath["scm_select_field"],"CVS"
        sleep SLEEP_TIME
        select($display_scm_xpath["cvs_access"], cvs_access) if cvs_access
        type($display_scm_xpath["cvs_module"], cvs_module) if cvs_module
      end
      type($display_scm_xpath["url_field"], url) if url
      type($display_scm_xpath["user_field"], login) if login
      type($display_scm_xpath["password_field"], password) if password
      type($display_scm_xpath["revision_field"], base_revision) if base_revision # TO DO
      type($display_scm_xpath["master_field"], master_base_name) if master_base_name
      check $display_scm_xpath["qac"] if (qac && qac == 1)
      check $display_scm_xpath["qacpp"] if (qacpp && qacpp == 1)
      type($display_scm_xpath["interval_field"], interval) if interval
      if (preprocess)
        # TODO, we may not be able to test this by selenium
      end
    end

  end
end


