defmodule BlogsApi.Post.DeleteTest do

  alias BlogsApi.Post

  describe "delete/1" do
    test "When the post exists, deletes the post" do
      id = "123"
      expected_response = "batataa"

      response = Post.delete(id)

      assert response == expected_response
    end
  end
end
