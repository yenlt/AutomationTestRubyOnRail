require File.dirname(__FILE__) + "/../../config/test_helper" unless defined? ENV["RAILS_ENV"]
require File.dirname(__FILE__) + "/../../config/selenium_setup" unless defined? SeleniumSetup

unless defined?(TestF1Setup)
  module TestF1Setup
    include SeleniumSetup
    include ERB::Util
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::AssetTagHelper
    include ActionView::Helpers::TagHelper
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

     def open_pj_management_page(pu_id)
      open "/devgroup/pu_index/#{pu_id}"
      wait_for_page_to_load "30000"
      click $xpath["misc"]["PJ_link"]
      assert !60.times{ break if (is_text_present(_("PJ Administration")) rescue false); sleep 1 }
      sleep 2
    end
    def register_pu(pu_name)
      click "link=[#{_('Register')}]"
      sleep 2
      type "project_unit_name", pu_name
      click "commit"
      wait_for_text_not_present(_("Create New PU"))
    end
     def register_pj(pj_name)
      click "link=[#{_('Register')}]"
      sleep 2
      type "project_name", pj_name
      click "commit"
      wait_for_text_not_present(_("Create New Project"))
    end

end