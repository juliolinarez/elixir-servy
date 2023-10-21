defmodule Servy.Handler do
  import Servy.Plugins, only: [track: 1, rewrite_path: 1, log: 1, emojify: 1]
  import Servy.File, only: [handle_file: 2, handle_extension: 1]
  import Servy.Parser, only: [parse: 1]

  alias Servy.Conv
  alias Servy.BearController
  import IEx

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
    |> emojify
    |> track
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    IO.puts("pepepe sjdfnsojdnfksjnfksj")
    BearController.show(conv, Map.put(conv.params, "id", id))
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    IEx.pry()
    BearController.index(conv)
  end

  def route(%Conv{method: "POST", path: "/bears", params: params} = conv) do
    BearController.create(conv, params)
  end

  def route(%Conv{method: "GET", path: "/about.html"} = conv) do
    File.read("pages/about.html") |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    File.read("pages/form.html") |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/pages/" <> filename} = conv) do
    handle_extension(filename) |> File.read() |> handle_file(conv)
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here"}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

# request = """
# GET /wildthings HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)

# IO.puts(response)
# IO.puts("==============")

# IO.puts(response)
# IO.puts("==============")

# request = """
# GET /bigfoot HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)

# IO.puts(response)
# IO.puts("==============")

# request = """
# GET /pepe HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)

# IO.puts(response)
# IO.puts("==============")

# request = """
# GET /bears/1 HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)

# IO.puts(response)
# IO.puts("==============")

# request = """
# GET /wildlife HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)

# IO.puts(response)
# IO.puts("==============")

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)
IO.puts("==============")

# request = """
# GET /about.html HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)

# IO.puts(response)
# IO.puts("==============")

# request = """
# GET /bears/new HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)

# IO.puts(response)
# IO.puts("==============")

# request = """
# GET /pages/about HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)

# IO.puts(response)
# IO.puts("==============")

# request = """
# GET /pages/about.html HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)

# IO.puts(response)
# IO.puts("==============")

# request = """
# POST /bears HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*
# Content-Type: application/x-www-form-urlencoded
# Content-Length: 21

# name=Baloo&type=Brown
# """

# response = Servy.Handler.handle(request)

# IO.puts(response)
# IO.puts("==============")

# request = """
# GET /bears/1 HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)
# IO.puts(response)
# IO.puts("==============")
