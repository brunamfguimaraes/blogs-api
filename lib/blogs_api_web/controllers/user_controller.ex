defmodule BlogsApiWeb.UserController do
  use BlogsApiWeb, :controller

  alias BlogsApiWeb.Auth.Guardian

  action_fallback(BlogsApiWeb.FallbackController)

  alias Elixir.BlogsApi

  def create(conn, params) do
    with {:ok, user} <- BlogsApi.create_user(params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("create.json", %{user: user, token: token})
    end
  end

  def sign_in(_conn, %{"email" => ""}) do
    {:error, "\"email\" is not allowed to be empty"}
  end


  def sign_in(_conn, %{"password" => ""}) do
    {:error, "\"password\" is not allowed to be empty"}
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    with {:ok, user, token} <- Guardian.authenticate(email, password) do
      conn
      |> put_status(:ok)
      |> render("login.json", %{user: user, token: token})
    end
  end

  def sign_in(_conn, %{"email" => _email}) do
    {:error, "password is required"}
  end


  def sign_in(_conn, %{"password" => _password}) do
    {:error, "email is required"}
  end

  def index(conn, _params) do
    all_users = BlogsApi.User.GetAll.get_all_users()
    render(conn, "index.json", all_users: all_users)
  end

  def show(conn, %{"id" => id}) do
    id
    |> BlogsApi.fetch_user()
    |> handle_response(conn, "show.json", :ok)
  end

  def delete(conn, %{"id" => id}) do
    id
    |> BlogsApi.delete_user()
    |> handle_delete(conn)
  end

  defp handle_delete({:ok, _user}, conn) do
    conn
    |> put_status(:no_content)
    |> text("")
  end

  defp handle_delete({:error, _reason} = error, _conn), do: error

  defp handle_response({:ok, user}, conn, view, status) do
    conn
    |> put_status(status)
    |> render(view, user: user)
  end

  defp handle_response({:error} = error, _conn, _view, _status), do: error
end
