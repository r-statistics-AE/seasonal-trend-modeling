# Seasonal Trend Modeling

This repository contains a **Bayesian temporal analysis** of monthly driver casualties in England.  

The exploratory analysis suggests that casualties remained relatively stable across months. However, after the promulgation of the new law, a noticeable reduction in casualties was observed.  

<p align="center">
  <img width="490" height="368" alt="casualties_before_after" src="https://github.com/user-attachments/assets/709bdb31-3c07-4a04-b525-300e6f441126" />
  <img width="490" height="368" alt="casualties_trend" src="https://github.com/user-attachments/assets/74375fbf-4646-4d0b-99df-a9fa2e69b31e" />
</p>

---

## Temporal Correlation of Observed Casualties  

The **ACF** and **PACF** analysis highlights two key findings:  

1. A strong correlation between casualties and their previous time point (lag-1).  
2. A clear **seasonal effect**, where significant correlation is observed with the same month in the previous year.  

These results indicate that the data exhibits both a **trend** and a **seasonal component**, both of which must be incorporated into the model.  

<p align="center">
  <img width="490" height="368" alt="acf_pacf" src="https://github.com/user-attachments/assets/e26d2e53-282a-456c-aa99-2e7a8f914df9" />
</p>

---

## Modeling with INLA  

A crucial aspect for model performance is the selection of an appropriate **likelihood family** for the distributional assumption.  

Since the variable of interest represents **count data**, the natural options are:  

- **Poisson distribution**: assumes mean ≈ variance.  
- **Negative Binomial distribution**: allows variance > mean (overdispersion).  

Given that the variance in this dataset is greater than the mean, the **Negative Binomial distribution** is a more suitable choice.  

The model accounts for:  
- Temporal correlation (lag structure).  
- Seasonal patterns.  
- Trend components.  

---

### Trend Modeling  

There are several possible approaches to model the trend, and the best choice depends on the dataset characteristics.  
A good strategy is to compare model selection criteria such as **DIC**, **WAIC**, and the **log-likelihood**.  

In this case, a **Random Walk of order 1 (RW1)** provided the best fit.  

After obtaining the predicted values, we observe that the model achieves a good performance on the dataset.  
Additionally, it allows for the **forecasting of casualties for the following year**.  

<p align="center">
  <img width="490" height="368" alt="fitted_model" src="https://github.com/user-attachments/assets/a6cb0a05-b2cf-45fd-aa55-acab8619364c" />
  <img width="490" height="368" alt="forecast_model" src="https://github.com/user-attachments/assets/dd0ce2f2-20ae-46a2-8f46-06ee43904559" />
</p>
