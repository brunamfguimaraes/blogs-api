defmodule BlogsApiWeb.UserControllerTest do
  use BlogsApiWeb.ConnCase, async: true

  import BlogsApiWeb.Auth.Guardian

  @params %{
    display_name: "Harry Potter",
    password: "123456",
    email: "harry@email.com",
    image:
      "https://ogimg.infoglobo.com.br/in/24440303-24f-31c/FT1086A/87996533_SCAtor-Daniel-Redcliff-como-Harry-Potter.-Foto-Divulgacao.jpg"
  }

  defp setup_user(%{conn: conn}) do
    {:ok, user} = BlogsApi.create_user(@params)
    {:ok, token, _claims} = encode_and_sign(user)

    conn = put_req_header(conn, "authorization", "Bearer #{token}")
    {:ok, conn: conn}
    %{conn: conn, user: user}
  end

  describe "show/2" do
    setup :setup_user

    test "When there is a user with the given id, returns the user", %{conn: conn, user: user} do
      response =
        conn
        |> get(Routes.user_path(conn, :show, user.id))
        |> json_response(:ok)

      assert %{
               "id" => _id,
               "display_name" => "Harry Potter",
               "email" => "harry@email.com",
               "image" => _image
             } = response
    end

    test "When there is not user `id`, returns the error", %{conn: conn} do
      response =
        conn
        |> get(Routes.user_path(conn, :show, "123"))
        |> json_response(:not_found)

      assert %{"error" => "Usuário não existe"} == response
    end
  end
end
