fullfolder=$(basename `pwd`)
current=$(echo $fullfolder | awk '{ print substr( $0, 1 ) }' )
seed=$((1000 + RANDOM % 9999))
echo $current
cat mutations.txt
$SCHRODINGER/fep_plus -HOST localhost -SUBHOST fgpu -ppj 8 -JOBNAME $current *.mae -protein mutations.txt -solvent_asl "chain.name E" -time 100000 -seed $seed -skip-leg solvent -prepare >launch.sh

sed -i 's/Launch command: //g' launch.sh

for i in *_*.msj ; do
#        sed -i '/  backend/a\ \ \ \ \ integrator.Multigrator.thermostat.Langevin.tau=8.334\n     integrator.Multigrator.thermostat.type=Langevin' $i
#        sed -i 's/time = 500.0/time = 240/g' $i
#        sed -i 's/asl: atom.i_rest_complex_hotregion 1/asl: res.num 32 and chain H/g' $i
#        sed -i 's/asl: atom.i_rest_solvent_hotregion 1/asl: res.num 32 and chain H/g' $i
#        sed -i '/print_expected_memory = true/a\ \ should_skip=true' $i
        sed -i 's/asl: atom.i_rest_complex_hotregion 1/asl: atom.i_rest_complex_hotregion 1 or (chain.name E and res.num 501) or (chain.name A and res.num 41) or (chain.name A and res.num 38) or (chain.name A and res.num 353)/g' $i
#        sed -i 's/asl: atom.i_rest_solvent_hotregion 1/asl: chain.name A,E and (fillres within 3 (chain.name E and res.num 498 and not atom. C,CA,N,O,HA,H)) and not res.num 498 and not atom. C,CA,N,O,HA,H and not res. pro,gly/g' $i
sed -i '/  fep_type =/a \ \ bennett.sliding_time.window=1000\n    bennett.sliding_time.begin=100\n    bennett.sliding_time.dt=1000' $i
