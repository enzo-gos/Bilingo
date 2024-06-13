class StoryService::Creator < ApplicationService
  include TaggableHelper

  def self.call(params:, author:)
    ActsAsTaggableOn.default_parser = TaggableParser
    story = Story.new(params)
    story.author = author
    story.save
    ServiceResponse.new(payload: story, errors: story.errors.full_messages)
  end
end
