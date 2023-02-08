defmodule BlogsApiWeb.Auth.Guardian do
  @moduledoc """
    Guardian é uma biblioteca de autenticação utilizada tendo como base JWT
  """

  use Guardian, otp_app: :blogs_api

  alias BlogsApi.User.Login

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    claims
    |> Map.get("sub")
    |> BlogsApi.fetch_user()
  end

  def authenticate(email, password) do
    with {:ok, user} <- Login.get_by_email(email) do
      case validate_password(password, user.encrypted_password) do
        true ->
          create_token(user)
        false ->
          {:error, :bad_request}
      end
    end
  end

  defp validate_password(password, encrypted_password) do
    Bcrypt.verify_pass(password, encrypted_password)
  end

  defp create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user)
    {:ok, user, token}
  end
end
