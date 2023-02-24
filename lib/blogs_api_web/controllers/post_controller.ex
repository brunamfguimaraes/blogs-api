defmodule BlogsApiWeb.PostController do
  use BlogsApiWeb, :controller

  alias BlogsApiWeb.Auth.Guardian

  action_fallback(BlogsApiWeb.FallbackController)

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

  def show(conn, %{"id" => id}) do
    with {:ok, post} <- BlogsApi.fetch_post(id),
         post_user <- BlogsApi.Post.GetAll.get_all_posts_users(post) do
      render(conn, "show.json", post_user: post_user)
    end
  end

  def delete(conn, %{"id" => id}) do
    id
    |> Elixir.BlogsApi.delete_post()
    |> handle_delete(conn)
  end

  defp handle_delete({:ok, _post}, conn) do
    conn
    |> put_status(:no_content)
    |> text("")
  end

  defp handle_delete({:error, _reason} = error, _conn), do: error
end
