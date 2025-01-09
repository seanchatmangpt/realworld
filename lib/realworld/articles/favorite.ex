defmodule Realworld.Articles.Favorite do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    notifiers: Ash.Notifier.PubSub,
    domain: Realworld.Articles,
    extensions: [AshJsonApi.Resource]

  postgres do
    table "favorites"
    repo Realworld.Repo

    references do
      reference :user, on_delete: :delete
      reference :article, on_delete: :delete
    end
  end

  policies do
    policy action_type(:read) do
      authorize_if always()
    end

    policy action_type(:create) do
      authorize_if actor_present()
    end

    policy action_type(:update) do
      authorize_if relates_to_actor_via(:user)
    end

    policy action_type(:destroy) do
      authorize_if relates_to_actor_via(:user)
    end
  end

  pub_sub do
    module RealworldWeb.Endpoint
    prefix "favorite"

    publish_all :create, ["created", :article_id]
    publish_all :destroy, ["destroyed", :article_id]
  end

  json_api do
    # Resource type in the JSON:API specification
    type "favorites"

    # Define the composite primary key
    primary_key do
      keys [:user_id, :article_id]
    end

    routes do
      # Base path for this resource
      base "/favorites"

      # GET /favorites?article_id=:article_id - Check if the current user has favorited an article
      get :favorited

      # POST /favorites - Add a favorite
      post :add_favorite

      # DELETE /favorites/:article_id - Remove a favorite
      delete :remove_favorite
    end
  end

  attributes do
    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :user, Realworld.Accounts.User do
      primary_key? true
      allow_nil? false
    end

    belongs_to :article, Realworld.Articles.Article do
      primary_key? true
      allow_nil? false
    end
  end

  actions do
    defaults [:read]

    read :favorited do
      get? true

      argument :article_id, :uuid, allow_nil?: false

      filter expr(user_id == ^actor(:id) and article_id == ^arg(:article_id))
    end

    create :add_favorite do
      primary? true
      upsert? true
      upsert_identity :unique_favorite

      accept [:article_id]

      change relate_actor(:user)
    end

    destroy :remove_favorite do
      primary? true
      argument :article_id, :uuid, allow_nil?: false
      change filter(expr(article_id == ^arg(:article_id)))
      change filter(expr(user_id == ^actor(:id)))
    end
  end

  identities do
    identity :unique_favorite, [:user_id, :article_id]
  end
end
