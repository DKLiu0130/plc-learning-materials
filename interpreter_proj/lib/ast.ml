type binop = 
  | Add
  | Sub
  | Mul
  | Div
  | Leq
  | Eq
  | Neq
  | Less
  | Greater
  | Land (* 指的是 && *)
  | Lor (* 指的是 || *)

type unop = 
  | Not (* 指的是 ! *)
  | Minus (* 指的是 - *)

type expr =
  | Int of int
  | Bool of bool
  | Var of string
  | Binop of binop * expr * expr
  | Unop of unop * expr
  | If of expr * expr * expr
  | Let of string * expr * expr

type typ = 
  | TInt
  | TBool

(* stmt 由 expr 的列表生成 *)
type stmt =
  | StmtList of expr list

(* 树状打印表达式类型 *)
let rec string_of_expr (e : expr) : string = 
  match e with
  | Int n -> Printf.sprintf "Int %d" n
  | Bool b -> Printf.sprintf "Bool %b" b
  | Var x -> Printf.sprintf "Var %s" x
  | Unop (unop, e) -> 
    let uop_str = 
      match unop with
      | Not -> "Not" 
      | Minus -> "Minus"
    in
    Printf.sprintf "Unary %s %s" uop_str (string_of_expr e)
  | Binop (binop, e1, e2) ->
    let binop_str = 
      match binop with 
      | Add -> "Add"
      | Mul -> "Mul"
      | Sub -> "Sub"
      | Div -> "Div"
      | Leq -> "Leq"
      | Greater -> "Greater"
      | Less -> "Less"
      | Eq -> "Eq"
      | Neq -> "Neq"
      | Land -> "Land"
      | Lor -> "Lor"
    in
    Printf.sprintf "Binop (%s, %s, %s)" binop_str (string_of_expr e1) (string_of_expr e2)
  | Let (e1, e2, e3) -> Printf.sprintf "Let (%s, %s, %s)"  (e1) (string_of_expr e2) (string_of_expr e3)
  | If (e1, e2, e3) -> Printf.sprintf "If (%s, %s, %s)"  (string_of_expr e1) (string_of_expr e2) (string_of_expr e3)