defmodule BlogsApi.Post.Delete do
  @moduledoc """
  Módulo que obtem um `id` de um POST no banco e deleta esse `id`
  """
  alias BlogsApi.{Post, Repo}
  alias Ecto.UUID

  def call(id) do
    case UUID.cast(id) do
      :error -> {:erro}
      {:ok, uuid} -> delete(uuid)
    end
  end

  def delete(uuid) do
    case Repo.get(Post, uuid) do
      nil -> {:erro}
      post -> Repo.delete(post)
    end
  end
end
