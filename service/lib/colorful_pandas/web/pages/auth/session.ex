defmodule ColorfulPandas.Web.Pages.Auth.Session do
 use ColorfulPandas.Web, :controller 

  @doc """
  Ends an authenticated session.
  """
  def logout(conn, _params) do
    ColorfulPandas.Web.Auth.end_session(conn)
  end
end
