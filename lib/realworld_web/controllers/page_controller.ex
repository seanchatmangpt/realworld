defmodule RealworldWeb.PageController do
  use RealworldWeb, :controller

  def index(conn, _params) do
    # Serve the Nuxt index.html from the Phoenix static folder
    index_path =
      :code.priv_dir(:realworld)
      |> Path.join("static/frontend/index.html")

    conn
    |> put_resp_content_type("text/html")
    |> Plug.Conn.send_file(200, index_path)
  end
end
