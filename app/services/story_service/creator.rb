class StoryService::Creator < ApplicationService
  include TaggableHelper

  def initialize(params:, author:)
    @params = params
    @author = author
  end

  def call
    ActsAsTaggableOn.default_parser = TaggableParser
    story = Story.new(@params)
    story.author = @author
    story.save
    ServiceResponse.new(payload: story, errors: story.errors.full_messages)
  end
end
