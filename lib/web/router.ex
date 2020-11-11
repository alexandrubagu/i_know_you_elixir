defmodule IKnowYou.Web.Router do
  use IKnowYou.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_root_layout, {IKnowYou.Web.LayoutView, :app}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", IKnowYou.Web do
    pipe_through :browser
    get "/*anything", FrontendController, :index
  end

  scope "/api", IKnowYou.Web do
    pipe_through :api
    post "/new-graph", ApiController, :new
    post "/:graph_id/create_subgraph", ApiController, :create_subgraph
    post "/:graph_id/get_shortest_path", ApiController, :get_shortest_path
  end
end
