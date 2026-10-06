open Yojson.Basic.Util

let () =
  let input_file = "input.json" in
  let output_file = "output.csv" in

  let json = Yojson.Basic.from_file input_file in
  let items = json |> to_list in
  
  if items = [] then (
    print_endline "Ошибка: JSON пуст.";
    exit 1
  );

  let first_item = List.hd items |> to_assoc in
  let headers = List.map fst first_item in

  let oc = open_out output_file in
  output_string oc (String.concat "," headers ^ "\n");

  List.iter (fun item ->
    let assoc = item |> to_assoc in
    let values = List.map (fun key ->
      try 
        match List.assoc key assoc with
        | `String s -> s
        | `Int i -> string_of_int i
        | `Float f -> string_of_float f
        | `Bool b -> string_of_bool b
        | `Null -> ""
        | _ -> ""
      with Not_found -> ""
    ) headers in
    output_string oc (String.concat "," values ^ "\n")
  ) items;

  close_out oc;
  print_endline "Конвертация успешно завершена. Данные сохранены в output.csv"
(* ocamlfind ocamlopt -package yojson -linkpkg -o json_to_csv json_to_csv.ml
./json_to_csv *)