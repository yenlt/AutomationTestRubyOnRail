URL_METRIC_PAGE = "metric/index/1/1?id=1"
URL_METRIC_VIEW_TABLE = "metric/view_table/1/1?id=1"
URL_METRIC_GET_TABLE = "metric/get_table/1/1?id=1"
URL_METRIC_CUSTOMIZE_WINDOW = "metric/view_customize_window/1/1?id=1"
URL_UPDATE_METRIC_LIST = "metric/update_metric_list/1/1?id=1"
URL_METRIC_VIEW_GRAPH = "metric/view_graph/1/1?id=1"
URL_METRIC_DRAW_GRAPH = "metric/draw_graph/1/1?id=1"
URL_TASK_DETAIL_PAGE = "task/task_detail/1/1?id=1"

require File.dirname(__FILE__) + '/../test_helper'

class MetricIntegrationTest < ActionController::IntegrationTest
  def test_000
    import_sql
  end

  def test_without_login
    get "metric/index"
    assert_redirected_to :controller => "auth",:action => "login"
  end

  def test_access_right_funtion
    login
    # invalid Pu
    get URL_METRIC_PAGE
    assert_response :success
    get "metric/index/10/1?id=1"
    assert_equal "PU (id=10) not found" , flash[:notice]
    assert_redirected_to :controller => "misc", :action => "index"
    # invalid Pj
    get URL_METRIC_PAGE
    assert_response :success
    get "metric/index/1/10?id=1"
    assert_equal "PJ (id=10) not found" , flash[:notice]
    assert_redirected_to :controller => "misc", :action => "index"
    # invalid Task
    get URL_METRIC_PAGE
    assert_response :success
    get "metric/index/1/1?id=40"
    assert_equal "Task (id=40) not found" , flash[:notice]
    assert_redirected_to :controller => "misc", :action => "index"
  end

  def test_link_to_metric_page
    login
    get URL_TASK_DETAIL_PAGE
    assert_response :success
    assert_template "task/task_detail"
    assert_select "td.task_status" do
      assert_select "table" do
        assert_select "tr" , :count => 3
        assert_select "a" , "Metrics"
      end
    end
    # click metric link when metric table is available
    get URL_TASK_DETAIL_PAGE
    get URL_METRIC_PAGE
    assert_response :success
    assert_template "metric/index"
    xml_http_request :post, URL_METRIC_VIEW_TABLE + "&metric_type=file"
    assert_response :success
    assert_template "metric/_view_table"
    assert_select "div#1_file_analyze_tools"
    xml_http_request :post, URL_METRIC_GET_TABLE + "&metric_type=file",
      :analyze_tools => ["QAC","QAC++"],:page_index =>1,
      :metrics =>["STFNC","STM33","STTPP"],:order_column => "File name",
      :order_direction => "asc"
    assert_response :success
    assert_template "metric/_metric_table"


    # click metric link when metric table is not available
    get "task/task_detail/1/1?id=2"
    get "/metric/index/1/1?id=2"
    assert_equal "Task (id=2) not found", flash[:notice]
    assert_redirected_to :controller => "misc", :action => "index"
  end

  def test_display_metric_page
    login
    get URL_METRIC_PAGE
    assert_response :success
    # metric page display
    assert_template "metric/index"
    #assert_select "pagetitle","Metric View"
    # 6 tabs appear
    assert_select "div#main_area" do
      assert_select "ul#tabcontrol1" do
        assert_select "li#file_table_tab a","File Metric Table"
        assert_select "li#file_graph_tab a","File Metric Graph"
        assert_select "li#class_table_tab a","Class Metric Table"
        assert_select "li#class_graph_tab a","Class Metric Graph"
        assert_select "li#func_table_tab a","Func Metric Table"
        assert_select "li#func_graph_tab a","Func Metric Graph"
      end
    end
    # tab is changed
      # file_table_tab
    xml_http_request :post, URL_METRIC_VIEW_TABLE + "&metric_type=file"
    assert_response :success
    assert_template "metric/_view_table"
    assert_select "div#1_file_analyze_tools"
      # file_graph_tab
    xml_http_request :post, URL_METRIC_VIEW_GRAPH + "&metric_type=file"
    assert_response :success
    assert_template "metric/_view_graph"
    assert_select "div#1_file_graph_metrics"
      # class_table_tab
    xml_http_request :post, URL_METRIC_VIEW_TABLE + "&metric_type=class"
    assert_response :success
    assert_template "metric/_view_table"
    assert_select "div#1_class_analyze_tools"
      # class_graph_tab
    xml_http_request :post, URL_METRIC_VIEW_GRAPH + "&metric_type=class"
    assert_response :success
    assert_template "metric/_view_graph"
    assert_select "div#1_class_graph_metrics"
      # func_table_tab
    xml_http_request :post, URL_METRIC_VIEW_TABLE + "&metric_type=func"
    assert_response :success
    assert_template "metric/_view_table"
    assert_select "div#1_func_analyze_tools"
      # func_graph_tab
    xml_http_request :post, URL_METRIC_VIEW_GRAPH + "&metric_type=func"
    assert_response :success
    assert_template "metric/_view_graph"
    assert_select "div#1_func_graph_metrics"
  end

  def test_table_view_page
    # Request to view HTML table
    login

    xml_http_request :post, URL_METRIC_VIEW_TABLE + "&metric_type=file"
    assert_response :success
    assert_select "div#1_file_analyze_tools"

    xml_http_request :post, URL_METRIC_VIEW_TABLE + "&metric_type=class"
    assert_response :success
    assert_select "div#1_class_analyze_tools"

    xml_http_request :post, URL_METRIC_VIEW_TABLE + "&metric_type=func"
    assert_response :success
    assert_select "div#1_func_analyze_tools"

    # file table
    metric_types = ["class","file","func"]
    metric_types.each do |metric_type|
      case metric_type
      when "file"
        default_metrics = ["STFNC","STM33","STTPP"]
      when "class"
        default_metrics = ["STCBO","STLCM","STMTH"]
      when "func"
        default_metrics = ["STCYC","STLIN","STMIF"]
      end
      xml_http_request :post, URL_METRIC_VIEW_TABLE + "&metric_type=#{metric_type}"
      assert_response :success
      # the screen of section "Select analysis tools"
      assert_select "div#1_#{metric_type}_analyze_tools" do
        assert_select "input[type = button][value = Check All]"
        assert_select "input[type = button][value = Uncheck All]"
        assert_select "input[type = checkbox][value = QAC][checked = checked]"
        assert_select "input[type = checkbox][value = QAC++][checked = checked]"
      end
      # the screen of section "Select metrics"
      assert_select "div#1_#{metric_type}_table_metrics" do
        assert_select "input[type = button][value = Check All]"
        assert_select "input[type = button][value = Uncheck All]"
        assert_select "input[type = button][value = Customize]"
        default_metrics.each do |metric|
          assert_select "input[type = checkbox][value = #{metric}][checked = checked]"
        end
      end
      # click "customize" button
      xml_http_request :post, URL_METRIC_CUSTOMIZE_WINDOW + "&metric_type=#{metric_type}" + "&display_type=table",
        :metrics => default_metrics
      assert_response :success
      assert_template "metric/_view_customize_window"
      # "Download CSV Format" button
      xml_http_request :post, URL_METRIC_VIEW_TABLE + "&metric_type=#{metric_type}"
      assert_response :success
      assert_select "form[method = post]" do
        assert_select "input[type = submit][value = Download CSV Format]"
      end
      post "/metric/download_csv_table/1/1?id=1" + "&metric_type=#{metric_type}"
      assert_response :success
      # html table
      analyze_tools = ["QAC","QAC++"]
      order_column = "File name"
      order_direction = "asc"
      page_index = 1
      metric_data = MetricCacheManager.get_metric_data(1,
                                                       metric_type)
      total_items, rows = metric_data.get_page(page_index,
                                               analyze_tools,
                                               default_metrics,
                                               order_column,
                                               order_direction)
      xml_http_request :post, URL_METRIC_GET_TABLE + "&metric_type=#{metric_type}",
        :analyze_tools => analyze_tools,:page_index => page_index,
        :metrics =>default_metrics,:order_column => order_column,
        :order_direction => order_direction
      assert_response :success
      if total_items == 0
        table_div = "1_#{metric_type}_HTML_table"
        assert_select_rjs :replace_html, table_div
      else
        assert_template "metric/_metric_table"
        assert_select "table[class = sortable]" do
          # header of table
          assert_select "thead" do
            assert_select "th a","File name"
            assert_select "th a","Item name"
            assert_select "th a","Analyze tool"
            default_metrics.each do |metric|
              assert_select "th a","#{metric}"
            end
          end
          # body of table
          assert_select "tbody" do
            assert_select "tr" , :count =>  total_items
            (1..total_items).each do |i|
              assert_select "tr:nth-child(#{i})" do
                rows[i-1].each do |item|
                  assert_select "td" , item.to_s
                end
              end
            end
          end
        end
      end
    end
  end

  def test_graph_view_page
    #  Request to view Graph of Metric
    login
    metric_types = ["class","file","func"]
    metric_types.each do |metric_type|
      case metric_type
      when "file"
        default_metric = "STFNC"
      when "class"
        default_metric = "STCBO"
      when "func"
        default_metric = "STCYC"
      end
      xml_http_request :post, URL_METRIC_VIEW_GRAPH + "&metric_type=#{metric_type}"
      assert_response :success
      assert_template "metric/_view_graph"
      # there are 2 sections
      assert_select "div#1_#{metric_type}_graph_metrics"
      assert_select "div#1_#{metric_type}_chart"
      # and 1 button
      assert_select "input[type = button][value = Customize]"
      xml_http_request :post, URL_METRIC_DRAW_GRAPH + "&metric_type=#{metric_type}","#{metric_type}_metric_name" => default_metric
      assert_response :success
    end
  end

  def test_metric_customize_page
    metrics = ["STFNC","STM33","STTPP"]
    update_metrics = ["STFNC","STM33"]
    metric_type = "file"
    login
    # TABLE
    xml_http_request :post, URL_METRIC_VIEW_TABLE + "&metric_type=#{metric_type}"
    assert_response :success
    assert_template "metric/_view_table"
    xml_http_request :post, URL_METRIC_CUSTOMIZE_WINDOW + "&metric_type=#{metric_type}" + "&display_type=table",
      :metrics => metrics
    assert_response :success
    assert_template "metric/_view_customize_window"
    # 2 button "Check All" & "Uncheck All"
    assert_select "input[type = button][value = Check All]"
    assert_select "input[type = button][value = Uncheck All]"
    # 2 buttons "OK" & "Cancel"
    assert_select "input[type = button][value = OK]"
    assert_select "input[type = button][value = Cancel][onclick = Windows.close('customize_window');]"
    metric_descriptions      = MetricDescription.full_list(metric_type)
    # list all metrics name & their description
    # The check box which can be chosen is attached to the left-hand side of each metric
    metric_descriptions.each do |metric_description|
      assert_select "input[type = checkbox][value = #{metric_description.name}]"
      assert_select "label",metric_description.name
      description = metric_description.e_description.rstrip
      assert_select "em", description
    end
    # The corresponding check boxes currently checked in “Select metrics” section are checked
    metrics.each do |metric|
      assert_select "input[type = checkbox][value = #{metric}][checked = checked]"
    end
    # "Ok" button is clicked
    xml_http_request :post, URL_UPDATE_METRIC_LIST + "&metric_type=#{metric_type}" + "&display_type=table",
      :metrics => update_metrics
    assert_response :success
    assert_template "metric/_metric_list"
    update_metrics.each do |metric|
      assert_select "input[type = checkbox][value = #{metric}][checked = checked]"
    end
    xml_http_request :post, URL_METRIC_GET_TABLE + "&metric_type=#{metric_type}",
      :analyze_tools => ["QAC","QAC++"],:page_index =>1,
      :metrics =>update_metrics,:order_column => "File name",
      :order_direction => "asc"
    assert_response :success
    assert_template "metric/_metric_table"

    # GRAPH
    xml_http_request :post, URL_METRIC_VIEW_GRAPH + "&metric_type=file"
    assert_response :success
    assert_template "metric/_view_graph"
     xml_http_request :post, URL_METRIC_CUSTOMIZE_WINDOW + "&metric_type=#{metric_type}" + "&display_type=graph",
      :metrics => metrics,:metric_name => metrics[1]
    assert_response :success
    assert_template "metric/_view_customize_window"
    # 2 button "Check All" & "Uncheck All"
    assert_select "input[type = button][value = Check All]"
    assert_select "input[type = button][value = Uncheck All]"
    # 2 buttons "OK" & "Cancel"
    assert_select "input[type = button][value = OK]"
    assert_select "input[type = button][value = Cancel][onclick = Windows.close('customize_window');]"
    metric_descriptions      = MetricDescription.full_list(metric_type)
    # list all metrics name & their description
    # The check box which can be chosen is attached to the left-hand side of each metric
    metric_descriptions.each do |metric_description|
      assert_select "input[type = checkbox][value = #{metric_description.name}]"
      assert_select "label",metric_description.name
      description = metric_description.e_description.rstrip
      assert_select "em", description
    end
    # The corresponding check boxes are checked
    metrics.each do |metric|
      assert_select "input[type = checkbox][value = #{metric}][checked = checked]"
    end
    # "Ok" button is clicked.
    xml_http_request :post, URL_UPDATE_METRIC_LIST + "&metric_type=#{metric_type}" + "&display_type=graph",
      :metrics => update_metrics, :metric_name => update_metrics[0]
    assert_response :success
    assert_template "metric/_metric_list"
    update_metrics.each do |metric|
      assert_select "input[type = radio][value = #{metric}]"
    end
  end
  
  def login
    get "/auth/login"
    assert_response :success
    post "/auth/login", :login => 'root', :password => 'root'
    assert_redirected_to :controller => "misc", :action => "index"
    get "/misc"
    assert_response :success
  end
end