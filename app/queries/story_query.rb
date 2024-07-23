class StoryQuery < ApplicationQuery
  query_on Story

  def base_relation
    relation_class.includes([:author, :chapters, { cover_image_attachment: :blob }, :primary_genre, :secondary_genre]).order(updated_at: :desc).with_published
  end

  def call
    name_param = options.fetch(:name, nil)
    name_param ? relation.where("name ilike ?", "%#{name_param}%") : relation
  end
end
