defmodule BlogsApi.Post.GetAll do
  @moduledoc """
  Módulo que busca todos os posts no banco de dados
  """
  alias BlogsApi.{User, Post, Repo}

  def get_all_posts() do
    Repo.all(Post)
    |> Repo.preload(:user)
  end

  def get_user_by_id!(id) do
    Repo.get!(User, id)
  end
end
