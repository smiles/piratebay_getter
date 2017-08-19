defmodule PbGetter.Pb_Args do

  import PbGetter.Pb_Get

  def parse_args(opts) do
    args = OptionParser.parse(
           opts,
           switches: [help: :boolean, seed: :boolean, asce_seed: :boolean,
                      leech: :boolean, asce_leech: :boolean, upload: :boolean,
                      asce_upload: :boolean, size: :boolean, asce_size: :boolean,
                      ul_by: :boolean, asce_ul_by: :boolean, tor: :boolean,
                      file: :string, rss: :string],
           aliases:  [h: :help, s: :seed, S: :asce_seed, l: :leech, L:
                     :asce_leech, u: :upload, U: :asce_upload, i: :size,
                     I: :asce_size, b: :ul_by, B: :asce_ul_by])
  end

  def use_args(opts) do


    pirates = %PbGetter.Pb_URL{}

    argu = List.to_string(elem(opts, 1))
    Tuple.delete_at(opts, 1)
    options = elem(opts, 0)

    url_end = first_option(List.first(options), pirates)
    options = List.delete_at(options, 0)
    domain_url = second_option(List.first(options), pirates)
    
    url = domain_url <> argu <> url_end 

    pb_request(url)

  end

  defp first_option(opt, pirate) do 
    case opt do
      {:help, true} ->
        display_help()
      {:seed, true} ->
        pirate.seed 
      {:asce_seed, true} ->
        pirate.asce_seed
      {:leech, true} ->
        pirate.leech
      {:asce_leech, true} ->
        pirate.asce_leech
      {:upload, true} ->
        pirate.upload
      {:asce_upload, true} ->
        pirate.asce_upload
      {:size, true} ->
        pirate.size
      {:asce_size, true} ->
        pirate.asce_size
      {:ul_by, true} ->
        pirate.ul_by
      {:asce_ul_by, true} ->
        pirate.asce_ul_by
      _ ->
        display_help()
    end
  end

  defp second_option(opt, pirate) do
    case opt do
      {:tor, true} ->
        pirate.tor
      _ ->
        pirate.url
    end
  end



#############################################################
## Prints out help info.
###########################################################
  defp display_help() do
    IO.puts """
 
 Usage: [option] [--tor] [--file/--rss] [search item]
  
 -s, --seed    Sort by seed descending order.
    """
  end
end
