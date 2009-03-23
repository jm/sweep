# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sweep}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremy McAnally"]
  s.date = %q{2009-03-22}
  s.default_executable = %q{sweep}
  s.description = %q{Rake, rebooted.}
  s.email = %q{jeremymcanally@gmail.com}
  s.executables = ["sweep"]
  s.extra_rdoc_files = ["History.txt", "README.txt", "bin/sweep"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "bin/sweep", "lib/sweep.rb", "lib/sweep/directory_task.rb", "lib/sweep/file_task.rb", "lib/sweep/namespace.rb", "lib/sweep/rule.rb", "lib/sweep/runner.rb", "lib/sweep/task.rb", "test/test_sweep.rb", "test/test_helper.rb", "test/test_file_task.rb", "test/test_namespace.rb", "test/test_task.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/jeremymcanally/sweep}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{sweep}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Rake, rebooted}
  s.test_files = ["test/test_file_task.rb", "test/test_helper.rb", "test/test_namespace.rb", "test/test_sweep.rb", "test/test_task.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bones>, [">= 2.2.0"])
    else
      s.add_dependency(%q<bones>, [">= 2.2.0"])
    end
  else
    s.add_dependency(%q<bones>, [">= 2.2.0"])
  end
end
