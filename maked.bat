@echo off
echo =============== [COMPILANDO] ===============
REM --- EJECUTABLE PRINCIPAL ---
REM Aca cada uno de los modulos a compilar
tasm /zi main
tasm /zi graphics
tasm /zi strings
tasm /zi random
tasm /zi sound
tasm /zi savefile

REM Aca compila todo junto en un EXE
tlink /v main graphics strings random sound savefile

REM --- INTERRUPCION RANDOM ---
REM Aca el .com de la interrupcion del random
tasm INT81RNG
tlink /t INT81RNG
INT81RNG ;De paso instala la funcion en memoria

REM Y aca borra los archivos de compilacion
del main.obj
del main.map
del graphics.obj
del strings.obj
del INT81RNG.obj
del INT81RNG.map
del random.obj
del sound.obj
del savefile.obj
echo ============================================

td main