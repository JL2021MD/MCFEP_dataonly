seed=$((1000 + RANDOM % 9999))
jobname=$1
fmp=/mnt/beegfs/home/friesner/jl6403/ManConfs/Abl/interclear/inter_to2F4J_dasRec/clearequi/inter_to2F4J_dasRec.fmp
if [ ! -f "restraint.tmpl" ]; then
        read -p "restraint.tmpl not found. Proceed anyway? y/n " user_input
        if [[ "$user_input" == "n" ]]; then
                echo "Exiting..."
                exit 1
        fi
fi

ff=$(ls custom*.opls)
if [ -f "$ff" ]; then
        ffstring="-OPLSDIR $ff"
        echo "Detected FF file, adding $ffstring to launch"
else
        echo "Did not detect FF file, not adding to launch"
fi

"${SCHRODINGER}/fep_plus" -HOST localhost -SUBHOST fgpu -ppj 4 -time 25000 -ensemble muVT -seed $seed -custom-charge-mode assign -lambda_windows 12 -core_hopping_lambda_windows 16 -charged_lambda_windows 24 $ffstring -JOBNAME $jobname $fmp -TMPLAUNCHDIR -prepare > launch.sh

sed -i 's/Launch command: //g' launch.sh
sed -i 's/-RETRIES 1/-RETRIES 0/g' launch.sh
#sed -i 's/neutralize_system = false/neutralize_system = true/g' *_*.msj

sed -i 's/asl: atom.i_rest_complex_hotregion 1/asl: atom.i_rest_complex_hotregion 1 or (res.num 249-255 and protein)/g' *_*.msj

sed -i '/  fep_type =/a \ \ bennett.sliding_time.window=1000\n    bennett.sliding_time.begin=100\n    bennett.sliding_time.dt=1000' *_*.msj
