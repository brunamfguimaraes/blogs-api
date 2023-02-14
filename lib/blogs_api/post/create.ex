defmodule BlogsApi.Post.Create do

  alias BlogsApi.{Repo, Post}

  def call(user, params) do
    params
    |> Post.changeset()
    |> Post.put_user(user)
    |> Repo.insert()
  end
end
