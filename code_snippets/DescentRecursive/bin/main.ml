open Ast
open Print

let rec calculate_num ast =
  match ast with
  | Add (x, y) -> calculate_num x + calculate_num y
  | Sub (x, y) -> calculate_num x - calculate_num y
  | Mul (x, y) -> calculate_num x * calculate_num y
  | Div (x, y) -> calculate_num x / calculate_num y
  | Id x -> Stack.check x
  | _ -> raise (Failure "error in calculate_num")
;;

let calculate_print ast =
  match ast with
  | Whole lst ->
    let rec func list =
      match list with
      | [] -> ()
      | h :: t ->
        (match h with
         | Assign _ -> func t
         | _ ->
           Printf.printf "\nRESULT: %d\n" (calculate_num h);
           func t)
    in
    func lst
  | _ -> raise (Failure "error calculate_print")
;;

let () =
  let lexbuf = Lexing.from_channel stdin in
  let tokens = Lexer.gettokens [] lexbuf in
  (* (match List.rev tokens with
   | h :: _ -> print_string (Parser.string_of_token h)
   | _ -> print_string "NO");  *)
  let ast = Parser.main_state tokens in
  let retstr = print_ast ast in
  Printf.printf "\n%s\n" retstr;
  calculate_print ast
;;
