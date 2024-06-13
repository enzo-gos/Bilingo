class StoryService::Updater < ApplicationService
  include TaggableHelper

  def initialize(params:, story:)
    @params = params
    @story = story
  end

  def call
    ActsAsTaggableOn.default_parser = TaggableParser
    @story.update(@params)
    ServiceResponse.new(payload: @story, errors: @story.errors.full_messages)
  end
end
