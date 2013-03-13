require File.dirname(__FILE__) + "/../../../test_helper" unless defined? ENV["RAILS_ENV"]
require File.dirname(__FILE__) + "/../../config/selenium_setup" unless defined? SeleniumSetup
unless defined?(TestWDSetup)
  module TestWDSetup
    include SeleniumSetup
    include GetText
LOAD_TIME               = "60000"
SLEEP_TIME              = 10
PJ_MEMBER_USER          = "pj_member"
PJ_MEMBER_PASSWORD      = "pj_member"
NONE_PJ_MEMBER_USER     = "pj_member2"
NONE_PJ_MEMBER_PASSWORD = "pj_member2"
PU_ADMIN_USER           = "pu_admin"
PU_ADMIN_PASSWORD       = "pu_admin"
PJ_ADMIN_USER           = "pj_admin"
PJ_ADMIN_PASSWORD       = "pj_admin"
ERROR_DIFF_ID           = 100
RIGHT_KEYWORD = "0288"
WRONG_KEYWORD = "wrong_keyword"
SPECIAL_KEYWORD = "spe\'ci\"al\\"
REGULAR_KEYWORD = "*"


$diff_administration = {
  "title"                   =>  _("Diff Administration"),
  "new_version_field_name"  =>  _("Select new version"),
  "old_version_field_name"  =>  _("Select old version"),
  "select_analysis_tool"    =>  _("Select Analysis Tool"),
  "link_to_result"          =>  _("Link to Result:"),
  "recent_diff_result"      =>  _("Recent Diff Result"),
  "recent_diff_result_head1"  =>  [ _("Action"),
                                    _("Result"),
                                    _("New"),
                                    _("Old")  ],
  "recent_diff_result_head2"  =>  [ "PU",
                                    "PJ",
                                    _("Task Name"),
                                    _("Analysis Tool"),
                                    _("Date")],
  "no_result_yet"             =>  _("No result yet"),
  "error_message"             =>  _("Setting for diff is not valid"),
  "success_message"           =>  _("Executing diff successful!"),
  "diff_result"               =>  _("Diff Result"),
  "diff_result_title"         =>  _("Diff Result Summary"),
  "delete_message"            =>  _("Delete result successful!"),
  "delete_confirm"            =>  _("Are you sure you want to delete the diff result?")

}

$warning_diff = {
	"summary_warning_file" =>"#{_('Summary of Warning')}(analyzeme.c)",
	"summary_warning_directory" =>"#{_('Summary of Warning')}(sample_c/src)",
	"diff_summary" => _("Diff Result Summary"),
	"diff_admin" => _("Diff Administration"),
	"diff_status" => _("Diff status"),
	"rule_level" => _("Rule level"),
	"other_condition" => _("Other_condition"),
	"warning_listing_text" => _("Warning Listing with Diff"),
  "download_csv_button" => _("Download CSV Format"),
	"analysis_report" => _("Analysis Result Report with Diff"),
	"pagination_text" => _("« Previous")

}

$warning_diff_xpath = {
	"warning_listing_button" => "//div[@id='filter_setting']/table[1]/tbody/tr[1]/td[1]/form/div/input",
	"download_csv_button" => "//div[@id='filter_setting']/table[1]/tbody/tr[1]/td[2]/input",
	"diff_status_combo" => "//div[@id='filter_setting']/table[2]/tbody/tr[2]/td[1]/select",
	"rule_level_combo" => "//div[@id='filter_setting']/table[2]/tbody/tr[2]/td[2]/select",
	"other_condition_combo" => "//div[@id='filter_setting']/table[2]/tbody/tr[2]/td[3]/select",
	"filter_textbox" => "//div[@id='filter_setting']/table[2]/tbody/tr[2]/td[4]/input",
	"filtering_button" => "//div[@id='filter_setting']/table[2]/tbody/tr[2]/td[5]/input",
	"link_to_directory" => "//table[@class='warning_table']/tbody/tr[1]/td[1]",
	"link_to_file" => "//table[@class='warning_table']/tbody/tr[1]/td[2]",
	"link_sort_rule_number" => "//table[@class='warning_table']/thead/tr[1]/th[5]",
	"link_sort_directory" => "//table[@class='warning_table']/thead/tr[1]/th[1]",
	"link_sort_source_name" => "//table[@class='warning_table']/thead/tr[1]/th[2]",
	"link_sort_rule_level" => "//table[@class='warning_table']/thead/tr[1]/th[3]",
	"link_sort_task_name" => "//table[@class='warning_table']/thead/tr[1]/th[4]",
	"link_sort_diff_status" => "//table[@class='warning_table']/thead/tr[1]/th[7]",
	"link_to_diff_result" => "//table[@class='warning_table']/tbody[2]/tr[1]/td[2]",
	"link_to_file_report" => "//table[@class='warning_table']/tbody/tr[1]/td[2]",
	"link_to_directory_report" => "//table[@class='warning_table']/tbody[2][@id='file_list']/tr[1]/td[1]",
	"table_header"  =>  "//table[@class='warning_table']/thead/tr/th[__INDEX__]",
	"diff_status_combo_index" => "//div[@id='filter_setting']/table[2]/tbody/tr[2]/td[1]/select/option[__DINDEX__]",
	"rule_level_combo_index" => "//div[@id='filter_setting']/table[2]/tbody/tr[2]/td[2]/select/option[__RINDEX__]",
	"other_condition_combo_index" => "//div[@id='filter_setting']/table[2]/tbody/tr[2]/td[3]/select/option[__OINDEX__]",
	"row" => "//table[@class='warning_table']/tbody/tr",
	"row_rule_number" => "//table[@class='warning_table']/tbody/tr[__SINDEX__]/td[5]",
	"pagination" => "//div/div[@id='page_links']/div[@class='pagination']",
	"navi_area" => "//div[@id='navi_area']/div[@id='navi']",
	"link_to_analysis_report" => "//table[@class='warning_table']/tbody[@id='warning_file_summary']/tr[1][@class='common']/td[2]"

}
#No result yet

$diff_administration_xpath = {
  "menu_link"       =>  "//div[@id = 'menu']/ul/li[4]/a",
  "new_pu_select"   =>  "//select[@id = 'new_pu']",
  "new_pj_select"   =>  "//select[@id = 'new_pj']",
  "new_task_select" =>  "//select[@id = 'new_task']",
  "old_pu_select"   =>  "//select[@id = 'old_pu']",
  "old_pj_select"   =>  "//select[@id = 'old_pj']",
  "old_task_select" =>  "//select[@id = 'old_task']",
  "analysis_tool_select"      =>  "//input[@name = 'tool\[toolid\]']",
  "execute_diff_button"       =>  "//input[@id = 'execute_diff_btn']",
  "recent_diff_result_head1"  =>  "//table[@class= 'warning_table']/tbody/tr/th[__INDEX__]",
  "recent_diff_result_head2"  =>  "//table[@class= 'warning_table']/tbody/tr[2]/th[__INDEX__]/a",
  "qac"                       =>  "//input[@id = 'tool_toolid_1']",
  "qacpp"                     =>  "//input[@id = 'tool_toolid_2']",
  "recent_diff_result_row"    =>  "//div[@id = 'recent_table']/div/table/tbody[2]/tr",
  "diff_result"               =>  "//div[@id='link_to_result']/a",
  "wait_element"              =>  "//div[@class = 'waiting']",
  "delete_link1"              =>  "//table[@class = 'warning_table']/tbody[2]/tr/td/a",
  "diff_link1"                =>  "//table[@class = 'warning_table']/tbody[2]/tr/td[2]/a",
}
$diff_result_summary = {#"#{_('Analysis result report')} (__FILE_NAME__)"
  "error_message"   => "#{_("Diff Result (id = ")}__INDEX__) #{_("not found!")}",
  #15:59:41 結果 (id=100) が見つかりません。
  #"結果 (id= ( 100)が見つかりません。"

  "title"           =>  _("Diff Result Summary"),
  "all_table"       =>  [ _("Path"),
                          _("Common: Critical"),
                          _("Added: Critical"),
                          _("Deleted: Critical"),
                          _("Common: HiRisk"),
                          _("Added: HiRisk"),
                         _("Deleted: HiRisk"),
                          _("Common: Normal"),
                          _("Added: Normal"),
                          _("Deleted: Normal")],
  "file_table"      =>  [ _("Path"),
                          _("Source"),
                          _("Common: Critical"),
                          _("Added: Critical"),
                          _("Deleted: Critical"),
                          _("Common: HiRisk"),
                          _("Added: HiRisk"),
                          _("Deleted: HiRisk"),
                          _("Common: Normal"),
                          _("Added: Normal"),
                          _("Deleted: Normal")],
  "all_table_header"        =>  _("All"),
  "module_table_header"     =>  _("Each Modules"),
  "file_table_header"       =>  _("Each Files"),
  "summary_page_title"      =>  "#{_('Summary of Warning')}(__INDEX__)"
}
$diff_result_summary_xpath = {
  "all_table_header"        =>  "//div[@id = 'all']/table/tbody/tr/th",
  "module_table_header"     =>  "//div[@id = 'module']/table/tbody/tr/th",
  "file_table_header"       =>  "//div[@id = 'file']/table/tbody/tr/th",
  "module_link"             =>  "//div[@id = 'module']/table/tbody[2]/tr/td/a",
  "directory_link"          =>  "//div[@id = 'file']/table/tbody[2]/tr/td/a",
  "file_link"               =>  "//div[@id = 'file']/table/tbody[2]/tr/td[2]/a",
}

$warning_listing = {
  "title"                   => _("Warning Listing with Diff")
}

$warning_listing_xpath = {
  #download button
  "download"                => "//div[@id='filter_setting']/table[1]/tbody/tr/td/input[@value='Download CSV Format']",
  #filter
  "status_condition"        => "//div[@id='filter_setting']/table[2]/tbody/tr[1]/th[1]",
  "rule_level_condition"    => "//div[@id='filter_setting']/table[2]/tbody/tr[1]/th[2]",
  "other_condition"         => "//div[@id='filter_setting']/table[2]/tbody/tr[1]/th[3]",
  "select_status"           => "//select[@id='status']",
  "select_rule_level"       => "//select[@id='rule_level']",
  "select_other"            => "//select[@id='others']",
  "other_text"              => "//input[@id='others_value']",
  "filter_button"           => "//input[@id='filtering_btn']",
  #warning table
  #header
  "header_id"               => "//div[@id='warning_listing_table']/table/thead/tr/th[1]",
  "header_directory"        => "//div[@id='warning_listing_table']/table/thead/tr/th[2]",
  "header_source_name"      => "//div[@id='warning_listing_table']/table/thead/tr/th[3]",
  "header_rule_level"       => "//div[@id='warning_listing_table']/table/thead/tr/th[4]",
  "header_task"             => "//div[@id='warning_listing_table']/table/thead/tr/th[5]",
  "header_line"             => "//div[@id='warning_listing_table']/table/thead/tr/th[6]",
  "header_character"        => "//div[@id='warning_listing_table']/table/thead/tr/th[7]",
  "header_rule_number"      => "//div[@id='warning_listing_table']/table/thead/tr/th[8]",
  "header_message"          => "//div[@id='warning_listing_table']/table/thead/tr/th[9]",
  "header_code"             => "//div[@id='warning_listing_table']/table/thead/tr/th[10]",
  "header_status"           => "//div[@id='warning_listing_table']/table/thead/tr/th[11]",
  "count_row"               => "//tbody[@id='warning_list_with_diff']/tr",
  #row
  "link_directory"          => "//tbody[@id='warning_list_with_diff']/tr[1]/td[2]/a",
  "link_source"             => "//tbody[@id='warning_list_with_diff']/tr[1]/td[3]/a",
  "rule_level_cell"         => "//tbody[@id='warning_list_with_diff']/tr[__ROW__]/td[4]",
  "rule_number_cell"        => "//tbody[@id='warning_list_with_diff']/tr[__ROW__]/td[8]",
  "status_cell"             => "//tbody[@id='warning_list_with_diff']/tr[__ROW__]/td[11]",
  #navigation bar
  "navi_link"               => "//div[@id='navi_area']/div[@id='navi']/a[__ROW__]"

}

$analysis_report = {
  "title"                   => _("Analysis Result Report with Diff")
}

$analysis_report_xpath = {
  #header
  "new_file"                => "//div[@id='main_area']/table/tbody/tr[1]/td[1]/h3",
  "old_file"                => "//div[@id='main_area']/table/tbody/tr[1]/td[2]/h3",
  "new_contents"            => "//tbody[@id='new_version']/tr",
  "old_contents"            => "//tbody[@id='old_version']/tr",
  #warning status
  "common"                  => "//tbody[@id='new_version']/tr[]/td",
  "added"                   => "//tbody[@id='new_version']/tr[@class='added']/td",
  "deleted"                 => "//tbody[@id='old_version']/tr[@class='deleted']/td",
  #button
  "warning_listing"         => "//input[@value = '#{_('Warning Listing')}']",
  "summary"                 => "//input[@value='#{_('Summary')}']",
  #checkbox
  "check_common"            => "//input[@id='Common']",
  "check_added"             => "//input[@id='Added']",
  "check_deleted"           => "//input[@id='Deleted']",
  "hide_text"               => "//div[@id='filter_setting']/table/tbody/tr[4]/td[COL]",
  #filter
  "status_condition"        => "//div[@id='filter_setting']/table/tbody/tr[3]/td[1]",
  "other_condition"         => "//div[@id='filter_setting']/table/tbody/tr[3]/td[2]",
  "select_rule_level"           => "//select[@id='rule_level']",
  "select_other"            => "//select[@id='others']",
  "other_text"              => "//input[@id='others_value']",
  "filter_button"           => "//input[@id='filtering_btn']",
  #navigation
  "navi_link"               => "//div[@id='navi_area']/div[@id='navi']/a[__ROW__]"
}

$warning_diff_table = {
  "1" =>  _("Directory"),
  "2" =>  _("Source Name"),
  "3" =>  _("Rule Level"),
  "4" =>  _("Task Name"),
  "5" =>  _("Rule Number"),
  "6" =>  _("Warning Message"),
  "7" =>  _("Diff Status"),
  "8" =>  _("Frequency")

}

$diff_status = {
	"1" => _("All"),
	"2" => _("Common"),
	"3" => _("Added"),
	"4" => _("Deleted")
}

$rule_level = {
	"1" => _("All"),
	"2" => "Critical",
	"3" => "HiRisk",
	"4" => "Normal"
}

$other_condition = {
	"1" => "",
	"2" => _("Rule Number"),
	"3" => _("Source Name")
}


    #
    def open_diff_administration_page
      login("root","root")
      sleep SLEEP_TIME
      assert @selenium.is_element_present($diff_administration_xpath["menu_link"])
      click $diff_administration_xpath["menu_link"]     
      assert @selenium.is_text_present($diff_administration["title"])      
      sleep SLEEP_TIME
    end
    #
    def open_diff_administration_page_as(user, password)
      login(user,password)
      sleep SLEEP_TIME
      assert @selenium.is_element_present($diff_administration_xpath["menu_link"])
      click $diff_administration_xpath["menu_link"]
      assert @selenium.is_text_present($diff_administration["title"])
      sleep SLEEP_TIME
    end
    #
    def open_diff_result_summary_page(diff_id)
      login("root","root")
      sleep SLEEP_TIME
      open "/diff/diff_result_summary?diff_id=#{diff_id}"
      sleep SLEEP_TIME
    end
    #
		def open_warning_diff_file
			open_diff_result_summary_page(1)
			@selenium.click $warning_diff_xpath["link_to_file_report"] + "/a"
			sleep SLEEP_TIME
		end
		#
		def open_warning_diff_directory
			open_diff_result_summary_page(1)
			@selenium.click $warning_diff_xpath["link_to_directory_report"] + "/a"
			sleep SLEEP_TIME
		end
		#
    def execute_qac_task
      # select new version
      select $diff_administration_xpath["new_pu_select"], "SamplePU1"
      sleep SLEEP_TIME
      select $diff_administration_xpath["new_pj_select"], "SamplePJ2"
      sleep SLEEP_TIME
      select $diff_administration_xpath["new_task_select"], "sample_c_cpp_1"
      # select old version
      select $diff_administration_xpath["old_pu_select"], "SamplePU1"
      sleep SLEEP_TIME
      select $diff_administration_xpath["old_pj_select"], "SamplePJ2"
      sleep SLEEP_TIME
      select $diff_administration_xpath["old_task_select"], "sample_c_cpp_2"
      # check QAC
      check $diff_administration_xpath["qac"]
      click $diff_administration_xpath["execute_diff_button"]
      wait_for_element_not_present($diff_administration_xpath["wait_element"])
      sleep SLEEP_TIME
    end
    #
    def execute_qacpp_task
      # select new version
      select $diff_administration_xpath["new_pu_select"], "SamplePU1"
      sleep SLEEP_TIME
      select $diff_administration_xpath["new_pj_select"], "SamplePJ2"
      sleep SLEEP_TIME
      select $diff_administration_xpath["new_task_select"], "sample_c_cpp_1"
      # select old version
      select $diff_administration_xpath["old_pu_select"], "SamplePU1"
      sleep SLEEP_TIME
      select $diff_administration_xpath["old_pj_select"], "SamplePJ2"
      sleep SLEEP_TIME
      select $diff_administration_xpath["old_task_select"], "sample_c_cpp_2"
      # check QAC
      check $diff_administration_xpath["qacpp"]
      click $diff_administration_xpath["execute_diff_button"]
      wait_for_element_not_present($diff_administration_xpath["wait_element"])
      sleep SLEEP_TIME
    end

    #WARNING LISTING WITH DIFF
    def access_warning_listing_with_diff(pu, pj, diff_id, diff_file_id)     
      login("root","root")
      sleep SLEEP_TIME
      open "/diff/warning_listing_with_status/#{pu}/#{pj}?diff_file_id=#{diff_file_id}&diff_id=#{diff_id}"
      sleep SLEEP_TIME
    end

    #ANALYSIS REPORT WITH DIFF
    def access_analysis_report_with_diff(pu, pj, diff_id, diff_file_id, file_name, file_id)
      login("root","root")
      sleep SLEEP_TIME
      open "diff/analysis_report_with_diff/#{pu}/#{pj}?diff_file_id=#{diff_file_id}&diff_id=#{diff_id}&file=#{file_name}&file_id=#{file_id}"
      sleep SLEEP_TIME
    end
  end
end


