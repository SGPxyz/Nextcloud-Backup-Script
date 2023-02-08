#!/usr/bin/env bash
###################################### NEXTCLOUD BACKUP SCRIPT ########################################
#
# NEXTCLOUD BACKUP SCRIPT is a simple bash script allowing to automatically backuping your Nextcloud instance
# based on the guidelines of the official documentation
#
# Copyright (C) 2022 CypherXXX
# Conceptually based on Nextcloud Official documentation:
# https://docs.nextcloud.com/server/latest/admin_manual/maintenance/backup.html
# 
# If you like my work, use it or just want to support the development of this script:
# buymeacoffee.com/cypherxxxx https://paypal.me/cypherx
# https://paypal.me/cypherx?country.x=FR&locale.x=fr_FR
########################################################################################################

##### Variable
RED="31"
GREEN="32"
BOLDGREEN="\e[1;${GREEN}m"
ITALICRED="\e[3;${RED}m"
ENDCOLOR="\e[0m"


echo -e "${BOLDGREEN}Welcome to the Nextcloud Backup Script.${ENDCOLOR}"
echo "This script comes with absolutely no warranty, and use it at your own risk.
We strongly advise that you use this script for some times in your dev environment 
before using it in full production, in case of bugs or situation not covered in the
cases we've made"
echo " To use this script your config folder must be named 'config', your themes folder is named 'themes' and your data folder is 
named 'nextcloud-data'"

#### Config Folder Path
echo "Full path of you Nextcloud installation folder wich contain your config folder (ex:/var/www/nextcloud/)"
read config_folder_path
config_folder_path=$config_folder_path/config
#### Path validation
if [ -d "$config_folder_path" ];
then
    echo "Your config folder path is" $config_folder_path
else
    echo "Warning $config_folder_path directory does not exist. Please double your Config folder path. It usually can be located here: /var/www/nextcloud"
    exit 1
fi

#### Theme Folder Path
echo "Full path of you Nextcloud installation folder wich contain your theme folder (ex:/var/www/nextcloud/)"
read theme_folder_path
theme_folder_path=$theme_folder_path/theme
if [ -d "$theme_folder_path" ];
then
    echo "Your theme folder path is" $theme_folder_path
else
    echo "Warning $theme_folder_path directory does not exist. Please double your Config folder path. It usually ca>
    exit 1
fi

#### Data Folder Path
echo "Full path of you Nextcloud installation folder wich contain your data folder (ex:/var/www/nextcloud/)"
read data_folder_path
data_folder_path=$data_folder_path/theme
if [ -d "$data_folder_path" ];
then
    echo "Your data folder path is" $data_folder_path
else
    echo "Warning $data_folder_path directory does not exist. Please double your Config folder path. It usually ca>
    exit 1
fi

echo Every path are correct
echo "Where would like to store your data,theme and config backup folder ? 2 Method supported:
1. Remote Host
2. On the same machine
Please select the method:"
read backup_method

############ Files Backuping
if [ backup_method == 1 ]
then
echo "Select the path where you the data, theme and config backup folder to be saved"
read nextcloud_backup_path

echo "Putting Nextcloud in maintenance mode /!\ in case of cancelling the script at this point you will have
to manually put Nextcloud Maintenance mode off (ex: sudo -u www-data php occ maintenance:mode --off"
sudo -u www-data php occ maintenance:mode --on
echo "Backuping config folder to the desired directory"
rsync -Aavx $config_folder_path $nextcloud_backup_path/nextcloud-config-dirbkp_`date +"%Y%m%d"`/
echo done

echo "Backuping ttheme folder to the desired directory"
rsync -Aavx $theme_folder_path $nextcloud_backup_path/nextcloud-theme-dirbkp_`date +"%Y%m%d"`/
echo done

echo "Backuping data folder to the desired directory. Depending on it size it can take some times to finish"
rsync -Aavx $data_folder_path $nextcloud_backup_path/nextcloud-data-dirbkp_`date +"%Y%m%d"`/
echo done
######### End Files Backuping


####### DATABASE Backuping

echo "Please your database type (currently supported:Mysql/Mariadb):
1.Mariadb/Mysql
2.Mysqlite
3.PostgreSQL"
read database_type

if [ database_type==1]
	echo "What's your database nextcloud user?"
	read nextcloud_database_user
	echo "What's your database name?"
	read nextcloud_database_name
	mysqldump --single-transaction -h localhost -u $nextcloud_database_user -p $nextcloud_database_name > $nextcloud_folder_path/nextcloud-database-sqlbkp_`date +"%Y%m%d"`.bak

elif [ database_type==2 ]
	exit 1
elif [ database_type==3 ]
	exit 1
else 
	exit 1
##### END DATABASE Backuping


elif [ backup_method == 2 ] 
then
	exit 1
else
    exit 1
fi



