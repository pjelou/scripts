#! /bin/bash
# any2mp3.sh
# Converts to mp3 anything mplayer can play
# Needs mplayer amd lame installed
[ $1 ] || { echo "Usage: $0 file1.wma file2.wma"; exit 1; }

yum -y install http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
yum install -y lame mplayer

for i in "$@"
do
    [ -f "$i" ] || { echo "File $i not found!"; exit 1; }
done

[ -f audiodump.wav ] && {
    echo "file audiodump.wav already exists"
    exit 1
}

for i in "$@"
do
    ext=`echo $i | sed 's/[^.]*\.\([a-zA-Z0-9]\+\)/\1/g'`
    j=`basename "$i" ".$ext"`
    j="$j.mp3"
    echo
    echo -n "Extracting audiodump.wav from $i... "
    mplayer -vo null -vc null -af resample=44100 -ao pcm:waveheader:fast \
    "$i" >/dev/null 2>/dev/null || {
        echo "Problem extracting file $i"
        exit 1
    }
    echo "done!"
    echo -n "Encoding to mp3... "
    lame -m s audiodump.wav -o "$j" >/dev/null 2>/dev/null
    echo "done!"
    echo "File written: $j"
done
# delete temporary dump file
rm -f audiodump.wav