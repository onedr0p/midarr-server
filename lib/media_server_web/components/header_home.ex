defmodule MediaServerWeb.Components.HeaderHome do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <%= if !Enum.empty?(@movies) do %>
      <header class="relative pb-24 bg-slate-800 sm:pb-32">
        <div
          class="absolute inset-0 bg-cover bg-fixed"
          style={
            "background-image: url(#{MediaServer.MoviesIndex.get_background(Enum.at(@movies, 0))})"
          }
        >
          <div
            class="absolute inset-0 bg-gradient-to-l from-slate-200 to-neutral-900 mix-blend-multiply"
            aria-hidden="true"
          >
          </div>
        </div>

        <div class="relative z-10">
          <.live_component
            module={MediaServerWeb.Components.NavComponent}
            id="nav-component"
            class="text-white hover:text-gray-100"
          />
        </div>

        <div class="relative mt-24 max-w-md mx-auto px-4 sm:max-w-xl sm:mt-32 sm:px-6 lg:max-w-6xl lg:px-8 space-y-6">
          <div class="space-y-2">
            <h1 class="text-3xl font-extrabold tracking-tight text-white">
              <%= Enum.at(@movies, 0)["title"] %>
            </h1>
            <div class="flex space-x-4 text-sm font-semibold text-red-300 tracking-wide uppercase">
              <h2>
                <%= Enum.at(@movies, 0)["year"] %>
              </h2>
              <%= if Enum.at(@movies, 0)["certification"] do %>
                <div>
                  |
                </div>
                <h2>
                  <%= Enum.at(@movies, 0)["certification"] %>
                </h2>
              <% end %>
              <div>
                |
              </div>
              <h2>
                <%= Enum.at(@movies, 0)["movieFile"]["mediaInfo"]["runTime"] %>
              </h2>
            </div>
          </div>
          <p class="text-lg text-white max-w-lg line-clamp">
            <%= Enum.at(@movies, 0)["overview"] %>
          </p>
          <div class="grid grid-cols-1 gap-y-4 lg:gap-y-12 gap-x-4 lg:grid-cols-6">
            <%= live_redirect to: MediaServerWeb.Router.Helpers.watch_movie_show_path(@socket, :show, Enum.at(@movies, 0)["id"], "watch"), class: "inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-slate-600 hover:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-slate-500" do %>
              <svg
                class="-ml-0.5 mr-2 h-6 w-6"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="1.5"
                stroke="currentColor"
                class="w-6 h-6"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M5.25 5.653c0-.856.917-1.398 1.667-.986l11.54 6.348a1.125 1.125 0 010 1.971l-11.54 6.347a1.125 1.125 0 01-1.667-.985V5.653z"
                />
              </svg>
              Play
            <% end %>

            <%= live_redirect to: MediaServerWeb.Router.Helpers.segment_movie_show_path(@socket, :show, Enum.at(@movies, 0)["id"]), class: "inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-slate-500" do %>
              <svg
                class="-ml-0.5 mr-2 h-6 w-6"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="1.5"
                stroke="currentColor"
                class="w-6 h-6"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M5.25 5.653c0-.856.917-1.398 1.667-.986l11.54 6.348a1.125 1.125 0 010 1.971l-11.54 6.347a1.125 1.125 0 01-1.667-.985V5.653z"
                />
              </svg>
                Test
            <% end %>

            <%= live_redirect to: MediaServerWeb.Router.Helpers.movies_show_path(@socket, :show, Enum.at(@movies, 0)["id"]), class: "inline-flex items-center justify-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-slate-500" do %>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="-ml-0.5 mr-2 h-6 w-6"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
                stroke-width="2"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                />
              </svg>
              More info
            <% end %>
          </div>
        </div>
      </header>
    <% else %>
      <header class="relative pb-24 bg-slate-800 sm:pb-32">
        No movies found. Please add movies to show here.
      </header>
    <% end %>
    """
  end
end
