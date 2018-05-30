chmod -R 777 /docker/*
chmod -R 777 /docker/artifacts/*
wget -O /bin/docker https://master.dockerproject.org/linux/x86_64/docker
chmod 7 /bin/docker
echo "+--------------------------------------------------+"
echo "| Prepare WAR file                                      |"
echo "+--------------------------------------------------+"
rm -rf /u01/*
mkdir /u01
rm -rf /usr/local/tomcat/webapps/*
unzip -qo /docker/artifacts/*.war -d /usr/local/tomcat/webapps/$PROJ_NAME
chmod -R 777 /usr/local/tomcat/webapps/*
echo "+--------------------------------------------------+"
echo "| Updating WAR Files                               |"
echo "+--------------------------------------------------+"
. /docker/scripts/updateWarFilesScript.sh

echo "+--------------------------------------------------+"
echo "| Creating Database                                |"
echo "+--------------------------------------------------+"
docker exec  mssql_database bash -c " /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P mssqlP@ssw0rd  -i /docker/scripts/drop_user.sql"
docker exec  mssql_database bash -c " /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P mssqlP@ssw0rd  -i /docker/scripts/create_user.sql"


echo "+--------------------------------------------------+"
echo "| Starting DB init & Running startup tasks         |"
echo "+--------------------------------------------------+"

cd /usr/local/tomcat/webapps/$PROJ_NAME/WEB-INF/lib
java -jar initializer* psysjo*domain*.jar

echo "+--------------------------------------------------+"
echo "| Executing workflow Scripts						 |"
echo "+--------------------------------------------------+"
docker exec  mssql_database bash -c " /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P mssqlP@ssw0rd  -i /docker/scripts/activate_wf.sql"

catalina.sh jpda run
echo "+--------------------------------------------------+"
echo "| Waiting for $APP_NAME startup                    |"
echo "+--------------------------------------------------+"
#curl http://localhost:8080/$APP_NAME
echo "+--------------------------------------------------+"
echo "| $APP_NAME Started                                |"
echo "+--------------------------------------------------+"
