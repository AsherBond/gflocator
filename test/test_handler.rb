require File.expand_path(File.dirname(__FILE__) + '/unittest_helper')

require 'gflocator/handler'

class Gflocator::Handler
  attr_accessor :t

  def xattr_get path, name
    path.sub!(%r{^/}, '')
    case @t
    when :g33b2
      "(<DISTRIBUTE:test-dht> <POSIX:g33b2.example.com:/glusterfs/t/#{path}>)"
    when :g33b2r
      "(<DISTRIBUTE:test-dht> (<REPLICATE:test-replicate-6> <POSIX:a006.example.com:/glusterfs/t/test/#{path}> <POSIX:b006.example.com:/glusterfs/t/test/#{path}>))"
    else
      "(<DISTRIBUTE:test-dht> <POSIX(/glusterfs/t):g330.example.com:/glusterfs/t/#{path}>)"
    end
  end
end

class TestHandler < Test::Unit::TestCase
  def setup
    @handler = Gflocator::Handler.new
  end

  def test_handler
    files = ['file1', 'file2']
    res = @handler.get_locations files, false
    ae 2, res.size
    files.each {|f|
      ae 1, res[f].size
      ae 2, res[f].first.size
    }
    @handler.t = :g33b2
    res = @handler.get_locations files, false
    files.each {|f|
      ae 1, res[f].size
      ae 2, res[f].first.size
    }
    @handler.t = :g33b2r
    res = @handler.get_locations files, false
    files.each {|f|
      ae 2, res[f].size
      ae 2, res[f].first.size
    }
  end
end
