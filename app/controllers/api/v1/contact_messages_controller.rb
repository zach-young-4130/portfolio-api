module Api
  module V1
    class ContactMessagesController < BaseController
      skip_before_action :authenticate!, only: %i[create]

      def index
        render_success(contact_messages: ContactMessageBlueprint.render_as_hash(ContactMessage.unread))
      end

      def create
        message = ContactMessage.new(message_params)
        if message.save
          render_created(contact_message: ContactMessageBlueprint.render_as_hash(message))
        else
          render_validation_errors(message)
        end
      end

      def update
        message = ContactMessage.find_by(id: params[:id])
        return render_not_found unless message

        message.update!(read_at: Time.current)
        render_success(contact_message: ContactMessageBlueprint.render_as_hash(message))
      end

      private

      def message_params
        params.expect(contact_message: %i[name email message])
      end
    end
  end
end
