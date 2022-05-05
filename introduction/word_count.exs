filename = IO.gets("File to count the words from: ") |> String.trim()

words =
  File.read!(filename)
  |> String.split(~r{(\\n|[^\w'])+})
  |> Enum.filter(fn s -> s != "" end)

words |> Enum.count() |> IO.puts()
