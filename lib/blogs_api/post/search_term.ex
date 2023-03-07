defmodule BlogsApi.Post.SearchTerm do
  @moduledoc """
  Busca no parâmetro da URL o termo pesquisado dentro de `title` ou `content`
  """
  import Ecto.Query, warn: false
  alias BlogsApi.{Post, Repo}

  def search_by_term(search_params) do
    query =
      from(p in Post,
        where:
          ilike(p.title, ^"%#{search_params}%") or
            ilike(p.content, ^"%#{search_params}%")
      )

    Repo.all(query)
    |> Repo.preload(:user)

  end
end
