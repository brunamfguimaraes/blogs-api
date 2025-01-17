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

  def show(conn, %{"id" => "search", "q" => search_params}) do
    search_posts = BlogsApi.Post.SearchTerm.search_by_term(search_params)
    render(conn, "index.json",  all_posts: search_posts)
  end

  def show(conn, %{"id" => id}) do
    with {:ok, post} <- BlogsApi.fetch_post(id) do
      render(conn, "show.json", post: post)
    end
  end

  def delete(conn, %{"id" => id}) do
    id
    |> BlogsApi.post_delete()
    |> handle_delete(conn)
  end

  defp handle_delete({:ok, _post}, conn) do
    conn
    |> put_status(:no_content)
    |> text("")
  end

  defp handle_delete({:erro} = error, _conn), do: error

  def update(conn, params) do
    with current_user <- Guardian.Plug.current_resource(conn),
         {:ok, post} <- BlogsApi.update_post_user(current_user, params) do
      conn
      |> put_status(:ok)
      |> render("create.json", post: post)
    end
  end
end
