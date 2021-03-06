% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fevd.R, R/plot.bvarfevd.R
\name{fevd}
\alias{fevd}
\alias{plot.bvarfevd}
\title{Forecast Error Variance Decomposition}
\usage{
fevd(object, response = NULL, n.ahead = 5, type = "oir",
  normalise_gir = FALSE)

\method{plot}{bvarfevd}(x, ...)
}
\arguments{
\item{object}{an object of class \code{"bvar"}, usually, a result of a call to \code{\link{bvar}}
or \code{\link{bvec_to_bvar}}.}

\item{response}{name of the response variable.}

\item{n.ahead}{number of steps ahead.}

\item{type}{type of the impulse responses used to calculate forecast error variable decompositions.
Possible choices are orthogonalised \code{oir} (default) and generalised \code{gir} impulse responses.}

\item{normalise_gir}{logical. Should the GIR-based FEVD be normalised?}

\item{x}{an object of class "bvarfevd", usually, a result of a call to \code{\link{fevd}}.}

\item{...}{further graphical parameters.}
}
\value{
A time-series object of class \code{"bvarfevd"}.
}
\description{
Produces the forecast error variance decomposition of a Bayesian VAR model.

A plot function for objects of class "bvarfevd".
}
\details{
The function produces forecast error variance decompositions (FEVD) for the VAR model
\deqn{y_t = \sum_{i = 1}^{p} A_{i} y_{t-i} + A_0^{-1} u_t,}
with \eqn{u_t \sim N(0, \Sigma)}.

If the FEVD is based on the orthogonalised impulse resonse (OIR), the FEVD will be calculated as
\deqn{\omega^{OIR}_{jk, h} = \frac{\sum_{i = 0}^{h-1} (e_j^{\prime} \Phi_i P e_k )^2}{\sum_{i = 0}^{h-1} (e_j^{\prime} \Phi_i \Sigma \Phi_i^{\prime} e_j )},}
where \eqn{\Phi_i} is the forecast error impulse response for the \eqn{i}th period,
\eqn{P} is the lower triangular Choleski decomposition of the variance-covariance
matrix \eqn{\Sigma}, \eqn{e_j} is a selection vector for the response variable and
\eqn{e_k} a selection vector for the impulse variable.

If \code{type = "sir"}, the structural FEVD will be
calculated as \deqn{\omega^{SIR}_{jk, h} = \frac{\sum_{i = 0}^{h-1} (e_j^{\prime} \Phi_i A_0^{-1} \Sigma^{\frac{1}{2}} e_k )^2}{\sum_{i = 0}^{h-1} (e_j^{\prime} \Phi_i A_0^{-1}  \Sigma A_0^{-1\prime} \Phi_i^{\prime} e_j )},}
where \eqn{\sigma_{jj}} is the diagonal element of the \eqn{j}th variable of the variance covariance matrix.

If \code{type = "gir"}, the generalised FEVD will be
calculated as \deqn{\omega^{GIR}_{jk, h} = \frac{\sigma^{-1}_{jj} \sum_{i = 0}^{h-1} (e_j^{\prime} \Phi_i \Sigma e_k )^2}{\sum_{i = 0}^{h-1} (e_j^{\prime} \Phi_i \Sigma \Phi_i^{\prime} e_j )},}
where \eqn{\sigma_{jj}} is the diagonal element of the \eqn{j}th variable of the variance covariance matrix.

If \code{type = "sgir"}, the structural generalised FEVD will be
calculated as \deqn{\omega^{SGIR}_{jk, h} = \frac{\sigma^{-1}_{jj} \sum_{i = 0}^{h-1} (e_j^{\prime} \Phi_i A_0^{-1} \Sigma e_k )^2}{\sum_{i = 0}^{h-1} (e_j^{\prime} \Phi_i A_0^{-1} \Sigma A_0^{-1\prime} \Phi_i^{\prime} e_j )}}.

Since GIR-based FEVDs do not add up to unity, they can be normalised by setting \code{normalise_gir = TRUE}.
}
\examples{
data("e1")
e1 <- diff(log(e1))

data <- gen_var(e1, p = 2, deterministic = "const")

y <- data$Y[, 1:73]
x <- data$Z[, 1:73]

set.seed(1234567)

iter <- 500 # Number of iterations of the Gibbs sampler
# Chosen number of iterations should be much higher, e.g. 30000.

burnin <- 100 # Number of burn-in draws
store <- iter - burnin

t <- ncol(y) # Number of observations
k <- nrow(y) # Number of endogenous variables
m <- k * nrow(x) # Number of estimated coefficients

# Set (uninformative) priors
a_mu_prior <- matrix(0, m) # Vector of prior parameter means
a_v_i_prior <- diag(0, m) # Inverse of the prior covariance matrix

u_sigma_df_prior <- 0 # Prior degrees of freedom
u_sigma_scale_prior <- diag(0, k) # Prior covariance matrix
u_sigma_df_post <- t + u_sigma_df_prior # Posterior degrees of freedom

# Initial values
u_sigma_i <- diag(.00001, k)
u_sigma <- solve(u_sigma_i)

# Data containers for posterior draws
draws_a <- matrix(NA, m, store)
draws_sigma <- matrix(NA, k^2, store)

# Start Gibbs sampler
for (draw in 1:iter) {
  # Draw conditional mean parameters
  a <- post_normal(y, x, u_sigma_i, a_mu_prior, a_v_i_prior)

# Draw variance-covariance matrix
u <- y - matrix(a, k) \%*\% x # Obtain residuals
u_sigma_scale_post <- solve(u_sigma_scale_prior + tcrossprod(u))
u_sigma_i <- matrix(rWishart(1, u_sigma_df_post, u_sigma_scale_post)[,, 1], k)
u_sigma <- solve(u_sigma_i) # Invert Sigma_i to obtain Sigma

# Store draws
if (draw > burnin) {
  draws_a[, draw - burnin] <- a
  draws_sigma[, draw - burnin] <- u_sigma
  }
}

# Generate bvar object
bvar_est <- bvar(y = y, x = x, A = draws_a[1:18,],
                 C = draws_a[19:21, ], Sigma = draws_sigma)

# Generate forecast error variance decomposition (FEVD)
bvar_fevd <- fevd(bvar_est, response = "cons")

# Plot FEVD
plot(bvar_fevd, main = "FEVD of consumption")
data("e1")
e1 <- diff(log(e1))

data <- gen_var(e1, p = 2, deterministic = "const")

y <- data$Y[, 1:73]
x <- data$Z[, 1:73]

set.seed(1234567)

iter <- 500 # Number of iterations of the Gibbs sampler
# Chosen number of iterations should be much higher, e.g. 30000.

burnin <- 100 # Number of burn-in draws
store <- iter - burnin

t <- ncol(y) # Number of observations
k <- nrow(y) # Number of endogenous variables
m <- k * nrow(x) # Number of estimated coefficients

# Set (uninformative) priors
a_mu_prior <- matrix(0, m) # Vector of prior parameter means
a_v_i_prior <- diag(0, m) # Inverse of the prior covariance matrix

u_sigma_df_prior <- 0 # Prior degrees of freedom
u_sigma_scale_prior <- diag(0, k) # Prior covariance matrix
u_sigma_df_post <- t + u_sigma_df_prior # Posterior degrees of freedom

# Initial values
u_sigma_i <- diag(.00001, k)
u_sigma <- solve(u_sigma_i)

# Data containers for posterior draws
draws_a <- matrix(NA, m, store)
draws_sigma <- matrix(NA, k^2, store)

# Start Gibbs sampler
for (draw in 1:iter) {
  # Draw conditional mean parameters
  a <- post_normal(y, x, u_sigma_i, a_mu_prior, a_v_i_prior)

# Draw variance-covariance matrix
u <- y - matrix(a, k) \%*\% x # Obtain residuals
u_sigma_scale_post <- solve(u_sigma_scale_prior + tcrossprod(u))
u_sigma_i <- matrix(rWishart(1, u_sigma_df_post, u_sigma_scale_post)[,, 1], k)
u_sigma <- solve(u_sigma_i) # Invert Sigma_i to obtain Sigma

# Store draws
if (draw > burnin) {
  draws_a[, draw - burnin] <- a
  draws_sigma[, draw - burnin] <- u_sigma
  }
}

# Generate bvar object
bvar_est <- bvar(y = y, x = x, A = draws_a[1:18,],
                 C = draws_a[19:21, ], Sigma = draws_sigma)

# Generate forecast error variance decomposition (FEVD)
bvar_fevd <- fevd(bvar_est, response = "cons")

# Plot FEVD
plot(bvar_fevd, main = "FEVD of consumption")
}
\references{
Lütkepohl, H. (2007). \emph{New introduction to multiple time series analysis} (2nd ed.). Berlin: Springer.

Pesaran, H. H., & Shin, Y. (1998). Generalized impulse response analysis in linear multivariate models. \emph{Economics Letters, 58}, 17-29.
}
