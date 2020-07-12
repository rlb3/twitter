defmodule TwitterWeb.Router do
  use TwitterWeb, :router
  use Pow.Phoenix.Router
  use PowAssent.Phoenix.Router

  def get_current_user_id(conn) do
    case Pow.Plug.current_user(conn) do
      user = %Twitter.Users.User{} ->
        %{"user_id" => user.id}
      nil -> %{}
    end
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TwitterWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :skip_csrf_protection do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
    pow_assent_routes()
  end

  scope "/", TwitterWeb do
    pipe_through [:browser, :protected]

  end

  scope "/" do
    pipe_through :skip_csrf_protection

    pow_assent_authorization_post_callback_routes()
  end

  scope "/", TwitterWeb do
    pipe_through :browser

    live "/", PageLive, :index
    live "/tweets", TweetLive.Index, :index, session: {__MODULE__, :get_current_user_id, []}
    live "/tweets/new", TweetLive.Index, :new
    live "/tweets/:id/edit", TweetLive.Index, :edit

    live "/tweets/:id", TweetLive.Show, :show
    live "/tweets/:id/show/edit", TweetLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", TwitterWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TwitterWeb.Telemetry
    end
  end
end
