defmodule Servy.BearController do
  alias Servy.BearView
  alias Servy.Wildthings
  alias Servy.Conv
  alias Servy.Bear

  # @templates_path Path.expand("../../templates", __DIR__)

  # def render(conv, template, bindings \\ []) do
  #   content =
  #     @templates_path
  #     |> Path.join(template)
  #     |> EEx.eval_file(bindings)

  #   %{conv | status: 200, resp_body: content}
  # end

  def index(%Conv{} = conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)

    # render(conv, "index.eex", bears: bears)
    %{ conv | status: 200, resp_body: BearView.index(bears) }
  end

  def show(%Conv{} = conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{ conv | status: 200, resp_body: BearView.show(bear) }
    # render(conv, "show.eex", bear: bear)
  end

  def show(%Conv{} = conv, _) do
    %{conv | status: 404, resp_body: "Not Found"}
  end

  def create(%Conv{} = conv, %{"name" => name, "type" => type}) do
    %{conv | status: 201, resp_body: "Created a #{type} bear named #{name}!"}
  end
end
