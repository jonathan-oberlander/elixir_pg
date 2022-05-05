defmodule Greeter do
  def greet do
    name = IO.gets("What's your name?\n") |> String.trim()

    case name do
      n when n in ["Jonathan", "jonathan"] ->
        "Oh, hi John! How are you doing?"

      _ ->
        "Hello, #{name}!"
    end
  end
end
