defmodule BlogsApiWeb.PostControllerTest do

  import BlogsApiWeb.Auth.Guardian
  use BlogsApiWeb.ConnCase, async: true

  describe "delete" do
    setup %{conn: conn} do
      params = %{
        display_name: "Harry Potter",
        password: "123456",
        email: "harry@email.com",
        image:
          "https://ogimg.infoglobo.com.br/in/24440303-24f-31c/FT1086A/87996533_SCAtor-Daniel-Redcliff-como-Harry-Potter.-Foto-Divulgacao.jpg"
      }

      {:ok, user} = BlogsApi.create_user(params)
      {:ok, token, _claims} = encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      {:ok, conn: conn}
    end

    test "Retorna `não encontrado` quando Post não existe", %{conn: conn} do
      not_found_id = Ecto.UUID.generate()
      connection = delete(conn, Routes.post_path(conn, :delete, not_found_id))
      assert json_response(connection, :no_content)
    end
  end
end
