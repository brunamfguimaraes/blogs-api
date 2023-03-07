defmodule BlogsApi.Post.Get do
  @moduledoc """
  Módulo que busca um `id` de um POST no banco de dados
  """
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
      post -> {:ok, Repo.preload(post, :user)}
    end
  end
end
