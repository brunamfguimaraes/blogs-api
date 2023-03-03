defmodule BlogsApi.User.UserTest do
  @moduledoc """
  Testa o Changeset do USER
  """
  use BlogsApi.DataCase

  alias BlogsApi.User

  describe "changeset/1" do
    test "When all params are valid, returns a valid changeset" do
      params = %{
        display_name: "Harry Potter",
        password: "1234567",
        email: "harry@email.com",
        image:
          "https://ogimg.infoglobo.com.br/in/24440303-24f-31c/FT1086A/87996533_SCAtor-Daniel-Redcliff-como-Harry-Potter.-Foto-Divulgacao.jpg"
      }

      response = User.changeset(params)

      assert %Ecto.Changeset{
               changes: %{
                 display_name: "Harry Potter",
                 password: "1234567",
                 email: "harry@email.com",
                 image: "https://ogimg.infoglobo.com.br/in/24440303-24f-31c/FT1086A/87996533_SCAtor-Daniel-Redcliff-como-Harry-Potter.-Foto-Divulgacao.jpg"
               },
               errors: [],
               data: %BlogsApi.User{},
               valid?: true
             } = response
    end

    test "When there are invalid params, returns an invalid changeset" do
      params = %{password: "1234567"}

      response = User.changeset(params)

      assert %Ecto.Changeset{
               changes: %{
                 password: "1234567"
               },
               data: %BlogsApi.User{},
               valid?: false
             } = response

      assert errors_on(response) == %{display_name: ["can't be blank"], email: ["\"email\" is required"], image: ["can't be blank"]}
    end
  end

    test "When there are invalid params, returns an error" do
      params = %{password: "1234567"}

      {:error, response} = User.build(params)

      assert %Ecto.Changeset{valid?: false} = response

      assert errors_on(response) == %{email: ["\"email\" is required"], display_name: ["can't be blank"], image: ["can't be blank"]}
    end

end
