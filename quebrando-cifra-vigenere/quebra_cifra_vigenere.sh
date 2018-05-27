#!/bin/bash
# Script para realizar quebra da "cifra de vigenere" - Especialização em Segurança Unibratec
# Autor: Diego Castelo Branco
# Data: 26/05/2018


#CIFRADO=(TCXKWZJCNGATTVZZWYNOFSOAKRCGGZZWYNOFSOAKRCGBZSSTURZIOXOBSUGZZWYNODUIXGDPJFLTCXKWZJCNGATTVZZWYNOFSOAKRCGBFTQLKSDWIPISCKWPYGPGQZTHPIWXKBEUBLBWOGRPSWYNODXSEOBLYHLUTLZWRGRLYBFTQLKGBASNKFPOEFKBZSSTURZIOXOBSUGZZWYNOFSOAKRCGGZZWYNOFSOAKRCGBZSSTURZIOXOBSUBZSSTURZIOXOBSUGZZWYNOFSOAKRCG)

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

FREQUENCIA_CHAVE=""

ALFABETO=(a b c d e f g h i j k l m n o p q r s t u v w x y z)

function fn_get_cifra_cesar()
{
	IN="$1"
	EXPRESSAO=$(echo "$IN" | tr "A-Z" "a-z")
	DELTA="$2"

	LEN_EXPRESSAO="${#EXPRESSAO}"
	LEN_LETRAS="${#ALFABETO[@]}"
	SAIDA=""
	DESCIFRAR=0
	#echo "   CIFRA DEBUG - EXPRESSAO: $EXPRESSAO, Tamanho: ${LEN_EXPRESSAO}, Tam Letras: ${LEN_LETRAS}, DELTA: $DELTA"   # DEBUG
	#echo "${LETRAS[@]}" # DEBUG

	for i in $(seq 0 $(("$LEN_EXPRESSAO"-1))) ; do
		
		L=$(echo "${EXPRESSAO:$i:1}")
		INDEX_LETRAS=$(echo ${ALFABETO[@]/$L//} | cut -d/ -f1 | wc -w | tr -d ' ')
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
		LETRA_CIFRADA="${ALFABETO[$NOVO_INDEX_LETRAS]}"
		SAIDA="$SAIDA$LETRA_CIFRADA"
		#echo "NOVO_INDEX_LETRAS: $NOVO_INDEX_LETRAS, LETRA_CIFRADA: $LETRA_CIFRADA"   #DEBUG
	done
	echo "$SAIDA"
}

function fn_get_index()
{
	TEXTO_CIFRA="$1"
	TEXTO_BUSCA="$2"
	TAM_BUSCA=${#TEXTO_BUSCA}
	SAIDA=""
	INDEX=1
	#echo "$TEXTO_CIFRA - $TEXTO_BUSCA"  #DEBUG
	#INDEX=$(echo ${TEXTO_CIFRA[@]/${TEXTO_BUSCA}//} | cut -d/ -f1 | wc -w | tr -d ' ')
	echo ${TEXTO_CIFRA} | grep ${TEXTO_BUSCA} | sed "s/${TEXTO_BUSCA}/${TEXTO_BUSCA}\n/g" > tmp_index
	QTD=$(cat tmp_index | wc -l)
	QTD=$(($QTD-1))
	for I in $( head -n ${QTD} tmp_index);do
		#echo $I  #DEBUG
		TAM_LOCALIZADO=$(echo $I | wc -c)
		# Regitra o indice
		#INDEX=$((${INDEX} + ${TAM_LOCALIZADO} - ${TAM_BUSCA} -1))
		INDEX=$((${INDEX} + ${TAM_LOCALIZADO} - ${TAM_BUSCA} -1 ))

		# evitando que seja enviado indice do resto do arquivo
		if [ ${INDEX} -gt 0 ];then
			#echo "Index PARCIAL: ${INDEX}"			
			SAIDA="$SAIDA ${INDEX}"
		fi
		# depois de regitrado a ocorrentcia em SAIDA, vamos adicionar o tamanho das linhas anteriores ao INDEX para continuar a busca
		INDEX=${TAM_LOCALIZADO}
	done
	echo ${SAIDA} | xargs -n1| sort -nu
	
}


function fn_gerar_frequencias()
{
	# função que identifica as frequencias de letras dentro do arquivo
	LISTAS="$1"
	RESULTADO="tmp_resultado.csv"

	rm -f "${RESULTADO}.*"
	# recebe várias listas de letras
	for AA in $(ls ${LISTAS}.*);do
		# identificando a quantidade de letras na lista para amostragem
		TOTAL_LETRAS=$(cat ${AA} | wc -l)
		# pra reduzir o processamento, extraindo letras unicas de cada lista
		ARRAY_LETRAS_UNICAS=$(cat ${AA} | sort | uniq)
		#echo "LETRAS UNICAS $ARRAY_LETRAS_UNICAS"
		# para cada lista ordena as letras e tenta contar a quantidade
		for B in ${ARRAY_LETRAS_UNICAS[@]}; do
			REPETICOES=$(grep -c ${B} ${AA})
			PERCENTUAL_TEXTO=$(echo "(${REPETICOES} / ${TOTAL_LETRAS})*100" | bc -l)
			PERCENTUAL_LETRAS=$(echo "(${REPETICOES} / 26)*100" | bc -l)
			#echo "LISTA: ${AA}; LETRA: ${B}; REPETICOES: ${REPETICOES}; P-LETRAS: ${PERCENTUAL_LETRAS}; P_TEXTO: ${PERCENTUAL_TEXTO}" ## DEBUG
			echo "${AA};${B};${REPETICOES};${PERCENTUAL_LETRAS};${PERCENTUAL_TEXTO}" >> $RESULTADO.${AA}
		done
		cat "$RESULTADO.${AA}" | sort -nr -t";" -k5 > tmp
		cat  tmp > "$RESULTADO.${AA}"
	done 
	rm -f tmp
}

function fn_get_delta_cesar()
{
	# funcao para extrair apenas os Delta de uma letra
	IN="$1"
	EXPRESSAO=$(echo "$IN" | tr "A-Z" "a-z")
	
	LEN_EXPRESSAO="${#EXPRESSAO}"
	LEN_LETRAS="${#LETRAS[@]}"
	SAIDA=""
	
	L=$(echo "${EXPRESSAO:$i:1}")
	INDEX_LETRAS=$(echo ${ALFABETO[@]/$L//} | cut -d/ -f1 | wc -w | tr -d ' ')
	
	#retornando o Delta negativo para operação de decifragem
	
	INDEX_LETRAS=$((${INDEX_LETRAS}+$EXTRA)) # Ingles
	echo "-${INDEX_LETRAS}"
	#echo ${INDEX_LETRAS}
}

function fn_descifra_cesar()
{
	# função que invoca a descifragem do texto
	ARQUIVO="$1"
	OUTPUT="tmp_decifrado"
	for CC in $(ls ${ARQUIVO}.*);do
		LETRA_A=$(head -n1 ${CC}| cut -d";" -f2)
		DELTA=$(fn_get_delta_cesar "$LETRA_A")
		echo "Arquivo: ${CC}: Letra A: $LETRA_A, DELTA: ${DELTA}"  ## DEBUG
		ARQUIVO_ORIGINAL=$(echo ${CC} | sed "s/tmp_resultado.csv.//g")		
		for F in $(cat "${ARQUIVO_ORIGINAL}");do
			#echo "ARQUIVO: ${CC}, LETRA: $F DELTA: $DELTA, ARQUIVO-ORIGINAL: ${ARQUIVO_ORIGINAL} OUTPUT: ${OUTPUT}.${ARQUIVO_ORIGINAL}" ##DEBUG
			fn_get_cifra_cesar "$F" "$DELTA" >> "${OUTPUT}.${ARQUIVO_ORIGINAL}"
		done
	done
	
}

function fn_extrair_frequencia_tamanho_chave()
{
	# função pra separar os caracteres que devem ter combinações em comum Linha X coluna de vegenere
	# 1) Esta função utiliza o tamanho da chave para fatiar a string em grupos de "TAM "caracteres por linha
	# 2) Com a quantidade de caracteres por linha, a segunda etepa é selecionar as colunas dessa arquivo e gerar outros arquivos
	# com apenas um caratere por linha

	ARQUIVO="$1"
	TAM="$2"
	LISTA="tmp_lista_freq.txt"
	rm -f "$LISTA*"
	#echo > "$LISTA"
	LETRAS_CIFRAS=$(cat $ARQUIVO)
	TAM_LETRAS=${#LETRAS_CIFRAS}
	TOTAL_GRUPOS=$((${TAM_LETRAS}/${TAM}))
	for L in $(seq 0 ${TAM} ${TAM_LETRAS});do  # Visão dividira pelo tamanho da chave
	#for L in $(seq 0 ${TOTAL_GRUPOS} ${TAM_LETRAS});do   # dividinfo em grupos definidos pelo tamanho da chave
	#for L in $(seq 0 ${TOTAL_GRUPOS});do   # dividinfo em grupos definidos pelo tamanho da chave
		#echo "L: $L"
		echo "${LETRAS_CIFRAS:${L}:${TAM}}" >> "$LISTA"
		#echo "${LETRAS_CIFRAS:${L}:${TOTAL_GRUPOS}}" >> "$LISTA"
	done

	for L in $(cat "$LISTA");do
		#echo "L: $L"
		T=$((${TAM}-1))
		for I in $(seq 0 $T);do
			# vamos pegar em cada trexo extraido a letra referente a posição 1, depois poisção 2 ...
			echo "${L:${I}:1}" >> "$LISTA.$I"			
		done
	done
	# função que gera as frequencias das letras no arquivo
	fn_gerar_frequencias "$LISTA"
}


function fn_identificar_repeticoes_chave()
{
	ARQUIVO="$1"
	TAM="$2"
	LETRAS_CIFRAS=$(cat $ARQUIVO)
	LEN_CIFRADO=${#LETRAS_CIFRAS}
	LIMITE=$((${LEN_CIFRADO}-${TAM}))
	for T in $(seq 0 ${LIMITE});do
		STRING=$(echo ${LETRAS_CIFRAS:$T:$TAM})
		#echo ${STRING}
		#Como o grep -c só conta linhas, o jeito foi dar uma quebra de linhas a cada ocorrencia da string procurada :(
		CONT=$(cat ${ARQUIVO} | sed "s/${STRING}/${STRING}\n/g" | grep -c ${STRING})
		#echo -e "${STRING};${CONT}"
		FREQUENCIA_CHAVE=$FREQUENCIA_CHAVE$(echo -e "\n${STRING};${CONT}")
	done
	echo "${FREQUENCIA_CHAVE}"
}

function fn_indentificar_possivel_tamanho_chave()
{
	ARQUIVO="$1"
	LETRAS=$(cat ${ARQUIVO})

	LIMITE_TAMANHO="$2"
	PESO_LETRAS="${3:-1}"
	TEMP=tmp_chaves.txt
	
	echo > $TEMP
	echo > $TEMP.2
	echo > $TEMP.3
	echo > $TEMP.4
	for T in $(seq 2 ${LIMITE_TAMANHO});do
		echo "Vasculhando repetições de $T letras"
		fn_identificar_repeticoes_chave ${ARQUIVO} ${T} >> $TEMP
	done

	cat $TEMP | sort -t";" -k2 -nr | uniq > "$TEMP.2"
	for L in $(cat "$TEMP.2");do
		STR=$(echo "$L"| cut -d";" -f1)
		QTD=$(echo "$L"| cut -d";" -f2)
		TAM_STR=${#STR}
		#echo "$STR;$QTD;$(($QTD*TAM_STR))"
		# a ideia é criar uma pontuação de quantidade de letras * a incidencia delas (o numero maios é candidato)
		echo "$STR;$QTD;$(($QTD*$TAM_STR*${PESO_LETRAS}))" >> "$TEMP.3"
	done
	cat "$TEMP.3" | sort -t";" -k3 -nr | uniq > "$TEMP.4"
	MAX=$(cat "$TEMP.4" | cut -d";" -f3| head -n1)
	CHAVES=$(cat "$TEMP.4" | grep "$MAX" | cut -d";" -f1)
	# echo "$CHAVES"
	
	for C in $CHAVES; do
		DISTANCIAS=$(fn_get_index "${LETRAS}" "$C")
		echo "Candidata: $C"   ##DEBUG
		echo ${DISTANCIAS}  
		###fn_get_mdc ${DISTANCIAS}
	done
}


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

# if [ $# -lt 3 ];then
# 	echo "Falha - Campos requeridos"
# 	echo "Use: $0 <expressao> <chave> <-c|--cript> |<-d|--decript>"
# 	echo " Notas:"
# 	echo "   1) Utilize aspas para delimitar textos com espaços"
# 	echo " Exemplo1: $0 \"cifra de vigeneve\" \"chavemestra\""
# 	exit

# fi

# case "$3" in
# 	"-c"|"--cript")
# 		echo "Resultado de cifragem (cript):"
# 		# expressao e chave
# 		fn_get_cifra_vigenere "$1" "$2"		
# 	;;
# 	"-d"|"--decript")
# 		echo "Resultado de decifragem (decript):"
# 		# expressao e chave
# 		fn_descifrar_cifra_vigenere "$1" "$2"
# 	;;
# 	*)
# 	echo "Opção $3 invalida"
# 	exit
# 	;;

# esac
##
#fn_identificar_repeticoes_chave cifrado.txt 3

export EXTRA="${2:-0}"
#rm -f tmp_*
rm -f tmp_decifrado*
#fn_indentificar_possivel_tamanho_chave cifrado.txt 5 10
#fn_extrair_frequencia_tamanho_chave cifrado.txt ${1:-3}
fn_descifra_cesar "tmp_resultado.csv"


echo "cifrado"
cat cifrado.txt
echo "descifrado"
paste -d" " tmp_dec* 
#paste -d" " tmp_dec* | tr "\n" " " | sed "s/ //g"
