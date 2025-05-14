#!/bin/bash

OUT="/home/wamasoft/monitoring/textfile_collector/sensors.prom"

i=0
while [ $i -lt 4 ]; do 
	TEMP_FILE="$(mktemp)"
	sensors | awk '
	/^Core [0-9]+:/ {
	  name = $1 "_" $2
	  gsub(":", "", name)
	  gsub("\\+", "", $3)
	  gsub("°C", "", $3)
	  print "hardware_sensor_value{name=\"" name "\"} " $3
	}

	/^fan[0-9]+:/ {
	  name = $1
	  gsub(":", "", name)
	  gsub("RPM", "", $2)
	  print "hardware_sensor_value{name=\"" name "\"} " $2
	}' > "$TEMP_FILE"

	mv "$TEMP_FILE" "$OUT"
	((i++))
	echo "save $i"

	chmod +r "$OUT"
	sleep 14
done
