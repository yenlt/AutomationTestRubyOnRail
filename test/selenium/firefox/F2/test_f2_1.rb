require File.dirname(__FILE__) + "/test_f2_setup" unless defined? TestF2Setup
  MASTER_LOCATION3 =  "/report.tar.gz"
class TestF2_1 < Test::Unit::TestCase
  include TestF2Setup
  fixtures :pus , :pjs , :tasks
  @@pu = 0
  @@pj = 0
  @@task = 0
   ## Setup
  def setup
    @verification_errors = []
    if $lang == "en"
      @overall = "Overall Analyze"
      @individual= "Individual Analyze"
    elsif $lang == "ja"
      @overall = "全体解析"
      @individual = "個人解析"
    end
    if $selenium
      @selenium = $selenium
    else
      @selenium = Selenium::SeleniumDriver.new(SELENIUM_CONFIG)
      @selenium.start
    end
  end

  def teardown
    @selenium.stop unless $selenium
    assert_equal [], @verification_errors
    write_log
  end
  # F-037
  # Task type: Individual analysis.
  #1. Set Analysis Type as Individual Analysis.
  #2. Change Tab into "Master."
  #3. Choose Individual Upload する for File by Selection of the Upload Method of
  #an Individual Analysis File.
  #Each directory name (link) of directory structure is clicked.
  def test_037
    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 4

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    sleep 4
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    wait_for_text_present(_("Registration of an Analysis Task"))
    sleep 3
    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    sleep 3
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 4 }

    #Select "uploading individual"
    click "file_upload_upload_way_upload_each"

    assert_equal _("Load directory tree."), get_value($xpath["task"]["read_tree_btn"])
    sleep 3
    #An "it is reading about a tree" button is clicked
    #after choosing a master to read directory structure into by selection of a master.

    click $xpath["task"]["read_tree"]
    sleep 4
    assert !60.times{ break if (is_text_present(_("Directory structure")) rescue false); sleep 4 }

    #Each directory name (link) of directory structure is clicked.
    click $xpath["task"]["tree_link_1"]

    sleep 4
    # test right directory structure
    assert is_text_present(_("Replace"))
    #The file [ directly under ] of the directory is displayed in a list
    #on replacement of a right-hand side file.
    click "link=src/"
    wait_for_text_present("analyzeme.c")
    wait_for_text_present("Makefile")
    wait_for_text_present("common.c")

    sleep 3

    #Initial state,File name < -It has become.
    #Replace file
    input_id      = get_attribute($xpath["task"]["input_field_id_1"], "id")
    type input_id , MASTER_LOCATION3
    click "upload"
    wait_for_text_present("analyzeme.c << report.tar.gz")

    #Remove file
    click $xpath["task"]["tree_chk_1"]
    click "upload"
    wait_for_text_present("analyzeme.c << - ")
    sleep 4
    #It moves suitably in a directory.
    #An error does not occur but changes the contents of a display according to the directory which moved.
    input_id_2      = get_attribute($xpath["task"]["input_field_id_2"], "id")
    type input_id_2 , MASTER_LOCATION3
    click "upload"
    wait_for_text_present("Makefile << report.tar.gz")
    sleep 4
    click $xpath["task"]["chk_value"]
    click "upload"
    wait_for_text_present("Makefile << - ")

    sleep 3
    #  logout
    logout

  end

  # F-038
  # Task type: Individual analysis.
  #1. Set Analysis Type as Individual Analysis.
  #2. Change Tab into "Master."
  #3. Choose Individual Upload する for File by Selection of the Upload Method of
  #an Individual Analysis File.
  #The [+] link on the right of "the new addition of a ■ file" is clicked.
  def test_038

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 4

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    wait_for_text_present(_("Registration of an Analysis Task"))

    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 4 }

    #Select "uploading individual"
    click "file_upload_upload_way_upload_each"

    assert_equal _("Load directory tree."), get_value($xpath["task"]["read_tree_btn"])
    sleep 3
    #An "it is reading about a tree" button is clicked
    #after choosing a master to read directory structure into by selection of a master.

    click $xpath["task"]["read_tree"]
    sleep 4
    assert !60.times{ break if (is_text_present(_("Directory structure")) rescue false); sleep 4 }

    #Each directory name (link) of directory structure is clicked.
    click $xpath["task"]["tree_link_1"]

    sleep 4
    # test right directory structure
    assert is_text_present(_("Replace"))
    #The file [ directly under ] of the directory is displayed in a list
    #on replacement of a right-hand side file.
    click $xpath["task"]["add_file_link"]
    sleep 4

    assert is_text_present(_("Register a new file."))

    #  logout
    logout

  end

  # F-039
  # Task type: Individual analysis.
  #1. Set Analysis Type as Individual Analysis.
  #2. Change Tab into "Master."
  #3. Choose Individual Upload する for File by Selection of the Upload Method of
  #an Individual Analysis File.
  #The [+] link on the right of "the new addition of a ■ file" is clicked.
  #Some files under "replacement of ■ file" are transposed to another file.
  #- What is necessary is just to push an update button, after specifying a replacement file.
  def test_039

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 4

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    wait_for_text_present(_("Registration of an Analysis Task"))

    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 4 }

    #Select "uploading individual"
    click "file_upload_upload_way_upload_each"

    assert_equal _("Load directory tree."), get_value($xpath["task"]["read_tree_btn"])
    sleep 3
    #An "it is reading about a tree" button is clicked
    #after choosing a master to read directory structure into by selection of a master.

    click $xpath["task"]["read_tree"]
    sleep 4
    assert !60.times{ break if (is_text_present(_("Directory structure")) rescue false); sleep 4 }

    #Each directory name (link) of directory structure is clicked.
    click $xpath["task"]["tree_link_1"]

    sleep 4
    # test right directory structure
    assert is_text_present(_("Replace"))
    #The file [ directly under ] of the directory is displayed in a list
    #on replacement of a right-hand side file.
    click $xpath["task"]["add_file_link"]
    sleep 4

    assert is_text_present(_("Register a new file."))

    type "addition_addition1", MASTER_LOCATION3
    sleep 4

    #  logout
    logout

  end

  # F-040
  # Task type: Individual analysis.
  #1. Set Analysis Type as Individual Analysis.
  #2. Change Tab into "Master."
  #3. Choose Individual Upload する for File by Selection of the Upload Method of
  #an Individual Analysis File.
  #The [+] link on the right of "the new addition of a ■ file" is clicked.
  #Some files under "replacement of ■ file" are transposed to another file.
  #- What is necessary is just to push an update button, after specifying a replacement file.
  #An update button is clicked after specifying the file
  #which uploads "the new addition of a ■ file" similarly.
  def test_040

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 4

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    sleep 4
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    wait_for_text_present(_("Registration of an Analysis Task"))

    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 4 }

    #Select "uploading individual"
    click "file_upload_upload_way_upload_each"

    assert_equal _("Load directory tree."), get_value($xpath["task"]["read_tree_btn"])
    sleep 3
    #An "it is reading about a tree" button is clicked
    #after choosing a master to read directory structure into by selection of a master.

    click $xpath["task"]["read_tree"]
    sleep 4
    assert !60.times{ break if (is_text_present(_("Directory structure")) rescue false); sleep 4 }

    #Each directory name (link) of directory structure is clicked.
    click $xpath["task"]["tree_link_1"]

    sleep 4
    # test right directory structure
    assert is_text_present(_("Replace"))
    #Whenever it clicks, the file addition field of the name of a new addition appears.

    click $xpath["task"]["add_file_link"]
    sleep 4

    assert is_text_present(_("Register a new file."))
    #input field
    type "addition_addition1", MASTER_LOCATION3
    sleep 4

    #Update button clicked
    click "upload"
    sleep 5
    #Upload of the specified file is performed.
    #It checks being replaced with the file name which the portion written to be new registration uploaded.
    assert is_text_present("report.tar.gz")
    sleep 4
    click "del_addition"
    sleep 4
    click "upload"
    sleep 3
    #  logout
    logout

  end

  # F-041
  # Task type: Individual analysis.
  #A check is put into the check box in the right end of the uploaded file
  #under "being a new addition to ■ file", and an update button is clicked.
  def test_041

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 4

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    sleep 4
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    wait_for_text_present(_("Registration of an Analysis Task"))

    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 4 }
    #Select "uploading individual"
    click "file_upload_upload_way_upload_each"

    assert_equal _("Load directory tree."), get_value($xpath["task"]["read_tree_btn"])
    sleep 3
    #An "it is reading about a tree" button is clicked
    #after choosing a master to read directory structure into by selection of a master.

    click $xpath["task"]["read_tree"]
    sleep 4
    assert !60.times{ break if (is_text_present(_("Directory structure")) rescue false); sleep 4 }

    #Each directory name (link) of directory structure is clicked.
    click $xpath["task"]["tree_link_1"]

    sleep 4
    # test right directory structure
    assert is_text_present(_("Replace"))
    #Whenever it clicks, the file addition field of the name of a new addition appears.

    click $xpath["task"]["add_file_link"]
    sleep 4

    assert is_text_present(_("Register a new file."))
    #input field
    type "addition_addition1", MASTER_LOCATION3
    sleep 4
    #Update button clicked
    click "upload"
    sleep 4
    #Upload of the specified file is performed.
    #It checks being replaced with the file name which the portion written to be new registration uploaded.
    assert is_text_present("report.tar.gz")
    sleep 4

    #The file which put in the check is deleted from on DB.
    #It checks that the file name which put in the check has disappeared
    #from under the "new addition of ■ file" field after a button depression.
    click "del_addition"
    sleep 4
    click "upload"
    sleep 3
    assert !is_text_present("report.tar.gz")
    sleep 4

    #  logout
    logout

  end

  # F-042
  # Task type: Individual analysis.
  #A check is put into the check box in the right end of the uploaded file
  #under "being a new addition to ■ file", and an update button is clicked.
  def test_042

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 4

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    sleep 4
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    wait_for_text_present(_("Registration of an Analysis Task"))

    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 4 }

    #Select "uploading individual"
    click "file_upload_upload_way_upload_each"

    assert_equal _("Load directory tree."), get_value($xpath["task"]["read_tree_btn"])
    sleep 3
    #An "it is reading about a tree" button is clicked
    #after choosing a master to read directory structure into by selection of a master.

    click $xpath["task"]["read_tree"]
    sleep 4
    assert !60.times{ break if (is_text_present(_("Directory structure")) rescue false); sleep 4 }

    #Each directory name (link) of directory structure is clicked.
    click $xpath["task"]["tree_link_1"]

    sleep 4
    # test right directory structure
    assert is_text_present(_("Replace"))
    #Whenever it clicks, the file addition field of the name of a new addition appears.

    click $xpath["task"]["add_file_link"]
    sleep 4

    assert is_text_present(_("Register a new file."))
    #input field
    type "addition_addition1", MASTER_LOCATION3
    sleep 4
    #Update button clicked
    click "upload"
    sleep 4
    #Upload of the specified file is performed.
    #It checks being replaced with the file name which the portion written to be new registration uploaded.
    assert is_text_present("report.tar.gz")
    sleep 4

    #The file which put in the check is deleted from on DB.
    #It checks that the file name which put in the check has disappeared
    #from under the "new addition of ■ file" field after a button depression.
    click "del_addition"
    sleep 4
    click "upload"
    sleep 3
    assert !is_text_present("report.tar.gz")
    sleep 4

    #The file which put in the check is deleted from on DB.
    #It checks that the file name which put in the check has disappeared
    #from under the "new addition of ■ file" field after a button depression.

    assert !is_text_present(_("Register a new file."))
    sleep 4

    #  logout
    logout

  end

  # F-043
  # Task type: Individual analysis.
  #After carrying out individual upload of a file,
  #a minimum setup is performed and an individual analysis task is registered.
  def test_043

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 4

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    sleep 4
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    wait_for_text_present(_("Registration of an Analysis Task"))

    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 4 }

    #Select "uploading individual"
    click "file_upload_upload_way_upload_each"

    assert_equal _("Load directory tree."), get_value($xpath["task"]["read_tree_btn"])
    sleep 3
    #An "it is reading about a tree" button is clicked
    #after choosing a master to read directory structure into by selection of a master.

    click $xpath["task"]["read_tree"]
    sleep 4
    assert !60.times{ break if (is_text_present(_("Directory structure")) rescue false); sleep 4 }

    #Each directory name (link) of directory structure is clicked.
    click $xpath["task"]["tree_link_1"]

    # test right directory structure
    wait_for_text_present(_("Replace"))
    #Whenever it clicks, the file addition field of the name of a new addition appears.

    click $xpath["task"]["add_file_link"]
    wait_for_text_present(_("Register a new file."))
    #input field
    type "addition_addition1", MASTER_LOCATION3
    sleep 4
    #Update button clicked
    click "upload"
    sleep 4
    #Upload of the specified file is performed.
    #It checks being replaced with the file name which the portion written to be new registration uploaded.
    assert is_text_present("report.tar.gz")
    sleep 4

    click $xpath["task"]["general_control_tab"]
    sleep 3
    type "task_name", "Task_individual"
    click "tool_qac"
    click "high"
    sleep 3

    #Set default for high qac tool
    click $xpath["task"]["selected_high_rule"]

    #wait for loading page
    wait_for_condition("Ajax.Request","30000")
    sleep 3

    click "//input[@value='#{_('Check All Rules in This Page')}']"

    #Register a new task
    click $xpath["task"]["register_task"]
    sleep 4

    #Move to Setup tab
    click $xpath["task"]["execution_setup_tab"]
    assert !60.times{ break if (is_text_present(_("Executing Setting")) rescue false); sleep 4 }
    click $xpath["task"]["save_setting_btn"]
    assert !60.times{ break if (is_text_present(_("Execution setting was updated.")) rescue false); sleep 4 }

    #    # Change Tab into "Master."
    #    click $xpath["task"]["master_tab"]
    #    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 4 }
    #    sleep 4
    click "confirm_task_btn"
    sleep 4
    assert !60.times{ break if (is_text_present(_("Confirm the Contents of Registration")) rescue false); sleep 4 }
    sleep 3

    click $xpath["task"]["register_task"]
    #  logout
    logout

  end

  # F-044
  # Task type: Individual analysis.
  #After carrying out individual upload of a file,
  #a minimum setup is performed and an individual analysis task is registered.
  def test_044

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 4

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    sleep 4
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    wait_for_text_present(_("Registration of an Analysis Task"))

    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 4 }

    #Select "uploading individual"
    click "file_upload_upload_way_upload_each"

    assert_equal _("Load directory tree."), get_value($xpath["task"]["read_tree_btn"])
    sleep 3
    #An "it is reading about a tree" button is clicked
    #after choosing a master to read directory structure into by selection of a master.

    click $xpath["task"]["read_tree"]
    sleep 4
    assert !60.times{ break if (is_text_present(_("Directory structure")) rescue false); sleep 4 }

    #Each directory name (link) of directory structure is clicked.
    click $xpath["task"]["tree_link_1"]

    sleep 4
    # test right directory structure
    assert is_text_present(_("Replace"))
    #Whenever it clicks, the file addition field of the name of a new addition appears.

    click $xpath["task"]["add_file_link"]
    sleep 4

    assert is_text_present(_("Register a new file."))
    #input field
    type "addition_addition1", MASTER_LOCATION3
    sleep 4
    #Update button clicked
    click "upload"
    sleep 4
    #Upload of the specified file is performed.
    #It checks being replaced with the file name which the portion written to be new registration uploaded.
    assert is_text_present("report.tar.gz")
    sleep 4

    click $xpath["task"]["general_control_tab"]
    sleep 3
    type "task_name", "Task_individual"
    click "tool_qac"
    click "high"
    sleep 3

    #Set default for high qac tool
    click $xpath["task"]["selected_high_rule"]

    #wait for loading page
    wait_for_condition("Ajax.Request","30000")
    sleep 3

    click "//input[@value='#{_('Check All Rules in This Page')}']"

    #Register a new task
    click $xpath["task"]["register_task"]
    sleep 4

    #Move to Setup tab
    click $xpath["task"]["execution_setup_tab"]
    assert !60.times{ break if (is_text_present(_("Executing Setting")) rescue false); sleep 4 }
    click $xpath["task"]["save_setting_btn"]
    assert !60.times{ break if (is_text_present(_("Execution setting was updated.")) rescue false); sleep 4 }
    sleep 4
    click "confirm_task_btn"
    sleep 3
    assert !60.times{ break if (is_text_present(_("Confirm the Contents of Registration")) rescue false); sleep 4 }
    sleep 3

    click $xpath["task"]["register_task"]
    sleep 3
    #Task detail
    click $xpath["task"]["individual_task_analysis"]
    assert !60.times{ break if (is_text_present(_("The individual analysis task ")+"Task_individual "+_("was registered")) rescue false); sleep 4 }
    sleep 4
    task = Task.find(:last)
    click "//tr[@id='task_id#{task.id}']"
    sleep 5

    task =Task.find(:last)
    task.destroy
    #  logout
    logout

  end

  # F-045
  # Task type: Individual analysis.
  #Individual upload of the file is carried out.
  #It moves to another tab.
  #It returns to a master tab.
  def test_045

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 4

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    sleep 4
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    wait_for_text_present(_("Registration of an Analysis Task"))
    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 4 }

    #Select "uploading individual"
    click "file_upload_upload_way_upload_each"
    sleep 3

    assert_equal _("Load directory tree."), get_value($xpath["task"]["read_tree_btn"])
    sleep 3
    #An "it is reading about a tree" button is clicked
    #after choosing a master to read directory structure into by selection of a master.

    click $xpath["task"]["read_tree"]
    sleep 3
    assert !60.times{ break if (is_text_present(_("Directory structure")) rescue false); sleep 4 }

    #Each directory name (link) of directory structure is clicked.
    click $xpath["task"]["tree_link_1"]
    # test right directory structure
    wait_for_text_present(_("Replace"))
    #Whenever it clicks, the file addition field of the name of a new addition appears.

    click $xpath["task"]["add_file_link"]
    wait_for_text_present(_("Register a new file."))
    #input field
    type "addition_addition1", MASTER_LOCATION3
    sleep 3
    #Update button clicked
    click "upload"
    sleep 3
    #Upload of the specified file is performed.
    #It checks being replaced with the file name which the portion written to be new registration uploaded.
    assert is_text_present("report.tar.gz")
    sleep 3

    click $xpath["task"]["general_control_tab"]
    sleep 3
    type "task_name", "Task_individual"
    click "tool_qac"
    click "high"
    sleep 3

    #Set default for high qac tool
    click $xpath["task"]["selected_high_rule"]

    #wait for loading page
    wait_for_condition("Ajax.Request","30000")
    sleep 3

    click "//input[@value='#{_('Check All Rules in This Page')}']"

    #Register a new task
    click $xpath["task"]["register_task"]
    sleep 4
    #Move to Setup tab
    click $xpath["task"]["execution_setup_tab"]
    assert !60.times{ break if (is_text_present(_("Executing Setting")) rescue false); sleep 4 }
    click $xpath["task"]["save_setting_btn"]
    assert !60.times{ break if (is_text_present(_("Execution setting was updated.")) rescue false); sleep 4 }
    sleep 4

    click "confirm_task_btn"
    sleep 4
    assert !60.times{ break if (is_text_present(_("Confirm the Contents of Registration")) rescue false); sleep 4 }
    sleep 3

    click $xpath["task"]["register_task"]
    wait_for_page_to_load "30000"
    #Move another task

    click $xpath["task"]["main_area_td4"]
    assert !60.times{ break if (is_text_present(_("Registration of an Analysis Task")) rescue false); sleep 3 }

    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 4 }
    sleep 4
    assert is_checked($xpath["task"]["upload_way"])
    sleep 4

    task =Task.find(:last)
    task.destroy

    #  logout
    logout

  end

  # F-046
  # Task type: Individual analysis.
  #Individual upload of the file is carried out.
  #It moves to another tab.
  #It returns to a master tab.
  def test_046

    #  login
    login

    #  Open PU management page
    open_pu_management_page_1

    #Find a PU

    @@pu = Pu.find_by_name('SamplePU1')
    open "/devgroup/pu_index/#{@@pu.id}"
    wait_for_page_to_load "30000"

    sleep 4

    #Find a PJ of PU
    open_pj_management_page(@@pu.id)

    @@pj = Pj.find_by_name('SamplePJ1')
    open"/devgroup/pj_index/#{@@pu.id}/#{@@pj.id}"
    wait_for_page_to_load "30000"

    #Open "Registration of analysis task" page
    open("/task/index2/#{@@pu.id}/#{@@pj.id}")
    sleep 4
    #Open master control tab
    click $xpath["task"]["main_area_td4"]
    wait_for_text_present(_("Registration of an Analysis Task"))

    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 4 }

    #Select "uploading individual"
    click "file_upload_upload_way_upload_each"

    assert_equal _("Load directory tree."), get_value($xpath["task"]["read_tree_btn"])
    sleep 3
    #An "it is reading about a tree" button is clicked
    #after choosing a master to read directory structure into by selection of a master.

    click $xpath["task"]["read_tree"]
    sleep 4
    assert !60.times{ break if (is_text_present(_("Directory structure")) rescue false); sleep 4 }

    #Each directory name (link) of directory structure is clicked.
    click $xpath["task"]["tree_link_1"]

    sleep 4
    # test right directory structure
    assert is_text_present(_("Replace"))
    #Whenever it clicks, the file addition field of the name of a new addition appears.

    click $xpath["task"]["add_file_link"]
    sleep 4

    assert is_text_present(_("Register a new file."))
    #input field
    type "addition_addition1", MASTER_LOCATION3
    sleep 4
    #Update button clicked
    click "upload"
    sleep 4
    #Upload of the specified file is performed.
    #It checks being replaced with the file name which the portion written to be new registration uploaded.
    assert is_text_present("report.tar.gz")
    sleep 4

    click $xpath["task"]["general_control_tab"]
    sleep 3
    type "task_name", "Task_individual"
    click "tool_qac"
    click "high"
    sleep 3

    #Set default for high qac tool
    click $xpath["task"]["selected_high_rule"]

    #wait for loading page
    wait_for_condition("Ajax.Request","30000")
    sleep 3

    click "//input[@value='#{_('Check All Rules in This Page')}']"

    #Register a new task
    click $xpath["task"]["register_task"]
    sleep 4

    #Move to Setup tab
    click $xpath["task"]["execution_setup_tab"]
    assert !60.times{ break if (is_text_present(_("Executing Setting")) rescue false); sleep 4 }
    click $xpath["task"]["save_setting_btn"]
    assert !60.times{ break if (is_text_present(_("Execution setting was updated.")) rescue false); sleep 4 }
    sleep 4
    click "confirm_task_btn"
    sleep 4
    assert !60.times{ break if (is_text_present(_("Confirm the Contents of Registration")) rescue false); sleep 4 }
    sleep 3

    click $xpath["task"]["register_task"]
    wait_for_page_to_load "30000"
    #Move another task

    click $xpath["task"]["main_area_td4"]
    wait_for_text_present(_("Registration of an Analysis Task"))

    # Set Analysis Type as Individual Analysis.
    select "analyze_type", "label=#{@individual}"

    # Change Tab into "Master."
    click $xpath["task"]["master_tab"]
    assert !60.times{ break if (is_text_present(_("Select a master")) rescue false); sleep 4 }
    sleep 4
    assert is_checked($xpath["task"]["upload_way"])
    assert !is_text_present(_("Uploaded individually."))
    sleep 4

    task =Task.find(:last)
    task.destroy
    #  logout
    logout

  end
end
