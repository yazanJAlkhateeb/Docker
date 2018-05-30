chmod -R 777 /docker/*
chmod -R 777 //docker/artifacts/*
wget -O /bin/docker https://master.dockerproject.org/linux/x86_64/docker
chmod 7 /bin/docker
echo "+--------------------------------------------------+"
echo "| Prepare WAR file                                      |"
echo "+--------------------------------------------------+"
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
docker exec  oracle_database bash -c ". /u01/app/oracle/product/11.2.0/xe/bin/oracle_env.sh && sh /docker/scripts/drop_user.sh"
docker exec  oracle_database bash -c ". /u01/app/oracle/product/11.2.0/xe/bin/oracle_env.sh && sh /docker/scripts/create_user.sh"

echo "+--------------------------------------------------+"
echo "| Starting DB init & Running startup tasks         |"
echo "+--------------------------------------------------+"

cd /usr/local/tomcat/webapps/$PROJ_NAME/WEB-INF/lib
java -jar initializer* psysjo*domain*.jar

echo "+--------------------------------------------------+"
echo "| Executing workflow Scripts						 |"
echo "+--------------------------------------------------+"
docker exec  oracle_database bash -c ". /u01/app/oracle/product/11.2.0/xe/bin/oracle_env.sh && sh /docker/scripts/activate_wf.sh"

catalina.sh jpda run
echo "+--------------------------------------------------+"
echo "| Waiting for $APP_NAME startup                    |"
echo "+--------------------------------------------------+"
#curl http://localhost:8080/$APP_NAME
echo "+--------------------------------------------------+"
echo "| $APP_NAME Started                                |"
echo "+--------------------------------------------------+"
