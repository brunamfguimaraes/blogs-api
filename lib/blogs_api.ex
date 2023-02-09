defmodule BlogsApi do
  alias BlogsApi.User

  defdelegate create_user(params), to: User.Create, as: :call
  #defdelegate fetch_all_users(params), to: User.GetAll, as: :call
  #defdelegate fetch_user(params), to: User.Get, as: :call

end
