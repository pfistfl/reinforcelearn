% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/valuefunction.R
\name{ValueTable}
\alias{ValueTable}
\alias{table}
\title{Value Table}
\arguments{
\item{n.states}{[\code{integer(1)}] \cr Number of states (rows in the value function).}

\item{n.actions}{[\code{integer(1)}] \cr Number of actions (columns in the value function).}

\item{step.size}{[\code{numeric(1)}] \cr Step size (learning rate) for gradient descent update.}
}
\description{
Table representing the action value function Q.
}
\details{
You can specify the shape of the value table. If omitted the agent will try
to configure these automatically from the environment during interaction
(therefore the environment needs to have a \code{n.states} and \code{n.actions} attribute).
}
\section{Usage}{

\code{makeValueFunction("table", n.states = NULL, n.actions = 1L, step.size = 0.1, initial.value = NULL)}
}

\examples{
val = makeValueFunction("table", n.states = 20L, n.actions = 4L)
}
