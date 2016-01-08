#!/bin/bash

set -x

alias puppet="bundle exec puppet"

puppet help

if [[ ${PUPPET_VERSION:0:3} == '2.7' ]] ||
   [[ ${PUPPET_VERSION:0:3} == '3.0' ]] ||
   [[ ${PUPPET_VERSION:0:3} == '3.1' ]] ||
   [[ ${PUPPET_VERSION:0:3} == '3.2' ]] ||
   [[ ${PUPPET_VERSION:0:3} == '3.3' ]] ||
   [[ ${PUPPET_VERSION:0:3} == '3.4' ]]
then
    OPT="--debug --manifest production/manifests/site.pp"
else
    OPT="--debug --environmentpath=."
fi

puppet master $OPT --compile=missing1.examble.com
RES1=$?
puppet master $OPT --compile=missing2.examble.com
RES2=$?
fail=0
if [ $RES1 -eq 0 ]
then
    echo 'test 1 did not fail :-('
    fail=1
fi
if [ $RES2 -eq 0 ]
then
    echo 'test 2 did not fail :-('
    fail=1
fi
exit $fail
