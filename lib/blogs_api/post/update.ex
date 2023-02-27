defmodule BlogsApi.Post.Update do
  @moduledoc """
  Módulo que pega o `id` do post, e atualiza o body (`title` e `content`),
  baseado no que a pessoa usuária quiser alterar no campo
  """
  alias BlogsApi.{Post, Repo}
  alias Ecto.UUID

  def call(current_user, %{"id" => uuid} = params) do
    case UUID.cast(uuid) do
      :error -> {:error, "Invalid ID format!"}
      {:ok, _uuid} -> update(current_user, params)
    end
  end

  defp update(current_user, %{"id" => uuid} = params) do
    with post when not is_nil(post) <- fetch_post(uuid),
         true <- current_user.id == post.user_id do
      update_post(post, params)
    else
      nil -> {:error, "Post não existe"}
      false -> {:error, :unauthorized}
    end
  end

  defp fetch_post(uuid) do
    Repo.get(Post, uuid)
  end

  defp update_post(post, %{"title" => _title, "content" => _content} = params) do
    post
    |> Post.update_changeset(params)
    |> Repo.update()
  end

  defp update_post(_post, %{"title" => _title} = _params), do: {:error, "\"content\" is required"}
  defp update_post(_post, %{"content" => _content} = _params), do: {:error, "\"title\" is required"}
end
