#' Plotting Forecast Error Variance Decompositions of Bayesian Vector Autoregression
#' 
#' A plot function for objects of class "bvarfevd".
#' 
#' @param x an object of class "bvarfevd", usually, a result of a call to \code{\link{fevd}}.
#' @param ... further graphical parameters.

#' @examples
#' data("e1")
#' e1 <- diff(log(e1))
#' 
#' data <- gen_var(e1, p = 2, deterministic = "const")
#' 
#' y <- data$Y[, 1:73]
#' x <- data$Z[, 1:73]
#' 
#' set.seed(1234567)
#' 
#' iter <- 500 # Number of iterations of the Gibbs sampler
#' # Chosen number of iterations should be much higher, e.g. 30000.
#' 
#' burnin <- 100 # Number of burn-in draws
#' store <- iter - burnin
#' 
#' t <- ncol(y) # Number of observations
#' k <- nrow(y) # Number of endogenous variables
#' m <- k * nrow(x) # Number of estimated coefficients
#' 
#' # Set (uninformative) priors
#' a_mu_prior <- matrix(0, m) # Vector of prior parameter means
#' a_v_i_prior <- diag(0, m) # Inverse of the prior covariance matrix
#' 
#' u_sigma_df_prior <- 0 # Prior degrees of freedom
#' u_sigma_scale_prior <- diag(0, k) # Prior covariance matrix
#' u_sigma_df_post <- t + u_sigma_df_prior # Posterior degrees of freedom
#' 
#' # Initial values
#' u_sigma_i <- diag(.00001, k)
#' u_sigma <- solve(u_sigma_i)
#' 
#' # Data containers for posterior draws
#' draws_a <- matrix(NA, m, store)
#' draws_sigma <- matrix(NA, k^2, store)
#' 
#' # Start Gibbs sampler
#' for (draw in 1:iter) {
#'   # Draw conditional mean parameters
#'   a <- post_normal(y, x, u_sigma_i, a_mu_prior, a_v_i_prior)
#' 
#' # Draw variance-covariance matrix
#' u <- y - matrix(a, k) %*% x # Obtain residuals
#' u_sigma_scale_post <- solve(u_sigma_scale_prior + tcrossprod(u))
#' u_sigma_i <- matrix(rWishart(1, u_sigma_df_post, u_sigma_scale_post)[,, 1], k)
#' u_sigma <- solve(u_sigma_i) # Invert Sigma_i to obtain Sigma
#' 
#' # Store draws
#' if (draw > burnin) {
#'   draws_a[, draw - burnin] <- a
#'   draws_sigma[, draw - burnin] <- u_sigma
#'   }
#' }
#' 
#' # Generate bvar object
#' bvar_est <- bvar(y = y, x = x, A = draws_a[1:18,],
#'                  C = draws_a[19:21, ], Sigma = draws_sigma)
#' 
#' # Generate forecast error variance decomposition (FEVD)
#' bvar_fevd <- fevd(bvar_est, response = "cons")
#' 
#' # Plot FEVD
#' plot(bvar_fevd, main = "FEVD of consumption")

#' @export
#' @rdname fevd
plot.bvarfevd <- function(x, ...) {
  par_orig <- graphics::par("mar")
  graphics::par(mar = c(5.1, 4.1, 4.1, 7.1))
  graphics::barplot(t(x), ylab = "Percentage", xlab = "Period", names.arg = stats::time(x))
  graphics::par(mar = par_orig)
  legend_names <- dimnames(x)[[2]]
  graphics::legend("left", legend = legend_names, xpd = FALSE, fill = grDevices::gray.colors(NCOL(x)), inset = 1)
}