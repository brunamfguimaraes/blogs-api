defmodule BlogsApiWeb.FallbackController do
  use BlogsApiWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "Usuário não autorizado"})
  end

  def call(conn, {:error, :email_exists}) do
    conn
    |> put_status(:conflict)
    |> put_view(BlogsApiWeb.ErrorView)
    |> render("409.json", message: "Usuário já existe")
  end

  def call(conn, {:error, :post_not_found}) do
    conn
    |> put_status(:not_found)
    |> json(%{error: "Post não existe"})
  end

  def call(conn, {:error}) do
    conn
    |> put_status(:not_found)
    |> json(%{error: "Usuário não existe"})
  end

  def call(conn, {:error, :invalid_login}) do
    conn
    |> put_status(:bad_request)
    |> put_view(BlogsApiWeb.ErrorView)
    |> render("400.json", message: "Campos inválidos")
  end

  def call(conn, {:error, message}) do
    conn
    |> put_status(:bad_request)
    |> put_view(BlogsApiWeb.ErrorView)
    |> render("400.json", message: message)
  end
end
