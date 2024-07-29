# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Define the fake genres and topics
def fake_genres
  ['Sci-Fi', 'Fantasy', 'Adventure', 'Mystery', 'Action', 'Horror', 'Humor', 'Erotica', 'Poetry', 'Other', 'Thriller', 'Romance', 'Children', 'Drama']
end

def fake_topics
  ['Love', 'Magic', 'Werewolf', 'Family', 'Friendships', 'Death', 'Supernatural', 'Mafia', 'Werewoles', 'ShortStory', 'Alpha', 'Murder']
end

# Seed genres
fake_genres.each do |genre_name|
  Genre.find_or_create_by(name: genre_name)
end

# Seed tags
fake_topics.each do |tag|
  ActsAsTaggableOn::Tag.find_or_create_by(name: tag)
end

# Ensure admin role exists
admin_role = Role.find_or_create_by!(name: 'admin')

# Ensure user role exists
user_role = Role.find_or_create_by!(name: 'user')

users_data = [
  { email: 'enzo.nguyen.gos@gmail.com', first_name: 'Nguyen', last_name: 'Enzo', password: '123123', roles: [admin_role] },
]

users_data.each do |user_data|
  user = User.find_or_create_by!(email: user_data[:email]) do |u|
    u.password = user_data[:password]
    u.first_name = user_data[:first_name]
    u.last_name = user_data[:last_name]
    u.password = user_data[:password]
    u.roles = user_data[:roles] || [user_role]
  end
end

# def long_description(story_number)
#   "This is the extended description for Story #{story_number}. " \
#   "In a world where the boundaries between reality and fantasy blur, " \
#   "a group of unlikely heroes must navigate through challenges that test their courage, " \
#   "friendship, and determination. Follow the journey of protagonists as they encounter " \
#   "breathtaking adventures, uncover dark mysteries, and face formidable adversaries. " \
#   "With each turn of the page, delve deeper into a narrative rich with emotion, " \
#   "intrigue, and wonder. Story #{story_number} is not just a tale, but an immersive " \
#   "experience that explores the depths of human spirit and the power of imagination."
# end

# # Seed stories and chapters
# 20.times do |i|
#   primary_genre = Genre.order("RANDOM()").first
#   secondary_genre = Genre.order("RANDOM()").first
#   book_covers = ['book_1.jpg', 'book_2.jpg', 'book_2.png', 'book_3.jpg']

#   story = Story.find_or_create_by!(
#     name: "Story #{i + 1}",
#     author_id: 1
#   ) do |s|
#     s.primary_genre = primary_genre
#     s.secondary_genre = secondary_genre
#     s.description = long_description(i + 1)
#     s.language_code = "EN"
#     s.position = i + 1
#     s.banned = false
#     s.cover_image.attach(io: File.open("app/assets/images/books/#{book_covers.sample}"), filename: "cover_image_#{i + 1}.jpg", content_type: 'image/jpeg')
#     selected_tags = ActsAsTaggableOn::Tag.order("RANDOM()").limit(3).pluck(:name)
#     s.tag_list.add(*selected_tags)
#   end

#   Chapter.find_or_create_by!(
#     title: "Chapter 1 of Story #{i + 1}",
#     story: story
#   ) do |c|
#     c.content = "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain. These cases are perfectly simple and easy to distinguish. In a free hour, when our power of choice is untrammelled and when nothing prevents our being able to do what we like best, every pleasure is to be welcomed and every pain avoided. But in certain circumstances and owing to the claims of duty or the obligations of business it will frequently occur that pleasures have to be repudiated and annoyances accepted. The wise man therefore always holds in these matters to this principle of selection: he rejects pleasures to secure other greater pleasures, or else he endures pains to avoid worse pains"
#     c.published = true
#     c.position = 1
#   end
# end
