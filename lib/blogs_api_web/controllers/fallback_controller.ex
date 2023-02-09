defmodule BlogsApiWeb.FallbackController do

  use BlogsApiWeb, :controller


  def call(conn, {:error, :email_exists}) do
    conn
    |> put_status(:conflict)
    |> put_view(BlogsApiWeb.ErrorView)
    |> render("409.json", message: "Usuário já existe")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(BlogsApiWeb.ErrorView)
    |> render("401.json", message: "User Unauthorized")
  end

  def call(conn, {:error, result}) do
    conn
    |> put_status(:bad_request)
    |> put_view(BlogsApiWeb.ErrorView)
    |> render("400.json", result: result)
  end

  def call(conn, {:error, message}) do
    conn
    |> put_status(:bad_request)
    |> put_view(BlogsApiWeb.ErrorView)
    |> render("400.json", message: message)
  end

end
