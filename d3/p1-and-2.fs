0 value total
\ 2 constant out-size \ part 1
12 constant out-size \ part 2
100 constant len

len 2 + constant buflen
create buf buflen allot
: b@ ( i -- c ) buf + c@ ;
: dgt ( c -- n ) 48 - ;
: digits ( -- ) buf len + buf ?do i c@ dgt i c! loop ;
: imax ( i j -- k n ) \ find max value and its index
  0 0 { n k }          \ i j
  buf + swap buf + ?do \
    i c@ dup n > if    \ d
      to n             \
      i buf - to k     \
    else
      drop             \
    then
  loop k n ;

create mask len allot
: m@ ( i -- ? ) mask + c@ ;
: mask0 ( -- ) \ we start each row by including the right-most digits
  mask len erase
  mask len + dup out-size - ?do 1 i c! loop ;
: left ( i j -- ) \ swap using a digit at j for a digit farther left at i
  mask + 0 swap c!
  mask + 1 swap c! ;
: .ns ( n -- ) \ dot "no space"
  0 <# #s #> type ;

: show ( @ -- )
  dup len + swap ?do i c@ .ns loop cr ;

: lefts ( -- ) \ repeat left until maxed out
  0 len out-size -  \ i j
  begin
    dup len <       \ i j ?
  while             \ i j
    >r r@ imax      \ mi md (save j)
    r@ b@           \ mi md d
    >= if           \ mi
      dup r@ left   \ mi
    else
      r> 2drop exit \
    then
    1+ r> 1+        \ mi' j' -> i j
  repeat 2drop ;    \

: jolt ( -- n )
  lefts 0    \ n
  len 0 ?do  \ n
    i m@ if  \ n
      10 *   \ n
      i b@ + \ n
    then
  loop ;

: solve-row ( -- )
  digits mask0
  jolt +to total ;

s" /home/skanaley/dev/aoc2025/d3/input.txt" r/o open-file throw value fid

: line ( -- ?neof )
  buf buflen fid read-line throw drop ;

: solve ( -- )
  begin
    line      \ ?
  while       \
    solve-row \
  repeat
  fid close-file throw
  total . cr
  bye ;

solve
