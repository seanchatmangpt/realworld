defmodule Realworld.Profiles.Follow do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    domain: Realworld.Profiles,
    extensions: [AshJsonApi.Resource]

  postgres do
    table "follows"
    repo Realworld.Repo
  end

  policies do
    policy action_type(:read) do
      authorize_if always()
    end

    policy action_type(:create) do
      authorize_if actor_present()
    end

    policy action_type(:destroy) do
      authorize_if relates_to_actor_via(:user)
    end
  end

  json_api do
    # Resource type in the JSON:API specification
    type "follows"

    # Define the composite primary key
    primary_key do
      keys [:user_id, :target_id]
    end

    routes do
      # Base path for this resource
      base "/follows"

      # CRUD Routes
      # GET /follows/:id - Fetch a specific follow
      get :read
      # GET /follows - List all followings of the current user
      index :list_followings

      # GET /follows?filter[target_id]=:target_id - Check if the current user follows a specific user
      # get :following
      # POST /follows - Follow a new user
      post :follow
      # DELETE /follows/:target_id - Unfollow a user
      delete :unfollow
    end
  end

  attributes do
    uuid_primary_key :id

    create_timestamp :created_at
  end

  relationships do
    belongs_to :user, Realworld.Accounts.User do
      allow_nil? false
      primary_key? true
    end

    belongs_to :target, Realworld.Accounts.User do
      allow_nil? false
      primary_key? true
    end
  end

  actions do
    defaults [:read]

    read :list_followings do
      filter expr(user_id == ^actor(:id))
    end

    read :following do
      get? true

      argument :target_id, :uuid do
        allow_nil? false
      end

      filter expr(user_id == ^actor(:id) and target_id == ^arg(:target_id))
    end

    create :follow do
      argument :target_id, :uuid do
        allow_nil? false
      end

      upsert? true
      upsert_identity :unique_follow

      change relate_actor(:user)
      change manage_relationship(:target_id, :target, type: :append)
    end

    destroy :unfollow do
      argument :target_id, :uuid do
        allow_nil? false
      end

      change filter(expr(target_id == ^arg(:target_id)))
      change filter(expr(user_id == ^actor(:id)))
    end
  end

  identities do
    identity :unique_follow, [:target_id, :user_id]
  end
end
