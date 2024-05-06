# MEIC : Make Each Iteration Count.  <h3><p align="right">*Verilog auto debug with LLMs*</p></h3>

## Directory Overview
- ErrorSet: The dataset we use, which contains error codes.
- Framework: Contains the main program `main.py`, along with other necessary script files and configuration files.

## How to Use
- Install the ModelSim simulation tool.
- Install dependencies:
```bash
  pip install -r requirements.txt
```
- Modify the contents of ```Framework/api.ini``` to include your own OpenAI API key.
- Modify the contents of ```Framework/config.json```, paying attention to the configuration file paths.
- Run ```Framework/main.py```. The script will automatically generate an output folder, save logs, and count the output results.

