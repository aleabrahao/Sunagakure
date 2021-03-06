#!/bin/bash
###################################################################
# Nome : backup_mysql.sh
# Script para Backup dos dados do MySQL  #
# Criação :  14/12/2018 - Alessandro Abrahao #
# Ultima modificação :  14/12/2018 - Alessandro Abrahao #
###################################################################

# Changelog


##### Variaveis
declare DATA=`date +%Y%m%d_%H%M%S`
declare DIR_BACKUP="/opt/backups/mysql/"  #  Define o diretório de backup
declare SENHA="TIX4Ym@N"
declare USER="root"
DIR_DEST_BACKUP=$DIR_BACKUP$DATA
###################################################################

##### Rotinas secundarias
mkdir -p $DIR_BACKUP/$DATA # Cria o diretório de backup diário
echo "MYSQL"
echo "Iniciando backup do banco de dados"
##################################################################

# função que executa o backup
executa_backup(){
echo "Inicio do backup $DATA"
 #Recebe os nomes dos bancos de dados na maquina destino
 BANCOS=$(mysql -u $USER -p$SENHA -e "show databases")
 #retira palavra database
 #BANCOS=${BANCOS:9:${#BANCOS}}

declare CONT=0

#inicia o laço de execução dos backups


for banco in $BANCOS
 do
 if [ $CONT -ne 0 ]; then    # ignora o primeiro item do array, cujo conteudo é "databases"
     NOME="backup_my_"$banco"_"$DATA".sql"


    echo "Iniciando backup do banco de dados [$banco]"
   # comando que realmente executa o dump do banco de dados
   mysqldump --hex-blob --lock-all-tables -u $USER -p$SENHA --databases $banco > $DIR_DEST_BACKUP/$NOME


   # verifica que se o comando foi bem sucedido ou nao.
   if [ $? -eq 0 ]; then
      echo "Backup Banco de dados [$banco] completo"
   else
      echo "ERRO ao realizar o Backup do Banco de dados [$banco]"
   fi

fi
 CONT=`expr $CONT + 1`
 done


DATA=`date +%Y%m%d_%H%M%S`

echo "Final do backup: $DATA"
}
