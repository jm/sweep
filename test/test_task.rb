require File.dirname(__FILE__) + '/test_helper'

class TaskTest < Test::Unit::TestCase
  def setup
    @a = @t = nil
    @task = Sweep::Task.new("thing")
    @task.behavior = Proc.new {|t, a| @t = t; @a = a;}
    @task.dependencies = {}
    @task.owner = Sweep::Namespace.new("")
  end
  
  def test_deps_alias
    assert_equal Hash.new, @task.prerequisites
  end
  
  def test_run_task
    class <<@task
      def run_task?
        true
      end
    end
    
    @task.invoke!
    assert_not_nil @t
  end
  
  def test_dont_run_task
    class <<@task
      def run_task?
        false
      end
    end
    
    @task.invoke!
    assert_nil @t
  end
  
  def test_invoke
    @task.invoke!
    assert_not_nil @t
  end
end