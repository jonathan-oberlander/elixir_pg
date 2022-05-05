defmodule MinimalTodo do
  def start() do
    # ask use for file name,
    filename = IO.gets("Name of the .cvs file to load: ") |> String.trim()

    # read it
    read(filename)
    |> parse
    |> get_command

    # parse data
    # ask user for commands
    # (read todos, add, delete, load file, save file)
  end

  def read(filename) do
    case File.read(filename) do
      {:ok, body} ->
        body

      {:error, reason} ->
        IO.puts(~s(Could not open file "#{filename}"))
        IO.puts(~s(#{:file.format_error(reason)}))
        start()
    end
  end

  def parse(body) do
    [header | items] =
      String.split(body, ~r{(\n\r|\n|\r)})
      |> Enum.filter(fn s -> s != "" end)

    # without the Item
    columns = tl(String.split(header, ","))
    parse_items(items, columns)
  end

  def parse_items(items, columns) do
    Enum.reduce(items, %{}, fn line, acc ->
      [todo | details] = String.split(line, ",")

      if Enum.count(details) == Enum.count(columns) do
        line_data = Enum.zip(columns, details) |> Enum.into(%{})
        Map.merge(acc, %{todo => line_data})
      else
        acc
      end
    end)
  end

  def show_todos(data, next_command? \\ true) do
    items = Map.keys(data)
    IO.puts("You have the following todos:")
    Enum.each(items, fn item -> IO.puts(item) end)

    if next_command? do
      get_command(data)
    end
  end

  def get_command(data) do
    prompt = """
    Type the first letter of the command you would like to execute:
    R)ead todos\tA)dd a todo\tD)elete a todo\tL)oad a .csv\tS)ave a .csv\nQ)uit
    """

    command =
      IO.gets(prompt)
      |> String.trim()
      |> String.downcase()

    case command do
      "r" -> show_todos(data)
      "d" -> delete_todo(data)
      "q" -> "Goodbye !"
      _ -> get_command(data)
    end
  end

  def delete_todo(data) do
    todo = IO.gets("Which todo would you like to delete? ") |> String.trim()

    if Map.has_key?(data, todo) do
      IO.puts("Ok!")
      new_map = Map.drop(data, [todo])
      IO.puts(~s("#{todo}" has been deleted!))
      get_command(new_map)
    else
      IO.puts(~s(There is no todo named "#{todo}!"))
      show_todos(data, false)
      delete_todo(data)
    end
  end
end
