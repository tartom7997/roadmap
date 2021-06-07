module PostsHelper

    def categorise(post)
        if post.category_id == 1
          '本の紹介や書評をする'
        elsif post.category_id == 2
          'Podcastや音声から学ぶ'
        elsif post.category_id == 3
          'Youtubeや動画から学ぶ'
        elsif post.category_id == 4
          'ブログや参考記事から学ぶ'
        elsif post.category_id == 5
          '体験談やノウハウをシェアする'
        end
      end

      def render_with_hashtags_post(hashbody)
        if hashbody.present?
          hashbody.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/) { |word| link_to word, "/post/hashtag/#{word.delete("#")}",data: {"turbolinks" => false} }.html_safe
        end
      end

      def mechanize_title(post)
        if post.url.present?
          agent = Mechanize.new
          page = agent.get(post.url) rescue agent.get(error_url)
          if page.title.present?
            title = page.title
            post.update(url_title: title)
          else
            "no title"
          end
        end
      end

      def mechanize_description(post)
        if post.url.present?
          agent = Mechanize.new
          page = agent.get(post.url) rescue agent.get(error_url)
          if page.at("meta[property='og:description']").present?
            description = page.at("meta[property='og:description']")[:content]
            post.update(url_description: description)
          else
            "no description"
          end
        end
      end

      def mechanize_image(post)
        if post.url.present?
          agent = Mechanize.new
          page = agent.get(post.url) rescue agent.get(error_url)
          if page.at("meta[property='og:image']").present?
            image = page.at("meta[property='og:image']")[:content]
            post.update(url_image: image)
          else
            "no image"
          end
        end
      end

end
