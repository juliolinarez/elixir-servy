defmodule Servy.KickStarter do
  use GenServer

  def start do
    IO.puts "Stating kickstarter ..."
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_http_server()
    {:ok, server_pid}
  end

  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts "HttpServer exited: #{inspect reason}"
    server_pid = start_http_server()
    {:noreply, server_pid}
  end

  defp start_http_server do
    IO.puts "Starting the HTTP server..."
    server_pid = spawn_link(Servy.HttpServer, :start, [4000])
    # Process.link(server_pid)
    Process.register(server_pid, :http_server)
    server_pid
  end

  def script! do
    {:ok, pid} = Servy.KickStarter.start()
    server_pid = Process.whereis(:http_server)
    Process.exit(server_pid, :kaboom)
    Process.alive? server_pid
    Process.alive? pid
  end

end
