# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tween}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Morin"]
  s.date = %q{2010-10-15}
  s.description = %q{Fluid motion using tweens for Ruby}
  s.email = %q{michael.c.morin@gmail.com}
  s.extra_rdoc_files = ["README.markdown", "lib/tween.rb"]
  s.files = ["Manifest", "README.markdown", "Rakefile", "examples/demo.rb", "lib/tween.rb", "tween.gemspec"]
  s.homepage = %q{http://ruby.about.com/}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Tween", "--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{tween}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Fluid motion using tweens for Ruby}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
