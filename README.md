# aot-rm-scripting

AoT random map scripting.

## Development workflow

1. edit `script.xs` and `label.xml` under `src/`
3. _build_ files and emit results to map script directory (*)
   
   give absolute path to map script directory as parameter

   example in my [WSL](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux) setup:

       bash cpToMyGames.sh /mnt/c/Users/alhoj/Documents/'My Games'/'Age of Mythology'/RM2

(*) _Building_ here means substituting some placeholder values.
