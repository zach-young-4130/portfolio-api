module Api
  module V1
    class TagsController < BaseController
      skip_before_action :authenticate!, only: %i[index]
      before_action :authorize_admin!, only: %i[create update destroy]

      def index
        render_success(tags: TagBlueprint.render_as_hash(Tag.ordered))
      end

      def create
        tag = Tag.new(tag_params)
        if tag.save
          render_success(tag: TagBlueprint.render_as_hash(tag), status: :created)
        else
          render_error(tag)
        end
      end

      def update
        tag = Tag.find_by(id: params[:id])
        return render_error("Tag not found", status: :not_found) unless tag

        if tag.update(tag_params)
          render_success(tag: TagBlueprint.render_as_hash(tag))
        else
          render_error(tag)
        end
      end

      def destroy
        tag = Tag.find_by(id: params[:id])
        return render_error("Tag not found", status: :not_found) unless tag

        tag.destroy
        head :no_content
      end

      private

      def tag_params
        params.expect(tag: %i[name slug])
      end
    end
  end
end
