FROM centos:latest
MAINTAINER penguinbeam
WORKDIR /opt/myalfresco
RUN yum -y upgrade && yum install -y java-1.8.0-openjdk wget
RUN wget http://mirror.ox.ac.uk/sites/rsync.apache.org/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz -O /opt/apache-maven-3.3.9-bin.tar.gz
RUN wget http://repo.spring.io/release/org/springframework/springloaded/1.2.5.RELEASE/springloaded-1.2.5.RELEASE.jar -O /opt/springloaded-1.2.5.RELEASE.jar
RUN tar -xzf /opt/apache-maven-3.3.9-bin.tar.gz -C /usr/local
RUN ln -s /usr/local/apache-maven-3.3.9 /usr/local/maven
RUN echo "export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk-1.8.0.77-0.b03.el7_2.x86_64/" > /etc/profile.d/java.sh
RUN echo "export M2_HOME=/usr/local/maven" > /etc/profile.d/maven.sh
RUN echo "export PATH=\${M2_HOME}/bin:\${PATH}" >> /etc/profile.d/maven.sh
RUN echo "export MAVEN_OPTS='-Xms1024m -Xmx1G -javaagent:/opt/springloaded-1.2.5.RELEASE.jar -noverify'" >> /etc/profile.d/maven.sh
ENV JAVA_HOME /usr/lib/jvm/jre-1.8.0-openjdk-1.8.0.77-0.b03.el7_2.x86_64/
ENV M2_HOME /usr/local/maven
ENV PATH ${M2_HOME}/bin:${PATH}
ENV MAVEN_OPTS "-Xms1024m -Xmx1G -javaagent:/opt/springloaded-1.2.5.RELEASE.jar -noverify"
#RUN mvn archetype:generate -Dfilter=org.alfresco:
RUN cd /opt && mvn archetype:generate -DarchetypeGroupId=org.alfresco.maven.archetype -DarchetypeArtifactId=alfresco-allinone-archetype -DarchetypeVersion=2.1.1 -DgroupId=org.soc -DartifactId=myalfresco -Dversion=1.0-SNAPSHOT -DarchetypeRepository=https://artifacts.alfresco.com/nexus/content/repositories/releases -DinteractiveMode=false
RUN cd /opt/myalfresco && mvn clean install -Prun
CMD ["/bin/bash"]
