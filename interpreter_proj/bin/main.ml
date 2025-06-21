open Interpreterlib
open Typechecker
open Big_step_evaluation
open Small_step_evaluation
open Ast

(* 对 statement 里面的 expression 进行一条一条执行 *)
let parse_stmt (s : string) : stmt =
  let lexbuf = Lexing.from_string s in
  try
    Parser.program Lexer.read lexbuf (* 解析为表达式树 *)
  with
  | Parsing.Parse_error ->
      (* 实验性功能, 可能有一个 token 的判断误差 *)
      let pos = lexbuf.Lexing.lex_curr_p in (* 停在报错的 pos 上 *)
      let line = pos.Lexing.pos_lnum in (* 从 1 开始编号 *)
      let col = pos.Lexing.pos_cnum - pos.Lexing.pos_bol + 1 in (* 从 1 开始编号 *)
      let token = Lexing.lexeme lexbuf in
      Printf.eprintf "Syntax error at line %d, column %d: unexpected token '%s'\n"
        line col token;
      exit 1

(* lexing  -> 
   parsing -> 
   execute all expressions and converting the result to a string sequentially *)
let interp (s : string) : string list = 
  let s = parse_stmt s in
  match s with
  | StmtList stmtList -> 
    let helper = (fun s -> s |> typecheck |> eval |> string_of_expr) in
    List.map helper stmtList 

(* lexing  -> 
   parsing -> 
   execute all expressions and converting the result to a string sequentially *)
let interp_big (s : string) : string list = 
  let s = parse_stmt s in
  match s with
  | StmtList stmtList -> 
    let helper = (fun s -> s |> typecheck |> eval_big |> string_of_expr) in
    List.map helper stmtList

(* ANSI colors *)
let green s = "\027[32m" ^ s ^ "\027[0m"
let red s = "\027[31m" ^ s ^ "\027[0m"

(* Padding helper *)
let pad_right s len =
  s ^ String.make (max 0 (len - String.length s)) ' '

let () =
  let () = Printexc.record_backtrace true in

  let read_file filename =
    let ic = open_in filename in
    let content = really_input_string ic (in_channel_length ic) in
    close_in ic;
    content
  in

  let filename = "test/test_stmt.in" in
  let standard_file = "test/standard.out" in

  (* 表状打印结果并对比 *)
  let file_content = read_file filename in
  let standard_output = String.split_on_char '\n' (read_file standard_file) |> List.filter (fun x -> x <> "") in

  let res_small = interp file_content in   (* small-step *)
  let res_big = interp_big file_content in (* big-step *)

  let max_len = List.fold_left max 5 (List.map String.length (res_small @ res_big @ standard_output)) in
  let pad = pad_right in

  Printf.printf "%s\n" (String.make (max_len * 3 + 10) '-');
  Printf.printf "| %s | %s | %s |\n"
    (pad "Small-step" max_len)
    (pad "Big-step" max_len)
    (pad "Standard" max_len);
  Printf.printf "%s\n" (String.make (max_len * 3 + 10) '-');

  let max_lines = List.length standard_output in
  let rec print_lines i =
    if i < max_lines then
      let s = List.nth_opt res_small i |> Option.value ~default:"<none>" in
      let b = List.nth_opt res_big i |> Option.value ~default:"<none>" in
      let std = List.nth_opt standard_output i |> Option.value ~default:"<none>" in

      let s_colored = if s = std then green (pad s max_len) else red (pad s max_len) in
      let b_colored = if b = std then green (pad b max_len) else red (pad b max_len) in
      let std_display = pad std max_len in

      Printf.printf "| %s | %s | %s |\n" s_colored b_colored std_display;
      print_lines (i + 1)
  in
  print_lines 0;
  Printf.printf "%s\n" (String.make (max_len * 3 + 10) '-')