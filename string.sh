function ascii2char() 
{
  echo -e '\x'`printf %x $1`
}

function char2ascii()
{
  printf '%d\n' \'$1
}

function urlencode()
{
  echo "$1" | nkf -WwMQ | sed 's/=$//' | tr -d '\n' | tr = %
}
