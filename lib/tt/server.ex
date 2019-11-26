defmodule TT.Server do
  use GenServer

  alias :mnesia, as: Mnesia
  alias ToneAnalyzer

  ## client API

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: :tt_server)
  end

  def show(id) do
    GenServer.call(:tt_server, {:show, id})
  end

  def tone(id) do
    GenServer.call(:tt_server, {:tone, id})
  end

  def get_data do
    GenServer.call(:tt_server, :get_data)
  end

  def tone_analyze(content) do
    GenServer.cast(:tt_server, {:analyze, content})
  end

  def get_state do
    GenServer.call(:tt_server, :get_state)
  end

  ## callbacks

  @impl true
  def init(_arg) do
    Mnesia.create_schema([node()])
    Mnesia.start()

    Mnesia.create_table(Tone,
      attributes: [
        :id,
        :type,
        :created_at,
        :text,
        :id_str,
        :tone
      ],
      type: :ordered_set,
      disc_copies: [node()]
    )

    Process.send_after(:tt_server, :collect, 1000)
    {:ok, []}
  end

  @impl true
  def handle_call({:show, id}, _, state) do
    resp = select_one(id)
    {:reply, resp, state}
  end

  @impl true
  def handle_call({:tone, id}, _, state) do
    tweet = Enum.find(state, fn tweet -> Map.get(tweet, :id_str) == id end)

    text =
      if tweet.full_text do
        tweet.full_text
      else
        tweet.text
      end

    {:ok, %{body: body}} = ToneAnalyzer.tone(%{text: text, header: "Content-Type: plain/text"})

    {:atomic, :ok} =
      transaction(%{
        type: :twitter,
        created_at: tweet.created_at,
        text: text,
        id_str: id,
        tone: body
      })

    {:reply, body, state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call(:get_data, _from, state) do
    {:atomic, all} = select_all()
    {:reply, all, state}
  end

  @impl true
  def handle_cast({:analyze, content}, state) do
    {:ok, %{body: body}} =
      ToneAnalyzer.tone_chat(%{file: content, header: {"Content-Type", "application/json"}})

    {:atomic, :ok} =
      transaction(%{
        type: :chat,
        created_at: "",
        text: content,
        id_str: "",
        tone: body
      })

    {:noreply, state}
  end

  @impl true
  def handle_info(:collect, _state) do
    tws = collect()
    Process.send_after(:tt_server, :collect, 30000)
    {:noreply, tws}
  end

  ## private

  defp select_one(id) do
    {:atomic, [resp]} =
      Mnesia.transaction(fn ->
        Mnesia.match_object({Tone, String.to_integer(id), :_, :_, :_, :_, :_})
      end)

    Tuple.to_list(resp)
  end

  defp select_all do
    Mnesia.transaction(fn ->
      Mnesia.select(Tone, [{{Tone, :"$1", :"$2", :"$3", :"$4", :"$5", :"$6"}, [], [:"$$"]}])
    end)
  end

  defp transaction(data) do
    id = Mnesia.table_info(Tone, :size) + 1

    data_write = fn ->
      Mnesia.write({Tone, id, data.type, data.created_at, data.text, data.id_str, data.tone})
    end

    Mnesia.transaction(data_write)
  end

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
end
