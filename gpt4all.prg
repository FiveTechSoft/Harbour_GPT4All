#include "hbclass.ch"
#include "FileIO.ch"

function Main()

   local dummy := QOut( "Loading GPT4All... cpu speed: " + AllTrim( CPUSpeed() ),;
                        If( ! CpuHasAvx2(), "not", "" ) + " AVX2 support" )
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

	local nReaded 	:= 1
	local nTries	:= 0
	local cBuffer 	:= Space( BUFFER_SIZE )
	local cText 	:= ''
	local aEsc, cCode, nPos, nEscLen	
	

	while ( nReaded := hb_PRead( ::hStdOut, @cBuffer, BUFFER_SIZE, 1000 ) ) == 0
      if ++nTries > 15 			
         exit
      endif 				 
   end
	  
	cBuffer = Substr( cBuffer, 1, nReaded )		
	aEsc = hb_ATokens( AllTrim( cBuffer ), Chr( 27 ) )								
		
   nEscLen = Len( aEsc )

   switch( nEscLen )   
      case 1	//	Only Text
         cText = cBuffer
      
      case 2 	//	1 code Escape										
         cText = GetEscapeCode( cBuffer, .F. )

      case 4	//	4 code Escape. Instruction Set				
         //	Check is instruction set...
         if getEscapeCode( aEsc[2] ) == '1' .and. ;
            getEscapeCode( aEsc[4] ) == '0' 
            cText := getEscapeCode( aEsc[ 4 ], .F. )
            ?? cText
            
            cBuffer = Space( BUFFER_SIZE )
            nTries  = 0
            
            while ( nReaded := hb_PRead( ::hStdOut, @cBuffer, BUFFER_SIZE, 1000 ) ) > 0
               if ++nTries > 15 						
                  exit
               endif 				 						 						 
            
               if At( chr( 27 ), cBuffer  ) == 0
                  ?? Substr( cBuffer, 1, nReaded )
               else
                  ?? GetEscapeCode( Substr( cBuffer, 1, nReaded ), .F. )
               endif
               
               cBuffer = Space( BUFFER_SIZE )
               nTries  = 0
            end					  					  
               
            return nil										
         endif					
   end 
         
   ?? cText   
	
return nil 

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

//	lCode == .t., return escape code
//	lCode == .f., return text after escape code
//	ex: esc[0mHello

function GetEscapeCode( u, lCode )

	local n := 0, cCode_Tmp := '', cCode := '', cChar, nPos
	
	hb_default( @lCode, .T. )
	
	if ( nPos := At( '[', u ) ) > 0
		cCode_Tmp = SubStr( u, nPos+1 )					
		cChar 	 = ''
		
		while cChar != "m" .and. Len( cCode_Tmp ) > n
			n++
			cChar = SubStr( cCode_Tmp, n, 1 )
		end 
		 
		if cChar == 'm' 
			if lCode
				cCode := SubStr( cCode_Tmp, 1, n - 1 )			
			else 
				cCode := SubStr( cCode_Tmp, n + 1 )			
			endif
		endif				 
	endif 
	
return cCode

function dbwin( u )
retu WAPI_OutputDebugString( chr(10) + chr(13) + u )

function CPUSpeed()

return Str( win_regRead( "HKLM\HARDWARE\DESCRIPTION\System\CentralProcessor\0\~MHz" ) )

#pragma BEGINDUMP

#include <hbapi.h>
#include <immintrin.h>

HB_FUNC( CPUHASAVX2 )
{
   int cpuInfo[ 4 ];
   __cpuid( cpuInfo, 0 );

    hb_retl( cpuInfo[ 2 ] & ( 1 << 5 ) );
}

#pragma ENDDUMP

