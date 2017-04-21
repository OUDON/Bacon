module ApplicationHelper
  def colored_name_link_tag(user)
    html = <<-HTML
<a href="#" class="user-name">
  <span style="color: #{ user.name_color }">#{ user.user_name }</span>
</a>
HTML
    html.html_safe
  end
end
