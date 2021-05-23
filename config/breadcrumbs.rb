crumb :root do
  link "ホーム", root_path
end

crumb :roadmaps_all do
  link "ロードマップ", all_user_roadmaps_path
  parent :root
end

crumb :steps_show do
  link "ステップ", user_roadmap_steps_path
  parent :roadmaps_all
end

crumb :posts_index do
  link "独学の記録", user_roadmap_step_posts_path
  parent :steps_show
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).