sed -i 's@C:/temp@/u01/communication-folders/core@g' /usr/local/tomcat/webapps/psysjo/WEB-INF/classes/config/product/camel/communication.properties
sed -i 's@C:/temp@/u01/communication-folders/core@g' /usr/local/tomcat/webapps/psysjo/WEB-INF/classes/config/product/camel/core.properties
sed -i 's@C:/temp@/u01/communication-folders/integration@g' /usr/local/tomcat/webapps/psysjo/WEB-INF/classes/config/app/camel/app-camel-settings.properties
sed -i 's@D:/temp@/u01/communication-folders/integration@g' /usr/local/tomcat/webapps/psysjo/WEB-INF/classes/config/app/camel/app-camel-settings.properties
sed -i 's@C:/temp@/u01/communication-folders/converter@g' /usr/local/tomcat/webapps/psysjo/WEB-INF/classes/config/product/camel/converter.properties
sed -i 's/setup.enabled=false/setup.enabled=true/g' /usr/local/tomcat/webapps/psysjo/WEB-INF/properties/startup.properties