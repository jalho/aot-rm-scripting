# aot-rm-scripting

AoT random map scripting.

## Development workflow

1. edit `script.xs` and `label.xml` under `maps/map-name/src/`
3. _build_<sup>[*](#buildfootnote)</sup> files and emit results to map scripts directory
   
       bash buildMap.sh [map src dir] [absolute path to map scripts dir]

   example in my [WSL](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux) setup:

       bash buildMap.sh big-ass-savannah /mnt/c/Users/alhoj/Documents/'My Games'/'Age of Mythology'/RM2

    <a name="buildfootnote">*</a> _Building_ here means substituting some placeholder values.
