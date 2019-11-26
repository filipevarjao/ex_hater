use Mix.Config

config :extwitter, :oauth,
  consumer_key: "",
  consumer_secret: "",
  access_token: "",
  access_token_secret: "",
  screen_name: ""

config :ex_watson_tone, url: "https://gateway.watsonplatform.net/tone-analyzer/api"
config :ex_watson_tone, version: System.get_env("VERSION") || "2017-09-21"

config :ex_watson_tone,
  api_key: System.get_env("APIKEY")

config :mnesia, dir: 'mnesia/#{Mix.env()}/#{node()}'
