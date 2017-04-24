module ApplicationHelper
  def colored_name_link_tag(user_name, name_color)
    html = <<-HTML
<a href="#" class="user-name">
  <span style="color: #{ name_color }">#{ user_name }</span>
</a>
HTML
    html.html_safe
  end
end
