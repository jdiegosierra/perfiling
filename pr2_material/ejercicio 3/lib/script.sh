#!/bin/bash
echo "Iniciando Script 3..."
echo ""

#VARIABLES
multiply_script=./lib/program
multiply_tr_script=./lib/program_t
Cache_inicio=1024
Cache_final=4096
Ninicio=512
Nfinal=528
# 768
# test => 528
Npaso=16

for((s=$Cache_inicio;s<=$Cache_final;s=s*2))
do
  fail_data="./data/multiply_misses_matrix_$s.dat"
  f_output=./data/matrix_$s.dat
  rm $f_output
  rm $fail_data
  echo ""
  echo "Tamaño Cache L1: $s" >&2

  for N in $(seq $Ninicio $Npaso $Nfinal)
	do
    echo "Tamaño Matriz: $N" >&2
    #Tiempos
    time_multiply=$($multiply_script $N | grep 'time' | awk '{print $3}')
    time_multiply_tr=$($multiply_tr_script $N | grep 'time' | awk '{print $3}')
    #Multiplicacion normal
    valgrind --tool=cachegrind --I1=$s,1,64 --D1=$s,1,64 --LL=$((8*1024*1024)),1,64 --cachegrind-out-file=$fail_data $multiply_script $N > /dev/null 2>&1
    slowd1mr=$(cg_annotate $fail_data | grep PROGRAM | awk '{print $5}' | sed 's/,//g')
		slowd1mw=$(cg_annotate $fail_data | grep PROGRAM | awk '{print $8}' | sed 's/,//g')
    #Multiplicacion traspuesta
    valgrind --tool=cachegrind --I1=$s,1,64 --D1=$s,1,64 --LL=$((8*1024*1024)),1,64 --cachegrind-out-file=$fail_data $multiply_tr_script $N > /dev/null 2>&1
    fastd1mr=$(cg_annotate $fail_data | grep PROGRAM | awk '{print $5}' | sed 's/,//g')
    fastd1mw=$(cg_annotate $fail_data | grep PROGRAM | awk '{print $8}' | sed 's/,//g')

    echo "$N    $time_multiply    $slowd1mr   $slowd1mw   $time_multiply_tr		$fastd1mr		$fastd1mw" >> $f_output
    done
    gnuplot -e "set terminal pngcairo; set xlabel 'Tamaño de matriz'; set ylabel 'Fallos de caché'; set output './images/fallos_$s.png'; plot './data/matrix_$s.dat' u 1:3 title 'Lectura Normal' with linespoints, u 1:4 title 'Escritura Normal', u 1:6 title 'Lectura Traspuesta', u 1:7 title 'Escritura Traspuesta' with linespoints"
    gnuplot -e "set terminal pngcairo; set xlabel 'Tamaño de matriz'; set ylabel 'Tiempo de ejecución'; set output './images/tiempo_ejecucion_$s.png'; plot './data/matrix_$s.dat' u 1:2 title 'Multiplicación Normal' with linespoints, '' u 1:5 title 'Multiplicacion traspuesta' with linespoints"
done

echo "FIN!"
