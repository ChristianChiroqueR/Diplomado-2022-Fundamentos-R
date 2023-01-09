# SESIÓN 3: TIDYVERSE - PRINCIPALES FUNCIONES ----

# Importación de datos ----

# Tú puedes importar con librerías como "rio" (entre otros paquetes)...

library(rio)
copas_rio<-import("WorldCups.csv")
class(copas_rio)
str(copas_rio)
copas_rio

# Pero se sugiere importar con la librería readr

## Archivos CSV ----
copas<-read_csv("WorldCups.csv")
str(copas)
class(copas) # Las clases las leemos de derecha a izquierda. Las dos primeras son especificaciones (subclases) de tibble. 
copas
# https://www.kaggle.com/datasets/abecklas/fifa-world-cup

# Si se trata de un excel pueden usar la librería readxl

## Archivos XLSX ----
library(readxl)
copas_xlsx<-read_xlsx("WorldCups.xlsx")
str(copas)
class(copas_xlsx)


## Archivos SAV (SPSS) ----
library(haven)
lapop_spss<-read_spss("sub_lapop.sav")
class(lapop_spss)
str(lapop_spss) # Por qué se ve diferente que los dos anteriores?

# Ingresando a los atributos de objetos
attributes(lapop_spss)
attributes(lapop_spss$interes)

# Puedes ingresar de forma detallada
lapop_spss$sexo %>% attr('label')
lapop_spss$sexo %>% attr('labels')


# Y si es una base de datos que se encuentra en un repositorio en línea?

## Archivos desde un repositorio GitHub ----
link<-"https://raw.githubusercontent.com/ChristianChiroqueR/Diplomado-2022-Fundamentos-R/main/BDs/WorldCups.csv"
copas_GH<-read_csv(link)
str(copas_GH)
class(copas_GH) # Las clases las leemos de derecha a izquierda. Las dos primeras son especificaciones (subclases) de tibble. 
copas_GH


## Archivos desde un Google Sheet ----

library("googlesheets4")

## Ejercicio para resolver en casa ---- 
# 1) Suba el archivo WorldCup.csv en su Google Drive personal (google sheet).
# 2) Importe el Drive (google sheet) usando el paquete "googlesheets4". 


# DPLYR: Gramática para manipulación de datos ----

# Utilizamos el El Operador pipe |>
# Si no cuentan con una versión actualizada de R, también pueden usar %>% 
# SHORTCUT : CONTROL + SHIFT + M
# Problema original: Funciones anidadas (Nested functions)



## DATA: Copas del mundo ----
names(copas)

# Year: Year of the worldcup
# Country: Country of the worldcup
# Winner: Team who won the worldcup
# Runners-Up: Team who was the second place
# Third: Team who was the third place
# Fourth: Team who was the fourth place
# GoalsScored: Total goals scored in the worldcup
# QualifiedTeams: Total participating teams
# MatchesPlayed: Total matches played in the cup
# Attendance: Total attendance of the worldcup

## FUNCIONES PRINCIPALES ----

## Función SELECT ----
# Selecciona columnas 

# SIN PIPE: 
select(.data= copas, Winner, Attendance)

# CON PIPE: 
copas |> select(Winner)

copas |> select(2,7,10)

## Función FILTER ----
# Filtra las filas de acuerdo a ciertos criterios

# SIN PIPE:
filter(.data=copas, Country== "France")

# CON PIPE:
copas |> filter(Country== "France")

copas |> filter(Year>1950)

copas |> filter(Year>1950 | GoalsScored>150)

copas |> filter(Year>1950 & GoalsScored>150)

## Función ARRANGE ----
# Ordena las columnas de acuerdo a ciertos criterios.
# Los NA los deja al final. Para eliminar NA de un vector puedes usar drop_na().


# SIN PIPE: 
arrange(.data=copas, GoalsScored)

# CON PIPE: 
copas |> arrange (GoalsScored) #En el caso de numérica, se ordena de forma ascendente por default 

copas |> arrange (desc(GoalsScored))

copas |> arrange (GoalsScored, MatchesPlayed) # Puedes incluir más de un criterio


## Función SUMMARISE ---- 
## Sirve para crear estadísticas resumen (con grupos o sin grupos)

### FUNCIONES VECTORIZADAS: Que se aplican a un VECTOR

# Tendencia central: mean(), median()
# Dispersión: sd(), IQR()
# Rango: min(), max(), quantile()
# Conteo: n(), n_distinct()

## SIN PIPE:
summarise(.data=copas, mean(GoalsScored))

## CON PIPE:

# Tendencia central: mean(), median()
copas |> 
  summarise(mean(GoalsScored))

copas |> 
  summarise(median(GoalsScored))

# Dispersión: sd(), IQR()
copas |> 
  summarise(sd(GoalsScored))

# Rango: min(), max(), quantile()
copas |> 
  summarise(min(GoalsScored))

copas |> 
  summarise(maximo=max(GoalsScored), minimo=min(GoalsScored))

# Conteo: n_distinct()
copas |> 
  summarise(n_distinct(Country))


## Función MUTATE ---- 
# Agrega nuevas variables (y preserva las que ya existen)

# SIN PIPE:
mutate(.data=copas, nueva_variable=1)

# CON PIPE:
ej1<-copas |> mutate(nueva_variable=1)
View(ej1)

ej1<-copas |> mutate(antiguedad=2023-Year) # Calculamos la antiguedad como nueva variable
View(ej1)

ej1<- copas |>  mutate(goles_acumulados=cumsum(GoalsScored)) #Nueva variable: Acumulado de goles
View(ej1)

 
copas_new<-copas |>  mutate(numero_goles_categorica=case_when(GoalsScored<100~"Bajo", 
                                  GoalsScored<150~"Medio", 
                                  TRUE ~ "Alto"))
View(copas_new)
# https://dplyr.tidyverse.org/reference/case_when.html


## Función GROUP_BY -----
# Agrupa los datos de acuerdo a categorías. 
# OJO: Si se desea desagrupar colocar ungroup() como una nueva sentencia 

# SIN PIPE
group_by(.data=copas_new, numero_goles_categorica)
# Qué sucedió?

summarise(group_by(.data=copas_new, numero_goles_categorica), mean(GoalsScored))


# CON PIPE
# Utilizando el pipe para evitar las funciones anidadas 
copas_new |> 
  group_by(numero_goles_categorica) |> 
  summarise(promedio_goles=mean(GoalsScored))


copas_new |> 
  filter(Country=="France") |> 
  group_by(numero_goles_categorica) |> 
  summarise(promedio_goles=mean(GoalsScored)) |> 
  arrange(promedio_goles)



## FUNCIONES COMPLEMENTARIAS ----

### Función COUNT() ----
# Cuenta el número de filas en cada grupo definido por la variable

copas_new |> 
  count(numero_goles_categorica) |> 
  mutate(porcentaje= prop.table((n))*100) 

# Serviría aplicarlo a una numérica?  
copas_new |> 
  count(GoalsScored)


### Función SLICE() ----
# Selecciona filas por su posición (complemento de filter())

copas_new |> 
  slice(1:10)

### Función TRANSMUTATE() ----

# En qué se diferencia del mutate?
copas |> 
  mutate(antiguedad=2023-Year) |> 
  View()

copas |> 
  transmute(antiguedad=2023-Year) |> 
  View()


### Función RENAME() ----

copas_new |> 
  rename(goles_categorica = numero_goles_categorica) |> 
  View()

# colnames(data)=c("nombre1", "nombre2",...)

### Función FILTER() con %in% ----
# Facilita crear condiciones con categóricas

copas |> filter(Country %in% c("France", "Brazil"))


### Función add_row()
# Agrega una o más filas a la tabla

copas |> 
  add_row(Year=2022, 
          Country="Qatar", 
          Winner = "Argentina",
          `Runners-Up`= "Francia") |> 
  View()


## DATA RELACIONAL ----

# Varias tablas relacionadas entre sí por una variable clave (KEY VARIABLE)

# Una base de datos relacional es un tipo de base de datos que almacena 
# y proporciona acceso a puntos de datos relacionados entre sí. 
# Las bases de datos relacionales se basan en el modelo relacional, 
# una forma intuitiva y directa de representar datos en tablas. 
# En una base de datos relacional, cada fila en una tabla es un registro 
# con una ID única, llamada clave. Las columnas de la tabla contienen los 
# atributos de los datos y cada registro suele tener un valor para cada 
# atributo, lo que simplifica la creación de relaciones entre los puntos 
# de datos.

# Mutating joins, which add new variables to one data frame 
# from matching observations in another.

### Función LEFTJOIN() ----
# Data de las copas mundiales (eventos)

names(copas_new)
names(partidos)

partidos |> 
  left_join(copas_new[,c(1,3)], by= "Year") 


## BIBLIOGRAFÍA RECOMENDADA ----

### Libro/Lectura recomendada ----

# Puedes revisar la guía oficial de POSIT (Empresa dueña de R Studio) sobre DPLYR
# Ahí puedes encontrar las funciones presentadas en esta clase y más. 

browseURL("https://github.com/rstudio/cheatsheets/blob/main/data-transformation.pdf")

# También el capítulo sobre data relacional de R for Data Science. 

browseURL("https://r4ds.had.co.nz/relational-data.html")

### Video recomendado ----

browseURL("https://www.youtube.com/watch?v=IMpXB30MP48")




