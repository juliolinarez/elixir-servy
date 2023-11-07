defmodule Servy.PledgeServer do

  @name __MODULE__

  def start do
    IO.puts("Starting the pledge server...")
    pid = spawn(__MODULE__, :listen_loop, [[]])
    Process.register(pid, @name)
    pid
  end

  def listen_loop(state) do
    IO.puts("\n Waiting for a message ...")

    receive do
      {sender, :create, name, amount} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        new_state = [{name, amount} | state]
        IO.puts("#{name} pledged #{amount}")
        IO.puts("New state is #{inspect new_state}")
        send sender, {:response, id}
        listen_loop(new_state)
      {sender, :recent} ->
        send sender, {:response, state}
        IO.puts("Sent pledges to #{inspect state}")
        listen_loop(state)
      end
  end

  def create_pledge(name, amount) do
    send @name, {self(), :create, name, amount}
    receive do
      {:response, status} ->
        status
    end
  end

  def recent_pledges do
    send @name, {self(), :recent}
    receive do
      {:response, pledges} ->
       pledges
    end

  end


  def run do
    pid = spawn(Servy.PledgeServer, :listen_loop, [[]])

    send pid, {self(), :create, "larry", 10}
    send pid, {self(), :create, "moe", 20}
    send pid, {self(), :create, "curly", 30}
    send pid, {self(), :create, "daisy", 40}
    send pid, {self(), :create, "grace", 50}

    send pid, {self(), :recent}

    receive do {:response, pledges} -> IO.inspect pledges end
    pid
  end


  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end
