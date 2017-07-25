@echo off
setlocal enabledelayedexpansion enableextensions

%~d0
cd %~dp0
goto :Make


:InitVars
	set AmxxPC=%~1
	set ProjectDir=%~2
	set IntDir=%~3
	set OutDir=%~4
	set Configuration=%~5
	if /i "%Configuration%"=="Debug" ( 
		set AmxxPCFlags=-d3
	) else (
		set AmxxPCFlags=-d0
	)
	exit /B 0

:Clearup
    rem call :CleanInt
	IF  EXIST "%OutDir%" (rd /S /Q "%OutDir%")
	exit /B 0

:MakeDirs
	echo "MakeDirs"
	IF NOT EXIST "%OutDir%" (mkdir "%OutDir%")
	IF NOT EXIST "%IntDir%" (mkdir "%IntDir%")
	exit /B 0


:ListSmaFiles
	echo ListSmaFiles
	set SmaFiles=
	FOR %%I in (%ProjectDir%\*.sma) DO  (
		set SmaFiles=!SmaFiles!%%~fI;
	)
	exit /B 0
	
:Compile
	call :ListSmaFiles
	echo SmaFiles=%SmaFiles%
	:GetAnotherSmaFile
	FOR  /F "tokens=1* delims=;" %%i in ("%SmaFiles%") DO (	
		
		FOR /F %%j IN ("%OutDir%\%%~ni.amxx") DO set OutFile=%%~fj
		echo Compiling:"%%~fi" CurDir="%cd%"
	    %AmxxPC% !AmxxPCFlags!  "%%~fi" -o"!OutFile!" 
		
		if !ERRORLEVEL! NEQ 0 ( 
			set /A bError=1
			echo FAILED: "%%~fi"
		) else (
			rem echo OK
		)
		if "%%j" NEQ "" ( 
			set SmaFiles=%%j
			goto :GetAnotherSmaFile
		)
	)
	popd
	if !bError! NEQ 0 (
		echo Compilation failed
		pause
		exit 1
	)
	exit /b 0


:Make
call :InitVars %*
if %errorlevel% == 1 (
     echo Something wrong
     pause
     exit 1
 )
	 call :MakeDirs  
     call :Compile
     exit /b %bError%
)
