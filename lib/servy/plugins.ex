require Logger

defmodule Servy.Plugins do

  @moduledoc """
    Handles HTTP requests.
  """

  def track(%{status: 404, path: path} = conv) do
    Logger.warning("Warning: #{path} is on the loose")
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{path: "/wildlife"} = conv) do
    Logger.info("Redirected from #{conv.path} to /wildthings")

    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path(conv), do: conv

  defp rewrite_path_captures(conv, %{"thing" => thing, "id" => id}) do
    %{conv | path: "/#{thing}/#{id}"}
  end

  defp rewrite_path_captures(conv, nil), do: conv

  def log(conv) do
    Logger.info(conv)
    conv
  end

  def emojify(%{status: 200, resp_body: resp} = conv) do
    %{conv | resp_body: "🎉 #{resp} 🎉"}
  end

  def emojify(conv), do: conv


end
