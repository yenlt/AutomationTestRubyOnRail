require File.dirname(__FILE__) + '/../test_helper'

class ScmConfigTest < ActiveSupport::TestCase
  #test the validations inside the model
  def test_ut_scm_m_01_to_10
    scmconfig = ScmConfig.new
    assert !scmconfig.valid?
    assert !scmconfig.save
    assert scmconfig.errors.invalid?(:tool)
    assert !scmconfig.errors.invalid?(:cvs_module)
    assert !scmconfig.errors.invalid?(:user)
    assert scmconfig.errors.invalid?(:tool_ids)
    assert !scmconfig.errors.invalid?(:password)
    assert !scmconfig.errors.invalid?(:target_dir)
    assert !scmconfig.errors.invalid?(:file_type)
    assert !scmconfig.errors.invalid?(:file_name)
    assert !scmconfig.errors.invalid?(:base_revision)
    assert scmconfig.errors.invalid?(:master_name)
    assert scmconfig.errors.invalid?(:repo_path)
    assert scmconfig.errors.invalid?(:interval)
    assert scmconfig.errors.invalid?(:interval)
    
  end
 #test initialization of scm_config model.
  def test_ut_scm_config_11
    scmconfig=ScmConfig.new(
      :tool => "SVN",
      :tool_ids => "2",
      :repo_path => "http://a.b.c/x/y/z/fred.gif",
      :master_name => "yyy",
      :interval => "1 2 3 4 5"
    )
    assert_equal("SVN",scmconfig.tool)
    assert_equal(2,scmconfig.tool_ids)
    assert_equal("http://a.b.c/x/y/z/fred.gif",scmconfig.repo_path)
    assert_equal("yyy",scmconfig.master_name)
    assert_equal("1 2 3 4 5",scmconfig.interval)
  end
  def test_ut_scm_m_12
    scmconfig=ScmConfig.new( 
      :tool => "SVN",
      :tool_ids => "2",
      :repo_path => "http://a.b.c/x/y/z/fred.gif",
      :master_name => "yyy",
      :interval => "1 2 3 4 5"
    )
    scmconfig.base_revision = -1
    assert !scmconfig.valid?
    assert_equal  _("Invalid base revision."), scmconfig.errors.on(:base_revision)
    scmconfig.base_revision = 0
    assert_equal _("Invalid base revision."), scmconfig.errors.on(:base_revision)
    scmconfig.base_revision = 1
    assert scmconfig.valid?
  end

  def test_ut_scm_m_13
    scmconfig=ScmConfig.new(
      :tool => "SVN",
      :tool_ids => "2",
      :repo_path => "http://a.b.c/x/y/z/fred.gif",
      :master_name => "yyy",
      :interval => "1 2 3 4 5"
    )

    scmconfig.master_name = "abc"
    assert scmconfig.valid?

    master = ""
    (1..40).each do
      master << "y"
    end
    scmconfig.master_name = master
    assert scmconfig.valid?

    master = ""
    (1..41).each do
      master << "y"
    end
    scmconfig.master_name = master
    assert !scmconfig.valid?
    assert_equal _("Invalid master name."), scmconfig.errors.on(:master_name)
  end
  
  def test_ut_scm_m_14
    scmconfig=ScmConfig.new(
      :tool => "SVN",
      :tool_ids => "2",
      :repo_path => "http://a.b.c/x/y/z/fred.gif",
      :master_name => "yyy",
      :interval => "1 2 3 4 5"
    )
    scmconfig.interval = "1 2 3"
    assert !scmconfig.valid?
    assert_equal _("Invalid crontab format."), scmconfig.errors.on(:interval)

    scmconfig.interval = "1 2 3 4 5 6  7"
    assert !scmconfig.valid?
    assert_equal _("Invalid crontab format."), scmconfig.errors.on(:interval)

    scmconfig.interval = "* * * * *"
    assert scmconfig.valid?

    scmconfig.interval = "* * * * * *"
    assert !scmconfig.valid?

    scmconfig.interval = "*/30 * * *"
    assert !scmconfig.valid?

    scmconfig.interval = "1 2 3 4 5"
    assert scmconfig.valid?
  end
end