defmodule IKnowYou.Web.ErrorView do
  use IKnowYou.Web, :view

  alias Ecto.Changeset

  def render("unprocessable.json", %{error: %Changeset{} = error}) do
    %{error: %{message: "Unprocessable Entity", details: traverse_errors(error)}}
  end

  defp traverse_errors(changeset) do
    Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
