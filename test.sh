mkdir test1 test2 
if ! [ -d "test1" ] && ! [ -d "test2" ]; then 
 echo "/etc/tomcat9/ doesn't exist, check tomcat9 installtion"
 exit 1
else
 echo "cp /lxd/*.xml /etc/tomcat9/" 
 echo "cp /tomcat/*.war  /var/lib/tomcat9/webapps/"
fi
rm -rf test1 test2