defmodule TwitterWeb.TweetLive.Index do
  use TwitterWeb, :live_view

  alias Twitter.Repo
  alias Twitter.Users.User
  alias Twitter.Tweets
  alias Twitter.Tweets.Tweet

  @impl true
  def mount(_params, session, socket) do
    user = get_current_user(session)

    socket =
      socket
      |> assign(:tweets, list_tweets(user))
      |> assign(:user, user)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Tweet")
    |> assign(:tweet, Tweets.get_tweet!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Tweet")
    |> assign(:tweet, %Tweet{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tweets")
    |> assign(:tweet, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tweet = Tweets.get_tweet!(id)
    {:ok, _} = Tweets.delete_tweet(tweet)

    {:noreply, assign(socket, :tweets, list_tweets(socket.assigns.user))}
  end

  @impl true
  def handle_event("like", %{"id" => id}, socket) do
    Tweets.increment_likes(id)
    {:noreply, assign(socket, :tweets, list_tweets(socket.assigns.user))}
  end

  defp list_tweets(user) do
    Tweets.list_tweets(user)
  end

  defp get_current_user(session) do
    case session["user_id"] do
      nil -> nil
      user_id -> Repo.get(User, user_id)
    end
  end
end
