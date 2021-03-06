% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ssvs_prior.R
\name{ssvs_prior}
\alias{ssvs_prior}
\title{Stochastic Search Variable Selection Prior}
\usage{
ssvs_prior(object, tau = c(0.05, 10), semiautomatic = NULL)
}
\arguments{
\item{object}{an object of class \code{"bvarmodel"}, usually, a result of a call to \code{\link{gen_var}}
or \code{\link{gen_vec}}.}

\item{tau}{a numeric vector of two elements containing the prior standard errors of restricted
variables (\eqn{\tau_0}) as its first element and unrestricted variables (\eqn{\tau_1})
as its second. Default is \code{c(0.05, 10)}.}

\item{semiautomatic}{an optional numeric vector of two elements containing the factors by which
the standard errors associated with an unconstrained least squares estimate of the country
VARX model are multiplied to obtain the prior standard errors of restricted (\eqn{\tau_0})
and unrestricted (\eqn{\tau_1}) variables. This is the semiautomatic approach
described in George et al. (2008).}
}
\value{
A list containing the vectors of prior standard deviations for restricted
and unrestricted variables, respectively.
}
\description{
Calculates the priors for a Bayesian VAR model, which employs stochastic search variable selection (SSVS).
}
\examples{

# Prepare data
data("e1")
data <- diff(log(e1))

# Generate model input
object <- gen_var(data)

# Obtain SSVS prior
prior <- ssvs_prior(object, semiautomatic = c(.1, 10))

}
\references{
George, E. I., Sun, D., & Ni, S. (2008). Bayesian stochastic search for VAR model
restrictions. \emph{Journal of Econometrics, 142}(1), 553--580.
\url{https://doi.org/10.1016/j.jeconom.2007.08.017}
}
