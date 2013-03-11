BITS 16
ORG 0x00


;========================================================
mov AX, 0x07c0
mov DS, AX			;le segment de data est initialisé à 0x7c0
mov ES, AX			;le segment utilisé dans certaines manipulations

mov AX, 0x5000
mov SS, AX			;le segment de pile est initialisé à 0x5000
mov SP, 0xFFFF		;le début de la pîle est maintenant à 5FFFF
					;Rappel : la pile est gérée de haut vers le bas.
;==========================================
FIN:
	JMP FIN

;======================
times 510 - ($-$$) db 0x90
	dw 0xAA55