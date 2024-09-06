# Projektna naloga
## Mealyev avtomat
V teoriji računanja je Mealyev avtomat determinističen avtomat s končnim stanjem, katerega donos je odvisen od trenutnega stanja in trenutnega vnosa.

## Formalna definicija

Mealyev stroj je šesterica $(S, S_0 , \Sigma, \Lambda, T, G)$, sestavljena iz:

- končne množice stanj $S$,
- začetnega stanja $S_0$, ki je element množice $S$,
- končna množica vhodnih znakov $\Sigma$ (vhodna abeceda),
- končna množica izhodnih znakov $\Lambda$ (izhodna abeceda),
- prehodnih funkcij $T : S \times \Sigma \rightarrow S$, ki silka par stanja in vnosa v naslednjo stanje,
- izhodnih funkcij $G : S \times \Sigma \rightarrow \Lambda$, ki slika par stanja in vnosa v izhodni znak.

## Razlike od Mooreovega avtomata
- Mealyev avtomat ima načeloma manj stanj,
- Mealyev avtomat je bolj varen in se odzove hitreje na vnos, ko ga implementiramo v električno vezje.

## Projekt
Moja implementacija Mealyevega avtomata v nalogi je izhajala iz ideje, kako poiskati telefonsko številko v decimalkah pi-ja.
To idejo sem še malo razširil, saj ujemanje 9-mestnega števila v manj kot 10000 decimalkah pi-ja skoraj nima smisla,
verjetnost je namreč premajhna. Avtomat pa bi takrat vrnil 10000 znakov. Zato sem to idejo nadomestil z iskanjem poljubne (krajše) dolžine vzorca (števila),
nato pa še dodal druge konstante in iskanje v poljubnem številu. 

Primer: *Iskanje števila 26 v 3141592653589793238462643 (pi spremenjen v naravno število),
in avtomat vrne
-------X--------------X--, kjer je X mesto, kjer se ujemanje konča.*

Primer: *Iskanje 252 v 2525265 (poljubno število) naj tukaj avtomat vrne*  --X-X-- ali --X----?
*Izkaže se, da je bolj smiselen odgovor drugi. Tukaj sem si pomagal s KMP algoritmom, ki je algoritem za delno ujemnaje in prvo možnost izloči.
Več o KMP algoritmu najdete v virih.*

Končni izdelek torej sprejme 2 vnosa: 
- nek vzorec (niz števk),
- število, v katerem želimo vzorec poiskati (pi, e, phi ali poljubno napisano število).

## Navodila za uporabo
Program se zažene z ukazom _Task : Run Task -> Ocaml_ v programu VSCode
ali prek spleta na povezavi https://www.tutorialspoint.com/compile_ocaml_online.php, 
kamor skopirate celotno vsebino datoteke avtomat.ml.

### Tekstovni vmesnik
S programom komunicirate preko preprostega tekstovnega vmesnika, le-ta pa vam bo dal navodila za uporabo.

## Viri

-  https://en.wikipedia.org/wiki/Mealy_machine
-  https://en.wikipedia.org/wiki/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm
-  https://github.com/matijapretnar/programiranje-1

