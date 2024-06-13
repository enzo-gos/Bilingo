class Api::V1::MetaDataController < ApplicationController
  def tags
    tags = ActsAsTaggableOn::Tag.all.map(&:name)
    respond_to do |format|
      format.json { render json: tags }
    end
  end
end
