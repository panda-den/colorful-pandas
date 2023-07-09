defmodule ColorfulPandas.Auth.OrganizationInvite do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias ColorfulPandas.Auth.Identity
  alias ColorfulPandas.Auth.Organization
  alias ColorfulPandas.Auth.OrganizationInvite

  @token_size 64
  @token_validity_in_days 7

  @schema_prefix "auth"
  @timestamps_opts [type: :utc_datetime]
  schema "organization_invites" do
    field :token, :string

    belongs_to :organization, Organization
    belongs_to :created_by, Identity

    field :accepted_at, :utc_datetime
    timestamps updated_at: false
  end

  def token_validity_in_days, do: @token_validity_in_days

  def generate_token do
    :crypto.strong_rand_bytes(@token_size)
  end

  @cast ~w(token created_by_id organization_id accepted_at)a
  @required ~w(token created_by_id organization_id)a
  def changeset(%OrganizationInvite{} = organization_invite \\ %OrganizationInvite{}, attrs) do
    organization_invite
    |> cast(attrs, @cast)
    |> validate_required(@required)
  end

  def with_token_query(token) do
    from(t in OrganizationInvite,
      where: t.token == ^token
    )
  end
end
