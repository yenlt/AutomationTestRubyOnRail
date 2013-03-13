# clear screen
system "clear"

PROGRAM_TITLE = "#   SELENIUM TEST for TOSCANA v2.0   #"
# introduce the prog
puts
puts
puts "#" * PROGRAM_TITLE.length
puts PROGRAM_TITLE
puts "#" * PROGRAM_TITLE.length
puts
puts

################################################################################
# select browser
browsers  = ["firefox", "ie"]
choice    = -1

while choice != 0 && choice != 1
  puts "Please select browser to run:"
  puts "1. Firefox"
  puts "2. Internet explorer"
  puts "3. Quit"
  print "Your choice:"
  choice = gets
  choice = choice.to_i - 1
  exit if choice == 2
end

################################################################################
# configurations
BROWSER     = browsers[choice]
BASE_DIR    = File.dirname(__FILE__)
CONFIG_DIR  = File.join(BASE_DIR, "config")
CODE_DIR    = File.join(BASE_DIR, BROWSER)
RESULT_DIR  = File.join(BASE_DIR, "results", BROWSER)

# clear the screen
system "clear"

################################################################################
# load environment settings

# load test_helper of rails
require BASE_DIR + "/config/test_helper.rb"
# load selenium setup
require CONFIG_DIR + "/selenium_setup.rb"
require "test/unit"
# read configuration
require "yaml"
SELENIUM_CONFIG = YAML::load_file(CONFIG_DIR + "/selenium.yml")[BROWSER]

puts "Environment is loaded successfully."
puts
# end of loading enviroment settings
################################################################################
choice = "1"
def total_test_cases(test_suite_id)
  total_test_cases = 0
  test_code_dir = File.join(CODE_DIR, test_suite_id)
  if File.exists?(test_code_dir)

  end

  return total_test_cases
end

class MyTestSuite
  attr_accessor :description, :size, :id
  def initialize(id, description)
    @id           = id
    @description  = description
  end

  # counts total test cases
  #
  def size
    total_testcases = 0

    test_code_dir = File.join(CODE_DIR, id)

    if File.exists?(test_code_dir)
      Dir.glob(File.join(test_code_dir,"test_#{id.downcase}*.rb")) do |f|
        file = File.open(f,
                        "r")
        file.each_line { |line| total_testcases += 1 if line =~ /^(\s)*def(\s)*test_/ }

        file.close
      end
    end

    return total_testcases
  end

  # execute this test suite
  #
  def run
    test_code_dir   = File.join(CODE_DIR, id)
    result_dir      = File.join(RESULT_DIR, "#{id}")

    Dir.mkdir(result_dir) unless File.exist?(result_dir)
    $log_file       = File.join(result_dir,
                                "#{Time.now.strftime("%Y%m%d")}.log")

    file = File.new($log_file, "w") || File.open($log_file, "w+")
    file.puts("#" * 80)
    file.puts("# Test suite:          %-55s #" % id)
    file.puts("# Test item:           %-55s #" % description)
    file.puts("# Total test cases:    %-55s #" % size)
    file.puts("# Test date:           %-55s #" % Time.now.strftime("%Y-%m-%d"))
    file.puts("#" * 80)
    file.close

    Dir.glob(File.join(test_code_dir,"test_#{id.downcase}*.rb")) do |f|
      require f if f != "test_#{id.downcase}_setup.rb"
    end
  end
end

testsuites = [MyTestSuite.new("A", "PU Management Function"),
              MyTestSuite.new("B", "PJ Management Function"),
              MyTestSuite.new("C", "PU, PJ management Function"),
              MyTestSuite.new("D", "Master controlling function"),
              MyTestSuite.new("DTM", "Display Transition of Metrics"),
              MyTestSuite.new("E1", "Task management page, Task list display"),
              MyTestSuite.new("E2", "Task management page, Task detailed display"),
              MyTestSuite.new("F1","Registration page"),
              MyTestSuite.new("F2","Master tab"),
              MyTestSuite.new("F3","Tool setting tab"),
              MyTestSuite.new("F4","General control tab"),
              MyTestSuite.new("F5","Task registration"),
              MyTestSuite.new("G","Analytical rule setup"),
              MyTestSuite.new("H","Analysis result QAC"),
              MyTestSuite.new("I","Analysis result QAC++"),
              MyTestSuite.new("J","Analysis log"),
              MyTestSuite.new("K", "PU member's addition and the Delete function"),
              MyTestSuite.new("L", "A project member's addition and the Delete function"),
              MyTestSuite.new("M", "Interlocking deletion of a column"),
              MyTestSuite.new("O", "User administrative module"),
              MyTestSuite.new("V", "Visualization Metric Function"),
              MyTestSuite.new("R", "Review Support Function"),
              MyTestSuite.new("SCM", "SCM Corporation"),
              MyTestSuite.new("WD", "Warning Differences"),
              MyTestSuite.new("Z", "Run all test suites"),
              MyTestSuite.new("Q", "Quit")]

def testsuites.find_by_testsuite_id(testsuite_id)
  self.each do |testsuite|
    return testsuite if testsuite.id == testsuite_id
  end
  return nil
end

while testsuites.find_by_testsuite_id(choice).nil?
  puts "Please select a test suite to run:"
  puts
  puts "+" + "-" * 78 + "+"
  puts "| %5s | %-55s | %10s |" % ["ID", "Test item", "Test cases"]
  puts "+" + "-" * 78 + "+"

  testsuites.each do |testsuite|
    puts "| %5s | %-55s | %10s |" % [testsuite.id, testsuite.description, testsuite.size]
  end
  puts "+" + "-" * 78 + "+"
  puts
  print "Your select (A, B, C, D, DTM, E1, E2, F1, F2, F3, F4, F5, G, H, I, J, K, L, M, O, V, R, SCM, WD, Z or Q):"
  
  choice = gets.rstrip.upcase
end

case choice
when "Q"  # quit
  exit
when "Z"  # run all test suites
  testsuites.delete_at(-1)
  testsuites.delete_at(-1)

  testsuites.each do |testsuite|
    testsuite.run
  end
else      # run a test suite
  testsuite = testsuites.find_by_testsuite_id(choice)
  testsuite.run
end

