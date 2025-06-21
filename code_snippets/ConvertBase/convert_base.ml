let convert_bases from digits target =
  if from <= 1 || target <= 1 then None
  else if  List.exists (fun x -> x < 0 || x >= from) digits then None
  else
    let to_decimal digits =
      List.fold_left (fun acc d -> acc * from + d) 0 digits
    in
    let from_decimal n =
      let rec aux n acc =
        if n = 0 then acc
        else aux (n / target) ((n mod target) :: acc)
      in
      if n = 0 then [0] else aux n []
    in
    let dec = to_decimal digits in
    Some (from_decimal dec)
