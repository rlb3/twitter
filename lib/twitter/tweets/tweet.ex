defmodule Twitter.Tweets.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tweets" do
    field :body, :string
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:body, :user_id])
    |> validate_required([:body, :user_id])
  end
end
