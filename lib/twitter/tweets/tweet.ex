defmodule Twitter.Tweets.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tweets" do
    field :body, :string
    field :likes, :integer
    belongs_to :user, Twitter.Users.User

    timestamps()
  end

  @doc false
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:body, :user_id, :likes])
    |> validate_required([:body, :user_id])
  end
end
