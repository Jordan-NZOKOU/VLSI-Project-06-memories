# QuestaSim/ModelSim batch script.
# Run from the project directory with: vsim -c -do run_questa.do

transcript on
onerror {quit -code 1 -force}
onbreak {quit -code 1 -force}

# Resolve all relative paths from the script location.
set SCRIPT_DIR [file dirname [file normalize [info script]]]
cd $SCRIPT_DIR

if {[file exists work]} {
    vdel -lib work -all
}
vlib work
vmap work work

vlog -sv -work work Instruction_Memory.v
vlog -sv -work work Data_Memory.v
vlog -sv -work work Memories_tb.v

vsim -voptargs=+acc work.Memories_tb

# Populate the Wave window when the script is launched from the GUI.
add wave -r /*

# Export a VCD that can be opened with GTKWave.
vcd file memories.vcd
vcd add -r /Memories_tb/*

run -all
vcd flush
vcd off
quit -code 0 -force
