defmodule BlogsApiWeb.Auth.ErrorHandler do
  import Plug.Conn
  use BlogsApiWeb, :controller

  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{error: to_string(type)})

    message =
      case body do
        "{\"error\":\"unauthenticated\"}" -> "Token não encontrado"
        "{\"error\":\"invalid_token\"}" -> "Token expirado ou inválido"
      end

    conn
    |> send_resp(401, message)
  end
end
