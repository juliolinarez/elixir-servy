defmodule Servy.BearController do
  alias Servy.Wildthings
  alias Servy.Conv
  alias Servy.Bear

  @templates_path Path.expand("../../templates", __DIR__)

  def render(conv, template, bindings \\ []) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{conv | status: 200, resp_body: content}
  end

  def index(%Conv{} = conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.filter(&Bear.is_hibernating/1)

    render(conv, "index.eex", bears: bears)
  end

  def show(%Conv{} = conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    render(conv, "show.eex", bear: bear)
  end

  def show(%Conv{} = conv, _) do
    %{conv | status: 404, resp_body: "Not found"}
  end

  def create(%Conv{} = conv, %{"name" => name, "type" => type}) do
    %{conv | status: 201, resp_body: "Bear name: #{name} type: #{type}"}
  end
end
