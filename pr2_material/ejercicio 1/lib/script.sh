#!/bin/bash
echo "Iniciando ejercicio 1..."
echo ""

#VARIABLES
res_dat=./data/res.dat
total_dat=./data/total.dat
res_png=./images/res.png
total_png=./images/total.png
slow_script=./lib/slow
fast_script=./lib/fast
iteraciones=2
Ninicio=12048
Npaso=256
Nfinal=18192
#18192
#test => 13584

#Borramos archivos
rm $res_dat
rm $total_dat
rm $res_png
rm $total_png
echo ""

for((j=0; j<=$iteraciones ; j++))
do
	echo "Iteracion numero: $j"
	echo ""
	iteracion=0

	for((i=$Ninicio;i<=$Nfinal;i=i+$Npaso))
	do
		 echo "Tamaño matriz: $i"
		 #Slow
		 slowres=$($slow_script $i | grep 'time' | awk '{print $3}')
		 echo "Slow Time: "+$slowres
		 slow_time=$(python -c "print $slow_time + $slowres")
		 echo "Total Slow Time: "+$slow_time
		 #Fast
		 fastres=$($fast_script $i | grep 'time' | awk '{print $3}')
		 echo "Fast Time: "+$fastres
		 fast_time=$(python -c "print $fast_time + $fastres")
		 echo "Total Fast Time: "+$fast_time

		 echo "$i	  $slowres	$fastres" >> $res_dat
		 echo ""
		 iteracion=$((1+$iteracion))
	done
	echo ""
	slow_average=$(python -c "print $slow_time/($iteracion-1)")
	fast_average=$(python -c "print $fast_time/($iteracion-1)")
	echo "$j	  $slow_average	$fast_average" >> $total_dat
done
gnuplot -e "set terminal pngcairo; set output '$res_png'; set xlabel 'Tamaño de matriz'; set ylabel 'Tiempo'; plot '$res_dat' u 1:2 title 'Slow' with linespoints, '' u 1:3 title 'Fast with linespoints'"
gnuplot -e "set terminal pngcairo; set output '$total_png'; set xlabel 'Iteracion'; set ylabel 'Media temporal'; plot '$total_dat' u 1:2 title 'Media Slow', '' u 1:3 title 'Media Fast'"

echo "FIN!"
