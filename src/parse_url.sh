#!/usr/bin/env bash
function parse_url() {
  # Based on http://stackoverflow.com/a/6174447/151666
  local parse="${1}"
  local need="${2}"

  local proto="$(echo $parse | grep :// | sed -e's,^\(.*://\).*,\1,g')"
  local url="$(echo ${parse/$proto/})"
  local userpass="$(echo $url | grep @ | cut -d@ -f1)"
  local user="$(echo $userpass | grep : | cut -d: -f1)"
  local pass="$(echo $userpass | grep : | cut -d: -f2)"
  local hostport="$(echo ${url/$userpass@/} | cut -d/ -f1)"
  local host="$(echo $hostport | grep : | cut -d: -f1)"
  local port="$(echo $hostport | grep : | cut -d: -f2)"
  local path="$(echo $url | grep / | cut -d/ -f2-)"

  [ -z "${user}" ] && user="${userpass}"
  [ -z "${host}" ] && host="${hostport}"
  if [ -z "${port}" ]; then
    [ "${proto}" = "http://" ]  && port="80"
    [ "${proto}" = "https://" ] && port="443"
    [ "${proto}" = "mysql://" ] && port="3306"
    [ "${proto}" = "redis://" ] && port="6379"
  fi

  if [ -n "${need}" ]; then
    echo ${!need}
  else
    echo ""
    echo " Use second argument to return just 1 variable."
    echo " parse_url() demo: "
    echo ""
    echo "   proto: ${proto}"
    echo "   user:  ${user}"
    echo "   pass:  ${pass}"
    echo "   host:  ${host}"
    echo "   port:  ${port}"
    echo "   path:  ${path}"
    echo ""
  fi
}
