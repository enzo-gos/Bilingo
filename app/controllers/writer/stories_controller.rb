class Writer::StoriesController < ApplicationController
  layout 'writer/editor', only: [:new]

  def new
    @toolbar_title = t('writer_toolbar.title')
  end
end
