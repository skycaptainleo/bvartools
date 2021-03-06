% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{post_coint_kls_sur}
\alias{post_coint_kls_sur}
\title{Posterior Draw for Cointegration Models}
\usage{
post_coint_kls_sur(y, beta, w, sigma_i, v_i, p_tau_i, g_i, x = NULL,
  gamma_mu_prior = NULL, gamma_v_i_prior = NULL)
}
\arguments{
\item{y}{a \eqn{K \times T} matrix of differenced endogenous variables.}

\item{beta}{a \eqn{M \times r} cointegration matrix \eqn{\beta}.}

\item{w}{a \eqn{M \times T} matrix of variables in the cointegration term.}

\item{sigma_i}{the inverse of the constant \eqn{K \times K} error variance-covariance matrix.
For time varying variance-covariance matrics a \eqn{KT \times K} can be provided.}

\item{v_i}{a numeric between 0 and 1 specifying the shrinkage of the cointegration space prior.}

\item{p_tau_i}{an inverted \eqn{M \times M} matrix specifying the central location
of the cointegration space prior of \eqn{sp(\beta)}.}

\item{g_i}{a \eqn{K \times K} or \eqn{KT \times K} matrix. If the matrix is \eqn{KT \times K},
the function will automatically produce a \eqn{K \times K} matrix containing the means of the
time varying \eqn{K \times K} covariance matrix.}

\item{x}{a \eqn{KT \times NK} matrix of differenced regressors and unrestricted deterministic terms.}

\item{gamma_mu_prior}{a \eqn{KN \times 1} prior mean vector of non-cointegration coefficients.}

\item{gamma_v_i_prior}{an inverted \eqn{KN \times KN} prior covariance matrix of non-cointegration coefficients.}
}
\value{
A named list containing the following elements:
\item{alpha}{a draw of the \eqn{K \times r} loading matrix.}
\item{beta}{a draw of the \eqn{M \times r} cointegration matrix.}
\item{Pi}{a draw of the \eqn{K \times M} cointegration matrix \eqn{\Pi = \alpha \beta^{\prime}}.}
\item{Gamma}{a draw of the \eqn{K \times N} coefficient matrix for non-cointegration parameters.}
}
\description{
Produces a draw of coefficients for cointegration models in SUR form with a prior on
the cointegration space as proposed in Koop et al. (2010) and a draw of
non-cointegration coefficients from a normal density.
}
\details{
The function produces posterior draws of the coefficient
matrices \eqn{\alpha}, \eqn{\beta} and \eqn{\Gamma} for the model
\deqn{y_{t} = \alpha \beta^{\prime} w_{t-1} + \Gamma z_{t} + u_{t},}
where \eqn{y_{t}} is a K-dimensional vector of differenced endogenous variables.
\eqn{w_{t}} is an \eqn{M \times 1} vector of variables in the cointegration term,
which include lagged values of endogenous and exogenous variables in levels and
restricted deterministic terms. \eqn{z_{t}} is an N-dimensional vector of
differenced endogenous and exogenous explanatory variabes as well as unrestricted
deterministic terms. The error term is \eqn{u_t \sim \Sigma}.

Draws of the loading matrix \eqn{\alpha} are obtained using the prior on the cointegration space
as proposed in Koop et al. (2010). The posterior covariance matrix is
\deqn{\overline{V}_{\alpha} = \left[\left(v^{-1} (\beta^{\prime} P_{\tau}^{-1} \beta) \otimes G_{-1}\right) + \left(ZZ^{\prime} \otimes \Sigma^{-1} \right) \right]^{-1}}
and the posterior mean by
\deqn{\overline{\alpha} = \overline{V}_{\alpha} + vec(\Sigma^{-1} Y Z^{\prime}),}
where \eqn{Y} is a \eqn{K \times T} matrix of differenced endogenous variables and
\eqn{Z = \beta^{\prime} W} with \eqn{W} as an \eqn{M \times T} matrix of
variables in the cointegration term.

For a given prior mean vector \eqn{\underline{\Gamma}} and prior covariance matrix \eqn{\underline{V_{\Gamma}}}
the posterior covariance matrix of non-cointegration coefficients in \eqn{\Gamma} is obtained by
\deqn{\overline{V}_{\Gamma} = \left[ \underline{V}_{\Gamma}^{-1} + \left(X X^{\prime} \otimes \Sigma^{-1} \right) \right]^{-1}}
and the posterior mean by
\deqn{\overline{\Gamma} = \overline{V}_{\Gamma} \left[ \underline{V}_{\Gamma}^{-1} \underline{\Gamma} + vec(\Sigma^{-1} Y X^{\prime}) \right],}
where \eqn{X} is an \eqn{M \times T} matrix of
explanatory variables, which do not enter the cointegration term.

Draws of the cointegration matrix \eqn{\beta} are obtained using the prior on the cointegration space
as proposed in Koop et al. (2010). The posterior covariance matrix of the unrestricted cointegration
matrix \eqn{B} is
\deqn{\overline{V}_{B} = \left[\left(A^{\prime} G^{-1} A \otimes v^{-1} P_{\tau}^{-1} \right) + \left(A^{\prime} \Sigma^{-1} A \otimes WW^{\prime} \right) \right]^{-1}}
and the posterior mean by
\deqn{\overline{B} = \overline{V}_{B} + vec(W Y_{B}^{-1} \Sigma^{-1} A),}
where \eqn{Y_{B} = Y - \Gamma X} and \eqn{A = \alpha (\alpha^{\prime} \alpha)^{-\frac{1}{2}}}.

The final draws of \eqn{\alpha} and \eqn{\beta} are calculated using
\eqn{\beta = B (B^{\prime} B)^{-\frac{1}{2}}} and
\eqn{\alpha = A (B^{\prime} B)^{\frac{1}{2}}}.
}
\examples{
data("e6")
temp <- gen_vec(e6, p = 1)
y <- temp$Y
ect <- temp$W

k <- nrow(y)
t <- ncol(y)
m <- nrow(ect)

# Initial value of Sigma
sigma <- tcrossprod(y) / t
sigma_i <- solve(sigma)

# Initial values of beta
beta <- matrix(c(1, -4), k)

# Draw parameters
coint <- post_coint_kls_sur(y = y, beta = beta, w = ect,
                            sigma_i = sigma_i, v_i = 0, p_tau_i = diag(1, m),
                            g_i = sigma_i)

}
\references{
Koop, G., León-González, R., & Strachan R. W. (2010). Efficient posterior
simulation for cointegrated models with priors on the cointegration space.
\emph{Econometric Reviews, 29}(2), 224-242. \url{https://doi.org/10.1080/07474930903382208}
}
