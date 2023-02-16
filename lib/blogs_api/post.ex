defmodule BlogsApi.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias BlogsApi.User

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "posts" do
    field :title, :string
    field :content, :string
    belongs_to(:user, User)

    timestamps()
  end

  @required_params ~w(title content user_id)a

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(:title, message: "\"title\" is required")
    |> validate_required(:content, message: "\"content\" is required")
    |> assoc_constraint(:user)
    |> foreign_key_constraint(:user_id)
  end

  def put_user(%Ecto.Changeset{} = changeset, %User{} = user) do
    put_assoc(changeset, :user, user)
  end

end
