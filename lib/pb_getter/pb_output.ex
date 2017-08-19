defmodule PbGetter.Pb_Output do 

  def handle_output(url_output, arg) do
   proc_to(elem(arg, 0), url_output) 
  end

  defp proc_to([ head | _tail ], output) do
    case head do
      {:rss, _} ->
        create_rss(elem(head, 1), output)
      {:file, _} ->
        create_file(elem(head, 1), output)
      _ ->
        proc_to(_tail, output)
    end
  end

  defp proc_to([], output) do
    display_terminal(output)
  end

  defp display_terminal([ head | tail ]) do
    IO.puts "+++ " <> elem(head, 0) <> " +++"
    IO.puts elem(head, 1)
    IO.puts "\n"

    display_terminal(tail)
  end

  defp display_terminal([]) do
  end

  defp create_rss(file_path, write) do
    content = "<rss version=\"2.0\"> \n <channel> \n"
    final_write(file_path, rss_content(write, content))
  end

  defp create_file(file_path, write) do
    content = ""
    final_write(file_path, file_content(write, content))  
  end

  defp rss_content([ head | tail], content) do
    content = Enum.join([content, "<title>", elem(head, 0), "</title>\n"])
    content = Enum.join([content, "<link>", elem(head, 1), "</link>\n"])
    rss_content(tail, content)
  end

  defp rss_content([], content) do
    content = Enum.join([content, "</channel> \n </rss>"])
    content
  end

  defp file_content([ head | tail ], content) do
    content = Enum.join([content, "+++ ", elem(head, 0), " +++\n"]) 
    content = Enum.join([content, elem(head, 1), "\n\n"])
    file_content(tail, content)
  end

  defp file_content([], content) do
    content
  end

  defp final_write(file_path, write) do 
    File.write(file_path, write)
  end
end
