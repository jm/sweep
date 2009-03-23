require 'task'

module Sweep
  class FileTask < Task
    # If the file doesn't exist or is older than any of its dependencies, then rebuild it
    def run_task?
      !File.exists?(name) || self.dependencies.map {|f| File.exists?(f) && (File.mtime(f) > File.mtime(name)) }.include?(true)
    end
  end
end