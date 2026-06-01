module Api
  module V1
    class TechnologiesController < BaseController
      skip_before_action :authenticate!, only: %i[index]
      before_action :authorize_admin!, only: %i[create update destroy]

      def index
        render_success(technologies: TechnologyBlueprint.render_as_hash(Technology.ordered))
      end

      def create
        technology = Technology.new(technology_params)
        if technology.save
          render_success(technology: TechnologyBlueprint.render_as_hash(technology), status: :created)
        else
          render_error(technology)
        end
      end

      def update
        technology = find_resource_or_404(Technology) or return
        if technology.update(technology_params)
          render_success(technology: TechnologyBlueprint.render_as_hash(technology))
        else
          render_error(technology)
        end
      end

      def destroy
        technology = find_resource_or_404(Technology) or return
        technology.destroy
        head :no_content
      end

      private

      def technology_params
        params.expect(technology: %i[name slug category])
      end
    end
  end
end
