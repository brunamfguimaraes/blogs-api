defmodule BlogsApi.Post.Delete do
  alias BlogsApi.{Post, Repo}
  alias Ecto.UUID

  def call(id) do
    case UUID.cast(id) do
      :error -> {:error, "Invalid ID format"}
      {:ok, uuid} -> delete(uuid)
    end
  end

  defp delete(uuid) do
    case fetch_post(uuid) do
      nil -> {:error, "Post não encontrado!"}
      post -> Repo.delete(post)
    end
  end

  defp fetch_post(uuid), do: Repo.get(Post, uuid)
end
