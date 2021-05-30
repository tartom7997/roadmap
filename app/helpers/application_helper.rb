module ApplicationHelper

  # ページごとの完全なタイトルを返します。  
  def full_title(page_title = '')
    base_title = "Growthmap"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  # https://qiita.com/takehanKosuke/items/f4f2e49e84576a555ee6
  def sidebar_link_item(name, path)
    class_name = 'channel'
    class_name << ' active' if current_page?(path)

    content_tag :li, class:class_name do
      link_to name, path, class: 'channel_name'
    end
  end

  # https://tech.basicinc.jp/articles/145
  def default_meta_tags
    {
      canonical: request.original_url,
      noindex: ! Rails.env.production?,
      icon: [
        { href: image_url('favicon.ico') },
        { href: image_url('apple-touch-icon-180x180'), rel: 'apple-touch-icon', type: 'image/jpg' },
      ],
      charset: "UTF-8",
      og: defalut_og,
      twitter: default_twitter_card,
      facebook: default_facebook_card
    }
  end
  
  private
  
  def defalut_og
    {
      title: :full_title,          # :full_title とすると、サイトに表示される <title> と全く同じものを表示できる
      description: :description,   # 上に同じ
      type: 'website',
      url: request.url,
      image: image_url('icon-ogp-1200×630.png'),
      locale: 'ja_JP'
    }
  end
  
  def default_twitter_card
    {
      card: 'summary_large_image', # または summary
      site: '@Growthmap_ss'            # twitter ID
    }
  end

  def default_facebook_card
    {
      app_id: '2901972550122764'
    }
  end

end
