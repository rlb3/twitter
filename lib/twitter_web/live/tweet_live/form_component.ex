defmodule TwitterWeb.TweetLive.FormComponent do
  use TwitterWeb, :live_component

  alias Twitter.Tweets

  @impl true
  def update(%{tweet: tweet} = assigns, socket) do
    changeset = Tweets.change_tweet(tweet)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"tweet" => tweet_params}, socket) do
    changeset =
      socket.assigns.tweet
      |> Tweets.change_tweet(tweet_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"tweet" => tweet_params}, socket) do
    save_tweet(socket, socket.assigns.action, tweet_params)
  end

  defp save_tweet(socket, :edit, tweet_params) do
    case Tweets.update_tweet(socket.assigns.tweet, tweet_params) do
      {:ok, _tweet} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tweet updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_tweet(socket, :new, tweet_params) do
    case Tweets.create_tweet(tweet_params) do
      {:ok, _tweet} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tweet created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
