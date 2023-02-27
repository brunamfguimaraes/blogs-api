defmodule BlogsApi.Post.PostTest do
  use BlogsApi.DataCase

  alias BlogsApi.Post

  describe "changeset/1" do
    test "When all params are valid, returns a valid changeset" do
      params = %{
        title: "Testando a aplicação",
        content: "Isso está dentro do conteúdo",
      }

      response = Post.changeset(params)

      assert %Ecto.Changeset{
               changes: %{
                title: "Testando a aplicação",
                content: "Isso está dentro do conteúdo",
               },
               errors: [],
               data: %BlogsApi.Post{},
               valid?: true
             } = response
    end

    test "When there are invalid params, returns an invalid changeset" do
      params = %{title: "Testando a aplicação"}

      response = Post.changeset(params)

      assert %Ecto.Changeset{
               changes: %{
                title: "Testando a aplicação",
               },
               data: %BlogsApi.Post{},
               valid?: false
             } = response

      assert errors_on(response) == %{content: ["\"content\" is required"]}
    end

    test "When there are invalid params, returns an error" do
      params = %{content: "Isso está dentro do conteúdo"}

      response = Post.changeset(params)

      assert %Ecto.Changeset{
               changes: %{
                content: "Isso está dentro do conteúdo",
               },
               data: %BlogsApi.Post{},
               valid?: false
             } = response

      assert errors_on(response) == %{title: ["\"title\" is required"]}
    end
  end
end
