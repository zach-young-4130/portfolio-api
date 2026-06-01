module Api
  module V1
    class FaqItemsController < BaseController
      skip_before_action :authenticate!, only: %i[index]
      before_action :authorize_admin!, only: %i[create update destroy]

      def index
        render_success(faq_items: FaqItemBlueprint.render_as_hash(visible_scope_for(FaqItem)))
      end

      def create
        item = FaqItem.new(faq_item_params)
        if item.save
          render_success(faq_item: FaqItemBlueprint.render_as_hash(item), status: :created)
        else
          render_error(item)
        end
      end

      def update
        item = find_resource_or_404(FaqItem) or return
        if item.update(faq_item_params)
          render_success(faq_item: FaqItemBlueprint.render_as_hash(item))
        else
          render_error(item)
        end
      end

      def destroy
        item = find_resource_or_404(FaqItem) or return
        item.destroy
        head :no_content
      end

      private

      def faq_item_params
        params.expect(faq_item: %i[question answer position published])
      end
    end
  end
end
