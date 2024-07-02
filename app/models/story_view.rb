class StoryView < ApplicationRecord
  belongs_to :story, counter_cache: true
  belongs_to :chapter, counter_cache: true
end
