# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

require "rake/classic_namespace"
require 'rake/testtask'

ensure_in_path 'lib'
require 'sweep'

desc "Run the unit tests" 
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

task :default => 'test'

PROJ.name = 'sweep'
PROJ.authors = 'Jeremy McAnally'
PROJ.email = 'jeremymcanally@gmail.com'
PROJ.url = 'http://github.com/jeremymcanally/sweep'
PROJ.version = Sweep::VERSION
PROJ.rubyforge.name = 'sweep'

PROJ.spec.opts << '--color'

# EOF
