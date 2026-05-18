module Api
  module V1
    class ProjectsController < BaseController
      skip_before_action :authenticate!, only: %i[index show]
      before_action :authorize_admin!, only: %i[create update destroy]

      def index
        render_success(projects: ProjectBlueprint.render_as_hash(visible_scope_for(Project)))
      end

      def show
        scope = current_user ? Project : Project.published
        project = scope.find_by(id: params[:id])
        return render_error("Project not found", status: :not_found) unless project

        render_success(project: ProjectBlueprint.render_as_hash(project))
      end

      def create
        project = Project.new(project_params)
        if project.save
          render_success(project: ProjectBlueprint.render_as_hash(project), status: :created)
        else
          render_error(project)
        end
      end

      def update
        project = Project.find_by(id: params[:id])
        return render_error("Project not found", status: :not_found) unless project

        if project.update(project_params)
          render_success(project: ProjectBlueprint.render_as_hash(project))
        else
          render_error(project)
        end
      end

      def destroy
        project = Project.find_by(id: params[:id])
        return render_error("Project not found", status: :not_found) unless project

        project.destroy
        head :no_content
      end

      private

      def project_params
        params.expect(project: %i[title tagline description tech_stack cover_image_url live_url repo_url featured position published project_start project_end])
      end
    end
  end
end
