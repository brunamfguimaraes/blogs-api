defmodule BlogsApi do
  @moduledoc """
  Criação de um CRUD de blog de posts
  """
  alias BlogsApi.{User, Post}


  defdelegate delete_user(params), to: User.Delete, as: :call
  defdelegate create_user(params), to: User.Create, as: :call
  defdelegate fetch_user(params), to: User.Get, as: :call

  defdelegate post_delete(params), to: Post.Delete, as: :call
  defdelegate create_post_user(user, params), to: Post.Create, as: :call
  defdelegate fetch_post(params), to: Post.Get, as: :call
  defdelegate update_post_user(current_user, params), to: Post.Update, as: :call
end
