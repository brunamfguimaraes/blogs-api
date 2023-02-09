defmodule BlogsApi.User.Get do
  alias BlogsApi.{User, Repo}
  alias Ecto.UUID

  def call(id) do
    case UUID.cast(id) do
      :error -> {:error, "Invalid ID format"}
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
