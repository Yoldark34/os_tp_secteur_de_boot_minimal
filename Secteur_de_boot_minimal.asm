BITS 16
ORG 0x00


;===============================================================================
mov AX, 0x07c0
mov DS, AX			;le segment de data est initialisé à 0x7c0
mov ES, AX			;le segment utilisé dans certaines manipulations

mov AX, 0x5000
mov SS, AX			;le segment de pile est initialisé à 0x5000
mov SP, 0xFFFF		;le début de la pîle est maintenant à 5FFFF
					;Rappel : la pile est gérée de haut vers le bas.

; Affiche message de boot

	mov SI,G_Ligne
	call Affiche_Chaine

	mov SI,G_Message
	call Affiche_Chaine

	mov SI,G_Ligne
	call Affiche_Chaine

	mov SI,G_Super_Image
	call Affiche_Chaine

	mov SI,G_CRLF
	call Affiche_Chaine
	call Affiche_Chaine

Fin:
	jmp Fin ; On boucle sur soit même

;===============================================================================
; Fonctio, Affiche_Chaine
; Input : DS:SI : adresse de la chaine zero terminal
;------------------------------------------------------------------------------
Affiche_Chaine :
; Des registres vont être modifiés dans cette fonction
; Ils sont donc sauvegarde dans la pile

	push AX
	push BX
	push SI

	xor BL,BL

; Tant que Chaine[SI++] <> 0
Affiche_Chaine_Loop_1:
	lodsb	; load byte :copier le contenu de l'adresse DS:SI dans AL
			; avec autoincrémentation de SI

	cmp al,0 ; Comparer AL avec la valeur 0 (fin de la chaine)
	jz Affiche_Chaine_End_Loop_1	; sortir de la boucle sur AL est égla à 0

	mov AH,0X0E		; Code de la fonction Affichage
	int 0x10		; invocation de l'int bios vidéo

; Fin Tant Que
	jmp Affiche_Chaine_Loop_1

Affiche_Chaine_End_Loop_1
; Restitution à partir de la pile des registres (pile FILO)

	pop SI		;restituer le contenu précédent de SI
	pop BX		;restituer le contenu précédent de BX
	pop AX		;restituer le contenu précédent de AX
	ret			;retrourner à la fonction appelante
;-------------------------------------------------------------------------------

;===============================================================================
; VARIABLES GLOBALES (Rappel DS=CS=0x07c0)
;===============================================================================
	G_Message db "#---Amorcage du super OS v0.0.00000.000.0.0000.0.0.1---#",13,10,0
	G_Ligne db "----------------------------------------",13,10,0
	G_Super_Image db "       .-''''-.",13,10,"      /        \",13,10,"     /_        _\",13,10,"    // \      / \\",13,10,"    |\__\    /__/|",13,10,"     \    ||    /",13,10,"      \        /",13,10,"       \  __  /",13,10,"        '.__.'",13,10,"         |  |",13,10,0
	G_CRLF db 13,10,0
;===============================================================================
times 510 - ($-$$) db 0x90
	dw 0xAA55