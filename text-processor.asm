                              .stack 100h
.data
Msg db "enter your text(up to 100 characters):$"
MsgA db "number of characters:$"
MsgB db "number of words:$"
MsgC db "most frequent character is:$"
blank db "blank$"
MsgD db "press Enter to continue$"
Buffer Db 101
Db 0
Db 102 dup(0)

countA db ?

freq db 256 dup(?)
maxchar db ?
maxcount db ?

row db ?
column db ?
line1 db ?
line2 db ?


.code
Main proc
Mov AX ,@data
Mov DS,AX
Mov AH ,09h
Mov DX,offset msg
int 21h

;step A
Mov AH, 0ah
Mov DX, offset buffer
int 21h

Mov SI,offset buffer+2
Mov AL,[buffer+1]
Mov CL,AL
Mov CH,0
Mov [countA],0
count:

Cmp [SI],' '
je skipA
Inc [countA]
skipA:
Inc SI
LOOP count

Mov DL,0Dh
Mov AH,02h
int 21h

Mov DL,0Ah
Mov AH,02h
int 21h

Mov AH ,09h
Mov DX,offset msgA
int 21h

Mov AL,[countA]

Cmp AL,100
Je print_100

Cmp AL ,10
Jge two_digit


Add AL,30h
Mov AH,02h
Mov DL,AL
int 21h
jmp finish

two_digit:
Mov AL, [countA]
Mov AH,0
Mov BL,10
Div BL
Mov BL,AH
Add AL,30h
Mov DL,AL
Mov AH,02h
int 21h
Add BL,30h
Mov DL,BL
Mov AH,02h
int 21h
jmp finish

print_100:
Mov DL,'1'
Mov AH,02h
int 21h
Mov DL,'0'
Mov AH,02h
int 21h
Mov DL,'0'
Mov AH,02h
int 21h

finish:
Mov DL,0Dh
Mov AH,02h
int 21h
Mov DL,0Ah
Mov AH,02h
int 21h

;step B
Mov SI, offset buffer+2
Mov AL,[buffer+1]
Mov CL,AL
Mov CH,0
Mov BL,0
Mov BH,0

start_b:
Cmp CX,0
Je done_b
Mov AL,[si]
Cmp AL,' '
Jne still_char
Mov BH,0
Jmp next_b

Still_char:
Cmp BH,0
Jne next_b
Inc BL
Mov BH,1

next_b:
Inc SI
Dec CX
Jmp start_b

done_b:
Cmp BL,10
Jge two_digit_word
Mov AH ,09h
Mov DX,offset msgB
int 21h
Add BL,30h
Mov AH,02h
Mov DL,BL
int 21h
jmp word_exit

two_digit_word:
Mov AH ,09h
Mov DX,offset msgB
int 21h
Mov AH,0
Mov AL,BL
Mov CL,10
Div CL
Mov CH,AH
Add AL,30h
Mov DL,AL
Mov AH,02h
int 21h
Add CH,30h
Mov DL,CH
Mov AH,02h
int 21h

word_exit:
Mov DL,0Dh
Mov AH,02h
int 21h
Mov DL,0Ah
Mov AH,02h
int 21h

;step c
Mov SI,offset freq
Mov CX,256
Mov AL,0
loop_c:
Mov [SI],AL
Inc SI
LOOP loop_c
Mov SI, offset buffer+2
Mov AL,[buffer+1]
Mov CL,AL
Mov CH,0
Mov maxcount,0
start_c:
Cmp CX,0
Je exit_c
Mov AL,[SI]
Cmp AL,' '
Je next_c
Mov BL,AL
Mov BH,0
Inc freq[BX]
Mov DL,freq[Bx]
Cmp maxcount,DL
Jae next_c
Mov maxcount,DL
Mov maxchar ,AL
next_c:
Inc SI
Dec CX
Jmp start_c
exit_c:
Mov AH ,09h
Mov DX,offset msgC
int 21h
Mov DL,[maxchar]
Cmp [maxcount],0
je blank_d
Mov AH,02h
int 21h
jmp finishC
blank_d:
Mov AH ,09h
Mov DX,offset blank
int 21h
finishC:
Mov DL,0Dh
Mov AH,02h
int 21h
Mov DL,0Ah
Mov AH,02h
int 21h
Mov AH ,09h
Mov DX,offset MsgD
int 21h
waitkey:
Mov AH,00h
int 16h
Cmp AL,0DH
Je stepD
Jmp waitkey

;step D
stepD:
Mov SI,offset buffer+2
Mov AL,[buffer+1]
Mov CL,AL
Mov CH,0
loop_d:
Mov AL,[SI]
Cmp AL,maxchar
jne again_d
Mov [si],'X'
again_d:
Inc SI
LOOP loop_d

;step D printing

Mov AL,[buffer+1]
Cmp AL,80
jbe oneline

Mov byte ptr [line1],80
Mov BL,80
Sub AL,BL
Mov byte ptr [line2],AL
Jmp donelength
oneline:
Mov line1,AL
Mov line2,0
donelength:
Mov AL,byte ptr[line1]
Mov BL,80
Sub BL,AL
Mov AL,BL
Mov BL,2
Mov AH,0
Div BL
Mov byte ptr [column],AL
Cmp byte ptr [line2],0
Je setrow
Mov byte ptr [row],11
jmp start_d
setrow:
Mov byte ptr [row],12

start_d:
Mov AH,00h
Mov AL,03h
int 10h
Mov DH,byte ptr[row]
Mov DL,byte ptr[column]
Mov AH,02h
Mov BH,00h
int 10h
Mov SI, offset buffer+2
Mov AL,byte ptr [line1]
Mov CL,AL
Mov CH,0

loop_dp1:
Mov AL,[SI]
Mov AH,0Eh
int 10h
inc SI
LOOP loop_dp1

Cmp byte ptr[line2],0
je keys

Mov AL,byte ptr[line2]
Mov BL,80
Sub BL,AL
Mov AL,BL
Mov BL,2
Mov AH,0
Div BL
Mov DH,byte ptr[row]
Inc DH
Mov DL,AL
Mov AH,02h
Mov BH,00h
int 10h
Mov SI, offset buffer+2+80
Mov AL,byte ptr [line2]
Mov CL,AL
Mov CH,0

loop_dp2:
Mov AL,[SI]
Mov AH,0Eh
int 10h
inc SI
LOOP loop_dp2

keys:
Mov AH,00h
int 16h

Cmp AL,1Bh
Je exit_prog

Cmp AL,00h
Jne start_d

cmp AH,48h
Je up

cmp AH,50h
Je down

cmp AH,4Bh
Je left

cmp AH,4Dh
Je right

up:
Mov AL,byte ptr[row]
Cmp AL,0
Je skipu
Dec byte ptr[row]
skipu:
Jmp start_d

down:
Cmp byte ptr[line2],0
Je row24
Cmp byte ptr [row],23
Jae skipd
Inc byte ptr [row]
Jmp skipd
row24:
Cmp byte ptr [row],24
jae skipd
Inc byte ptr [row]
skipd:
jmp start_d

left:
Mov AL,byte ptr[column]
Cmp AL,0
Je skipl
Dec byte ptr[column]
skipl:
Jmp start_d

right:
Mov AL,byte ptr[line1]
Mov BL,80
Sub BL,AL
Cmp byte ptr[column],BL
Jae skipr
inc byte ptr[column]
skipr:
Jmp start_d

exit_prog:
Mov AH,4Ch
Mov AL,00h
int 21h