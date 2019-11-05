defmodule TT.Server do
  use GenServer

  alias :mnesia, as: Mnesia

  ## client API

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: :tt_server)
  end

  def get_state do
    state = GenServer.call(:tt_server, {:get_state})
    IO.puts("CURRENT STATE #{inspect(state)}")
  end

  ## callbacks

  @impl true
  def init(_arg) do
    Mnesia.create_schema([node()])
    Mnesia.start()

    Mnesia.create_table(Tdata,
      attributes: [
        :created_at,
        :favorite_count,
        :text,
        :id_str,
        :full_text,
        :retweet_count,
        :tone
      ],
      disc_copies: [node()]
    )

    Process.send_after(:tt_server, :collect, 1000)
    {:ok, []}
  end

  @impl true
  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info(:collect, _state) do
    tws = collect()
      # |> processing(state)

    Process.send_after(:tt_server, :collect, 30000)
    {:noreply, tws}
  end

  ## private

  defp collect do
    screen_name = Application.get_env(:extwitter, :screen_name)

    for tweet <- ExTwitter.user_timeline(screen_name: screen_name) do
      %{
        created_at: tweet.created_at,
        favorite_count: tweet.favorite_count,
        text: tweet.text,
        id_str: tweet.id_str,
        full_text: tweet.full_text,
        retweet_count: tweet.retweet_count
      }
    end
  end

  # defp processing(tws, state) when is_list(tws) do

  # end
end
