#' @title Summary of Performance Metrics for Predicted Survival Data
#'
#' @description 
#' This function computes and summarizes various performance metrics for survival data
#' using predicted values and observed survival data. Users can specify the desired metrics
#' or compute all available metrics by default.
#'
#' @param predicted_data A numeric vector of predicted survival probabilities or scores.
#' @param survival_time A numeric vector of observed survival times.
#' @param metrics A character vector specifying the desired metrics to compute. Options include:
#'   \itemize{
#'     \item `"R_square"`: R-squared metric.
#'     \item `"L_square"`: L-squared metric.
#'     \item `"Pesudo_R"`: Pseudo-R-squared metric.
#'     \item `"Harrells_C"`: Harrell's Concordance Index.
#'     \item `"Unos_C"`: Uno's Concordance Index.
#'     \item `"R_sph"`: Explained variation (R_sph).
#'     \item `"R_sh"`: Explained variation (R_sh).
#'     \item `"Brier_Score"`: Brier Score.
#'     \item `"Time_Dependent_Auc"`: Time-dependent AUC.
#'   }
#'
#' @param status A numeric or logical vector indicating event status (1 for event, 0 for censoring).
#' @param tau An optional numeric value for restricted time horizon. Default is NULL.
#' @param t_star An optional numeric value specifying the time point for certain metrics. Default is NULL.
#'
#' @return A data frame summarizing the requested performance metrics.
#'
#' @examples
#' predicted_data <- c(0.8, 0.6, 0.4, 0.2)
#' survival_time <- c(5, 8, 3, 10)
#' status <- c(1, 0, 1, 1)
#' metric <- "R_square"
#' pam.predicted_performance_metric(predicted_data, survival_time, metric, status)
#'
#' @export

pam.predicted_performance_metric <- function(predicted_data, survival_time, metric, 
                                          status = NULL, tau = NULL, t_star = NULL, start_time = NULL) {
  
  if (missing(predicted_data) || missing(survival_time) || missing(metric)) {
    stop("Please provide 'predicted_data','survival_time' and 'metric'.")
  }
  
  metric_value <- NULL
  
  if (metric == "R_square" || metric == "L_square" || metric == "Pesudo_R") {
    r_l_list <- pam.r2_metrics(predicted_data, survival_time, status, tau)
    if (metric == "R_square") metric_value <- r_l_list$R_square
    if (metric == "L_square") metric_value <- r_l_list$L_square
    if (metric == "Pesudo_R") metric_value <- r_l_list$Pseudo_R_squared
  } else if (metric == "Harrell’s C") {
    metric_value <- round(pam.concordance_metric(predicted_data, survival_time, 
                                                 status, weight = "H"), 2)
  } else if (metric == "Uno’s C") {
    metric_value <- round(pam.concordance_metric(predicted_data, survival_time, 
                                                 status, weight = "U", input_tau = tau), 2)
  } else if (metric == "R_sph") {
    metric_value <- round(pam.rsph_metric(predicted_data, survival_time, status, start_time)$Re, 2)
  } else if (metric == "R_sh") {
    value_list <-  pam.rsh_metric(predicted_data, survival_time, status)
    metric_value <- round(value_list$Dx, 2)
  } else if (metric == "Brier Score") {
    metric_value <- round(pam.Brier_metric(predicted_data, survival_time, t_star), 2)
  } else if (metric == "Time Dependent Auc") {
    if(!is.null(t_star)){
      pred_time <- t_star
    } else {
      pred_time <- quantile(survival_time$time, 0.5)
    }
    
    auc <- pam.survivalROC(Stime = survival_time$time, status = survival_time$status, 
                           marker = predicted_data, predict.time = pred_time, 
                           method = "KM")$AUC
    metric_value <- round(max(auc, 1 - auc), 2)
  } else {
    stop("Invalid metric specified. Please choose a valid metric.")
  }
  
  # Return the result as a named list
  return(list(Metric = metric, Value = metric_value))
}