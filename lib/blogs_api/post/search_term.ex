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
          like(p.title, ^"%#{search_params}%") or
            like(p.content, ^"%#{search_params}%")
      )

    get_posts = Repo.all(query)

    case get_posts do
      [] -> []
      _ -> Post.GetAll.get_all_posts_users(get_posts)
    end
  end
end
