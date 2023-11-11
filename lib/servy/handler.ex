defmodule Servy.Handler do
  import Servy.Plugins, only: [track: 1, rewrite_path: 1, log: 1]
  import Servy.File, only: [handle_file: 2, handle_extension: 1]
  import Servy.Parser, only: [parse: 1]

  alias Mix.Dep.Fetcher
  alias Mix.Dep.Fetcher
  alias Mix.Dep.Fetcher
  alias Mix.Dep.Fetcher
  alias Mix.Dep.Fetcher
  alias Servy.Conv
  alias Servy.BearController
  alias Servy.VideoCam
  alias Servy.Fetcher

  @moduledoc """
    Handles HTTP requests.
  """

  @doc """
   Transforms a request into a response.
  """
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    # |> emojify
    |> track
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/sensors"} = conv) do
    sensor_data = Servy.SensorServer.get_sensor_data()

    %{conv | status: 200, resp_body: inspect(sensor_data)}
  end

  def route(%Conv{method: "POST", path: "/pledges"} = conv) do
    Servy.PledgeController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/pledges"} = conv) do
    Servy.PledgeController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/hibernate/" <> time} = conv) do
    time |> String.to_integer() |> :timer.sleep()

    %{conv | status: 200, resp_body: "Awake!"}
  end

  def route(%Conv{method: "GET", path: "/kaboom"}) do
    raise "kaboom!"
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    BearController.show(conv, Map.put(conv.params, "id", id))
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Servy.Api.BearController.index(conv)
  end

  def route(%Conv{method: "POST", path: "/bears", params: params} = conv) do
    BearController.create(conv, params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    File.read("pages/about.html") |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    File.read("pages/form.html") |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/pages/" <> filename} = conv) do
    handle_extension(filename) |> File.read() |> handle_file(conv)
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: #{conv.resp_content_type}\r
    Content-Length: #{String.length(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end
end
