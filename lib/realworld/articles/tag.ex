defmodule Realworld.Articles.Tag do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    domain: Realworld.Articles,
    extensions: [AshJsonApi.Resource]

  postgres do
    table "tags"
    repo Realworld.Repo
  end

  json_api do
    # Resource type in the JSON:API specification
    type "tags"

    routes do
      # Base path for this resource
      base "/tags"

      # CRUD Routes

      # GET /tags/:id - Fetch a specific tag by ID
      get :read

      # GET /tags - List all tags
      index :read

      # POST /tags - Create a new tag
      post :create

      # DELETE /tags/:id - Delete a tag
      delete :destroy
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  actions do
    defaults [:read, :destroy, create: [:name]]
  end

  identities do
    identity :unique_name, [:name]
  end
end
