defmodule Twitter.Repo.Migrations.AlterTweetsAddLikes do
  use Ecto.Migration

  def change do
    alter table("tweets") do
      add :likes, :integer, default: 0
    end
  end
end
