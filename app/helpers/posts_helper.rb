module PostsHelper

    def categorise(post)
        if post.category_id == 1
          '本の紹介や書評'
        elsif post.category_id == 2
          'Podcastや音声'
        elsif post.category_id == 3
          'Youtubeや動画'
        elsif post.category_id == 4
          'ブログや参考記事'
        elsif post.category_id == 5
          'あなたの体験談やノウハウのシェア'
        end
      end

      def render_with_hashtags_post(hashbody)
        if hashbody.present?
          hashbody.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/) { |word| link_to word, "/post/hashtag/#{word.delete("#")}",data: {"turbolinks" => false} }.html_safe
        end
      end

end
