#!/bin/bash
# Script para realizar operação simples de criptografia usando a "cifra de vigenere" - Especialização em Segurança Unibratec
# Autor: Diego Castelo Branco
# Data: 07/05/2018

LETRAS=(a b c d e f g h i j k l m n o p q r s t u v w x y z)

  LINHA_0=(0 a b c d e f g h i j k l m n o p q r s t u v w x y z)
  LINHA_1=(1 b c d e f g h i j k l m n o p q r s t u v w x y z a)
  LINHA_2=(2 c d e f g h i j k l m n o p q r s t u v w x y z a b)
  LINHA_3=(3 d e f g h i j k l m n o p q r s t u v w x y z a b c)
  LINHA_4=(4 e f g h i j k l m n o p q r s t u v w x y z a b c d)
  LINHA_5=(5 f g h i j k l m n o p q r s t u v w x y z a b c d e)
  LINHA_6=(6 g h i j k l m n o p q r s t u v w x y z a b c d e f)
  LINHA_7=(7 h i j k l m n o p q r s t u v w x y z a b c d e f g)
  LINHA_8=(8 i j k l m n o p q r s t u v w x y z a b c d e f g h)
  LINHA_9=(9 j k l m n o p q r s t u v w x y z a b c d e f g h i)
LINHA_10=(10 k l m n o p q r s t u v w x y z a b c d e f g h i j)
LINHA_11=(11 l m n o p q r s t u v w x y z a b c d e f g h i j k)
LINHA_12=(12 m n o p q r s t u v w x y z a b c d e f g h i j k l)
LINHA_13=(13 n o p q r s t u v w x y z a b c d e f g h i j k l m)
LINHA_14=(14 o p q r s t u v w x y z a b c d e f g h i j k l m n)
LINHA_15=(15 p q r s t u v w x y z a b c d e f g h i j k l m n o)
LINHA_16=(16 q r s t u v w x y z a b c d e f g h i j k l m n o p)
LINHA_17=(17 r s t u v w x y z a b c d e f g h i j k l m n o p q)
LINHA_18=(18 s t u v w x y z a b c d e f g h i j k l m n o p q r)
LINHA_19=(19 t u v w x y z a b c d e f g h i j k l m n o p q r s)
LINHA_20=(20 u v w x y z a b c d e f g h i j k l m n o p q r s t)
LINHA_21=(21 v w x y z a b c d e f g h i j k l m n o p q r s t u)
LINHA_22=(22 w x y z a b c d e f g h i j k l m n o p q r s t u v)
LINHA_23=(23 x y z a b c d e f g h i j k l m n o p q r s t u v w)
LINHA_24=(24 y z a b c d e f g h i j k l m n o p q r s t u v w x)
LINHA_25=(25 z a b c d e f g h i j k l m n o p q r s t u v w x y)


function fn_get_cifra_vigenere()
{
	IN="$1"
	EXPRESSAO=$(echo "$IN" | tr "A-Z" "a-z")
	CHAVE="$2"

	LEN_EXPRESSAO="${#EXPRESSAO}"
	LEN_CHAVE="${#CHAVE}"
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
		# vamos pegar o index da letra da chave
		LETRA_LIN=$(echo "${NEW_CHAVE:$i:1}")		
		# as LINHAS sempre pegao index de LETRAS - As linhas são selecionadas pela letra da chave
		INDEX_LIN=$(echo ${LETRAS[@]/${LETRA_LIN}//} | cut -d/ -f1 | wc -w | tr -d ' ')
		#echo "LETRA_LIN: $LETRA_LIN, INDEX_LIN: $INDEX_LIN"   #DEBUG
		
		# Vamos recuperar a letra da expressao
		LETRA_COL=$(echo "${EXPRESSAO:$i:1}")
		# Como ja sabemos o indice da c
		TMP="\"\${LINHA_${INDEX_LIN}[@]}\""
		#LINHA_CERTA=$(eval "echo $TMP")
		eval "LINHA_CERTA=(${TMP[@]})"
		
		INDEX_COL=$(echo ${LETRAS[@]/${LETRA_COL}//} | cut -d/ -f1 | wc -w | tr -d ' ')
		#para suprir o primeiro item do ARRAY que é o identificador da linha
		INDEX_COL=$(($INDEX_COL+1))

		#echo "LETRA_COL: $LETRA_COL, INDEX_COL: $INDEX_COL: LINHA_CERTA: ${LINHA_CERTA[@]}, TMP $TMP"   #DEBUG


		LETRA_CIFRADA="${LINHA_CERTA[${INDEX_COL}]}"
		SAIDA="$SAIDA$LETRA_CIFRADA"
		
	done
	echo "$SAIDA"
}

function fn_descifrar_cifra_vigenere()
{
	IN="$1"
	EXPRESSAO=$(echo "$IN" | tr "A-Z" "a-z")
	CHAVE="$2"

	LEN_EXPRESSAO="${#EXPRESSAO}"
	LEN_CHAVE="${#CHAVE}"
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
		# vamos pegar o index da letra da chave
		LETRA_LIN=$(echo "${NEW_CHAVE:$i:1}")		
		# as LINHAS sempre pegao index de LETRAS - As linhas são selecionadas pela letra da chave
		INDEX_LIN=$(echo ${LETRAS[@]/${LETRA_LIN}//} | cut -d/ -f1 | wc -w | tr -d ' ')
		#echo "LETRA_LIN: $LETRA_LIN, INDEX_LIN: $INDEX_LIN"   #DEBUG
		
		# Vamos recuperar a letra da expressao
		LETRA_COL=$(echo "${EXPRESSAO:$i:1}")
		# Como ja sabemos o indice da c
		TMP="\"\${LINHA_${INDEX_LIN}[@]}\""
		#LINHA_CERTA=$(eval "echo $TMP")
		eval "LINHA_CERTA=(${TMP[@]})"
		
		# Vamos identificar qual LETRA é a letra FONTE com base na letra selecionada (Linha com letra da chave) e (Coluna com letra FONTE)
		INDEX_COL=$(echo ${LINHA_CERTA[@]/${LETRA_COL}//} | cut -d/ -f1 | wc -w | tr -d ' ')
		#para suprir o primeiro item do ARRAY que é o identificador da linha
		INDEX_COL=$(($INDEX_COL-1))

		#echo "LETRA_COL: $LETRA_COL, INDEX_COL: $INDEX_COL: LINHA_CERTA: ${LINHA_CERTA[@]}, TMP $TMP"   #DEBUG

		LETRA_DECIFRADA="${LETRAS[${INDEX_COL}]}"
		SAIDA="$SAIDA$LETRA_DECIFRADA"
		
	done
	echo "$SAIDA"
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
		fn_get_cifra_vigenere "$1" "$2"		
	;;
	"-d"|"--decript")
		echo "Resultado de decifragem (decript):"
		# expressao e chave
		fn_descifrar_cifra_vigenere "$1" "$2"
	;;
	*)
	echo "Opção $3 invalida"
	exit
	;;

esac

