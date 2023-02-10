defmodule BlogsApi.User.GetAll do
  @moduledoc """
  Módulo que busca todas as pessoas usuárias no banco de dados
  """
  alias BlogsApi.{User, Repo}

  def get_all_users() do
    Repo.all(User)
  end
end
