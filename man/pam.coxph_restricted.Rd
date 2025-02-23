% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pam.coxph_restricted.R
\name{pam.coxph_restricted}
\alias{pam.coxph_restricted}
\title{Prediction Accuracy Measures for Cox Proportional Hazards Model}
\usage{
pam.coxph_restricted(
  fit.cox,
  covariates,
  time_var,
  status_var,
  tau = NULL,
  newdata = NULL
)
}
\arguments{
\item{fit.cox}{An object of class `coxph` representing a fitted Cox proportional hazards regression model. The model must be fitted with `x = TRUE` and `y = TRUE` to include the design matrix and response vector.}

\item{covariates}{A character vector specifying the names of the covariates used in the model.}

\item{time_var}{A string specifying the name of the time variable in the data.}

\item{status_var}{A string specifying the name of the event indicator variable in the data (1 for event, 0 for censored).}

\item{tau}{(Optional) A numeric value specifying a time horizon for truncating the observed survival times. If provided, the function calculates metrics up to time `tau`.}

\item{newdata}{(Optional) A new dataset for validation. If provided, the function calculates metrics on this new dataset instead of the training data.}
}
\value{
A list containing the following components:
\item{R.squared}{The R-squared measure, quantifying the proportion of variability explained by the model.}
\item{L.squared}{The L-squared measure, quantifying the proportion of prediction error explained by the corrected prediction.}
\item{Psuedo.R}{A pseudo-R measure, calculated as the product of R-squared and L-squared.}
}
\description{
This function calculates a pair of measures, R-squared and L-squared, for a Cox proportional hazards model. 
R-squared quantifies the proportion of variability in the observed survival times explained by the model's predictions,
while L-squared measures the proportion of prediction error explained by a corrected prediction function. Together, these metrics provide a comprehensive evaluation of the predictive power of the Cox model.
}
\examples{
library(survival)
library(PAmeasure)

# Use Mayo Clinic Primary Biliary Cirrhosis Data
data(pbc)

# Fit a univariate Cox PH model with bilirubin
fit1 <- coxph(Surv(time, status == 2) ~ bili, data = pbc, x = TRUE, y = TRUE)

# Calculate prediction accuracy measures
pam.cox_metrics(fit1, covariates = "bili", time_var = "time", status_var = "status")

# Fit a multivariate Cox PH model with bilirubin and albumin
fit2 <- coxph(Surv(time, status == 2) ~ bili + albumin, data = pbc, x = TRUE, y = TRUE)

# Calculate prediction accuracy measures
pam.cox_metrics(fit2, covariates = c("bili", "albumin"), time_var = "time", status_var = "status")

}
\references{
Li, G., & Wang, X. (2016). Prediction Accuracy Measures for a Nonlinear Model and for Right-Censored Time-to-Event Data.
arXiv preprint arXiv:1611.03063. Available at \url{https://arxiv.org/abs/1611.03063}.
}
