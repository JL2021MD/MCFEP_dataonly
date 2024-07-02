fullfolder=$(basename `pwd`)
current=$(echo $fullfolder | awk '{ print substr( $0, 1 ) }' )
seed=$((1000 + RANDOM % 9999))
infmp=$1
echo $current

"${SCHRODINGER}/fep_plus" -HOST localhost -SUBHOST fgpu -ppj 4 -ensemble muVT -seed $seed -time 25000 -custom-charge-mode clear -skip-leg vacuum -skip-leg solvent -lambda_windows 12 -core_hopping_lambda_windows 16 -charged_lambda_windows 24 -JOBNAME $current $infmp -TMPLAUNCHDIR -prepare >launch.sh


sed -i 's/Launch command: //g' launch.sh
sed -i 's/asl: atom.i_rest_complex_hotregion 1/asl: (res.num 111 and chain.name A)/g' *_*.msj

#sed -i "/  backend/a\ \ \ \ \ integrator.Multigrator.thermostat.Langevin.tau=8.334\n     integrator.Multigrator.thermostat.type=Langevin\n     $bondA \n     $bondB \n     $qA \n     $qB \n     $vdwA \n     $vdwB" *_*.msj
sed -i '/  fep_type = small_molecule/a \ \ bennett.sliding_time.window=1000\n    bennett.sliding_time.begin=100\n    bennett.sliding_time.dt=1000' *_*.msj

