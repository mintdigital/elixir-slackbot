use Mix.Config
config :tirexs, :uri, System.get_env("ELASTICSEARCH_URL")
config :rex_bot, :elasticsearch_index_name, System.get_env("ELASTICSEARCH_INDEX_NAME")
