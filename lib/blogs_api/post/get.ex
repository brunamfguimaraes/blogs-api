defmodule BlogsApi.Post.Get do
  alias BlogsApi.{Post, Repo}
  alias Ecto.UUID

  def call(id) do
    case UUID.cast(id) do
      :error -> {:error, :post_not_found}
      {:ok, uuid} -> get(uuid)
    end

  end

  defp get(uuid) do
    case Repo.get(Post, uuid) do
      nil -> {:error, "Post não existe"}
      post -> {:ok, post}
    end
  end
end
