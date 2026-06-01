module Api
  module V1
    class ProjectsController < BaseController
      skip_before_action :authenticate!, only: %i[index show]
      before_action :authorize_admin!, only: %i[create update destroy]

      def index
        scope = visible_scope_for(Project).includes(:technologies, :tags)
        scope = scope.by_tag(params[:tag]) if params[:tag].present?
        scope = scope.by_technology(params[:technology]) if params[:technology].present?
        render_success(projects: ProjectBlueprint.render_as_hash(scope))
      end

      def show
        scope = current_user ? Project : Project.published
        project = scope.includes(:technologies, :tags).find_by(id: params[:id])
        return render_error("Project not found", status: :not_found) unless project

        render_success(project: ProjectBlueprint.render_as_hash(project))
      end

      def create
        project = Project.new(project_params)
        if project.save
          render_success(project: ProjectBlueprint.render_as_hash(load_project(project.id)), status: :created)
        else
          render_error(project)
        end
      end

      def update
        project = Project.find_by(id: params[:id])
        return render_error("Project not found", status: :not_found) unless project

        if project.update(project_params)
          render_success(project: ProjectBlueprint.render_as_hash(load_project(project.id)))
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

      def load_project(id)
        Project.includes(:technologies, :tags).find(id)
      end

      def project_params
        params.expect(project: [
          :title, :tagline, :description, :tech_stack,
          :cover_image_url, :live_url, :repo_url,
          :featured, :position, :published,
          :project_start, :project_end,
          { technology_ids: [], tag_ids: [] }
        ])
      end
    end
  end
end
