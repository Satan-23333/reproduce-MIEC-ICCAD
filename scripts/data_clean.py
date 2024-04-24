import subprocess
import random
import os
from pathlib import Path
import re 
import argparse


bugType_probability_list = [  
    0.05,    #   ['/reg', '\\wire', 2],
    0.05,    #   ['/posedge\ clk', '\\nedge\ clk', 5], 
    0.05,    #   ['/+\ 1', '\\-\ 1', 2], 
    0.05,    #   ['/-\ 1', '\\-\ 2', 2], 
    0.05,    #   ['/always @(\* ', 'always @(posedge clk)', 5],
    0.05,    #   ['/<=', '= ', 2],
    0.05,    #   ['/ =', '<=', 5],
    0.05,    #   ['/&', '&&', 5],
    0.05,    #   ['/\|', '\|\|', 5],
    0.05,    #   ['/&&', '&', 5],
    0.05,    #   ['/\|\|', '\|', 5],
    0.05,    #   ['/&', '|', 5],
    0.05,    #   ['/|', '&', 5],
    0.05,    #   ['/==', '!=', 2],
    0.05,    #   ['/!=', '==', 2],
    0.05,    #   ['/\ >\ ', '\ <\ ', 2],
    0.05,    #   ['/\ <\ ', '\ >\ ', 2],
    0.025,    #   ['/data\(data\)', '\\data\(addr\)', 2],
    0.025,    #   ['/addr\(addr\)', '\\addr\(data\)', 2],
    0.05,    #   ['/input', '\\output', 2],
    0.05     #   ['/output', '\\input', 2],
] # bug_list 比例

parser = argparse.ArgumentParser(description="Bug Needle: Semi-automated bug needle tool")
parser.add_argument("-e", "--equal_probability", 
                        action="store_true",
                        help="the input file directory")
args = parser.parse_args()


# To be continued
