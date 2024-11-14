defmodule Champions.GroupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Champions.Groups` context.
  """

  @doc """
  Generate a group.
  """
  def group_fixture(attrs \\ %{}) do
    {:ok, group} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Champions.Groups.create_group()

    group
  end

  @doc """
  Generate a group_membership.
  """
  def group_membership_fixture(attrs \\ %{}) do
    {:ok, group_membership} =
      attrs
      |> Enum.into(%{
        role: "some role"
      })
      |> Champions.Groups.create_group_membership()

    group_membership
  end
end
