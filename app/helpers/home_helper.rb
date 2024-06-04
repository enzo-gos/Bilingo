module HomeHelper
  def fake_genres
    ['Sci-Fi', 'Fantasy', 'Adventure', 'Mystery', 'Action', 'Horror', 'Humor', 'Erotica', 'Poetry', 'Other', 'Thriller', 'Romance', 'Children', 'Drama']
  end

  def fake_topics
    ['# Love', '# Magic', '# Werewolf', '# Family', '# Friendships', '# Death', '# Supernatural', '# Mafia', '# Werewoles', '# Short Story', '# Alpha', '# Murder']
  end

  def fake_top_story
    [
      {
        cover: 'books/book_1.jpg',
        title: 'My Secret Ex-husband',
        author: 'RHea Verma',
        description: "Katharine Smith is the heir of the famous 'The Smith's' company. She is rich and beautiful. All her employees call her a heartless bitch. A spoilt brat. But there is more to her than she lets out to the world. she has buried a secret inside heart for five years now. A  secret of a painful  heart break. A secret marriage. Follow Katharine's journey to know what happens to her when she meets her ex-husband. Her secret ex-husband like, after three years.",
        views: '408K',
        comments: '726',
        chapters: '55'
      },
      {
        cover: 'books/book_2.jpg',
        title: 'The Alpha And His Possession',
        author: 'Nojamsbts',
        description: "Killian King; cold, distant, dominant, and possessive over what's his is top dog at school and known as the bad boy, so what happens when Finnick Green, the nerdy shy and socially awkward boy, trips into his life and creates an uproar that leaves his alpha wolf trembling.",
        views: '17.9M',
        comments: '126K',
        chapters: '39'
      },
      {
        cover: 'books/book_3.jpg',
        title: 'Shielded: A Valkyrie Saga Book 1',
        author: 'E.A.Baker',
        description: "Ray has one goal in life; to survive long enough to age out of the foster care system, and she has been using her unique Gifts to keep any unwanted attention off of her for years. Not only is Ray trying to avoid her foster mother, but has also done everything in her power to stay hidden from the supernatural world that she belongs to. What will Ray do when the local clan of Valkyries finally discovers that she has been hiding right under their noses?
        <br />
        Female Valkyries are so rare, they are only found within the ancient royal Valkyrie lines, and males out number them 500 to 1. What will the Oakland Clan do when they discover a very rare and very powerful female Valkyrie in their territory?
        <br />
        This is a supernatural slow burn reverse harem novel.",
        views: '304K',
        comments: '364',
        chapters: '30'
      }
    ]
  end
end
