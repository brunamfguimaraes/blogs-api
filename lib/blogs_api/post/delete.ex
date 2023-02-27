defmodule BlogsApi.Post.Delete do
  alias BlogsApi.{Post, Repo}
  alias Ecto.UUID

  def call(id) do
    case UUID.cast(id) do
      :error -> {:erro}
      {:ok, uuid} -> delete(uuid)
    end
  end

  defp delete(uuid) do
    case Repo.get(Post, uuid) do
      nil -> {:erro}
      post -> Repo.delete(post)
    end
  end
end
