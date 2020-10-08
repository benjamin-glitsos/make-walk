{-# LANGUAGE MultiWayIf #-}

-- TODO: Haskell docker with stack installs inside docker file
-- TODO: use a regex package that is not Text.Regex.Posix

import System.Process

-- Utilities --------------------

split :: Char -> String -> [String]
split c xs = case break (==c) xs
             of   (ls, "") -> [ls]
                  (ls, x:rs) -> ls : split c rs

filterNotNull :: [a] -> [a]
filterNotNull = filter (not . null)

formatName :: String -> String
formatName s = ??? -- TODO: use regex

-- Shell Commands --------------------

ignoredInput :: String -> IO ()
ignoredInput s = s

-- Control Flow --------------------

main :: IO ()
main = getLine >>= split '/' >>> filterNotNull <$> \s ->
    if | matchParentDirectory s -> ???
       | otherwise -> ignoredInput s
    where
        matchParentDirectory = ??? -- TODO: use regex for matching
