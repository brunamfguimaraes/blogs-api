defmodule BlogsApi do
  alias BlogsApi.User

  defdelegate create_user(params), to: User.Create, as: :call
  defdelegate fetch_user(params), to: User.Get, as: :call

end
