require File.dirname(__FILE__) + "/test_v_setup" unless defined? TestVSetup
require "test/unit"
class TestVisualMetricFunction < Test::Unit::TestCase
  include TestVMFSetup

  #########################################################
  #		Access right function(1-6)                          #
  #########################################################
  
  #- User hasn't logged in
  #- Request metric page
  #
#  def test_001
#    printf "\n+ Test 001"
#    open "/metric/index/1/1?id=1"
#    wait_for_page_to_load PAGE_LOAD_TIME
#    assert @selenium.is_text_present($page_titles["auth_login"])
#  end
#  #- User has logged in
#  #- Request metric page with invalid PU
#  #
#  def test_002
#    #test_000
#    printf "\n+ Test 002"
#    ## open_metric_page(pu_id,pj_id,task_id). invalid pu_id =10
#    open_metric_page(10,1,1)
#    assert @selenium.is_text_present($page_titles["index_page"])
#    assert @selenium.is_text_present("PU (id=10) #{_("not found")}")
#    logout
#  end
#  #- User has logged in
#  #- Request metric page with invalid PJ
#  #
#  def test_003
#    #test_000
#    printf "\n+ Test 003"
#    ## open_metric_page(pu_id,pj_id,task_id). invalid pj_id =10
#    open_metric_page(1,10,1)
#    assert @selenium.is_text_present($page_titles["index_page"])
#    assert @selenium.is_text_present("PJ (id=10) #{_("not found")}")
#    logout
#  end
#  #- User has logged in
#  #- Request metric page with invalid Task
#  #
#  def test_004
#    #test_000
#    printf "\n+ Test 004"
#    ## open_metric_page(pu_id,pj_id,task_id). invalid task_id =10
#    open_metric_page(1,1,10)
#    assert @selenium.is_text_present($page_titles["index_page"])
#    assert @selenium.is_text_present("#{_("Task (id=")}10) #{_("not found")}")
#    logout
#  end
#  #- User has logged in
#  #- Request metric page with uncomplete Task
#  #
#  def test_005
#    #test_000
#    printf "\n+ Test 005"
#    tasks = Task.find(:all)
#    tasks.each do |task|
#      ## On Execute Cancel task
#      task.task_state_id = UNCOMPLETE_ID
#      task.save
#    end
#    open_metric_page
#    sleep WAIT_TIME
#    begin
#      ## return to misc page
#      assert @selenium.is_text_present($page_titles["index_page"])
#      ## notice of no_metric_page
#      assert @selenium.is_text_present($messages["no_metric_page"])
#    rescue Test::Unit::AssertionFailedError
#      @verification_errors << $!
#    end
#    tasks.each do |task|
#      task.task_state_id= COMPLETE_ID
#      task.save
#    end
#    logout
#  end
#  # - User has logged in
#  # - Request metric page
#  # - Metric table in DB is missing
#  # - This test has removed
#  #  def test_006
#  #    test_000
#  #    printf "\n+ Test 006"
#  #    metrics = Metric.find(:all,
#  #      :conditions => {:subtask_id=> OLD_ID})
#  #    metrics.each do |metric|
#  #      metric.analyze_tool_id = NEW_ID
#  #      metric.subtask_id=NEW_ID
#  #      metric.save
#  #    end
#  #    metric_descriptions=MetricDescription.find(:all,
#  #      :conditions => {:analyze_tool_id => OLD_ID})
#  #    metric_descriptions.each do |metric_description|
#  #      metric_description.analyze_tool_id=NEW_ID
#  #      metric_description.save
#  #    end
#  #    sleep WAIT_TIME
#  #    open_metric_page
#  #    #with out metrics db, this page won't run.
#  #    #This test case should be deleted
#  #    assert true
#  #    logout
#  #  end
#  #########################################################################
#  #		Link to Metric Page view right function	(7-9)		  #
#  #########################################################################
#  # provide the analysis task detail page.
#  # check exits of "Metrics" link
#  #
#  def test_007
#    #test_000
#    printf "\n+ Test 007"
#    open_analysis_task_detail_page
#    assert_equal "Metrics", @selenium.get_text("link=Metrics")
#    logout
#  end
#  # provide the analysis task detail page.
#  # click Metrics link => redirect to Metric Page (File Metric Table View is default)
#  # metric data is available
#  #
#  def test_008
#    #test_000
#    printf "\n+ Test 008"
#    open_analysis_task_detail_page
#    click "link=Metrics"
#    sleep WAIT_TIME
#    assert_equal $page_title["metric_view_page_title"], @selenium.get_title
#    assert_equal $link_texts["metric_tab"][0],@selenium.get_text($xpath["metric"]["chosen_tab"])
#    logout
#  end
#  # provide the analysis task detail page.
#  # click Metrics link => redirect to Metric Page (File Metric Table View is default)
#  # metric data is NOT available
#  # this test has removed
#  #  def test_009
#  #    test_000
#  #    printf "\n+ Test 009"
#  #    metrics = Metric.find(:all,
#  #      :conditions => {:subtask_id=> OLD_ID})
#  #    metrics.each do |metric|
#  #      metric.analyze_tool_id = NEW_ID
#  #      metric.subtask_id= NEW_ID
#  #      metric.save
#  #    end
#  #    metric_descriptions=MetricDescription.find(:all,
#  #      :conditions => {:analyze_tool_id => OLD_ID})
#  #    metric_descriptions.each do |metric_description|
#  #      metric_description.analyze_tool_id=NEW_ID
#  #      metric_description.save
#  #    end
#  #    open_analysis_task_detail_page
#  #    click "link=Metrics"wait_for_element_present
#  #    sleep WAIT_TIME
#  #    #with out metrics db, this page won't run.
#  #    #This test case should be deleted
#  #    assert true
#  #    logout
#  #  end
#  #########################################################################
#  #             Display metric page	(10-14)                           #
#  #########################################################################
#  # test display of metric page
#  #
#  def test_010
#    #test_000
#    printf "\n+ Test 010"
#    open_metric_page
#    assert_equal $page_title["metric_view_page_title"], @selenium.get_title
#    logout
#  end
#  # open metric page, check tab
#  #
#  def test_011
#    #test_000
#    printf "\n+ Test 011"
#    open_metric_page
#    (0..5).each do |id|
#      assert_equal $link_texts["metric_tab"][id], @selenium.get_text($xpath["metric"]["metric_tab"][id])
#    end
#    logout
#  end
#  # open metric page, check default chosen
#  #
#  def test_012
#    #test_000
#    printf "\n+ Test 012"
#    open_metric_page
#    assert_equal $link_texts["metric_tab"][0],@selenium.get_text($xpath["metric"]["chosen_tab"])
#    logout
#  end
#  # click another title of the task
#  # content change
#  #
#  def test_013
#    #test_000
#    printf "\n+ Test 013"
#    open_metric_page
#    tab_contents = Array.new
#    ## get contents of each tab to tab_contents[]
#    (0..5).each do |tab_id|
#      tab_index=$link_texts["metric_tab"][tab_id]
#      ## open each other tab
#      click "link=#{tab_index}"
#      sleep WAIT_TIME
#      ## get contents of each tab
#      tab_contents[tab_id]=@selenium.get_text($xpath["metric"]["metric_tab"][tab_id])
#    end
#    ## compare each content with different value!
#    (0..5).each do |i|
#      (0..5).each do |j|
#        if(i!=j)
#          assert_not_equal(tab_contents[i],tab_contents[j])
#        end
#      end
#    end
#    logout
#  end
#  # click another title of the task
#  # color change
#  #
#  def test_014
#    #test_000
#    printf "\n+ Test 014"
#    open_metric_page
#    ## each tab has chosen has class = pane-selected => have background=#FFFFFF
#    assert_equal $link_texts["metric_tab"][0],@selenium.get_text($xpath["metric"]["chosen_tab"])
#    (1..5).each do |temp_index|
#      ## each tab has not chosen has class = pane-unselected => have background=#F0F0F0
#      assert_equal $link_texts["metric_tab"][temp_index],@selenium.get_text($xpath["metric"]["metric_tab"][temp_index])
#    end
#  end
#  ###################################################################
#  #											Test FILE TABLE TAB													#
#  ###################################################################
#  def test_015
#	printf "\n+ Test 015"
#	#- the display of "class metric table" tab
#	#- Return Metric page with 3 sections       
#	#	+ section “Select analysis tools”        
#	#	+ section “Select metrics”        
#	#	+ section “Metric HTML table” 
#	login_metric
#    #Select analyze tools
#    wait_for_text_present(_("Select analyze tools"))
#    #Select metric
#		wait_for_text_present(_("Select metrics"))	
#		#Metric HTML table
#		wait_for_text_present(_("Metric HTML table"))
#	end
#	
#	def test_016
#	printf "\n+ Test 016"
#	#- the screen of section "Select analysis tools"       
#	#	+ there are 2 button: "Check All" & "Uncheck All"       
#	#	+ By default, 2 check boxes: “QAC” & “QAC++” are checked
#	login_metric
#    #Select analyze tools
#    wait_for_text_present(_("Select analyze tools"))
#			#button
#			assert_equal "Check All", get_value($file_table_tab["analyze_tool_check_all"])
#			assert_equal "Uncheck All", get_value($file_table_tab["analyze_tool_uncheck_all"])
#			#radio button checked
#			assert is_checked("1_file_QAC")
#			assert is_checked("1_file_QAC++")
#	end
#	
#	def test_017
#	printf "\n+ Test 017"
#	#- the screen of section "Select metrics"       
#	#	+ there are 3 buttons: "Check All", "Uncheck All" & "Customize"       
#	#	+ By default, some check boxes are displayed and checked
#	login_metric
#	#Select metric
#		wait_for_text_present(_("Select metrics"))	
#			#button & customize button
#			assert_equal "Check All", get_value($file_table_tab["select_metrics_check_all"])
#			assert_equal "Uncheck All", get_value($file_table_tab["select_metrics_uncheck_all"])
#			assert_equal "Customize", get_value($file_table_tab["customize"])
#			#radio button checked
#			assert is_checked("1_file_STFNC")
#			assert is_checked("1_file_STM33")
#			assert is_checked("1_file_STTPP")
#	end
#	
#	def test_018
#	printf "\n+ Test 018"
#	#- the screen of section "Metric HTML table"       
#	#	+ there is 1 buttons: "Download CSV format"       
#	#	+ Show  HTML table
#	login_metric 
#	#Metric HTML table
#		wait_for_text_present(_("Metric HTML table"))
#			#download CSV format button	
#			assert_equal "Download CSV Format", get_value($file_table_tab["download_csv"])	
#			#HTML table
#			wait_for_element_text($file_table_tab["file_name"],"File name")
#			wait_for_element_text($file_table_tab["item_name"],"Item name")
#			wait_for_element_text($file_table_tab["analyze_tool"], "Analyze tool")
#	end

#	def test_019
#	printf "\n+ Test 019"
#	#- Click "Check All" button in "Select analysis tools" section
#	#- Check boxes: "QAC" & "QAC++" are checked 
#	#- HTML table change dynamically
#	login_metric
#	#click Check All button in Analyze tool
#		wait_for_element_present($file_table_tab["analyze_tool_check_all"])
#		click $file_table_tab["analyze_tool_check_all"]
#			assert is_checked("1_file_QAC")
#			assert is_checked("1_file_QAC++")
#			wait_for_element_text($file_table_tab["file_name"],_("File name"))
#			wait_for_element_text($file_table_tab["item_name"],_("Item name"))
#			wait_for_element_text($file_table_tab["analyze_tool"], _("Analyze tool"))
#	end
#  
#  def test_020
#  printf "\n+ Test 020"
#  #- Click "Uncheck All" button in "Select metrics" section
#	#- Check boxes: "QAC" & "QAC++" are unchecked 
#	#- HTML table change dynamically: It will disappear
#	login_metric
#	#click Uncheck All button in Analyze tool
#  	wait_for_element_present($file_table_tab["analyze_tool_uncheck_all"])
#  	click $file_table_tab["analyze_tool_uncheck_all"]
#  	sleep WAIT_TIME
#			assert !is_checked("1_file_QAC")
#			assert !is_checked("1_file_QAC++")
#			sleep WAIT_TIME
#			wait_for_text_present(_(_("According to your options, there is no information to display")))
#  end
  
#  def test_021
#  printf "\n+ Test 021"
#  #- Select analysis tool by checking check boxes
#	#- HTML table change dynamically according to selected analysis tool
#	login_metric
#	#Uncheck QAC. HTML page only display QAC++ 
#	wait_for_element_present($file_table_tab["QAC_radio"])
#  	click $file_table_tab["QAC_radio"]
#			assert !is_checked("1_file_QAC")
#			wait_for_element_present($file_table_tab["analyze_tool"])
#			sleep WAIT_TIME
#			assert_equal "QAC++", get_text($file_table_tab["QAC_analyze_tool"])	
#  end
#  
#  def test_022
#  printf "\n+ Test 022"
#  #- Don't select any analysis tool 
#	#- HTML table will disappear 
#	#- Pagination isn't displayed
#	login_metric
#	wait_for_element_present($file_table_tab["QAC_radio"])
#	wait_for_element_present($file_table_tab["QAC++_radio"])
#	#Uncheck analysis tools.
#		click $file_table_tab["QAC_radio"]
#		assert !is_checked("1_file_QAC")
#  	click $file_table_tab["QAC++_radio"]	
#  	assert !is_checked("1_file_QAC++")
#  #- Pagination isn't displayed
#  wait_for_element_not_present($file_table_tab["page_2"])	
#  #HTML table disappear	
# 		sleep WAIT_TIME
#		wait_for_text_present(_(_("According to your options, there is no information to display")))
#  end
#  
#  def test_023
#  printf "\n+ Test 023"
#  #- Click "Check All" button in "Select metrics" section
#	#- All check boxes available in “Select metrics” section are checked 
#	#- HTML table change dynamically
#	login_metric
#	#click Check All button in Select metrics
#		wait_for_element_present($file_table_tab["select_metrics_check_all"])
#		click $file_table_tab["select_metrics_check_all"]
#			assert is_checked("1_file_STFNC")
#			assert is_checked("1_file_STM33")
#			assert is_checked("1_file_STTPP")
#			wait_for_element_text($file_table_tab["STFNC"],"STFNC")
#			wait_for_element_text($file_table_tab["STM33"],"STM33")
#			wait_for_element_text($file_table_tab["STTPP"],"STTPP")
#  end

#	def test_024
#	printf "\n+ Test 024"
#	#- Click "Uncheck All" button in "Select metrics" section
#	#- All check boxes available in “Select metrics” section are unchecked 
#	#- HTML table change dynamically
#	login_metric	
#	#click Uncheck All button in Select metrics
#		wait_for_element_present($file_table_tab["select_metrics_uncheck_all"])
#		click $file_table_tab["select_metrics_uncheck_all"]
#		sleep WAIT_TIME
#			assert !is_checked("1_file_STFNC")
#			assert !is_checked("1_file_STM33")
#			assert !is_checked("1_file_STTPP")
#			sleep WAIT_TIME
#			wait_for_text_present(_(_("According to your options, there is no information to display")))
#	end

#	def test_025
#	printf "\n+ Test 025"
#	#- Select metric names by checking check boxes 
#	#- HTML table change dynamically according to selected metrics
#	login_metric	
#	#Uncheck STFNC radio button
#		wait_for_element_present($file_table_tab["STFNC"])
#		click $file_table_tab["STFNC_radio"]	
#	#Check STFNC radio button
#		click $file_table_tab["STFNC_radio"]	
#		assert is_checked("1_file_STFNC")
#	#HTML table display STFNC	normally
#	wait_for_element_text($file_table_tab["STFNC"],"STFNC")
#	end

#	def test_026
#	printf "\n+ Test 026"
#	#- Don't select any  metric name 
#	#- HTML table will disappear 
#	#- Pagination isn't displayed
#	login_metric
#	#Uncheck all metric
#	wait_for_element_present($file_table_tab["STFNC"])
#		click $file_table_tab["STFNC_radio"]	
#		click $file_table_tab["STM33_radio"]	
#		click $file_table_tab["STTPP_radio"]
#		sleep WAIT_TIME
#	# HTML table disappear
#		assert !is_checked("1_file_STFNC")
#		assert !is_checked("1_file_STM33")
#		assert !is_checked("1_file_STTPP")
#		sleep WAIT_TIME
#		wait_for_text_present(_(_("According to your options, there is no information to display")))
#	end
#	
#	def test_027
#	printf "\n+ Test 027"
#	#- Click "Customize" button
#	#- a sub window "Metric Customize Window" will be displayed 
#	login_metric
#  #click Customize button
#  wait_for_element_present($file_table_tab["customize"])
#  	click $file_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#	end
#    
#  def test_028
#  printf "\n+ Test 028"
#  #- a sub window "Metric Customize Window" is displayed 
#	#- 2 buttons: "Check All" & "Uncheck All" in the top 
#	#- 2 buttons: “Ok” & “Cancel” in the bottom 
#	#- list all metrics & their meaning
#	login_metric
#  #click Customize button
#  wait_for_element_present($file_table_tab["customize"])
#  	click $file_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#  	wait_for_element_present($file_table_tab["customize_check_all"])
#		assert_equal "Check All", get_value($file_table_tab["customize_check_all"])
#		wait_for_element_present($file_table_tab["customize_uncheck_all"])
#		assert_equal "Uncheck All", get_value($file_table_tab["customize_uncheck_all"])
#		wait_for_element_present($file_table_tab["customize_ok"])
#		assert_equal "OK", get_value($file_table_tab["customize_ok"])
#		wait_for_element_present($file_table_tab["customize_cancel"])
#		assert_equal _("Cancel"), get_value($file_table_tab["customize_cancel"])
#  end
#    
#  def test_029
#  printf "\n+ Test 029"
#  #The check box which can be chosen is attached to the left-hand side of each metric
#  login_metric
#	#click Customize button
#  wait_for_element_present($file_table_tab["customize"])
#  	click $file_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#  #Checkbox displayed
#		wait_for_element_present($file_table_tab["customize_count"])
#		metrics_count = get_xpath_count($file_table_tab["customize_count"])
#    1.upto(metrics_count) do |i|
#    	wait_for_element_present($file_table_tab["customize_count"] + "[" + i.to_s + "]" + "/input")
#  	end	
#  end
#  
#  def test_030
#  printf "\n+ Test 030"
#  #- The "Check All" button on a subwindow is clicked.
#	#- All check boxes are checked
#	login_metric
#	#click Customize button
#	wait_for_element_present($file_table_tab["customize"])
#	click $file_table_tab["customize"]
#		wait_for_element_present("customize_window_top")
#		wait_for_element_present($file_table_tab["customize_check_all"])
#		#click Check All button
#		click $file_table_tab["customize_check_all"]
#		checker_count = get_xpath_count($file_table_tab["customize_count"])
#    1.upto(checker_count) do |i|
#    	assert is_checked($file_table_tab["customize_count"] + "[" + i.to_s + "]" + "/input")
#    end
#  end
#  
#  def test_031
#  printf "\n+ Test 031"
#  #- The "Uncheck All" button on a subwindow is clicked
#	#- All check boxes are uncheked
#  login_metric
#  	#click Customize button
#  	wait_for_element_present($file_table_tab["customize"])
#  	click $file_table_tab["customize"]
#		wait_for_element_present("customize_window_top")
#		wait_for_element_present($file_table_tab["customize_uncheck_all"])	
#		#click Uncheck All button
#      click $file_table_tab["customize_uncheck_all"]
#      checker_count = get_xpath_count($file_table_tab["customize_count"])
#      1.upto(checker_count) do |i|
#      	assert !is_checked($file_table_tab["customize_count"] + "[" + i.to_s + "]" + "/input")
#      end
#  end
#    
#  def test_032
#  printf "\n+ Test 032"
#  #- Some metrics are checked, and "Ok" button is clicked.
#	#- Corresponding check boxes are substituted for "Select metrics" section & they are checked 
#	#- HTML table change dynamically
#	login_metric
#  	#click Customize button
#  	wait_for_element_present($file_table_tab["customize"])
#  	click $file_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#  	wait_for_element_present($file_table_tab["customize_ok"])
#  	#check STBME
#			wait_for_element_present($file_table_tab["new_STBME_radio"])
#		  click $file_table_tab["new_STBME_radio"]
#		  assert is_checked($file_table_tab["new_STBME_radio"])
#  	#Click OK button  
#      click $file_table_tab["customize_ok"]
#	    wait_for_element_present($file_table_tab["STBME_radio"])
#	    sleep WAIT_TIME
#	    assert is_checked("1_file_STBME")
#	    wait_for_element_present($file_table_tab["STBME"])
#  end  
#  
#  def test_033
#  printf "\n+ Test 033"
#  #- "Customize" button is again clicked following the above-mentioned operation, and a subwindow is displayed.
#	#- The corresponding check boxes currently checked in “Select metrics” section are checked
#	login_metric
#  	#click Customize button
#  	wait_for_element_present($file_table_tab["customize"])
#  	click $file_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#  	wait_for_element_present($file_table_tab["customize_ok"])
#  	#check STBME
#			wait_for_element_present($file_table_tab["new_STBME_radio"])
#		  click $file_table_tab["new_STBME_radio"]
#  	#Click OK button  
#      click $file_table_tab["customize_ok"]
#	    wait_for_element_present($file_table_tab["STBME_radio"])
#	  #click Customize button
#  	wait_for_text_present(_("Select metrics"))
#  	click $file_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#  	#check STBME
#			wait_for_element_present($file_table_tab["new_STBME_radio"])
#			assert is_checked($file_table_tab["new_STBME_radio"])
#  end
#   
#  def test_034
#  printf "\n+ Test 034"
#  #- Do some operations(such as: check some check boxes), but finally click "Cancel" button
#	#- Nothing change in parent page(metric page)
#	login_metric
#  	#click Customize button
#  	wait_for_element_present($file_table_tab["customize"])
#  	click $file_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#  	wait_for_element_present($file_table_tab["customize_ok"])
#  	#check STBME
#			wait_for_element_present($file_table_tab["new_STBME_radio"])
#		  click $file_table_tab["new_STBME_radio"]
#  	#Click OK button  
#      click $file_table_tab["customize_ok"]
#	    wait_for_element_present($file_table_tab["STBME_radio"])
#	  #click Customize button again
#  	wait_for_element_present($file_table_tab["customize"])
#  	click $file_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#  	#check STBME
#			wait_for_element_present($file_table_tab["new_STBME_radio"])
#		  assert is_checked($file_table_tab["new_STBME_radio"])
#		  click $file_table_tab["new_STBME_radio"]
#  	#Click Cancel button  
#      click $file_table_tab["customize_cancel"]
#	    wait_for_element_present($file_table_tab["STBME_radio"])
#			assert is_checked($file_table_tab["STBME_radio"])
#  end 
#  
#  def test_035
#  printf "\n+ Test 035"
#  #- HTML table display
#	#- Header of table is file_name, item_name, analysis_tool_type, followed by metric name 
#	#- Each row of table represents one item(file, function or class) in metric list
#	login_metric
#  	wait_for_text_present(_("Metric HTML table"))
#   	#HTML table display
#  	wait_for_element_present($file_table_tab["file_name"])
#  	wait_for_element_present($file_table_tab["item_name"])
#  	wait_for_element_present($file_table_tab["analyze_tool"])
#  	wait_for_element_present($file_table_tab["STFNC"])
#  	wait_for_element_present($file_table_tab["STM33"])
#  	wait_for_element_present($file_table_tab["STTPP"])
#  	#HTML row
#  	wait_for_element_present($file_table_tab["file_name_row_1"])
#  end  
#  
#  def test_036
#  printf "\n+ Test 036"
#  #- HTML table display
#	#- Values inside metric are the same with values from DB. If analysis tool has no value for that metric, it shall set to “”
#	login_metric
#  	wait_for_text_present(_("Metric HTML table"))
#   	wait_for_element_present($file_table_tab["file_name_row_1"])
#  #Valid value
#  	metric_data = MetricData.new(1, "file")
#  	metric_value = metric_data.get_metric("STFNC")
#  	assert_equal get_text($file_table_tab["file_name_row_1_value"]).to_i, metric_value[1].to_i
#  	assert_equal get_text($file_table_tab["file_name_row_2_value"]), metric_value[1].to_s 	
#  end
#  
#  def test_037
#  printf "\n+ Test 037"
#  #- Dummy data is very large
#	#- Show HTML table with extra conditions below 	+ Pagination is displayed
#	login_metric
#  	wait_for_text_present(_("Metric HTML Table"))
#  	#Paginating
#  	wait_for_element_text($file_table_tab["page_2"], "2")
#  end
#  
#  def test_038
#  printf "\n+ Test 038"
#  #- Modify data in DB
#	#- Corresponding data in table change according to data in DB  
#	#- Size of corresponding column in table change to fit with this changed data 
#	login_metric
#	#Data modified from 91 to 91000
#	wait_for_element_present($file_table_tab["data_change"])
#	assert_equal "91000", get_text($file_table_tab["data_change"])
#  end
#  
#  def test_039
#  printf "\n+ Test 039"
#  #- Select one analysis tool 
#  #- Select metric names which don't belong to selected tool
#	#- Default value of these metric names is "" in HTML table
#	login_metric
#  #Uncheck QAC
#  wait_for_element_present($file_table_tab["QAC_radio"])
#  click  $file_table_tab["QAC_radio"]	
#  #Assert value in STFNC
#		wait_for_element_present($file_table_tab["file_name_row_2_value"])  
#		assert_equal 0, get_text($file_table_tab["file_name_row_2_value"]).to_i
#  end
#  
#  def test_040
#  printf "\n+ Test 040"
#  #- HTML table
#	#- By default, column “File Name” is used to provide the initial  descending sort 
#	#- This column is highlighted
#	login_metric
#  wait_for_element_present($file_table_tab["file_name"])
#	#default File name sort asc
#  	assert_equal "sortasc", get_attribute($file_table_tab["file_name"], "class")
#  end
#  
#  def test_041
#  printf "\n+ Test 041"
#  #- Click at header of each column
#	#- All items in this column will be re-arranged in descending order 
#	login_metric
#  	wait_for_text_present(_("Metric HTML table"))
#  #click header of STFNC column
#  wait_for_element_present($file_table_tab["STTPP"])
#		click	$file_table_tab["STTPP"] + "/a"
#		sleep WAIT_TIME
#		assert_equal "sortdesc", 	get_attribute($file_table_tab["STTPP"], "class")
#  end
#  
#  def test_042
#  printf "\n+ Test 042"
#  #- Click at header of above column again
#	#- All items in this column will be re-arranged in ascending order 
#	login_metric
#  	wait_for_text_present(_("Metric HTML table"))
#  #click header of STFNC column
#  wait_for_element_present($file_table_tab["STTPP"])
#		click	$file_table_tab["STTPP"] + "/a"
#		sleep WAIT_TIME
#		assert_equal "sortdesc", 	get_attribute($file_table_tab["STTPP"], "class")
#		click	$file_table_tab["STTPP"] + "/a"
#		sleep WAIT_TIME
#		assert_equal "sortasc", 	get_attribute($file_table_tab["STTPP"], "class")
#  end
#  
#  def test_043
#  printf "\n+ Test 043"
#  #- Remove the current sorting column from HTML table
#	#- By default, column “File Name” is used to provide the initial  descending sort 
#	login_metric
#  	wait_for_text_present(_("Metric HTML table"))
#  #click header of STFNC column
#  wait_for_element_present($file_table_tab["STTPP"])
#		click	$file_table_tab["STTPP"] + "/a"
#		sleep WAIT_TIME
#		assert_equal "sortdesc", 	get_attribute($file_table_tab["STTPP"], "class")
#	#uncheck STFNC metric
#	click 	$file_table_tab["STTPP_radio"]
#	wait_for_element_present($file_table_tab["file_name"])
#	#default File name sort asc
#  	assert_equal "sortasc", get_attribute($file_table_tab["file_name"], "class")
#	
#  end
#  
#  def test_044
#  printf "\n+ Test 044"
#  #-Click "CSV Down Load" button
#	#- Download the content of metric's table in CSV format
#	#- File is downloaded in CSV format
#	login_metric
#	#click download button
#	wait_for_element_present($file_table_tab["download_csv"])
#	click $file_table_tab["download_csv"]
#	sleep WAIT_TIME
#  end
#  
#  def test_045
#  printf "\n+ Test 045"
#  #-Click "CSV Down Load" button
#	#- File is downloaded in CSV format	
#	login_metric
#	#click download button
#	wait_for_element_present($file_table_tab["download_csv"])
#	click $file_table_tab["download_csv"]
#	sleep WAIT_TIME
#	printf "-	Test Failed! Selenium does not support to assert download of file"
#	assert false
#  end
#  
#  #########################################################################
#  #		File Metric Graph - Tab Display (46-49)                             #
#  #########################################################################
#  # display of file metric graph tab
#  #
#  def test_046
#    #test_000
#    printf "\n+ Test 046"
#    open_metric_tab($link_texts["metric_tab"][1])
#    assert_equal _("Select metrics"),@selenium.get_text($xpath["metric"]["metric_pane_content"]+"/h3[1]")
#    assert_equal _("Graph"),@selenium.get_text($xpath["metric"]["metric_pane_content"]+"/h3[2]")
#    logout
#  end
#  # display of file metric graph tab: select metric
#  #
#  def test_047
#    #test_000
#    printf "\n+ Test 047"
#    open_metric_tab($link_texts["metric_tab"][1])
#    wait_for_element_present($xpath["metric"]["customize_button"])
#    logout
#  end
#  # display of file metric graph tab: graph of metric
#  def test_048
#    #test_000
#    printf "\n+ Test 048"
#    open_metric_tab($link_texts["metric_tab"][1])
#    wait_for_element_present($xpath["metric"]["redraw_graph_button"])
#    logout
#  end
#  # click on customize button, a subwindow display
#  def test_049
#    #test_000
#    printf "\n+ Test 049"
#    open_metric_customize_subwindow($link_texts["metric_tab"][1])
#    wait_for_element_present("Customize metrics")
#    logout
#  end
#  ##########################################################################
#  ##		File Metric Graph -  Metric Customize Window (50-57)       #
#  ##########################################################################
#  # open subwindow Metric Customize Window
#  # check view
#  #
#  def test_050
#    #test_000
#    printf "\n+ Test 050"
#    open_metric_customize_subwindow($link_texts["metric_tab"][1])
#    assert(is_element_present($xpath["metric"]["check_all_button"]))
#    assert(is_element_present($xpath["metric"]["uncheck_all_button"]))
#    assert(is_element_present($xpath["metric"]["ok_button"]))
#    assert(is_element_present($xpath["metric"]["cancel_button"]))
#    total_checks=get_xpath_count($xpath["metric"]["sub_window_list"])
#    (1..total_checks).each do |check_index|
#      check_item_metric= $xpath["metric"]["sub_window_list"]+ "[#{check_index}]"+"/label"
#      check_item_content= $xpath["metric"]["sub_window_list"]+ "[#{check_index}]"+"/em"
#      assert_equal true,is_element_present(check_item_metric)
#      assert_equal true,is_element_present(check_item_content)
#    end
#    logout
#  end
#  # open subwindow Metric Customize Window
#  # check of check button
#  #
#  def test_051
#    #test_000
#    printf "\n+ Test 051"
#    open_metric_customize_subwindow($link_texts["metric_tab"][1])
#    total_checks=get_xpath_count($xpath["metric"]["sub_window_list"])
#    (1..total_checks).each do |check_index|
#      check_item_checkbox= $xpath["metric"]["sub_window_list"]+ "[#{check_index}]"+"/input[@type='checkbox']"
#      check_item_metric= $xpath["metric"]["sub_window_list"]+ "[#{check_index}]"+"/label"
#      check_item_content= $xpath["metric"]["sub_window_list"]+ "[#{check_index}]"+"/em"
#      assert_equal true,is_element_present(check_item_checkbox)
#      assert_equal true,is_element_present(check_item_metric)
#      assert_equal true,is_element_present(check_item_content)
#    end
#    logout
#  end
#  # open subwindow
#  # click "Check All" button
#  # all check are checked
#  #
#  def test_052
#    #test_000
#    printf "\n+ Test 052"
#    open_metric_customize_subwindow($link_texts["metric_tab"][1])
#    ## check all item
#    click "#{$xpath["metric"]["check_all_button"]}"
#    sleep WAIT_TIME
#    total_checks=get_xpath_count($xpath["metric"]["sub_window_list"])
#    ## check checked or not
#    (1..total_checks).each do |check_index|
#      check_item_xpath= $xpath["metric"]["sub_window"]+ "/div[#{check_index}]"
#      check_contents= @selenium.get_text(check_item_xpath)
#      check_value=check_contents[0..4]
#      if (check_value=="STFNC"||check_value=="STM33"||check_value=="STTPP")
#        assert true
#      else
#        assert_equal true,is_checked("//input[@value='#{check_value}']")
#      end
#    end
#    p "Reloading fixtures. Please wait ..."
#    system "rake db:fixtures:load"
#    logout
#  end
#  # open subwindow
#  # click "Uncheck All" button
#  # all check are unchecked
#  #
#  def test_053
#    #test_000
#    printf "\n+ Test 053"
#    open_metric_customize_subwindow($link_texts["metric_tab"][1])
#    ## uncheck all item
#    click "#{$xpath["metric"]["uncheck_all_button"]}"
#    sleep WAIT_TIME
#    total_checks=get_xpath_count($xpath["metric"]["sub_window_list"])
#    ## check unchecked or not
#    (1..total_checks).each do |check_index|
#      check_item_xpath= $xpath["metric"]["sub_window"]+ "/div[#{check_index}]"
#      check_contents= @selenium.get_text(check_item_xpath)
#      check_value=check_contents[0..4]
#      assert_equal false,is_checked("//input[@value='#{check_value}']")
#    end
#    p "Reloading fixtures. Please wait ..."
#    system "rake db:fixtures:load"
#    logout
#  end
#  # check a random metric
#  # click ok
#  #
#  def test_054
#    #test_000
#    printf "\n+ Test 054"
#    check_random_metric($link_texts["metric_tab"][1])
#    ## click ok
#    click "#{$xpath["metric"]["ok_button"]}"
#    run_script("destroy_subwindow()")
#    sleep WAIT_TIME
#    assert(is_text_present(@@check_random_value))
#    p "Reloading fixtures. Please wait ..."
#    system "rake db:fixtures:load"
#    logout
#  end
#  # check a random metric
#  # click ok
#  #
#  def test_055
#    #test_000
#    printf "\n+ Test 055"
#    metric_strings=Array.new
#    i=0
#    open_metric_customize_subwindow($link_texts["metric_tab"][1])
#    ## get total check item
#    total_checks=get_xpath_count($xpath["metric"]["sub_window_list"])
#    ## get a random value
#    begin
#      random_item=rand(total_checks-1)+1
#      check_item_xpath=$xpath["metric"]["sub_window"]+ "/div[#{random_item}]"
#      ## get content of value
#      check_contents= @selenium.get_text(check_item_xpath)
#      @@check_random_value=check_contents[0..4]
#    end while (is_checked("//input[@value='#{@@check_random_value}']")==true)
#    check("//input[@value='#{@@check_random_value}']")
#    ## get string of checked item
#    (1..total_checks).each do |check_index|
#      check_item_xpath=$xpath["metric"]["sub_window"]+ "/div[#{check_index}]"
#      ## get content of value
#      check_contents= @selenium.get_text(check_item_xpath)
#      check_value=check_contents[0..4]
#      if (is_checked("//input[@value='#{check_value}']")==true)
#        metric_strings[i]= check_value
#        i+=1
#      end
#    end
#    ## click ok
#    click "#{$xpath["metric"]["ok_button"]}"
#    sleep WAIT_TIME
#    ## check assert or not
#    if i
#      (1..i).each do |j|
#        assert(is_text_present(metric_strings[j-1]))
#      end
#    end
#    p "Reloading fixtures. Please wait ..."
#    system "rake db:fixtures:load"
#    logout
#  end
#  # click customize again
#  # subwindow view
#  #
#  def test_056
#    #test_000
#    printf "\n+ Test 056"
#    open_metric_tab($link_texts["metric_tab"][1])
#    total_metrics=get_xpath_count($xpath["metric"]["metric_list"])
#    total_metric_contents=Array.new
#    (1..total_metrics).each do |i|
#      temp_metric_content=@selenium.get_text($xpath["metric"]["metric_list"]+"[#{i}]")
#      total_metric_contents[i]=temp_metric_content
#    end
#    sleep WAIT_TIME
#    click "#{$xpath["metric"]["customize_button"]}"
#    sleep WAIT_TIME
#    total_checks=get_xpath_count($xpath["metric"]["sub_window_list"])
#    metric_strings=Array.new
#    i=1
#    (1..total_checks).each do |check_index|
#      check_item_xpath=$xpath["metric"]["sub_window"]+ "/div[#{check_index}]"
#      ## get content of value
#      check_contents= @selenium.get_text(check_item_xpath)
#      check_value=check_contents[0..4]
#      if (is_checked("//input[@value='#{check_value}']")==true)
#        metric_strings[i]= check_contents
#        i+=1
#      end
#    end
#    if (total_metrics==i-1)
#      (1..total_metrics).each do |j|
#        assert_equal total_metric_contents[j],metric_strings[j]
#      end
#    end
#    p "Reloading fixtures. Please wait ..."
#    system "rake db:fixtures:load"
#    logout
#  end
#  # do something
#  # click cancel button
#  # nothing change
#  #
#  def test_057
#    #test_000
#    printf "\n+ Test 057"
#    open_metric_tab($link_texts["metric_tab"][1])
#    file_metric_graph_old=@selenium.get_text($xpath["metric"]["metric_pane_content"])
#    sleep WAIT_TIME
#    click "#{$xpath["metric"]["customize_button"]}"
#    sleep WAIT_TIME
#    click "#{$xpath["metric"]["check_all_button"]}"
#    sleep WAIT_TIME
#    click "#{$xpath["metric"]["cancel_button"]}"
#    sleep WAIT_TIME
#    file_metric_graph_new=@selenium.get_text($xpath["metric"]["metric_pane_content"])
#    assert_equal file_metric_graph_old,file_metric_graph_new
#    logout
#  end
#  #########################################################################
#  #		File Metric Graph - Graph Metric Function (58-60)    	  #
#  #########################################################################
#  #	select 1 metric name
#  #	click "redaw button"
#  def test_058
#    #test_000
#    printf "\n+ Test 058"
#    open_metric_tab($link_texts["metric_tab"][1])
#    click ("#{$xpath["metric"]["redraw_graph_button"]}")
#    sleep WAIT_TIME
#    assert(is_element_present($xpath["metric"]["redraw_graph_view"]))
#    ## selenium is not being able to test Flash/Flex/Silverlight or Java Applets
#    logout
#  end
#  #select metric its type is string
#  #
#  def test_059
#    #test_000
#    printf "\n+ Test 059"
#    metric_descriptions=MetricDescription.find(:all,
#      :conditions => {:name => "STMCC"})
#    metric_descriptions.each do |metric_description|
#      metric_description.metric_type = 'File'
#      metric_description.save
#    end
#    metrics = Metric.find(:all,
#      :conditions => {:name => "STMCC"}      )
#    metrics.each do |metric|
#      metric.metric_type= 'File'
#      metric.save
#    end
#    #
#    sleep WAIT_TIME
#    open_metric_customize_subwindow($link_texts["metric_tab"][1])
#    click ("#{$xpath["metric"]["check_all_button"]}")
#    sleep WAIT_TIME
#    click ("#{$xpath["metric"]["ok_button"]}")
#    sleep WAIT_TIME
#    begin
#      assert(is_text_present('STMCC'))
#    rescue Test::Unit::AssertionFailedError
#      @verification_errors << $!
#    end
#    check("//input[@value='STMCC']")
#    sleep WAIT_TIME
#    click ("#{$xpath["metric"]["redraw_graph_button"]}")
#    sleep WAIT_TIME
#    begin
#      assert(is_text_present($messages["redraw_notice"]))
#    rescue Test::Unit::AssertionFailedError
#      @verification_errors << $!
#    end
#    p "Reloading fixtures. Please wait ..."
#    system "rake db:fixtures:load"
#    logout
#  end
#  #request to download image Graph of metric
#  #
#  def test_060
#    #test_000
#    printf "\n+ Test 060"
#    open_metric_tab($link_texts["metric_tab"][1])
#    click ($xpath["metric"]["redraw_graph_button"])
#    sleep WAIT_TIME
#    context_menu($xpath["metric"]["redraw_graph_view"])
#    sleep WAIT_TIME
#    ## can not assert type of downloaded file
#    assert true
#    logout
#  end
#  ###################################################################
#  #											Test CLASS TABLE TAB												#
#  ###################################################################
#  def test_061
#	printf "\n+ Test 061"
#	#- the display of "class metric table" tab
#	#- Return Metric page with 3 sections       
#	#	+ section “Select analysis tools”        
#	#	+ section “Select metrics”        
#	#	+ section “Metric HTML table” 
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#    #Select analyze tools
#    wait_for_text_present(_("Select analyze tools"))
#    #Select metric
#		wait_for_text_present(_("Select metrics"))	
#		#Metric HTML table
#		wait_for_text_present(_("Metric HTML table"))
#	end
#	
#	def test_062
#	printf "\n+ Test 062"
#	#- the screen of section "Select analysis tools"       
#	#	+ there are 2 button: "Check All" & "Uncheck All"       
#	#	+ By default, 2 check boxes: “QAC” & “QAC++” are checked
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#    #Select analyze tools
#    wait_for_text_present(_("Select analyze tools"))
#			#button
#			wait_for_element_present($class_table_tab["analyze_tool_check_all"])
#			wait_for_element_present($class_table_tab["analyze_tool_uncheck_all"])
#			assert_equal "Check All", get_value($class_table_tab["analyze_tool_check_all"])
#			assert_equal "Uncheck All", get_value($class_table_tab["analyze_tool_uncheck_all"])
#			#radio button checked
#			assert is_checked("1_file_QAC")
#			assert is_checked("1_file_QAC++")
#	end
#	
#	def test_063
#	printf "\n+ Test 063"
#	#- the screen of section "Select metrics"       
#	#	+ there are 3 buttons: "Check All", "Uncheck All" & "Customize"       
#	#	+ By default, some check boxes are displayed and checked
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#	#Select metric
#		wait_for_text_present(_("Select metrics"))	
#			#button & customize button
#			wait_for_element_present($class_table_tab["select_metrics_check_all"])
#			wait_for_element_present($class_table_tab["select_metrics_uncheck_all"])
#			assert_equal "Check All", get_value($class_table_tab["select_metrics_check_all"])
#			assert_equal "Uncheck All", get_value($class_table_tab["select_metrics_uncheck_all"])
#			assert_equal "Customize", get_value($class_table_tab["customize"])
#			#radio button checked
#			assert is_checked("1_class_STCBO")
#			assert is_checked("1_class_STLCM")
#			assert is_checked("1_class_STMTH")
#	end
#	
#	def test_064
#	printf "\n+ Test 064"
#	#- the screen of section "Metric HTML table"       
#	#	+ there is 1 buttons: "Download CSV format"       
#	#	+ Show  HTML table
#	login_metric 
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#	#Metric HTML table
#		wait_for_text_present(_("Metric HTML table"))
#			#download CSV format button	
#			wait_for_element_present($class_table_tab["download_csv"])
#			assert_equal "Download CSV Format", get_value($class_table_tab["download_csv"])	
#			#HTML table
#			wait_for_element_text($class_table_tab["file_name"],"File name")
#			wait_for_element_text($class_table_tab["item_name"],"Item name")
#			wait_for_element_text($class_table_tab["analyze_tool"], "Analyze tool")
#	end
#	
#	def test_065
#	printf "\n+ Test 065"
#	#- Click "Check All" button in "Select analysis tools" section
#	#- Check boxes: "QAC" & "QAC++" are checked 
#	#- HTML table change dynamically
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#	#click Check All button in Analyze tool
#		wait_for_element_present($class_table_tab["analyze_tool_check_all"])
#		click $class_table_tab["analyze_tool_check_all"]
#			assert is_checked("1_class_QAC")
#			assert is_checked("1_class_QAC++")
#			wait_for_element_text($class_table_tab["file_name"],"File name")
#			wait_for_element_text($class_table_tab["item_name"],"Item name")
#			wait_for_element_text($class_table_tab["analyze_tool"], "Analyze tool")
#	end
#  
#  def test_066
#  printf "\n+ Test 066"
#  #- Click "Uncheck All" button in "Select metrics" section
#	#- Check boxes: "QAC" & "QAC++" are unchecked 
#	#- HTML table change dynamically: It will disappear
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#	#click Uncheck All button in Analyze tool
#  	wait_for_element_present($class_table_tab["analyze_tool_uncheck_all"])
#  	click $class_table_tab["analyze_tool_uncheck_all"]
#  	sleep WAIT_TIME
#			assert !is_checked("1_class_QAC")
#			assert !is_checked("1_class_QAC++")
#			sleep WAIT_TIME
#			wait_for_text_present(_("According to your options, there is no information to display"))
#  end
#  
#  def test_067
#  printf "\n+ Test 067"
#  #- Select analysis tool by checking check boxes
#	#- HTML table change dynamically according to selected analysis tool
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#	#Uncheck QAC. HTML page only display QAC++ 
#	wait_for_element_present($class_table_tab["QAC_radio"])
#  	click $class_table_tab["QAC_radio"]
#			assert !is_checked("1_class_QAC")
#			wait_for_element_present($class_table_tab["analyze_tool"])
#			assert_equal "QAC++", get_text($class_table_tab["QAC_analyze_tool"])	
#  end
#  
#  def test_068
#  printf "\n+ Test 068"
#  #- Don't select any analysis tool 
#	#- HTML table will disappear 
#	#- Pagination isn't displayed
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#	wait_for_element_present($class_table_tab["QAC_radio"])
#	wait_for_element_present($class_table_tab["QAC++_radio"])
#	#Uncheck analysis tools.
#		click $class_table_tab["QAC_radio"]
#		assert !is_checked("1_class_QAC")
#  	click $class_table_tab["QAC++_radio"]	
#  	assert !is_checked("1_class_QAC++")
#  #- Pagination isn't displayed
#  wait_for_element_not_present($class_table_tab["page_2"])	
#  #HTML table disappear	
#  	sleep WAIT_TIME
#		wait_for_text_present(_("According to your options, there is no information to display"))
#  end
#	
#  def test_069
#  printf "\n+ Test 069"
#  #- Click "Check All" button in "Select metrics" section
#	#- All check boxes available in “Select metrics” section are checked 
#	#- HTML table change dynamically
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#	#click Check All button in Select metrics
#		wait_for_element_present($class_table_tab["select_metrics_check_all"])
#		click $file_table_tab["select_metrics_check_all"]
#			assert is_checked("1_class_STCBO")
#			assert is_checked("1_class_STLCM")
#			assert is_checked("1_class_STMTH")
#			wait_for_element_text($class_table_tab["STCBO"],"STCBO")
#			wait_for_element_text($class_table_tab["STLCM"],"STLCM")
#			wait_for_element_text($class_table_tab["STMTH"],"STMTH")
#  end

#	def test_070
#	printf "\n+ Test 070"
#	#- Click "Uncheck All" button in "Select metrics" section
#	#- All check boxes available in “Select metrics” section are unchecked 
#	#- HTML table change dynamically
#	login_metric	
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#	#click Uncheck All button in Select metrics
#		wait_for_element_present($class_table_tab["select_metrics_uncheck_all"])
#		click $class_table_tab["select_metrics_uncheck_all"]
#		sleep WAIT_TIME
#			assert !is_checked("1_class_STCBO")
#			assert !is_checked("1_class_STLCM")
#			assert !is_checked("1_class_STMTH")
#			sleep WAIT_TIME
#			wait_for_text_present(_("According to your options, there is no information to display"))
#	end

#	def test_071
#	printf "\n+ Test 071"
#	#- Select metric names by checking check boxes 
#	#- HTML table change dynamically according to selected metrics
#	login_metric	
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#	#Uncheck STFNC radio button
#		wait_for_element_present($class_table_tab["STCBO"])
#		click $class_table_tab["STCBO_radio"]	
#	#Check STFNC radio button
#		click $class_table_tab["STCBO_radio"]	
#		assert is_checked("1_class_STCBO")
#	#HTML table display STFNC	normally
#	wait_for_element_text($class_table_tab["STCBO"],"STCBO")
#	end

#	def test_072
#	printf "\n+ Test 072"
#	#- Don't select any  metric name 
#	#- HTML table will disappear 
#	#- Pagination isn't displayed
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#	#Uncheck all metric
#	wait_for_element_present($class_table_tab["STCBO"])
#		click $class_table_tab["STCBO_radio"]	
#		click $class_table_tab["STLCM_radio"]	
#		click $class_table_tab["STMTH_radio"]
#		sleep WAIT_TIME
#	# HTML table disappear
#		assert !is_checked("1_class_STCBO")
#		assert !is_checked("1_class_STLCM")
#		assert !is_checked("1_class_STMTH")
#		sleep WAIT_TIME
#		wait_for_text_present(_("According to your options, there is no information to display"))	
#	end
#	
#	def test_073
#	printf "\n+ Test 073"
#	#- Click "Customize" button
#	#- a sub window "Metric Customize Window" will be displayed 
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#  #click Customize button
#  wait_for_element_present($class_table_tab["customize"])
#  	click $class_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#	end
#  
#	def test_074
#	printf "\n+ Test 074"
#  #- a sub window "Metric Customize Window" is displayed 
#	#- 2 buttons: "Check All" & "Uncheck All" in the top 
#	#- 2 buttons: “Ok” & “Cancel” in the bottom 
#	#- list all metrics & their meaning
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#  #click Customize button
#  wait_for_element_present($class_table_tab["customize"])
#  	click $class_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#  	wait_for_element_present($class_table_tab["customize_check_all"])
#		assert_equal "Check All", get_value($class_table_tab["customize_check_all"])
#		wait_for_element_present($class_table_tab["customize_uncheck_all"])
#		assert_equal "Uncheck All", get_value($class_table_tab["customize_uncheck_all"])
#		wait_for_element_present($class_table_tab["customize_ok"])
#		assert_equal "OK", get_value($class_table_tab["customize_ok"])
#		wait_for_element_present($class_table_tab["customize_cancel"])
#		assert_equal _("Cancel"), get_value($class_table_tab["customize_cancel"])
#  end
#    
#  def test_075
#  printf "\n+ Test 075"
#  #The check box which can be chosen is attached to the left-hand side of each metric
#  login_metric
#  #click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#	#click Customize button
#  wait_for_element_present($class_table_tab["customize"])
#  	click $class_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#  #Checkbox displayed
#		wait_for_element_present($class_table_tab["customize_count"])
#		metrics_count = get_xpath_count($class_table_tab["customize_count"])
#    1.upto(metrics_count) do |i|
#    	wait_for_element_present($class_table_tab["customize_count"] + "[" + i.to_s + "]" + "/input")
#  	end	
#  end
#  
#  def test_076
#  printf "\n+ Test 076"
#  #- The "Check All" button on a subwindow is clicked.
#	#- All check boxes are checked
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#	#click Customize button
#	wait_for_element_present($class_table_tab["customize"])
#	click $class_table_tab["customize"]
#		wait_for_element_present("customize_window_top")
#		wait_for_element_present($class_table_tab["customize_check_all"])
#		#click Check All button
#		click $class_table_tab["customize_check_all"]
#		checker_count = get_xpath_count($class_table_tab["customize_count"])
#    1.upto(checker_count) do |i|
#    	assert is_checked($class_table_tab["customize_count"] + "[" + i.to_s + "]" + "/input")
#    end
#  end
#  
#  def test_077
#  printf "\n+ Test 077"
#  #- The "Uncheck All" button on a subwindow is clicked
#	#- All check boxes are uncheked
#  login_metric
#  #click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#  	#click Customize button
#  	wait_for_element_present($class_table_tab["customize"])
#  	click $class_table_tab["customize"]
#		wait_for_element_present("customize_window_top")
#		wait_for_element_present($class_table_tab["customize_uncheck_all"])	
#		#click Uncheck All button
#      click $class_table_tab["customize_uncheck_all"]
#      checker_count = get_xpath_count($class_table_tab["customize_count"])
#      1.upto(checker_count) do |i|
#      	assert !is_checked($class_table_tab["customize_count"] + "[" + i.to_s + "]" + "/input")
#      end
#  end
#    
#  def test_078
#  printf "\n+ Test 078"
#  #- Some metrics are checked, and "Ok" button is clicked.
#	#- Corresponding check boxes are substituted for "Select metrics" section & they are checked 
#	#- HTML table change dynamically
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#  	#click Customize button
#  	wait_for_element_present($class_table_tab["customize"])
#  	click $class_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#  	wait_for_element_present($class_table_tab["customize_ok"])
#  	#check STWMC
#			wait_for_element_present($class_table_tab["new_STWMC_radio"])
#		  click $class_table_tab["new_STWMC_radio"]
#		  assert is_checked($class_table_tab["new_STWMC_radio"])
#  	#Click OK button  
#      click $class_table_tab["customize_ok"]
#	    wait_for_element_present($class_table_tab["STWMC_radio"])
#	    sleep WAIT_TIME
#	    assert is_checked("1_class_STWMC")
#	    wait_for_element_present($class_table_tab["STWMC"])
#  end  
#  
#  def test_079
#  printf "\n+ Test 079"
#  #- "Customize" button is again clicked following the above-mentioned operation, and a subwindow is displayed.
#	#- The corresponding check boxes currently checked in “Select metrics” section are checked
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#  	#click Customize button
#  	wait_for_element_present($class_table_tab["customize"])
#  	click $class_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#  	wait_for_element_present($class_table_tab["customize_ok"])
#  	#check STBME
#			wait_for_element_present($class_table_tab["new_STWMC_radio"])
#		  click $class_table_tab["new_STWMC_radio"]
#  	#Click OK button  
#      click $class_table_tab["customize_ok"]
#	    wait_for_element_present($class_table_tab["STWMC_radio"])
#	  #click Customize button
#  	wait_for_text_present(_("Select metrics"))
#  	click $class_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#  	#check STBME
#			wait_for_element_present($class_table_tab["new_STWMC_radio"])
#			assert is_checked($class_table_tab["new_STWMC_radio"])
#  end
#   
#  def test_080
#  printf "\n+ Test 080"
#  #- Do some operations(such as: check some check boxes), but finally click "Cancel" button
#	#- Nothing change in parent page(metric page)
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#  	#click Customize button
#  	wait_for_element_present($class_table_tab["customize"])
#  	click $class_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#  	wait_for_element_present($class_table_tab["customize_ok"])
#  	#check STBME
#			wait_for_element_present($class_table_tab["new_STWMC_radio"])
#		  click $class_table_tab["new_STWMC_radio"]
#  	#Click OK button  
#      click $class_table_tab["customize_ok"]
#	    wait_for_element_present($class_table_tab["STWMC_radio"])
#	  #click Customize button again
#  	wait_for_element_present($class_table_tab["customize"])
#  	click $class_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#  	#check STBME
#			wait_for_element_present($class_table_tab["new_STWMC_radio"])
#		  assert is_checked($class_table_tab["new_STWMC_radio"])
#		  click $class_table_tab["new_STWMC_radio"]
#  	#Click Cancel button  
#      click $class_table_tab["customize_cancel"]
#	    wait_for_element_present($class_table_tab["STWMC_radio"])
#			assert is_checked($class_table_tab["STWMC_radio"])
#  end 
#  
#  def test_081
#  printf "\n+ Test 081"
#  #- HTML table display
#	#- Header of table is class_name, item_name, analysis_tool_type, followed by metric name 
#	#- Each row of table represents one item(file, function or class) in metric list
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#  	wait_for_text_present(_("Metric HTML table"))
#   	#HTML table display
#  	wait_for_element_present($class_table_tab["file_name"])
#  	wait_for_element_present($class_table_tab["item_name"])
#  	wait_for_element_present($class_table_tab["analyze_tool"])
#  	wait_for_element_present($class_table_tab["STCBO"])
#  	wait_for_element_present($class_table_tab["STLCM"])
#  	wait_for_element_present($class_table_tab["STMTH"])
#  	#HTML row
#  	wait_for_element_present($class_table_tab["file_name_row_1"])
#  end  
#  
#  def test_082
#  printf "\n+ Test 082"
#  #- HTML table display
#	#- Values inside metric are the same with values from DB. If analysis tool has no value for that metric, it shall set to “”
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#  	wait_for_text_present(_("Metric HTML table"))
#   	wait_for_element_present($class_table_tab["file_name_row_1"])
#   	#Valid value
#  	metric_data = MetricData.new(1, "class")
#  	metric_value = metric_data.get_metric("STMTH")
#  	assert_equal get_text($class_table_tab["file_name_row_1_value"]).to_i, metric_value[1][20]
#  	assert_equal get_text($class_table_tab["STCBO_column_value"]).to_i, metric_value[1][0]
#  end
#  
#  def test_083
#  printf "\n+ Test 083"
#  #- Dummy data is very large
#	#"- Show HTML table with extra conditions below 	+ Pagination is displayed"
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#  	wait_for_text_present(_("Metric HTML table"))
#  	#Paginating
#  	wait_for_element_text($class_table_tab["page_2"], "2")
#  end
#  
#  def test_084
#  printf "\n+ Test 084"
#  # - Modify data in DB, such as class_name... 
#	#- Corresponding data in table change according to data in DB  
#	#- Size of corresponding column in table change to fit with this changed data 
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#	#Data modified from 5 to 50000
#	wait_for_element_present($class_table_tab["data_change"])
#	assert_equal "50000", get_text($class_table_tab["data_change"])
#  end
#  
#  def test_085
#  printf "\n+ Test 085"
#  #- Select one analysis tool 
#  #- Select metric names which don't belong to selected tool
#	#- Default value of these metric names is "" in HTML table
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#  #Uncheck QAC
#  wait_for_element_present($class_table_tab["QAC_radio"])
#  click  $class_table_tab["QAC_radio"]	
#  #Assert value in STCBO
#		wait_for_element_present($class_table_tab["STCBO_column_value"])  
#		assert_equal 0, get_text($class_table_tab["STCBO_column_value"]).to_i
#  end
#  
#  def test_086
#  printf "\n+ Test 086"
#  #- HTML table
#	#- By default, column “File Name” is used to provide the initial  descending sort 
#	#- This column is highlighted
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#  wait_for_element_present($class_table_tab["file_name"])
#	#default File name sort asc
#  	assert_equal "sortasc", get_attribute($class_table_tab["file_name"], "class")
#  end
#  
#  def test_087
#  printf "\n+ Test 087"
#  #- Click at header of each column
#	#- All items in this column will be re-arranged in descending order 
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#  	wait_for_text_present(_("Metric HTML table"))
#  #click header of STFNC column
#  wait_for_element_present($class_table_tab["STMTH"])
#		click	$class_table_tab["STMTH"] + "/a"
#		sleep WAIT_TIME
#		assert_equal "sortdesc", 	get_attribute($class_table_tab["STMTH"], "class")
#  end
#  
#  def test_088
#  printf "\n+ Test 088"
#  #- Click at header of above column again
#	#- All items in this column will be re-arranged in ascending order 
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#  	wait_for_text_present(_("Metric HTML table"))
#  #click header of STFNC column
#  wait_for_element_present($class_table_tab["STMTH"])
#		click	$class_table_tab["STMTH"] + "/a"
#		sleep WAIT_TIME
#		assert_equal "sortdesc", 	get_attribute($class_table_tab["STMTH"], "class")
#		click	$class_table_tab["STMTH"] + "/a"
#		sleep WAIT_TIME
#		assert_equal "sortasc", 	get_attribute($class_table_tab["STMTH"], "class")
#  end
#  
#  def test_089
#  printf "\n+ Test 089"
#  #- Remove the current sorting column from HTML table
#	#- By default, column “File Name” is used to provide the initial  descending sort 
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#  	wait_for_text_present(_("Metric HTML table"))
#  #click header of STFNC column
#  wait_for_element_present($class_table_tab["STMTH"])
#		click	$class_table_tab["STMTH"] + "/a"
#		sleep WAIT_TIME
#		assert_equal "sortdesc", 	get_attribute($class_table_tab["STMTH"], "class")
#	#uncheck STFNC metric
#	click 	$class_table_tab["STMTH_radio"]
#	wait_for_element_present($class_table_tab["file_name"])
#	#default File name sort asc
#  	assert_equal "sortasc", get_attribute($class_table_tab["file_name"], "class")
#	
#  end
#  
#  def test_090
#  printf "\n+ Test 090"
#  #-Click "CSV Down Load" button
#	#- Download the content of metric's table in CSV format
#	#- File is downloaded in CSV format
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#	#click download button
#	wait_for_element_present($class_table_tab["download_csv"])
#	click $class_table_tab["download_csv"]
#	sleep WAIT_TIME
#  end

#	def test_091
#	printf "\n+ Test 091"
#	#-Click "CSV Down Load" button	
#	#- File is downloaded in CSV format
#	login_metric
#	#click Class table tab
#  click $class_table_tab["link_to_class_table_tab"]
#	#click download button
#	wait_for_element_present($class_table_tab["download_csv"])
#	click $class_table_tab["download_csv"]
#	sleep WAIT_TIME
#	printf "-	Test Failed! Selenium does not support to assert download of file"
#	assert false
#	end
#  
#  
#  ########################################################################
#  #							Class Metric Graph Tab Display (92 - 95)              	 #
#  ########################################################################
#  #display of Class metric graph tab
#  #
#  def test_092
#    #test_000
#    printf "\n+ Test 092"
#    open_metric_tab($link_texts["metric_tab"][3])
#    assert_equal _("Select metrics"),@selenium.get_text($xpath["metric"]["metric_pane_content"]+"/h3[1]")
#    assert_equal _("Graph"),@selenium.get_text($xpath["metric"]["metric_pane_content"]+"/h3[2]")
#    logout
#  end
#  # display of Class metric graph tab: select metric
#  #
#  def test_093
#    #test_000
#    printf "\n+ Test 093"
#    open_metric_tab($link_texts["metric_tab"][3])
#    assert(is_element_present($xpath["metric"]["customize_button"]))
#    logout
#  end
#  # display of Class metric graph tab: graph of metric
#  #
#  def test_094
#    # test_000
#    printf "\n+ Test 094"
#    open_metric_tab($link_texts["metric_tab"][3])
#    assert(is_element_present($xpath["metric"]["redraw_graph_button"]))
#    logout
#  end
#  # click on customize button, a subwindow display
#  #
#  def test_095
#    # test_000
#    printf "\n+ Test 095"
#    open_metric_customize_subwindow($link_texts["metric_tab"][3])
#    assert(is_text_present("Customize metrics"))
#    logout
#  end
#  ##########################################################################
#  #		Class Metric Graph -  Metric Customize Window (96-103)     #
#  ##########################################################################
#  # open subwindow Metric Customize Window
#  # check view
#  #
#  def test_096
#    #test_000
#    printf "\n+ Test 096"
#    open_metric_customize_subwindow($link_texts["metric_tab"][3])
#    assert(is_element_present($xpath["metric"]["check_all_button"]))
#    assert(is_element_present($xpath["metric"]["uncheck_all_button"]))
#    assert(is_element_present($xpath["metric"]["ok_button"]))
#    assert(is_element_present($xpath["metric"]["cancel_button"]))
#    total_checks=get_xpath_count($xpath["metric"]["sub_window_list"])
#    (1..total_checks).each do |check_index|
#      check_item_metric= $xpath["metric"]["sub_window_list"]+ "[#{check_index}]"+"/label"
#      check_item_content= $xpath["metric"]["sub_window_list"]+ "[#{check_index}]"+"/em"
#      assert_equal true,is_element_present(check_item_metric)
#      assert_equal true,is_element_present(check_item_content)
#    end
#    logout
#  end
#  # open subwindow Metric Customize Window
#  # check of check button
#  #
#  def test_097
#    #test_000
#    printf "\n+ Test 097"
#    open_metric_customize_subwindow($link_texts["metric_tab"][3])
#    total_checks=get_xpath_count($xpath["metric"]["sub_window_list"])
#    (1..total_checks).each do |check_index|
#      check_item_checkbox= $xpath["metric"]["sub_window_list"]+ "[#{check_index}]"+"/input[@type='checkbox']"
#      check_item_metric= $xpath["metric"]["sub_window_list"]+ "[#{check_index}]"+"/label"
#      check_item_content= $xpath["metric"]["sub_window_list"]+ "[#{check_index}]"+"/em"
#      assert_equal true,is_element_present(check_item_checkbox)
#      assert_equal true,is_element_present(check_item_metric)
#      assert_equal true,is_element_present(check_item_content)
#    end
#    logout
#  end
#  # open subwindow
#  # click "Check All" button
#  # all check are checked
#  #
#  def test_098
#    #test_000
#    printf "\n+ Test 098"
#    open_metric_customize_subwindow($link_texts["metric_tab"][3])
#    ## check all item
#    click "#{$xpath["metric"]["check_all_button"]}"
#    sleep WAIT_TIME
#    total_checks=get_xpath_count($xpath["metric"]["sub_window_list"])
#    ## check checked or not
#    (1..total_checks).each do |check_index|
#      check_item_xpath= $xpath["metric"]["sub_window"]+ "/div[#{check_index}]"
#      check_contents= @selenium.get_text(check_item_xpath)
#      check_value=check_contents[0..4]
#      if (check_value=="STCBO"||check_value=="STLCM"||check_value=="STMTH")
#        assert true
#      else
#        assert_equal true,is_checked("//input[@value='#{check_value}']")
#      end
#    end
#    p "Reloading fixtures. Please wait ..."
#    system "rake db:fixtures:load"
#    logout
#  end
#  # open subwindow
#  # click "Uncheck All" button
#  # all check are unchecked
#  #
#  def test_099
#    #test_000
#    printf "\n+ Test 099"
#    open_metric_customize_subwindow($link_texts["metric_tab"][3])
#    ## uncheck all item
#    click "#{$xpath["metric"]["uncheck_all_button"]}"
#    sleep WAIT_TIME
#    total_checks=get_xpath_count($xpath["metric"]["sub_window_list"])
#    ## check unchecked or not
#    (1..total_checks).each do |check_index|
#      check_item_xpath= $xpath["metric"]["sub_window"]+ "/div[#{check_index}]"
#      check_contents= @selenium.get_text(check_item_xpath)
#      check_value=check_contents[0..4]
#      assert_equal false,is_checked("//input[@value='#{check_value}']")
#    end
#    p "Reloading fixtures. Please wait ..."
#    system "rake db:fixtures:load"
#    logout
#  end
#  # check a random metric
#  # click ok
#  #
#  def test_100
#    #test_000
#    printf "\n+ Test 100"
#    check_random_metric($link_texts["metric_tab"][3])
#    ## click ok
#    click "#{$xpath["metric"]["ok_button"]}"
#    run_script("destroy_subwindow()")
#    sleep WAIT_TIME
#    assert(is_text_present(@@check_random_value))
#    p "Reloading fixtures. Please wait ..."
#    system "rake db:fixtures:load"
#    logout
#  end
#  # check a random metric
#  # click ok
#  #
#  def test_101
#    #test_000
#    printf "\n+ Test 101"
#    metric_strings=Array.new
#    i=0
#    open_metric_customize_subwindow($link_texts["metric_tab"][3])
#    ## get total check item
#    total_checks=get_xpath_count($xpath["metric"]["sub_window_list"])
#    ## get a random value
#    begin
#      random_item=rand(total_checks-1)+1
#      check_item_xpath=$xpath["metric"]["sub_window"]+ "/div[#{random_item}]"
#      ## get content of value
#      check_contents= @selenium.get_text(check_item_xpath)
#      @@check_random_value=check_contents[0..4]
#    end while (is_checked("//input[@value='#{@@check_random_value}']")==true)
#    check("//input[@value='#{@@check_random_value}']")
#    ## get string of checked item
#    (1..total_checks).each do |check_index|
#      check_item_xpath=$xpath["metric"]["sub_window"]+ "/div[#{check_index}]"
#      ## get content of value
#      check_contents= @selenium.get_text(check_item_xpath)
#      check_value=check_contents[0..4]
#      if (is_checked("//input[@value='#{check_value}']")==true)
#        metric_strings[i]= check_value
#        i+=1
#      end
#    end
#    ## click ok
#    click "#{$xpath["metric"]["ok_button"]}"
#    sleep WAIT_TIME
#    ## check assert or not
#    if i
#      (1..i).each do |j|
#        assert(is_text_present(metric_strings[j-1]))
#      end
#    end
#    p "Reloading fixtures. Please wait ..."
#    system "rake db:fixtures:load"
#    logout
#  end
#  # click customize again
#  # subwindow view
#  #
#  def test_102
#    #test_000
#    printf "\n+ Test 102"
#    open_metric_tab($link_texts["metric_tab"][3])
#    total_metrics=get_xpath_count($xpath["metric"]["metric_list"])
#    total_metric_contents=Array.new
#    (1..total_metrics).each do |i|
#      temp_metric_content=@selenium.get_text($xpath["metric"]["metric_list"]+"[#{i}]")
#      total_metric_contents[i]=temp_metric_content
#    end
#    sleep WAIT_TIME
#    click "#{$xpath["metric"]["customize_button"]}"
#    sleep WAIT_TIME
#    total_checks=get_xpath_count($xpath["metric"]["sub_window_list"])
#    metric_strings=Array.new
#    i=1
#    (1..total_checks).each do |check_index|
#      check_item_xpath=$xpath["metric"]["sub_window"]+ "/div[#{check_index}]"
#      ## get content of value
#      check_contents= @selenium.get_text(check_item_xpath)
#      check_value=check_contents[0..4]
#      if (is_checked("//input[@value='#{check_value}']")==true)
#        metric_strings[i]= check_contents
#        i+=1
#      end
#    end
#    if (total_metrics==i-1)
#      (1..total_metrics).each do |j|
#        assert_equal total_metric_contents[j],metric_strings[j]
#      end
#    end
#    p "Reloading fixtures. Please wait ..."
#    system "rake db:fixtures:load"
#    logout
#  end
#  # do something
#  # click cancel button
#  # nothing change
#  #
#  def test_103
#    #test_000
#    printf "\n+ Test 103"
#    open_metric_tab($link_texts["metric_tab"][3])
#    file_metric_graph_old=@selenium.get_text($xpath["metric"]["metric_pane_content"])
#    sleep WAIT_TIME
#    click "#{$xpath["metric"]["customize_button"]}"
#    sleep WAIT_TIME
#    click "#{$xpath["metric"]["check_all_button"]}"
#    sleep WAIT_TIME
#    click "#{$xpath["metric"]["cancel_button"]}"
#    sleep WAIT_TIME
#    file_metric_graph_new=@selenium.get_text($xpath["metric"]["metric_pane_content"])
#    assert_equal file_metric_graph_old,file_metric_graph_new
#    logout
#  end
#  #########################################################################
#  #	Class Metric Graph - Graph Metric Function (104-106)    	  #
#  #########################################################################
#  #select one metric name
#  #click redraw button
#  #
#  def test_104
#    #test_000
#    printf "\n+ Test 104"
#    open_metric_tab($link_texts["metric_tab"][3])
#    click ("#{$xpath["metric"]["redraw_graph_button"]}")
#    sleep WAIT_TIME
#    assert(is_element_present($xpath["metric"]["redraw_graph_view"]))
#    ## selenium is not being able to test Flash/Flex/Silverlight or Java Applets
#    logout
#  end
#  #select metric its type is string
#  #
#  def test_105
#    #test_000
#    printf "\n+ Test 105"
#    metric_descriptions=MetricDescription.find(:all,
#      :conditions => {:name => "STMCC"})
#    metric_descriptions.each do |metric_description|
#      metric_description.metric_type = 'Class'
#      metric_description.save
#    end
#    metrics = Metric.find(:all,
#      :conditions => {:name => "STMCC"}      )
#    metrics.each do |metric|
#      metric.metric_type= 'Class'
#      metric.save
#    end
#    sleep WAIT_TIME
#    open_metric_customize_subwindow($link_texts["metric_tab"][3])
#    click ("#{$xpath["metric"]["check_all_button"]}")
#    sleep WAIT_TIME
#    click ("#{$xpath["metric"]["ok_button"]}")
#    sleep WAIT_TIME
#    begin
#      assert(is_text_present('STMCC'))
#    rescue Test::Unit::AssertionFailedError
#      @verification_errors << $!
#    end
#    check("//input[@value='STMCC']")
#    sleep WAIT_TIME
#    click ("#{$xpath["metric"]["redraw_graph_button"]}")
#    sleep WAIT_TIME
#    begin
#      assert(is_text_present($messages["redraw_notice"]))
#    rescue Test::Unit::AssertionFailedError
#      @verification_errors << $!
#    end
#    p "Reloading fixtures. Please wait ..."
#    system "rake db:fixtures:load"
#    logout
#  end
#  #request to download image Graph of metric
#  #
#  def test_106
#    #test_000
#    printf "\n+ Test 106"
#    open_metric_tab($link_texts["metric_tab"][3])
#    click ($xpath["metric"]["redraw_graph_button"])
#    sleep WAIT_TIME
#    context_menu($xpath["metric"]["redraw_graph_view"])
#    sleep WAIT_TIME
#    ## cannot assert type of downloaded file
#    assert true
#    logout
#  end
#  ###################################################################
#  #											Test FUNC TABLE TAB													#
#  ###################################################################
#  def test_107
#	printf "\n+ Test 107"
#	#- the display of "class metric table" tab
#	#- Return Metric page with 3 sections       
#	#	+ section “Select analysis tools”        
#	#	+ section “Select metrics”        
#	#	+ section “Metric HTML table” 
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#    #Select analyze tools
#    wait_for_text_present(_("Select analyze tools"))
#    #Select metric
#		wait_for_text_present(_("Select metrics"))	
#		#Metric HTML table
#		wait_for_text_present(_("Metric HTML table"))
#	end
#	
#	def test_108
#	printf "\n+ Test 108"
#	#- the screen of section "Select analysis tools"       
#	#	+ there are 2 button: "Check All" & "Uncheck All"       
#	#	+ By default, 2 check boxes: “QAC” & “QAC++” are checked
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#    #Select analyze tools
#    wait_for_text_present(_("Select analyze tools"))
#			#button
#			wait_for_element_present($func_table_tab["analyze_tool_check_all"])
#			wait_for_element_present($func_table_tab["analyze_tool_uncheck_all"])
#			assert_equal "Check All", get_value($func_table_tab["analyze_tool_check_all"])
#			assert_equal "Uncheck All", get_value($func_table_tab["analyze_tool_uncheck_all"])
#			#radio button checked
#			assert is_checked("1_func_QAC")
#			assert is_checked("1_func_QAC++")
#	end
#	
#	def test_109
#	printf "\n+ Test 109"
#	#- the screen of section "Select metrics"       
#	#	+ there are 3 buttons: "Check All", "Uncheck All" & "Customize"       
#	#	+ By default, some check boxes are displayed and checked
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#	#Select metric
#		wait_for_text_present(_("Select metrics"))	
#			#button & customize button
#			wait_for_element_present($func_table_tab["select_metrics_check_all"])
#			wait_for_element_present($func_table_tab["select_metrics_uncheck_all"])
#			assert_equal "Check All", get_value($func_table_tab["select_metrics_check_all"])
#			assert_equal "Uncheck All", get_value($func_table_tab["select_metrics_uncheck_all"])
#			assert_equal "Customize", get_value($func_table_tab["customize"])
#			#radio button checked
#			assert is_checked("1_func_STCYC")
#			assert is_checked("1_func_STLIN")
#			assert is_checked("1_func_STMIF")
#	end
#	
#	def test_110
#	printf "\n+ Test 110"
#	#- the screen of section "Metric HTML table"       
#	#	+ there is 1 buttons: "Download CSV format"       
#	#	+ Show  HTML table
#	login_metric 
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#	#Metric HTML table
#		wait_for_text_present(_("Metric HTML table"))
#			#download CSV format button	
#			wait_for_element_present($func_table_tab["download_csv"])
#			assert_equal "Download CSV Format", get_value($func_table_tab["download_csv"])	
#			#HTML table
#			wait_for_element_text($func_table_tab["file_name"],"File name")
#			wait_for_element_text($func_table_tab["item_name"],"Item name")
#			wait_for_element_text($func_table_tab["analyze_tool"], "Analyze tool")
#	end
#	
#	def test_111
#	printf "\n+ Test 111"
#	#- Click "Check All" button in "Select analysis tools" section
#	#- Check boxes: "QAC" & "QAC++" are checked 
#	#- HTML table change dynamically
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#	#click Check All button in Analyze tool
#		wait_for_element_present($func_table_tab["analyze_tool_check_all"])
#		click $func_table_tab["analyze_tool_check_all"]
#			assert is_checked("1_func_QAC")
#			assert is_checked("1_func_QAC++")
#			wait_for_element_text($func_table_tab["file_name"],"File name")
#			wait_for_element_text($func_table_tab["item_name"],"Item name")
#			wait_for_element_text($func_table_tab["analyze_tool"], "Analyze tool")
#	end
#  
#  def test_112
#  printf "\n+ Test 112"
#  #- Click "Uncheck All" button in "Select metrics" section
#	#- Check boxes: "QAC" & "QAC++" are unchecked 
#	#- HTML table change dynamically: It will disappear
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#	#click Uncheck All button in Analyze tool
#  	wait_for_element_present($func_table_tab["analyze_tool_uncheck_all"])
#  	click $func_table_tab["analyze_tool_uncheck_all"]
#  	sleep WAIT_TIME
#			assert !is_checked("1_func_QAC")
#			assert !is_checked("1_func_QAC++")
#			sleep WAIT_TIME
#			wait_for_text_present(_("According to your options, there is no information to display"))
#  end
#  
#  def test_113
#  printf "\n+ Test 113"
#  #- Select analysis tool by checking check boxes
#	#- HTML table change dynamically according to selected analysis tool
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#	#Uncheck QAC++. HTML page only display QAC 
#	wait_for_element_present($func_table_tab["QAC_radio"])
#  	click $func_table_tab["QAC++_radio"]
#			assert !is_checked("1_func_QAC++")
#			sleep WAIT_TIME
#			wait_for_element_present($func_table_tab["QAC_analyze_tool"])
#			assert_equal "QAC", get_text($func_table_tab["QAC_analyze_tool"])	
#  end
#  
#  def test_114
#  printf "\n+ Test 114"
#  #- Don't select any analysis tool 
#	#- HTML table will disappear 
#	#- Pagination isn't displayed
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#  wait_for_element_present($func_table_tab["QAC_radio"])
#	wait_for_element_present($func_table_tab["QAC++_radio"])
#	sleep WAIT_TIME
#	#Uncheck analysis tools.
#		click $func_table_tab["QAC_radio"]
#		sleep WAIT_TIME
#  	click $func_table_tab["QAC++_radio"]	
#  	sleep WAIT_TIME
#  #- Pagination isn't displayed
#  wait_for_element_not_present($func_table_tab["page_2"])	
#  #HTML table disappear	
#  	assert !is_checked("1_func_QAC")
#  	assert !is_checked("1_func_QAC++")
#		sleep WAIT_TIME
#		wait_for_text_present(_("According to your options, there is no information to display"))
#  end
#	
#  def test_115
#  printf "\n+ Test 115"
#  #- Click "Check All" button in "Select metrics" section
#	#- All check boxes available in “Select metrics” section are checked 
#	#- HTML table change dynamically
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#	#click Check All button in Select metrics
#		wait_for_element_present($func_table_tab["select_metrics_check_all"])
#		click $file_table_tab["select_metrics_check_all"]
#			assert is_checked("1_func_STCYC")
#			assert is_checked("1_func_STLIN")
#			assert is_checked("1_func_STMIF")
#			wait_for_element_text($func_table_tab["STCYC"],"STCYC")
#			wait_for_element_text($func_table_tab["STLIN"],"STLIN")
#			wait_for_element_text($func_table_tab["STMIF"],"STMIF")
#  end

#	def test_116
#	printf "\n+ Test 116"
#	#- Click "Uncheck All" button in "Select metrics" section
#	#- All check boxes available in “Select metrics” section are unchecked 
#	#- HTML table change dynamically
#	login_metric	
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#	#click Uncheck All button in Select metrics
#		wait_for_element_present($func_table_tab["select_metrics_uncheck_all"])
#		click $func_table_tab["select_metrics_uncheck_all"]
#		sleep WAIT_TIME
#			assert !is_checked("1_func_STCYC")
#			assert !is_checked("1_func_STLIN")
#			assert !is_checked("1_func_STMIF")
#			sleep WAIT_TIME
#			wait_for_text_present(_("According to your options, there is no information to display"))
#	end

#	def test_117
#	printf "\n+ Test 117"
#	#- Select metric names by checking check boxes 
#	#- HTML table change dynamically according to selected metrics
#	login_metric	
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#	#Uncheck STFNC radio button
#		wait_for_element_present($func_table_tab["STCYC"])
#		click $func_table_tab["STCYC_radio"]	
#	#Check STFNC radio button
#		click $func_table_tab["STCYC_radio"]	
#		assert is_checked("1_func_STCYC")
#	#HTML table display STFNC	normally
#	wait_for_element_text($func_table_tab["STCYC"],"STCYC")
#	end

#	def test_118
#	printf "\n+ Test 118"
#	#- Don't select any  metric name 
#	#- HTML table will disappear 
#	#- Pagination isn't displayed
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#	#Uncheck all metric
#	wait_for_element_present($func_table_tab["STCYC"])
#		click $func_table_tab["STCYC_radio"]	
#		click $func_table_tab["STLIN_radio"]	
#		click $func_table_tab["STMIF_radio"]
#		sleep WAIT_TIME
#	# HTML table disappear
#		assert !is_checked("1_func_STCYC")
#		assert !is_checked("1_func_STLIN")
#		assert !is_checked("1_func_STMIF")
#		sleep WAIT_TIME
#		wait_for_text_present(_("According to your options, there is no information to display"))	
#	end
#	
#	def test_119
#	printf "\n+ Test 119"
#	#- Click "Customize" button
#	#- a sub window "Metric Customize Window" will be displayed 
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#  #click Customize button
#  wait_for_element_present($func_table_tab["customize"])
#  	click $func_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#	end
#  
#	def test_120
#	printf "\n+ Test 120"
#  #- a sub window "Metric Customize Window" is displayed 
#	#- 2 buttons: "Check All" & "Uncheck All" in the top 
#	#- 2 buttons: “Ok” & “Cancel” in the bottom 
#	#- list all metrics & their meaning
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#  #click Customize button
#  wait_for_element_present($func_table_tab["customize"])
#  	click $func_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#  	wait_for_element_present($func_table_tab["customize_check_all"])
#		assert_equal "Check All", get_value($func_table_tab["customize_check_all"])
#		wait_for_element_present($func_table_tab["customize_uncheck_all"])
#		assert_equal "Uncheck All", get_value($func_table_tab["customize_uncheck_all"])
#		wait_for_element_present($func_table_tab["customize_ok"])
#		assert_equal "OK", get_value($func_table_tab["customize_ok"])
#		wait_for_element_present($func_table_tab["customize_cancel"])
#		assert_equal _("Cancel"), get_value($func_table_tab["customize_cancel"])
#  end
#    
#  def test_121
#  printf "\n+ Test 121"
#  #The check box which can be chosen is attached to the left-hand side of each metric
#  login_metric
#  #click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#	#click Customize button
#  wait_for_element_present($func_table_tab["customize"])
#  	click $func_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#  #Checkbox displayed
#		wait_for_element_present($func_table_tab["customize_count"])
#		metrics_count = get_xpath_count($func_table_tab["customize_count"])
#    1.upto(metrics_count) do |i|
#    	wait_for_element_present($func_table_tab["customize_count"] + "[" + i.to_s + "]" + "/input")
#  	end	
#  end
#  
#  def test_122
#  printf "\n+ Test 122"
#  #- The "Check All" button on a subwindow is clicked.
#	#- All check boxes are checked
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#	#click Customize button
#	wait_for_element_present($func_table_tab["customize"])
#	click $func_table_tab["customize"]
#		wait_for_element_present("customize_window_top")
#		wait_for_element_present($func_table_tab["customize_check_all"])
#		#click Check All button
#		click $func_table_tab["customize_check_all"]
#		checker_count = get_xpath_count($func_table_tab["customize_count"])
#    1.upto(checker_count) do |i|
#    	assert is_checked($func_table_tab["customize_count"] + "[" + i.to_s + "]" + "/input")
#    end
#  end
#  
#  def test_123
#  printf "\n+ Test 123"
#  #- The "Uncheck All" button on a subwindow is clicked
#	#- All check boxes are uncheked
#  login_metric
#  #click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#  	#click Customize button
#  	wait_for_element_present($func_table_tab["customize"])
#  	click $func_table_tab["customize"]
#		wait_for_element_present("customize_window_top")
#		wait_for_element_present($func_table_tab["customize_uncheck_all"])	
#		#click Uncheck All button
#      click $func_table_tab["customize_uncheck_all"]
#      checker_count = get_xpath_count($func_table_tab["customize_count"])
#      1.upto(checker_count) do |i|
#      	assert !is_checked($func_table_tab["customize_count"] + "[" + i.to_s + "]" + "/input")
#      end
#  end
#    
#  def test_124
#  printf "\n+ Test 124"
#  #- Some metrics are checked, and "Ok" button is clicked.
#	#- Corresponding check boxes are substituted for "Select metrics" section & they are checked 
#	#- HTML table change dynamically
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#  	#click Customize button
#  	wait_for_element_present($func_table_tab["customize"])
#  	click $func_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#  	wait_for_element_present($func_table_tab["customize_ok"])
#  	#check STAKI
#			wait_for_element_present($func_table_tab["new_STUNR_radio"])
#		  click $func_table_tab["new_STUNR_radio"]
#		  assert is_checked($func_table_tab["new_STUNR_radio"])
#  	#Click OK button  
#      click $func_table_tab["customize_ok"]
#	    wait_for_element_present($func_table_tab["STUNR_radio"])
#	    sleep WAIT_TIME
#	    assert is_checked("1_func_STUNR")
#	    wait_for_element_present($func_table_tab["STUNR"])
#  end  
#  
#  def test_125
#  printf "\n+ Test 125"
#  #- "Customize" button is again clicked following the above-mentioned operation, and a subwindow is displayed.
#	#- The corresponding check boxes currently checked in “Select metrics” section are checked
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#  	#click Customize button
#  	wait_for_element_present($func_table_tab["customize"])
#  	click $func_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#  	wait_for_element_present($func_table_tab["customize_ok"])
#  	#check STBME
#			wait_for_element_present($func_table_tab["new_STAKI_radio"])
#		  click $func_table_tab["new_STAKI_radio"]
#  	#Click OK button  
#      click $func_table_tab["customize_ok"]
#	    wait_for_element_present($func_table_tab["STAKI_radio"])
#	  #click Customize button
#  	wait_for_text_present(_("Select metrics"))
#  	click $func_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#  	#check STBME
#			wait_for_element_present($func_table_tab["new_STAKI_radio"])
#			assert is_checked($func_table_tab["new_STAKI_radio"])
#  end
#   
#  def test_126
#  printf "\n+ Test 126"
#  #- Do some operations(such as: check some check boxes), but finally click "Cancel" button
#	#- Nothing change in parent page(metric page)
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#  	#click Customize button
#  	wait_for_element_present($func_table_tab["customize"])
#  	click $func_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#  	wait_for_element_present($func_table_tab["customize_ok"])
#  	#check STBME
#			wait_for_element_present($func_table_tab["new_STAKI_radio"])
#		  click $func_table_tab["new_STAKI_radio"]
#  	#Click OK button  
#      click $func_table_tab["customize_ok"]
#	    wait_for_element_present($func_table_tab["STAKI_radio"])
#	  #click Customize button again
#  	wait_for_element_present($func_table_tab["customize"])
#  	click $func_table_tab["customize"]
#  	wait_for_element_present("customize_window_top")	
#  	#check STBME
#			wait_for_element_present($func_table_tab["new_STAKI_radio"])
#		  assert is_checked($func_table_tab["new_STAKI_radio"])
#		  click $func_table_tab["new_STAKI_radio"]
#  	#Click Cancel button  
#      click $func_table_tab["customize_cancel"]
#	    wait_for_element_present($func_table_tab["STAKI_radio"])
#			assert is_checked($func_table_tab["STAKI_radio"])
#  end 
#  
#  def test_127
#  printf "\n+ Test 127"
#  #- HTML table display
#	#- Header of table is class_name, item_name, analysis_tool_type, followed by metric name 
#	#- Each row of table represents one item(file, function or class) in metric list
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#  	wait_for_text_present(_("Metric HTML table"))
#   	#HTML table display
#  	wait_for_element_present($func_table_tab["file_name"])
#  	wait_for_element_present($func_table_tab["item_name"])
#  	wait_for_element_present($func_table_tab["analyze_tool"])
#  	wait_for_element_present($func_table_tab["STCYC"])
#  	wait_for_element_present($func_table_tab["STLIN"])
#  	wait_for_element_present($func_table_tab["STMIF"])
#  	#HTML row
#  	wait_for_element_present($func_table_tab["file_name_row_1"])
#  end  
#  
#  def test_128
#  printf "\n+ Test 128"
#  #- HTML table display
#	#- Values inside metric are the same with values from DB. If analysis tool has no value for that metric, it shall set to “”
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#  	wait_for_text_present(_("Metric HTML table"))
#   	wait_for_element_present($func_table_tab["file_name_row_1"])
#   	#Valid value
#  	metric_data = MetricData.new(1, "func")
#  	metric_value = metric_data.get_metric("STMIF")
#   	assert_equal get_text($func_table_tab["file_name_row_1_value"]).to_i, metric_value[1][5]
#  	assert_equal get_text($func_table_tab["file_name_row_2_value"]).to_i, metric_value[1][2]
#  end
#  
#  def test_129
#  printf "\n+ Test 129"
#  #- Dummy data is very large
#	#"- Show HTML table with extra conditions below 	+ Pagination is displayed"
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#  	wait_for_text_present(_("Metric HTML table"))
#  	#Paginating
#  	wait_for_element_text($func_table_tab["page_2"], "2")
#  end
#  
#  def test_130
#  printf "\n+ Test 130"
#  # - Modify data in DB, such as class_name... 
#	#- Corresponding data in table change according to data in DB  
#	#- Size of corresponding column in table change to fit with this changed data 
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#	wait_for_element_present($func_table_tab["data_change"])
#	assert_equal "103", get_text($func_table_tab["data_change"])
#  end
#  
#  def test_131
#  printf "\n+ Test 131"
#  #- Select one analysis tool 
#  #- Select metric names which don't belong to selected tool
#	#- Default value of these metric names is "" in HTML table
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#  #Uncheck QAC
#  wait_for_element_present($func_table_tab["QAC_radio"])
#  click  $func_table_tab["QAC_radio"]	
#  assert !is_checked($func_table_tab["QAC_radio"]	)
#  #Assert value in STMIF
#  sleep WAIT_TIME
#		wait_for_element_present($func_table_tab["file_name_row_1_value"])  
#		assert_equal 0, get_text($func_table_tab["file_name_row_1_value"]).to_i
#  end
#  
#  def test_132
#  printf "\n+ Test 132"
#  #- HTML table
#	#- By default, column “File Name” is used to provide the initial  descending sort 
#	#- This column is highlighted
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#  wait_for_element_present($func_table_tab["file_name"])
#	#default File name sort asc
#  	assert_equal "sortasc", get_attribute($func_table_tab["file_name"], "class")
#  end
#  
#  def test_133
#  printf "\n+ Test 133"
#  #- Click at header of each column
#	#- All items in this column will be re-arranged in descending order 
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#  	wait_for_text_present(_("Metric HTML table"))
#  #click header of STFNC column
#  wait_for_element_present($func_table_tab["STMIF"])
#		click	$func_table_tab["STMIF"] + "/a"
#		sleep WAIT_TIME
#		assert_equal "sortdesc", 	get_attribute($func_table_tab["STMIF"], "class")
#  end
#  
#  def test_134
#  printf "\n+ Test 134"
#  #- Click at header of above column again
#	#- All items in this column will be re-arranged in ascending order 
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#  	wait_for_text_present(_("Metric HTML table"))
#  #click header of STFNC column
#  wait_for_element_present($func_table_tab["STMIF"])
#		click	$func_table_tab["STMIF"] + "/a"
#		sleep WAIT_TIME
#		assert_equal "sortdesc", 	get_attribute($func_table_tab["STMIF"], "class")
#		click	$func_table_tab["STMIF"] + "/a"
#		sleep WAIT_TIME
#		assert_equal "sortasc", 	get_attribute($func_table_tab["STMIF"], "class")
#  end
#  
#  def test_135
#  printf "\n+ Test 135"
#  #- Remove the current sorting column from HTML table
#	#- By default, column “File Name” is used to provide the initial  descending sort 
#	login_metric
#	#click Func table tab
#  click $func_table_tab["link_to_func_table_tab"]
#  	wait_for_text_present(_("Metric HTML table"))
#  #click header of STFNC column
#  wait_for_element_present($func_table_tab["STMIF"])
#		click	$func_table_tab["STMIF"] + "/a"
#		sleep WAIT_TIME
#		assert_equal "sortdesc", 	get_attribute($func_table_tab["STMIF"], "class")
#	#uncheck STFNC metric
#	click 	$func_table_tab["STMIF_radio"]
#	wait_for_element_present($func_table_tab["file_name"])
#	#default File name sort asc
#  	assert_equal "sortasc", get_attribute($func_table_tab["file_name"], "class")
#	
#  end
#  
#  def test_136
#		printf "\n+ Test 136"
#		#-Click "CSV Down Load" button
#		#- Download the content of metric's table in CSV format
#		login_metric
#		#click Func table tab
#		click $func_table_tab["link_to_func_table_tab"]
#		#click download button
#		wait_for_element_present($func_table_tab["download_csv"])
#		click $func_table_tab["download_csv"]
#		sleep WAIT_TIME
#  end
#	
#	def test_137
#		printf "\n+ Test 137"
#		#-Click "CSV Down Load" button	
#		#- File is downloaded in CSV format
#		login_metric
#		#click Func table tab
#		click $func_table_tab["link_to_func_table_tab"]
#		#click download button
#		wait_for_element_present($func_table_tab["download_csv"])
#		click $func_table_tab["download_csv"]
#		sleep WAIT_TIME
#		printf "-	Test Failed! Selenium does not support to assert download of file"
#		assert false
#	end
#  
#  
#  #######################################################################
#  #      	 Function Metric Graph Tab Display (138 - 141)              	#
#  #######################################################################
#  #display of Function metric graph tab
#  #
  def test_138
    #test_000
    printf "\n+ Test 138"
    open_metric_tab($link_texts["metric_tab"][5])
    assert_equal _("Select metrics"),@selenium.get_text($xpath["metric"]["metric_pane_content"]+"/h3[1]")
    assert_equal _("Graph"),@selenium.get_text($xpath["metric"]["metric_pane_content"]+"/h3[2]")
    logout
  end
  # display of Function metric graph tab: select metric
  #
  def test_139
    #test_000
    printf "\n+ Test 139"
    open_metric_tab($link_texts["metric_tab"][5])
    assert(is_element_present($xpath["metric"]["customize_button"]))
    logout
  end
  # display of Function metric graph tab: graph of metric
  #
  def test_140
    #test_000
    printf "\n+ Test 140"
    open_metric_tab($link_texts["metric_tab"][5])
    assert(is_element_present($xpath["metric"]["redraw_graph_button"]))
    logout
  end
  # click on customize button, a subwindow display
  #
  def test_141
    #test_000
    printf "\n+ Test 141"
    open_metric_customize_subwindow($link_texts["metric_tab"][5])
    assert(is_text_present("Customize metrics"))
    logout
  end
#  ##########################################################################
#  ##		Function Metric Graph -  Metric Customize Window (142-149)   #
#  ##########################################################################
#  # open subwindow Metric Customize Window
#  # check view
#  #
  def test_142
    #test_000
    printf "\n+ Test 142"
    open_metric_customize_subwindow($link_texts["metric_tab"][5])
    assert(is_element_present($xpath["metric"]["check_all_button"]))
    assert(is_element_present($xpath["metric"]["uncheck_all_button"]))
    assert(is_element_present($xpath["metric"]["ok_button"]))
    assert(is_element_present($xpath["metric"]["cancel_button"]))
    total_checks=get_xpath_count($xpath["metric"]["sub_window_list"])
    (1..total_checks).each do |check_index|
      check_item_metric= $xpath["metric"]["sub_window_list"]+ "[#{check_index}]"+"/label"
      check_item_content= $xpath["metric"]["sub_window_list"]+ "[#{check_index}]"+"/em"
      assert_equal true,is_element_present(check_item_metric)
      assert_equal true,is_element_present(check_item_content)
    end
    logout
  end
  # open subwindow Metric Customize Window
  # check of check button
  #
  def test_143
    #test_000
    printf "\n+ Test 143"
    open_metric_customize_subwindow($link_texts["metric_tab"][5])
    total_checks=get_xpath_count($xpath["metric"]["sub_window_list"])
    (1..total_checks).each do |check_index|
      check_item_checkbox= $xpath["metric"]["sub_window_list"]+ "[#{check_index}]"+"/input[@type='checkbox']"
      check_item_metric= $xpath["metric"]["sub_window_list"]+ "[#{check_index}]"+"/label"
      check_item_content= $xpath["metric"]["sub_window_list"]+ "[#{check_index}]"+"/em"
      assert_equal true,is_element_present(check_item_checkbox)
      assert_equal true,is_element_present(check_item_metric)
      assert_equal true,is_element_present(check_item_content)
    end
    logout
  end
  # open subwindow
  # click "Check All" button
  # all check are checked
  #
  def test_144
    #test_000
    printf "\n+ Test 144"
    open_metric_customize_subwindow($link_texts["metric_tab"][5])
    ## check all item
    click "#{$xpath["metric"]["check_all_button"]}"
    sleep WAIT_TIME
    total_checks=get_xpath_count($xpath["metric"]["sub_window_list"])
    ## check checked or not
    (1..total_checks).each do |check_index|
      check_item_xpath= $xpath["metric"]["sub_window"]+ "/div[#{check_index}]"
      check_contents= @selenium.get_text(check_item_xpath)
      check_value=check_contents[0..4]
      if (check_value=="STCYC"||check_value=="STLIN"||check_value=="STMIF")
        assert true
      else
        assert_equal true,is_checked("//input[@value='#{check_value}']")
      end
    end
    p "Reloading fixtures. Please wait ..."
    system "rake db:fixtures:load"
    logout
  end
  # open subwindow
  # click "Uncheck All" button
  # all check are unchecked
  #
  def test_145
    #test_000
    printf "\n+ Test 145"
    open_metric_customize_subwindow($link_texts["metric_tab"][5])
    # uncheck all item
    click "#{$xpath["metric"]["uncheck_all_button"]}"
    sleep WAIT_TIME
    total_checks=get_xpath_count($xpath["metric"]["sub_window_list"])
    ## check unchecked or not
    (1..total_checks).each do |check_index|
      check_item_xpath= $xpath["metric"]["sub_window"]+ "/div[#{check_index}]"
      check_contents= @selenium.get_text(check_item_xpath)
      check_value=check_contents[0..4]
      assert_equal false,is_checked("//input[@value='#{check_value}']")
    end
    p "Reloading fixtures. Please wait ..."
    system "rake db:fixtures:load"
    logout
  end
  # check a random metric
  # click ok
  #
  def test_146
    #test_000
    printf "\n+ Test 146"
    check_random_metric($link_texts["metric_tab"][5])
    ## click ok
    click "#{$xpath["metric"]["ok_button"]}"
    run_script("destroy_subwindow()")
    sleep WAIT_TIME
    assert(is_text_present(@@check_random_value))
    p "Reloading fixtures. Please wait ..."
    system "rake db:fixtures:load"
    logout
  end
  # check a random metric
  # click ok
  #
  def test_147
    #test_000
    printf "\n+ Test 147"
    metric_strings=Array.new
    i=0
    open_metric_customize_subwindow($link_texts["metric_tab"][5])
    ## get total check item
    total_checks=get_xpath_count($xpath["metric"]["sub_window_list"])
    ## get a random value
    begin
      random_item=rand(total_checks-1)+1
      check_item_xpath=$xpath["metric"]["sub_window"]+ "/div[#{random_item}]"
      ## get content of value
      check_contents= @selenium.get_text(check_item_xpath)
      @@check_random_value=check_contents[0..4]
    end while (is_checked("//input[@value='#{@@check_random_value}']")==true)
    check("//input[@value='#{@@check_random_value}']")
    ## get string of checked item
    (1..total_checks).each do |check_index|
      check_item_xpath=$xpath["metric"]["sub_window"]+ "/div[#{check_index}]"
      # get content of value
      check_contents= @selenium.get_text(check_item_xpath)
      check_value=check_contents[0..4]
      if (is_checked("//input[@value='#{check_value}']")==true)
        metric_strings[i]= check_value
        i+=1
      end
    end
    ## click ok
    click "#{$xpath["metric"]["ok_button"]}"
    sleep WAIT_TIME
    ## check assert or not
    if i
      (1..i).each do |j|
        assert(is_text_present(metric_strings[j-1]))
      end
    end
    p "Reloading fixtures. Please wait ..."
    system "rake db:fixtures:load"
    logout
  end
  # click customize again
  # subwindow view
  #
  def test_148
    #test_000
    printf "\n+ Test 148"
    open_metric_tab($link_texts["metric_tab"][5])
    total_metrics=get_xpath_count($xpath["metric"]["metric_list"])
    total_metric_contents=Array.new
    (1..total_metrics).each do |i|
      temp_metric_content=@selenium.get_text($xpath["metric"]["metric_list"]+"[#{i}]")
      total_metric_contents[i]=temp_metric_content
    end
    sleep WAIT_TIME
    click "#{$xpath["metric"]["customize_button"]}"
    sleep WAIT_TIME
    total_checks=get_xpath_count($xpath["metric"]["sub_window_list"])
    metric_strings=Array.new
    i=1
    (1..total_checks).each do |check_index|
      check_item_xpath=$xpath["metric"]["sub_window"]+ "/div[#{check_index}]"
      ## get content of value
      check_contents= @selenium.get_text(check_item_xpath)
      check_value=check_contents[0..4]
      if (is_checked("//input[@value='#{check_value}']")==true)
        metric_strings[i]= check_contents
        i+=1
      end
    end
    if (total_metrics==i-1)
      (1..total_metrics).each do |j|
        assert_equal total_metric_contents[j],metric_strings[j]
      end
    end
    p "Reloading fixtures. Please wait ..."
    system "rake db:fixtures:load"
    logout
  end
  #     do something
  #     click cancel button
  #     nothing change
  
  def test_149
    #test_000
    printf "\n+ Test 149"
    open_metric_tab($link_texts["metric_tab"][5])
    file_metric_graph_old=@selenium.get_text($xpath["metric"]["metric_pane_content"])
    sleep WAIT_TIME
    click "#{$xpath["metric"]["customize_button"]}"
    sleep WAIT_TIME
    click "#{$xpath["metric"]["check_all_button"]}"
    sleep WAIT_TIME
    click "#{$xpath["metric"]["cancel_button"]}"
    sleep WAIT_TIME
    file_metric_graph_new=@selenium.get_text($xpath["metric"]["metric_pane_content"])
    assert_equal file_metric_graph_old,file_metric_graph_new
    logout
  end
#  #########################################################################
#  #	Function Metric Graph - Graph Metric Function (150-152)                  #
#  #########################################################################
#  #select one metric name
#  #click redraw button
#  #
  def test_150
    #test_000
    printf "\n+ Test 150"
    open_metric_tab($link_texts["metric_tab"][5])
    click ("#{$xpath["metric"]["redraw_graph_button"]}")
    sleep WAIT_TIME
    assert(is_element_present($xpath["metric"]["redraw_graph_view"]))
    ## selenium is not being able to test Flash/Flex/Silverlight or Java Applets
    logout
  end
  #select metric its type is string
  #
  def test_151
    #test_000
    printf "\n+ Test 151"
    metric_descriptions=MetricDescription.find(:all,
      :conditions => {:name => "STMCC"})
    metric_descriptions.each do |metric_description|
      metric_description.metric_type = 'Func'
      metric_description.save
    end
    metrics = Metric.find(:all,
      :conditions => {:name => "STMCC"}      )
    metrics.each do |metric|
      metric.metric_type= 'Func'
      metric.save
    end
    #
    open_metric_customize_subwindow($link_texts["metric_tab"][5])
    click ("#{$xpath["metric"]["check_all_button"]}")
    sleep WAIT_TIME
    click ("#{$xpath["metric"]["ok_button"]}")
    sleep WAIT_TIME
    check("//input[@value='STMCC']")
    sleep WAIT_TIME
    click ("#{$xpath["metric"]["redraw_graph_button"]}")
    sleep WAIT_TIME
    begin
      assert(is_text_present($messages["redraw_notice"]))
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    p "Reloading fixtures. Please wait ..."
    system "rake db:fixtures:load"
    logout
  end
  #request to download image Graph of metric
  #
  def test_152
    #test_000
    printf "\n+ Test 152"
    open_metric_tab($link_texts["metric_tab"][5])
    click ($xpath["metric"]["redraw_graph_button"])
    sleep WAIT_TIME
    @selenium.context_menu($xpath["metric"]["redraw_graph_view"])
    sleep WAIT_TIME
    assert true
    ##
    logout
  end
#  #########################################################################
#  #	Window Performance Test (153-154)                                     #
#  #########################################################################
#  #memory size<200mb
#  def test_153
#    printf "\n+ Test 153"
#    ## cannot assert memory size
#    assert true
#  end
#  #time of redraw graph <5s
#  def test_154
#    #test_000
#    printf "\n+ Test 154"
#    open_metric_tab($link_texts["metric_tab"][1])
#    click ("#{$xpath["metric"]["redraw_graph_button"]}")
#    sleep WAIT_TIME
#    assert(is_element_present($xpath["metric"]["redraw_graph_view"]))
#    ## open tab 4
#    click ("link=#{$link_texts["metric_tab"][3]}")
#    sleep WAIT_TIME
#    click ("#{$xpath["metric"]["redraw_graph_button"]}")
#    sleep WAIT_TIME
#    assert(is_element_present($xpath["metric"]["redraw_graph_view"]))
#    ## open tab 6
#    click ("link=#{$link_texts["metric_tab"][5]}")
#    sleep WAIT_TIME
#    click ("#{$xpath["metric"]["redraw_graph_button"]}")
#    sleep WAIT_TIME
#    assert(is_element_present($xpath["metric"]["redraw_graph_view"]))
#    logout
#  end
end
