FUNCTION MurmurHash : DWORD
VAR_INPUT
    pbKey : POINTER TO BYTE;
    dwLen : DWORD;
    dwSeed : DWORD;
END_VAR
VAR
    dwNblocks : DWORD;
    dwH1 : DWORD;
    dwC1 : DWORD := 16#CC9E2D51;
    dwC2 : DWORD := 16#1B873593;
    pdwBlocks : POINTER TO DWORD;
    dwK1 : DWORD;
    iI : INT;
    pbTail : POINTER TO BYTE;
END_VAR

dwNblocks := dwLen / 4;
dwH1 := dwSeed;
pdwBlocks := pbKey;

FOR iI := 0 TO DWORD_TO_INT(dwNblocks) - 1 DO
    dwK1 := pdwBlocks[iI];
    dwK1 := dwK1 * dwC1;
    dwK1 := SHL(dwK1, 15) OR SHR(dwK1, 17);
    dwK1 := dwK1 * dwC2;
    dwH1 := dwH1 XOR dwK1;
    dwH1 := SHL(dwH1, 13) OR SHR(dwH1, 19);
    dwH1 := dwH1 * 5 + 16#E6546B64;
END_FOR

(**
	ST implementationof case runs, at least in CODESYS
	behaves differently from the usual C like language
	SWITCH statements;
	Only the actual value is executed and there is no
	fall through - this means that the algorithm needs
	to implement all distinct cases for leftover bytes.
**)
pbTail := pbKey + dwNblocks * 4;
dwK1 := 0;
CASE dwLen MOD 4 OF
    1:
		dwK1 := dwK1 XOR pbTail[0];       
    2: 
		// Multiplying to have automatic casting
		dwK1 := dwK1 XOR (pbTail[1] * 256);
		dwK1 := dwK1 XOR pbTail[0];
    3: 
		// Multiplying to have automatic casting
		dwK1 := dwK1 XOR (pbTail[2] * 65536);
		dwK1 := dwK1 XOR (pbTail[1] * 256);
		dwK1 := dwK1 XOR pbTail[0];
END_CASE

(**
	Also for previously mentioned reason, to avoid having
	this code block copied to every CASE statement, instead
	we rely on an if statement.
**)
IF (dwLen MOD 4) <> 0 THEN
	dwK1 := dwK1 * dwC1;
	dwK1 := SHL(dwK1, 15) OR SHR(dwK1, 17);
    dwK1 := dwK1 * dwC2;
    dwH1 := dwH1 XOR dwK1;
END_IF

dwH1 := dwH1 XOR dwLen;
dwH1 := dwH1 XOR SHR(dwH1, 16);
dwH1 := dwH1 * 16#85EBCA6B;
dwH1 := dwH1 XOR SHR(dwH1, 13);
dwH1 := dwH1 * 16#C2B2AE35;
dwH1 := dwH1 XOR SHR(dwH1, 16);

MurmurHash := dwH1;

END_FUNCTION
