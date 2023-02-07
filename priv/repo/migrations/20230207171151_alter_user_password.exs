defmodule BlogsApi.Repo.Migrations.AlterUserPassword do
  use Ecto.Migration

  def change do
    rename table("users"), :password, to: :encrypted_password
    alter table("users") do
      modify :encrypted_password, :text, from: :string
    end
  end
end
