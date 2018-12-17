#!/bin/bash
#Data
declare tdate=`date +%Y%m%d_%H%M%S`

#Host Remoto
host="192.168.242.40"
user="alessandro"
passwd="ale2008"
file="*.tar.gz"

#Diretórios
dir=/opt/backups/mysql
temporario=/tmp/bkptmp

# Cria diretório temporário
mkdir $temporario

#Copia Simples:
cp -R $dir $temporario

# Incluindo data no nome do arquivo
nomeArquivo="`echo $dir | sed -e 's:/:_:g'`_$tdate"

#Compactando Diretorios
tar -cvzf $temporario/$nomeArquivo.tar.gz $dir

#Copia backup para armazenamento Remoto
cd ${temporario}
ftp -n ${host} <<EOF
quote user ${user}
quote PASS ${passwd}
put  ${file}
quit
EOF

#Remove arquivos temporários
rm -rf $temporario
