Gem::Specification.new do |s|
  s.date = "2009-12-23"

  s.platform = Gem::Platform::RUBY
  s.name = "rerails"
  s.version = "2.3.5.1"
  s.summary = "Reinforcing the Rails"
  s.description = "Assorted patches to make Rails a bit better."

  s.files = Dir["CHANGELOG.rdoc", "README.rdoc", "lib/**/*"]

  s.add_dependency "rails", "= 2.3.5"

  s.has_rdoc = true
  s.extra_rdoc_files = %w(CHANGELOG.rdoc README.rdoc)
  s.rdoc_options = %w(--main README.rdoc)

  s.author = "Stephen Celis"
  s.email = "stephen@stephencelis.com"
  s.homepage = "http://github.com/stephencelis/rerails"
  s.rubyforge_project = "rerails"
end
