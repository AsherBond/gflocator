# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gflocator/version"

Gem::Specification.new do |s|
  s.name        = "gflocator"
  s.version     = Gflocator::VERSION
  s.authors     = ["maebashi"]
  s.homepage    = ""
  s.summary     = %q{file location server for GlusterFS}
  s.description = %q{a daemon for providing responses to queries against file locations of GlusterFS}

  s.files         = `git ls-files`.split("\n").select {|e| /^tmp/!~e}
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "msgpack-rpc"
  s.add_runtime_dependency "ffi-xattr"
end
