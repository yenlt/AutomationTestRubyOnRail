class DelPuTest < ActiveSupport::TestCase
  def test_000
    import_sql
  end
  
  def test_del_pu
    pj_ids             = []
    master_ids         = []
    task_ids           = []
    subtask_ids        = []
    pu_id              = 1

    pj_ids = Pj.find(:all, :conditions=>["pu_id = 1"]).map do |pj| pj.id end

    pj_ids.each do |pj_id|
      master_ids << Master.find(:all, :conditions=>["pj_id = ?", pj_id]).map do |master| master.id end
      task_ids   << Task.find(:all, :conditions=>["pj_id = ?", pj_id]).map do |task| task.id end
    end
    master_ids.flatten!
    task_ids.flatten!

    task_ids.each do |task_id|
      subtask_ids << Subtask.find(:all, :conditions=>["task_id = ?", task_id]).map do |subtask| subtask.id end
    end
    subtask_ids.flatten!

    Pu.destroy(1)

    # pus_usersレコード, privileges_usersレコードの削除を確認
    assert_equal 0, PusUsers.find(:all, :conditions=>["pu_id = ?", pu_id]).length
    assert_equal 0, PrivilegesUsers.find(:all, :conditions=>["pu_id = ?", pu_id]).length


    # pjレコードの削除を確認
    assert_equal 0, Pj.find(:all, :conditions=>["pu_id = 1"]).length

    # masterレコード, taskレコード, pjs_usersレコード, privileges_usersレコードの削除を確認
    pj_ids.each do |pj_id|
      assert_equal 0, PjsUsers.find(:all, :conditions=>["pj_id = ?", pj_id]).length
      assert_equal 0, PrivilegesUsers.find(:all, :conditions=>["pj_id = ?", pj_id]).length
      assert_equal 0, Master.find(:all, :conditions=>["pj_id = ?", pj_id]).length
      assert_equal 0, Task.find(:all, :conditions=>["pj_id = ?", pj_id]).length
    end

    # segmentレコード,directory_treeレコード, temp_fileレコードの削除を確認
    master_ids.each do |master_id|
      assert_equal 0, Segment.find(:all, :conditions=>["fk_id = ?", master_id]).length
      assert_equal 0, DirectoryTree.find(:all, :conditions=>["fk_id = ?", master_id]).length
      assert_equal 0, TempFile.find(:all, :conditions=>["master_id = ?", master_id]).length
    end

    # subtaskレコードの削除を確認
    task_ids.each do |task_id|
      assert_equal 0, Subtask.find(:all, :conditions=>["task_id = ?", task_id]).length
    end

    # resultレコード, analyze_logレコードの削除を確認
    subtask_ids.each do |subtask_id|
      assert_equal 0, AnalyzeLog.find(:all, :conditions=>["subtask_id = ?", subtask_id]).length
      assert_equal 0, Result.find(:all, :conditions=>["subtask_id = ?", subtask_id]).length
    end
  end
end
