require File.dirname(__FILE__) + "/selenium.rb"
require File.dirname(__FILE__) + "/test_helper.rb"

module SeleniumSetup
  include GetText
  include SeleniumHelper
  include ERB::Util
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::TagHelper

  bindtextdomain("toscana", :path => File.join(RAILS_ROOT, "locale"))


  # title of pages
  #
  # ex: $page_titles = {"misc_index" => "misc"}
  # use:
  #  $page_titles["misc_index"]     #=> "misc"
  #Analysis Result Report (analyzeme.c.Critical.html)
  $page_titles = {
    "auth_login"                              => _("TOSCANA Login"),
    "index_page"                              => _("User Page"),
    "review_view_result_report_list"          => _("Analysis Result Report List"),
    "review_view_result_report"               => "#{_('Analysis Result Report')} (__FILE_NAME__)",
    "review_view_warning_list"                => _("Warning Listing Page"),
    "review_view_comment_list"                => _("Comment Listing Page"),
    "review_index"                            => _("Review Administration"),
    "review_view_report_warning_list"         => "#{_("Warning Listing Page")} (__FILE_NAME__)",
    "pj_management_page"                      => _("PJ Administration"),
    "master_management_page"                  => _("Master Administration"),
    'task_management_page'                    => _("Analysis Task Administration")
  }

  # xpath used to specify element
  #
  # ex: $xpath = {"controller" => {"view_element" => "master_list"}}
  # use:
  #  $xpath["controller]["view_element"]      #=> "master_list"
  #
  $xpath = {"review"  =>  {"publicize_button"           => "//input[@value='#{_('Publicize')}']",
      "unpublicize_button"         => "//input[@value='#{_('Unpublicize')}']",
      "result_download_button"     => "//input[@value='#{_('Result Download')}']",
      "result_list_headers"        => ["//thead/tr[1]/th[1]", # Path
        "//thead/tr[1]/th[2]", # File name
        "//thead/tr[1]/th[3]", # Registered comments
        "//thead/tr[1]/th[4]", # Total warnings
        "//thead/tr[2]/th[1]", # Not classified yet
        "//thead/tr[2]/th[2]", # Investigating
        "//thead/tr[2]/th[3]", # Fault warning
        "//thead/tr[2]/th[4]", # Intention
        "//thead/tr[2]/th[5]", # Confirmation required
        "//thead/tr[2]/th[6]", # Critical warning
        "//thead/tr[2]/th[7]", # Bug
        "//thead/tr[2]/th[8]"],# Total
      "result_list_body_row"       => "//table[@class='review_table']/tbody/tr",
      "warning_listing_button"     => "//input[@value='#{_('Warning Listing')}']", # WarningListing
      "comment_listing_button"     => "//input[@value='#{_('Comment Listing')}']", # CommentListing
      "review_list_body"           => "//tbody",
      "review_list_row"            => "//tbody/tr",
      "show_comments_button"       => "//input[@value='#{_('Show Comments')}']",
      "hide_comments_button"       => "//input[@value='Hide Comments']",
      "hide_comments_button_ja"       => "//input[@value='コメントを隠す']",
      "comment_editor_div"         => "//div[@id='comment_editor']",
      "risk_type_combobox"         => "//select[@id='risk_type_id']",
      "risk_type_description"      => "//div[@id='risk_type_description']",
      "reference_button"           => "//input[@value='#{_('Reference')}']",
      "warning_row_add_link"       => "link=[#{_('Add')}]",
      "warning_row_edit_link"      => "link=[#{_('Edit')}]",
      "warning_row_delete_link"    => "link=[#{_('Delete')}]",
      "warning_description_frame"                => "//iframe[@id='warning_description___Frame']",
      "warning_description_show_toolbar_button"  => "//input[@value='#{_('Show Toolbar')}' and @title='warning_description']",
      "warning_description_hide_toolbar_button_en"  => "//input[@value='Hide Toolbar' and @title='warning_description']",
      "warning_description_hide_toolbar_button_ja"  => "//input[@value='Toolbarを隠す' and @title='warning_description']",
      "warning_description_toolbar"              => "//tr[@id='xExpanded']",
      "warning_description_toolbar_button"       => "//input[@value='#{_('Toolbar')}' and @title='warning_description']",
      "warning_description_editor_frame"         => "//td[@id='xEditingArea']/iframe",
      "warning_description_body"                 => "//body",
      "sample_source_code_frame"                 => "//iframe[@id='sample_source_code___Frame']",
      "sample_source_code_show_toolbar_button"   => "//input[@value='#{_('Show Toolbar')}' and @title='sample_source_code']",
      "sample_source_code_hide_toolbar_button_en"   => "//input[@value='#{_('Hide Toolbar')}' and @title='sample_source_code']",
      "sample_source_code_hide_toolbar_button_ja"   => "//input[@value='Toolbarを隠す' and @title='sample_source_code']",
      "sample_source_code_toolbar"               => "//tr[@id='xExpanded']",
      "sample_source_code_toolbar_button"        => "//input[@value='#{_('Toolbar')}' and @title='sample_source_code']",
      "sample_source_code_editor_frame"          => "//td[@id='xEditingArea']/iframe",
      "sample_source_code_body"                  => "//body",
      "register_button"                          => "//input[@value='#{_('Register')}']",
      "temporary_save_button"                    => "//input[@value='#{_("Temporary Save")}']",
      "cancel_link"                              => "link=#{_('Cancel')}",
      "delete_link"                              => "link=#{_('Delete')}",
      "page_title"                               => "//h1/div[@id='pagetitle']",
      "referred_rule_number"                     => "//div[@id='referred_comment_list']/table/tbody/tr/td[1]",
      "referred_rule_message"                    => "//div[@id='referred_comment_list']/table/tbody/tr/td[2]",
      "referred_comment_list"                    => "//div[@id='referred_comments']/div[2]",
      "referred_comment_list_page_links"         => "//div[@id='page_links']/div",
      "referred_comment_list_cancel_button"      => "//input[@value='#{_("Cancel")}']",
      "referred_comment_list_ok_button"          => "//input[@value='OK']",
      # Comment Listing Page
      "download_csv_button"      => "//input[@value='#{_('Download CSV Format')}']",
      "upload_csv_button"        => "//input[@value='#{_('Upload CSV Format')}']",
      "upload_file_browser"      => "//input[@id='csv_file']",
      "upload_file_button"       => "//input[@value='#{_('Upload')}']",
      "search_combobox"          => "//select[@id='search_field']",
      "search_combobox_options"  => ["//option[@value='results.path']",
        "//option[@value='warnings.rule']",
        "//option[@value='results.file_name']",
        "//option[@value='results.source_name']"],
      "search_textbox"           => "//input[@id='search_keyword']",
      "search_button"            => "//input[@value='#{_('Search')}']",
      "page_links"               => "//div[@class='pagination']",
      "current_page"             => "//span[@class='current']",
      "disable_previous_page"    => "//span[@class='disabled prev_page']",
      "disable_next_page"        => "//span[@class='disabled next_page']",
      "warning_list_table"       => "//table[@class='review_table']",
      "warning_list_headers"     => ["//thead/tr[1]/th[1]",   # ID
        "//thead/tr[1]/th[2]",   # Directory/Line Number
        "//thead/tr[1]/th[3]",   # Source Name/Character Number
        "//thead/tr[1]/th[4]",   # File Name/Rule Number
        "//thead/tr[1]/th[5]",   # Line Number/Warning message
        "//thead/tr[1]/th[6]",   # Character Number/Code
        "//thead/tr[1]/th[7]",   # Rule Number/Reference
        "//thead/tr[1]/th[8]",   # Warning message/Comment
        "//thead/tr[1]/th[9]",   # Code/Status
        "//thead/tr[1]/th[10]",  # Reference/Action
        "//thead/tr[1]/th[11]",  # Comment/-
        "//thead/tr[1]/th[12]",  # Status/-
        "//thead/tr[1]/th[13]"],  # Action/-
    },
    'task' => {
      'tab_header_links'  => {'overall'     => 'link=全体解析タスク',
        'individual'  => 'link=個人解析タスク',
        'other'       => 'link=その他'},
      'tab_headers'       => {'overall'     => 'tab1',
        'individual'  => 'tab2',
        'other'       => 'tab3'},
      'tab_panes'         => {'overall'     => 'content1',
        'individual'  => 'content2',
        'other'       => 'content3'},
      'task_lists'        => {'overall'     => 'task_list_1',
        'individual'  => 'task_list_2',
        'other'       => 'task_list_3'},
      'task_details'      => 'task_details',
      'task_detail'       => '//table[@class="task_detail"]',

      'details'           => {
        "state_explanation" => "task_state_expl",
        'name'            => '//table[@class="task_detail"]/tbody/tr[2]/td[2]',
        'pj_name'         => "//table[@class='task_detail']//tbody/tr[4]/td[2]",
        'master'          => "//table[@class='task_detail']/tbody/tr[6]/td[2]",
        'status'          => '//td[@class="task_status"]',
        'log_and_result'  => 'log_and_result',
        'result'          => "link=[#{_('Analysis')}]",
        'log'             => "link=[#{_('Log')}]",
        'make_root'               => "//table[@class='task_detail']/tbody/tr[10]/td[2]",
        'header_file_at_analyze'  => "//table[@class='task_detail']/tbody/tr[10]/td[4]",
        'make_options'            => "//table[@class='task_detail']/tbody/tr[11]/td[2]",
        'environment_variables'   => "//table[@class='task_detail']/tbody/tr[11]/td[4]",
        'analyze_allow_files'     => "//table[@class='task_detail']/tbody/tr[12]/td[2]",
        'analyze_deny_files'      => "//table[@class='task_detail']/tbody/tr[12]/td[4]",
        'analyze_tool_config'     => "//table[@class='task_detail']/tbody/tr[13]/td[2]",
        'other'                   => "//table[@class='task_detail']/tbody/tr[13]/td[4]",
        'delete_link'             => "//table[@class='task_detail']/tbody/tr[17]/td[2]/a[1]",
        'analyze_rules'           => "//table[@class='task_detail']/tbody/tr[15]/td/table/tbody/tr",
        'subtask1_state'          => "//tbody[@id='log_and_result']/tr[1]/td[3]",
        'subtask2_state'          => "//tbody[@id='log_and_result']/tr[2]/td[3]",
        'subtask1_result'         => "//tbody[@id='log_and_result']/tr[1]/td[5]/a",
        'subtask2_result'         => "//tbody[@id='log_and_result']/tr[2]/td[5]/a"
      },

      'indicators'        => {'overall'     => {'back' => '//tbody[@id="direction_indicator_1"]//td[1]/a',
          'next' => '//tbody[@id="direction_indicator_1"]//td[3]/a'},
        'individual'  => {'back' => '//tbody[@id="direction_indicator_2"]//td[1]/a',
          'next' => '//tbody[@id="direction_indicator_2"]//td[3]/a'},
        'other'       => {'back' => '//tbody[@id="direction_indicator_3"]//td[1]/a',
          'next' => '//tbody[@id="direction_indicator_3"]//td[3]/a'}},

      'task_indicators' => {'next' => '//div[@id="next_marker"]/a',
        'back' => '//div[@id="prev_marker"]/a'},

      'misc' => {
        'waiting' => '//div[@id="reserved_task"]/ul/ul/ul/li',
        'analyzing' => '//div[@id="executing_task"]/ul/ul/ul/li',
        'completed' => '//div[@id="recent_result"]/ul/ul/ul/li',
      },
      'pu_index' => {
        'waiting' => '//div[@id="reserved_task"]/ul/ul/li',
        'analyzing' => '//div[@id="executing_task"]/ul/ul/li',
        'completed' => '//div[@id="recent_result"]/ul/ul/li',
      },
      'pj_index' => {
        'waiting' => '//div[@id="reserved_task"]/ul/li',
        'analyzing' => '//div[@id="executing_task"]/ul/li',
        'completed' => '//div[@id="recent_result"]/ul/li',
      }
    },
    "misc"  => {"id_link"                    => "link=ID",
      "name_link"                  => "link=#{_('PU name')}",
      "registration_link"          => "link=#{_('Registration date')}" ,
      "PU_link"                    => "link=#{_("PU Administration")}",
      "result_list_PU_row"         => "//tbody[@id='pu_list']/tr",
      "PU_setting_page"            => "link=#{_('PU Setting')}" ,
      "display_page"               => "link=#{_('Execution Setting')}" ,
      "PJ_setting_page"            => "link=#{_('PJ Setting')}" ,
      "PJ_link"                    => "link=#{_("PJ Administration")}",
      "setup_page"                 => "link=[#{_('Register')}]",
      "execution_setting_tab"      => "link=#{_('Analysis Tool Setting')}",
      "general_control_tab"        => "link=#{_('General Setting')}",
      "analyze_rule_numbers"       => "//table[@id='analyze_rule_numbers']/tbody/tr[3]/td[1]/table/tbody/tr[3]/td/a[1]",
      "analyze_rule_numbers_th"    => "//table[@id='analyze_rule_numbers']/tbody/tr[1]/th",
      "tool_setting_th"            => "//div[@id='tool_setting']/table[1]/tbody/tr[1]/th",
      "analytical_rule_setup"      => "//table[@id='analyze_rule_numbers']/tbody/tr[5]/td[1]/table/tbody/tr[3]/td/a[1]",
      "rule_select_window_div"     => "//div[@id='rule_select_window']/h2",
      "tool_configuration_table_tr16" =>"//table[@id='tool_configuration']/tbody/tr[16]/td/a",
      "tool_configuration_table_tr13" =>"//table[@id='tool_configuration']/tbody/tr[13]/td/a",
      "tool_configuration_table_tr10" =>"//table[@id='tool_configuration']/tbody/tr[10]/td/a",
      "tool_configuration_table_tr7"  => "//table[@id='tool_configuration']/tbody/tr[7]/td/a",
      "tool_configuration_table_tr4"  => "//table[@id='tool_configuration']/tbody/tr[4]/td/a",
      "page_list"                   => "//p[@id='page_list']/a",
      "rule_list_tr0"               => "//tbody[@id='rule_list']/tr",
      "rule_list_tr1"               => "//tbody[@id='rule_list']/tr[1]/td[2]",
      "rule_list_tr1_input"         => "//tbody[@id='rule_list']/tr[1]/td[1]/input",
      "check_button"                => "//input[@value='#{_('Check All Rules in This Page')}']",
      "register_button"             => "//input[@value='#{_('Register')}']",
      "clearance_button"            => "//input[@value='#{_('Clear All Rules in This Page')}']",
      "check_all_button"            => "//input[@value='#{_('All Check')}']",
      "clear_all_button"            => "//input[@value='#{_('All Clear')}']",
      "save_all_setup_button"       => "//input[@value='#{_('Save All Settings')}']" ,
      "save_a_setup_button"         => "//input[@value='#{_('Save Setting')}']",
      "tab1_link"                   => "//td[@id=\"tab1\"]",
      "tab2_link"                   => "//td[@id=\"tab2\"]" ,
      "tab1_style"                  => "//td[@id='tab1']@style",
      "tab2_style"                  => "//td[@id='tab2']@style"
    },
    "task"  => {
      'tab_headers' => {'overall' => 'link=全体解析タスク', 'individual' => '個人解析タスク', 'other' => 'その他'},
      'tab_panes'   => {'overall' => 'content1', 'individual' => 'content2', 'other' => 'conten3'},
      "main_area_td4"               => "//div[@id='main_area']/table[@id='tab_title']/tbody/tr[2]/td[4]/a" ,
      "master_tab"                            => "//div[@id='main_area']/table[@id='tab_title']/tbody/tr[2]/td[@id='tab3']/a" ,
      "general_control_tab"                   => "//div[@id='main_area']/table[@id='tab_title']/tbody/tr[2]/td[@id='tab1']/a",
      "execution_setup_tab"                   => "//div[@id='main_area']/table[@id='tab_title']/tbody/tr[2]/td[@id='tab2']/a",
      "read_tree"                             => "//input[@value='#{_('Load directory tree.')}']",
      "option_setup_link"                     => "//div[@id='tab_content_area']/form/table[@id='master_setting_table']/tbody/tr[5]/td[1]/a[1]",
      "option_setup_link2"                    => "//div[@id='tab_content_area']/form/table[@id='master_setting_table']/tbody/tr[5]/td[2]/a[1]",
      "registration_task_button"              => "//input[@value='#{_('Register Analysis Task')}']",
      "back_to_reflect_the_changes"           => "//input[@value='#{_('Save Changes')}']",
      "analyze_allow_file_link"               => "//div[@id='tab_content_area']/form/table[@id='master_setting_table']/tbody/tr[5]/td[1]/a[2]",
      "analyze_allow_file_link2"              => "//div[@id='tab_content_area']/form/table[@id='master_setting_table']/tbody/tr[5]/td[2]/a[2]",
      "analyze_deny_files"                    => "//div[@id='tab_content_area']/form/table[@id='master_setting_table']/tbody/tr[5]/td[1]/a[3]",
      "master_option_chk1"                    => "//div[@id='master_options']/table/tbody/tr[2]/td[1]/table/tbody/tr/td/ul[@id='al1p0n1']/li[1]/input[@id='chkbox_dir1']",
      "master_option_chk2"                    => "//div[@id='master_options']/table/tbody/tr[2]/td[1]/table/tbody/tr/td/ul[@id='al1p0n1']/li[2]/input[@id='chkbox_dir2']",
      "master_option_chk3"                    => "//div[@id='master_options']/table/tbody/tr[2]/td[1]/table/tbody/tr/td/ul[@id='al1p0n1']/ul[@id='al2p2n1']/li[1]/input[@id='chkbox_dir3']",
      "master_option_chk4"                    => "//div[@id='master_options']/table/tbody/tr[2]/td[1]/table/tbody/tr/td/ul[@id='al1p0n1']/ul[@id='al2p2n1']/li[2]/input[@id='chkbox_dir4']",
      "master_option_dir1"                    => "//div[@id='master_options']/table/tbody/tr[2]/td[1]/table/tbody/tr/td/ul[@id='al1p0n1']/li[2]/a[1]",
      "m_link"                                => "//div[@id='master_options']/table/tbody/tr[2]/td[1]/table/tbody/tr/td/ul[@id='al1p0n1']/li[2]/a[2]",
      "make_root_link"                        => "//div[@id='master_options']/table/tbody/tr[2]/td[2]/table/tbody/tr[2]/td/input[@id='option_makeroot']",
      "make_root_main_link"                   => "//div[@id='tab_content_area']/form/table[@id='master_setting_table']/tbody/tr[5]/td[1]/input[@id='makeroot_qac']",
      "master_option_file1"                   => "//div[@id='master_options']/table/tbody/tr[2]/td[1]/table/tbody/tr/td/ul[@id='al1p0n1']/ul[@id='al2p2n1']/li[2]/a[1]",
      "master_option_chk5"                    => "//div[@id='master_options']/table/tbody/tr[2]/td[1]/table/tbody/tr/td/ul[@id='al1p0n1']/ul[@id='al2p2n1']/ul[@id='al3p4n1']/li[1]/input[@id='chkbox_dir5']",
      "master_option_chk6"                    => "//div[@id='master_options']/table/tbody/tr[2]/td[1]/table/tbody/tr/td/ul[@id='al1p0n1']/ul[@id='al2p2n1']/ul[@id='al3p4n1']/li[2]/input[@id='chkbox_dir6']",
      "master_control"                        => "link=#{_('Master Administration')}",
      "master_link"                           => "link=#{_('Master')}",
      "add_task"                              => "//div[@id='task_detail']/table/tbody/tr[17]/td[2]/a[1]/img",
      "task_information"                      => "//table[@id='task_information']/tbody/tr[2]/td[2]",
      "set_qac_link"                          => "//table[@id='master_setting_table']/tbody/tr[5]/td[1]/a[1]",
      "upload_once_name"                      => "//div[@id='master_uploader']/table[@id='upload_analyze_file']/tbody/tr[2]/td/table[@id='upload_once']/tbody/tr/td/input[@id='upload_once_name']",
      "selected_high_rule"                    => "//div[@id='tab_content_area']/table[@id='analyze_rule_numbers']/tbody/tr[3]/td[2]/table/tbody/tr[3]/td/a[1]",
      "register_task"                         => "//input[@value='#{_('Register')}']",
      "save_setting_btn"                      => "//div[@id='tool_setting']/table[1]/tbody/tr[3]/td[2]/input[@value='#{_('Save Setting')}']",
      "task_detail"                           => "//div[@id='task_detail']/table/tbody/tr[6]/td[2]/a[2]",
      "tool_qac"                              => "//table[@id='analyze_rule_and_level']/tbody/tr[2]/td/input[@id='tool_qac']",
      "high_qac"                              => "//table[@id='analyze_rule_and_level']/tbody/tr[3]/td[3]/input[@id='high']",
      "individual_task_analysis"              => "//div[@id='main_area']/table[@id='tab_title']/tbody/tr[2]/td[@id='tab2']/a",
      "tree_link_1"                           => "//div[@id='directory_tree_area']/ul[@id='l1p0n1']/li[1]/a",
      "tree_link_2"                           => "//div[@id='directory_tree_area']/ul[@id='l1p0n1']/li[2]/a",
      "tree_chk_1"                            => "//div[@id='replace_file_area']/table[@id='replace_file_list']/tbody/tr[1]/td[@id='checkbox_field']/input[@id='del_replacement']",
      "read_tree_btn"                         => "//table[@id='upload_each']/tbody/tr[2]/td/input",
      "input_field_id_1"                      => "//div[@id='replace_file_area']/table[@id='replace_file_list']/tbody/tr[1]/td[4]/input",
      "input_field_id_2"                      => "//div[@id='replace_file_area']/table[@id='replace_file_list']/tbody/tr[2]/td[4]/input",
      "chk_value"                             => "//div[@id='replace_file_area']/table[@id='replace_file_list']/tbody/tr[2]/td[5]/input[@id='del_replacement']",
      "add_file_link"                         => "//div[@id='file_uploader']/table[@id='file_upload_table']/tbody/tr[5]/td/a",
      "upload_way"                            => "//div[@id='master_uploader']/table[@id='file_upload_table']/tbody/tr[2]/td[1]/input[@id='file_upload_upload_way_upload_once']"
    },
    "login_page"             =>  "/auth/login",
    "index_page"             =>  "/misc",
    "admin_menu_page"        =>  "/misc/adminmenu",
    "metric_page"            =>  "/metric/index/1/1?id=1",
    "metric"	=> {#button on customize subwindow
      "customize_button"      => "//li[@class='pane-selected']/h3/input[@value='Customize']",
      "redraw_graph_button"		=> "//li[@class='pane-selected']/h3/input[@value='Redraw graph']",
      "check_all_button"			=> "//input[@value='Check All']",
      "uncheck_all_button"		=> "//input[@value='Uncheck All']",
      "ok_button"             => "//input[@value='OK']",
      "cancel_button"         => "//input[@value='Cancel']",
      #content of "Selectmetric" section
      "metric_list"           => "//div[@id='main_area']/ul[2]/li[@class='pane-selected']/div/div/div",
      #chosen panel
      "metric_pane_content"		=> "//div[@id='main_area']/ul[2]/li[@class='pane-selected']",
      #chosen_tab
      "chosen_tab"            => "//div[@id='main_area']/ul/li[@class='tab-selected']/a",
      #unchosen_tab
      "unchosen_tab"          => "//div[@id='main_area']/ul/li[@class='tab-unselected']/a",
      #6 tab of metric view page
      "metric_tab"            =>[	"//div[@id='main_area']/ul/li[1]/a",	#File metric table
        "//div[@id='main_area']/ul/li[2]/a",	#File metric graph
        "//div[@id='main_area']/ul/li[3]/a",	#Class metric table
        "//div[@id='main_area']/ul/li[4]/a",	#Class metric graph
        "//div[@id='main_area']/ul/li[5]/a",	#Func metric table
        "//div[@id='main_area']/ul/li[6]/a"],	#Func metric graph
      #sub_window information
      "sub_window"          	=> "//div[@id='metric_descriptions']",
      "sub_window_list"       => "//div[@id='metric_descriptions']/div",
      #redraw_graph_view
      "redraw_graph_view"     => "//div[@id='main_area']/ul/li[@class='pane-selected']/div[@class='chart_view']",
    },
    "pu_user"  =>  {
      "register_button"     =>  "//input[@value='登録']",
      "add_user_pu"         =>  "//input[@value='>>']",
      "remove_user_pu"      =>  "//input[@value='<<']",
      "pu_user_list_table"  =>  "//div[@id='right_contents']/div/table/tbody/tr",
      "pu_member_management"  =>  "//div[@id='main_area']/div/ul/li[4]/a",
      "pu_member_list"  =>  "//div[@id='main_area']/div/ul/li[3]/a",
    },
    "pj_user"  =>  {
      "add_user_pj"         =>  "//input[@value='>>']",
      "remove_user_pj"      =>  "//input[@value='<<']",
      "pj_member_management"  =>  "//div[@id='main_area']/div/ul/li[4]/a",
      "pj_member_list"  =>  "//div[@id='main_area']/div/ul/li[3]/a",
    },
    "pu"       =>  {
      "pu_list_row"       =>  "//tbody[@id='pu_list']/tr",
      "delete_temp_pu" => "//tbody[@id='pu_list']/tr[2]/td[5]/a[2]",
      "pu_management"     =>  "//div[@id='main_area']/div/div/ul/li[4]/a",
      "pu_registration_administrator"   =>  "//div[@id='main_area']/div/ul/li[5]/a",
      "commit"               =>  "//input[@class='submit']",
    },
    "user"     => {
      "user_table"    =>  "//div[@id='right_contents']/div/table/tbody/tr",
      "user_list_row"    =>  "//div[@id='right_contents']/div/table/tbody/tr",
      "sub_window"   =>  "//div[@id='sub_window']",
      "user_register"=>  "//div[@id='user_register_area']/form/table/tbody",
      "update_user"         =>  "//input[@value='更新']",
      "user_management"     =>  "//div[@id='main_area']/div/div/ul/li[2]/a",
      "register_button"     =>  "//div[@class='button_area']/a",
      "user_infor"          =>  "//div[@id='main_area']/div/ul/li[1]/a",
    } ,
    "pj"       =>  {
      "inherit_pj"        => "//div[@id='add_pj_window']/form/table[2]/tbody/tr[2]/td[1]/ul/li[2]/input",
      "pj_list_row"           =>  "//tbody[@id='pj_list']/tr",
      "pj_registration_administrator"   =>  "//div[@id='main_area']/div/ul/li[5]/a",
      "pj_management"     =>  "//div[@id='main_area']/div/ul/li[6]/a",
    },

    "master"   =>  {"master_list"             =>  "master_list",
      "search_box"              =>  "find_box",
      "search_combobox"         => "find_box",
      "search_combobox_options" => {"name"              => "label=#{_('Entry name')}", #name
        "master_status_id"  => "label=#{_('Used in a task')}", # master's status
        "user_id"           => "label=#{_('Registrant')}", # owner's name
        "created_at"        => "label=#{_('Registration time')}", # registration day
      },
      "search_button"           => "//input[@value='#{_('Search')}']",
      "search_textbox"          => "//input[@id='query']",
      "master_list_row"         =>  "//tbody[@id='master_list']/tr",
      "master_delete_link"      =>  "//tbody[@id='master_list']/tr[__ROW_INDEX__]/td[6]/a[1]",
      "master_change_link"      =>  "//tbody[@id='master_list']/tr[__ROW_INDEX__]/td[6]/a[2]",
      "master_register_link"        => "link=[#{_('Register')}]",
      "master_name_textbox"         => "master_name",
      "master_file_input"           => "master_file",
      "master_explanation_textarea" => "master_expl",
      "master_register_button"      => "//input[@value='#{_('Register')}']",
      "master_list_headers"         => ["link=ID", #id
        "link=#{_('Entry name')}", # entry name
        "link=#{_('Used in a task')}", # assigned to task?
        "link=#{_('Registrant')}", # owner's name
        "link=#{_('Registration date')}", # registration date
      ]
    },
    "master_control"      =>  "//div[@id='main_area']/div/ul/li[6]/a"
  }

  # notice
  #
  # ex: $link_texts = {
  #  "master_management_page"              => "マスタ管理",
  #  "master_registration"                 =>"[登録]",
  #  "logout"                              => "[ログアウト]",
  #  "master_column_id"                    => "ID",
  #  "master_column_name"                  => "エントリ名",
  #  "master_column_master_status_id"      => "タスク割り当て",
  #  "master_column_user_id"               => "登録者",
  #  "master_column_created_at"            => "登録日",
  #  "task_overall_tab"                    => "全体解析タスク",
  #  "task_individual_tab"                 => "個人解析タスク",
  #  "task_other_tab"                      => "その他"
  #}
  # use:
  #  $messages["no_task"]           #=> "解析タスクがありません。"
  #
  $messages = {
    "register_master_failed"              => _("Failed registration/update of a Master. Please confirm an entry content."),
    "no_master"                           => _("A master is unregistered."),
    "register_master_successfully"        => _("was registered"),
    "no_matched_master"                   => _("This Master does not exist."),
    "no_task_in_list"                     => _("There is no analysis task."),
    "task_details"                        => _("Details of an analysis task"),
    "complete_task_description"           => _("This task was completed."),
    "task_detail_denied"                  => _("The details of this task cannot be perused."),
    "master_invalid_filetype"             => _("File format error.This file format may be not \"tar.gz\"."),
    "unpubliczed_subtask"                 => _("The subtask is unpublicized, so you can not access the wanted page!"),
    "subtask_has_no_result"               => _("This subtask has no result report. No file is downloaded"),
    "report_of_empty_source_file"         => _("This report is for an empty source file."),
    "warning_list_empty"                  => _("No warning found."),
    "register_comment"                    => _("A comment was registered successfully!"),
    "temporary_save_comment"              => _("A comment was saved temporarily!"),
    "comment_deleting_confirmation"       => _("Are you sure?"),
    "delete_comment_successfully"         => _("A comment was deleted successfully!"),
    "delete_user_confirm"                 => "newuserを削除してよろしいですか？",
    "pu_member_is_not_registered"         =>  "PUメンバが登録されていません。",
    "save_comment_successfully"           => "A comment was saved successfully!",
    "no_warning_found"                    => _("No warning found."),
    "no_warning_for_download"             => "No download: Warning/Comment list is empty.",
    "upload_csv_failed2"                  => "Upload fails: Unexpected error",
    "upload_csv_failed"                   => "Upload fails: Upload file is invalid.",
    "upload_csv_failed3"                  => _("Upload fails: File content is incorrect (line [1]).Headers are invalid."),
    "no_csv_file_selected"                => _("Please select a .csv file to upload!"),
    "upload_csv_successully"              => _("Upload successfully!"),
    "pj_member_is_not_registered"         =>  "PJメンバが登録されていません。",
    "register_user_failed"                =>  "登録失敗：入力内容をご確認ください。",
    "register_user_success"               =>  "ユーザ _NEW_USER_を登録しました。",
    "update_user-passed"                 =>  "ユーザ情報を更新しました。",
    "update_user_failed"                =>  "ユーザ情報の更新に失敗しました。入力内容をご確認ください。",
  }

  $link_texts = {				"metric_tab"			=>[	"File metric table",
      "File metric graph",
      "Class metric table",
      "Class metric graph",
      "Func metric table",
      "Func metric graph"],
    "master_management_page"              => _("Master Administration"),
    "toscana_management"               => "TOSCANA管理",
    "user_management"                  => "ユーザ管理",
    "register"                         => "[登録]",
    "pu_management"                    => "PU管理",
    "pu_member_list"                   => "PUメンバ一覧",
    "pu_member_management"             => "PUメンバ管理",
    "pu_registration_administrator"    => "PU管理者登録",
    "pj_management"                    => "PJ管理",
    "pj_member_list"                   => "PJメンバ一覧",
    "pj_member_management"             => "PJメンバ管理",
    "pj_registration_administrator"    => "PJ管理者登録",
    "pj_list_adminstrator"             => "PJ管理者一覧",
    "master_control"                   => "マスタ管理",
    "task_management"                  => "解析タスク管理",
    "register_task"                    => "タスクの登録" ,
    "pu_user"     =>{
      "member"              =>  "member[]",
      "non_member"          =>  "non_member[]",
      "manager"             =>  "manager[]",
      "non_manager"         =>  "non_manager[]",
      "pu_user_list_table"  =>  [ "ID番号",
        "ユーザID",
        "ユーザ名",
        "ニックネーム",
        "Emailアドレス", ],
    },
    "pj_user"     =>{
      "member"              =>  "member[]",
      "non_member"         =>  "non_member[]",
      "admin"              =>  "admins[]",
      "non_admin"          =>  "members[]",
    },
    "user"        =>  {
      "user_id"              => "ユーザID",
      "user_register_table" =>  ["user_account_name",
        "user_last_name",
        "user_first_name",
        "user_nick_name",
        "user_email",
        "user_password",
        "user_password_confirmation",
      ]  ,
      "edit_user"           =>  "変更",
      "user_infor"          =>  "ユーザ情報の変更",
    } ,

  }

  # title of subwindows
  # ex: $window_titles = {
  #  "master_registration"                 => "マスターの新規登録",
  #  "master_change"                       => "マスターの新規登録",
  #  "master_information"                  => "マスター情報",
  #  "task_log"                            => "解析実行ログ"
  #  }
  #
  # use:
  #  $window_titles["task_log"] #=> "解析実行ログ"
  #
  #
  $window_titles = {
    "comment_editor"        => "Comment Editor",
    "referred_comment_list" => "Referred Comment List",
    "upload_csv_file"       => "Upload CSV File",
    "master_registration"   => _("Register New Master"),
    "update_user_information" =>  "ユーザ情報の更新",
    "master_information" => _("Master Information"),
    "task_log" => _("Analysis Execution Log"),
    "register_user"         =>  "ユーザの登録",
    "edit_user"             =>  "ユーザ情報の更新",
  }
  $time_delay	=	{
    "delay"									=>	"3"
  }

  def setup
    @verification_errors = []
    if $selenium
      @selenium = $selenium
    else
      @selenium = Selenium::SeleniumDriver.new(SELENIUM_CONFIG)
      @selenium.start
    end
  end

  def teardown
    @selenium.stop unless $selenium
    assert_equal [], @verification_errors
    write_log
  end

  # this function:
  # + enters auth/login page
  # + types username, password
  # + clicks "login" button
  #
  def login(username = "root", password = "root")
    # open login page
    open "auth/login"
    wait_for_text_present($page_titles["auth_login"])

    # type username & password
    type("login", username)
    type("password", password)

    # log in
    click "commit"
    wait_for_page_to_load "30000"
  end

  # logs out
  #
  def logout
    open "auth/logout"
    wait_for_text_present($page_titles["auth_login"])
  end


  # waits until a text appears
  #
  def wait_for_text_present(text)
    assert !60.times{ break if (is_text_present(text) rescue false); sleep 1 }
  end
  # waits until a text disappears
  #
  def wait_for_text_not_present(text)
    assert !60.times{ break if (is_text_present(text) rescue false); sleep 1 }
  end

  # waits until an element appears
  #
  def wait_for_element_present(element)
    assert !60.times{ break if (is_element_present(element) rescue false); sleep 1 }
  end

  # waits until an elemement disappears
  #
  def wait_for_element_not_present(element)
    assert !60.times{ break if (!is_element_present(element) rescue false); sleep 1 }
  end

  # gets "style" attribute of an HTML element
  #
  def get_style(element)
    style = get_attribute(element,
      "style")

    style = style + ";" if style[style.length - 1, 1] != ";" && style != ""
    style
  end

  # gets an attribute of an element
  def get_attribute(element, attribute = nil)
    value = @selenium.get_attribute(element + "@#{attribute.to_s}") rescue ""
    if attribute == "href"
      value.sub!(SELENIUM_CONFIG["browserURL"], "")
    end
    return value.downcase
  end

  # counts total elements which have the same xpath
  #
  def get_xpath_count(element)
    return @selenium.get_xpath_count(element).to_i
  end

  def is_element_not_present(element)
    return !is_element_present(element)
  end

  def wait_for_element_text(element, wanted_text)
    assert !60.times {
      break if(wanted_text == get_text(element) rescue false)
      sleep 1
    }
  end

  # waits until our element has wanted attribute
  #
  def wait_for_attribute(element, attribute, wanted_value)
    assert !60.times {
      break if (wanted_value == get_attribute(element, attribute) rescue false); sleep 1
    }
  end

  # waits until our element changes its attribute
  #
  def wait_for_not_attribute(element, attribute, unwanted_value)
    assert !60.times {
      break if (unwanted_value != get_attribute(element, attribute) rescue false); sleep 1
    }
  end

  def wait_for_style(element, wanted_style)
    assert !10.times {

      break if (wanted_style == (a = get_style(element)) rescue false); sleep 1
      p wanted_style
      p a
    }
  end

  # waits until an element changes it style
  #
  def wait_for_not_style(element,
      unwanted_style)
    wait_for_not_attribute(element, "style", unwanted_style)
  end

  def wait_for_xpath_count(element, xpath)
    assert !60.times{
      break if xpath == get_xpath_count(element) rescue false
      sleep 1
    }
  end

  ##############################################################################
  # write log                                                                  #
  ##############################################################################
  def write_log
    result  = @test_passed ? "Passed" : "Failed"
    file    = File.open($log_file, "a+")
    time    = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    log     = "[#{time}] %-20s %35s" % ["#{self.class.to_s}##{method_name}", result]
    file.puts log
    file.close
  end

  # overrides default url_for method
  #
  def url_for(options)
    ActionController::Routing::Routes.reload if ActionController::Routing::Routes.empty?
    ActionController::Routing::Routes.generate(options, {})
  end

  def full_url_for(options)
    SELENIUM_CONFIG["browserURL"] + url_for(options)
  end

  # reloads all data from "test/fixtures" before executing any testsuite.
  #
  # Please comment this method if you do not want to wait :)
  #
  def test_000
    puts "Loading data from fixtures. This process may take some minutes. Please wait..."

    #system "rake db:fixtures:load"

    conf = ActiveRecord::Base.configurations['development']
    cmd_line = "mysql -h " + conf["host"] +" -D "+conf["database"] +
      " --user=" + conf["username"] + " --password=" + conf["password"] + " < " +
      RAILS_ROOT + "/test/fixtures/files/toscana_test.sql"
    raise Exception, "Error executing " + cmd_line unless system(cmd_line)

    puts "Data loaded successfully!"
  end
end

