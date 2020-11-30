defmodule ProjectRp.Repo do
  use Ecto.Repo,
    otp_app: :project_rp,
    adapter: Ecto.Adapters.Postgres
end
