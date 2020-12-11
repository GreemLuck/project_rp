defmodule ProjectRp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias ProjectRp.Accounts.User
  alias Comeonin.Bcrypt

  schema "users" do
    field :password, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
    |> unique_constraint(:username)
    |> update_change(:password, &Bcrypt.hashpwsalt/1)
  end
end
