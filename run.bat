@echo off
cls

set automate_workflow=%USERPROFILE%\Documents\Work\automate-workflow.tcl
set job_file="job.txt"

echo Running %automate_workflow%
tclsh "%automate_workflow%"
pause

set /p file_path=<"%job_file%"
echo Starting %file_path%
start "%file_path%"
del /p "%job_file%"

exit /b
