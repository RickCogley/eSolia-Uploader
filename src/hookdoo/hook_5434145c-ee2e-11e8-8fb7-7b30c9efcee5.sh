#!/bin/sh
# Runs at Webfaction
echo $INPUT > ~/tassy-payload.out
cat ~/tassy-payload.out | php -R 'echo urldecode($argn)."\n";' > ~/tassy-payload-decoded.out
cat ~/tassy-payload-decoded.out | awk -F'&signature=' '{print $2}' > ~/tassy-signature.out
cat ~/tassy-payload-decoded.out | awk -F'&signature=' '{print $1}' > ~/tassy-payload-decoded-pre1.out
cat ~/tassy-payload-decoded-pre1.out | awk -F'transloadit=' '{print $2}' > ~/tassy-result-pre1.out
cat ~/tassy-result-pre1.out | /home/rcogley/bin/jq '.' > ~/tassy-result.out
echo "Done"
