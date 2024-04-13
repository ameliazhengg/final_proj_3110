type ship = {
  name : string;
  length : int;
  coordinates : (int * char) list;
  hits : int;
}

(* type of guesses*)
type guesses = (int * char) list

let coord_add coord lst = lst :: coord
let create_ship name length a = { name; length; coordinates = a; hits = 0 }

(**let output match_emoji = function | true -> "❌" | false -> "⚪️" **)
