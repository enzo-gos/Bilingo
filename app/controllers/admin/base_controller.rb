module Admin
  class BaseController < ApplicationController
    before_action :authorize_admin

    private

    def authorize_admin
      authorize :admin, :admin_access?
    end
  end
end
