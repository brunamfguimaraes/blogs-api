defmodule BlogsApiWeb.UserView do
  use BlogsApiWeb, :view

  alias BlogsApiWeb.UserView
  alias BlogsApi.User

  def render("index.json", %{all_users: all_users}) do
    render_many(all_users, UserView, "create_without_token.json")
  end

  def render("create_without_token.json", %{
        user: %User{id: id, display_name: display_name, email: email, image: image}
      }) do
    %{
      user: %{
        id: id,
        display_name: display_name,
        email: email,
        image: image
      }
    }
  end

  def render("create.json", %{
        user: %User{id: id, display_name: display_name, email: email, image: image},
        token: token
      }) do
    %{
      user: %{
        id: id,
        display_name: display_name,
        email: email,
        image: image
      },
      token: token
    }
  end

  def render("login.json", %{token: token}) do
    %{token: token}
  end
end
