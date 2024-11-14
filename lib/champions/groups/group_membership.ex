defmodule Champions.Groups.GroupMembership do
  use Ecto.Schema
  import Ecto.Changeset

  schema "group_memberships" do
    field :role, :string
    belongs_to :user, Champions.Accounts.User
    belongs_to :group, Champions.Groups.Group

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(group_membership, attrs) do
    group_membership
    |> cast(attrs, [:role, :user_id, :group_id])
    |> validate_required([:role, :user_id, :group_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:group_id)
  end
end
