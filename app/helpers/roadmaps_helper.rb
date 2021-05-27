module RoadmapsHelper

    def render_with_hashtags_roadmap(hashbody)
        hashbody.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/) { |word| link_to word, "/roadmap/hashtag/#{word.delete("#")}",data: {"turbolinks" => false} }.html_safe
      end

end
