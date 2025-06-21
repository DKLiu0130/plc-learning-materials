open Ast

(* check if an expression is a value (i.e., fully evaluated) *)
let is_value : expr -> bool = function
  | Int _ -> true
  | Bool _ -> true
  | Var _ -> true
  | _ -> false


(* takes a single step of evaluation of [e] *)
let rec step : expr -> expr = function
  | Int _  | Bool _ | Var _ -> failwith "Does not step on a number"

  (* No need for further stepping if both sides are already values *)
  | Binop (binop, e1, e2) when is_value e1 && is_value e2 -> 
    step_binop binop e1 e2

  (* Evaluate the right side of the binop if the left side is a value *)
  | Binop (binop, e1, e2) when is_value e1 -> Binop (binop, e1, step e2)

  (* Leftmost step for binop *)
  | Binop (binop, e1, e2) -> Binop (binop, step e1, e2)

  | If (e1, e2, e3) -> begin
    (* 不用一口气全化简完 *)
      if is_value e1 then step_if e1 e2 e3
      else If((step e1), e2, e3)
    end
  | Let (x, e2, e3) -> begin
    (* 不用一口气全化简完 *)
    if is_value e2 then subst x e2 e3 
    else Let(x, step e2, e3)
  end
  | Unop (unop, e1) -> 
    if is_value e1 then step_uop unop e1
    else Unop (unop, step e1)

(* implement the primitive operation [v1 binop v2].
   Requires: [v1] and [v2] are both values. *)
and step_binop binop v1 v2 = match binop, v1, v2 with
  | Add, Int a, Int b -> Int (a + b)
  | Sub, Int a, Int b -> Int (a - b)
  | Mul, Int a, Int b -> Int (a * b)
  | Div, Int a, Int b when b <> 0 -> Int (a / b)
  | Leq, Int a, Int b -> Bool (a <= b)
  | Div, Int _, Int 0 -> failwith "Division by zero"
  | Greater, Int a, Int b -> Bool (a > b)
  | Less, Int a, Int b -> Bool (a < b)
  | Eq, Int a, Int b -> Bool (a = b)
  | Eq, Bool a, Bool b -> Bool (a = b) (* 可选，允许 bool 判等 *)
  | Neq, Int a, Int b -> Bool (a <> b)
  | Neq, Bool a, Bool b -> Bool (a <> b)
  | Land, Bool a, Bool b -> Bool (a && b)
  | Lor, Bool a, Bool b -> Bool (a || b)
  | _ -> failwith "Operator and operand type mismatch"

and step_uop unop v1 = match unop, v1 with
| Not, Bool x -> Bool (not x)
| Minus, Int x -> Int (-x)
| _, _ -> failwith "not completed yet"

and step_if v1 e2 e3 = match v1, e2, e3 with
| Bool true, e2, _ -> e2
| Bool false, _, e3 -> e3
| _ -> failwith "Condition of if must be a boolean value"

(* substitute x in e3 with v2 *)
and subst x v2 e3 = match e3 with
| Int _ | Bool _ -> e3
| Var y -> if y = x then v2 else e3
| Binop (binop, e1, e2) -> Binop(binop, subst x v2 e1, subst x v2 e2)
| Unop (unop, e1) -> Unop (unop, subst x v2 e1)
| If (e1, e2, e3') -> If(subst x v2 e1, subst x v2 e2, subst x v2 e3')
| Let (y, e1, e2) -> 
  (* 
    let x = 5 in (let x = x + 1 in x + 2) 
    其中 x 即 'x', v2 = 5, 
    e3 = Let(y, e1, e2) = Let('x', x + 1, x + 2)
  *) 
  (* 先要把 e1 中的 x 给带入进去*)
  let e1' = subst x v2 e1 in
  (* e2 的 x 要用 y 换，因为同名隐藏，下一次再 eval ) *)
  if x = y then Let (y, e1', e2) 
  (* 否则 subst 把 e2 里面的 x 全部替换干净 *)
  else Let(y, e1', subst x v2 e2)
  
(* 不断对 e 进行单步求值直到成为 value *)
let rec eval (e : expr) : expr =
  if is_value e then e else
    e |> step |> eval

