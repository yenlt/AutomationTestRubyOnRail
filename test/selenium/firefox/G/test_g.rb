require File.dirname(__FILE__) + "/test_g_setup" unless defined? TestGSetup
require "test/unit"

class TestG < Test::Unit::TestCase
  include TestGSetup
  
  def test_001
  	printf "\n+ Test 001	"
  	login_analytical_rule
		#selection qac normal
		wait_for_element_present($analytical_rule["qac_selection_normal"])  	
		click $analytical_rule["qac_selection_normal"]
		#load indicator displayed 
		str = get_attribute($analytical_rule["selection"], "onclick")
		indicator = str.include? "set_load_indicator"
		begin
			assert indicator
		rescue Exception => e
			printf "- Test Failed! Load indicator did not displayed"
			assert false
		end
  end
  
  def test_002
  	printf "\n+ Test 002	"
  	login_analytical_rule
		#selection qac normal
		wait_for_element_present($analytical_rule["qac_selection_normal"])  	
		click $analytical_rule["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($analytical_rule["analytical_rule_text"])
		run_script("destroy_subwindow()")
		#selection qac high
		wait_for_element_present($analytical_rule["qac_selection_high"])  	
		click $analytical_rule["qac_selection_high"]
		sleep WAIT_TIME
		wait_for_text_present($analytical_rule["analytical_rule_text"])
		run_script("destroy_subwindow()")
		#selection qac critical
		wait_for_element_present($analytical_rule["qac_selection_critical"])  	
		click $analytical_rule["qac_selection_critical"]
		sleep WAIT_TIME
		wait_for_text_present($analytical_rule["analytical_rule_text"])
		run_script("destroy_subwindow()")	
  end
  
  def test_003
 		printf "\n+ Test 003	"
 		login_analytical_rule
		#selection qac++ normal
		wait_for_element_present($analytical_rule["qac++_selection_normal"])  	
		click $analytical_rule["qac++_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($analytical_rule["analytical_rule_text"])
		run_script("destroy_subwindow()")
		#selection qac++ high
		wait_for_element_present($analytical_rule["qac++_selection_high"])  	
		click $analytical_rule["qac++_selection_high"]
		sleep WAIT_TIME
		wait_for_text_present($analytical_rule["analytical_rule_text"])
		run_script("destroy_subwindow()")
		#selection qac++ critical
		wait_for_element_present($analytical_rule["qac++_selection_critical"])  	
		click $analytical_rule["qac++_selection_critical"]
		sleep WAIT_TIME
		wait_for_text_present($analytical_rule["analytical_rule_text"])
		run_script("destroy_subwindow()")	  	
  end
  
  def test_004
  	printf "\n+ Test 004	"
  	login_analytical_rule
		#selection qac normal
		wait_for_element_present($analytical_rule["qac_selection_normal"])  	
		click $analytical_rule["qac_selection_normal"]
		sleep WAIT_TIME
		link_page_count = get_xpath_count($analytical_rule["link_page"])
    1.upto(link_page_count) do  |i|
      link_range = get_text($analytical_rule["link_page"] + "[" + i.to_s + "]")
      #link to each page
      click "link=#{link_range}"
      sleep WAIT_TIME
      #get xxx
  		xxx_range = get_text($analytical_rule["first_rule_number"])
  		#get yyy
  		if i == link_page_count
  			#yyy of last page
  			rule_count = get_xpath_count($analytical_rule["rule_list"])
  			last_rule  = ($analytical_rule["rule_list"] + "[" + rule_count.to_s + "]/td[2]")
   			yyy_range  = get_text(last_rule)
   		else
  			yyy_range  = get_text($analytical_rule["last_rule_number"])
  		end
  		#assert link range
  		assert_equal (xxx_range + "〜" + yyy_range), "#{link_range}"
    end
   		
  end
  
  def test_005
  	printf "\n+ Test 005	"
  	login_analytical_rule
  	#selection qac normal
		wait_for_element_present($analytical_rule["qac_selection_normal"])  	
		click $analytical_rule["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($analytical_rule["analytical_rule_text"])
		#no analytical rule checked
		wait_for_element_present($analytical_rule["check_rule"])
		check_count = get_xpath_count($analytical_rule["check_rule"])
		1.upto(check_count)	do  |i|
			rule = $analytical_rule["check_rule"]+ "["+i.to_s + $analytical_rule["rule_id"]
			assert !is_checked(rule)
		end  
		run_script("destroy_subwindow()")
  end
  
  def test_006
  	printf "\n+ Test 006	"
  	login_analytical_rule
  	#selection qac normal
		wait_for_element_present($analytical_rule["qac_selection_normal"])  	
		click $analytical_rule["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($analytical_rule["analytical_rule_text"])
		#no analytical rule checked
		wait_for_element_present($analytical_rule["check_rule"])
		rule = $analytical_rule["check_rule"] + "[1" + $analytical_rule["rule_id"]
		click rule
		assert is_checked(rule)
		run_script("destroy_subwindow()")
  end
  
  def test_007
  	printf "\n+ Test 007	"
  	login_analytical_rule
  	#setting rule is characters string
  	type "qac_rule1", "invalid"
		#selection qac normal
		wait_for_element_present($analytical_rule["qac_selection_normal"])  	
		click $analytical_rule["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($analytical_rule["analytical_rule_text"])
		#no analytical rule checked
		wait_for_element_present($analytical_rule["check_rule"])
		check_count = get_xpath_count($analytical_rule["check_rule"])
		1.upto(check_count)	do  |i|
			rule = $analytical_rule["check_rule"]+ "["+i.to_s + "]/td[2]"
			assert_not_equal "invalid", get_text(rule)
		end  
		run_script("destroy_subwindow()")
  end
  
  def test_008
  	printf "\n+ Test 008	"
  	login_analytical_rule
  	#setting rule = 0
  	type "qac_rule1", "8"
		#selection qac normal
		wait_for_element_present($analytical_rule["qac_selection_normal"])  	
		click $analytical_rule["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($analytical_rule["analytical_rule_text"])
		wait_for_element_present($analytical_rule["check_rule"])
		#rule number not displayed
		check_count = get_xpath_count($analytical_rule["check_rule"])
		1.upto(check_count)	do  |i|
			rule_number = $analytical_rule["check_rule"]+ "["+i.to_s + "]/td[2]"
			assert_not_equal "35", get_text(rule_number)
			#no analytical rule checked
			rule = $analytical_rule["check_rule"]+ "[" +i.to_s + $analytical_rule["rule_id"]
			assert !is_checked(rule)	
		end  
		run_script("destroy_subwindow()")
  end
  
  def test_009
  	printf "\n+ Test 009	"
  	login_analytical_rule
  	#setting rule
  	type "qac_rule1", "8"
  	#selection qac normal
		wait_for_element_present($analytical_rule["qac_selection_normal"])  	
		click $analytical_rule["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($analytical_rule["analytical_rule_text"])
		wait_for_element_present($analytical_rule["registration"])
		click $analytical_rule["registration"]
		wait_for_element_present($analytical_rule["qac_text_normal"])
		sleep WAIT_TIME
		begin
			assert_equal "", get_value("qac_rule1")
		rescue Test::Unit::AssertionFailedError
        printf "- Test Failed! " << $!
        assert false
		end
  end
  
  def test_010
  	printf "\n+ Test 010	"
  	login_analytical_rule
  	#selection qac normal
		wait_for_element_present($analytical_rule["qac_selection_normal"])  	
		click $analytical_rule["qac_selection_normal"]
		sleep WAIT_TIME
    link_page_count = get_xpath_count($analytical_rule["link_page"])
    1.upto(link_page_count) do  |i|
      link = get_text($analytical_rule["link_page"] + "[" + i.to_s + "]")
      #link to each page
      click "link=#{link}"
      sleep 2
      rule_list_count = get_xpath_count($analytical_rule["rule_list"])
      all_rules = []
      #get all rules
      1.upto(rule_list_count) do  |j|
        all_rules << get_text($analytical_rule["rule_list"]+ "[" + j.to_s + "]/td[2]")
      end
      #assert no dupicate
    	no_duplication_rules = all_rules.uniq
    	assert_equal no_duplication_rules, all_rules
    end
    
  end
  
  def test_011
  	printf "\n+ Test 011	"
  	login_analytical_rule
  	#selection qac normal
		wait_for_element_present($analytical_rule["qac_selection_normal"])  	
		click $analytical_rule["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_element_present($analytical_rule["rule_list"])
		#check rule
		click $analytical_rule["first_rule"]
		assert is_checked($analytical_rule["first_rule"])
		#link to other page
		click $analytical_rule["link_page"] + "[2]"
		sleep 2
		wait_for_text_present($analytical_rule["analytical_rule_text"])
		#back to first page
		click $analytical_rule["link_page"] + "[1]"
		sleep 2
		#rule still checked
		wait_for_element_present($analytical_rule["rule_list"])
		assert is_checked($analytical_rule["first_rule"])
  end
  
  def test_012
  	printf "\n+ Test 012	"
  	login_analytical_rule
		#selection qac normal
		wait_for_element_present($analytical_rule["qac_selection_normal"])  	
		click $analytical_rule["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($analytical_rule["analytical_rule_text"])
		wait_for_element_present($analytical_rule["check_button"])
		#click check button
		click $analytical_rule["check_button"]
		sleep WAIT_TIME
		#all checker checked
		check_count = get_xpath_count($analytical_rule["check_rule"])
		1.upto(check_count)	do  |i|
			rule = $analytical_rule["check_rule"]+ "[" +i.to_s + $analytical_rule["rule_id"]
			assert is_checked(rule)	
		end  
  end
  
  def test_013
  	printf "\n+ Test 013	"
  	login_analytical_rule
		#selection qac normal
		wait_for_element_present($analytical_rule["qac_selection_normal"])  	
		click $analytical_rule["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($analytical_rule["analytical_rule_text"])
		#check one rule
		wait_for_element_present($analytical_rule["first_rule"])
		click $analytical_rule["first_rule"]
		assert is_checked($analytical_rule["first_rule"])
		#click clear button
		wait_for_element_present($analytical_rule["clear_button"])
		click $analytical_rule["clear_button"]
		sleep WAIT_TIME
		#all checker unchecked
		check_count = get_xpath_count($analytical_rule["check_rule"])
		1.upto(check_count)	do  |i|
			rule = $analytical_rule["check_rule"]+ "[" +i.to_s + $analytical_rule["rule_id"]
			assert !is_checked(rule)	
		end  
  end
  
  def test_014
  	printf "\n+ Test 014	"
  	login_analytical_rule
		#selection qac normal
		wait_for_element_present($analytical_rule["qac_selection_normal"])  	
		click $analytical_rule["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($analytical_rule["analytical_rule_text"])
		#check one rule
		wait_for_element_present($analytical_rule["first_rule"])
		click $analytical_rule["first_rule"]
		assert is_checked($analytical_rule["first_rule"])
		#click is check all button
		wait_for_element_present($analytical_rule["is_check_all_button"])
		click $analytical_rule["is_check_all_button"]
		sleep WAIT_TIME
		#rest of checker will be checked
		link_page_count = get_xpath_count($analytical_rule["link_page"])
		1.upto(link_page_count) do  |i|
      link = get_text($analytical_rule["link_page"] + "[" + i.to_s + "]")
      #link to each page
      click "link=#{link}"
      sleep WAIT_TIME
      rule_list_count = get_xpath_count($analytical_rule["rule_list"])
			1.upto(rule_list_count)	do  |i|
				rule = $analytical_rule["check_rule"]+ "[" +i.to_s + $analytical_rule["rule_id"]
				assert is_checked(rule)	
			end  
		end	
  end
  
  def test_015
  	printf "\n+ Test 015	"
  	login_analytical_rule
		#selection qac normal
		wait_for_element_present($analytical_rule["qac_selection_normal"])  	
		click $analytical_rule["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($analytical_rule["analytical_rule_text"])
		#check one rule
		wait_for_element_present($analytical_rule["first_rule"])
		click $analytical_rule["first_rule"]
		assert is_checked($analytical_rule["first_rule"])
		#click is clear all button
		wait_for_element_present($analytical_rule["is_clear_all_button"])
		click $analytical_rule["is_clear_all_button"]
		sleep WAIT_TIME
		#rest of checker will be unchecked
		link_page_count = get_xpath_count($analytical_rule["link_page"])
		1.upto(link_page_count) do  |i|
      link = get_text($analytical_rule["link_page"] + "[" + i.to_s + "]")
      #link to each page
      click "link=#{link}"
      sleep WAIT_TIME
      rule_list_count = get_xpath_count($analytical_rule["rule_list"])
			1.upto(rule_list_count)	do  |i|
				rule = $analytical_rule["check_rule"]+ "[" +i.to_s + $analytical_rule["rule_id"]
				assert !is_checked(rule)	
			end 
		end	 
  end
  
  def test_016
  	printf "\n+ Test 016	"
  	login_analytical_rule
  	#selection qac normal
		wait_for_element_present($analytical_rule["qac_selection_normal"])  	
		click $analytical_rule["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($analytical_rule["analytical_rule_text"])
		#check one rule
		wait_for_element_present($analytical_rule["first_rule"])
		click $analytical_rule["first_rule"]
		#registration
		click $analytical_rule["registration"]
		wait_for_element_present($analytical_rule["qac_text_normal"])
		sleep WAIT_TIME
		#The checked analytical rule is stored in a text field
		assert_equal "9", get_value($analytical_rule["qac_text_normal"])
  end
  
  def test_017
  	printf "\n+ Test 017	"
  	login_analytical_rule
  	#selection qac normal
		wait_for_element_present($analytical_rule["default"])  
		click $analytical_rule["default"]
		assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
  end
  
  def test_018
  	printf "\n+ Test 018	"
  	login_analytical_rule
  	#setting rule
  	type "qac_rule1", "9"
  	#selection qac normal
		wait_for_element_present($analytical_rule["default"])  	
		choose_ok_on_next_confirmation
		click $analytical_rule["default"]
		assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
		sleep WAIT_TIME
		#reset to default setting
		wait_for_element_present($analytical_rule["qac_text_normal"])
		assert_equal "", get_value($analytical_rule["qac_text_normal"])
  end
  
  def test_019
 		printf "\n+ Test 019	"
  	login_analytical_rule
  	#setting rule
  	type "qac_rule1", "9"
  	#selection qac normal
		wait_for_element_present($analytical_rule["default"]) 
		choose_cancel_on_next_confirmation
		click $analytical_rule["default"] 	
		assert_equal _("Are you sure you want to restore to default setting?"), get_confirmation
		sleep WAIT_TIME
		#nothing change
		wait_for_element_present($analytical_rule["qac_text_normal"])
		assert_equal "9", get_value($analytical_rule["qac_text_normal"])
  end
  
  def test_020
  	printf "\n+ Test 020	"
  	login_analytical_rule
  	#selection qac normal
		wait_for_element_present($analytical_rule["qac_selection_normal"])  	
		click $analytical_rule["qac_selection_normal"]
		sleep WAIT_TIME
		wait_for_text_present($analytical_rule["analytical_rule_text"])
		#click is check all button
		wait_for_element_present($analytical_rule["is_check_all_button"])
		click $analytical_rule["is_check_all_button"]
		sleep WAIT_TIME
		#all rules checked
		link_page_count = get_xpath_count($analytical_rule["link_page"])
    all_rules = []
    #get all rules checked
    1.upto(link_page_count) do  |i|
      link = get_text($analytical_rule["link_page"] + "[" + i.to_s + "]")
      #link to each page
      click "link=#{link}"
      sleep WAIT_TIME
      rule_list_count = get_xpath_count($analytical_rule["rule_list"])
		  1.upto(rule_list_count) do  |j|
		    all_rules << get_text($analytical_rule["rule_list"]+ "[" + j.to_s + "]/td[2]")
		  end
		end  

		#registration
		click $analytical_rule["registration"]
		wait_for_element_present($analytical_rule["qac_text_normal"])
		sleep WAIT_TIME
		#all rules checked displayed 
		checked_rules = []
		checked_rules = get_value("qac_rule1").split(',')
    assert_equal all_rules, checked_rules    
  end

  def test_021
  	printf "\n+ Test 021	"
  	#login to task refistration page
  	login_task_registration
  	3.step(5,2)	do  |i|
			1.upto(3)	do  |j|
				selection_link	=	$task_registration["selection_link"].sub("_ROW_", i.to_s).sub("_COL_", j.to_s)
				wait_for_element_present(selection_link)
				#link to rule setting sub window
				click selection_link		
				#click is check all button
				wait_for_element_present($task_registration["is_check_all_button"])
				click $task_registration["is_check_all_button"]
				sleep WAIT_TIME
				#registration
				click $task_registration["register_task"]
				sleep WAIT_TIME																													
			end
  	end
  	  	
 		sleep WAIT_TIME
  	#setting
  	type "task_name", "new_task"
  	#check tool and level 	
  	#qac
  	click "tool_qac"
  	click "normal"
  	click "high"
  	click "critical"
  	sleep WAIT_TIME
  	#qac++
  	click "tool_qacpp"
  	click $task_registration["qac++_normal"]
  	click $task_registration["qac++_high"]
  	click $task_registration["qac++_critical"]
  	sleep WAIT_TIME
  	#master tab
  	click "link=#{_("Master")}"
  	sleep WAIT_TIME
  	wait_for_element_present($task_registration["select_master"])
  	select $task_registration["select_master"], "label=sample_c_cpp"
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
  	
  	#get new task id
  	task = Task.find(:last)
  	#return task detail page
  	new_task = $task_detail["new_task_id"].sub("_NEW_TASK_", task.id.to_s)
  	wait_for_element_present(new_task)
  	click new_task
  	sleep WAIT_TIME
  	wait_for_text_present($task_detail["task_detail_title"])
  	#set up rule displayed
  	#qac
  	wait_for_element_present($task_detail["qac_rule"])
  	assert_equal "normal", get_text($task_detail["qac_rule"] + "[1]")
  	assert_equal "high", get_text($task_detail["qac_rule"] + "[2]")
  	assert_equal "critical", get_text($task_detail["qac_rule"] + "[3]")
  	#qac++
  	wait_for_element_present($task_detail["qac++_rule"])
  	assert_equal "normal", get_text($task_detail["qac++_rule"] + "[1]")
  	assert_equal "high", get_text($task_detail["qac++_rule"] + "[2]")
  	assert_equal "critical", get_text($task_detail["qac++_rule"] + "[3]")
  	
  	#reset
  	Task.destroy(:last)
  end

end
