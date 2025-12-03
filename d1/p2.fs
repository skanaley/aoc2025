0 value zs

s" /home/skanaley/dev/aoc2025/i1" r/o open-file throw value fid

( -- xt )
: dir fid key-file case
  'L of ['] 1- endof
  'R of ['] 1+ endof
  -1 of zs . cr fid close-file throw bye endof
  dup . abort" unknown val"
endcase ;

( -- amt )
: num 0 fid key-file begin
  swap 10 * swap 48 - +
  fid key-file dup 10 =
until drop ;

( dial -- dial' )
: row dir swap num 0 do
  over execute 100 mod
  dup 0= if 1 +to zs then
loop nip ;

: solve 50 begin row again ;

solve
