####################################################################
####################################################################
# SESIÓN 2: Construcción de funciones en R
####################################################################
####################################################################

######0.1 Índices

# Creamos un data frame

df1 <- data.frame(peso=c(45,36,78,95,38,63), 
                 tipo=c("a","b","c","d","e","f"), 
                 seleccion= c(TRUE, FALSE, FALSE, TRUE, TRUE, TRUE))

# Accedemos al elemento "peso". Son lo mismo?

df1$peso
#df1$1 # OJO
df1[2]
df1[[2]]


class(df1[2])

class(df1[[2]])


# Y las listas?
lista <- list(letters[1:4], matrix(letters[1:9],3,3), df1) # Creamos la lista
names(lista) <- c("letra","mat","dfr") #le damos nombres
# Averiguar cómo se extrae la data de una archivo .xml


# También...

lista[1]
lista[[1]]
lista["letra"]
lista$letra

lista[2]
lista[[2]]
lista["mat"]
lista[["mat"]]


######0.2 Funciones propias

# nombre_funcion <- function(arg1, arg2, ...) {
# CÓDIGO A SER EJECUTADO
# }

# Ejemplo1

resta_2_numeros <- function(arg1, arg2) {
  y<-arg1 - arg2
  return(y)
}

resta_2_numeros(arg1=45, arg2 = 16)
resta_2_numeros(45, 16)
resta_2_numeros(16,45)

# Podemos configurarlo mejor?
resta_2_numeros <- function(arg1, arg2) {
  if (!is.numeric(arg1) | !is.numeric(arg2)){
    warning("Al menos uno de los argumentos no es numérico")
  }
  
  if (is.numeric(arg1) | is.numeric(arg2)){
    y<-arg1 - arg2
    return(y)
  }
}

resta_2_numeros("a",45)
resta_2_numeros(80,45)

# Ejemplo2

area_triangulo <- function(base, altura) {
  a<-(base*altura)/2
  return(a)
}

area_triangulo(base=4,altura=3)
area_triangulo(4,3)

# Ejemplo3: Construir la función para determinar si es par o impar

es_par <- function(numero) {
  if (numero %% 2 ==0) {
    x<- "Es par"
  }
  else {
    x<- "Es impar"
  }
  return("es par")
}

es_par(numero=12)
es_par(numero=13)
es_par(numero=20)


## Va a haber momentos en que se utilizan más de un argumento

x<-c(1,5,17,4,NA)
mean(x, na.rm=FALSE)
mean(x, na.rm = TRUE)

# 

######0.3 Funciones del R y demás paquetes?

seq()
seq(from=10, to=100, by=10)
seq(10,100,10)

# Del R

v1=c(35, 2, 65, 156, 6)

median(v1)

?median

methods(stats::median)
getAnywhere(mean.default)

# Y de esta función....
data.frame() #Puedes entrar al código a traves de la tecla F2

# De otros paquetes?
library(DescTools)
Mode

