require File.dirname(__FILE__) + "/../../config/test_helper" unless defined? ENV["RAILS_ENV"]
require File.dirname(__FILE__) + "/../../config/selenium_setup" unless defined? SeleniumSetup

unless defined?(TestDSetup)
  module TestDSetup
    include SeleniumSetup
    include GetText

  MASTER_DELETE_LINK = "link=#{_('Delete')}"
  MASTER_CHANGE_LINK = "link=#{_('Edit')}"

    PU_ID = 1
    PJ_ID = 1

    MASTER_DIR = File.expand_path(File.dirname(__FILE__))
    # master file full path
    MASTER_FILES = {"normal"  => (File.join(MASTER_DIR,  "sample_c_all.tar.gz")),
                    "lzh"     => File.join(MASTER_DIR,  "sample_c_all.lzh"),
                    "zip"     => File.join(MASTER_DIR,  "sample_c_all.zip"),
                    "tar"     => File.join(MASTER_DIR,  "sample_c_all.tar"),
                    "100mb"   => File.join(MASTER_DIR,  "100mb.tar.gz"),
                    "800mb"   => File.join(MASTER_DIR,  "800mb.tar.gz"),
                    "1000mb"  => File.join(MASTER_DIR,  "1000mb.tar.gz"),
                    "1200mb"  => File.join(MASTER_DIR,  "1200mb.tar.gz")}

    if ENV['OS'] =~ /Windows/
      MASTER_FILES.each do |key, value|
        MASTER_FILES[key] = value.gsub('/', '\\')
      end
    end
    # enters Master Management page
    #
    def open_master_management_page(pu_id = PU_ID,
                                    pj_id = PJ_ID)

      # enters PJ management page
      open(url_for(:controller  => "devgroup",
                   :action      => "pj_index",
                   :pu          => pu_id,
                   :pj          => pj_id))

      # waits for loading this page
      wait_for_page_to_load(30000)

      # clicks on link to open "Master Management" page
      click("link=#{$link_texts["master_management_page"]}")

      # waits for loading the page
      wait_for_text_present($page_titles["master_management_page"])
      sleep 2
    end

    # logs in, then open Master Management page
    #
    def access_master_management_page(pu_id = PU_ID,
                                      pj_id = PJ_ID)

      # logs in
      login("root",
            "root")

      # opens Master Management page
      open_master_management_page
    end

    # uses element_locator quickly
    #
    def element_locator(element)
      return $xpath["master"][element]
    end

    # counts total matched masters
    #
    def count_matched_masters(filter_field  = "1",
                              keyword       = "1")
    
      Master.count(:conditions => [filter_field + " like ?" + " and pj_id=? and master_type = 1",
                                         "%"+keyword+"%",
                                         PJ_ID])
    end

    # open Master Registration subwindow
    #
    def open_master_registration_subwindow
      # accesses the Master Managemen page
      access_master_management_page

      # clicks on master_register_link
      click(element_locator("master_register_link"))

      # waits for loading page
      wait_for_text_present($window_titles['master_registration'])
      sleep 2
    end

    def register_master(master_name = "",
                        master_file = "")
      # opens Master registration subwindow
      open_master_registration_subwindow

      # inputs master's name
      type(element_locator("master_name_textbox"),
           master_name)

      # inputs master's file to upload
      type(element_locator("master_file_input"),
           master_file)

      # clicks on "Register" button
      click(element_locator("master_register_button"))

      # waits for closing Master registration subwindow
      wait_for_text_not_present($window_titles["master_registration"])
      sleep 4
    end

    def register_large_master(master_size)
      old_total_masters = count_matched_masters

      register_master(master_size, MASTER_FILES[master_size])

      # a new master row is added into the master list
      wait_for_xpath_count(element_locator("master_list_row"), old_total_masters + 1)
      new_total_masters = old_total_masters + 1
      # the last entry of master list is for the newest master
      last_master_name_on_list_xpath  = element_locator("master_list_row") + "[#{new_total_masters}]/td[2]"
      last_master_name_on_list        = get_text(last_master_name_on_list_xpath)
      assert_equal(master_size, last_master_name_on_list)

      # the successful message must be displayed
      assert(is_text_present($messages["register_master_successfully"]))
      sleep 5
    end

    def open_master_change_subwindow
      # accesses Master management page
      access_master_management_page
      old_total_masters = count_matched_masters
      # click on Change link
      click("//tbody[@id='master_list']/tr[#{old_total_masters}]/td[6]/a[2]")

      # waits for opening the subwindow
      wait_for_text_present($window_titles["master_registration"])
      sleep 2
    end

    def change_master(master_name         = nil,
                      master_explanation  = nil,
                      master_file         = nil)
      open_master_change_subwindow

      # enters master's new name
      type(element_locator("master_name_textbox"), master_name) if master_name
      # enters master's new explanation
      type(element_locator("master_explanation_textarea"), master_explanation) if master_explanation
      # enters master's new file
      type(element_locator("master_file_input"), master_file) if master_file

      # clicks Register button
      click(element_locator("master_register_button"))

      # waits for closing the subwindow
      wait_for_text_not_present($window_titles["master_registration"])
      sleep 2
    end

    def filter_master(search_field,
                      search_keyword)

      # 
      access_master_management_page

      # selects filter field
      select(element_locator('search_combobox'),
             element_locator('search_combobox_options')[search_field])

      # types keyword
      type(element_locator('search_textbox'), search_keyword)

      # clicks Search button
      click(element_locator('search_button'))
      sleep 2
    end
  end
end
