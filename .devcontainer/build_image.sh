#!/bin/bash

PARASOFT_CPPTEST_STD_FOLDER="/opt/parasoft/cpptest/std/2024.1.0"
PARASOFT_CPPTEST_CT_FOLDER="/opt/parasoft/cpptest/ct/2024.1.0"
PARASOFT_SE_GITHUB_PAT=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
GITHUB_AGENT_VERSION=2.319.1

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

docker build --build-arg CPPTEST_STD="${CPPTEST_STD_PACKAGE}" --build-arg CPPTEST_CT="${CPPTEST_CT_PACKAGE}" --build-arg GITHUB_PAT="${PARASOFT_SE_GITHUB_PAT}" --build-arg GITHUB_AGENT_VERSION="${GITHUB_AGENT_VERSION}" -t parasoft_iceoryx_demo .
