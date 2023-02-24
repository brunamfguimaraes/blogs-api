defmodule TesteTest do
  use ExUnit.Case, async: true
  alias BlogsApi.Teste

  describe "sum/2" do
    test "A soma de dois itens está correta" do
      assert Teste.sum(2, 3) == 5
    end
  end
end
