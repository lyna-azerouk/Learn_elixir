defmodule Typeur.Pterm do
  @current_value ref: 0

  defmodule Liste do
    defstruct Vide: nil, Cons: nil

    def vide, do: %Liste{Vide: nil}
    def cons(a, l), do: %Liste{Cons: {a, l}}
  end


  defmodule CompteurVar do
    @compteur_var ref: 0

    def set(val) do
      Process.put(:compteur_var, val)
    end

    def get do
      Process.get(:compteur_var)
    end
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




  def alpha_conversion (t) do

  end

end
