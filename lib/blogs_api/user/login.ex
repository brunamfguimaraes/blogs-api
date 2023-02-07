defmodule BlogsApi.User.Login do
  alias BlogsApi.{User, Repo}

  def get_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        {:error, :bad_request}
      user ->
        {:ok, user}
    end
  end

  #def go_login(%{"email" => ""}), do: {:error, :bad_request, "\"email\" is not allowed to be empty"}
end
