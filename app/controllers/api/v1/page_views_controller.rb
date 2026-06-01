module Api
  module V1
    class PageViewsController < BaseController
      skip_before_action :authenticate!, only: %i[create]
      before_action :authorize_admin!, only: %i[stats]

      def create
        return head :no_content if PageView.bot?(request.user_agent)

        ip  = request.remote_ip
        geo = Geocoder.search(ip).first

        PageView.create!(
          path:       page_view_params[:path],
          ip_address: anonymize_ip(ip),
          user_agent: request.user_agent,
          referrer:   page_view_params[:referrer],
          city:       geo&.city,
          region:     geo&.state,
          country:    geo&.country
        )

        head :no_content
      end

      def stats
        scope = PageView.where(created_at: 30.days.ago..)

        render_success(
          total:      scope.count,
          by_country: scope.where.not(country: nil).group(:country).count.sort_by { |_, v| -v }.first(10).to_h,
          by_city:    scope.where.not(city: nil).group(:city).count.sort_by { |_, v| -v }.first(10).to_h,
          recent:     PageViewBlueprint.render_as_hash(scope.order(created_at: :desc).limit(25))
        )
      end

      private

      def anonymize_ip(ip)
        return nil if ip.blank?
        parts = ip.split(".")
        return ip unless parts.length == 4
        parts[0..2].join(".") + ".0"
      end

      def page_view_params
        params.expect(page_view: %i[path referrer])
      end
    end
  end
end
