class StoryService::Updater < ApplicationService
  include TaggableHelper

  def self.call(params:, story:)
    ActsAsTaggableOn.default_parser = TaggableParser
    story.update(params)
    ServiceResponse.new(payload: story, errors: story.errors.full_messages)
  end
end
