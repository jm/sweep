require File.dirname(__FILE__) + '/test_helper'

FILE_TASK_CODE = <<CODE
file "test.txt" => ["other.txt"] do
  File.open("test.txt", "w+") {|f| f.write("yo") }
end

file "other.txt" do
  File.open("other.txt", "w+") {|f| f.write("yo") }
end
CODE

class TaskTest < Test::Unit::TestCase
  def setup
    @tree = Sweep::Runner.parse(FILE_TASK_CODE)
    @task = @tree.tasks['test.txt']
  end
  
  def test_run_task
    @task.invoke!
    
    assert File.exist?("test.txt")
  end
  
  def test_run_task_if_file_doesnt_exist
    assert !File.exist?("other.txt")
    @tree.tasks['other.txt'].invoke!
    
    assert File.exist?("other.txt")
  end
  
  def test_run_task_if_dependency_is_newer
    @tree.tasks['other.txt'].invoke!
    @tree.tasks['test.txt'].invoke!
    old_time = File.mtime('test.txt')

    sleep(1)
    File.utime(Time.now, Time.now, "other.txt")
    @tree.tasks['test.txt'].invoke!

    assert old_time < File.mtime('test.txt')
  end
  
  def test_dont_run_task_if_dependency_is_not_newer
    @tree.tasks['other.txt'].invoke!
    @tree.tasks['test.txt'].invoke!
    old_time = File.mtime('test.txt')
    
    @tree.tasks['test.txt'].invoke!

    assert old_time == File.mtime('test.txt')
  end
  
  def teardown
    begin
      File.delete("test.txt")
      File.delete("other.txt")
    rescue
      nil
    end
  end
end