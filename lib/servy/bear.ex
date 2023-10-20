defmodule Servy.Bear do
  defstruct id: nil,
            name: "",
            type: "",
            hibernating: false

  def is_hibernating bear do
    bear.hibernating
  end


end
