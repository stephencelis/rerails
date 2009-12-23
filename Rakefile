begin
  require "vendor/gems/environment.rb"
rescue LoadError
  warn "Run `gem bundle --only=test`."
end

require "rake/testtask"

task :default => :test

desc "Test the Rerails."
Rake::TestTask.new(:test) do |t|
  t.libs << "lib" << "test"
  t.pattern = "test/**/*_test.rb"
  t.verbose = true
end
