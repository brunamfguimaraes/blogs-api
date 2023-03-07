defmodule BlogsApiWeb.UserControllerTest do
  @moduledoc """
  Módulo de teste do UserController
  """
  use BlogsApiWeb.ConnCase, async: true

  import BlogsApiWeb.Auth.Guardian

  @params %{
    display_name: "Harry Potter",
    email: "harry@email.com",
    password: "123456",
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

  describe "login" do
    setup :setup_user

    test "Verifica se é possível fazer login com sucesso", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :create), @params)

      assert [
               %{
                 "user" => %{
                   "display_name" => "Harry Potter",
                   "email" => "harry@email.com",
                   "image" =>
                     "https://ogimg.infoglobo.com.br/in/24440303-24f-31c/FT1086A/87996533_SCAtor-Daniel-Redcliff-como-Harry-Potter.-Foto-Divulgacao.jpg"
                 }
               }
             ] = json_response(conn, :ok)
    end

    test "Não é possível fazer login sem o campo `email`", %{conn: conn} do
      invalid_user = %{
        display_name: "Harry Potter",
        image:
          "https://ogimg.infoglobo.com.br/in/24440303-24f-31c/FT1086A/87996533_SCAtor-Daniel-Redcliff-como-Harry-Potter.-Foto-Divulgacao.jpg",
        password: "123456"
      }

      conn = post(conn, Routes.user_path(conn, :create), user: invalid_user)
      assert %{"message" => %{"email" => ["\"email\" is required"]}} = json_response(conn, 400)
    end

    test "Não é possível fazer login sem o campo `password`", %{conn: conn} do
      invalid_user = %{
        display_name: "Harry Potter",
        email: "harry@email.com",
        image:
          "https://ogimg.infoglobo.com.br/in/24440303-24f-31c/FT1086A/87996533_SCAtor-Daniel-Redcliff-como-Harry-Potter.-Foto-Divulgacao.jpg"
      }

      conn = post(conn, Routes.user_path(conn, :create), user: invalid_user)

      assert %{"message" => %{"password" => ["\"password\" is required"]}} =
               json_response(conn, 400)
    end

    test "Não é possível fazer login com o campo `email` em branco", %{conn: conn} do
      invalid_user = %{
        display_name: "Harry Potter",
        email: "",
        image:
          "https://ogimg.infoglobo.com.br/in/24440303-24f-31c/FT1086A/87996533_SCAtor-Daniel-Redcliff-como-Harry-Potter.-Foto-Divulgacao.jpg",
        password: "123456"
      }

      conn = post(conn, Routes.user_path(conn, :create), user: invalid_user)
      assert %{"message" => %{"email" => ["\"email\" is required"]}} = json_response(conn, 400)
    end
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

  describe "index/1" do
    setup :setup_user

    test "Retorna todas as pessoas usuárias", %{conn: conn} do
      response =
        get(conn, Routes.user_path(conn, :index))
        |> json_response(:ok)

      assert response
    end
  end

  describe "create" do
    test "Cria um User quando os parâmetros são válidos", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), @params)

      assert %{
               "user" => %{
                 "display_name" => "Harry Potter",
                 "email" => "harry@email.com",
                 "image" =>
                   "https://ogimg.infoglobo.com.br/in/24440303-24f-31c/FT1086A/87996533_SCAtor-Daniel-Redcliff-como-Harry-Potter.-Foto-Divulgacao.jpg"
               }
             } = json_response(conn, 201)
    end

    test "Valida que não é possível cadastrar um User com o `display_name` com menos de 8 caracteres",
         %{conn: conn} do
      invalid_params = %{
        display_name: "Harry",
        email: "harry@email.com",
        image:
          "https://ogimg.infoglobo.com.br/in/24440303-24f-31c/FT1086A/87996533_SCAtor-Daniel-Redcliff-como-Harry-Potter.-Foto-Divulgacao.jpg",
        password: "123456"
      }

      conn = post(conn, Routes.user_path(conn, :create), user: invalid_params)
      assert %{"message" => %{"display_name" => ["can't be blank"]}} = json_response(conn, 400)
    end
  end

  describe "delete" do
    setup :setup_user

    test "Retorna `Usuário não encontrado!` quando User não existe", %{conn: conn} do
      not_found_id = Ecto.UUID.generate()
      connection = delete(conn, Routes.user_path(conn, :delete, not_found_id))
      assert json_response(connection, 400)
    end
  end
end
