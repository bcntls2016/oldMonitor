#!/bin/bash
GNUPLOT="gnuplot503"
DT="1*10^(-4)"
ITER="200"

TIMESTEP=$(echo "scale=6;$ITER*$DT"|bc)
for res in ../*res*
do
	awk '/Number of particles/{print$5}' $res | tail -n +3 > nparticles.${res##*.}.dat
	$GNUPLOT -e "INPUT='nparticles.${res##*.}.dat'; OUTPUT='nparticles.${res##*.}.eps'; \
		Observable='nparticles.obs'; TimeStep='${TIMESTEP}'" monitor.gnu
	awk '/Total Energy \(He\)/{print$4}' $res > total_energy_he.${res##*.}.dat
	$GNUPLOT -e "INPUT='total_energy_he.${res##*.}.dat'; \
		OUTPUT='total_energy_he.${res##*.}.eps'; Observable='total_energy_he.obs'; \
		TimeStep='${TIMESTEP}'" monitor.gnu
	awk '/Impurity energy \(X->He\)/{print$5}' $res > impurity_energy.${res##*.}.dat
	$GNUPLOT -e "INPUT='impurity_energy.${res##*.}.dat'; \
		OUTPUT='impurity_energy.${res##*.}.eps'; Observable='impurity_energy.obs'; \
		TimeStep='${TIMESTEP}'" monitor.gnu
	awk '/TOTAL energy \(He\+X\)/{print$5}' $res > total_energy.${res##*.}.dat
	$GNUPLOT -e "INPUT='total_energy.${res##*.}.dat'; \
		OUTPUT='total_energy.${res##*.}.eps'; Observable='total_energy.obs'; \
		TimeStep='${TIMESTEP}'" monitor.gnu
	awk '/Interaction energy \(X-He\)/{print$5}' $res > interaction_energy.${res##*.}.dat
	$GNUPLOT -e "INPUT='interaction_energy.${res##*.}.dat'; \
		OUTPUT='interaction_energy.${res##*.}.eps'; Observable='interaction_energy.obs'; \
		TimeStep='${TIMESTEP}'" monitor.gnu
	awk '/Kinetic energy \(X\)/{print$5}' $res > kinetic_energy.${res##*.}.dat
	$GNUPLOT -e "INPUT='kinetic_energy.${res##*.}.dat'; \
		OUTPUT='kinetic_energy.${res##*.}.eps'; Observable='kinetic_energy.obs'; \
		TimeStep='${TIMESTEP}'" monitor.gnu

	$GNUPLOT -e "INPUT='../rimp.out.${res##*.}'; OUTPUT='position.${res##*.}.eps'; \
		Observable='rimp.obs'; TimeStep='${TIMESTEP}'" monitor.gnu
	$GNUPLOT -e "INPUT='../vimp.out.${res##*.}'; OUTPUT='velocity.${res##*.}.eps'; \
		Observable='vimp.obs'; TimeStep='${TIMESTEP}'" monitor.gnu
	$GNUPLOT -e "INPUT='../aimp.out.${res##*.}'; OUTPUT='acceleration.${res##*.}.eps'; \
		Observable='aimp.obs'; TimeStep='${TIMESTEP}'" monitor.gnu

	$GNUPLOT -e "INPUT1='kinetic_energy.${res##*.}.dat'; \
		INPUT2='interaction_energy.${res##*.}.dat'; \
		INPUT3='impurity_energy.${res##*.}.dat'; \
		OUTPUT='energy_mix.${res##*.}.eps'; Observable='energy_mix.obs'; \
		TimeStep='${TIMESTEP}'" monitor.gnu
done