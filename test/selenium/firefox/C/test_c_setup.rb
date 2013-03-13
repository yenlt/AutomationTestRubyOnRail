require File.dirname(__FILE__) + "/../../config/test_helper" unless defined? ENV["RAILS_ENV"]
require File.dirname(__FILE__) + "/../../config/selenium_setup" unless defined? SeleniumSetup

unless defined?(TestCSetup)
  module TestCSetup
    include SeleniumSetup
    include ERB::Util
    include GetText
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::AssetTagHelper
    include ActionView::Helpers::TagHelper

  
    def open_pu_registration_page
      open_pu_management_page
      click "link=[#{_('Register')}]"
      sleep 2
    end

    def open_pj_management_page(pu_id)
      open "/devgroup/pu_index/#{pu_id}"
      wait_for_page_to_load "30000"
      click $xpath["misc"]["PJ_link"]
      assert !60.times{ break if (is_text_present(_("PJ Administration")) rescue false); sleep 1 }

      sleep 2
    end

    # open a PU Management Page
    def open_pu_management_page_1
      #request to open
      open(url_for(:controller => "misc", :action => "adminmenu"))

      #wait for loading page
      wait_for_condition("Ajax.Request","30000")

      #Click to open PU link
      click $xpath["misc"]["PU_link"]

      sleep(3)
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

    def register_pu(pu_name)
      click "link=[#{_('Register')}]"
      sleep 2
      type "project_unit_name", pu_name
      click "commit"
      sleep 2
    end

    def create_pu(name)
      pu = Pu.new(:name =>name)
      pu.created_at = DateTime.now.to_s
      pu.updated_at = DateTime.now.to_s
      pu.save
    end

    def register_pj(pj_name)
      click "link=[#{_('Register')}]"
      sleep 2
      type "project_name", pj_name
      click "commit"
      sleep 2
    end

    def create_pj(pu_id,name)
      pj = Pj.new(:pu_id => pu_id, :name => name)
      pj.created_at = DateTime.now.to_s
      pj.updated_at = DateTime.now.to_s
      pj.save
    end

    def register_user(name,pass)
      open "/misc/adminmenu"
      wait_for_page_to_load '3000'
      click "link=#{_('User Administration')}"

      sleep 2
      click "link=[#{_('Register')}]"
      sleep 2
      user_id = get_text("//div[@id='user_register_area']/form/table/tbody/tr[1]/td").to_i
      type "user_account_name", name
      type "user_last_name", name
      type "user_first_name", name
      type "user_nick_name", name
      type "user_email", "toantn@tsdv.com.vn"
      type "user_password", pass
      type "user_password_confirmation", pass
      click "//input[@value='#{_('Register')}']"
      sleep 2
      window_id = get_attribute("//body/div[2]@id")
      click window_id + "_close"
      sleep 2
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

    def create_pu_member(pu_id)
      register_user('toan', '071185')
      user = User.find(:last)
      PusUsers.create(:pu_id => pu_id, :user_id => user.id)
    end

    def create_pj_member(pj_id)
      register_user('tnt', '071185')
      pj_user = User.find(:last)
      PjsUsers.create(:pj_id => pj_id, :user_id => pj_user.id)
    end
    def filtering(factor)
      type "//input[@id='query']", factor
      sleep 2
      click "//input[@value='#{_('Search')}']"
      sleep 2
    end

    def register_task(pu_id,pj_id)
      create_master(pj_id, 'registrate a master', 'my_master', 'mater.tar.gz')
      open("/task/add_task2/#{pu_id}/#{pj_id}")
      wait_for_page_to_load "30000"
      type "task_name", "my_task"
      type "expl", "registrate a task"
      click "tool_qac"
      click "normal"
      click "link=#{_('Analysis Tool Setting')}"
      sleep 5
      type "make_options", "my_task"
      type "environment_variables", "my_task"
      click "//input[@value='#{_('Save Setting')}']"
      sleep 5
      click "link=#{_('Master')}"
      sleep 5
      master_labels = get_select_options("master_id")
      select "master_id", "label=#{master_labels.last}"
      click "confirm_task_btn"
      sleep 5
     # click "//input[@value='#{_('Register')}']"
      sleep 5
    end

    def create_master(pj_id,expl,name,filename)
      Master.create(:content_type => 'gz',
        :user_id => 1,
        :pj_id => pj_id,
        :expl => expl,
        :master_status_id => 2,
        :name => name,
        :filename => filename,
        :master_type => 1
      )
    end


  end
end