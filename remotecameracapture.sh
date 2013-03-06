#!/bin/sh

# Dependencies: Gphoto2 and Geeqie.
# Yes, this is pretty simple and doesn't check errors

gphoto_cmd=gphoto2
imageviewer_cmd=geeqie

echo 'Smile!'
${gphoto_cmd} --capture-image 2>&1 >/dev/null

echo 'Getting picture from the camera..'
latestphoto=$(${gphoto_cmd} -L 2>&1| tail -1 |awk '{print $1}' |sed s/#//)
photoname=$(${gphoto_cmd} -L 2>&1| tail -1 |awk '{print $2}')
${gphoto_cmd} -p ${latestphoto}

echo 'Preview of the picture'
${imageviewer_cmd} ${photoname}

