defmodule Discountex.Repo do
  use Ecto.Repo,
    otp_app: :discountex,
    adapter: Ecto.Adapters.Postgres
end
