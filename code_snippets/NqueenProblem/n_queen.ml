let n_queen (n:int) : int list list = 
  let board = Array.make_matrix n n 0 in 
  let ans = ref [] in
  let diag1 = Array.init (2 * n) (fun _ -> 0) in
  let diag2 = Array.init (2 * n) (fun _ -> 0) in
  let check row col = 
    let ok = ref true in
      for i = 0 to col-1 do
        if board.(row).(i) = 1 then ok := false
      done; (* 注意语句间的分号 *)
      if diag1.(row+col) = 1 || diag2.(row-col+n) = 1 then ok := false;
      !ok 
  in
  let rec dfs (cur:int) (path:int list) = 
    if cur = n then
      ans := (List.rev path) :: !ans
    else
      for i = 0 to n - 1 do
        (* 使用 begin end 包裹过程块 *)
        if check i cur then begin
          board.(i).(cur) <- 1;
          diag1.(i+cur) <- 1;
          diag2.(i-cur+n) <- 1;
          dfs (cur + 1) ((i+1) :: path);
          board.(i).(cur) <- 0;
          diag1.(i+cur) <- 0;
          diag2.(i-cur+n) <- 0;
        end
      done
  in
  dfs 0 [];
  !ans
