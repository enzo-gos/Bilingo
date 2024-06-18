class StoryService::Creator < ApplicationService
  include TaggableHelper

  def self.call(params:, author:)
    ActsAsTaggableOn.default_parser = TaggableParser
    story = Story.new(params)
    story.author = author
    chapter = story.chapters.create if story.save
    ServiceResponse.new(payload: { story: story, chapter: chapter }, errors: story.errors.full_messages)
  end
end
