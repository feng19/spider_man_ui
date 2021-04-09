defmodule SpiderManUiWeb.ControllerLive do
  use Phoenix.LiveDashboard.PageBuilder, refresher?: false

  @impl true
  def mount(_params, _session, socket) do
    spiders = SpiderMan.list_spiders()
    not_started_spiders = find_all_spider(spiders)

    spiders =
      Enum.map(spiders, &{&1, SpiderMan.Engine.status(&1)}) ++
        Enum.map(not_started_spiders, &{&1, :not_started})

    {:ok, assign(socket, spiders: spiders)}
  end

  @impl true
  def menu_link(_, %{dashboard_running?: false}), do: :skip
  def menu_link(_, _), do: {:ok, "SpiderMan Controller"}

  @impl true
  def render_page(assigns) do
    items =
      Enum.map(assigns.spiders, fn {spider, _} ->
        {
          spider,
          name: "#{inspect(spider)}",
          render: fn -> render_spider_controller(assigns, spider) end,
          method: :redirect
        }
      end)

    nav_bar(items: items)
  end

  defp render_spider_controller(assigns, spider) do
    ~L"""
    <div class="card p-3 m-2">
      <% status = Keyword.get(@spiders, spider) %>
      <%= case status do %>
        <% :running -> %>
        <div class="row">
          <div class="col col-md-auto">
            <button phx-click="suspend" phx-value-id="<%= spider %>" class="btn btn-primary">Suspend Spider</button>
          </div>
          <div class="col col-md-auto">
            <button phx-click="stop" phx-value-id="<%= spider %>" class="btn btn-primary">Stop Spider</button>
          </div>
        </div>
        <% :not_started -> %>
        <div class="row">
          <div class="col col-md-auto">
            <button phx-click="start" phx-value-id="<%= spider %>" class="btn btn-primary float-left">Start Spider</button>
          </div>
        </div>
        <% :suspend -> %>
        <div class="row">
          <div class="col col-md-auto">
            <button phx-click="continue" phx-value-id="<%= spider %>" class="btn btn-primary float-left">Continue Spider</button>
          </div>
          <div class="col col-md-auto">
            <button phx-click="dump2file" phx-value-id="<%= spider %>" class="btn btn-primary float-left">Dump To File</button>
          </div>
        </div>
      <% end %>

      <div class="m-2">
      <%= if status == :not_started do %>
        status: <%= inspect(status) %>
      <% else %>
        <h4>state:</h4>
        <pre><%= inspect(SpiderMan.Engine.get_state(spider), pretty: true) %></pre>
      <% end %>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event(click_event, %{"id" => spider}, socket)
      when click_event in ["start", "stop", "suspend", "dump2file", "continue"] do
    spider = String.to_existing_atom(spider)
    spiders = socket.assigns.spiders
    click_event = String.to_existing_atom(click_event)

    fun =
      [
        start: fn -> {match?({:ok, _pid}, SpiderMan.start(spider)), :running} end,
        stop: fn -> {match?(:ok, SpiderMan.stop(spider)), :not_started} end,
        suspend: fn -> {match?(:ok, SpiderMan.suspend(spider)), :suspend} end,
        dump2file: fn -> {match?(:ok, SpiderMan.Engine.dump2file_force(spider)), :suspend} end,
        continue: fn -> {match?(:ok, SpiderMan.continue(spider)), :running} end
      ]
      |> Keyword.get(click_event)

    socket =
      with {:ok, _} <- Keyword.fetch(spiders, spider),
           {true, status} <- fun.() do
        spiders = Keyword.replace(spiders, spider, status)
        assign(socket, spiders: spiders)
      else
        error ->
          IO.inspect(error)
          socket
      end

    {:noreply, socket}
  end

  def handle_event("search", %{"q" => query}, socket) do
    {:noreply,
     socket
     |> put_flash(:error, "No dependencies found matching \"#{query}\"")
     |> assign(results: %{}, query: query)}
  end

  def find_all_spider(spiders) do
    :code.all_loaded()
    |> Enum.map(&elem(&1, 0))
    |> Kernel.--(spiders)
    |> Enum.filter(fn m ->
      Enum.any?(m.module_info(:attributes), &match?({:behaviour, [SpiderMan]}, &1))
    end)
  end
end
