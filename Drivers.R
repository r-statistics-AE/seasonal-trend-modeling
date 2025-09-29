
# Library
library(INLA)
library(tidyverse)
library(ggplot2)
library(dplyr)

data(package = "INLA")
help(package = "INLA")

data("Drivers",package = "INLA")
Drivers %>% 
  group_by(belt) %>% 
  summary(y)

Drivers$belt <- factor(Drivers$belt, labels =  c("Before", "Afther"))

# Boxplot
plot(Drivers$belt,Drivers$y,
     bty = "n",
      ylab = "y (deaths)",
     xlab = "Belt law",
     axes = F)
axis(1, at = 1:2, labels = levels(Drivers$belt)) 
axis(2)

# Casualties overtime 
plot(Drivers$trend, Drivers$y, 
     xlab = "Month", ylab = "y (deaths)",
     main = "",
     bty = "n",
     axes = TRUE) 

abline(v = 169, lty = 2, col = "red")
mtext("No belt law", side = 3, at = 85, line = 0.5, cex = 0.8, col = "red",)
mtext("Belt law", side = 3, at = 190, line = 0.5, cex = 0.8, col = "darkgreen")


# ACF and PACF
ts_data <- ts(na.omit(Drivers$y), frequency = 12)  

# Autocorrelation
par(mfrow = c(1, 2))  #
acf(ts_data, main = "ACF",bty = "n", axes = T)
pacf(ts_data, main = "PACF",bty = "n", axes = T)



# Model
formula <- y ~  belt + f(trend, model = "rw1") + f(seasonal, model = "seasonal",season.length = 12) 

fit_1 <- inla(formula,
              data = Drivers,
              family = "nbinomial",
              control.predictor = list(compute=TRUE),
              control.compute = list(dic = TRUE, waic = TRUE))
summary(fit_1)


# Predictions
predictions <- data.frame(
  trend = Drivers$trend,
  y_real = Drivers$y,
  y_pred = fit_1$summary.fitted.values$mean,
  lower = fit_1$summary.fitted.values$"0.025quant",
  upper = fit_1$summary.fitted.values$"0.975quant"
)


na_rows <- is.na(predictions$y_real)


predictions$y_pred[na_rows] <- exp(predictions$y_pred[na_rows])
predictions$lower[na_rows]  <- exp(predictions$lower[na_rows])
predictions$upper[na_rows]  <- exp(predictions$upper[na_rows])


ggplot(predictions, aes(x = trend)) +
  # Datos reales
  geom_point(aes(y = y_real), alpha = 0.6, color = "black", size = 1.5) +
  # Línea de predicción del modelo
  geom_line(aes(y = y_pred), color = "red", linewidth = 1) +
  # Intervalo de credibilidad (95%)
  geom_ribbon(aes(ymin = lower, ymax = upper), 
              fill = "red", alpha = 0.2) +
  # Personalización
  labs(title = "",
       x = "Month",
       y = "y (casualties)") +
  theme_minimal()
