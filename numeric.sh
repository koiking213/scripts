#16進数のインクリメント
function inc_hex()
{
  num=`printf %d \'$1`
  ((num++))
  printf %c
}
#10進数のインクリメント
function inc_dec()
{
  [ x"${1#0}" == x ] && echo 1 && exit
  echo $((${1#0}+1))
}
