#!/bin/bash

PARASOFT_CPPTEST_STD_FOLDER="/opt/parasoft/cpptest/std/2024.1.0"
PARASOFT_CPPTEST_CT_FOLDER="/opt/parasoft/cpptest/ct/2024.1.0"

regex=".* ([0-9]{4}\.[0-9]{1}\.[0-9]{1}) \(([0-9\.]+)B([0-9]+)\).*([0-9]{4}).*"

if [[ $(${PARASOFT_CPPTEST_STD_FOLDER}/cpptestcli -version) =~ $regex ]]
then
  std_version="${BASH_REMATCH[1]}"
fi

if [[ $(${PARASOFT_CPPTEST_CT_FOLDER}/cpptestct -version) =~ $regex ]]
then
  ct_version="${BASH_REMATCH[1]}"
fi

CPPTEST_STD_PACKAGE="parasoft_cpptest_std_${std_version}.tar.gz"
CPPTEST_CT_PACKAGE="parasoft_cpptest_ct_${ct_version}.tar.gz"

if [[ ! -f "./${CPPTEST_STD_PACKAGE}" ]]; then
  tar -C ${PARASOFT_CPPTEST_STD_FOLDER} -czvf "./${CPPTEST_STD_PACKAGE}" .
fi

if [[ ! -f "./${CPPTEST_CT_PACKAGE}" ]]; then
  tar -C ${PARASOFT_CPPTEST_CT_FOLDER} -czvf "./${CPPTEST_CT_PACKAGE}" .
fi

docker build --build-arg CPPTEST_STD="${CPPTEST_STD_PACKAGE}" --build-arg CPPTEST_CT="${CPPTEST_CT_PACKAGE}" -t parasoft_iceoryx_demo .
