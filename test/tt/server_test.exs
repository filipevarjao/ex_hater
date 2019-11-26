defmodule TT.ServerTest do
  use ExUnit.Case

  alias TT.Server
  alias :mnesia, as: Mnesia

  @proc_name :tt_server
  @mnesia_table Tone

  @chat "\r\n\r\n{\n\"utterances\":[\n{\n\"text\":\"Hello, I'm having a problem with your product.\",\n\"user\":\"customer\"\n },\n {\n \"text\": \"OK, let me know what's going on, please.\",\n\"user\": \"agent\"\n},\n{\n\"text\": \"Well, nothing is working :(\",\n\"user\": \"customer\"\n},\n{\n\"text\": \"Sorry to hear that.\",\n\"user\": \"agent\"\n}\n]\n}\r\n\r\n"

  @tweet %{
    created_at: "",
    favorite_count: 0,
    full_text: nil,
    id_str: "123",
    retweet_count: 0,
    text: "Lorem ipsum"
  }

  setup_all do
    load_data()

    on_exit(fn ->
      Mnesia.clear_table(@mnesia_table)
    end)
  end

  test "check server process" do
    pid = Process.whereis(@proc_name)
    assert true == Process.alive?(pid)
  end

  test "get current state" do
    pid = Process.whereis(@proc_name)
    assert Server.get_state() == :sys.get_state(pid)
  end

  test "get data from db" do
    data = Server.get_data()
    assert data == select_all()
  end

  test "store chat content" do
    size = Mnesia.table_info(Tone, :size)
    Server.tone_analyze(@chat)
    Process.sleep(2000)
    assert size + 1 == Mnesia.table_info(Tone, :size)
  end

  test "show tweet content by id" do
    id = "1"
    tweet = Server.show(id)
    assert @tweet.created_at in tweet
    assert @tweet.id_str in tweet
    assert @tweet.text in tweet
  end

  test "show chat content by id" do
    id = "2"
    tweet = Server.show(id)
    assert @chat in tweet
  end

  test "passing tweet content to be analyzed" do
    Process.sleep(1000)
    [first_tweet|_] = Server.get_state()
    _resp = Server.tone(first_tweet.id_str)
    Process.sleep(500)
    [[_, text]] = Mnesia.dirty_select(@mnesia_table, [{{Tone, :"$1", :twitter, @tweet.created_at, @tweet.text, @tweet.id_str, :"$6"}, [], [:"$$"]}])
    assert @tweet.text == text
  end

  defp load_data do
    :ok =
      Mnesia.dirty_write(
        {@mnesia_table, 1, :twitter, @tweet.created_at, @tweet.text, @tweet.id_str, @tweet.text}
      )

    :ok = Mnesia.dirty_write({@mnesia_table, 2, :chat, "", @chat, "123", @chat})
  end

  defp select_all do
    Mnesia.dirty_select(@mnesia_table, [
      {{Tone, :"$1", :"$2", :"$3", :"$4", :"$5", :"$6"}, [], [:"$$"]}
    ])
  end
end
