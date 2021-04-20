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
end

# https://qiita.com/takehanKosuke/items/f4f2e49e84576a555ee6
  def sidebar_link_item(name, path)
    class_name = 'channel'
    class_name << ' active' if current_page?(path)

    content_tag :li, class:class_name do
      link_to name, path, class: 'channel_name'
    end
  end