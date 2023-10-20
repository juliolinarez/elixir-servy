defmodule Servy.BearController do
  alias Servy.Wildthings
  alias Servy.Conv
  alias Servy.Bear

  def index(%Conv{} = conv) do
    items =
      Wildthings.list_bears()
      |> Enum.filter(&Bear.is_hibernating/1)
      |> Enum.map(&bear_item/1)
      |> Enum.join()

    %{conv | status: 200, resp_body: "<ul> #{items} </ul>"}
  end

  defp bear_item(bear) do
    "<li>Name: #{bear.name} Type: #{bear.type} </li>"
  end

  def show(%Conv{} = conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{conv | status: 200, resp_body: "Bear #{id} name #{bear.name} type #{bear.type}"}
  end

  def show(%Conv{} = conv, _) do
    %{conv | status: 404, resp_body: "Not found"}
  end

  def create(%Conv{} = conv, %{"name" => name, "type" => type}) do
    %{conv | status: 201, resp_body: "Bear name: #{name} type: #{type}"}
  end
end
