defmodule RealworldWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [
      Module.concat([
        "Realworld.Accounts"
      ]),
      Module.concat([
        "Realworld.Articles"
      ]),
      Module.concat([
        "Realworld.Profiles"
      ])
    ],
    open_api: "/open_api"
end
