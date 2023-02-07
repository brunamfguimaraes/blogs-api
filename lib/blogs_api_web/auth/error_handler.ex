
defmodule BlogsApiWeb.Auth.ErrorHandler do
  import Plug.Conn
  use BlogsApiWeb, :controller

  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{error: to_string(type)})
    message =
    case body do
      "{\"error\":\"unauthenticated\"}" -> "Token não encontrado"
    end
    conn
    #|> put_status(:unauthorized)
    #|> put_view(BlogsApiWeb.ErrorView)
    #|> render("401.json", message: message)
    #|> put_resp_content_type("application/json")
    |> send_resp(401, message)
  end
end
