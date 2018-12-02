#!/bin/bash
#######################################
#1st parameter is to be updated string, here key value delimiter must be "=", e.g '21=2|55=6758|40=1|38=1000'
#2nd parameter is the delimiter
#3rd parameter is a key value string to replace: e.g  21=3, here key value delimiter must be "="
######################################
function overrideTag {
	toBeUpdatedStr="$1"
	delimiter="$2"
	keyValueStr="$3"
	keyValueDelimiter='='
	#Below is one of the way to assign the variable, we also use
	#toBeUpdatedArr=`echo "$toBeUpdatedStr" | awk -F"$delimiter" '{for(i=1; i<=NF; i++) print $i}'`
	toBeUpdatedArr=$(echo "$toBeUpdatedStr" | awk -F"$delimiter" '{for(i=1; i<=NF; i++) print $i}')
	keyStr=$(echo "$keyValueStr" | awk -F"$keyValueDelimiter" '{print $1}')
	valueStr=$(echo "$keyValueStr" | awk -F"$keyValueDelimiter" '{print $2}')
	updated=""
	isExist=false
	#Here we cannot use "${toBeUpdatedArr[@]}", it will be treated as one string
	for e in ${toBeUpdatedArr[@]}; do
		eKeyStr=$(echo "$e" | awk -F"$keyValueDelimiter" '{print $1}')
        	eValueStr=$(echo "$e" | awk -F"$keyValueDelimiter" '{print $2}')
		if [ "$keyStr" == "$eKeyStr" ]; then
			eValueStr="$valueStr"
			isExist=true
		fi
		if [ ! -z "$eValueStr" ]; then
			updated+="$eKeyStr"="$eValueStr""$delimiter"
		fi
	done
	if [ $isExist == false ]; then
		updated+="$keyStr"="$valueStr""$delimiter"
	fi
	#remove the last character of the string
	updated=${updated::-1}
	#return doesn't work in bash function, use echo to return value and in the caller, use $(overrideTag '21=3|38=1000' '|' '21=2')
	echo $updated
}

function overrideTags {
	toBeUpdatedStr="$1"
	delimiter="$2"
	keyValueStr="$3"
	keyValueDelimiter="="
	keyValueArr=$(echo "$keyValueStr" | awk -F"$delimiter" '{for(i=1;i<=NF;i++) print $i}')
	for e in ${keyValueArr[@]}; do
		toBeUpdatedStr=$(overrideTag "$toBeUpdatedStr" "$delimiter" "$e")
	done
	echo $toBeUpdatedStr
}
overrideTags $1 $2 $3
