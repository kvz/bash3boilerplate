__dir=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

source "${__dir}/parse_url.sh"
function megamount () {
  local url="${1}"
  local target="${2}"

  proto=$(parse_url "${url}" "proto")
  user=$(parse_url "${url}" "user")
  pass=$(parse_url "${url}" "pass")
  host=$(parse_url "${url}" "host")
  port=$(parse_url "${url}" "port")
  path=$(parse_url "${url}" "path")

  umount -lf "${target}" || true
  mkdir -p "${target}"
  if [ "${proto}" = "smb://" ]; then
    mount -t cifs --verbose -o "username=${user},password=${pass},hard" "//${host}/${path}" "${target}"
  elif [ "${proto}" = "afp://" ]; then
    # start syslog-ng
    # afpfsd || echo "Unable to run afpfsd. Does /dev/log exist?" && exit 1
    mount_afp "${url}" "${target}"
  elif [ "${proto}" = "nfs://" ]; then
    mount -t nfs --verbose -o "vers=3,nolock,soft,intr,rsize=32768,wsize=32768" ${host}:/${path} ${target}
  else
    echo "ERR: Unknown protocol ${proto}"
    exit 1
  fi

  # chmod 777 "${target}"
  ls -al "${target}/"
}
