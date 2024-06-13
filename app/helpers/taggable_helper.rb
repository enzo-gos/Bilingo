module TaggableHelper
  class TaggableParser < ActsAsTaggableOn::GenericParser
    def parse
      ActsAsTaggableOn::TagList.new.tap do |tag_list|
        next if @tag_list.empty?

        arr_tag_list = JSON.parse @tag_list
        tag_list.add(arr_tag_list.map { |h| h['value'] })
      end
    end
  end
end
