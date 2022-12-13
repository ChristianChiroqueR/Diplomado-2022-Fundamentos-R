#################
#################
# SESIÓN 1: CIENCIA DE DATOS CON R: Elementos básicos
#################
#################


########## 1. LOS ELEMENTOS MÁS BÁSICOS

class(1.5)

class(5L)

class("rojo") # Para escribir valores character siempre entre comillas

class(TRUE) # Para escribir valores booleanos siempre usar mayúscula.

class(1+2i)

class(NULL) # Valor vacío


########## 2. COERCIÓN

as.numeric("5")

as.integer(5.1)

as.character(5)


########## 3. ASIGNACIÓN DE VALORES A VARIABLES

x <- 5.5
class(x)

y <- "perro"
class(y)

z <- TRUE
class(z)

# Considerar que también se puede usar el signo "<-". Sin embargo, tiene
# algunas diferencias en cuanto a su uso en el programa. 

# X <-5+5
# 5+5->X
# 5+5 = X


########## 4. ESTRUCTURA EN R

###### A. Vectores

a <- c(1, 2, 3, 4, 5)
a
length(a)


b <- c("arbol", "casa", "persona")
b
length(b)

c <- c(TRUE, TRUE, FALSE, FALSE, TRUE)
c
length(c)


d <- c(1,2,3,NA,5)
d
length(d)

class(a)
class(b)
class(c)
class(d)

###### B. Matrices
#Matriz simple
matrix(1:12)

#Crear una matriz a partir de vectores creados
v1<-c(1,2,3)
v2<-c(4,5,6)
cbind(v1,v2) # Unir vectores usando cada uno como una columna
rbind(v1,v2) # Unir vectores usando cada uno como una fila

#Crear con especificaciones
mi_matriz<-matrix(1:12, nrow= 3, ncol = 4)

#Propiedades
dim(mi_matriz) #Primero filas, después columnas

#Las operaciones aritméticas son vectorizadas en una matriz
mi_matriz+1
mi_matriz*2
mi_matriz**2

#Transposición
mi_matriz
t(mi_matriz)


###### C. Array
mi_array <- array(data = 1:8, dim = c(2, 2, 2))
mi_array
# Redes neuronales convolucionales-> Visión computacional

###### D. Data frame

mi_df <- data.frame(
  "entero" = 1:4, 
  "numero" = c(1.2, 3.4, 4.5, 5.6),
  "cadena" = as.character(c("a", "b", "c", "d")),
  "factor" = as.factor(c("1", "2", "3", "4"))
) #Para crear un DT los vectores de insumo deben ser del mismo largo

mi_df
str(mi_df)

# Propiedades
dim(mi_df) #Dimensión
length(mi_df) #Largo (número de casos)
names(mi_df) #Nombre de las variables
#colnames(mi_df)
#rownames(mi_df)
class(mi_df) #Clase

# Coercionar una matriz a un data frame
mi_matriz
as.data.frame(mi_matriz)


########## 5. ÍNDICES

### LOS CORCHETES

v1 [2] # una sola dimensión
mi_matriz [2,3] # filas, columnas
mi_array [, , 2] # por qué?
mi_df [,2]

### SIGNO DE $

mi_df$entero # El elemento extraído siempre será una columna
# al usar el signo $ para extraer un elemento de un data frame 
# o una lista, obtenemos un objeto de la clase que ese 
# elemento era originalmente.


### Para qué sirve los corchetes dobles [[]]????

