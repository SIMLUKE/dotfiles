#!/bin/bash
# Specify destination folder to mount your project into docker
DEST_FOLDER=/home/student/
docker run --rm -v ".:$DEST_FOLDER" -it epitechcontent/epitest-docker /bin/bash -c 'useradd student && su - student'
