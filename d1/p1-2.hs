import qualified Control.Applicative as A
import Data.Functor
import Text.Parsec

data Dir = L | R deriving Show
data Row = Row Dir Int deriving Show
type P   = Parsec String ()

dir = char 'L' $> L <|> char 'R' $> R

int = read <$> many1 digit

row = A.liftA2 Row dir int

rows = row `sepBy` space

solve = snd . foldl (uncurry step) (50, 0)
  where
    step d n (Row dir amt) = (d', n')
      where
        d' = op d amt `mod` 100
        n' = if d' == 0 then n + 1 else n
        op = case dir of
          L -> (-)
          R -> (+)

main = do
  s <- readFile "/home/skanaley/dev/aoc2025/i1"
  case parse rows "" s of
    Left  e -> error $ show e
    Right a -> print $ solve a
