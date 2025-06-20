.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitcode: DWORD
.data
.code
main PROC
  

  INVOKE Exitprocess, 0
  main ENDP
  END main