require 'rubygems'
begin
  require 'xattr'
rescue LoadError
end
unless defined? XAttr
  require 'ffi-xattr'
end

module Gflocator
  class Handler
    if defined? XAttr
      def xattr_get path, name
        XAttr.get path, name
      end
    else
      def xattr_get path, name
        Xattr::Lib.get path, false, name
      end
    end

    def get_locations args, glob_flag
      if glob_flag
        paths = Dir.glob args.join("\0")
      else
        paths = args
      end
      name = 'trusted.glusterfs.pathinfo'
      locations = {}
      for path in paths
        if (loc_str = xattr_get(path, name))
          res = loc_str.scan(/<POSIX(?:\([^\)]+\))?:([-\w\.]+):([^>]+)>/)
          locations[path] = res
        else
          raise RuntimeError, 'getxattr failed'
        end
      end
      locations
    end
  end
end
