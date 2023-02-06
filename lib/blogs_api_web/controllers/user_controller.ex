defmodule BlogsApiWeb.UserController do
  use BlogsApiWeb, :controller

  alias BlogsApiWeb.Auth.Guardian

  action_fallback BlogsApiWeb.FallbackController

  alias Elixir.BlogsApi

  def create(conn, params) do
    with {:ok, user} <- BlogsApi.create_user(params),
    {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("create.json", %{user: user, token: token})
    end
  end

  """
  def sign_in(conn, params) do
    with {:ok, token} <- Guardian.authenticate(params) do
      conn
      |> put_status(:ok)
      |> render("login.json", token: token)
    end
  end
"""
end