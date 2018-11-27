#!/bin/sh
# Run by hookdoo and INPUT var is created by the script in the hook
JQBIN="/home/rcogley/bin/jq"
WORKINGDIR="/home/rcogley"

echo ${INPUT} > ${WORKINGDIR}/tassy-payload.out
cat ${WORKINGDIR}/tassy-payload.out | php -R 'echo urldecode($argn)."\n";' > ${WORKINGDIR}/tassy-payload-decoded.out
cat ${WORKINGDIR}/tassy-payload-decoded.out | awk -F'&signature=' '{print $2}' > ${WORKINGDIR}/tassy-signature.out
cat ${WORKINGDIR}/tassy-payload-decoded.out | awk -F'&signature=' '{print $1}' > ${WORKINGDIR}/tassy-payload-decoded-pre1.out
cat ${WORKINGDIR}/tassy-payload-decoded-pre1.out | awk -F'transloadit=' '{print $2}' > ${WORKINGDIR}/tassy-result-pre1.out
cat ${WORKINGDIR}/tassy-result-pre1.out | ${JQBIN} '.' > ${WORKINGDIR}/tassy-result.json

TEMPLATEID=$(cat tassy-result.json | ${JQBIN} --compact-output --raw-output '.template_id')
ASSEMBLYID=$(cat tassy-result.json | ${JQBIN} --compact-output --raw-output '.assembly_id')
ASSEMBLYTS=$(cat tassy-result.json | ${JQBIN} --compact-output --raw-output '.last_job_completed|gsub(" GMT"; "Z")|gsub(" "; "T")|gsub("/"; "-")')

cat ${WORKINGDIR}/tassy-result.json |  ${JQBIN} --raw-output --arg tid "${TEMPLATEID}" --arg aid "${ASSEMBLYID}" --arg ats "${ASSEMBLYTS}" '[.uploads,.results.compress_image | .[] | {template_id: $tid, assembly_id: $aid, assembly_ts: $ats, original_id: .original_id, size: .size, width: .meta.width, last_modified: (.meta.date_file_modified|gsub(" GMT"; "Z")|gsub(" "; "T")|gsub("/"; "-")), ssl_url: .ssl_url}]' > ${WORKINGDIR}/tassy-dbflex-ready.json
