# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jenkins-plugin-runtime}
  s.version = "0.1.17"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Charles Lowell}]
  s.date = %q{2011-12-27}
  s.description = %q{I'll think of a better description later, but if you're reading this, then I haven't}
  s.email = [%q{cowboyd@thefrontside.net}]
  s.homepage = %q{http://github.com/cowboyd/jenkins-plugin-runtime}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{jenkins-plugin-runtime}
  s.rubygems_version = %q{1.8.9}
  s.summary = %q{Runtime support libraries for Jenkins Ruby plugins}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<rake>, ["= 0.8.7"])
      s.add_development_dependency(%q<rspec>, ["~> 2.0"])
      s.add_development_dependency(%q<rspec-spies>, [">= 0"])
      s.add_development_dependency(%q<jenkins-war>, ["~> 1.445"])
    else
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<rake>, ["= 0.8.7"])
      s.add_dependency(%q<rspec>, ["~> 2.0"])
      s.add_dependency(%q<rspec-spies>, [">= 0"])
      s.add_dependency(%q<jenkins-war>, ["~> 1.445"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<rake>, ["= 0.8.7"])
    s.add_dependency(%q<rspec>, ["~> 2.0"])
    s.add_dependency(%q<rspec-spies>, [">= 0"])
    s.add_dependency(%q<jenkins-war>, ["~> 1.445"])
  end
end
