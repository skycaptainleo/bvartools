% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gen_vec.R
\name{gen_vec}
\alias{gen_vec}
\title{Vector Error Correction Model Input}
\usage{
gen_vec(data, p = 2, exogen = NULL, s = 2, const = NULL,
  trend = NULL, seasonal = NULL)
}
\arguments{
\item{data}{a time-series object of endogenous variables.}

\item{p}{an integer of the lag order of the series (levels) in the VAR.}

\item{exogen}{an optional time-series object of external regressors.}

\item{s}{an optional integer of the lag order of the exogenous variables of the series
(levels) in the VAR.}

\item{const}{a character specifying whether a constant term enters the error correction
term (\code{"restricted"}) or the non-cointegration term as an \code{"unrestricted"} variable.
If \code{NULL} (default) no constant term will be added.}

\item{trend}{a character specifying whether a trend term enters the error correction
term (\code{"restricted"}) or the non-cointegration term as an \code{"unrestricted"} variable.
If \code{NULL} (default) no constant term will be added.}

\item{seasonal}{a character specifying whether seasonal dummies should be included in the error
correction term (\code{"restricted"}) or in the non-cointegreation term as \code{"unrestricted"}
variables. If \code{NULL} (default) no seasonal terms will be added. The amount of dummy variables depends
on the frequency of the time-series object provided in \code{data}.}
}
\value{
A list containing the following elements:
\item{Y}{a matrix of differenced dependent variables.}
\item{W}{a matrix of variables in the cointegration term.}
\item{X}{a matrix of non-cointegration regressors.}
}
\description{
\code{gen_vec} produces the input for the estimation of a vector error correction (VEC) model.
}
\details{
The function produces the variable matrices of a vector error correction (VEC)
model, which can also include exogenous variables:
\deqn{\Delta y_t = \Pi w_t + \sum_{i=1}^{p-1} \Gamma_i \Delta y_{t - i} + 
\sum_{i=0}^{s-1} \Upsilon_i \Delta x_{t - i} +
C^{UR} d^{UR}_t + u_t,}
where
\eqn{\Delta y_t} is a \eqn{K \times 1} vector of differenced endogenous variables,
\eqn{w_t} is a \eqn{(K + M + N^{R}) \times 1} vector of cointegration variables,
\eqn{\Pi} is a \eqn{K \times (K + M + N^{R})} matrix of cointegration parameters,
\eqn{\Gamma_i} is a \eqn{K \times K} coefficient matrix of endogenous variables,
\eqn{\Delta x_t} is a \eqn{M \times 1} vector of differenced exogenous regressors,
\eqn{\Upsilon_i} is a \eqn{K \times M} coefficient matrix of exogenous regressors,
\eqn{d^{UR}_t} is a \eqn{N \times 1} vector of deterministic terms, and
\eqn{C^{UR}} is a \eqn{K \times N^{UR}} coefficient matrix of deterministic terms
that do not enter the cointegration term.
\eqn{p} is the lag order of endogenous variables and \eqn{s} is the lag
order of exogenous variables of the corresponding VAR model.
\eqn{u_t} is a \eqn{K \times 1} error term.

In matrix notation the above model can be re-written as
\deqn{Y = \Pi W + \Gamma X + U,}
where
\eqn{Y} is a \eqn{K \times T} matrix of differenced endogenous variables,
\eqn{W} is a \eqn{(K + M + N^{R}) \times T} matrix of variables in the cointegration term,
\eqn{X} is a \eqn{(K(p - 1) + Ms + N^{UR}) \times T} matrix of differenced regressor variables
and unrestricted deterministic terms. \eqn{U} is a \eqn{K \times T} matrix of errors.
}
\examples{
data("e6")
data <- gen_vec(e6, p = 4, const = "unrestricted", season = "unrestricted")

}
\references{
Lütkepohl, H. (2007). \emph{New introduction to multiple time series analysis} (2nd ed.). Berlin: Springer.
}
