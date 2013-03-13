require File.dirname(__FILE__) + "/../../config/test_helper" unless defined? ENV["RAILS_ENV"]
require File.dirname(__FILE__) + "/../../config/selenium_setup" unless defined? SeleniumSetup

unless defined?(TestASetup)
  module TestASetup
    include SeleniumSetup
    include ERB::Util
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::AssetTagHelper
    include ActionView::Helpers::TagHelper

    def open_pu_management_page
      login
      open(url_for(:controller => "misc", :action => "adminmenu"))
      wait_for_page_to_load "30000"
      click $xpath["misc"]["PU_link"]
      sleep 3
    end

    def open_pu_registration_page
      open_pu_management_page
      click "link=[#{_('Register')}]"
      sleep 2
    end

    def open_pu_setting_page(pu_name)
      click "link=#{pu_name}"
      wait_for_page_to_load "30000"
      # Pu setting page
      click "link=#{_('PU Setting')}"
      sleep 2
    end    

    # open a PU Management Page
    def open_pu_management_page_1
      #request to open
      open(url_for(:controller => "misc", :action => "adminmenu"))

      #wait for loading page
      wait_for_page_to_load "30000"

      #Click to open PU link
      click $xpath["misc"]["PU_link"]

      sleep 3
    end

    # overrides the traditional url_for
    #
    def url_for(options)
      ActionController::Routing::Routes.reload if ActionController::Routing::Routes.empty?
      ActionController::Routing::Routes.generate(options, {})
    end    

    def xpath
      xpath = {
        "pu_management" => {
          "search_box"  => "query",
          "pu_table"    => "class=form1",
          "pu_list"     => "//tbody[@id='pu_list']/tr"
        },
        "add_pu_window" => {
          "inheritance_pu_list" => "//div[@id='add_pu_window']/form/table[2]/tbody/tr[2]/td[1]/ul/li"
        }
      }
      return xpath
    end

    def register_pu(name, arr_click = nil)
      open_pu_registration_page
      type "project_unit_name", name
      if (arr_click != nil)
        n = arr_click.length - 1
        for j in 0..n          
          click arr_click[j]
        end
      end
      click "commit"
      sleep 3
      run_script("destroy_subwindow()")
      sleep 3
    end

    def create_pu(name)
      pu = Pu.new(:name =>name)
      pu.created_at = DateTime.now.to_s
      pu.updated_at = DateTime.now.to_s
      pu.save
    end

    def change_pu_name(pu_id, name)
      click "//a[contains(@href, '/devgroup/change_pu?id=" + pu_id.to_s + "')]"
      wait_for_element_present("change_pu_name")
      type "change_pu_name", name
      # registration button is clicked.
      click "//input[@value='#{_('Edit')}']"
      wait_for_page_to_load "30000"
    end

    def make_original_pus
      system "rake db:fixtures:load"
    end

    def delete_all_pus
      Pu.destroy_all
      PusUsers.destroy_all
      PjsUsers.destroy_all
    end

    def filtering(factor)
      type "//input[@id='query']", factor
      sleep 2
      click "//input[@value='#{_('Search')}']"
      sleep 2
    end

    def check_pu_setting_blank
      assert_equal "", get_value("make_options")
      assert_equal "", get_value("environment_variables")
      assert_equal "", get_value("header_file_at_analyze")
      assert_equal "", get_value("analyze_tool_config")
      assert_equal "", get_value("others")
    end    

    def check_pu_setting_value(pu, n)
      assert_equal pu.analyze_configs[n].make_options||'', get_value("make_options")
      assert_equal pu.analyze_configs[n].environment_variables||'', get_value("environment_variables")
      assert_equal pu.analyze_configs[n].header_file_at_analyze||'', get_value("header_file_at_analyze")
      assert_equal pu.analyze_configs[n].analyze_tool_config||'', get_value("analyze_tool_config")
      assert_equal pu.analyze_configs[n].others||'', get_value("others")
    end

    def setup_setting_pu(pu_id,qac_setting,rule_number)
      pu = Pu.find(pu_id)
      analyze_config_pus = pu.analyze_configs
      AnalyzeConfig.update(analyze_config_pus[0].id, {:make_options => qac_setting,
          :environment_variables => qac_setting,
          :header_file_at_analyze => qac_setting,
          :analyze_tool_config => qac_setting,
          :others => qac_setting})
      analyze_rule_config_pus = pu.analyze_rule_configs
      AnalyzeRuleConfig.update(analyze_rule_config_pus[0].id, {:rule_numbers => rule_number})
    end

    def setup_setting_pj(pj_id,qac_setting,qacpp_setting,rule_number,pj_rule_number)
      # set up setting for a project "pj"
      pj = Pj.find(pj_id)
      analyze_config_pjs = pj.analyze_configs
      AnalyzeConfig.update(analyze_config_pjs[0].id, {:make_options => qac_setting,
          :environment_variables => qac_setting,
          :header_file_at_analyze => qac_setting,
          :analyze_tool_config => qac_setting,
          :others => qac_setting})
      AnalyzeConfig.update(analyze_config_pjs[1].id, {:make_options => qacpp_setting,
          :environment_variables => qacpp_setting,
          :header_file_at_analyze => qacpp_setting,
          :analyze_tool_config => qacpp_setting,
          :others => qacpp_setting})
      analyze_rule_config_pjs = pj.analyze_rule_configs
      AnalyzeRuleConfig.update(analyze_rule_config_pjs[3].id, {:rule_numbers => pj_rule_number})
      AnalyzeRuleConfig.update(analyze_rule_config_pjs[0].id, {:rule_numbers => rule_number})
    end   
  
  end
end