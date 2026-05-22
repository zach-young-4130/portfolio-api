module Api
  module V1
    class CommunityItemsController < BaseController
      skip_before_action :authenticate!, only: %i[index]
      before_action :authorize_admin!, only: %i[create update destroy]

      def index
        render_success(community_items: CommunityItemBlueprint.render_as_hash(visible_scope_for(CommunityItem)))
      end

      def create
        item = CommunityItem.new(community_item_params)
        if item.save
          render_success(community_item: CommunityItemBlueprint.render_as_hash(item), status: :created)
        else
          render_error(item)
        end
      end

      def update
        item = CommunityItem.find_by(id: params[:id])
        return render_error("Community item not found", status: :not_found) unless item

        if item.update(community_item_params)
          render_success(community_item: CommunityItemBlueprint.render_as_hash(item))
        else
          render_error(item)
        end
      end

      def destroy
        item = CommunityItem.find_by(id: params[:id])
        return render_error("Community item not found", status: :not_found) unless item

        item.destroy
        head :no_content
      end

      private

      def community_item_params
        params.expect(community_item: %i[title description url role year tech_stack position published])
      end
    end
  end
end
