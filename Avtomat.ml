let pi_digits = "31415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679
821480865132823066470938446095505822317253594081284811174502841027019385211055596446229489549303819"

let e_digits = "271828182845904523536028747135266249775724709369995957496696762772407663035354759457138217852516642742
746639193200305992181741359662904357290033429526059563073813232862794349076323382988075319525101901"

let golden_ratio_digits = "161803398874989484820458683436563811772030917980576286213544862270526046281890
244970720720418939113748475408807538689175212663386222353693179318006076672635
443338908659593958290563832266131992829026"

type state = {
  indeks : int;  (*Indeks, ki nam bo pomagal pri delnem ujemanju s KMP listom*)
  st_ponovitev :  int;  (*Število pojavitev vzorca*)
  vrnjen_trak : string;  (*Trak sestavljen iz "_" in "X", ki ga vrne Mealyev stroj*)
}

let initial_state = {
  indeks = 0;
  st_ponovitev = 0;
  vrnjen_trak = "";
}

(*Funkcija, ki ustvari KMP list*)
let ustvari_KMP_list niz =
  let dolzina = String.length niz in  (*Shranimo dolžino niza.*)
  let kmp_list = Array.make dolzina 0 in  (*Ustvarimo array, ki je dolg toliko, kot niz, in zaenkrat vsebuje same ničle.*)
  let j = ref 0 in  (*Ustvarimo spremenljivko, jo bomo spreminjali.*)
  for i = 1 to dolzina - 1 do  (*Zanka for teče od 1 do dolzina - 1.*)
    while !j > 0 && niz.[!j] <> niz.[i] do
      j := kmp_list.(!j - 1)  (*Kadar je število j>0 in se hkrati števili na j-tem in i-tem mestu v nizu NE ujemata, spreminjamo j.*)
    done;
    if niz.[!j] = niz.[i] then
      incr j;  (*Kadar se ujemata, pa povečamo j za 1.*)
    kmp_list.(i) <- !j  (*Na i-to mesto v array-ju postavimo j.*)
  done;
  kmp_list


(*Funkcija za nek niz in konstante vrne trak in število ponovitev.*)
let process_text niz dolga_stevilka_ali_konstanta =
  let kmp_table = ustvari_KMP_list niz in (*Ustvari se KMP list.*)
  let dolzina = String.length niz in (*Shranimo dolžino niza.*)

  let obnovi state stevka = (*Funkcija, ki obnavlja stanje, ko preverimo vsako števko v konstanti.*)
    let rec poisci_indeks indeks = 
      if indeks > 0 && niz.[indeks] <> stevka then poisci_indeks (kmp_table.(indeks - 1)) else indeks 
    in
    let indeks = poisci_indeks state.indeks in (*Indeks je odvisen od prejšnega stanja. Če je večji od 0 in se trenutna števka in vzorec v indeksu ne ujemata, 
    funkcija pokliče sebe na vrednosti KMP lista prejšnjega indeksa.*)
    let novi_indeks = if indeks < dolzina && niz.[indeks] = stevka then indeks + 1 else indeks in (*Če je dolzina vzorca daljša od indeksa in se niz v indeksu ujema s števko, ga povečamo za 1, drugče ohranimo.*)
    let ujemanje = novi_indeks = dolzina in (*Logična vrednost, ki je True, če se novi indeks enak dolzini vzorca.*)

    { 
      indeks = if ujemanje then 0 else novi_indeks;
      vrnjen_trak = state.vrnjen_trak ^ (if ujemanje then "X" else "_");
      st_ponovitev = state.st_ponovitev + if ujemanje then 1 else 0;
    } (*Posodobimo stanje - če se pojavi ujemanje, indeks nastavimo na 0, na trak dodamo "X" in ponovitev povečamo za 1, drugače indeksa ne spreminjamo in na trak dodamo "_".*)
  in

  String.fold_left obnovi initial_state  dolga_stevilka_ali_konstanta (*Funkcijo obnovi zaženemo na začetno stanje, ter čez celo konstanto.*)
  |> fun final_state -> final_state.vrnjen_trak, final_state.st_ponovitev 
    
(*Definirmo nestalno (mutable) sklicevanje na prazen list.*)
let seznam = ref []  (*Tip bo (string * string * int) list ref.*)

(* Funkcija, ki doda rezultat v zgodovino.*)
let dodaj_na_seznam (str1, str2, n) =
  seznam := (str1, str2, n) :: !seznam

(*Funkcija, ki izpiše dosedanjo zgodovino.*)
let print_seznam () =
  List.iter (fun (str1, str2, n) ->
    Printf.printf "(%s, %s, %d)\n" str1 str2 n
  ) !seznam

(*Funkcija, ki vrne par glede na dani vnos.*)
let vrni_const_str x = match x with
|1 -> ("pi", pi_digits)
|2 -> ("e", e_digits)
|3 -> ("phi", golden_ratio_digits)
|_ -> (string_of_int x, string_of_int x)

(*Funkcija sprejme trak, ki ga vrne stroj in v niz izpiše indekse pojavitve X*)
let indeksi_ujemanja binarni_niz =
  let len = String.length binarni_niz in
  let rec aux i acc =
    if i >= len then
      String.concat ", " (List.rev acc)  (*Funkcija, najprej obrne list na glavo in nato druži elemente ter med njih postavi ",".*)
    else
      if binarni_niz.[i] = 'X' then
        aux (i + 1) (string_of_int (i+1):: acc)
      else
        aux (i + 1) acc  (*Če se na i-tem mestu pojavi "X",v akumulator shranimo i.*)
  in
  aux 0 []

  (*Funkcija preveri, če je vnos število*)
let rec read_int_from_user prompt =
  print_endline prompt;
  let input = read_line () in
   try int_of_string input  (*Če se tukaj zatakne, nam sporoči, da je bil vnos napačen.*)
  with Failure _ ->
    print_endline "Vnos mora biti naravno število (npr. 12345). ";
    read_int_from_user prompt 
  
let konzola stevilka zaporedje =
  let str_zaporedje = string_of_int zaporedje in  
  let (deci_cifra, deci_str) = vrni_const_str stevilka in
  let (rez, stevilo) = process_text str_zaporedje deci_str in
  let() = dodaj_na_seznam("  "^deci_cifra ^ " ", " "^str_zaporedje^" ", stevilo) in
  print_endline "+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n";
  print_endline ("Mealyev avtomat vrne: \n" ^ rez);
  if not (stevilo = 0) then
    begin
      Printf.printf "Ideksi ponovitve: %s\n" (indeksi_ujemanja rez)
    end
  else 
    print_endline "Smola, vaš zaporedje števk se ne pojavi nikjer.\n"
      
let () =
  let rec vprasaj () =
    print_endline "Seznam prejšnih rezultatov\n(const., števke, št. ponovitev)";
    print_seznam ();
    let zaporedje_stevk = read_int_from_user "Vnesite svojo najljubšo zaporedje števk (telefonsko številko brez presledkov, srečno število,... ) in zaradi zanimivosti naj ne presega 9 mest" in
    let dolga_stevilka_ali_konstanta = read_int_from_user "Da preverite, ali se vaša številka pojavi v (1)pi-ju, (2)e-ju, (3)phi-ju, vpišite številko v oklepaju pred konstanto, za poljubno število pa ga v celoti izpišite sem:" in
    konzola dolga_stevilka_ali_konstanta zaporedje_stevk;  (*Funkcija, ki vzame 2 vnosa, ter pokliče funkcijo konzola, vnosa vstavi v Mealyev stroj oz. se ponavlja, dokler vnosa nista števili.*)
  
  let rec ponovno_previrjanje ()=
    print_endline "Želite preveriti še kako zaporedje števk? (da/ne)";
    let response = read_line () in
    match String.lowercase_ascii response with
    | "da" -> vprasaj ()  (*Postopek se ponovi.*)
    | "ne" -> print_endline "Lep dan in nasvidenje!"  (*Program se ugasne.*)
    | _ -> 
      print_endline "Odgovorite z Da ali Ne";
      ponovno_previrjanje ()  (*Funkcija, ki se izvede po koncu Mealyevega procesa, uporabnika vpraša, če želi iskanje ponoviti ali zaključiti program.*)
    in 
    ponovno_previrjanje ()
  in
  vprasaj ()
