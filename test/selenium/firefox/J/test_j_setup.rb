require File.dirname(__FILE__) + "/../../config/test_helper" unless defined? ENV["RAILS_ENV"]
require File.dirname(__FILE__) + "/../../config/selenium_setup" unless defined? SeleniumSetup


												
module TestJSetup
	include SeleniumSetup
	include GetText
	
	WAIT_TIME = 3

$xpath = {
	"sample_c_cpp_1_1"				=>	"//div[@id='right_contents']/div[@id='recent_result']/ul/ul/ul/li/a",
	"[log]_link"							=>	"//div[@id='task_detail_area']/table/tbody/tr[4]/td[3]/table/tbody[@id='log_and_result']/tr[2]/td[4]/a"
}

$analysis_log	=	{
	"analysis_log_page_title"								=>	_("Analysis Execution Log")		,
	"task_tool_xpath"												=>	"//h3[@id='pagetitle']/span[@id='subtitle']",
	"task_tool_name"												=>	"#{_("Analysis Task")}1:「sample_c_cpp_1_1」,#{_("Tool")}:「QAC++」",
	"navi_link"															=>	"[PU] SamplePU1 > [PJ] SamplePJ1 > #{_("Analysis Task Administration")} > #{_("Analysis Execution Log")}",
	"analyzer_run_end"											=>	"//div[@id='log_sammary_area']/h3[@id='status']",
	"analyzer_run_end_text"									=>	"■#{_("State")}: Analyzer::Analyzer.run : end",
	"analysis_progress_error"								=>	"//div[@id='log_sammary_area']/table/tbody/tr[2]/td[@id='current_analyze_status']",
	"analysis_progress_error_text"					=>	"6/6, #{_("Error")}(5)",
	"analysis_files"												=>	"//div[@id='log_sammary_area']/table/tbody/tr[4]/td[@id='number_of_files']/span",
	"analysis_log_text"											=>	"//div[@id='analyze_log_area']/div[@id='analyze_log_contents']",		
	"error_sub_window_title"								=>	"//div[@id='window_1251261860283_top']",
	"error_files"														=>	"//div[@id='error_files']",
	"error_files_name"											=>	"sample_cpp/Base/src/LanguageProduct.cpp\nsample_cpp/Common/src/LCSAlgo.cpp\nsample_cpp/Common/src/AnzException.cpp\nsample_cpp/Base/src/LanguageFactory.cpp\nsample_cpp/Base/src/Preprocessor.cpp",
	"error_sub_window_file_count"						=>	"//div[@id='error_files']",
	"error_sub_window_link"									=>	"//div[@id='log_sammary_area']/table/tbody/tr[2]/td[@id='current_analyze_status']/span/a"
}
	def login_analysis_log
		login
		wait_for_text_present(_("User Page"))
    #click $xpath["sample_c_cpp_1_1"]
    open "/task/task_detail/1/1?id=1"
    wait_for_text_present("[#{_("Log")}]")
	end

end 
