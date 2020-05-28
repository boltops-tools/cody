class Cody::CLI
  class Badge < Base
    def run
      resp = codebuild.batch_get_projects(names: [@full_project_name])
      project = resp.projects.first
      unless project
        puts "Project not found: #{@full_project_name}"
        return
      end

      url = project.badge.badge_request_url
      if @options[:markdown]
        puts "![CodeBuild](#{url})"
      else
        puts url
      end
    end
  end
end
