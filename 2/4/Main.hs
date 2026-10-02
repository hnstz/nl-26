import Data.Array

lcsLength :: String -> String -> Array (Int, Int) Int
lcsLength xs ys = arr
  where
    m = length xs
    n = length ys
    arr = array ((0,0), (m,n))
          [ ((i,j), cell i j) | i <- [0..m], j <- [0..n] ]
    cell 0 _ = 0
    cell _ 0 = 0
    cell i j
      | xs !! (i-1) == ys !! (j-1) = arr ! (i-1, j-1) + 1
      | otherwise = max (arr ! (i-1, j)) (arr ! (i, j-1))

lcs :: String -> String -> String
lcs xs ys = backtrack (length xs) (length ys)
  where
    arr = lcsLength xs ys
    backtrack 0 _ = []
    backtrack _ 0 = []
    backtrack i j
      | xs !! (i-1) == ys !! (j-1) = xs !! (i-1) : backtrack (i-1) (j-1)
      | arr ! (i-1, j) >= arr ! (i, j-1) = backtrack (i-1) j
      | otherwise = backtrack i (j-1)

main :: IO ()
main = do
    let s1 = "ACCGGTCGAGTGCGCGGAAGCCGGCCGAA"
        s2 = "GTCGTTCGGAATGCCGTTGCTCTGTAAA"
    putStrLn $ "Строка 1 (длина " ++ show (length s1) ++ "): " ++ s1
    putStrLn $ "Строка 2 (длина " ++ show (length s2) ++ "): " ++ s2
    putStrLn $ "Длина LCS: " ++ show (lcsLength s1 s2 ! (length s1, length s2))
    putStrLn $ "LCS: " ++ lcs s1 s2