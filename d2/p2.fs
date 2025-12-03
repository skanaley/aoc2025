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

: ?mirror { #w } ( @ c #window -- ? )
  #w / { sz }             \ @
  dup sz + swap ?do       \ i = start @
    i c@ #w 1 ?do         \ j = start @, i = w, ( c -- )
      dup i sz * j + c@ - \ c ?
      if drop 0 unloop unloop exit then
    loop drop             \
  loop -1 ;

: ?any-mirror ( @ c -- ? ) \ actually only needs to check primes, but...
  dup 1 = if 2drop 0 exit then
  dup 1+ 2 ?do
    dup i mod 0= if 2dup i ?mirror if 2drop -1 unloop exit then then
  loop 2drop 0 ;

: mirrors hi 1+ lo ?do i str ?any-mirror if i +to total then loop ;

: solve ( -- )
  !buf if bye then
  begin
    num to lo
    !buf drop
    num to hi
    mirrors
    !buf
  until fid close-file throw total . cr bye ;

solve
