require File.dirname(__FILE__) + '/test_helper'

class NamespaceTest < Test::Unit::TestCase
  def setup
    @ns = Sweep::Namespace.new("testing")
  end
  
  def test_default_values
    assert_equal Hash.new, @ns.subspaces
    assert_equal Hash.new, @ns.tasks
    assert_equal "testing", @ns.name
    assert_equal nil, @ns.parent    
  end
  
  def test_ns_with_parent
    child = Sweep::Namespace.new("child", @ns)
    
    assert_equal @ns, child.parent
  end
  
  def test_add_task_method
    @ns.desc "Things are great"
    @ns.add_task("thing", nil, Sweep::Task) { nil }
    
    assert_equal 1, @ns.tasks.values.length
  end
  
  def test_set_desc
    @ns.desc "Things are great"
    @ns.add_task("thing", nil, Sweep::Task) { nil }
    
    assert_equal "Things are great", @ns.tasks.values.first.desc
  end
  
  def test_add_namespace
    @ns.namespace("hello") { nil }
    assert_equal 1, @ns.subspaces.values.length
  end

  def test_add_file_task
    @ns.task("hello") { nil }
    assert_equal 1, @ns.tasks.values.length
    assert_equal "hello", @ns.tasks.values.first.name
  end
  
  def test_add_file_task
    @ns.file "things.txt"
    assert_equal 1, @ns.tasks.values.length
    assert_equal "things.txt", @ns.tasks.values.first.name
  end
  
  def test_add_directory_task
    @ns.directory "hello/w00t"
    assert_equal 1, @ns.tasks.values.length
    assert_equal "hello/w00t", @ns.tasks.values.first.name
  end
end