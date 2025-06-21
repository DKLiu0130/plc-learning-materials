type player = O | X
let connect (board: string list) : player option = 
  let get_matrix (board: string list):char array array =
    let n = List.length board in
    (* 下标从 0 开始 *)
    let m  = (String.length (List.nth board 0)) / 2 + 1 in
    Array.init_matrix n m (fun x y -> String.get (List.nth board x) (x + y * 2))
  in
  let matrix = get_matrix board in
  let n = Array.length (matrix) in
  let m = Array.length (Array.get matrix 0) in
  let dir = [(-1,0);(-1,1);(0,-1);(0,1);(1,-1);(1,0)] in
  let vis = Array.make_matrix n m 0 in
  let check_win (player:player) (pos:(int*int)) = match player, pos with
  | O, (x, _) -> x = n - 1
  | X, (_, y) -> y = m - 1
  in
  let check_valid (player:player) (pos:(int*int)) = match pos with
  | (x, y) -> x >= 0 && y >= 0 && x < n && y < m && (vis.(x).(y) = 0) && (matrix.(x).(y) = (match player with
  | O -> 'O' | X -> 'X' ))
  in
  let rec dfs (player:player) (cur:(int*int)):bool =
    if check_win player cur then true else begin
      (* 往所有方向 dfs *)
      let success = ref(false) in
      let (x, y) = cur in
      vis.(x).(y) <- 1; 
      for i = 0 to ((List.length dir) - 1) do
        let (dx, dy) = List.nth dir i in
        let nx, ny = x + dx, y + dy in
        if check_valid player (nx, ny) then
          vis.(nx).(ny) <- 1;
          if dfs player (nx, ny) then success := true;
          vis.(nx).(ny) <- 0;
      done;
      !success
    end in
    (* O 和 X 分别 dfs *)
    let win_o = ref(false) in
      for i = 0 to m-1 do
        vis.(0).(i) <- 1;
        if dfs O (0, i) then win_o := true;
        vis.(0).(i) <- 0;
      done;
    let win_x = ref(false) in
      for i = 0 to n-1 do
        vis.(i).(0) <- 1;
        if dfs X (i, 0) then win_x := true;
        vis.(i).(0) <- 0;
      done;
    match !win_o, !win_x with
    | false, false -> None
    | true, false -> Some O
    | false, true -> Some X
    | true, true -> failwith "X O all won!"



(* 
      let board = [
        ". O . .";
        " O X X X";
        "  O O O .";
        "   X X O X";
        "    . O X .";
      ]
*)
