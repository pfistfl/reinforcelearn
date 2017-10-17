
Reinforcement Learning in R <img src="reinforcelearn.png" align="right" height="36"/>
=====================================================================================

[![Travis-CI Build Status](https://travis-ci.org/markdumke/reinforcelearn.svg?branch=master)](https://travis-ci.org/markdumke/reinforcelearn) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/reinforcelearn)](https://cran.r-project.org/package=reinforcelearn) [![Coverage Status](https://img.shields.io/codecov/c/github/markdumke/reinforcelearn/master.svg?maxAge=600)](https://codecov.io/github/markdumke/reinforcelearn?branch=master)

### Installation

``` r
# install.packages("devtools")
devtools::install_github("markdumke/reinforcelearn")
```

------------------------------------------------------------------------

### Get started

Reinforcement Learning with the package `reinforcelearn` is as easy as

``` r
library(reinforcelearn)

# Create gridworld environment
env = windyGridworld()

# Solve environment using Sarsa
res = sarsa(env, n.episodes = 30)
print(res$steps)
#>  [1]  860 1938  408  306  666  225  277  181   97  355  149  167  161   92
#> [15]  372  138   29  201   34  171  313  140   37  159   48   80  305   92
#> [29]   49   64
```

------------------------------------------------------------------------

### Environments

With `makeEnvironment` you can create a reinforcement learning environment from a Markov Decision Process.

``` r
# Create environment from MDP.
P = array(0, c(2,2,2))
P[, , 1] = matrix(c(0.2, 0.8, 0, 1), 2, 2, byrow = TRUE)
P[, , 2] = matrix(c(0.1, 0.9, 0, 1), 2, 2, byrow = TRUE)
R = matrix(c(5, 10, -1, 2), 2, 2, byrow = TRUE)  
env = makeEnvironment(transitions = P, rewards = R)
```

The environment is an `R6` class with a set of attributes and methods. You can interact with the environment via the `reset` and `step` method.

``` r
# Reset environment.
env$reset()
print(env)
#> Number of steps: 0 
#> State: 0 
#> Reward:  
#> Done: FALSE

# Take action 0.
env$step(0)
print(env)
#> Number of steps: 1 
#> State: 1 
#> Reward: 5 
#> Done: TRUE
```

You can also create an environment from [OpenAI Gym](https://gym.openai.com/) via the `gym` package. You need to install all dependencies listed [here](https://github.com/openai/gym-http-api).

``` r
# Create an OpenAI Gym environment.
# Make sure you have Python and Gym installed.
# Start server and create gym client.
package.path = system.file(package = "reinforcelearn")
path2pythonfile = paste0(package.path, "/gym_http_server.py")
system2("python", args = path2pythonfile, stdout = NULL, wait = FALSE)
client = gym::create_GymClient("http://127.0.0.1:5000")
instance.id = gym::env_create(client, "MountainCar-v0")

env = makeEnvironment(list(client, instance.id))

# Take random actions for 200 steps.
env$reset()
for (i in 1:200) {
  action = sample(m$actions, 1)
  env$step(action)
}
env$close()
```

This should open a Python window showing the interaction with the environment.

For more details on how to create an environment have a look at the vignette: [How to create an environment?](markdumke.github.io/reinforcelearn/articles/environments.html)

------------------------------------------------------------------------

### Algorithms

After you created an environment you can use various reinforcement learning algorithms to sovle this environment. For example, for a tabular environment like gridworld you can use tabular Q-Learning to solve it and find the optimal action value function *Q*\*. You can set various parameters like the learning rate, the number of episodes, the discount factor or epsilon.

``` r
# Create the windy gridworld environment.
env = windyGridworld()
res = qlearning(env, n.episodes = 30)
print(res$steps)
#>  [1]  844 1652  768  399  416  403   80  274  185  316   99   79  333   34
#> [15]  174  228  204  172  104  218   43   59  118  115  324  133   80   29
#> [29]   80   64

# Show value of each state.
print(matrix(round(apply(res$Q1, 1, max), 1), ncol = 10, byrow = TRUE))
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
#> [1,] -4.7 -4.9 -5.4 -6.2 -6.9 -7.3 -7.3 -6.7 -6.0  -5.1
#> [2,] -4.5 -4.5 -4.7 -4.9 -4.6 -4.2 -2.9 -3.9 -4.3  -4.3
#> [3,] -4.2 -4.1 -4.0 -4.0 -3.2 -1.9 -1.1 -2.4 -3.2  -3.4
#> [4,] -3.9 -3.6 -3.3 -3.1 -2.0 -0.8 -0.2  0.0 -2.3  -2.6
#> [5,] -3.3 -3.1 -2.7 -2.2 -1.1 -0.3  0.0 -0.3 -0.9  -1.8
#> [6,] -2.9 -2.6 -2.1 -1.6 -0.6  0.0  0.0  0.0 -0.7  -1.1
#> [7,] -2.6 -2.3 -1.7 -1.1  0.0  0.0  0.0  0.0 -0.3  -0.7
```

We can then get the optimal policy by taking the argmax over the action value function Q.

``` r
optimal.policy = max.col(res$Q1) - 1L
print(matrix(optimal.policy, ncol = 10, byrow = TRUE))
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
#> [1,]    3    1    3    2    0    2    3    1    1     3
#> [2,]    1    3    0    0    0    3    0    0    3     3
#> [3,]    3    0    3    1    3    0    3    0    3     3
#> [4,]    3    1    2    2    0    1    3    0    0     3
#> [5,]    1    0    1    2    1    1    3    2    0     3
#> [6,]    2    2    0    1    1    2    2    3    0     0
#> [7,]    0    0    1    1    0    1    0    3    0     0
```

For more details on algorithms have a look at the vignette: [How to solve an environment?](markdumke.github.io/reinforcelearn/articles/algorithms.html)

------------------------------------------------------------------------

### Value function approximation

When the state space is large or even continuous tabular solution methods cannot be applied. Then it is better to approximate the value function using a function approximator. We need to define a function, which preprocesses the state observation, so that the function approximator can work with it. Here is an example solving the mountain car problem using linear function approximation.

``` r
# Set up the Mountain Car problem
m = mountainCar()

# Define preprocessing function (here grid tiling)
n.tilings = 8
max.size = 4096
iht = IHT(max.size)

position.max = m$state.space.bounds[[1]][2]
position.min = m$state.space.bounds[[1]][1]
velocity.max = m$state.space.bounds[[2]][2]
velocity.min = m$state.space.bounds[[2]][1]
position.scale = n.tilings / (position.max - position.min)
velocity.scale = n.tilings / (velocity.max - velocity.min)

preprocessState = function(state) {
  # scale state observation
  state = matrix(c(position.scale * state[1], velocity.scale * state[2]), ncol = 2)
  # get active tiles
  active.tiles = tiles(iht, 8, state)
  # return n hot vector with 1 at the position of each active tile
  makeNHot(active.tiles, max.size)
}

set.seed(123)
res = qlearning(m, fun.approx = "linear", 
  preprocessState = preprocessState, n.episodes = 20)
print(res$steps)
#>  [1] 1211  903  536  420  406  241  241  239  233  232  204  241  194  235
#> [15]  233  167  198  165  234  162
```

------------------------------------------------------------------------

### Vignettes

Also have a look at the vignettes for further examples.

-   [Introduction to reinforcelearn](markdumke.github.io/reinforcelearn/articles/introduction.html)
-   [How to create an environment?](markdumke.github.io/reinforcelearn/articles/environments.html)
-   [How to solve an environment?](markdumke.github.io/reinforcelearn/articles/algorithms.html)

------------------------------------------------------------------------

Logo is a modification of <https://www.r-project.org/logo/>.

Author: Markus Dumke

Date: "17 Oktober 2017"
