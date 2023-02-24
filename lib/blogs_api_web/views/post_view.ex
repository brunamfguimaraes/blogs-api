defmodule BlogsApiWeb.PostView do
  use BlogsApiWeb, :view

  alias BlogsApiWeb.PostView
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

  def render("show.json", %{post_user: post_user}) do
    render_one(post_user, PostView, "post.json")
  end

  def render("index.json", %{all_posts: all_posts}) do
    render_many(all_posts, PostView, "post.json")
  end

  def render("post.json", %{post: %{post: post, user: user}}) do
    %{
      id: post.id,
      title: post.title,
      content: post.content,
      published: post.inserted_at,
      updated: post.updated_at,
      user: render("user.json", %{user: user})
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      display_name: user.display_name,
      email: user.email,
      image: user.image
    }
  end
end
