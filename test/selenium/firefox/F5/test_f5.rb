require File.dirname(__FILE__) + "/test_f5_setup" unless defined? TestF5Setup
require "test/unit"

class TestF5 < Test::Unit::TestCase
  include TestF5Setup
  
  def setup
    @verification_errors = []
    if $selenium
      @selenium = $selenium
    else
      @selenium = Selenium::SeleniumDriver.new(SELENIUM_CONFIG)
      @selenium.start
    end
    
    if $lang = "en"
  	  @overall  = "Overall Analyze"
  	  @individual = "Individual Analyze"
  	elsif $lang = "ja"
  	  @overall  = "全体解析"
  	  @individual = "個人解析"
  	end  
  end
  
  def teardown
    @selenium.stop unless $selenium
    assert_equal [], @verification_errors
    write_log
  end
  
  def test_001
  	printf "\n+ Test 001	"
  	login_task_registration
  	#click registration task
  	wait_for_element_present($task_registration["registration_task"])
  	click $task_registration["registration_task"]
  	sleep WAIT_TIME
  	#sub window display
  	wait_for_text_present($task_registration["registration_title"])
  	wait_for_text_present(_("Task"))
  	wait_for_text_present(_("Master"))
  end
  
  def test_002
  	printf "\n+ Test 002	"
  	login_task_registration
  	#click registration task
  	wait_for_element_present($task_registration["registration_task"])
  	click $task_registration["registration_task"]
  	sleep WAIT_TIME
  	#not enough infomation. task can not register
  	wait_for_text_present($task_registration["can_not_register_message"])
  end
  
  def test_003
 		printf "\n+ Test 003	"
  	login_task_registration
  	#setting
  	type "task_name", "new_task"
  	type "qac_rule1", "9"
  	click "tool_qac"
  	click "normal"
  	#master tab
  	click "link=#{_("Master")}"
  	wait_for_element_present($task_registration["select_master"])
  	select $task_registration["select_master"], "label=sample_c_cpp"
  	#registration button displayed
  	wait_for_element_present($task_registration["registration_task"])
  end
  
  def test_004
  	printf "\n+ Test 004	"
  	login_task_registration
  	#setting
  	click "normal"
  	#register task
  	wait_for_element_present($task_registration["registration_task"])
  	click $task_registration["registration_task"]
  	sleep WAIT_TIME
  	#unselected analysis tool message displayed
  	wait_for_text_present($task_registration["can_not_register_message"])
  end
  
  def test_005
  	printf "\n+ Test 005	"
  	login_task_registration
  	#setting
  	click "tool_qac"
  	#register task
  	wait_for_element_present($task_registration["registration_task"])
  	click $task_registration["registration_task"]
  	sleep WAIT_TIME
  	#unselected analysis tool message displayed
  	wait_for_text_present($task_registration["rule_level_uncheck"])
  end
  
  def test_006
  	printf "\n+ Test 006	"
  	login_task_registration
  	#setting
  	click "tool_qac"
  	click "normal"
  	#register task
  	wait_for_element_present($task_registration["registration_task"])
  	click $task_registration["registration_task"]
  	sleep WAIT_TIME
  	#unselected analysis tool message displayed
  	wait_for_text_present($task_registration["rule_unsetting"])
  end
  
  def test_007
  	printf "\n+ Test 007	"
  	login_task_registration
  	#register task
  	wait_for_element_present($task_registration["registration_task"])
  	click $task_registration["registration_task"]
  	sleep WAIT_TIME
  	#no master
  	wait_for_text_present($task_registration["no_master"])
  end
  
  def test_008
  	printf "\n+ Test 008	"
  	login_task_registration
  	#setting
  	type "task_name", "new_task"
  	type "qac_rule1", "9"
  	click "tool_qac"
  	click "normal"
  	#master tab
  	click "link=#{_("Master")}"
  	wait_for_text_present(_("Master"))
  	wait_for_element_present($task_registration["select_master"])
  	select $task_registration["select_master"], "label=sample_c_cpp"
  	sleep WAIT_TIME
  	#register task
  	wait_for_element_present($task_registration["registration_task"])
  	click $task_registration["registration_task"]
  	sleep WAIT_TIME
  	#assert right contents
  	wait_for_text_present("new_task")
  	wait_for_text_present(_("QACsetting"))
  	wait_for_text_present(_("Normal"))
  	wait_for_text_present("9")
  end
  
  def test_009
  	printf "\n+ Test 009	"
  	login_task_registration
  	#setting
  	type "task_name", "new_task"
  	type "qac_rule1", "9"
  	click "tool_qac"
  	click "normal"
  	#master tab
  	click "link=#{_("Master")}"
  	wait_for_element_present($task_registration["select_master"])
  	select $task_registration["select_master"], "label=sample_c_cpp"
  	sleep WAIT_TIME
  	#register button
  	wait_for_element_present($task_registration["registration_task"])
  	click $task_registration["registration_task"]
  	sleep WAIT_TIME
  	#click registration button 
  	wait_for_element_present($task_registration["registration"])
  	click $task_registration["registration"]
  	sleep WAIT_TIME
  	#new task registered
  	wait_for_text_present($task_registration["new_task_registered"])
  	sleep WAIT_TIME
  	
  	#delete newtask
  	delete_newtask
  end
  
  def test_010
  	printf "\n+ Test 010	"
  	login_task_registration
  	#set individual type
  	select "analyze_type", "label=#{@individual}"
  	#click registration task
  	wait_for_element_present($task_registration["registration_task"])
  	click $task_registration["registration_task"]
  	sleep WAIT_TIME
  	#sub window display
  	wait_for_text_present($task_registration["registration_title"])
  	wait_for_text_present(_("Task"))
  	wait_for_text_present(_("Master"))
  	
  	#task can not register
  	wait_for_text_present($task_registration["individual_can_not_register_message"])
  end
  
  def test_011
  	printf "\n+ Test 011	"
  	login_task_registration
  	#set individual type
  	select "analyze_type", "label=#{@individual}"
  	#setting
  	type "task_name", "new_task"
  	type "qac_rule1", "9"
  	click "tool_qac"
  	click "normal"
   	#master tab
  	click "link=#{_("Master")}"
  	wait_for_element_present($task_registration["select_master"])
  	select $task_registration["select_master"], "label=sample_c_cpp"
  	sleep WAIT_TIME
  	#register button
  	wait_for_element_present($task_registration["registration_task"])
  	click $task_registration["registration_task"]
  	sleep WAIT_TIME
  	#task can not register
  	wait_for_text_present($task_registration["individual_can_not_register_message"])
  end
  
  def test_012
  	printf "\n+ Test 012	"
  	login_task_registration
  	#set individual type
  	select "analyze_type", "label=#{@individual}"
  	#setting
  	type "task_name", "new_task"
  	type "qac_rule1", "9"
  	click "tool_qac"
  	click "normal"
   	#master tab
  	click "link=#{_("Master")}"
  	wait_for_element_present($task_registration["select_master"])
  	select $task_registration["select_master"], "label=sample_c_cpp"
  	sleep WAIT_TIME
  	#register button
  	wait_for_element_present($task_registration["registration_task"])
  	click $task_registration["registration_task"]
  	sleep WAIT_TIME
  	#not file uploaded
  	wait_for_text_present($task_registration["no_upload_file"])
  end
  
  def test_013
  	reset_upload_file
  	printf "\n+ Test 013	"
  	login_task_registration
  	#setting
  	type "task_name", "new_task"
  	type "qac_rule1", "9"
  	click "tool_qac"
  	click "normal"
  	select "analyze_type", "label=#{@individual}"
  	#master tab
  	click "link=#{_("Master")}"
  	sleep WAIT_TIME
  	wait_for_element_present($task_registration["select_master"])
  	select $task_registration["select_master"], "label=sample_c_cpp"
  	#upload
  	wait_for_element_present($task_registration["upload_package"])
  	assert is_checked($task_registration["upload_package"])
  	type 'file_upload_uploaded_master', "/sample_c_all.tar.gz"
  	click $task_registration["upload_button"]
  	sleep WAIT_TIME
  	#register button
  	wait_for_element_present($task_registration["registration_task"])
  	click $task_registration["registration_task"]
  	sleep WAIT_TIME
  	
  	#sub window display
  	begin
  		wait_for_text_present(_("Existing"))
  		wait_for_element_present($task_registration["registration"])
  	rescue Exception => e
  		assert false
  	end
  end
  
  def test_014
  	reset_upload_file
  	printf "\n+ Test 014	"
  	login_task_registration
  	#setting
  	type "task_name", "new_task"
  	type "qac_rule1", "9"
  	click "tool_qac"
  	click "normal"
  	select "analyze_type", "label=#{@individual}"
  	#master tab
  	click "link=#{_("Master")}"
  	sleep WAIT_TIME
  	wait_for_element_present($task_registration["select_master"])
  	select $task_registration["select_master"], "label=sample_c_cpp"
  	#upload
  	wait_for_element_present($task_registration["upload_package"])
  	assert is_checked($task_registration["upload_package"])
  	type 'file_upload_uploaded_master', "/sample_c_all.tar.gz"
  	click $task_registration["upload_button"]
  	sleep WAIT_TIME
  	#register button
  	wait_for_element_present($task_registration["registration_task"])
  	click $task_registration["registration_task"]
  	sleep WAIT_TIME
  	#click registration button 
  	begin
  		wait_for_element_present($task_registration["registration"])
			click $task_registration["registration"]
			sleep WAIT_TIME
			#new task registered
			wait_for_text_present($task_registration["individual_task_registered"])
			sleep WAIT_TIME
  	rescue Exception => e
  		assert false
  	end
  	
  	#delete newtask
  	delete_newtask
  end
  
  def test_015
		reset_upload_file
  	printf "\n+ Test 015	"
  	login_task_registration
  	#setting
  	type "task_name", "new_task"
  	type "qac_rule1", "9"
  	click "tool_qac"
  	click "normal"
  	select "analyze_type", "label=#{@individual}"
  	#master tab
  	click "link=#{_("Master")}"
  	sleep WAIT_TIME
  	wait_for_element_present($task_registration["select_master"])
  	select $task_registration["select_master"], "label=sample_c_cpp"
  	#upload
  	wait_for_element_present($task_registration["upload_package"])
  	assert is_checked($task_registration["upload_package"])
  	wait_for_element_present($task_registration["upload_individual"])
  	click $task_registration["upload_individual"]
  	sleep WAIT_TIME
  	#register button
  	wait_for_element_present($task_registration["registration_task"])
  	click $task_registration["registration_task"]
  	sleep WAIT_TIME
  	#no file uploaded
  	wait_for_text_present($task_registration["no_upload_file"])
  end
  
  def test_016
  	printf "\n+ Test 016	"
  	#create sample master
  	create_master
  	
  	login_task_registration
  	#setting
  	type "task_name", "new_task"
  	type "qac_rule1", "9"
  	click "tool_qac"
  	click "normal"
  	select "analyze_type", "label=#{@individual}"
  	#master tab
  	click "link=#{_("Master")}"
  	sleep WAIT_TIME
  	#change master
  	wait_for_element_present($task_registration["select_master"])
  	select $task_registration["select_master"], "label=master_sample"
  	#upload
  	wait_for_element_present($task_registration["upload_package"])
  	assert is_checked($task_registration["upload_package"])
  	type 'file_upload_uploaded_master', "/sample_c_all.tar.gz"
  	click $task_registration["upload_button"]
  	sleep WAIT_TIME
  	#register button
  	wait_for_element_present($task_registration["registration_task"])
  	click $task_registration["registration_task"]
  	sleep WAIT_TIME
  	#sub window display
  	begin
  		wait_for_text_present(_("Existing"))
  		wait_for_element_present($task_registration["registration"])
  		#delele created sample master
  		Master.destroy(Master.last)
  	rescue Exception => e
  		#delele created sample master
  		Master.destroy(Master.last)
  		assert false
  	end
  end
  
  def test_017
  	reset_upload_file
  	printf "\n+ Test 017	"
  	login_task_registration
  	#setting
  	type "task_name", "new_task"
  	type "qac_rule1", "9"
  	click "tool_qac"
  	click "normal"
  	select "analyze_type", "label=#{@individual}"
  	#master tab
  	click "link=#{_("Master")}"
  	sleep WAIT_TIME
  	wait_for_element_present($task_registration["select_master"])
  	select $task_registration["select_master"], "label=sample_c_cpp"
  	#upload
  	wait_for_element_present($task_registration["upload_individual"])
  	click $task_registration["upload_individual"]
  	#dir tree
  	wait_for_element_present($task_registration["dir_tree"])
  	click $task_registration["dir_tree"]
  	sleep WAIT_TIME
  	wait_for_element_present($task_registration["sample_c_directory"])
  	click $task_registration["sample_c_directory"]
  	sleep WAIT_TIME
  	#upload file
  	type "replacement_3", "/test.tar.gz"
		wait_for_element_present($task_registration["upload_individual_button"])
		click $task_registration["upload_individual_button"]
  	sleep WAIT_TIME
  	#register button
  	wait_for_element_present($task_registration["registration_task"])
  	click $task_registration["registration_task"]
  	sleep WAIT_TIME
  	
  	#subwindow display
  	begin
  		wait_for_element_present($task_registration["registration"])
  	rescue Exception => e
  		assert false
  	end
  end
  
  def test_018
  	printf "\n+ Test 018	"
  	#create sample master
  	create_master
  	
  	login_task_registration
  	#setting
  	type "task_name", "new_task"
  	type "qac_rule1", "9"
  	click "tool_qac"
  	click "normal"
  	select "analyze_type", "label=#{@individual}"
  	#master tab
  	click "link=#{_("Master")}"
  	sleep WAIT_TIME
  	#change master
  	wait_for_element_present($task_registration["select_master"])
  	select $task_registration["select_master"], "label=master_sample"
  	#check individual
  	wait_for_element_present($task_registration["upload_individual"])
  	click $task_registration["upload_individual"]
  	sleep WAIT_TIME
  	#register button
  	wait_for_element_present($task_registration["registration_task"])
  	click $task_registration["registration_task"]
  	sleep WAIT_TIME
  	#no file uploaded
  	wait_for_text_present($task_registration["no_upload_file"])
  	
  	#delele created sample master
  	Master.destroy(Master.last)
  end
  
  def test_019
		reset_upload_file
 		printf "\n+ Test 019	"
  	login_task_registration
  	#setting
  	type "task_name", "new_task"
  	type "qac_rule1", "9"
  	click "tool_qac"
  	click "normal"
  	select "analyze_type", "label=#{@individual}"
  	#master tab
  	click "link=#{_("Master")}"
  	sleep WAIT_TIME
  	wait_for_element_present($task_registration["select_master"])
  	select $task_registration["select_master"], "label=sample_c_cpp"
  	#upload
  	wait_for_element_present($task_registration["upload_package"])
  	assert is_checked($task_registration["upload_package"])
  	sleep WAIT_TIME
  	#register button
  	wait_for_element_present($task_registration["registration_task"])
  	click $task_registration["registration_task"]
  	sleep WAIT_TIME
  	#no file uploaded
  	wait_for_text_present($task_registration["no_upload_file"])
  end
  
  def test_020
		reset_upload_file
  	printf "\n+ Test 020	"
  	login_task_registration
  	#setting
  	type "task_name", "new_task"
  	type "qac_rule1", "9"
  	click "tool_qac"
  	click "normal"
  	select "analyze_type", "label=#{@individual}"
  	#master tab
  	click "link=#{_("Master")}"
  	sleep WAIT_TIME
  	wait_for_element_present($task_registration["select_master"])
  	select $task_registration["select_master"], "label=sample_c_cpp"
  	#upload
  	wait_for_element_present($task_registration["upload_individual"])
  	click $task_registration["upload_individual"]
  	#dir tree
  	wait_for_element_present($task_registration["dir_tree"])
  	click $task_registration["dir_tree"]
  	sleep WAIT_TIME
  	wait_for_element_present($task_registration["sample_c_directory"])
  	click $task_registration["sample_c_directory"]
  	sleep WAIT_TIME
  	#upload file
  	type "replacement_3", "/test.tar.gz"
		wait_for_element_present($task_registration["upload_individual_button"])
		click $task_registration["upload_individual_button"]
  	sleep WAIT_TIME
  	#move to other tab
   	click "link=#{_("General Setting")}"
  	wait_for_text_present(_("General Setting"))
   	#register button
  	wait_for_element_present($task_registration["registration_task"])
  	click $task_registration["registration_task"]
  	sleep WAIT_TIME
  	
  	#subwindow display
  	begin
  		wait_for_element_present($task_registration["registration"])
  	rescue Exception => e
  		assert false
  	end
  end
  
  def test_021
		reset_upload_file
	 	printf "\n+ Test 021	"
  	login_task_registration
  	#setting
  	type "task_name", "new_task"
  	type "qac_rule1", "9"
  	click "tool_qac"
  	click "normal"
  	select "analyze_type", "label=#{@individual}"
  	#master tab
  	click "link=#{_("Master")}"
  	sleep WAIT_TIME
  	wait_for_element_present($task_registration["select_master"])
  	select $task_registration["select_master"], "label=sample_c_cpp"
  	#upload
  	wait_for_element_present($task_registration["upload_individual"])
  	click $task_registration["upload_individual"]
  	#dir tree
  	wait_for_element_present($task_registration["dir_tree"])
  	click $task_registration["dir_tree"]
  	sleep WAIT_TIME
  	wait_for_element_present($task_registration["sample_c_directory"])
  	click $task_registration["sample_c_directory"]
  	sleep WAIT_TIME
  	#upload file
  	type "replacement_3", "/test.tar.gz"
		wait_for_element_present($task_registration["upload_individual_button"])
		click $task_registration["upload_individual_button"]
  	sleep WAIT_TIME
  	#register button
  	wait_for_element_present($task_registration["registration_task"])
  	click $task_registration["registration_task"]
  	sleep WAIT_TIME
  	#click registration button 
  	begin
  		wait_for_element_present($task_registration["registration"])
			click $task_registration["registration"]
			sleep WAIT_TIME
			#new task registered
			wait_for_text_present($task_registration["individual_task_registered"])
			sleep WAIT_TIME
  	rescue Exception => e
  		assert false
  	end
  	
  	#delete newtask
  	delete_newtask
  end

	def test_022
		reset_upload_file
		printf "\n+ Test 022	"
  	login_task_registration
  	#setting
  	type "task_name", "new_task"
  	type "qac_rule1", "9"
  	click "tool_qac"
  	click "normal"
  	select "analyze_type", "label=#{@individual}"
  	#master tab
  	click "link=#{_("Master")}"
  	sleep WAIT_TIME
  	wait_for_element_present($task_registration["select_master"])
  	select $task_registration["select_master"], "label=sample_c_cpp"
  	#upload
  	wait_for_element_present($task_registration["upload_individual"])
  	click $task_registration["upload_individual"]
  	#dir tree
  	wait_for_element_present($task_registration["dir_tree"])
  	click $task_registration["dir_tree"]
  	sleep WAIT_TIME
  	wait_for_element_present($task_registration["sample_c_directory"])
  	click $task_registration["sample_c_directory"]
  	sleep WAIT_TIME
  	#upload file
  	type "replacement_3", "/test.tar.gz"
		wait_for_element_present($task_registration["upload_individual_button"])
		click $task_registration["upload_individual_button"]
  	sleep WAIT_TIME
  	#register button
  	wait_for_element_present($task_registration["registration_task"])
  	click $task_registration["registration_task"]
  	sleep WAIT_TIME
 		#click registration button 
 		begin
 			wait_for_element_present($task_registration["registration"])
			click $task_registration["registration"]
			sleep WAIT_TIME
			#new task registered
  		wait_for_text_present($task_registration["individual_task_registered"])
 		rescue Exception => e
 			assert false
 		end
 
 		#only replacement/file stored
 		open "task/add_task2/1/1" 
 		wait_for_text_present(_("General Setting"))
 		sleep WAIT_TIME
 		select "analyze_type", "label=#{@individual}"
 		click "link=#{_("Master")}"	
 		#upload
  	wait_for_element_present($task_registration["upload_individual"])
  	click $task_registration["upload_individual"]
  	#dir tree
  	wait_for_element_present($task_registration["dir_tree"])
  	click $task_registration["dir_tree"]
  	sleep WAIT_TIME
  	wait_for_element_present($task_registration["sample_c_directory"])
  	click $task_registration["sample_c_directory"]
  	sleep WAIT_TIME
  	#file stored
  	wait_for_element_present($task_registration["file_stored"])
  	assert_equal "test.tar.gz", get_text($task_registration["file_stored"])
  	
  	#reset
  	reset_upload_file
  	#delete newtask
  	delete_newtask
	end
	
end
