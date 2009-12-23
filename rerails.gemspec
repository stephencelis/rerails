Gem::Specification.new do |s|
  s.date = "2009-12-23"

  s.platform = Gem::Platform::RUBY
  s.name = "rerails"
  s.version = "3.0.pre.1"
  s.summary = "Reinforcing the Rails"
  s.description = "Assorted patches for Rails."

  s.files = Dir["CHANGELOG.rdoc", "README.rdoc", "lib/**/*"]

  s.add_dependency "rails", "= 3.0.pre"

  s.has_rdoc = true
  s.extra_rdoc_files = %w(CHANGELOG.rdoc README.rdoc)
  s.rdoc_options = %w(--main README.rdoc)

  s.author = "Stephen Celis"
  s.email = "stephen@stephencelis.com"
  s.homepage = "http://github.com/stephencelis/rerails"
  s.rubyforge_project = "rerails"
end
