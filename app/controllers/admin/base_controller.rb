module Admin
  class BaseController < ApplicationController
    layout 'admin/base'

    before_action :authorize_admin
    before_action :set_locale

    def default_url_options(options = {})
      { locale: nil }.merge options
    end

    private

    def authorize_admin
      authorize :admin, :admin_access?
    end

    def set_locale
      I18n.locale = 'en'
    end
  end
end
