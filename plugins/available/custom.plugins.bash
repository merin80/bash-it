
function nethosts() {
  about 'list hosts defined in tarent-rz-net'
  group 'tarent-rz-net'

  if [ $# -lt 1 ]; then
    echo "Usage: nethosts tarentex13 [onlydown]"
  else 

  echo "LDAP-Zweig: \"cn=${1},cn=computers,ou=RZ,dc=tarent,dc=de\""
  echo "Pinge alle Hosts"
  echo "--"

  for arecord in $(ldapsearch -xLLL -b cn=${1},cn=computers,ou=RZ,dc=tarent,dc=de aRecord  | grep ^aRecord: | cut -d" " -f2 | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4); do
    host_name=$(host ${arecord} | cut -d" " -f5)
    ping -c1 -w1 ${arecord} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      if [ "$2" != "onlydown" ]; then
        printf "Host: %s (%s)" "${host_name}" "${arecord}"
        printf " UP \n"
      fi
    else
      printf "Host: %s (%s)" "${host_name}" "${arecord}"
      printf " DOWN \n"
    fi
  done
fi
}
