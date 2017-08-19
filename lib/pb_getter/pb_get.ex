defmodule PbGetter.Pb_Get do
  
  def pb_request(url) do
    HTTPoison.start
    return = elem(HTTPoison.get(url), 1) 
    body = Map.get(return, :body)
    status = Map.get(return, :status_code)

    case status do
      200 -> parse_html(body)
      404 -> IO.puts "Recieve a 404 reponse"
      _   -> IO.puts "Something has gone horrible wrong and beyond what I saw was possible"
    end
  end 

  defp parse_html(html) do
    result = Floki.find(html, "table")
    |> Floki.raw_html
    
    detname_result = Floki.find(result, "div.detName") 

    magnet_result = Floki.attribute(result, "a", "href")
    |> Enum.drop( 8)
    
    clean_titles  = get_title(detname_result, [])
    clean_magnets = get_magnet(magnet_result, [])

    #display_tm(clean_titles, clean_magnets)
  
    combine_tm(clean_titles, clean_magnets, [])

  end
  
  defp get_title([head | tail], title_list) do
    head = Tuple.delete_at(head, 0)
    head = Tuple.delete_at(head, 0) 

    head = elem(head, 0)
    head = List.first(head)

    head = Tuple.delete_at(head, 0)
    head = Tuple.delete_at(head, 0)

    head = elem(head, 0)

    get_title(tail, title_list ++ head)

  end

  defp get_title([], title_list) do
    title_list
  end

  defp get_magnet([head | tail], magnet_list) do
    cond do
      Regex.match?(~r/magnet:/, head) -> 
        get_magnet(tail, List.insert_at(magnet_list, -1, head ))
      true -> get_magnet(tail, magnet_list)
    end
  end

  defp get_magnet([], magnet_list) do
    magnet_list
  end

  #defp display_tm([ head_t | tail_t ], [ head_m | tail_m]) do
  # IO.puts head_t 
  # IO.puts "\n"
  # IO.puts head_m
  # IO.puts "\n"
  #
  # display_tm(tail_t, tail_m)
  #end
  #
  #defp display_tm([], []) do
    #IO.puts "\n\nTHE END"
    #end
  
  defp combine_tm([ head_t | tail_t], [ head_m | tail_m], comp_list) do
    
    fin = { head_t, head_m }

    combine_tm(tail_t, tail_m, List.insert_at(comp_list, -1, fin))
  end

  defp combine_tm([], [], comp_list) do
    comp_list
  end

end
