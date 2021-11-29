%define arg(n) ebp+(4*n)+4

section .text
global _start
_start:
.init:   
        mov [d_n], dword 101
        mov [d_i], dword 1
.lp:    
        mov eax, [d_i]
        cmp eax, [d_n]
        jnl .quit
        
        push dword 3
        push dword [d_i]
        call isMultipleOf
        add esp, (2) * 4

        mov [d_mul3], eax
        
        push dword 5
        push dword [d_i]
        call isMultipleOf
        add esp, (2) * 4

        mov [d_mul5], eax
        
        mov eax, [d_mul3]
        cmp eax, 1
        jne  .notPrintFizz
        
        push dword d_Fizz_len
        push dword d_Fizz
        call printString
        add esp, (2) * 4
.notPrintFizz:
        mov eax, [d_mul5]
        cmp eax, 1
        jne  .notPrintBuzz
        
        push dword d_Buzz_len
        push dword d_Buzz
        call printString
        add esp, (2) * 4
.notPrintBuzz:
        mov eax, [d_mul3]
        mov ebx, [d_mul5]
        or  eax, ebx
        
        cmp eax, 0
        jne .notPrintInteger

        push dword [d_i]
        call printInteger
        add esp, (1) * 4
.notPrintInteger:
        push dword d_Newline_len
        push dword d_Newline
        call printString
        add esp, (2) * 4

        mov eax, [d_i]
        cmp eax, [d_n]
        jnl .quit
        jl .lpexp
.lpexp:    
        add dword [d_i], 1
        jmp .lp
.quit:
        mov ebx, 0
        mov eax, 1
        int 80h

; input: 
;       arg(1) = dividend number
;       arg(2) = divisor number
; output:
;       eax = 1 or 0
isMultipleOf:
        push ebp
        mov ebp, esp

        xor edx, edx
        mov eax, [arg(1)]
        mov ebx, [arg(2)]
        div ebx ; divides edx:eax by ebx. edx = remainer
        cmp edx, 0
        je  .mul
        mov eax, 0
        jmp .ret
.mul: 
        mov eax, 1
.ret:   
        mov esp, ebp
        pop ebp
        ret

; input: 
;       arg(1) = integer
; output: 
;       none
printInteger:
        push ebp
        mov ebp, esp

        mov eax, [arg(1)]
        push dword b_outputString
        call convertIntegerToString
        add esp, (1) * 4
        
        push dword eax
        push dword edi
        call printString
        add esp, (2) * 4
        
        mov esp, ebp
        pop ebp
        ret

; input: 
;       arg(1) = addres to outputString
;       eax = integer number
; output: 
;       edi = addres to complete outputString
;       eax = length of outputString
convertIntegerToString:
        push ebp
        mov ebp, esp
        
        mov edi, [arg(1)] 
        mov ecx, 10         ; divisor
        xor ebx, ebx        ; count digits

.divide:
        xor edx, edx        ; high part = 0
        div ecx             ; eax = edx:eax/ecx, edx = remainder
        push edx            ; DL is a digit in range [0..9]
        inc ebx             ; count digits
        test eax, eax       ; EAX is 0?
        jnz .divide         ; no, continue

        ; POP digits from stack in reverse order
        mov ecx, ebx        ; number of digits
.next_digit:
        pop eax
        add al, '0'         ; convert to ASCII
        mov [edi], al       ; write it to the buffer
        inc edi
        loop .next_digit
        jmp .return
        
.return:
        mov edi, [arg(1)]
        mov eax, ebx
        mov esp, ebp
        pop ebp
        ret
        
; input:
;       arg(1) = string to print
;       arg(2) = length of string
; output:
;       none
printString:
        push ebp
        mov ebp, esp
        
        mov esi, [arg(1)] 
        mov eax, [arg(2)]
        
        mov edx, eax
        mov ecx, esi
        mov ebx, 1
        mov eax, 4
        int 0x80
.return:
        mov esp, ebp
        pop ebp
        ret  

section .data
d_n             dd  101
d_i             dd  1
d_mul3          dd  0
d_mul5          dd  0
d_Fizz          db  "Fizz"
d_Fizz_len      equ $-d_Fizz
d_Buzz          db  "Buzz"
d_Buzz_len      equ $-d_Buzz
d_Newline       db  10
d_Newline_len   equ $-d_Newline

section .bss
b_outputString    resb    256