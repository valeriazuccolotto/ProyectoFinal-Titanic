module Main where

import Data.List (sort, intercalate)
import Data.Char (toUpper)
import Text.Printf (printf)

data Pasajero = Pasajero
  { edad   :: String
  , tarifa :: String
  , sexo   :: String
  } deriving Show

data Stats = Stats
  { sSum    :: Double
  , sMean   :: Double
  , sStd    :: Double
  , sMedian :: Double
  , sMin    :: Double
  , sMax    :: Double
  } deriving Show

computeStats :: [Double] -> Stats
computeStats [] = error "No hay datos disponibles para mostrar"

computeStats xs =
    Stats {
        sSum = suma,
        sMean = promedio,
        sStd = desviacion,
        sMedian = mediana,
        sMin = minimo,
        sMax = maximo }

  where
    n = fromIntegral (length xs)
    suma = sum xs
    promedio = suma / n
    varianza = sum [(x - promedio)^2 | x <- xs] / n
    desviacion = sqrt varianza
    sorted = sort xs
    mid = length xs `div` 2
    mediana = if odd (length xs)
              then sorted !! mid
              else (sorted !! (mid - 1) + sorted !! mid) / 2
    minimo = minimum xs
    maximo = maximum xs

transformText :: String -> Int -> Char -> String
transformText text l padChar =
  let upper = map toUpper text
      collapsed = unwords (words upper)
      currentLen = length collapsed
  in if currentLen > l
     then take l collapsed
     else collapsed ++ replicate (l - currentLen) padChar

splitCSV :: String -> [String]
splitCSV = go False "" []
  where
    go _ acc res [] = res ++ [acc]
    go inQuotes acc res (c:cs)
      | c == '"'  = go (not inQuotes) acc res cs
      | c == ',' && not inQuotes = go inQuotes "" (res ++ [acc]) cs
      | otherwise = go inQuotes (acc ++ [c]) res cs

stripQuotes :: String -> String
stripQuotes s = filter (`notElem` "\"") s

procesarFila :: [String] -> Maybe Pasajero
procesarFila cols
  | length cols >= 12 =
      let age = stripQuotes (cols !! 5)
          fare = stripQuotes (cols !! 9)
          sex = stripQuotes (cols !! 4)
      in if null (words sex)
         then Nothing
         else Just $ Pasajero { edad = age, tarifa = fare, sexo = sex }
  | otherwise = Nothing

longitud :: Int
longitud = 8
caracterPad :: Char
caracterPad = '$'

toDouble :: String -> Maybe Double
toDouble s = case reads s of
               [(x,"")] -> Just x
               _        -> Nothing

formatearStats :: String -> Stats -> String
formatearStats titulo s =
  "Estadisticas de " ++ titulo ++ ":\n" ++
  "  Suma total: " ++ printf "%.2f" (sSum s) ++ "\n" ++
  "  Promedio: " ++ printf "%.2f" (sMean s) ++ "\n" ++
  "  Desviacion estandar: " ++ printf "%.2f" (sStd s) ++ "\n" ++
  "  Mediana: " ++ printf "%.2f" (sMedian s) ++ "\n" ++
  "  Minimo: " ++ printf "%.2f" (sMin s) ++ "\n" ++
  "  Maximo: " ++ printf "%.2f" (sMax s) ++ "\n\n"

main :: IO ()
main = do
  contenido <- readFile "titanic.csv"
  let lineas = lines contenido
  let datosSinEncabezado = drop 1 lineas

  let totalFilas = length datosSinEncabezado
  let pasajerosValidos = [p | linea <- datosSinEncabezado,
                              let cols = splitCSV linea,
                              Just p <- [procesarFila cols]]

  let filasValidas = length pasajerosValidos
  let filasDescartadas = totalFilas - filasValidas

  let edades = [x | p <- pasajerosValidos, Just x <- [toDouble (edad p)]]
  let tarifas = [x | p <- pasajerosValidos, Just x <- [toDouble (tarifa p)]]

  let statsEdad = computeStats edades
  let statsTarifa = computeStats tarifas

  let ejemplosSexo = take 3 $ map (\p ->
        let original = sexo p
            nuevo = transformText original longitud caracterPad
        in original ++ " -> " ++ nuevo) pasajerosValidos

  let salida = "REPORTE DEL TITANIC\n\n" ++
               "Conteo de filas:\n" ++
               "  Total: " ++ show totalFilas ++ "\n" ++
               "  Validas: " ++ show filasValidas ++ "\n" ++
               "  Descartadas: " ++ show filasDescartadas ++ "\n\n" ++
               formatearStats "Edad" statsEdad ++
               formatearStats "Tarifa" statsTarifa ++
               "Ejemplos de transformacion de Sexo:\n" ++
               unlines ejemplosSexo

  writeFile "resultados.txt" salida
  putStrLn "Proceso completado y guardado en resultados.txt :)"