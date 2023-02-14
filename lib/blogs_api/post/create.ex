defmodule BlogsApi.Post.Create do
  @moduledoc """
  Módulo que busca, valida e insere as
  informações necessárias para criação do post com base no id do usuário
  """

  alias BlogsApi.{Repo, Post}

  def call(user, params) do
    params
    |> Post.changeset()
    |> Post.put_user(user)
    |> Repo.insert()
  end
end
