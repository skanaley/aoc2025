import qualified Control.Applicative as A
import Data.Functor
import Text.Parsec

data Dir = L | R deriving Show

data Row = Row {
    rowDir :: Dir
  , rowAmt :: Int
  } deriving Show

type P = Parsec String ()

dir :: P Dir
dir = char 'L' $> L
  <|> char 'R' $> R

int :: P Int
int = read <$> many1 digit

row :: P Row
row = A.liftA2 Row dir int

rows :: P [Row]
rows = row `sepBy` space

solve :: [Row] -> Int
solve = snd . foldl (uncurry step) (50, 0)
  where
    step :: Int -> Int -> Row -> (Int, Int)
    step d n r = (d', n')
      where
        d' = op d (rowAmt r) `mod` 100
        n' = if d' == 0 then n + 1 else n
        
        op :: Int -> Int -> Int
        op = case rowDir r of
          L -> (-)
          R -> (+)

--testRow :: String
--testRow = "L32\nR5"

main :: IO ()
main = do
  s <- readFile "/home/skanaley/dev/aoc2025/i1"
  case parse rows "" s of
    Left  e -> error $ show e
    Right a -> print $ solve a
