defmodule MediaServerWeb.WatchEpisodeLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServer.Repo
  alias MediaServer.Accounts
  alias MediaServerWeb.Repositories.Episodes

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(
        :current_user,
        Accounts.get_user_by_session_token(session["user_token"])
        |> Repo.preload(:continues)
        |> Repo.preload(continues: [:media])
      )
    }
  end

  @impl true
  def handle_params(%{"id" => id, "action" => "watch"}, _url, socket) do
    episode = Episodes.get_episode(id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{episode["series"]["title"]}: #{episode["title"]}")
      |> assign(:episode, episode)
      |> assign(
        :media_stream,
        Routes.stream_episode_path(socket, :show, episode["id"],
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
    episode = Episodes.get_episode(id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{episode["series"]["title"]}: #{episode["title"]}")
      |> assign(:episode, episode)
      |> assign(
        :media_stream,
        Routes.stream_episode_path(socket, :show, episode["id"],
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
        socket.assigns.current_user.continues
        |> Enum.filter(fn item -> item.media.media_id == episode["id"] end)
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
    media =
      MediaServer.Media.find_or_create(%{
        media_id: socket.assigns.episode["id"],
        media_type_id: MediaServer.MediaTypes.get_id("episode")
      })

    MediaServer.Continues.update_or_create(%{
      media_id: media.id,
      current_time: current_time,
      duration: duration,
      user_id: socket.assigns.current_user.id
    })

    {:noreply, socket}
  end

  def handle_event("video_played", _params, socket) do
    action = MediaServer.Actions.list_actions() |> List.first()

    media =
      MediaServer.Media.find_or_create(%{
        media_id: socket.assigns.episode["id"],
        media_type_id: MediaServer.MediaTypes.get_id("episode")
      })

    MediaServer.MediaActions.create(%{
      media_id: media.id,
      user_id: socket.assigns.current_user.id,
      action_id: action.id
    })

    {:noreply, socket}
  end
end
