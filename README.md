# kf2-dedicated
Learning to make a KF2 Server inside of Docker

## Creating the Directory for the persistent volume
    sudo mkdir -p $(pwd)/docker/volumes/kf2-data

## Setting permissions for the persistent volume
    sudo chmod 777 $(pwd)/docker/volumes/kf2-data

## Building the docker container
    ## --network host = Builds the docker container over the hosts web connection
    ## -t kf2-dedicated = Names the docker container
    ## $(pwd)/docker/images/kf2_dedicated_docker = the directory of the folder to build from
    docker build --network host -t kf2-dedicated $(pwd)/docker/images/kf2_dedicated_docker

## Running the docker container
## -d = detached/headless
## --net=host = the network it is on, host being the server itself
## -v $(pwd)/docker/volumes/kf2-data:/home/steam/kf2-dedicated/ = setting a persisten volume
## First location is local machine
## Second location is docker container
## --name=kf2-dedicated = name of the container that docker will recognize it
## kf2-dedicated:latest = name of the docker container we are running
    docker run -d --net=host -v $(pwd)/docker/volumes/kf2-data:/home/steam/kf2-dedicated/ --name=kf2-dedicated kf2-dedicated:latest

##For editing files, use the volume you created when doing docker run
##For more information on server settings:
    ##https://wiki.killingfloor2.com/index.php?title=Dedicated_Server_(Killing_Floor_2)
