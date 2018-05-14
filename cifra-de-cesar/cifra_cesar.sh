#!/bin/bash
# Script para realizar operação simples de criptografia usando a "cifra de cesar" - Especialização em Segurança Unibratec
# Autor: Diego Castelo Branco
# Data: 05/05/2018

#LETRAS=(a b c d e f g h i j k l m n o p q r s t u v w x y z " ")
LETRAS=(a b c d e f g h i j k l m n o p q r s t u v w x y z)

function fn_get_cifra_cesar()
{
	IN="$1"
	EXPRESSAO=$(echo "$IN" | tr "A-Z" "a-z")
	DELTA="$2"

	LEN_EXPRESSAO="${#EXPRESSAO}"
	LEN_LETRAS="${#LETRAS[@]}"
	SAIDA=""
	DESCIFRAR=0
	#echo "EXPRESSAO: $EXPRESSAO, Tamanho: ${LEN_EXPRESSAO}, Tam Letras: ${LEN_LETRAS}, DELTA: $DELTA"   # DEBUG
	#echo "${LETRAS[@]}" # DEBUG

	for i in $(seq 0 $(("$LEN_EXPRESSAO"-1))) ; do
		
		L=$(echo "${EXPRESSAO:$i:1}")
		INDEX_LETRAS=$(echo ${LETRAS[@]/$L//} | cut -d/ -f1 | wc -w | tr -d ' ')
		# echo "Letra: $L, INDEX_LETRAS: $INDEX_LETRAS"  DEBUG

		# Criando a relação circular das letras
		#=======================================
		# tratando o delta para descriptografar (criando delta sempre positivo)
		if [ "$DELTA" -lt 0 ];then
			DELTA=$(($DELTA*-1)) 
			DESCIFRAR=1
		fi

		# tratando quando o delta é maior que a quantidade de letras
		if [ "$DELTA" -ge "$LEN_LETRAS" ];then
			# pegamos o módulo - o resto da divisão			
			NOVO_DELTA=$(($DELTA%$LEN_LETRAS))
			DELTA="$NOVO_DELTA"
			
		fi
		# Retornando o Delta para negativo se for descifrar
		if [ "$DESCIFRAR" -eq 1 ];then
				DELTA=$(($DELTA*-1)) 
		fi		
		#echo "Delta CALCULO: $DELTA"  # DEBUG

		#Inicinado as oprações de deslocamento
		DESLOCAMENTO=$(($INDEX_LETRAS+$DELTA))
		if [ "$DESLOCAMENTO" -ge "$LEN_LETRAS" ];then
			# pegamos o módulo - o resto da divisão
			NOVO_INDEX_LETRAS=$(($DESLOCAMENTO%$LEN_LETRAS))
		else
			NOVO_INDEX_LETRAS="$DESLOCAMENTO"
		fi
		LETRA_CIFRADA="${LETRAS[$NOVO_INDEX_LETRAS]}"
		SAIDA="$SAIDA$LETRA_CIFRADA"
		#echo "NOVO_INDEX_LETRAS: $NOVO_INDEX_LETRAS, LETRA_CIFRADA: $LETRA_CIFRADA"   #DEBUG
	done
	echo "$SAIDA"
}

# Inicio do script
#===================

if [ $# -lt 2 ];then
	echo "Falha - Campos requeridos"
	echo "Use: $0 <expressao> <delta>"
	echo " Notas:"
	echo "   1) Utilize aspas para delimitar textos com espaços"
	echo "   2) Para cifrar Use delta positivo (Ex.: 3)"
	echo "   3) Para descifrar Use delta negativo (Ex.: -3)"
	echo " Exemplo1: $0 \"cifradecesar\" 5"
	echo " Exemplo1: $0 \"hnkxfeijehjwfx\" -5"
	exit
fi

fn_get_cifra_cesar "$1" "$2"
