defmodule DiningPhilosophers do
  def run do
    num = 5
    forks = Enum.map(0..num-1, fn _ -> spawn_link(&fork/0) end)

    Enum.each(0..num-1, fn id ->
      left = Enum.at(forks, id)
      right = Enum.at(forks, rem(id + 1, num))
      spawn_link(fn -> philosopher(id, left, right) end)
    end)

    :timer.sleep(5000)
  end

  defp fork do
    receive do
      {:take, pid} ->
        send(pid, :taken)
        receive do
          {:release, _} -> fork()
        end
    end
  end

  defp philosopher(id, left, right) do
    think(id)
    eat(id, left, right)
    philosopher(id, left, right)
  end

  defp think(id) do
    IO.puts("Philosopher #{id} is thinking")
    :timer.sleep(:rand.uniform(1000))
  end

  defp eat(id, left, right) do
    {first, second} = if rem(id, 2) == 0 do
      {left, right}
    else
      {right, left}
    end

    take_fork(first)
    take_fork(second)

    IO.puts("Philosopher #{id} is eating")
    :timer.sleep(:rand.uniform(1000))

    release_fork(first)
    release_fork(second)
  end

  defp take_fork(fork) do
    send(fork, {:take, self()})
    receive do
      :taken -> :ok
    end
  end

  defp release_fork(fork) do
    send(fork, {:release, self()})
  end
end

DiningPhilosophers.run()
