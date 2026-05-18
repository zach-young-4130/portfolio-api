module Api
  module V1
    class FaqItemsController < BaseController
      skip_before_action :authenticate!, only: %i[index]

      def index
        render_success(faq_items: FaqItemBlueprint.render_as_hash(visible_scope_for(FaqItem)))
      end

      def create
        item = FaqItem.new(faq_item_params)
        if item.save
          render_created(faq_item: FaqItemBlueprint.render_as_hash(item))
        else
          render_validation_errors(item)
        end
      end

      def update
        item = FaqItem.find_by(id: params[:id])
        return render_not_found unless item

        if item.update(faq_item_params)
          render_success(faq_item: FaqItemBlueprint.render_as_hash(item))
        else
          render_validation_errors(item)
        end
      end

      def destroy
        item = FaqItem.find_by(id: params[:id])
        return render_not_found unless item

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
