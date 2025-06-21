open Ast


(* substitute x in e3 with v2 *)
let rec subst x v2 e3 = match e3 with
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



(* 大步求值，返回值是一个 value *)
let rec eval_big (e : expr) : expr = match e with
  | Int _ | Var _ | Bool _ -> e
  | Binop (binop, e1, e2) -> eval_bop binop e1 e2
  | Unop (unop, e1) -> eval_uop unop e1
  | If (e1, e2, e3) -> eval_if e1 e2 e3
  | Let (x, e2, e3) -> 
    let e3' = subst x (eval_big e2) e3 
    in eval_big e3' 

and eval_bop binop e1 e2 = match binop, eval_big e1, eval_big e2 with
  | Add, Int a, Int b -> Int (a + b)
  | Sub, Int a, Int b -> Int (a - b)
  | Mul, Int a, Int b -> Int (a * b)
  | Div, Int a, Int b when b <> 0 -> Int (a / b)
  | Leq, Int a, Int b -> Bool (a <= b)
  | Greater, Int a, Int b -> Bool (a > b)
  | Less, Int a, Int b -> Bool (a < b)
  | Eq, Int a, Int b -> Bool (a = b)
  | Eq, Bool a, Bool b -> Bool (a = b)
  | Neq, Int a, Int b -> Bool (a <> b)
  | Neq, Bool a, Bool b -> Bool (a <> b)
  | Land, Bool a, Bool b -> Bool (a && b)
  | Lor, Bool a, Bool b -> Bool (a || b)
  | Div, Int _, Int 0 -> failwith "Division by zero"
  | _ -> failwith "Operator and operand type mismatch"

and eval_uop unop e = match unop, eval_big e with
| Not, Bool x -> Bool (not x)
| Minus, Int x -> Int (-x)
| _ -> failwith "not completed yet"

and eval_if e1 e2 e3 = match eval_big e1 with
| Bool true -> eval_big e2
| Bool false -> eval_big e3
| _ -> failwith "Condition of if must be a boolean value"


    
