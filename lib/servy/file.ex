defmodule Servy.File do

  alias Servy.Conv

  def handle_file({:ok, content}, %Conv{} = conv) do
    %{conv | status: 200, resp_body: content}
  end

  def handle_file({:error, :enoent}, %Conv{} = conv) do
    %{conv | status: 404, resp_body: "File not found"}
  end

  def handle_file({:error, reason}, %Conv{} = conv) do
    %{conv | status: 500, resp_body: "File error: #{reason}"}
  end

  def handle_extension(filename) do
    if Regex.match?(~r/.html$/i, filename) do
      "pages/#{filename}"
    else
      "pages/#{filename}.html"
    end
  end
end
