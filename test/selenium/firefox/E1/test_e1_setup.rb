require File.dirname(__FILE__) + "/../../config/test_helper" unless defined? ENV["RAILS_ENV"]
require File.dirname(__FILE__) + "/../../config/selenium_setup" unless defined? SeleniumSetup

unless defined?(TestE1Setup)
  module TestE1Setup
    include SeleniumSetup
    include GetText
    if $lang == "ja"
      SUBTASK_STATUSES =   {1 => "待ち",      # waiting
                          2 => "解析中",    # analyzing
                          3 => "異状",      # trouble
                          4 => "キャンセル",# canceled
                          5 => "完了"}      # completed
    elsif $lang == "en"
      SUBTASK_STATUSES =   {1 => "On Wait",      # waiting
                          2 => "On Analyze",    # analyzing
                          3 => "On Trouble",      # trouble
                          4 => "On Execute Cancel",# canceled
                          5 => "Complete"}      # completed
    end
    TASK_STATUS_MESSAGES = {1 => _("This Task is in the state waiting for analysis now."),  # on wait
                            2 => _("This Task is under analysis now."),        # on analyze
                            3 => _("The taks was abnormal ended during analysis."),
                            4 => _("This task was canceled."),
                            5 => _("This task was completed.")}

    TASK_ROW = 'task_id1' unless defined? TASK_ROW
    INDIVIDUAL_TASK_ROW = 'task_id2'
    OTHER_TASK_ROW = 'task_id3'

    PU_ID = 1
    PJ_ID = 1
    TASK_ID = 1

    TAB_PANE_STYLES   = {"focused"    => "display: block;",
                         "unfocused"  => "display: none;" }
                       

    task_styles = {'firefox' => {"mouseover"  => "background-color: rgb(255, 255, 204); color: rgb(255, 0, 0);",
                    "waiting"   => "background-color: rgb(255, 255, 255);",
                    "analyzing" => "background-color: rgb(204, 255, 255);",
                    "aborted"   => "background-color: rgb(255, 102, 51);",
                    "cancelled" => "background-color: rgb(255, 204, 51);",
                    "completed" => "background-color: rgb(204, 204, 255);", },
                  'ie' => {"mouseover"  => "color: #ff0000; background-color: #ffffcc;",
                    "waiting"   => 'background-color: #ffffff;',
                    "analyzing" => "background-color: #ccffff;",
                    "aborted"   => "background-color: #ff6633;",
                    "cancelled" => "background-color: #ffcc33;",
                    "completed" => "background-color: #ccccff;", }
                    }


    tab_header_styles = {'firefox' => {'focused'    => 'background-color: rgb(238, 255, 223);',
                                       'unfocused'  => 'background-color: rgb(192, 192, 192);'},
                         'ie' => {'focused'    => 'background-color: #eeffdf;',
                                  'unfocused'  => 'background-color: #c0c0c0;'},
                            }

    TASK_STYLES = task_styles[BROWSER]
    TAB_HEADER_STYLES = tab_header_styles[BROWSER]
    def check_task_background(task_status)
      task_statuses = ['mouseover',
                       "waiting",
                       "analyzing",
                       'aborted',
                       'cancelled',
                       'completed']
      task_state_id = task_statuses.index(task_status)
      task = Task.find(1)
      task.subtask.each do |st|
        st.task_state_id = task_state_id
        st.save
      end
      task.task_state_id = task_state_id
      task.save

      access_task_management_page_as_root
      #
      expected_row_style = TASK_STYLES[task_status]
      row_style = get_style(TASK_ROW)
      assert_equal(expected_row_style,
                   row_style)

      logout
    end
    def check_tab_header_style(tab_name,
                               wanted_style)
      tab_headers = element_locator('tab_headers')
      tab_header  = tab_headers[tab_name]

      # asserts the style
      expected_header_style = TAB_HEADER_STYLES[wanted_style]
      header_style = get_style(tab_header)
      assert_equal(expected_header_style,
                   header_style)
    end

    def check_tab_pane_style(tab_name,
                             wanted_style)
      tab_panes = element_locator('tab_panes')
      tab_pane  = tab_panes[tab_name]
      expected_pane_style = TAB_PANE_STYLES[wanted_style]

      # asserts the style
      pane_style = get_style(tab_pane)
      assert_equal(expected_pane_style,
                   pane_style)
    end

    def get_col(tab_name, col_name)
      cols = ['id', 'name', 'date']
      col_index = cols.index(col_name) + 1

      task_lists  = element_locator('task_lists')
      task_list   = task_lists[tab_name]
      task_list_row_xpath = "//tbody[@id='#{task_list}']/tr"
      total_rows = get_xpath_count(task_list_row_xpath)

      values = []
      (1..total_rows).each do |row_index|
        cell_xpath  = task_list_row_xpath + "[#{row_index}]/td[#{col_index}]"
        value       = get_text(cell_xpath)
        values << value
      end
      values
    end


    def open_tab(tab_name='overall')
      tab_header_links  = element_locator('tab_header_links')
      tab_panes         = element_locator('tab_panes')
      tab_pane          = tab_panes[tab_name]
      tab_headers       = element_locator('tab_headers')
      tab_header        = tab_headers[tab_name]
      tab_header_link   = tab_header_links[tab_name]
      click tab_header_link

      wait_for_style(tab_pane, TAB_PANE_STYLES['focused'])
      wait_for_style(tab_header, TAB_HEADER_STYLES['focused'])
    end

    def open_overall_tab
      open_tab('overall')
    end

    def open_other_tab
      open_tab('other')
    end

    def open_individual_tab
      open_tab('individual')
    end

    def open_task_management_page(pu_id = PU_ID,
                                  pj_id = PJ_ID)
      # request to open Task management page
      open(url_for(:controller  => 'task',
                   :action      => 'index2',
                   :pu          => pu_id,
                   :pj          => pj_id))

      # waits for loading page
      wait_for_page_to_load(30000)

      # makes sure that we are in Task management page
      assert(is_text_present($page_titles['task_management_page']))
    end

    def access_task_management_page_as_root(pu_id = PU_ID,
                                            pj_id = PJ_ID)
      login('root',
            'root')
      open_task_management_page(pu_id,
                                pj_id)
    end

    def access_task_management_page_as_pj_member(pu_id = PU_ID,
                                                 pj_id = PJ_ID)
      login('pj_member',
            'pj_member')
      open_task_management_page(pu_id,
                                pj_id)
    end

    def element_locator(element)
        task = {
    'tab_header_links'  => {'overall'     => "link=#{_('Overall Analysis Task')}",
                            'individual'  => "link=#{_('Individual Analysis Task')}",
                            'other'       => "link=#{_('Other')}"},
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
  }
      return task[element]
    end

    def change_page(tab_name,
                    direction = 'next')
      indicators = element_locator('indicators')[tab_name]
      indicator = indicators[direction]

      assert(is_element_present(indicator))
      click indicator
      sleep 5
    end

    def view_task_details(task_row = TASK_ROW)
      click task_row
      # wait for loading task's details
      #wait_for_element_present(element_locator('task_detail'))
      sleep 5
    end

    def view_individual_task_details(task_row = INDIVIDUAL_TASK_ROW)
      open_individual_tab
      view_task_details(task_row)
    end

    def view_other_task_details(task_row = OTHER_TASK_ROW)
      open_other_tab
      view_task_details(task_row)
    end
    def view_setting(setting)
      task_id = 1
      task = Task.find(task_id)

      access_task_management_page_as_root
      view_task_details

      task.subtask.each do |subtask|
        analyze_tool = subtask.analyze_tool.name
        setting_field = element_locator('details')[setting] + "/a"
        text = get_text(setting_field)

        if text != analyze_tool
          setting_field += "[2]"
        end

        click setting_field

        subwindow_title = "#{analyze_tool.upcase}:#{setting}"
        unless setting == "make_root" || setting == "make_options" || setting == "header_file_at_analyze"
          subwindow_title.gsub!("_", " ")
        end
        wait_for_text_present(subwindow_title)

      end
      logout
    end

    def open_pu_index(pu_id = PU_ID)
      open url_for(:controller => 'devgroup',
                   :action => 'pu_index',
                   :pu => pu_id
                  )
    end

    def open_pj_index(pu_id = PU_ID, pj_id = PJ_ID)
      open url_for(:controller => 'devgroup',
                   :action => 'pj_index',
                   :pu => pu_id,
                   :pj => pj_id)
    end

    def open_task_detail_page(pu_id = PU_ID,
                              pj_id = PJ_ID,
                              task_id = TASK_ID)
      open url_for(:controller => 'task',
                   :action => 'task_detail',
                   :pu => pu_id,
                   :pj => pj_id,
                   :id => task_id)
      wait_for_page_to_load(30000)
    end

    def access_task_detail_page_as_root(pu_id = PU_ID,
                                        pj_id = PJ_ID,
                                        task_id = TASK_ID)
      login("root", "root")
      open_task_detail_page(pu_id, pj_id, task_id)
    end

    def access_task_detail_page_as_pj_member(pu_id = PU_ID,
                                        pj_id = PJ_ID,
                                        task_id = TASK_ID)
      login("pj_member", "pj_member")
      open_task_detail_page(pu_id,
                            pj_id,
                            task_id)
    end
    
  end
end
