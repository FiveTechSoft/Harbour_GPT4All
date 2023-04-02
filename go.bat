@setlocal
@call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64
c:\harbour\bin\win\msvc64\hbmk2 gpt4all.prg -comp=msvc64 -lhbwin.hbc
gpt4all.exe
@endlocal
