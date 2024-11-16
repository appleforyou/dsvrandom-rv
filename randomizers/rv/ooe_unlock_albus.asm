.nds
.relativeinclude on
.erroronwarning on

@Overlay86Start equ 0x022EB1A0
@FreeSpace equ @Overlay86Start + 0x420
@FreeSpace2 equ @Overlay86Start + 0x500

.open "ftc/overlay9_22", 02223E00h
.org 0x02233280
  b @SetVillagers
.close

.open "ftc/overlay9_60", 022C1FE0h
.org 0x022C211C
  b @SetMemories
.close

.open "ftc/overlay9_86", @Overlay86Start ; Free space overlay
.org @FreeSpace
; Sets all villagers as rescued to enable Albus to be fought at any time.
@SetVillagers:
  mov r3, r14
  ldr r14, =0210038Ch ;=02100388h
  ldr r1, [r14]
  orr r1, r1, 00002400h
  orr r1, r1, 00040000h
  orr r1, r1, 11000000h
  str r1, [r14]
  ldr r1, [r14, 4h]
  orr r1, r1, 00000001h
  orr r1, r1, 00000880h
  orr r1, r1, 00088000h
  orr r1, r1, 00800000h
  str r1, [r14, 4h]
; Also sets albus's memories cutscene as seen, which enables Barlowe to be fought anytime.
  ldr r14, =02100388h
  ldr r1, [r14]
  ;orr r1, r1, 00000080h
  orr r1, r1, 00002000h
  orr r1, r1, 02000000h
  str r1, [r14]
  mov r14, r3
  mov r1, 0h
  b 02233284h ;0x0221aE34
  .pool


.org @FreeSpace2
; After killing Albus, it's necessary to unset the albus memories cutscene flag,
; or else the cutscene will try and fail to play when you absorb his glyph, causing a graphical glitch.
; The flag will immediately be reenabled when you absorb his glyph.
@SetMemories:
  ldr r14, =02100388h
  ldr r1, [r14]
  mvn r3, 02000000h
  and r1, r1, r3
  str r1, [r14]
  mov r1, 0h
  b 022C2120h
  .pool
.close
