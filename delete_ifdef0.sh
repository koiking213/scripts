#!/bin/bash 
#if 0(++) -> endif(--)
#if 0(++) -> else(--) -> endif
#if 1 -> endif
#if 1 -> else(++) -> endif(--)

# 未定義変数を使用するとエラー
set -u
# case構文のパターンマッチング強化
shopt -s extglob

COMMENT_LEVEL=0
IF1_FLAG=false #if 1の構文中
IFX_FLAG=false #if defined(...) のようなその他の構文中
ELSE_FLAG=false

while IFS= read -r line
  do
  case "$line" in 
      *'#if 0'*)
          $ELSE_FLAG && { echo "error: unexpected if0"; exit; }
          ((COMMENT_LEVEL++))
          ;;
      *'#if 1'*) 
          { $IFX_FLAG || $IF1_FLAG || $ELSE_FLAG; } && { echo "error: unexpected if1"; exit; }
          IF1_FLAG=true
          ;;
      *'#if'*)
          { $IFX_FLAG || $ELSE_FLAG; } && { echo "error: unexpected ifdef"; exit; }
          IFX_FLAG=true
          ((COMMENT_LEVEL == 0)) && echo "$line"
          ;;
      *'#elif'*)
         
          echo "error: unexpected elif"
          exit
          ;;
      *'#else'*)
          if $IFX_FLAG; then
              ((COMMENT_LEVEL == 0)) && echo "$line"
          else
              $ELSE_FLAG && { echo "error: unexpected else"; exit; }
              #if 0 -> else
              $IF1_FLAG || ((COMMENT_LEVEL = COMMENT_LEVEL - 1))
              #if 1 -> else
              $IF1_FLAG && ((COMMENT_LEVEL++))
              ELSE_FLAG=true
          fi
          ;;
      *'#endif'*)
          if $IFX_FLAG; then
              IFX_FLAG=false
              ((COMMENT_LEVEL == 0)) && echo "$line"
          else
              #if 0 -> endif
              $IF1_FLAG || { $ELSE_FLAG || ((COMMENT_LEVEL = COMMENT_LEVEL - 1)); }
              #if 0 -> else -> endif
                # nothing to do
              #if 1 -> endif
                # nothing to do
              #if 1 -> else -> endif
              $IF1_FLAG && { $ELSE_FLAG && ((COMMENT_LEVEL = COMMENT_LEVEL - 1)); }
              # common
              IF1_FLAG=false
              ELSE_FLAG=false
          fi
          ;;
      *)
          ((COMMENT_LEVEL == 0)) && echo "$line"
          ;;
  esac
  # debug
  ((COMMENT_LEVEL < 0 )) && { echo "error: comment level is invalid."; exit; }
done <$1
