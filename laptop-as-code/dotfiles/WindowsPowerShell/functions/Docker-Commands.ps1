function Docker-Command { docker $args }
function Docker-Build($image) { docker build -t $image . }
function Docker-Run-Ptrace { docker run -it --rm --cap-add=SYS_PTRACE --security-opt seccomp:unconfined $args }
function Docker-Bash { docker exec -i -t $args /bin/bash }
function Docker-Stop-Containers { docker st $(docker ps -a -q) }
function Docker-Remove-Images { docker rmi $(docker images -q -f dangling=true) }
function Docker-Remove-Volumes { docker volume rm $(docker volume ls -qf dangling=true) }
function Docker-Remove-Containers { docker rm $(docker ps -a -q) }
function Docker-Remove-Container-With-Image ($imageId) { docker rmi $(docker ps --all --quiet --filter "ancestor=$imageId") }
function Docker-Systen-Prune { docker system prune -f }

function Docker-Compose-Command { docker-compose $args }
function Docker-Machine-Command { docker-machine $args }
function Docker-Machine-Start { docker-machine start $args }
function Docker-Machine-Stop { docker-machine stop $args }
function Docker-Machine-List { docker-machine ls $args }
function Docker-Machine-Ssh { docker-machine ssh $args }

New-Alias d Docker-Command
New-Alias d-build Docker-Build
New-Alias d-run-ptrace Docker-Run-Ptrace
New-Alias d-bash Docker-Bash
New-Alias d-stop-containers Docker-Stop-Containers
New-Alias d-rm-images Docker-Remove-Images
New-Alias d-rm-volumes Docker-Remove-Volumes
New-Alias d-rm-containers Docker-Remove-Containers
New-Alias d-rm-container-from Docker-Remove-Container-With-Image
New-Alias d-prune Docker-Systen-Prune

New-Alias dc Docker-Compose-Command

New-Alias dm Docker-Machine-Command
New-Alias dm-start Docker-Machine-Start
New-Alias dm-stop Docker-Machine-Stop
New-Alias dm-ls Docker-Machine-List
New-Alias dm-ssh Docker-Machine-Ssh

function Docker-Jenkins($name = 'jenkins', $port = '49001', $volumeDir = '/c/dev/servers/jenkins') { docker run -d --name $name -p ${port}:8080 -v ${volumeDir}:/var/jenkins_home -t jenkins }
New-Alias d-jenkins Docker-Jenkins

function Docker-Portainer($name = 'portainer', $port = '5002', $volumeDir = '/c/dev/servers/portainer') { docker run -d --name $name -p ${port}:9000 --privileged -v /var/run/docker.sock:/var/run/docker.sock -v ${volumeDir}:/data portainer/portainer }
New-Alias d-portainer Docker-Portainer

function Docker-Run-Web($name, $image) { docker run -d --name $name -p 80:80 $image }
New-Alias d-run-web Docker-Run-Web

function Docker-Run-Mongo($name = 'mongodb', $port = '27017') { docker run -d --name $name -p ${port}:27017 mongo $args }
New-Alias d-run-mongo Docker-Run-Mongo

function Docker-Run-Mongo($name = 'mongodb', $port = '27017') {
  docker run -d --name $name -p ${port}:27017 mongo $args
}

# docker run -ti --volumes-from=dockerregistry_storage_1 -v $(pwd)/backup:/backup kfinteractive/backup-tools rsync -avz /var/lib/docker/registry/ /backup/
