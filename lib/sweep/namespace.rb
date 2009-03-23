module Sweep
  class Namespace
    attr_accessor :subspaces, :tasks, :parent, :name
    
    def initialize(name, parent = nil)
      @subspaces = {}
      @tasks = {}
      @name = name
      @parent = parent
    end
    
    # Is this the head namespace?
    def head?
      name.empty?
    end
    
    # Add a comment/description to a task
    def desc(text)
      @desc = text
    end
    
    alias :comment :desc
    
    # Show the full name of a namespace (i.e., include its parents)
    def full_name
      if parent.nil?
        name
      else
        "#{parent.full_name}#{name}:"
      end
    end
  
    # Add a task to this namespace
    def task(name, args=nil, &behavior)
      add_task(name, args, Task, &behavior)
    end
  
    # Add a sub-namespace to this namespace
    def namespace(name, &behavior)
      n = Namespace.new(name.to_s, self)

      n.instance_eval(&behavior)
      @subspaces[name.to_s] = n
    end
  
    # Add a file task to this namespace
    def file(name, args=nil, &behavior)
      add_task(name, args, FileTask, &behavior)
    end
  
    # Add a directory task to this namespace
    def directory(name, args=nil, &behavior)
      add_task(name, args, DirectoryTask, &behavior)
    end
  
    # Add a task to this namespace
    def add_task(name, args, klass, &behavior)
      dependencies = nil
      
      # Figure out which syntax we're using here...
      if name.is_a?(Hash)
        # If it's a Hash, we have dependencies
        dependencies = name.values.first.map {|d| d.to_s}
        name = name.keys.first.to_s
      elsif args.is_a?(Hash)
        # If the second param is a Hash, then we have args and deps
        dependencies = args.values.first.map {|d| d.to_s}
        
        args = args.keys.first  
      end
      
      # Create a new Task and populate it
      t = klass.new(name.to_s)
      t.owner = self
      t.behavior = behavior if block_given?
      t.dependencies = dependencies || []
      t.desc = @desc
      
      # Set the args
      if args.is_a?(Array)
        t.args = args
      end
      
      # Add the task to the tasks collection
      @tasks[name.to_s] = t
      @desc = nil
    end
  
    # I don't support rules yet and I probably won't actually ever support them.
    def rule(*args)
      raise NotYetImplementedError
    end
  end
end