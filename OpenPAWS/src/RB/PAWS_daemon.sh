cd /PAWS/

while [ ! -f "config.cfg" ]
do
	sleep 10
done

/PAWS/repeat_query.sh
