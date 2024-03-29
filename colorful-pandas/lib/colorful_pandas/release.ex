defmodule ColorfulPandas.Release do
  @moduledoc false

  use Boundary, deps: [], exports: [], top_level?: true

  def migrate do
    ensure_started()
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    ensure_started()
    load_app()

    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(:colorful_pandas, :ecto_repos)
  end

  defp load_app do
    Application.load(:colorful_pandas)
  end

  defp ensure_started do
    Application.ensure_all_started(:ssl)
  end
end
