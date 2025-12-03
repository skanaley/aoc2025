0 value zs

s" /home/skanaley/dev/aoc2025/i1" r/o open-file throw value fid

: dir fid key-file case
  'L of ['] - endof
  'R of ['] + endof
  -1 of zs . cr fid close-file throw bye endof
  dup . abort" unknown val"
endcase ;

: num 0 fid key-file begin
  swap 10 * swap 48 - +
  fid key-file dup 10 =
until drop ;

: row dir num swap execute 100 mod
dup 0= if 1 +to zs then ;

: solve 50 begin row again ;

solve
