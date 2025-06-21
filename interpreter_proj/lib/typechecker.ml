open Ast

(* 查找上下文中 x 的类型 *)
let lookup env x = 
  try List.assoc x env
  with Not_found -> failwith "Unbound variable"

(* 添加 <x,ty> 记录 *)
let extend env x ty = 
  (x, ty) :: env

(* 对 e 在上下文 env 里面做类型检查 *)
let rec typeof (env:(string*typ) list) e = 
  match e with
| Int _ -> TInt
| Bool _ -> TBool
| Var x -> lookup env x
| Let (x, e1, e2) -> typeof_let env x e1 e2
| Unop (unop, e) -> typeof_uop env unop e
| Binop (bop, e1, e2) -> typeof_bop env bop e1 e2
| If (e1, e2, e3) -> typeof_if env e1 e2 e3
(* | _ -> failwith "not completed yet" *)

and typeof_let (env:(string*typ) list) x e1 e2 = 
    let t1 = typeof env e1 in
    let env' = extend env x t1 in
    typeof env' e2

and typeof_bop env bop e1 e2 = 
  let t1, t2 = typeof env e1, typeof env e2 in
  match bop, t1, t2 with
  | Add, TInt, TInt | Mul, TInt, TInt | Sub, TInt, TInt | Div, TInt, TInt -> TInt
  | Leq, TInt, TInt 
  | Greater, TInt, TInt | Less, TInt, TInt | Eq, TInt, TInt | Neq, TInt, TInt -> TBool
  | Eq, TBool, TBool | Neq, TBool, TBool -> TBool (* 可选，允许 bool 判等 *)
  | Lor, TBool, TBool | Land, TBool, TBool -> TBool
  | _ -> failwith "mismatched type"

and typeof_uop env unop e = match unop, typeof env e with
| Not, TBool -> TBool
| Minus, TInt -> TInt
| _ -> failwith "mismatched type"

and typeof_if env e1 e2 e3 = 
  if typeof env e1 = TBool then begin
    let t2 = typeof env e2 in
    let t3 = typeof env e3 in
    if t2 = t3 then t2 else failwith "e2 e3 type mismatch"
  end
  else failwith "e1 don't has type bool"

let typecheck (e:expr):expr = 
  try
  let _ = typeof [] e in
  e
  with
  Failure _ -> Printf.printf "Failed typechecking! Return Int(-1) \n";
  Int (-1)
