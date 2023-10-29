require Logger

defmodule Servy.Plugins do
  alias Servy.Conv

  @moduledoc """
    Handles HTTP requests.
  """

  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env() != :test do
      Logger.warning("Warning: #{path} is on the loose")
    end
    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    Logger.info("Redirected from #{conv.path} to /wildthings")

    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path(%Conv{} = conv), do: conv

  defp rewrite_path_captures(%Conv{} = conv, %{"thing" => thing, "id" => id}) do
    %{conv | path: "/#{thing}/#{id}"}
  end

  defp rewrite_path_captures(%Conv{} = conv, nil), do: conv

  def log(%Conv{} = conv) do
    if Mix.env() == :dev do
      Logger.info(conv)
    end
    conv
  end

  def emojify(%Conv{status: 200, resp_body: resp} = conv) do
    %{conv | resp_body: "🎉 #{resp} 🎉"}
  end

  def emojify(%Conv{} = conv), do: conv
end
