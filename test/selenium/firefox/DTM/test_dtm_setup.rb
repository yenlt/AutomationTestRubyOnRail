require File.dirname(__FILE__) + "/../../config/test_helper" unless defined? ENV["RAILS_ENV"]
require File.dirname(__FILE__) + "/../../config/selenium_setup" unless defined? SeleniumSetup


unless defined?(TestDTMSetup)
  module TestDTMSetup
    include SeleniumSetup
    include GetText

    LOAD_TIME           = "30000"
    SLEEP_TIME          = 8
    SHORT_TIME          = 2
    SELECTED_TAB_COLOR  = "background-color: rgb(238, 255, 223);"
    PJ_member_user      = "pj_member"
    PJ_member_password  = "pj_member"
    TOSCANA_user        = "root"
    TOSCANA_password    = "root"
    PJ_admin_user       = "pj_admin"
    PJ_admin_password   = "pj_admin"
    PJ_admin_user2      = "pj_admin2"
    PJ_admin_password2  = "pj_admin2"
    PU_admin_user       = "pu_admin"
    PU_admin_password   = "pu_admin"

    $display_metric = {
      "name"                  =>  _('Display Metric Transition'),
      "table"                 =>  _("Table"),
      "graph"                 =>  _("Graph"),
      "filter_name"           =>  _("Directory Filter:"),
      "filter_button"         =>  _("Update"),
      "no_subtask"            =>  _("There isn't any subtask!"),
      "download_csv_button"   => _("download csv format"), # "Download CSV Format"
      "target_setting_button" =>  _("Targets Setting"), #"Targets Setting"
      "target_setting_title"  =>  _("Targets Setting"),
      "save_button"           => _("Save"),
      "add_subtask_button"    =>  _("Add Subtask"),
      "pj_field"              =>  _("Select PJ"),
      "task_field"            =>  _("Select Task"),
      "tool_field"            =>  _("Select Analysis Tool"),
      "check_all_button"      =>  _("Check all"), #_("check all"),
      "uncheck_all_button"    =>  _("Uncheck all"),#_("uncheck all"),
      "delete_button"         =>    _("Delete"),# _("delete"),
      "here_link"             =>  _("Here"),
      "unextracted_message_en"   =>  "The results of these subtask are not extracted. The extracting process may take several minutes to finish. If you want to extract, click on And be patient. \n To go back previous page, click here .",
      "unextracted_message_ja"   => "このサブタスクの結果から，まだ指摘を抽出していません。この抽出処理には少々時間がかかります。この処理を行う場合は，クリックしてください。 しばらくお待ちください。 \n 前のページにもどるには，ここをクリックしてください。 here をクリックしてくだざい。 .",
      "metrics"               => _("Metrics"),
      "graph_type"            =>  _("Graph Type"),
      "y_axis"                =>  _("Y Axis"),
      "metric_options"        =>  [_("STTLN"),
        _("STTPP"),
        _("STFNC"),
        _("Number of Warnings (Critical)"),
        _("Number of Warnings (Normal)"),
        _("Number of Warnings (HiRisk)"),
        _("Density of Warnings (Critical)"),
        _("Density of Warnings (Normal)"),
        _("Density of Warnings (HiRisk)")],
      "graph_type_options"    =>  [_("Bar"),
        _("Line")],
      "save_message"          =>  _("Targets setting were saved."),
      "extracting_message"    =>  _("Extracting data... Please wait!"),
      "success_message_en"       =>  _("Extracting finish. Click here to continue"),
      #データ抽出は終了しました。here をクリックしてくだざい。
      "success_message_ja"       =>  _("データ抽出は終了しました。here をクリックしてくだざい。")
    }

    $display_metric_xpath = {
      "menu"                  =>  "//div[@id='menu']/ul/li[8]",
      "title"                 =>  "//div[@id='right_contents']/form/table[@id='tab_title']/tbody/tr[1]/th[1]",
      "table_name"            =>  "//table[@id= 'tab_title']/tbody/tr[3]/td[1]/a",
      "graph_name"            =>  "//table[@id= 'tab_title']/tbody/tr[3]/td[2]/a",
      "table"                 =>  "//table[@id= 'tab_title']/tbody/tr[3]/td[1]/a",
      "graph"                 =>  "//table[@id= 'tab_title']/tbody/tr[3]/td[2]/a",
      "filter_name"           =>  "//table[@id= 'tab_title']/tbody/tr[2]/th",
      "filter_keyword"        =>  "//table[@id= 'tab_title']/tbody/tr[2]/td[1]",
      "filter_button"         =>  "//table[@id= 'tab_title']/tbody/tr[2]/td[2]",
      "no_subtask"            =>  "//table[@id= 'tab_contents']/tbody/tr/td/div/div",
      "table_header"          =>  "//div[@id= 'metric_table_list']/table/tbody[1]/tr/th[__INDEX__]",
      "row"                   =>  "//div[@id= 'metric_table_list']/table/tbody[2]/tr",
      "table_row"             =>  "//div[@id= 'metric_table_list']/table/tbody[2]/tr[__INDEX__]",
      "table_content"               =>  "//div[@id= 'metric_table_list']/table/tbody[2]/tr[__ROW_INDEX__]/td",
      "download_csv_button"         =>  "//div[@id= 'content1']/div/div/input",
      "target_setting_button"       => "//table[@id= 'tab_title']/tbody/tr/th[2]/input",
      "update_button"               =>  "//input[@value='#{_('Update')}']",
      "input_keyword"               =>  "//input[@id= 'filter_keyword']",
      "target_setting_title"        =>  "//div[@id= 'right_contents']/div/div[1]/table/tbody/tr/th[1]",
      "save_button"                 =>  "//input[@value= '#{_('Save')}']",
      "add_subtask_button"          =>  "//input[@value= '#{_('Add Subtask')}']",
      "select_field_header"         =>  "//div[@id= 'target_setting']/div[2]/div/table/tbody/tr/th",
      "pj_select_field"             =>  "//select[@id= 'pjs']",
      "target_setting_header"       =>  "//div[@id= 'target_setting']/div[4]/div/table/tbody/tr/th[__INDEX__]",
      "target_setting_row"          =>  "//tbody[@id= 'target_list']/tr",
      "target_setting_row_content"  =>  "//tbody[@id= 'target_list']/tr[__INDEX__]/td",
      "target_setting_row_checkbox" =>  "//tbody[@id= 'target_list']/tr[__INDEX__]/td[1]/input",
      "check_all_button"            =>  "//div[@id= 'target_setting']/div[4]/div[2]/input[1]",
      "uncheck_all_button"          =>  "//div[@id= 'target_setting']/div[4]/div[2]/input[2]",
      "delete_button"               =>  "//div[@id= 'target_setting']/div[4]/div[2]/input[3]",
      "sample_subtask"              =>  "//input[@value ='#{_('id9')}']",
      "extract"                     =>  "//input[@value = '#{_('Extract')}']",
      "here_link"             =>  "//div[@id = 'unextracted_message']/b/a",
      "success_here_link"     =>  "//div[@id = 'unextracted_message']/h3/a",
      "unextracted_message"   =>  "//div[@id = 'unextracted_message']",
      "add_metric_button"     =>  "//input[@value= '#{_('Add Metrics')}']",
      "redraw_button"         =>  "//input[@value= '#{_('Redraw')}']",
      "select_metrics"        =>  "//div[@id= 'metric_graph']/table[2]/tbody/tr/td",
      "cumulative"            =>  "//input[@id= 'cumulative']",
      "select_metric_row"     =>  "//div[@id= 'metric_graph']/table[3]/tbody/tr",
      "metric_select_box"     =>  "//select[@id= 'metric__INDEX__']",
      "graph_type_select_box" =>  "//select[@id= 'graph_type__INDEX__']",
      ## yaxis
      "pj_list"               =>  "//select[@id = 'pjs']",
      "task_list"             =>  "//select[@id =  'tasks']",
      "yaxis_button"          =>  "//button[@style = 'button']",
      "extracting_element"    =>  "//img[@alt = 'Pleasewait']",
      "wait_element"          =>  "//div[@class = 'waiting']"
    }

    $display_metric_table = {
      "1" =>  _("Subtask ID"),
      "2" =>  _("Task Name"),
      "3" =>  _("PJ Name"),
      "4" =>  _("Date"),
      "5" =>  _("Revision"),
      "6" =>  _("Total STTPP"),
      "7" =>  _("Total STTLN"),
      "8" =>  _("Total STFNC"),
      "9" =>  _("Number of Warnings (Critical)"),
      "10" =>  _("Number of Warnings (HiRisk)"),
      "11" =>  _("Number of Warnings (Normal)"),
      "12" =>  _("Warning Density (Critical)"),
      "13" =>  _("Warning Density (HiRisk)"),
      "14" =>  _("Warning Density (Normal)")
    }

    $target_setting_table = {
      "2" =>  _("Date"),
      "3" =>  _("PJ"),
      "4" =>  _("Task ID"),
      "5" =>  _("Task Name"),
      "6" =>  _("Revision"),
      "7" =>  _("Subtask ID"),
      "8" =>  _("Analysis Tool")
    }
    ## Open display metric page as root user.
    def open_display_metric_page      
      login("root","root")
      open "/devgroup/pu_index/1"
      sleep SHORT_TIME
      @selenium.click $display_metric_xpath["menu"] + "/a"
      wait_for_element_not_present($display_metric_xpath["wait_element"])
      sleep SHORT_TIME
    end
    ## Open display metric page as enter user.
    def open_display_metric_page_as_user(user,password,pu_id)
      login(user,password)
      open "/devgroup/pu_index/#{pu_id}"
      sleep SHORT_TIME
      @selenium.click $display_metric_xpath["menu"] + "/a"
      wait_for_element_not_present($display_metric_xpath["wait_element"])
      sleep SHORT_TIME
    end
    ## Open targets setting page as root user.
    def open_target_setting_page
      open_display_metric_page
      @selenium.click $display_metric_xpath["target_setting_button"]
      sleep SLEEP_TIME
    end
    ## Open targets setting page as enter user.
    def open_target_setting_page_as_user(user,password,pu_id)
      open_display_metric_page_as_user(user,password, pu_id)
      @selenium.click $display_metric_xpath["target_setting_button"]
      sleep SLEEP_TIME
    end
    ## Add 1 unextracted subtask.
    def add_unextracted_subtask
      p "add unextractes subtask"
      new_subtask = DisplayMetric.new
      new_subtask.subtask_id = 7
      new_subtask.selected_pu_id = 1
      new_subtask.task_state_id = 5
      new_subtask.STTPP = 0
      new_subtask.STFNC = 0
      new_subtask.STTLN = 0
      new_subtask.critical_number = 0
      new_subtask.hirisk_number = 0
      new_subtask.normal_number = 0
      new_subtask.critical_density = 0
      new_subtask.hirisk_density = 0
      new_subtask.normal_density = 0
      new_subtask.extracted = 0
      new_subtask.save
    end

  end
end


