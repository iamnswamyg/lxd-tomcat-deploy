git submodule add https://github.com/iamnswamyg/spring-mvc-java11.git spring-app/spring-mvc-java11
mvn clean package -f spring-app/spring-mvc-java11/pom.xml
cp spring-app/spring-mvc-java11/target/*.war ./share



