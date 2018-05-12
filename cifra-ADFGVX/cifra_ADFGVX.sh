#!/bin/bash
# Script para realizar operação simples de criptografia usando a "cifra de ADFGVX" - Especialização em Segurança Unibratec
# Autor: Diego Castelo Branco
# Data: 07/05/2018

LETRAS=(a b c d e f g h i j k l m n o p q r s t u v w x y z)

CHAVE_BASE=(W 6 J L O Y X I E 8 4 H S 0 Q 2 9 M R 1 B K D G 5 Z U N A T F 3 V 7 P C)

BASE_CIFRA=(A D F G V X)
        #A D F G V X 
LINHA_0=(W 6 J L O Y)  #A
LINHA_1=(X I E 8 4 H)  #D
LINHA_2=(S 0 Q 2 9 M)  #F
LINHA_3=(R 1 B K D G)  #G
LINHA_4=(5 Z U N A T)  #V
LINHA_5=(F 3 V 7 P C)  #X

# bola = GF AV AG VV

function fn_get_cifra_adfgvx()
{
	IN="$1"
	EXPRESSAO=$(echo "$IN" | tr "A-Z" "a-z")
	CHAVE="$2"

	LEN_EXPRESSAO="${#EXPRESSAO}"
	LEN_CHAVE="${#CHAVE}"
	LEN_CHAVE_BASE="${#CHAVE_BASE}"
	LEN_LETRAS="${#LETRAS[@]}"
	SAIDA=""
	NEW_CHAVE=""
	
	# criando a repetição da chave para o mesmo tamanho da expressão SE a chave for menor que a quantidade de letras da expressao
	if [ "$LEN_EXPRESSAO" -gt "$LEN_CHAVE" ];then
		REPETE=$(($LEN_EXPRESSAO/$LEN_CHAVE))
		COMPLETA=$(($LEN_EXPRESSAO%$LEN_CHAVE))

		for C in $(seq 1 "$REPETE"); do
			NEW_CHAVE="${NEW_CHAVE}${CHAVE}"
		done
		NEW_CHAVE="${NEW_CHAVE}${CHAVE:0:${COMPLETA}}"
	else
		#chave maior que a expressao
		NEW_CHAVE="${NEW_CHAVE}${CHAVE:0:${LEN_EXPRESSAO}}"
	fi
	#echo "EXPRESSAO: $EXPRESSAO, Tamanho: ${LEN_EXPRESSAO}, CHAVE: $CHAVE, NEW_CHAVE: $NEW_CHAVE"   # DEBUG
	#echo "${LETRAS[@]}" # DEBUG

	for i in $(seq 0 $(("$LEN_EXPRESSAO"-1))) ; do
		#vamos pegar a letra dentro da expressao
		LETRA_TMP=$(echo "${EXPRESSAO:$i:1}")
		LETRA=$(echo "$LETRA_TMP" | tr "a-z" "A-Z")


		INDEX_CHAVE_BASE=$(echo ${CHAVE_BASE[@]/${LETRA}//} | cut -d/ -f1 | wc -w | tr -d ' ')
		echo "LETRA: $LETRA, INDEX_CHAVE_BASE: $INDEX_CHAVE_BASE, CHAVE_BASE: ${CHAVE_BASE[@]}"
		
		# ajustando o indice para termos o tamanho começando de 1
		INDEX_TMP=$(($INDEX_CHAVE_BASE+1))
		
		# o valor inteiro da divisão por 6 (LETRAS ADFGVX) dá o indice da linha
		INDEX_LIN="$(($INDEX_TMP/6))"
		
		# o valor resto da divisão por 6 (LETRAS ADFGVX) dá o indice da coluna (retirada as reptições das linhas)
		# temos de retirar o 1 adicionado para achar o indice correto
		INDEX_COL_TMP="$(($INDEX_TMP%6))"
		INDEX_COL="$(($INDEX_COL_TMP-1))"
		
		# Obtendo o par de coordenadas LinhaxColuna
		COORDENADAS="${BASE_CIFRA[${INDEX_LIN}]}${BASE_CIFRA[${INDEX_COL}]}"
		echo "LETRA: $LETRA, INDEX_LIN: $INDEX_LIN, INDEX_COL: $INDEX_COL, COORDENADAS: $COORDENADAS "

		
		SAIDA="$SAIDA$COORDENADAS"	

		
	done
	echo "$SAIDA"
}

function fn_descifrar_cifra_adfgvx()
{
	
}


# Inicio do script
#===================

if [ $# -lt 3 ];then
	echo "Falha - Campos requeridos"
	echo "Use: $0 <expressao> <chave> <-c|--cript> |<-d|--decript>"
	echo " Notas:"
	echo "   1) Utilize aspas para delimitar textos com espaços"
	echo " Exemplo1: $0 \"cifra de vigeneve\" \"chavemestra\""

fi

case "$3" in
	"-c"|"--cript")
		echo "Resultado de cifragem (cript):"
		# expressao e chave
		fn_get_cifra_adfgvx "$1" "$2"		
	;;
	"-d"|"--decript")
		echo "Resultado de decifragem (decript):"
		# expressao e chave
		fn_descifrar_cifra_adfgvx "$1" "$2"
	;;
	*)
	echo "Opção $3 invalida"
	exit
	;;

esac

