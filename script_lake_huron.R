# Instalando os pacotes (matriz + time)
install.packages("xts")
install.packages("forecast")

# Inicializando as bibliotecas necess�rias
library(xts)
library(forecast)

rm(list=ls(all=TRUE))

setwd("C:/Users/Alex/Desktop")

# Quest�o 1 - Carregando a base de dados Lago Huron
dados_lago <- read.table("lake_huron.txt", header = TRUE, sep = "")
View(dados_lago)

# Mostrando a estrutura do banco de dados
str(dados_lago)

# Quest�o 2 - Transformando a s�rie de dados em uma s�rie temporal
tsdados_lago <- ts(dados_lago$nivel, frequency = 12, start = c(1875)) # 12 para mensal
tsdados_lago <- ts(dados_lago$nivel, frequency = 6, start = c(1875)) # 6 para semestral
tsdados_lago

# Quest�o 3 - Gr�fico de S�ries Temporais
plot(tsdados_lago, type= "b", pch = "19", main="N�vel do lago ao longo dos anos", xlab="Ano", ylab="N�vel")

# Quest�o 4 - Gr�ficos: ACF e PACF
par(mfrow=c(1,2))
# Gr�fico ACF - Mostrando a fun��o de autocorrela��o dos res�duos ajuda descobrir 
acf(tsdados_lago, plot = FALSE)
acf(tsdados_lago)
#Intepretga��o: No gr�fico, existe uma correla��o significativa no lag 1 que decresce depois de alguns lags.

# Gr�fico PACF - Mostrando a fun��o autocorrela��o parcial dos res�duos ajuda a verificar alguns padr�es
pacf(tsdados_lago, plot=FALSE)
pacf(tsdados_lago)
# Intepreta��o: Neste gr�fico, existe uma correla��o significativa no lag 1, seguido por correla��es que n�o s�o significativas.

# Verificando a sanzonalidade
# Observei que houve um pico em Abril, descreve suvamente at� Junho e depois cresce at� Setembro. O gr�fico n�o revela padr�o de sazonalidade.
seasonplot(tsdados_lago)

# Quest�o 5 - Ajustando O Modelo ARIMA aos dados.
modelo_ARIMA <- arima0(tsdados_lago, order = c(2,1,0))
modelo_ARIMA
# Coeficiente AR1 � 0.1728 e o erro padr�o 0.1012
# Coeficiente AR2 � -0.2233 e o erro padr�o 0.1015

#Quest�o 6 - Avaliando se o modelo � adequado: An�lise de Res�duos
residuos <- modelo_ARIMA$residuals 
#Observei que os res�duos n�o revelam um padr�o e nem autocorrela��o.
ts.plot(residuos, ylab="Res�duos", main="An�lise de Res�duos")
abline(h=0, col=2)

# QUest�o 7 - Verificando as normalidades dos res�duos.

#Gr�fico de Probailidade Normal
qqnorm(residuos)
qqline(residuos, col=2)

# Teste de Normalidade para os res�duos
shapiro.test(residuos) # n�o rejeita a hip�tese de normalidade
# W = 0.98645, p-value = 0.4239

# Efetuando previs�es para 3 meses adiante
previsao <- forecast(residuos, h = 3)
previsao

# Retornando a previs�o pontual e os intervalos de 80% a 95% de confian�a

# Point Forecast      Lo 80     Hi 80     Lo 95    Hi 95
# Mar 1883    -0.00568271 -0.9384475 0.9270821 -1.432223 1.420858
# Apr 1883    -0.00568271 -0.9384475 0.9270821 -1.432223 1.420858
# May 1883    -0.00568271 -0.9384475 0.9270821 -1.432223 1.420858

# Mostrando as previs�es pontuais. Em cinza escuro o intervalo de 80% e em cinza claro de 90% 
plot(previsao)
