import subprocess
import os

# Set the working directory to ModelSim's directory
modelsim_dir = 'path/to/your/modelsim'
os.chdir(modelsim_dir)

# Optionally, set MODELSIM environment variable
os.environ['MODELSIM'] = modelsim_dir

# Define the absolute paths
design_file = "path/to/your/design.v"
testbench_file = "path/to/your/tb.v"
compile_report_file = "path/to/your/compile_report.txt"
simulation_report_file = "path/to/your/simulation_report.txt"

# ModelSim compile command with absolute paths
compile_command = f"vlog {design_file} {testbench_file}"

# Run the compile command and write output to compile report
with open(compile_report_file, "w") as report_file:
    subprocess.run(compile_command, shell=True, stdout=report_file, stderr=subprocess.STDOUT)

# ModelSim simulation command
simulate_command = "vsim -c -do \"run -all\" tb"

# Run the simulation command and write output to simulation report
with open(simulation_report_file, "w") as report_file:
    subprocess.run(simulate_command, shell=True, stdout=report_file, stderr=subprocess.STDOUT)

# Add additional commands or modifications as needed
