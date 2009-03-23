require 'fileutils'
require 'task'
require 'file_task'

module Sweep
  class DirectoryTask < FileTask
    # Create the directory!
    def behavior
      proc { FileUtils.mkdir_p(@name) }
    end
  end
end