defmodule BlogsApiWeb.PostControllerTest do
  @moduledoc """
  Módulo de teste do PostController
  """

  import BlogsApiWeb.Auth.Guardian
  use BlogsApiWeb.ConnCase, async: true

  @params %{
    display_name: "Harry Potter",
    password: "123456",
    email: "harry@email.com",
    image:
      "https://ogimg.infoglobo.com.br/in/24440303-24f-31c/FT1086A/87996533_SCAtor-Daniel-Redcliff-como-Harry-Potter.-Foto-Divulgacao.jpg"
  }

  @create_attrs %{content: "some content", title: "some title"}

  @update_attrs %{content: "Conteúdo atualizado", title: "titulo"}

  defp setup_user(%{conn: conn}) do
    {:ok, user} = BlogsApi.create_user(@params)
    {:ok, token, _claims} = encode_and_sign(user)

    conn = put_req_header(conn, "authorization", "Bearer #{token}")
    {:ok, conn: conn}
    %{conn: conn, user: user}
  end

  defp setup_post(%{conn: conn, user: user}) do
    {:ok, post} = BlogsApi.create_post_user(user, @create_attrs)
    {:ok, conn: conn, user: user, post: post}
  end

  describe "index/1" do
    setup :setup_user

    test "Retorna todos os posts", %{conn: conn} do
      response =
        get(conn, Routes.post_path(conn, :index))
        |> json_response(:ok)

      assert response
    end
  end

  describe "show/2" do
    setup :setup_user
    setup :setup_post

    test "Retorna um post, quando o post é encontrado", %{conn: conn, user: _user, post: post} do
      connection = get(conn, Routes.post_path(conn, :show, post.id))

      assert %{
          "id" => _id,
          "title" => "some title",
          "content" => "some content",
          "published" => _published,
          "updated" => _updated,
          "user" => %{
            "id" => _user_id,
            "display_name" => "Harry Potter",
            "email" => "harry@email.com",
            "image" =>
            "https://ogimg.infoglobo.com.br/in/24440303-24f-31c/FT1086A/87996533_SCAtor-Daniel-Redcliff-como-Harry-Potter.-Foto-Divulgacao.jpg"
          }
      } = json_response(connection, :ok)
    end
  end

  describe "create" do
    setup :setup_user
    test "Cria um post quando os parâmetros são válidos", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), @create_attrs)

      assert %{
        "post" => %{"content" => "some content",
        "title" => "some title",
        "user_id" => _user_id}
      } = json_response(conn, 201)
    end
  end

  describe "update" do
    setup :setup_user
    setup :setup_post

    test "Atualiza um post quando os parâmetros são válidos", %{conn: conn, post: post} do
      connection =
        conn
        |> put(Routes.post_path(conn, :update, post.id), @update_attrs)

      assert %{
        "post" => %{
          "content" => "Conteúdo atualizado",
          "title" => "titulo",
          "user_id" => _user_id
        }
      } = json_response(connection, 200)
    end
  end

  describe "delete" do
    setup :setup_user

    test "Retorna `Post não existe` quando Post não existe", %{conn: conn} do
      not_found_id = Ecto.UUID.generate()
      connection = delete(conn, Routes.post_path(conn, :delete, not_found_id))
      assert json_response(connection, :not_found)
    end
  end

  describe "show_by_post_term/1" do
    setup :setup_user
    setup :setup_post


    test "Retorna um resultado quando um termo é pesquisado por `title` na URL", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :show, "search", q: "title"))

      assert [
          %{
            "content" => "some content",
            "id" => _id,
            "published" => _published,
            "title" => "some title",
            "updated" => _updated,
            "user" => %{
              "display_name" => "Harry Potter",
              "email" => "harry@email.com",
              "id" => _user_id,
              "image" => "https://ogimg.infoglobo.com.br/in/24440303-24f-31c/FT1086A/87996533_SCAtor-Daniel-Redcliff-como-Harry-Potter.-Foto-Divulgacao.jpg"
            }
          }
        ] = json_response(conn, 200)
    end

    test "Retorna um resultado quando um termo é pesquisado por `content` na URL", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :show, "search", q: "content"))

      assert [
          %{
            "content" => "some content",
            "id" => _id,
            "published" => _published,
            "title" => "some title",
            "updated" => _updated,
            "user" => %{
              "display_name" => "Harry Potter",
              "email" => "harry@email.com",
              "id" => _user_id,
              "image" => "https://ogimg.infoglobo.com.br/in/24440303-24f-31c/FT1086A/87996533_SCAtor-Daniel-Redcliff-como-Harry-Potter.-Foto-Divulgacao.jpg"
            }
          }
        ] = json_response(conn, 200)
    end

    test "Retorna todos os Posts quando passa a busca vazia", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :show, "search", q: ""))

      assert [
          %{
            "content" => "some content",
            "id" => _id,
            "published" => _published,
            "title" => "some title",
            "updated" => _updated,
            "user" => %{
              "display_name" => "Harry Potter",
              "email" => "harry@email.com",
              "id" => _user_id,
              "image" => "https://ogimg.infoglobo.com.br/in/24440303-24f-31c/FT1086A/87996533_SCAtor-Daniel-Redcliff-como-Harry-Potter.-Foto-Divulgacao.jpg"
            }
          }
        ] = json_response(conn, 200)
    end

    test "Será validado que é possível buscar um Post inexistente e retornar array vazio", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :show, "search", q: "batata"))

      assert [] = json_response(conn, 200)
    end
  end
end
