quit -sim 

#.main    clear

vlib    ./lib
vlib    ./lib/work

vmap     work ./lib/work

vlog    -work    work    ./design/*.v -l ./design/vcompile.txt

vsim    -voptargs=+acc    work.tb -l ./design/vsim.txt -wlf ./vsim.wlf
log /* -r

add    wave    -divider 	{tb}
add    wave    tb/*
add    wave    -divider 	{uut}
add    wave    tb/uut/*

run    80us