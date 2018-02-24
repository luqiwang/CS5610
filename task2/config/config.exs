# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :task2,
  ecto_repos: [Task2.Repo]

# Configures the endpoint
config :task2, Task2Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3lukpfNutY1TOtiqrpbDYQUdnTXn5npPVEvyFmu+nfD+rPjF5A+xBXjXo41nx6Nj",
  render_errors: [view: Task2Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Task2.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
