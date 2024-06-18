class ChapterService::Creator < ApplicationService
  def self.call(params:)
    chapter = Chapter.new(params)
    chapter.save
    ServiceResponse.new(payload: chapter, errors: chapter.errors.full_messages)
  end
end
