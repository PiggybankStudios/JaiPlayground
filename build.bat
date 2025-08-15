@echo off
REM By default blocks like IF and FOR in batch are treated as a single command and variable values are expended when the block is entered
REM Enabling "delayed expansion" allows us to use !variable! syntax inside blocks to get the value of variables on that line (and at each iteration in the case of loops)
setlocal enabledelayedexpansion

jai build.jai
