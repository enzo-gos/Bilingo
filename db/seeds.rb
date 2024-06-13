# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

def fake_genres
  ['Sci-Fi', 'Fantasy', 'Adventure', 'Mystery', 'Action', 'Horror', 'Humor', 'Erotica', 'Poetry', 'Other', 'Thriller', 'Romance', 'Children', 'Drama']
end

def fake_topics
  ['Love', 'Magic', 'Werewolf', 'Family', 'Friendships', 'Death', 'Supernatural', 'Mafia', 'Werewoles', 'Short Story', 'Alpha', 'Murder']
end

# Seed genres
fake_genres.each do |genre_name|
  Genre.find_or_create_by(name: genre_name)
end

# Seed tags
fake_topics.each do |tag|
  ActsAsTaggableOn::Tag.new(:name => tag).save
end
