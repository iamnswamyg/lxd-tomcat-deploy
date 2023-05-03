# !/bin/bash

if ! java -version>/dev/null 2>&1; then
  echo "Java not found"
  sudo apt install openjdk-11-jdk -y
fi
if java -version>/dev/null 2>&1; then
   java -version
   sudo apt install tomcat9 tomcat9-admin -y
else
  echo "Java not found"
  exit 1
fi


if ! [ -d "/etc/tomcat9/" ] && ! [ -d "/var/lib/tomcat9/webapps/" ]; then 
 echo "tomcat9 doesn't exist, check tomcat9 installtion"
 exit 1
else
  cp /lxd/*.xml /etc/tomcat9/ 
  cp /tomcat/*.war  /var/lib/tomcat9/webapps/
fi
sudo systemctl restart tomcat9



