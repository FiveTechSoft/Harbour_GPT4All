#include "hbclass.ch"
#include "FileIO.ch"

function Main()

   local dummy := QOut( "GPT4All running..." )
   local oAI := GPT4All():New()

   oAI:Read()
   ?? "Tell me a zen advise"
   oAI:Write( "Tell me a zen advise" )
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

   local nTotal := 0, nReaded := 1, cBuffer, cResult, nTries

   cBuffer = "x"

   while nReaded > 0
      cBuffer = Space( BUFFER_SIZE )
      nReaded = 0
      nTries = 0
      while ( nReaded += hb_PRead( ::hStdOut, @cBuffer, BUFFER_SIZE, 1000 ) ) == 0
         if ++nTries > 5
            exit
         endif  
      end

      ?? RemoveANSIEscapeCodes( SubStr( cBuffer, 1, nReaded ) )
      ::Log( SubStr( cBuffer, 1, nReaded ) )
   end  

   ::Log( "after read" )

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

   local cCleanString := "", n

   for n := 1 TO Len( cString )
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