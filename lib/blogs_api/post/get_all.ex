defmodule BlogsApi.Post.GetAll do
  @moduledoc """
  Módulo que busca todos os posts no banco de dados
  """
  alias BlogsApi.{User, Post, Repo}

  def get_all_posts() do
    Repo.all(Post)
    |> get_all_posts_users()
  end

  def get_all_posts_users([]), do: []

  def get_all_posts_users([post | posts]) do
    with user <- get_user_by_id!(post.user_id) do
      [%{post: post, user: user} | get_all_posts_users(posts)]
    end
  end

  def get_user_by_id!(id) do
    Repo.get!(User, id)
  end
end
