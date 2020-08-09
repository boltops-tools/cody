# Represents a project with no builds yet. In this case we just return an info message for the columns.
# This allows `cody list` to work without breaking for Fresh projects with zero builds.
module Cody::List
  class NoBuildsProject
    def method_missing(meth, *args, &block)
      "no builds"
    end
  end
end
