#!/bin/bash
GNUPLOT="gnuplot"
EXT="eps"

DT="5*10^(-4)"
ITER="200"

TIMESTEP=$(echo "scale=6;$ITER*$DT"|bc)
for res in ../*res*
do
	awk '/Number of particles/{print$4}' $res | tail -n +3 > nparticles.${res##*.}.dat
	$GNUPLOT -e "INPUT='nparticles.${res##*.}.dat'; OUTPUT='nparticles.${res##*.}.${EXT}'; \
		Observable='nparticles.obs'; TimeStep='${TIMESTEP}'" monitor.gnu
	awk '/Total Energy \(He\)/{print$4}' $res > total_energy_he.${res##*.}.dat
	$GNUPLOT -e "INPUT='total_energy_he.${res##*.}.dat'; \
		OUTPUT='total_energy_he.${res##*.}.${EXT}'; Observable='total_energy_he.obs'; \
		TimeStep='${TIMESTEP}'" monitor.gnu
	awk '/Impurity energy \(X->He\)/{print$5}' $res > impurity_energy.${res##*.}.dat
	$GNUPLOT -e "INPUT='impurity_energy.${res##*.}.dat'; \
		OUTPUT='impurity_energy.${res##*.}.${EXT}'; Observable='impurity_energy.obs'; \
		TimeStep='${TIMESTEP}'" monitor.gnu
	awk '/TOTAL energy \(He\+X\)/{print$5}' $res > total_energy.${res##*.}.dat
	$GNUPLOT -e "INPUT='total_energy.${res##*.}.dat'; \
		OUTPUT='total_energy.${res##*.}.${EXT}'; Observable='total_energy.obs'; \
		TimeStep='${TIMESTEP}'" monitor.gnu
	awk '/Interaction energy \(X-He\)/{print$5}' $res > interaction_energy.${res##*.}.dat
	$GNUPLOT -e "INPUT='interaction_energy.${res##*.}.dat'; \
		OUTPUT='interaction_energy.${res##*.}.${EXT}'; Observable='interaction_energy.obs'; \
		TimeStep='${TIMESTEP}'" monitor.gnu
	awk '/Kinetic energy \(X\)/{print$5}' $res > kinetic_energy.${res##*.}.dat
	$GNUPLOT -e "INPUT='kinetic_energy.${res##*.}.dat'; \
		OUTPUT='kinetic_energy.${res##*.}.${EXT}'; Observable='kinetic_energy.obs'; \
		TimeStep='${TIMESTEP}'" monitor.gnu
		
	awk '/Center of Mass/{print$10}' $res | sed 's/)$//g' > zcm.${res##*.}.dat
	awk '/Impurity position/{print$5}' $res > zimp.${res##*.}.dat
	LENGTH=$(cat zcm.${res##*.}.dat | wc -l)
	MAX=$(echo "scale=6;$LENGTH*$TIMESTEP"|bc)
	seq $TIMESTEP $TIMESTEP $MAX > time.${res##*.}.dat
	paste time.${res##*.}.dat zimp.${res##*.}.dat zcm.${res##*.}.dat > time-positions.${res##*.}.dat
	rm time.${res##*.}.dat zimp.${res##*.}.dat zcm.${res##*.}.dat

	$GNUPLOT -e "INPUT='../rimp.out.${res##*.}'; OUTPUT='position.${res##*.}.${EXT}'; \
		Observable='rimp.obs'; TimeStep='${TIMESTEP}'" monitor.gnu
	$GNUPLOT -e "INPUT='../vimp.out.${res##*.}'; OUTPUT='velocity.${res##*.}.${EXT}'; \
		Observable='vimp.obs'; TimeStep='${TIMESTEP}'" monitor.gnu
	$GNUPLOT -e "INPUT='../aimp.out.${res##*.}'; OUTPUT='acceleration.${res##*.}.${EXT}'; \
		Observable='aimp.obs'; TimeStep='${TIMESTEP}'" monitor.gnu

	$GNUPLOT -e "INPUT1='kinetic_energy.${res##*.}.dat'; \
		INPUT2='interaction_energy.${res##*.}.dat'; \
		INPUT3='impurity_energy.${res##*.}.dat'; \
		OUTPUT='energy_mix.${res##*.}.${EXT}'; Observable='energy_mix.obs'; \
		TimeStep='${TIMESTEP}'" monitor.gnu
done
