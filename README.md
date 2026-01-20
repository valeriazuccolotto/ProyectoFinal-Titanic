# Proyecto Final – Programación Funcional en Haskell

## Descripción
Este proyecto aplica los principios del paradigma funcional en Haskell para procesar el dataset Titanic de Kaggle.  
El objetivo es demostrar cómo las funciones puras y operaciones como "map", "filter", "fold" y lambdas pueden integrarse en un flujo de trabajo modular y claro.

El programa realiza:
- Carga y validación de datos (descarta filas inválidas).
- Cálculo de estadísticas descriptivas en columnas numéricas ("Age", "Fare").
- Transformación de texto en la columna "Sex" mediante un pipeline funcional.
- Generación de un archivo de salida ("resultados.txt") con el reporte completo.

## Dataset
- Nombre: Titanic Dataset  
- Enlace: [https://www.kaggle.com/datasets/yasserh/titanic-dataset](https://www.kaggle.com/datasets/yasserh/titanic-dataset)  
- Columnas seleccionadas:
  - `Age` → NUM1  
  - `Fare` → NUM2  
  - `Sex` → TEXT  

## Valores usados
- Longitud fija (L) = 8  
- Carácter de relleno (PAD_CHAR) = `$`  

## Ejecución
Para correr el programa directamente en Haskell:

```bash
runghc ProyectoFinal.hs

Ejemplo de salida:
REPORTE DEL TITANIC

Conteo de filas:
  Total: 340
  Validas: 340
  Descartadas: 0

Estadisticas de Edad:
  Suma total: 7958.75
  Promedio: 29.15
  Desviacion estandar: 14.52
  Mediana: 28.00
  Minimo: 0.83
  Maximo: 71.00

Estadisticas de Tarifa:
  Suma total: 10693.45
  Promedio: 31.45
  Desviacion estandar: 49.69
  Mediana: 14.45
  Minimo: 0.00
  Maximo: 512.33

Ejemplos de transformacion de Sexo:
male -> MALE$$$$
female -> FEMALE$$
female -> FEMALE$$
