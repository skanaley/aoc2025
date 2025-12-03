0 value lo
0 value hi
0 value total
create buf 1 allot

s" /home/skanaley/dev/aoc2025/i2" r/o open-file throw value fid

( -- ?eof )
: !buf buf 1 fid read-line throw drop 0= ;

: num ( -- n ) \ buf already primed
  0 begin
    10 * buf c@ 48 - +
    !buf if exit then
    buf c@ 48 58 within 0=
  until ;

: str ( n -- @ c )
  s>d <# #s #> ;

: ?odd ( n -- ? )
  2 mod ;

: ?mirror ( @ c -- ? )
  dup ?odd if 2drop 0 exit then
  2 / swap
  2dup + swap ?do
    i c@ over i + c@ - if drop 0 unloop exit then
  loop drop -1 ;

: mirrors hi 1+ lo ?do i str ?mirror if i +to total then loop ;

: solve ( -- )
  !buf if bye then
  begin
    num to lo
    !buf
    num to hi
    mirrors
    !buf
  until fid close-file throw total . cr bye ;

solve
