
defmodule BlogsApiWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :blogs_api,
    module: BlogsApiWeb.Auth.Guardian,
    error_handler: BlogsApiWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource

end
