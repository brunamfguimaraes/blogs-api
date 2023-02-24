defmodule BlogsApiWeb.PostControllerTest do

  use BlogsApiWeb.ConnCase, async: true

  describe "delete" do
    test "Retorna `não encontrado` quando Post não existe", %{conn: conn} do
      not_found_id = Ecto.UUID.generate()
      connection = delete(conn, Routes.post_path(conn, :delete, not_found_id))
      assert json_response(connection, :not_found)
    end
  end
end
