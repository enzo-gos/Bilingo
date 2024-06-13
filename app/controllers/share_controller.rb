class ShareController < ApplicationController
  def index
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('share-modal-body', partial: 'share/modal_body/share', locals: { url: "http://localhost:3000/stories/#{params[:id]}" })
        ]
      end
    end
  end
end
