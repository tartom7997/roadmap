# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://growthmap-ss.com/"
SitemapGenerator::Sitemap.sitemaps_host = "https://s3-ap-northeast-1.amazonaws.com/#{ENV['S3_BUCKET']}"
SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(
  ENV['S3_BUCKET'],
  aws_access_key_id: ENV['S3_ACCESS_KEY'],
  aws_secret_access_key: ENV['S3_SECRET_KEY'],
  aws_region: ENV['S3_REGION'],
)

SitemapGenerator::Sitemap.create do
  add root_path
  add about_path
  add new_contact_path
  add term_of_use_path
  add privacy_policy_path
  add specified_commercial_transaction_act_path
  add users_path, changefreq: 'daily'     
  add roadmaps_path, changefreq: 'daily'     
  add posts_path, changefreq: 'daily'     

    roadmaps = Roadmap.includes(:user)
    roadmaps.each do |roadmap|
      add all_user_roadmaps_path(user_id: roadmap.user.id), changefreq: 'daily', :lastmod => roadmap.updated_at
      add user_roadmap_path(roadmap.id, user_id: roadmap.user.id), changefreq: 'daily', :lastmod => roadmap.updated_at
    end

    steps = Step.includes(:roadmap => :user)
    steps.each do |step|
      add user_roadmap_steps_path(user_id: step.roadmap.user.id, roadmap_id: step.roadmap.id), changefreq: 'daily', :lastmod => step.updated_at
    end

    posts = Post.includes({:step => {:roadmap => :user}})
    posts.each do |post|
      add all_user_roadmap_step_posts_path(step_id: post.step.id, roadmap_id: post.step.roadmap.id, user_id: post.step.roadmap.user.id), changefreq: 'daily', :lastmod => post.updated_at
      add user_roadmap_step_post_path(post.id, step_id: post.step.id,roadmap_id:post.step.roadmap.id,user_id:post.step.roadmap.user.id), changefreq: 'daily', :lastmod => post.updated_at
    end

  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
