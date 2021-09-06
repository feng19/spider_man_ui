defmodule SpiderManUiWeb.Router do
  use SpiderManUiWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SpiderManUiWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/" do
    pipe_through :browser

    live_dashboard "/",
      metrics: SpiderManUiWeb.Telemetry,
      metrics_history: {SpiderManUiWeb.MetricsHistoryStorage, :metrics_history, []},
      additional_pages: [
        broadway: BroadwayDashboard,
        spider_man_controller: SpiderManUiWeb.ControllerLive
      ]
  end
end
