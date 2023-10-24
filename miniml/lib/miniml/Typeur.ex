defmodule Typeur.Pterm do
  defmodule Liste do
    defstruct Vide: nil, Cons: nil

    def vide, do: %Liste{Vide: nil}
    def cons(a, l), do: %Liste{Cons: {a, l}}
  end

  defmodule Ptype do
     defstruct Var: nil,
               Arr: nil,
               Nat:  nil
   end
  defstruct Var: nil,
            App: nil,
            Abs: nil,
            N: nil,
            Add: nil,
            Sou: nil,
            ListP: nil,
            Hd: nil,
            Tail: nil,
            Izte: nil

  defmodule Env do
    defstruct Env: nil
  end

  def translate_pterm(%{Var: var}), do: %{Var: var}
  def traanslate_pterm(%{App: {func, arg}}), do: %{App: {translate_pterm(func), translate_pterm(arg)}}
  def traanslate_pterm(%{Abs: {s, body}}), do: %{Abs: {s, translate_pterm(body)}}
  def traanslate_pterm(%{N: val}), do: %{N: val}
  def translate_pterm(%{Add: {f1,f2}}), do: %{Add: {translate_pterm(f1), traanslate_pterm(f2)}}
  def translate_pterm(%{Sou: {f1,f2}}), do: %{Sou: {translate_pterm(f1), traanslate_pterm(f2)}}
  def translate_pterm(%{ListeP: {Liste.Vide}}), do: %{ListeP: {}}
  def translate_pterm(%{ListeP: {%Liste{Cons: {a, l}}}}), do: %{ListeP: {Liste.cons(traanslate_pterm(a), traanslate_pterm(l))}}
  def translate_pterm(%{Hd: {%Liste{Cons: {a, l}}}}), do: %{Hd: {Liste.cons(traanslate_pterm(a), traanslate_pterm(l))}}

  def print_term_liste(l) do
    case l do
      :Vide ->"nil"
      {:Cons, {a, l}} -> "#{print_term(a)}  #{print_term_liste(l)}"
    end
  end

  def print_term(t) do
    case t do
      {:Var, x} ->x
      {:App, func, body} -> "(#{print_term(func)}  #{print_term(body)})"
      {:Abs, x, t} -> "(fun #{x} -> #{print_term(t)})"
      {:N, x} -> x
      {:ListeP,  Vide } -> ""
      {:ListeP, {:Cons, a, l}}  -> "[#{print_term((a))} , #{print_term_liste(l)}  ]"
      {:Add, t1, t2} ->"#{print_term(t1)} +#{print_term(t2)}"

    end
  end

  defmodule State do
    defstruct compteur: 0
    def incrementer_compteur(%State{compteur: compteur} = state) do
      %State{ compteur: compteur + 1}
    end

    def nouvelle_var(%State{} = state) do
      new_state = incrementer_compteur(state)
      "T#{new_state.compteur}"
    end
  end
  defmodule Exception  do
    defexception message: "var non trouvé "
  end

#Si recurssion ==>  plusieurs fonction avec patern match
  defp cherche_type(_, []), do: raise "Exception.defexception"
  defp cherche_type(s, [{v1, _v2}|_tail]) when v1== s, do: v1
  defp cherche_type(s, [{_v1, _}|tail]), do: cherche_type(s, tail)


 @spec alpha_convertion(any(), any()) :: nil
 def alpha_convertion(l, acc) do
     case l do
        {:Var, x} ->(case acc do
                       []-> {:Var ,State.nouvelle_var(%State{compteur: 0})}
                       [{var, new_var}|tail]  -> (if var == x  do
                        {:Var, new_var}
                       else
                        alpha_convertion({:Var, x}, tail)
                       end)
                    end)
     end
 end

end
