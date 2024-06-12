class ShareController < ApplicationController
  def index
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('share-modal-body', partial: 'share/modal_body/share')
        ]
      end
    end
  end
end
