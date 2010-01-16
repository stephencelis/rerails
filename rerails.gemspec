Gem::Specification.new do |s|
  s.date = "2010-01-15"

  s.name = "rerails"
  s.version = "3.0.pre.1"
  s.summary = "Reinforcing the Rails"
  s.description = "Assorted patches for Rails."

  s.files = Dir["CHANGELOG.rdoc", "README.rdoc", "lib/**/*"]

  s.add_dependency "rails", "= 3.0.pre"

  s.extra_rdoc_files = %w(CHANGELOG.rdoc README.rdoc)
  s.rdoc_options = %w(--main README.rdoc)

  s.author = "Stephen Celis"
  s.email = "stephen@stephencelis.com"
  s.homepage = "http://github.com/stephencelis/rerails"
  s.post_install_message = <<DOC
Remember to explicitly 'require "rerails"' in and initializer or \
'after_initialize', or require only the parts you need.
DOC
end
