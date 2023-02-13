defmodule BlogsApi do
  @moduledoc """
  Criação de um CRUD de blog de posts
  """
  alias BlogsApi.User


  defdelegate delete_user(params), to: User.Delete, as: :call
  defdelegate create_user(params), to: User.Create, as: :call
  defdelegate fetch_user(params), to: User.Get, as: :call
end
