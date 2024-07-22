# Bilingo

Bilingo Stories is a vibrant platform dedicated to bilingual storytelling. Writers can effortlessly compose and share stories in their languages, while readers explore a diverse collection of bilingual stories spanning various genres.

# Table of Contents

- [Tech Stack](#techstack)
- [Features](#features)
- [Directory Structure](#directory-structure)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
  <br />
  <br />

# Architecture

# Tech Stack

| Category                   | Technology                         |
| -------------------------- | ---------------------------------- |
| Framework                  | Ruby on Rails 7                    |
| Language                   | Ruby 3.3                           |
| Database                   | PostgreSQL                         |
| Background Job             | Sidekiq                            |
| Notifications              | Noticed                            |
| Google Services            | Google Translator API + Gemini     |
| Error Monitoring           | Sentry                             |
| Authentication             | Devise + Omniauth (Facebook OAuth) |
| Authorization & Permission | Pundit + Rolify                    |
| Template engine            | Slim                               |
| WYSIWYG                    | Trix Editor & Medium Editor        |
| Styling                    | Tailwind CSS                       |
| Icon Set                   | Material Icons                     |
| Testing                    | RSpec + Factory Bot + Faker        |

<br />

# Directory Structure

```
.
├── app
│   ├── assets
│   │   ├── config
│   │   ├── images
│   │   │   ├── icons
│   │   │   │   ├── locales
│   │   │   │   ├── share
│   │   │   │   ├── facebook_icon.svg
│   │   │   │   ├── google_icon.svg
│   │   │   │   ├── search_icon.svg
│   │   │   │   └── writer_icon.svg
│   │   │   └── favicon.ico
│   │   └── stylesheets
│   │       ├── tailwind
│   │       ├── application.scss
│   │       ├── application.tailwind.css
│   │       └── actiontext.css
│   ├── controllers
│   │   ├── admin
│   │   │   ├── ban_requests_controller.rb
│   │   │   ├── ban_requests_controller.rb
│   │   │   ├── dashboards_controller.rb
│   │   │   ├── reports_controller.rb
│   │   │   ├── stories_controller.rb
│   │   │   └── users_controller.rb
│   │   ├── api
│   │   │   └── v1
│   │   │       └── meta_data_controller.rb
│   │   ├── users
│   │   ├── application_controller.rb
│   │   ├── auth_controller.rb
│   │   ├── chapters_controller.rb
│   │   ├── comments_controller.rb
│   │   ├── genres_controller.rb
│   │   ├── home_controller.rb
│   │   ├── notifications_controller.rb
│   │   ├── profiles_controller.rb
│   │   ├── reports_controller.rb
│   │   ├── share_controller.rb
│   │   ├── stories_controller.rb
│   │   └── topics_controller.rb
│   ├── helpers
│   │   ├── admin
│   │   │   ├── ban_requests_helper.rb
│   │   │   ├── ban_requests_helper.rb
│   │   │   ├── dashboards_helper.rb
│   │   │   ├── reports_helper.rb
│   │   │   ├── stories_helper.rb
│   │   │   └── users_helper.rb
│   │   ├── api
│   │   │   └── v1
│   │   │       └── meta_data_helper.rb
│   │   ├── users
│   │   ├── application_helper.rb
│   │   ├── auth_helper.rb
│   │   ├── chapters_helper.rb
│   │   ├── comments_helper.rb
│   │   ├── genres_helper.rb
│   │   ├── home_helper.rb
│   │   ├── notifications_helper.rb
│   │   ├── profiles_helper.rb
│   │   ├── reports_helper.rb
│   │   ├── share_helper.rb
│   │   ├── stories_helper.rb
│   │   ├── taggable_helper.rb
│   │   └── topics_helper.rb
│   ├── javascript
│   │   ├── channels
│   │   ├── controllers
│   │   ├── helpers
│   │   └── application.js
│   ├── jobs
│   ├── mailers
│   ├── models
│   │   ├── concerns
│   │   ├── application_record.rb
│   │   ├── banned_request.rb
│   │   ├── chapter.rb
│   │   ├── comment.rb
│   │   ├── genre.rb
│   │   ├── role.rb
│   │   ├── story_report.rb
│   │   ├── story_view.rb
│   │   ├── story.rb
│   │   └── user.rb
│   ├── notifiers
│   │   ├── delivery_methods
│   │   │   ├── admin_turbo_stream.rb
│   │   │   └── user_turbo_stream.rb
│   │   ├── application_delivery_method.rb
│   │   ├── application_notifier.rb
│   │   ├── banned_request_notifier.rb
│   │   ├── report_notifier.rb
│   │   └── solved_request_notifier.rb
│   ├── policies
│   │   ├── admin
│   │   │   ├── banned_request_policy.rb
│   │   │   ├── story_policy.rb
│   │   │   ├── story_report_policy.rb
│   │   │   └── user_policy.rb
│   │   ├── writer
│   │   │   ├── chapter_policy.rb
│   │   │   └── story_policy.rb
│   │   ├── admin_policy.rb
│   │   ├── application_policy.rb
│   │   ├── banned_request_policy.rb
│   │   ├── chapter_policy.rb
│   │   ├── comment_policy.rb
│   │   ├── notification_policy.rb
│   │   └── story_policy.rb
│   ├── services
│   │   ├── chapter_service
│   │   │   ├── creator.rb
│   │   │   ├── rephraser.rb
│   │   │   ├── summarizer.rb
│   │   │   └── translator.rb
│   │   ├── story_service
│   │   │   ├── creator.rb
│   │   │   └── updater.rb
│   │   └── application_service.rb
│   ├── sidekiq
│   └── views
│       ├── active_storage
│       ├── admin
│       ├── auth
│       ├── chapters
│       ├── comments
│       ├── devise
│       ├── genres
│       ├── home
│       ├── layouts
│       ├── profiles
│       ├── reports
│       ├── shared
│       ├── stories
│       ├── topics
│       └── writer
├── bin
├── config
├── db
│   ├── migrate
│   ├── schema.rb
│   └── seeds.rb
├── lib
├── log
├── public
├── storage
├── test
├── tmp
└── vendor



```

## Setup Instructions

1. **Clone the repository:**

   ```bash
   git clone <repository-url>
   ```

2. **Navigate to the project directory:**

   ```bash
   cd Bilingo
   ```

3. **Install dependencies:**

   ```bash
   bundle install
   ```

4. **Set up the database:**

   ```bash
   rails db:setup
   ```

5. **Set up environment variables:**

   - Create `.env` file in the project root.
   - Add required environment variables for Facenook OAuth, Google Translate, Gemini, and other configurations.

   ```bash
    NGROK_HOST

    MAIL_SERVICE
    MAIL_SERVICE_PORT
    MAIL_SERVICE_DOMAIN
    MAIL_SERVICE_PROTOCOL
    MAIL_SERVICE_AUTH

    MAIL_SERVICE_SENDER
    MAIL_SERVICE_USERNAME
    MAIL_SERVICE_PASSWORD

    DATABASE_USERNAME
    DATABASE_PASSWORD

    FACEBOOK_APP_ID
    FACEBOOK_APP_SECRET

    SENTRY_DSN

    GPT_API_KEY
    GOOGLE_API_KEY

    CLOUD_PROJECT_ID
    GOOGLE_APPLICATION_CREDENTIALS

    DATABASE_URL
    REDIS_URL

    RAILS_MASTER_KEY

    POSTGRES_HOST_AUTH_METHOD
    POSTGRES_USER
    POSTGRES_DB
    PGUSER

   ```

6. **Run dev:**

   ```bash
   ./bin/dev
   ```

7. **Access the project:**
   Open a web browser and go to `http://localhost:3000` (or the specified port if different).
