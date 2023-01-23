# SESIÓN 5: DATOS PERDIDOS ----

library(pacman)
p_load("VIM","DEoptimR","minqa","nloptr","simputation", "mice", "tidyverse", "DMwR2")

#DMwR

# OBTENCIÓN DE DATOS ----

# En la librería VIM existen diversos datasets de ejemplo:
help(tao)
data(tao)
head(tao)
summary(tao)

# QUÉ ES UN VALOR PERDIDO PARA EL R? -----

help(NA)


# DIAGNÓSTICO DE DATOS PERDIDOS ----

## Primera identificación ----

# Ver la cantidad y porcentaje de valores perdidos

### Según toda la data -----

# Descriptivo:

any_na(tao)

n_miss(tao)

prop_miss(tao$Sea.Surface.Temp)

pct_miss(tao)

n_complete(tao)

### Según variable -----

miss_var_summary(tao)

miss_var_table(tao)

### Según casos -----

miss_case_summary(tao)

miss_case_table(tao)

## Gráficamente -----

vis_miss(tao) # Primera visualización macro

gg_miss_case(tao) # Número de casos según número de valores perdidos.

gg_miss_upset(tao) #Valores perdidos de acuerdo a posibles combinaciones.


# Podemos utilizar el Aggregation plot

a=aggr(tao,numbers=T)
a
summary(a)
aggr(tao,numbers=T, sortComb=TRUE, sortVar=TRUE, only.miss=TRUE)
# Leer los patrones de manera horizontal...

# Gráfico según niveles de una variable?


# IDENTIFICACIÓN DE PATRÓN DE VP ----

## Mecanismo completamente aleatorio (MCAR)?  
## O mecanismo aleatorio (MAR)?

matrixplot(tao)
# Foto de tu dataset en colores.
# Rojo: Los datos faltantes
# Escala de grises según valores de vectores numéricos
# Para poder inspeccionar necesitamos que la gráfica sea interactiva y utilizamos x11()
x11()
matrixplot(tao)

# Analicemos la variable Humedad: sería MCAR o MAR?
# MCAR: Valores perdidos no debería coincidir con ningún patrón en las otras variables. Aleatoriamente
# MAR: Valores perdidos coinciden con ciertos valores de otras variables. 
# Con Uwind y Wwind sí parece ser MCAR. 
# Pero qué pasa con Air.Temp?
# Suele perderse datos de la humedad cuando la temperatura suele ser baja

# Ejercicio: Analicemos la variable Air.Temp?

# Podemos hacer una prueba más minuciosa con un boxplot
# Pregunta: Cómo se vería la distribución de las otras variables
# cuando tenemos datos perdidos/presentes de una variable en particular?

# Probemos con tres variables una casi completa (Sea.Surface.Temp)
# y dos con amplio NA (Air.Temp y Humidity)
VIM::pbox(tao[4:6], pos=1)
# Si los tres boxplot son iguales. No hay diferencia. MCAR
# Si son diferentes: Están asociados. MAR


# Otra forma es a través de una prueba de hipótesis 
# (Comparación de medias en dos grupos) CUIDADO CON LOS SUPUESTOS!
# El grupo es la variable que presenta perdidos. 

# Prueba t de medias (evaluar el mecanismo de la variable humedad)
# H0: No hay diferencia
# H1: Hay diferencia 
t.test(Sea.Surface.Temp ~ is.na(Humidity), data=tao)
# Si el p valor < 0.05, rechaza la H0 y concluyes que hay diferencia. MAR
# Si el p valor > 0.05, no se rechaza la H0 y concluyes que no hay diferencia. MCAR

# COINCIDE CON EL DIAGNÓSTICO VISUAL!!!


# MÉTODOS DE IMPUTACIÓN ----

## Y si sólo lo eliminamos? ----

# solo si es trivial y MCAR  
tao.cl=na.omit(tao)

## Usando una medida de Tendencia Central ----

library(DMwR2)
tao.c<-centralImputation(tao)
summary(tao.c)

tao.d<-initialise(tao,method="median")
summary(tao.d)

## Reemplazando por la media (usando una regresión)
library(simputation)
tao.i <- impute_lm(tao, Air.Temp + Humidity ~ 1)
tao[c(108:110, 463,551:552),]
mean(tao$Air.Temp, na.rm = TRUE)
mean(tao$Humidity, na.rm = TRUE)
tao.i[c(108:110, 463,551:552),]

## Reemplazando por la media de cada año
tao.i <- impute_lm(tao, Air.Temp + Humidity ~ 1 | Year)
tao[c(108:110, 463,551:552),]
tao.i[c(108:110, 463,551:552),]


## Usando Modelos de Regresión (Ahora sí) -----

# Considerando otras variables como predictoras
tao.i <- impute_lm(tao, Air.Temp + Humidity ~ Sea.Surface.Temp + UWind + VWind | Year)
tao[c(108:110, 463,551:552),]
tao.i[c(108:110, 463,551:552),]

## Adicionando un residuo aleatorio
#set.seed(666)
tao.i <- impute_lm(tao, Air.Temp + Humidity ~ Sea.Surface.Temp + UWind + VWind, add_residual = "normal")
tao[c(108:110, 463,551:552),]
tao.i[c(108:110, 463,551:552),]


## K-Vecinos más cercanos -----

# Usando la libreria VIM
tao_vars <- c("Air.Temp","Humidity")
tao_i_knn <- VIM::kNN(data=tao, variable=tao_vars, k = 5)
tao[c(108:110, 463,551:552),]
tao_i_knn[c(108:110, 463,551:552),]


# Usando la libreria DMwR2
tao_i_knn2<-DMwR2::knnImputation(tao,k = 5)
tao_i_knn2[c(108:110, 463,551:552),]





