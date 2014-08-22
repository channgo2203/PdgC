module F = Frontc
module C = Cil
module E = Errormsg

module O = Ciltutoptions


let parseOneFile (fname: string) : C.file =
  let cabs, cil = F.parse_with_cabs fname () in
  Rmtmps.removeUnusedTemps cil;
  cil

let outputFile (f : C.file) : unit =
  if !O.outFile <> "" then
    try
      let c = open_out !O.outFile in

      C.print_CIL_Input := false;
      Stats.time "printCIL"
        (C.dumpFile (!C.printerForMaincil) c !O.outFile) f;
      close_out c
    with _ ->
      E.s (E.error "Couldn't open file %s" !O.outFile)
			
let processOneFile (cil: C.file) : unit =
  if !(O.enable_tut.(0)) then Tut0.tut0 cil;
  if !(O.enable_tut.(1)) then Tut1.tut1 cil;

  outputFile cil
;;

let main () =

  C.print_CIL_Input := true;


  C.insertImplicitCasts := false;


  C.lineLength := 100000;


  C.warnTruncate := false;


  E.colorFlag := true;


  Cabs2cil.doCollapseCallCast := true;

  let usageMsg = "Usage: PdgC [options] source-files" in
  Arg.parse (O.align ()) Ciloptions.recordFile usageMsg;

  Ciloptions.fileNames := List.rev !Ciloptions.fileNames;
  let files = List.map parseOneFile !Ciloptions.fileNames in
  let one =
    match files with
    | [] -> E.s (E.error "No file names provided")
    | [o] -> o
    | _ -> Mergecil.merge files "stdout"
  in

  processOneFile one
;;


begin
  try
    main ()
  with
  | F.CabsOnly -> ()
  | E.Error -> ()
end;
exit (if !E.hadErrors then 1 else 0)
