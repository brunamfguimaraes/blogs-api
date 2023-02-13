defmodule BlogsApiWeb.PostView do
  use BlogsApiWeb, :view

  alias BlogsApi.Post

  def render("create.json", %{
        post: %Post{title: title, content: content, user_id: user_id}
      }) do
    %{
      post: %{
        title: title,
        content: content,
        user_id: user_id
      }
    }
  end
end
