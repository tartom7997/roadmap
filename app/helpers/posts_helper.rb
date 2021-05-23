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
end
