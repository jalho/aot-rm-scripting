# aot-rm-scripting

AoT random map scripting.

## Development workflow

1. edit `script.xs` and `label.xml` under `src/`
3. _build_<sup>[*](#buildfootnote)</sup> files and emit results to map scripts directory
   
       bash cpToMyGames.sh [absolute path to map scripts dir] [map name]

   example in my [WSL](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux) setup:

       bash cpToMyGames.sh /mnt/c/Users/alhoj/Documents/'My Games'/'Age of Mythology'/RM2 'Big Ass Savannah'

    <a name="buildfootnote">*</a> _Building_ here means substituting some placeholder values.
