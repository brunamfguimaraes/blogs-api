defmodule BlogsApi.Post.Create do

  alias BlogsApi.{Repo, Post}

  def call(params) do
    params
    |> Post.changeset()
    |> Repo.insert()
    #|> create_user_post()
  end

  """
  def create_user_post(params) do
    params
    |> handle_build()
    IO.inspect("params")
  end

  defp handle_build({:ok, post}) do
    IO.inspect("post")
    Repo.insert(post)
  end
  defp handle_build({:error, _changeset} = error), do: error
"""
end
