defmodule BlogsApi.User do
  @moduledoc """
  Criação do schema do User, com as devidas validações
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "users" do
    field(:display_name, :string)
    field(:email, :string)
    field(:encrypted_password, :string)
    field(:password, :string, virtual: true)
    field(:image, :string)
  end

  @required_params ~w(display_name image)a
  @allowed_params  @required_params ++ ~w(email password)a
  def build(params) do
    params
    |> changeset()
    |> apply_action(:insert)
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @allowed_params)
    |> validate_required(@required_params)
    |> validate_length(:display_name,
      min: 8,
      message: "\"display_name\" length must be at least 8 characters long"
    )
    |> validate_length(:password, min: 6, message: "\"password\" length must be 6 characters long")
    |> validate_format(:email, ~r/@/, [{:message, "\"email\" must be a valid email"}])
    |> unique_constraint(:email, message: "Usuário já existe")
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, encrypted_password: Bcrypt.hash_pwd_salt(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
