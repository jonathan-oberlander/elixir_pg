defmodule MoveImagesToFolder do
  def start() do
    get_image_files()
  end

  def get_image_files() do
    files = Path.wildcard("*.{jpg,png,gif,bmp}")

    if Enum.empty?(files) do
      IO.puts("No jpg, png, gif, bmp files were found in this folder.")
    else
      IO.puts("Found files:")
      Enum.each(files, fn file -> IO.puts(~s(\t#{file})) end)

      yn =
        IO.gets(~s(Would you like to move the files to the "/images" folder? y/n\n))
        |> String.trim()

      case yn do
        "y" -> make_folder(files)
        "n" -> :ok
      end
    end
  end

  def make_folder(files) do
    if !File.exists?("images/") do
      yn =
        IO.gets(~s(No "/images" folder found, would you like to create it? y/n\n))
        |> String.trim()

      case yn do
        "y" ->
          File.mkdir!("images")
          IO.puts(~s("/images" folder succesfully created))
          move_image_files(files)

        "n" ->
          :ok
      end
    else
      move_image_files(files)
    end
  end

  def move_image_files(files \\ []) do
    yn =
      IO.gets(~s(Ready to move the files the folder?\n))
      |> String.trim()

    case yn do
      "y" ->
        Enum.map(files, fn file -> File.rename!(file, ~s(images/#{file})) end)
        IO.puts(~S(Image files moved, see you soon.))

      "n" ->
        :ok
    end
  end
end
