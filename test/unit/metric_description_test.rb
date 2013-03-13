require File.dirname(__FILE__) + '/../test_helper'
require 'json'

$data = {
	
	"analyzed_tools"			=>	[["sample_c_cpp/sample_c/src/analyzeme.c", 
														"sample_c_cpp/sample_c/src/analyzeme.c", "QAC"], 
 														["sample_c_cpp/sample_cpp/Common/src/MemoryManagement.cpp", 
 														 "sample_c_cpp/sample_cpp/Common/src/MemoryManagement.cpp", "QAC++"]],
 		
 	"get_metric_result"		=>	[[["sample_c_cpp/sample_c/src/analyzeme.c", 
 														"sample_c_cpp/sample_c/src/analyzeme.c", "QAC"], 
 														["sample_c_cpp/sample_cpp/Common/src/MemoryManagement.cpp", 
 														"sample_c_cpp/sample_cpp/Common/src/MemoryManagement.cpp", "QAC++"]], [661, 248]],	
 														 
 	"data_table"					=>	[2, [["sample_c_cpp/sample_c/src/analyzeme.c", 
  										 			"sample_c_cpp/sample_c/src/analyzeme.c", "QAC", 661], 
  													["sample_c_cpp/sample_cpp/Common/src/MemoryManagement.cpp", 
  										 			"sample_c_cpp/sample_cpp/Common/src/MemoryManagement.cpp", "QAC++", 248]]],
  
  "data_row"						=>	["sample_c_cpp/sample_cpp/Common/src/MemoryManagement.cpp", 
  													"sample_c_cpp/sample_cpp/Common/src/MemoryManagement.cpp",
  													"QAC++","File",  nil, nil, nil, nil, 54, 41, 73, 697, nil,
  													nil, nil, nil, nil, nil, nil, nil, nil, nil, 248, 0, nil, 										
  													nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0.289, 4030, 3061, 885],
	
	"data_label"					=>	["0", "40", "80", "120", "160", "200", "240", "280", "320", "360", "400", "440", 
														"480","520","560", "600", "640", "680", "720", "760", "800","840","880", "920"],
						    						
	"metric_names" 				=>	["STBME", "STBMO", "STBMS", "STBUG", "STCCA", "STCCB", "STCCC", "STCDN", "STDEV", 
														"STDIF", "STECT", "STEFF", "STFCO", "STFNC", "STHAL", "STM20", "STM21", "STM22", 
				 										"STM28", "STM33", "STMOB", "STOPN", "STOPT", "STPRT", "STSCT", "STSHN", "STTDE", 
														"STTDO", "STTDS", "STTLN", "STTOT", "STTPP", "STVAR", "STVOL", "STZIP"]					    						  													
}


class MetricDescriptionTest < ActiveSupport::TestCase
  def test_000
    import_sql
  end
  
  # test item: MTF_UT_FM_01
  def test_MTF_UT_FM_01_initialize_metric_data
  	metric_data = MetricData.new(1, 'File')

    #test contain metric's information
    assert_equal metric_data.task_id,1
    assert_equal metric_data.metric_type,"File"
    assert metric_data.metric_names.include?"STSCT"
    assert metric_data.data_types.include?"Integer"
    assert_not_nil metric_data.data
 		assert_equal($data["analyzed_tools"], metric_data.analyzed_items)   
		
		#test invalid initialize 
		invalid_metric = MetricData.new(1,'invalid')
		assert_equal([], invalid_metric.metric_names)	
		
		#test get metric values and correspoding anaylyzed items
		test_get_metric = metric_data.get_metric("STTPP")
		assert_equal($data["get_metric_result"], test_get_metric)
		# test with invalid param
    assert_raise RuntimeError, /Cannot find ABCD in the metric data/ do
      metric_data.get_metric('ABCD')
    end
    
  end
  
  # test item: MTF_UT_FM_02
  def test_MTF_UT_FM_02_build_table
  	metric_data = MetricData.new(1, 'File')
  	analyze_tools = ["QAC", "QAC++"]
 
  	#test filter by analyze tools
  	filtered = metric_data.filter_by_analyze_tools(analyze_tools)
  	assert_equal([0, 1], filtered)
  	
  	#test sort filter analyzed items
  	sorted = metric_data.sort("file name", "asc")
  	assert_equal([0, 1], sorted)
  	
  	#test get page to build table
  	page = metric_data.get_page(1, analyze_tools, "STTPP", "file name", "asc")
  	assert_equal($data["data_table"], page)
 
  end
  
  # test item: MTF_UT_FM_03
  def test_MTF_UT_FM_03_get_cache_data 
    # Store metric data on cache then get this data from cache
    # Data get from DB
    metric_data= MetricData.new(1,'Func')
    # Data get from cache
    metric_cache_data= MetricCacheManager.get_metric_data(1,'Func')

    # Compare with each other
    assert_equal metric_data.analyzed_items,metric_cache_data.analyzed_items
    assert_equal metric_data.data,metric_cache_data.data
    assert_equal metric_data.data_types,metric_cache_data.data_types
    assert_equal metric_data.metric_names,metric_cache_data.metric_names
    assert_equal metric_data.metric_type,metric_cache_data.metric_type
    assert_equal metric_data.task_id,metric_cache_data.task_id
  end
  
  # test item: MTF_UT_FM_04
  def test_MTF_UT_FM_04_get_csv_data
		# get data to create CSV file 
    csv_data= MetricData.new(1,'File')
   
    row_csv=csv_data.get_csv_row(1)
    expected_row= $data["data_row"]
    assert_equal expected_row,row_csv
    
    # test with invalid index of row
    assert_raise TypeError, /can't convert String into Integer/ do
      csv_data.get_csv_row('a')
    end
    assert_raise RuntimeError, /Out of range/ do
      csv_data.get_csv_row(1000)
    end
  end
  
  #test item: MTF_UT_FM_05
  def test_MTF_UT_FM_05_get_graph_data
    #get data to draw graph
    metric_data = MetricCacheManager.get_metric_data(1, 'File')
    metric_analyzed_items, metric_values = metric_data.get_metric('STCCC')
    
    # scale data
    x_min, x_max, x_step, x_labels, left_values, right_values = MetricGraphLib.scale_data(metric_values)
    assert_equal($data["data_label"], x_labels)
    assert_equal(1,x_step)
    assert_equal(0, x_min)
    assert_equal(23,x_max)
    assert_equal([0],left_values)
    assert_equal([22.125], right_values)
    # test with invalid param
    assert_raise RuntimeError, /Error data/ do
      MetricGraphLib.scale_data('')
    end

    # test getting graph data
    graph_data= MetricGraphLib.render_graph(1, 'File', 'STCCC')
    assert_equal(String, graph_data.class)
    graph_data_hash=JSON.parse(graph_data)
    y_label_string= graph_data_hash['y_legend']
    y_label_hash=JSON.parse(y_label_string)
    assert_equal('Metric items', y_label_hash['text'])
    x_label_string= graph_data_hash['x_legend']
    x_label_hash=JSON.parse(x_label_string)
    assert_equal('Value', x_label_hash['text'])
    title_string= graph_data_hash['title']
    title_hash=JSON.parse(title_string)
    assert_equal('STCCC', title_hash['text'])
    
    #test return HTML string
    flash_chart = MetricGraphLib.html_open_flash_chart_object("1_file_horizontal_chart", 110, 900, "/open-flash-chart.swf")
    assert_equal(String, flash_chart.class)
    
  end
  
	# test item: MTF_UT_FM_06
	def test_MTF_UT_FM_06_get_metric_descriptions 
		#test default_values function	
		#get default metric desscription
		default_array = [] 
		default_metrics = MetricDescription.default_values('File')
		default_metrics.each do |default_metric|
			default_array << default_metric.name
		end	
		
		#test array return default metric description
		assert_equal(["STFNC", "STM33", "STTPP"], default_array)
		
		#test full_list function
		#get full metric description
		metric_array = []
		all_metrics = MetricDescription.full_list('file')
		all_metrics.each do |metric|
			metric_array << metric.name
		end
		
		#test array return full metric description
		assert_equal($data["metric_names"], metric_array)
		
		#test metric type is invalid, return nil array
		#default_values function
		invalid_metric_type = MetricDescription.default_values('invalid')
		assert_equal([], invalid_metric_type)
		#full_list function
		invalid_metric_type2 = MetricDescription.full_list('invalid')
		assert_equal([],invalid_metric_type2)
	end
	
end
