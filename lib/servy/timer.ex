defmodule Servy.Timer do

  def remind(message, sec) do
    spawn(fn ->
      :timer.sleep(sec)
      IO.puts("It's done!: #{message}")
    end)
  end

end
