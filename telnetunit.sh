#!/bin/bash
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
defaultProfile=default
defaultExtension=conf
containsError=0
profileFound=0

profile=$1
profiles=`find ./profiles/*.$defaultExtension -type f -exec basename {} \; | sed 's/\.[^.]*$//'`
if [ "$#" -eq  "0" ]
  then
  profilesToArray=( $profiles )
  if [ ${#profilesToArray[@]} -gt 1 ]
      then
       PS3='Choose profile number: '
      select choice in ${profiles}; do
        profile=$choice
        echo "------------------------"; break
      done
      else
        profile=$defaultProfile
  fi
fi

if [ -z "$profile" ]; then
    echo "${red} [ERROR] Profile not available, please select right number. $i ${reset}"; exit 1
fi

for i in $profiles; do
  if [[ "$i" = "$profile" ]]; then
    profileFound=1; break
  fi
done

if [ $profileFound -eq 0 ]; then
  echo "${red} [ERROR] Profile not available. ${reset}"; exit 1
fi

input="./profiles/$profile.$defaultExtension"
echo "Loading :" $input ; echo "Checking in progress...⏱️"

while IFS= read -r i; do
  [[ $i =~ ^#.* ]] && continue
  [[ -z "$i" ]] && continue
	netcat -zw 2 $i
	if [ $? -eq 0 ]; then
		  echo "${green} [OK] Telnet accepting connections for : $i ${reset}"
		else
		  echo "${red} [KO] Telnet connections not possible for : $i ${reset}"
		  containsError=1
	fi
done < "$input"

if [ $containsError = 0 ]
  then
    echo Done with success ✅
  else
    echo Done with error ⛔
fi
