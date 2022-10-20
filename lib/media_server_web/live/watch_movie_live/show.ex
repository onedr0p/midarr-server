defmodule MediaServerWeb.WatchMovieLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServer.Repo
  alias MediaServer.Accounts

  alias MediaServer.Actions
  alias MediaServer.Movies.Indexer

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(
        :current_user,
        Accounts.get_user_by_session_token(session["user_token"])
        |> Repo.preload(:user_continues)
      )
    }
  end

  @impl true
  def handle_params(%{"id" => id, "action" => "watch"}, _url, socket) do
    movie = Indexer.get_movie(id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{movie["title"]}")
      |> assign(:movie, movie)
      |> assign(
        :media_stream,
        Routes.stream_movie_path(socket, :show, movie["id"],
          token:
            Phoenix.Token.sign(
              MediaServerWeb.Endpoint,
              "user auth",
              socket.assigns.current_user.id
            )
        )
      )
    }
  end

  def handle_params(%{"id" => id, "action" => "continue"}, _url, socket) do
    movie = Indexer.get_movie(id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{movie["title"]}")
      |> assign(:movie, movie)
      |> assign(
        :media_stream,
        Routes.stream_movie_path(socket, :show, movie["id"],
          token:
            Phoenix.Token.sign(
              MediaServerWeb.Endpoint,
              "user auth",
              socket.assigns.current_user.id
            )
        )
      )
      |> assign(
        :continue,
        socket.assigns.current_user.user_continues
        |> Enum.filter(fn item -> item.media_id == movie["id"] end)
        |> List.first()
      )
    }
  end

  @impl true
  def handle_event(
        "video_destroyed",
        %{
          "current_time" => current_time,
          "duration" => duration
        },
        socket
      ) do
    MediaServer.Accounts.UserContinues.update_or_create(%{
      media_id: socket.assigns.movie["id"],
      current_time: current_time,
      duration: duration,
      user_id: socket.assigns.current_user.id,
      media_type_id: MediaServer.MediaTypes.get_id("movie")
    })

    {:noreply, socket}
  end

  def handle_event("video_played", _params, socket) do
    action = MediaServer.Action.list_actions() |> List.first()

    Actions.create_movie(%{
      movie_id: socket.assigns.movie["id"],
      title: socket.assigns.movie["title"],
      user_id: socket.assigns.current_user.id,
      user_action_id: action.id
    })

    {:noreply, socket}
  end
end
