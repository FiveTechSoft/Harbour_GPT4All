#include "hbclass.ch"
#include "FileIO.ch"

function Main()

   local dummy := QOut( "GPT4All running..." + CPUSpeed() )
   local oAI := GPT4All():New()

   oAI:Read()
   ?? "Tell me a zen advise"
   oAI:Write( "Tell me a zen advise" )
   ?
   oAI:Read()
   ?? "what is love ?" 
   oAI:Write( "what is love ?" )
   ? 
   oAI:Read()

   oAI:End()

return nil  

#define BUFFER_SIZE  1024
#define LOGFILE_NAME "GPT4All.log"

CLASS GPT4All

   DATA   hProcess
   DATA   hStdIn, hStdOut, hStdErr

   METHOD New()
   METHOD Write( cText ) INLINE ::Log( "write: " + cText ), FWrite( ::hStdIn, cText + hb_eol() )
   METHOD Read()
   METHOD End()
   METHOD Log( cMsg )

ENDCLASS  

METHOD New( cPrompt ) CLASS GPT4All

   local hStdIn, hStdOut

   ::hProcess = hb_processOpen( "gpt4all-lora-quantized-win64.exe", @hStdIn, @hStdOut, @::hStdErr )

   ::hStdIn = hStdIn
   ::hStdOut = hStdOut

   FErase( LOGFILE_NAME )
   ::Log( "process: " + AllTrim( Str( ::hProcess ) ) )
   ::Log( "stdin: " + AllTrim( Str( ::hStdIn ) ) )
   ::Log( "stdout: " + AllTrim( Str( ::hStdOut ) ) )

return Self

METHOD Read() CLASS GPT4All

   local nReaded := 0, cBuffer, cResult, nTries, lExit := .F.

   cBuffer = "x"

   while ! lExit
      if ! Empty( cBuffer )
         cBuffer = Space( BUFFER_SIZE )
         if nReaded > 0 .and. ( nReaded := hb_PRead( ::hStdOut, @cBuffer, BUFFER_SIZE, 1000 ) ) == 0
            lExit = .T.
            exit 
         endif

         if nReaded == 0
            nTries = 0
            while ( nReaded += hb_PRead( ::hStdOut, @cBuffer, BUFFER_SIZE, 1000 ) ) == 0
               if ++nTries > 5
                  exit
               endif
            end
         endif
      endif

      if nReaded > 0 
         ?? RemoveANSIEscapeCodes( SubStr( cBuffer, 1, nReaded ) )
         ::Log( SubStr( cBuffer, 1, nReaded ) )
      endif   
   end  

   ::Log( "after read" )
   dbWin( "after read" )

return

METHOD End() CLASS GPT4All

   local nResult := hb_processClose( ::hProcess )

   FClose( ::hStdIn )
   FClose( ::hStdOut )
   FClose( ::hStdErr )

   ::Log( "End" )

return nResult  

METHOD Log( cMsg ) CLASS GPT4All

   local hLogFile

   if ! File( LOGFILE_NAME )
      FClose( FCreate( LOGFILE_NAME ) )
   endif      

   if( ( hLogFile := FOpen( LOGFILE_NAME, FO_WRITE ) ) != -1 )
      FSeek( hLogFile, 0, FS_END )
      FWrite( hLogFile, cMsg + hb_eol(), Len( cMsg ) + Len( hb_eol() ) )
      FClose( hLogFile )
   endif

return nil  

function RemoveANSIEscapeCodes( cString )

   local cCleanString := "", n, nLen := Len( cString )

   for n := 1 TO nLen
      cChar := SubStr( cString, n, 1 )
      if cChar == Chr( 27 )
         while cChar != "m"
            n++
            cChar = SubStr( cString, n, 1 )
         end      
         cChar = ""
      endif  

      cCleanString := cCleanString + cChar
   next

return cCleanString

function dbwin( u )
retu WAPI_OutputDebugString( chr(10) + chr(13) + u )

function CPUSpeed()

return Str( win_regRead( "HKLM\HARDWARE\DESCRIPTION\System\CentralProcessor\0\~MHz" ) )

