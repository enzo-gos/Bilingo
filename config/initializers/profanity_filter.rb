require 'profanity_filter'

combined_blacklist = []

Dir[Rails.root.join('config', 'filters', '*.yml')].each do |file|
  blacklist = YAML.load_file(file)
  combined_blacklist.concat(blacklist['blacklist']) if blacklist['blacklist']
end

ProfanityFilter::Base.dictionary = combined_blacklist
