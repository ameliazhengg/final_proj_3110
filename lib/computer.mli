type board

type coord

(*let computer_ship_coords = ref []*)
val create_board : unit -> board

val get_board_element : board -> int -> int -> string 

val random_dir : unit -> int

(* [check_contains] is true if the coordinates of a potential ship are already*) 
val check_contains : int -> int -> int -> int list -> bool 

(* [valid_placement] is true if a ship with [start_coord] [dir] and [len] can be
   placed there otherwise false *)
let valid_placement start_cord dir len lst =
  match dir with
  | 0 ->
      if start_cord >= 91 then false
      else if (start_cord / 10) + len > 10 then false
      else check_contains start_cord dir len lst
  | 1 ->
      if start_cord <= 10 then false
      else if (start_cord / 10) - len < 0 then false
      else check_contains start_cord dir len lst
  | 2 ->
      if start_cord mod 10 = 1 then false
      else if (start_cord mod 10) - len < 0 then false
      else check_contains start_cord dir len lst
  | 3 ->
      if start_cord mod 10 = 0 then false
      else if (start_cord mod 10) + len > 10 then false
      else check_contains start_cord dir len lst
  | _ -> false

(* [random_coord] is a random number between 1 and 100 inclusive representing
   the coordinate in a 10x10 grid *)
let random_coord _ =
  let coord = 1 + Random.int 100 in
  coord
(* Generate a random integer from 1 to 100 *)
(* if (not (List.mem coord !occupied_coords_lst)) && List.length
   !occupied_coords = 0 then begin occupied_coords := !occupied_coords @ [ coord
   ]; coord end else if not (List.mem coord !occupied_coords_lst) then coord
   else begin random_coord occupied_coords_lst (* If the coord is already
   occupied, try again *) end *)

let rec add_ship_to_lst name start dir len lst =
  if len = 0 then add_computer_ship name (List.length lst) lst
  else begin
    occupied_coords := !occupied_coords @ [ start ];
    comp_ship_coords := !comp_ship_coords @ [ (name, start) ];
    (* if List.mem start !occupied_coords then () else *)
    let lst = lst @ [ (start / 10, start mod 10) ] in
    match dir with
    | 0 -> add_ship_to_lst name (start + 10) 0 (len - 1) lst
    | 1 -> add_ship_to_lst name (start - 10) 1 (len - 1) lst
    | 2 -> add_ship_to_lst name (start - 1) 2 (len - 1) lst
    | 3 -> add_ship_to_lst name (start + 1) 3 (len - 1) lst
    | _ -> ()
  end

let rec new_ship_coord start dir len name =
  if len = 6 then new_ship_coord start dir 3 31
  else if valid_placement start dir len !occupied_coords = true then
    add_ship_to_lst name start dir len []
  else
    let new_start = random_coord occupied_coords in
    new_ship_coord new_start (random_dir new_start) len name

let add_coords =
  for i = 2 to 6 do
    let new_rand = random_coord occupied_coords in
    new_ship_coord new_rand (random_dir new_rand) i i
  done

let rec row_col_to_string lst =
  match lst with
  | [] -> ""
  | h :: t ->
      string_of_int ((snd h - 1) / 10)
      ^ ", "
      ^ string_of_int ((snd h - 1) mod 10)
      ^ " | " ^ row_col_to_string t

let random_board board =
  add_coords;
  List.iter
    (fun (name, coord) ->
      let row = if coord = 100 then 9 else coord / 10 in
      let col = (coord - 1) mod 10 in
      let icon = match_ship name in
      board.(row).(col) <- icon)
    !comp_ship_coords;
  board

(* let random_board board = board *)
let get_comp_lst_size = List.length !comp_ship_coords

let rec com_lst_to_string lst =
  match lst with
  | [] -> ""
  | h :: t ->
      string_of_int (fst h)
      ^ ", "
      ^ string_of_int (snd h)
      ^ " | " ^ com_lst_to_string t

let rec occ_lst_to_string lst =
  match lst with
  | [] -> ""
  | h :: t -> string_of_int h ^ " | " ^ occ_lst_to_string t

let string_comp_ships = com_lst_to_string !comp_ship_coords
let string_occ_coord = occ_lst_to_string !occupied_coords
let string_row_col = row_col_to_string !comp_ship_coords

let rec make_occupied_coords coord_lst lst =
  match lst with
  | [] -> coord_lst
  | h :: t ->
      let row = (h / 10) + 1 in
      let col = if h / 10 = 10 then 9 else h mod 10 in
      let new_lst = (row, col) :: coord_lst in
      make_occupied_coords new_lst t

let get_occupied_coords _ = make_occupied_coords [] !occupied_coords

(* checks if the guessed (row, col) is occupied by a ship from the computer*)
let in_comp_shi_coords row col =
  if List.mem (((row - 1) * 10) + col) !occupied_coords then true else false

(* generates random guess *)
let generate_random_guess () =
  let random_row = Random.int (Array.length rows) in
  let random_col = Random.int (Array.length columns - 1) in
  (random_row, random_col)