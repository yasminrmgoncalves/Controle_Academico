@echo off
CodeCoverage.exe ^
  -e ..\UnitTest1\Win32\Debug\TestProjectCMD.exe ^
  -m ..\UnitTest1\Win32\Debug\TestProjectCMD.map ^
  -dproj ..\AppControleAcademico.dproj ^
  -od CodeCoverage ^
  -emma ^
  -xml ^
  -html ^
  -xmllines ^
  -v
timeout /t -1