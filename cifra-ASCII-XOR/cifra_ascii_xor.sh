#!/bin/bash
# Script para realizar operação simples de criptografia usando a "cifra ASCII XOR" - Especialização em Segurança Unibratec
# Autor: Diego Castelo Branco
# Data: 05/05/2018


function asc_to_char() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}

function char_to_ascii() {
  case "$2" in
	"d")
  		LC_CTYPE=C printf '%d' "'$1"
		;;
	"b")
		TMP=$(LC_CTYPE=C printf '%d' "'$1")
		echo "obase=2; ibase=10; $TMP" | bc
		;;
	*)
	LC_CTYPE=C printf '%d' "'$1"
		;;
  esac
}

function fn_get_ascii()
{
	#IN="$1"
	#EXPRESSAO=$(echo "$IN" | tr "A-Z" "a-z")
	EXPRESSAO="$1"
	CHAVE="$2"

	LEN_EXPRESSAO="${#EXPRESSAO}"
	LEN_CHAVE=${#CHAVE}
	# gerar um alerta se as chaves não possuirem o mesmo tamanho de letras
	if [ "$LEN_EXPRESSAO" -ne "$LEN_CHAVE" ];then
		echo "[alerta] Chave e expressão nao possuiem o mesmo tamanho"
	fi

	SAIDA=""
	DESCIFRAR=0
	echo "EXPRESSAO: $EXPRESSAO, LEN_EXPRESSAO: $LEN_EXPRESSAO, CHAVE: $CHAVE"
	
	for i in $(seq 0 $(("$LEN_EXPRESSAO"-1))) ; do
		
		LETRA_EXP=$(echo "${EXPRESSAO:$i:1}")
		LETRA_CHAVE=$(echo "${CHAVE:$i:1}")
		#INDEX_LETRAS=$(echo ${LETRAS[@]/$L//} | cut -d/ -f1 | wc -w | tr -d ' ')
		ASCII_EXP_BIN=$(char_to_ascii "$LETRA_EXP" b)
		ASCII_EXP_DEC=$(char_to_ascii "$LETRA_EXP" d)
		ASCII_CHAVE_BIN=$(char_to_ascii "$LETRA_CHAVE" b)
		ASCII_CHAVE_DEC=$(char_to_ascii "$LETRA_CHAVE" d)
				
		RES=$(("$ASCII_EXP_DEC" ^ "$ASCII_CHAVE_DEC"))
		RESULTADO=$(echo "obase=2; ibase=10; $RES" | bc | awk -v L="$LEN_EXPRESSAO" '{ printf "%08d", $1 }')

		#echo "LETRA_EXP: $LETRA_EXP, ASCII_EXP_BIN: $ASCII_EXP_BIN, ASCII_EXP_DEC: $ASCII_EXP_DEC, LETRA_CHAVE: $LETRA_CHAVE, ASCII_CHAVE_BIN: $ASCII_CHAVE_BIN, ASCII_CHAVE_DEC: $ASCII_CHAVE_DEC, XOR: $RESULTADO"  # DEBUG
		
		SAIDA="$SAIDA$RESULTADO"
		#SAIDA="$SAIDA $RESULTADO"
		
	done
	echo "$SAIDA"
}

# Inicio do script
#===================

if [ $# -lt 2 ];then
	echo "Falha - Campos requeridos"
	echo "Use: $0 <expressao> <chave>"
	echo " Notas:"
	echo "   1) Utilize textos sem espaços"
	echo " Exemplo1: $0 \"textoplano\" \"chave\""
	exit
	
fi

fn_get_ascii "$1" "$2"
