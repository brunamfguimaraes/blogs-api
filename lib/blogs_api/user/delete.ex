defmodule BlogsApi.User.Delete do
  alias BlogsApi.{User, Repo}
  alias Ecto.UUID

  def call(id) do
    case UUID.cast(id) do
      :error -> {:error, "Invalid ID format"}
      {:ok, uuid} -> delete(uuid)
    end
  end

  defp delete(uuid) do
    case fetch_user(uuid) do
      nil -> {:error, "Usuário não encontrado!"}
      user -> Repo.delete(user)
    end
  end

  defp fetch_user(uuid), do: Repo.get(User, uuid)
end
