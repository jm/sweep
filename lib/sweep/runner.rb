require 'namespace'
require 'task'
require 'file_task'
require 'directory_task'

module Sweep
  class Runner
    class <<self
      attr_accessor :task_file
      
      def find_task_file(file)
        # Set the directory we're in now
        @executing_directory = Dir.pwd
        @task_file = nil
        
        # If they've given a file and it exists, then go with it
        if file && File.exist?(file)
          @task_file = file
          return file
        end
        
        # Otherwise we need to bubble up to find a tasks file
        current = Dir.pwd
        
        # Does our current directory have a task file?
        while !(@task_file = has_task_file?)
          # No?  Bubble bubble bubble...
          Dir.chdir("..")
          
          # Can't bubble any further and no task file?  Oh well!
          if Dir.pwd == current
            return nil
          end
          
          current = Dir.pwd
        end
        
        @task_file = Dir.pwd + "/" + @task_file if @task_file
        @task_file
      ensure
        # Make sure we switch back to our working directory
        Dir.chdir(@executing_directory)
      end
      
      # Looks for a task file in the current path.  Valid task filenames are:
      # Taskfile, Tasksfile, taskfile.rb, tasksfile.rb, Rakefile, rakefile.rb, and tasks.rb 
      def has_task_file?
        Dir.glob("{Taskfile,Tasksfile,taskfile.rb,tasksfile.rb,Rakefile,rakefile.rb,tasks.rb}").pop
      end
      
      # Output the tasks in a certain Rakefile
      def show_tasks_in(file)
        @tree = parse(File.read(file))
        
        output_tasks_in(@tree)
      end
      
      # Get all the tasks and output their name + description, then drill down into its
      # subnamespaces
      def output_tasks_in(ns)
        # Output each task...
        ns.tasks.each do |k,t|
          puts "sweep #{t.full_name}\t\t #{"# " + t.desc if t.desc}"
        end
        
        # Then do the same with each of its subspaces
        ns.subspaces.each do |k, n|
          output_tasks_in(n)
        end
      end
      
      # Run a task from a given set of tasks
      def run(task, tasks_file)
        # Setup our super fancy dependency graph...
        @executed_dependencies = []
        
        # Used to check for cyclic dependencies
        @level = 0
        
        # Bust up the task name
        pieces = task.split(":").flatten
      
        # Parse our file and setup the tree of tasks and namespaces
        main = parse(tasks_file)
        
        # If it's a top-level task, then just invoke it
        if pieces.length == 1
          main.tasks[pieces.first.to_s].invoke!
        else
          # Otherwise, let's dig for it
          dig_for_task(main, pieces)
        end
      end
      
      def parse(code)
        # Create a head namespace and insert the code into it
        head = Namespace.new("")
        head.instance_eval(code)
        
        head
      end

      # Drill down for a task
      def dig_for_task(ns, pieces)
        # Which namespace are we looking for?
        name = pieces.shift
        
        # Oh have we found it?
        if pieces.empty?
          # Invoke the task...
          if task = ns.tasks[name.to_s]
            invoke_with_dependencies(task)
          else
            # FAIL if it doesn't exist
            raise "Unknown task: #{name}"
          end
        else
          # Keep digging in the subspaces
          if ns.subspaces[name.to_s]
            dig_for_task(ns.subspaces[name.to_s], pieces)
          else
            # FAIL if the namespace doesn't exist
            raise "Unknown namespace: #{name}"
          end
        end
      end
      
      # Bubble up for a task.  When searching for a task to invoke, we need to bubble up through the namespaces
      # to find it if it's not in the current one.
      def bubble_for_task(ns, name)
        # Make sure we don't have a cyclical dependency
        @level += 1
        raise "It looks like you have a cyclic dependency!" if @level >= 16
        
        # If it's in the current namespace...
        if task = ns.tasks[name.to_s]
          # INVOKE IT
          invoke_with_dependencies(task)
        else
          # If not, then bubble up...
          if ns.parent
            bubble_for_task(ns.parent, name)
          else
            # Or FAIL if that isn't a real task.
            raise "Can't find task: #{name}"
          end
        end
      end
      
      # Invoke a task and its dependencies
      def invoke_with_dependencies(task)
        # No dependencies and hasn't been executed yet?
        if task.dependencies.empty? && !@executed_dependencies.include?(task)
          # Add the task to the dependencies, invoke the task, and reset the cyclical dependency tracker
          @executed_dependencies << task
          task.invoke!
        else
          # Has dependencies?  Iterate them and invoke those and then the current task.
          @executed_dependencies << task
          task.dependencies.each do |dep|
            bubble_for_task(task.owner, dep)
          end
          
          task.invoke!
        end
      ensure
        # Reset the cyclical dependency tracker
        @level = 0
      end
    end
  end
end
