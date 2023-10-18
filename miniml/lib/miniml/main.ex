defmodule Miniml.Main do
  import Typeur.Pterm

  def main do
    pterm2 = %Typeur.Pterm{App: %{Var: "x", Var: "x"}}
    translated_pterm2 = Typeur.Pterm.translate_pterm(pterm2)
    IO.inspect(Typeur.Pterm.print_term(pterm2))
  end
end
Miniml.Main.main()
