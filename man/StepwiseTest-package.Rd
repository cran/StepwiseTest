\name{StepwiseTest-package}
\alias{StepwiseTest-package}
\alias{StepwiseTest}
\alias{FWERkControl}
\alias{FDPControl}
\docType{package}
\title{
\packageTitle{StepwiseTest}
}
\description{
\packageDescription{StepwiseTest}
}
\usage{
FWERkControl(test_stat, boot_stat, k, alpha)
FDPControl(test_stat, boot_stat, gamma, alpha)
}
\arguments{
\item{test_stat}{m x 1 column vector of test statistics}
\item{boot_stat}{m x B matrix of bootstrap statistics}
\item{k}{Number of false rejections}
\item{gamma}{False discovery proportion}
\item{alpha}{The desired FWER(k) or FDP level}
}
\value{
  \code{Reject}: A 0/1 numeric vector where the element \code{j} equals 1 indicates the model \code{j} is significant.
  
  \code{CV}: The critical value.
  
}
\references{
  Romano, J. P. and Wolf, M. (2005). ``Stepwise multiple testing as formalized data snooping.'' Econometrica, 73, 1237-1282.

  Romano, J. P. and Wolf, M. (2007). ``Control of generalized error rates in multiple testing.'' Annals of Statistics, 35, 1378-1408.
  
  Hsu, P.-H., Hsu, Y.-C., and Kuan, C.-M. (2010). ``Testing the predictive ability of technical analysis using a new stepwise test without data-snooping bias.'' Journal of Empirical Finance, 17, 471-484.
  
  Hsu, Y.-C., Kuan, C.-M., and Yen, M.-F. (2014). ``A generalized stepwise procedure with improved power for multiple inequalities testing.'' Journal of Financial Econometrics, 12, 730-755.
  
}
\examples{
# Specify the model parameters
m_null = 3
m_alt  = 7
m = m_null + m_alt
mu = c( rep(0, m_null), rep(0.5,m_alt) )
rho = 0.25
omega= (1-rho)*diag(1,m) + rho*matrix(1,m,m)
v=t(chol(omega))

# generate the data
n = 100
y = mu\%*\%matrix(1,1,n)+ v \%*\% matrix(rnorm(m*n),m,n)

# calculate the test statistics and bootstrap statistics
library(foreach)
library(tseries)
B = 100
y_mean = apply(y,1,mean)
y_sig = apply(y,1,sd)
t_stat = as.matrix(sqrt(n)*y_mean/y_sig)
s = tsbootstrap(1:n,B,b=2,type="stationary")
b_stat = foreach(i=1:B,.combine=cbind) \%do\% {
  y_boot = y[, s[,i]]
  y_mean_boot = apply(y_boot,1,mean)
  sqrt(n)*(y_mean_boot - y_mean)/y_sig
}

# Multiple test that controls FWER(1) at 5\% significance level
FWERkControl(t_stat,b_stat,1,0.05)

# Multiple test that controls FWER(3) at 5\% significance level
FWERkControl(t_stat,b_stat,1,0.05)

# Multiple test that controls FDP(0.1) at 5\% significance level
FDPControl(t_stat,b_stat,0.1,0.05)

}
\author{
\packageAuthor{StepwiseTest}

Maintainer: \packageMaintainer{StepwiseTest}
}

