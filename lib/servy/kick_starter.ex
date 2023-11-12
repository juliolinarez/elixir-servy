defmodule Servy.KickStarter do
  use GenServer

  def start_link(_args) do
    IO.puts "Stating kickstarter ..."
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get_server do
    GenServer.call __MODULE__, :get_server
  end

  # Server callbacks

  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_http_server()
    {:ok, server_pid}
  end

  def handle_call(:get_server, _from, state) do
    {:reply, state, state}
  end

  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts "HttpServer exited: #{inspect reason}"
    server_pid = start_http_server()
    {:noreply, server_pid}
  end

  defp start_http_server do
    IO.puts "Starting the HTTP server..."
    port = Application.get_env(:servy, :port)
    server_pid = spawn_link(Servy.HttpServer, :start, [port])
    # Process.link(server_pid)
    # Process.register(server_pid, :http_server)
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
