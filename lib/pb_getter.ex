defmodule PbGetter do

  import PbGetter.Pb_Args
  import PbGetter.Pb_Output

  def main(args) do
    arg = parse_args(args)
    use_args(arg)
    |> handle_output(arg)
  end 
end
