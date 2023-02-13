defmodule BlogsApiWeb.PostController do
  use BlogsApiWeb, :controller

  action_fallback BlogsApiWeb.FallbackController

  alias BlogsApi.Post

  def create(conn, params) do
    with {:ok, %Post{} = post} <- BlogsApi.create_post_user(params) do
      conn
      |> put_status(:created)
      |> render("create.json", post: post)
    end
  end


    """
    params
    #|> Elixir.BlogsApi.create_user_post()
    |> Create.create_post_user()
    |> handle_response(conn, "create.json", :created)
  end

  defp handle_response({:ok, post}, conn, view, status) do
    conn
    |> put_status(status)
    |> render(view, post: post)
  end

  defp handle_response({:error, _changeset} = error, _conn, _view, _status), do: error
  """
end
