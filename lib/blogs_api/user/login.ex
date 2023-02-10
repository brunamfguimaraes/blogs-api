defmodule BlogsApi.User.Login do
  @moduledoc """
  Vai até o banco de dados e procura pelo email que corresponde ao email da requisição
  """
  alias BlogsApi.{User, Repo}

  def get_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        {:error, :invalid_login}

      user ->
        {:ok, user}
    end
  end
end
