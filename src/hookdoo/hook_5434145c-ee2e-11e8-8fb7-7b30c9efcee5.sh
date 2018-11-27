#!/bin/sh
# Run by hookdoo and INPUT var is created by the script in the hook
# Use ${DBFLEXRESTTOKEN} in dbflex load statement
JQBIN="/home/rcogley/bin/jq"
RMBIN="/usr/bin/rm"
WORKINGDIR="/home/rcogley/webapps/hook_transloadit_esdocup"

cd ${WORKINGDIR}
${RMBIN} -rf *

echo ${INPUT} > ${WORKINGDIR}/tassy-payload.out
cat ${WORKINGDIR}/tassy-payload.out | php -R 'echo urldecode($argn)."\n";' > ${WORKINGDIR}/tassy-payload-decoded.out
cat ${WORKINGDIR}/tassy-payload-decoded.out | awk -F'&signature=' '{print $2}' > ${WORKINGDIR}/tassy-signature.out
cat ${WORKINGDIR}/tassy-payload-decoded.out | awk -F'&signature=' '{print $1}' > ${WORKINGDIR}/tassy-payload-decoded-pre1.out
cat ${WORKINGDIR}/tassy-payload-decoded-pre1.out | awk -F'transloadit=' '{print $2}' > ${WORKINGDIR}/tassy-result-pre1.out
cat ${WORKINGDIR}/tassy-result-pre1.out | ${JQBIN} '.' > ${WORKINGDIR}/tassy-result.json

TEMPLATEID=$(cat tassy-result.json | ${JQBIN} --compact-output --raw-output '.template_id')
ASSEMBLYID=$(cat tassy-result.json | ${JQBIN} --compact-output --raw-output '.assembly_id')
ASSEMBLYTS=$(cat tassy-result.json | ${JQBIN} --compact-output --raw-output '.last_job_completed|gsub(" GMT"; "Z")|gsub(" "; "T")|gsub("/"; "-")')

cat ${WORKINGDIR}/tassy-result.json |  ${JQBIN} --raw-output --arg tid "${TEMPLATEID}" --arg aid "${ASSEMBLYID}" --arg ats "${ASSEMBLYTS}" '[.uploads,.results.compress_image | .[] | {"Template Id": $tid, "Assembly Id": $aid, "Assembly TS": $ats, "Original Id": .original_id, "File Size": .size, "File Width": .meta.width, "File Last Modified": (.meta.date_file_modified|gsub(" GMT"; "Z")|gsub(" "; "T")|gsub("/"; "-")), "File URL": .ssl_url}]' > ${WORKINGDIR}/tassy-dbflex-ready.json

curl -X "POST" "https://pro.dbflex.net/secure/api/v2/15331/${DBFLEXRESTTOKEN}/Upload%20Link/create.json" \
     -H 'Content-Type: application/json' \
     -d @${WORKINGDIR}/tassy-dbflex-ready.json
