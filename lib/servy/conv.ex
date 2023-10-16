defmodule Servy.Conv do
  defstruct method: "", path: "", resp_body: "", status: nil, params: %{}

  alias Servy.Conv

  def full_status(%Conv{} = conv) do
    "#{conv.status} #{status_reason(conv.status)}"
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not found",
      500 => "Internal Server Error"
    }[code]
  end
end
