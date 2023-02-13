defmodule BlogsApi.User.Get do
  @moduledoc """
  Função que captura no banco de dados um usuário com base em seu ID
  """
  alias BlogsApi.{User, Repo}
  alias Ecto.UUID

  def call(id) do
    case UUID.cast(id) do
      :error -> {:error}
      {:ok, uuid} -> get(uuid)
    end

  end

  defp get(uuid) do
    case Repo.get(User, uuid) do
      nil -> {:error, "User not found!"}
      user -> {:ok, user}
    end
  end
end
