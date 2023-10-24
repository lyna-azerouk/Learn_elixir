defmodule Miniml.Main do
  import   Typeur.Pterm
  import   Typeur.Pterm.State
  def main do
    term1 = {:Var, "x"}
    result1 = print_term(term1)

    term2 = {:Abs, "x", term1}
    result1 = print_term(term2)
    IO.puts(result1)


    term3 = {:App, {:Var, :f}, {:Var, :x}}
    result3 = print_term(term3)
    IO.puts(result3)

    term4 = {:ListeP, {:Cons, term1, :Vide}}
    result4 = print_term(term4)
    IO.puts(result4)
    initial_state =%Typeur.Pterm.State{compteur: 0}
    variable_name =Typeur.Pterm.State.nouvelle_var(initial_state)
    IO.puts variable_name
    IO.puts("je suis la ")
    term1 = {:Var,  "x"}
    result =  (alpha_convertion(term1,[]))
    IO.puts(print_term(result))
  end
end
Miniml.Main.main()
