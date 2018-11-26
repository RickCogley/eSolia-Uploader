#!/bin/sh
JQBIN="/home/rcogley/bin/jq"

echo $INPUT > ~/tassy-payload.out
cat ~/tassy-payload.out | php -R 'echo urldecode($argn)."\n";' > ~/tassy-payload-decoded.out
cat ~/tassy-payload-decoded.out | awk -F'&signature=' '{print $2}' > ~/tassy-signature.out
cat ~/tassy-payload-decoded.out | awk -F'&signature=' '{print $1}' > ~/tassy-payload-decoded-pre1.out
cat ~/tassy-payload-decoded-pre1.out | awk -F'transloadit=' '{print $2}' > ~/tassy-result-pre1.out
cat ~/tassy-result-pre1.out | ${JQBIN} '.' > ~/tassy-result.json

TEMPLATEID=$(cat tassy-result.json | jq --compact-output --raw-output '.template_id')
ASSEMBLYID=$(cat tassy-result.json | jq --compact-output --raw-output '.assembly_id')
ASSEMBLYTS=$(cat tassy-result.json | jq --raw-output '.last_job_completed|gsub(" GMT"; "Z")|gsub(" "; "T")|gsub("/"; "-")')
