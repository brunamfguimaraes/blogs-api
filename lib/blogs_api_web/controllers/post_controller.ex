defmodule BlogsApiWeb.PostController do
  use BlogsApiWeb, :controller

  alias BlogsApiWeb.Auth.Guardian

  action_fallback BlogsApiWeb.FallbackController

  def index(conn, _params) do
    all_posts = BlogsApi.Post.GetAll.get_all_posts()
    render(conn, "index.json", all_posts: all_posts)
  end

  def create(conn, params) do
    with user <- Guardian.Plug.current_resource(conn),
         {:ok, post} <- BlogsApi.create_post_user(user, params) do
      conn
      |> put_status(:created)
      |> render("create.json", post: post)
    end
  end
end
