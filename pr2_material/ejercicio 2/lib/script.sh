#!/bin/bash
echo "Iniciando Script 2..."
echo ""

#VARIABLES
slow_script=./lib/slow
fast_script=./lib/fast
Cache_superior=8000000
Cache_inicio=1024
Cache_final=4096
Ninicio=4048
Npaso=256
Nfinal=4816
# 10192
# Test => 4816

for((s=$Cache_inicio;s<=$Cache_final;s=s*2))
do
  echo "Tamaño Cache L1: $s" >&2
  echo ""
  fail_data="./data/misses_size_$s.dat"
  f_output=./data/cache_$s.dat
  rm $f_output
  rm $fail_data
  echo ""

  for N in $(seq $Ninicio $Npaso $Nfinal)
	do
    echo "Tamaño matriz: $N"
    #Slow
  	valgrind --tool=cachegrind --I1=$s,1,64 --D1=$s,1,64 --LL=$((8*1024*1024)),1,64 --cachegrind-out-file=$fail_data $slow_script $N > /dev/null 2>&1
    slowi1mr=$(cg_annotate $fail_data | grep PROGRAM | awk '{print $2}' | sed 's/,//g')
    slowd1mr=$(cg_annotate $fail_data | grep PROGRAM | awk '{print $5}' | sed 's/,//g')
		slowd1mw=$(cg_annotate $fail_data | grep PROGRAM | awk '{print $8}' | sed 's/,//g')
    #Fast
    valgrind --tool=cachegrind --I1=$s,1,64 --D1=$s,1,64 --LL=$((8*1024*1024)),1,64 --cachegrind-out-file=$fail_data $fast_script $N > /dev/null 2>&1
    fasti1mr=$(cg_annotate $fail_data | grep PROGRAM | awk '{print $2}' | sed 's/,//g')
    fastd1mr=$(cg_annotate $fail_data | grep PROGRAM | awk '{print $5}' | sed 's/,//g')
    fastd1mw=$(cg_annotate $fail_data | grep PROGRAM | awk '{print $8}' | sed 's/,//g')

    echo "$N 		$slowd1mr		$slowd1mw		$fastd1mr		$fastd1mw" >> $f_output
  done
  gnuplot -e "set terminal pngcairo; set xlabel 'Fallos de lectura'; set ylabel 'Tamaño de memoria caché'; set output './images/fallos_lectura_$s.png'; plot './data/cache_$s.dat' u 1:2 title 'Slow' with linespoints, '' u 1:4 title 'Fast' with linespoints"
  gnuplot -e "set terminal pngcairo; set xlabel 'Fallos de escritura'; set ylabel 'Tamaño de memoria caché'; set output './images/fallos_escritura_$s.png'; plot './data/cache_$s.dat' u 1:3 title 'Slow' with linespoints, '' u 1:5 title 'Fast' with linespoints"
done

echo "FIN!"
