require File.dirname(__FILE__) + '/test_helper'

class SweepTest < Test::Unit::TestCase
  def setup
    @tree = Sweep::Runner.parse(TEST_FILE)
  end
  
  def test_namespace
    assert_equal 1, @tree.subspaces.keys.length
  end
  
  def test_nested_namespace
    assert_equal 1, @tree.subspaces['first'].subspaces.keys.length    
  end
  
  def test_task
    assert_equal 3, @tree.tasks.keys.length
  end
  
  def test_task_in_namespace
    assert_equal 1, @tree.subspaces['first'].tasks.keys.length
  end
  
  def test_task_with_dependencies
    assert_equal ["two", "poop.txt", "what/hi/hah"], @tree.subspaces['first'].subspaces['second'].tasks.values.last.dependencies
  end
  
  def test_task_with_parameters
    assert_equal [:param_one, :param_two], @tree.subspaces['first'].subspaces['second'].tasks.values.first.args
  end
end