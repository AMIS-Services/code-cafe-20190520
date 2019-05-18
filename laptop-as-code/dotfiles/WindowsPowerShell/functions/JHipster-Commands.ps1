function JHipster-diff{
    if (Test-Path mvnw){
        ./mvnw compile liquibase:diff
    }else{
        ./gradlew liquibaseDiffChangelog
    }
}
Set-Alias jhdiff JHipster-diff

function jh{ jhipster $args }

function JHipster-upgrade{ jhipster upgrade}
Set-Alias jhupgrade JHipster-upgrade

function JHipster-f{ jhipster --force}
Set-Alias jhf JHipster-f

function JHipster-fe{ jhipster --force --with-entities }
Set-Alias jhfe JHipster-fe

function JHipster-jdl{ jhipster import-jdl $args}
Set-Alias jhjdl JHipster-jdl

function JHipster-jdl-export{ jhipster export-jdl $args}
Set-Alias jhjdle JHipster-jdl-export

function JHipster-e{ jhipster entity $args}
Set-Alias jhe JHipster-e

function JHipster-s{ jhipster spring-service $args}
Set-Alias jhs JHipster-s

function JHipster-c{ jhipster spring-controller $args}
Set-Alias jhc JHipster-c

function JHipster-lang{ jhipster languages $args}
Set-Alias jhlang JHipster-lang

function JHipster-info{ jhipster info}
Set-Alias jhinfo JHipster-info

function JHipster-compose{ jhipster docker-compose}
Set-Alias jhcompose JHipster-compose

function JHipster-rancher{ jhipster rancher-compose}
Set-Alias jhrancher JHipster-rancher

function JHipster-cicd{ jhipster ci-cd}
Set-Alias jhcicd JHipster-cicd

function JHipster-cf{ jhipster cloudfoundry}
Set-Alias jhcf JHipster-cf

function JHipster-heroku{ jhipster heroku}
Set-Alias jhheroku JHipster-heroku

function JHipster-k8s{ jhipster kubernetes}
Set-Alias jhk8s JHipster-k8s

function JHipster-aws{ jhipster aws}
Set-Alias jhaws JHipster-aws

function JHipster-clean{
  if (Test-Path mvnw){
     ./mvnw clean;mvn compile
  }else{
    ./gradlew clean
  }
}
Set-Alias jhclean JHipster-clean

function JHipster-run() {
    if (Test-Path mvnw){
        ./mvnw spring-boot:run
    }else{
        ./gradlew bootRun
    }
}
Set-Alias jhrun JHipster-run
Set-Alias jhserver JHipster-run

function JHipster-client() {
    yarn start
}
Set-Alias jhclient JHipster-client

function JHipster-prod() {
    if (Test-Path mvnw){
        jhclean;./mvnw `-P'prod,swagger';
    }else{
        jhclean;./gradlew -Pprod -Pswagger
    }
}
Set-Alias jhprod JHipster-prod

function JHipster-pack() {
    if (Test-Path mvnw){
        ./mvnw -Pprod package
    }else{
        ./gradlew -Pprod bootRepackage
    }
}
Set-Alias jhpack JHipster-pack

function JHipster-dock() {
    if (Test-Path mvnw){
        ./mvnw -Pprod package docker:build
    }else{
        ./gradlew -Pprod bootRepackage buildDocker
    }
}
Set-Alias jhdock JHipster-dock

function JHipster-gatling() {
    if (Test-Path mvnw){
        ./mvnw gatling:execute
    }else{
        ./gradlew gatlingRun
    }
}
Set-Alias jhgatling JHipster-gatling

function JHipster-appup {docker-compose -f src/main/docker/app.yml up -d}
Set-Alias jhappup JHipster-appup

function JHipster-appdown {docker-compose -f src/main/docker/app.yml down}
Set-Alias jhappdown JHipster-appdown

function JHipster-appstop {docker-compose -f src/main/docker/app.yml stop}
Set-Alias jhappstop JHipster-appstop

function JHipster-applogs {docker-compose -f src/main/docker/app.yml logs --follow}
Set-Alias jhapplogs JHipster-applogs

function JHipster-mysqlup {docker-compose -f src/main/docker/mysql.yml up -d}
Set-Alias jhmysqlup JHipster-mysqlup

function JHipster-mysqldown {docker-compose -f src/main/docker/mysql.yml down}
Set-Alias jhmysqldown JHipster-mysqldown

function JHipster-mysqlstop {docker-compose -f src/main/docker/mysql.yml stop}
Set-Alias jhmysqlstop JHipster-mysqlstop

function JHipster-mysqllogs {docker-compose -f src/main/docker/mysql.yml logs --follow}
Set-Alias jhmysqllogs JHipster-mysqllogs

function JHipster-mariaup {docker-compose -f src/main/docker/mariadb.yml up -d}
Set-Alias jhmariaup JHipster-mariaup

function JHipster-mariadown {docker-compose -f src/main/docker/mariadb.yml down}
Set-Alias jhmariadown JHipster-mariadown

function JHipster-mariastop {docker-compose -f src/main/docker/mariadb.yml stop}
Set-Alias jhmariastop JHipster-mariastop

function JHipster-marialogs {docker-compose -f src/main/docker/mariadb.yml logs --follow}
Set-Alias jhmarialogs JHipster-marialogs

function JHipster-postgresqlup {docker-compose -f src/main/docker/postgresql.yml up -d}
Set-Alias jhpostgresqlup JHipster-postgresqlup

function JHipster-postgresqldown {docker-compose -f src/main/docker/postgresql.yml down}
Set-Alias jhpostgresqldown JHipster-postgresqldown

function JHipster-postgresqlstop {docker-compose -f src/main/docker/postgresql.yml stop}
Set-Alias jhpostgresqlstop JHipster-postgresqlstop

function JHipster-postgresqllogs {docker-compose -f src/main/docker/postgresql.yml logs --follow}
Set-Alias jhpostgresqllogs JHipster-postgresqllogs

function JHipster-mongoup {docker-compose -f src/main/docker/mongodb.yml up -d}
Set-Alias jhmongoup JHipster-mongoup

function JHipster-mongodown {docker-compose -f src/main/docker/mongodb.yml down}
Set-Alias jhmongodown JHipster-mongodown

function JHipster-mongostop {docker-compose -f src/main/docker/mongodb.yml stop}
Set-Alias jhmongostop JHipster-mongostop

function JHipster-mongologs {docker-compose -f src/main/docker/mongodb.yml logs --follow}
Set-Alias jhmongologs JHipster-mongologs

function JHipster-cassandraup {docker-compose -f src/main/docker/cassandra.yml up -d}
Set-Alias jhcassandraup JHipster-cassandraup

function JHipster-cassandradown {docker-compose -f src/main/docker/cassandra.yml down}
Set-Alias jhcassandradown JHipster-cassandradown

function JHipster-cassandrastop {docker-compose -f src/main/docker/cassandra.yml stop}
Set-Alias jhcassandrastop JHipster-cassandrastop

function JHipster-cassandralogs {docker-compose -f src/main/docker/cassandra.yml logs --follow}
Set-Alias jhcassandralogs JHipster-cassandralogs

function JHipster-esup {docker-compose -f src/main/docker/elasticsearch.yml up -d}
Set-Alias jhesup JHipster-esup

function JHipster-esdown {docker-compose -f src/main/docker/elasticsearch.yml down}
Set-Alias jhesdown JHipster-esdown

function JHipster-esstop {docker-compose -f src/main/docker/elasticsearch.yml stop}
Set-Alias jhesstop JHipster-esstop

function JHipster-eslogs {docker-compose -f src/main/docker/elasticsearch.yml logs --follow}
Set-Alias jheslogs JHipster-eslogs

function JHipster-registryup {docker-compose -f src/main/docker/jhipster-registry.yml up -d}
Set-Alias jhregistryup JHipster-registryup

function JHipster-registrydown {docker-compose -f src/main/docker/jhipster-registry.yml down}
Set-Alias jhregistrydown JHipster-registrydown

function JHipster-registrystop {docker-compose -f src/main/docker/jhipster-registry.yml stop}
Set-Alias jhregistrystop JHipster-registrystop

function JHipster-registrylogs {docker-compose -f src/main/docker/jhipster-registry.yml logs --follow}
Set-Alias jhregistrylogs JHipster-registrylogs

function JHipster-kafkaup {docker-compose -f src/main/docker/kafka.yml up -d}
Set-Alias jhkafkaup JHipster-kafkaup

function JHipster-kafkadown {docker-compose -f src/main/docker/kafka.yml down}
Set-Alias jhkafkadown JHipster-kafkadown

function JHipster-kafkastop {docker-compose -f src/main/docker/kafka.yml stop}
Set-Alias jhkafkastop JHipster-kafkastop

function JHipster-kafkalogs {docker-compose -f src/main/docker/kafka.yml logs --follow}
Set-Alias jhkafkalogs JHipster-kafkalogs

function JHipster-consulup {docker-compose -f src/main/docker/consul.yml up -d}
Set-Alias jhconsulup JHipster-consulup

function JHipster-consuldown {docker-compose -f src/main/docker/consul.yml down}
Set-Alias jhconsuldown JHipster-consuldown

function JHipster-consulstop {docker-compose -f src/main/docker/consul.yml stop}
Set-Alias jhconsulstop JHipster-consulstop

function JHipster-consullogs {docker-compose -f src/main/docker/consul.yml logs --follow}
Set-Alias jhconsullogs JHipster-consullogs
