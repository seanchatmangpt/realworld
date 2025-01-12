defmodule Realworld.Accounts do
  use Ash.Domain, otp_app: :realworld, extensions: [AshJsonApi.Domain]

  json_api do
    authorize? false
  end

  resources do
    resource Realworld.Accounts.Token

    resource Realworld.Accounts.User do
      define :get_user_by_username, action: :get_by_username, args: [:username]
    end
  end

  authorization do
    authorize :by_default
  end
end
