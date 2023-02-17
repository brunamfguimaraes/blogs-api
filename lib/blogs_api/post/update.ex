defmodule BlogsApi.Post.Update do
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

  defp update_post(post, params) do
    post
    |> Post.update_changeset(params)
    |> Repo.update()
  end
end
