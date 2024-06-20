module ApplicationHelper
  include Pagy::Frontend

  def all_genres
    Genre.all
  end

  def all_topics
    ActsAsTaggableOn::Tag.for_context(:tags).map { |tag| "# #{tag}" }
  end

  def fake_top_story
    [
      {
        cover: 'books/book_1.jpg',
        title: 'The Perfect Run',
        author: 'Maxime J. Durand',
        description: 'Ryan "Quicksave" Romano is an eccentric adventurer with a strange power: he can create a save-point in time and redo his life whenever he dies. Arriving in New Rome, the glitzy capital of sin of a rebuilding Europe, he finds the city torn between mega-corporations, sponsored heroes, superpowered criminals, and true monsters. It\'s a time of chaos, where potions can grant the power to rule the world and dangers lurk everywhere. <br>Ryan only sees different routes; and from Hero to Villain, he has to try them all. Only then will he achieve his perfect ending... no matter how many loops it takes.',
        views: '10M',
        comments: '15K',
        chapters: '130'
      },
      {
        cover: 'books/book_2.png',
        title: 'Cultist of Cerebon',
        author: 'Fizzicks',
        description: 'When Zareth first realized he had been reborn into a world that seemed to run on video game mechanics, he was ecstatic. He’d expected to go on to live an exciting life filled with danger and adventure. Instead, Zareth spent much of his new life living on the streets of Tal’Qamar before eventually becoming a Cultist to Cerebon, God of Flesh and Transformation.<br>However, being Cultist to the God of Flesh was much less exciting than Zareth had hoped and he now spent most of his time helping rich women smoothen their skin. Just when he had given up hope of his life ever being anything exceptional, everything begins to change when the city of Tal’Qamar enters a period of sharp political turmoil.<br>When Zareth finds himself being dragged into that turmoil, he very quickly learned that he should have been more careful about what he wished for.',
        views: '1M',
        comments: '11K',
        chapters: '33'
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

  def locales
    [
      {
        name: 'Tiếng việt',
        code: 'vi',
        flag: 'icons/locales/vi.svg'
      },
      {
        name: 'English',
        code: 'en',
        flag: 'icons/locales/en.svg'
      },
      {
        name: '中文',
        code: 'zh',
        flag: 'icons/locales/zh.svg'
      }
    ]
  end

  def current_locale
    I18n.locale
  end
end
