require File.dirname(__FILE__) + "/test_f3_setup" unless defined? TestF3Setup
require "test/unit"

class TestF3 < Test::Unit::TestCase
  include TestF3Setup
  
 def test_001
  	printf "\n+ Test 001	"
  	login_tool_setting
  	#click selection box
  	wait_for_element_present($tool_setting["selection_box"])
  	select "tool_name", "label=qacpp"
  	sleep WAIT_TIME
    qacpp = "qacpp "+ _("setting")
  	assert_equal qacpp, get_text($tool_setting["bold_text"])
  	select "tool_name", "label=qac"
  	sleep WAIT_TIME
    qac = "qac "+ _("setting")
  	assert_equal qac, get_text($tool_setting["bold_text"])
  end
  
 def test_002
  	printf "\n+ Test 002	"
  	login_tool_setting
  	#set up
  	sleep WAIT_TIME
  	type "make_options", "QAC"
    type "environment_variables", "QAC"
    type "header_file_at_analyze", "QAC"
    type "analyze_tool_config", "QAC"
    type "others", "QAC"
    #saved setting
		click  $tool_setting["save_setting"]
		wait_for_text_present($tool_setting["saved_message"])
  end

 def test_003
 		printf "\n+ Test 003	"
  	login_tool_setting
  	#set up
  	type "make_options", "edited_1"
    type "environment_variables", "edited_2"
    type "header_file_at_analyze", "edited_3"
    type "analyze_tool_config", "edited_4"
    type "others", "edited_5"
    #change tab
    click "link=#{_('General Setting')}"
    wait_for_text_present(_("Basic Setting"))
    #return tool setting. edited data displayed
    wait_for_text_present(_("Analysis Tool Setting"))
    click "link=#{_('Analysis Tool Setting')}"
    wait_for_text_present("edited_1")
    wait_for_text_present("edited_2")
    wait_for_text_present("edited_3")
    wait_for_text_present("edited_4")
   	wait_for_text_present("edited_5")
    #click registraion task button
    wait_for_element_present($tool_setting["registration_task"])
    click $tool_setting["registration_task"]
    sleep WAIT_TIME
    #return
    sub_window_close = get_attribute($tool_setting["registration_task_close"], "id")
    click "//div[@id=\'"+ sub_window_close + "_close\']"
    #edited data displayed
    wait_for_text_present("edited_1")
    wait_for_text_present("edited_2")
    wait_for_text_present("edited_3")
    wait_for_text_present("edited_4")
    wait_for_text_present("edited_5")
  end

 def test_004
  	printf "\n+ Test 004	"
  	login_tool_setting
  	4.step(16, 3)	do  |i|
    	default = $tool_setting["default_link"].sub("_ROW_INDEX_", i.to_s)
			#click defautl link
			wait_for_element_present(default)
			click default
			#dialog display
			assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
			choose_cancel_on_next_confirmation
		  sleep WAIT_TIME
	 	end

  end

 def test_005
  	printf "\n+ Test 005	"
  	login_tool_setting
  	#set up
  	type "make_options", "edited_1"
  	type "environment_variables", "edited_2"
    type "header_file_at_analyze", "edited_3"
    type "analyze_tool_config", "edited_4"
    type "others", "edited_5"
    4.step(16, 3)	do  |i|
    	default = $tool_setting["default_link"].sub("_ROW_INDEX_", i.to_s)
			#click defautl link
			wait_for_element_present(default)
			click default
			#dialog display
			assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
			choose_ok_on_next_confirmation
		  sleep WAIT_TIME
		  #assert default data
		  wait_for_element_present($tool_setting["make_options_text"])
		  wait_for_element_present($tool_setting["environment_text"])
		  wait_for_element_present($tool_setting["header_file_text"])
		  wait_for_element_present($tool_setting["analyze_tool_text"])
		  wait_for_element_present($tool_setting["others_text"])
		  #default data = ""
		  assert_equal "", get_text($tool_setting["make_options_text"])
		  assert_equal "", get_text($tool_setting["environment_text"])
		  assert_equal "", get_text($tool_setting["header_file_text"])
		  assert_equal "", get_text($tool_setting["analyze_tool_text"])
		  assert_equal "", get_text($tool_setting["others_text"])
  	end

  end
  
 def test_006
  	printf "\n+ Test 006	"
  	login_tool_setting
  	#set up
  	type "make_options", "edited_1"
    #change tab
    click "link=#{_('General Setting')}"
    wait_for_text_present(_("Basic Setting"))
    #return tool setting. edited data displayed
    wait_for_text_present(_("Analysis Tool Setting"))
    click "link=#{_('Analysis Tool Setting')}"
    wait_for_text_present("edited_1")
    #click save setting
    click  $tool_setting["save_setting"]
		wait_for_text_present($tool_setting["saved_message"])
  end

 def test_007
  	printf "\n+ Test 007	"
  	login_tool_setting
  	#set up
  	type "make_options", "edited_1"
  	open "/misc"
  	wait_for_text_present(_("User Page"))
  	open "/task/add_task2/1/1"
  	wait_for_text_present(_("Basic Setting"))
  	#return tool setting tab
  	wait_for_text_present(_("Analysis Tool Setting"))
    click "link=#{_('Analysis Tool Setting')}"
    #data reset
    wait_for_element_present($tool_setting["make_options_text"])
    assert_equal "", get_text($tool_setting["make_options_text"])
  end

 def test_008
  	printf "\n+ Test 008	"
  	login_tool_setting
  	bytes = 0
  	begin
  		0.step(65535, 221) do  |i|
				#make data size
				type "make_options", "i"*i
				type "environment_variables", "i"*i
				type "header_file_at_analyze", "i"*i
				type "analyze_tool_config", "i"*i
				type "others", "i"*i
				bytes = i
  		end
  		#save setting
		  click  $tool_setting["save_setting"]
			wait_for_text_present($tool_setting["saved_message"])
			#change tab
			click "link=#{_('General Setting')}"
		  wait_for_text_present("Basic Setting")
		  #return tool setting. edited data displayed
		  wait_for_text_present(_("Analysis Tool Setting"))
		  click "link=#{_('Analysis Tool Setting')}"
		  #text displayed
		  wait_for_text_present(get_text($tool_setting["make_options_text"]))
		  wait_for_text_present(get_text($tool_setting["others_text"]))
  	rescue Exception => e
  		printf "- Test Failed. Input data only save " + (bytes).to_s + "bytes for each setting item"
  		assert false
  	end

  end
 
end
