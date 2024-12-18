% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pam.Brier.R
\name{pam.Brier}
\alias{pam.Brier}
\title{Brier Score Calculation}
\usage{
pam.Brier(object, pre_sp, t_star = -1)
}
\arguments{
\item{object}{An object of class \code{Surv}, created by the \code{Surv} function, or a fitted survival model, such as those produced by \code{coxph}, \code{survreg}, or \code{rfsrc}.}

\item{pre_sp}{If \code{object} is a fitted survival model, this parameter should be a dataset on which you want to calculate the Brier Score. If \code{object} is a survival object, this parameter should be a vector of predicted survival probabilities for each observation at time \code{t_star}.}

\item{t_star}{A specified time point for calculating the Brier Score. This is necessary when \code{object} is a fitted survival model, as it indicates when the survival probability is predicted. If \code{object} is a survival object, this parameter can be ignored and does not affect the function's outcome.}
}
\value{
The Brier Score at time \code{t_star}, representing the difference between true classes and predicted probabilities.
}
\description{
The Brier Score, proposed by Glenn W. Brier in 1950, is a proper score function used to measure the accuracy of probabilistic predictions. It is commonly applied to assess model fits for survival data. The Brier Score can be calculated at any time point, regardless of whether it coincides with the event time.

The Brier Score represents the mean squared difference between true classes and predicted probabilities, effectively serving as a cost function. A lower Brier Score indicates better-calibrated predictions. Its values range from zero to one, as it reflects the maximum possible squared difference between predicted probabilities and actual outcomes. 

In the context of censored samples, where the exact time of an event (e.g., death) is unknown, direct calculation of residuals is not feasible. Thus, the Brier Score is widely utilized in survival analysis.

The Brier Score is considered a strictly proper score (Gneiting and Raftery, 2007), meaning it achieves its minimum value only when the predicted probabilities align with empirical probabilities. Empirical evidence suggests that predictions of survival duration can be inaccurate; however, incorporating patient-specific survival probabilities along with the Brier Score improves the ability to differentiate between future survivors and failures.
}
\examples{
library(PAmeasures)
library(survival)

# Use Mayo Clinic Primary Biliary Cirrhosis Data
data(pbc)

# Fit an exponential model with bilirubin
fit.coxph.full <- coxph(Surv(time, status) ~ age + log_albumin + 
                         log_bili + log_protime + edema, 
                      data = pbc,x=TRUE,y=TRUE)
taulist <- seq(0, max(pbc$time), 300)
median_time <- median(pbc$time)
pam.Brier(fit.coxph.full, pbc, median_time)

}
\references{
Graf, E., Schmoor, C., Sauerbrei, W., & et al. (1999). Assessment and comparison of prognostic classification schemes for survival data. *Statistical Medicine*, 18(17-18), 2529-2545.

Brier, G. W. (1950). Verification of forecasts expressed in terms of probability. *Monthly Weather Review*, 78.

Gneiting, T., & Raftery, A. E. (2007). Strictly Proper Scoring Rules, Prediction, and Estimation.

Zhou, H., Cheng, X., Wang, S., Zou, Y., & Wang, H. (2022). SurvMetrics: Predictive Evaluation Metrics in Survival Analysis. 
R package version 0.5.0. Available at \url{https://github.com/skyee1/SurvMetrics}.
}
