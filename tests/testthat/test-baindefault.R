# This R code contains a number of tests of the bain default function
data(sesamesim)

#========================================================================================")
# compute c=, f=, and f>|= for an hypothesis with 1 = and 1 > restriction with Bain and R")
#========================================================================================")



estimate <- c(1,1)
names(estimate)<-c("a", "b")
sampN<- 40
cov <- matrix(c(1,0,0,1), nrow=2,ncol=2)

set.seed(100)
y<-bain(estimate,"a-b = 0 & b  > 0",n=sampN,Sigma=cov,group_parameters=0,joint_parameters = 2)

# a-b has prior mean 0 variance 40 sd 6.325
# evaluate this prior in 0

test_that("bain default", {expect_equal(y$fit$Com_eq[1], dnorm(0,0,6.325), tolerance = .001)})

# a-b has posterior mean 0 variance 2 sd 1.414
test_that("bain default", {expect_equal(y$fit$Fit_eq[1], dnorm(0,0,1.414), tolerance = .001)})

# sampelen uit de verdeling van a=b is voor de prior sampelen uit N(0,number) en
# dat geeft inderdaad c=.50

# a=b voor de fit is N(1,.707) namelijk de var[(a+b)/2] = 1/4 * var(a+b) = 1/4 * 2 = .5
# de sd is dan .707

x<-rnorm(100000,1,.707)
for (i in 1:100000){
  if (x[i] > 0){x[i]=1} else {x[i]<-0}
}
test_that("bain default", {expect_equal(y$fit$Fit_in[1], mean(x), tolerance = .01)})
test_that("bain default", {expect_equal(y$fit$Com_in[1], .5, tolerance = .01)})

#========================================================================================")
# a straightforward variation of the previous test")
#========================================================================================")



estimate <- c(0,4)
names(estimate)<-c("a", "b")
sampN<- 40
cov <- matrix(c(1,0,0,1), nrow=2,ncol=2)

set.seed(100)
y<-bain(estimate,"a-b = 0 & b  > 0",n=sampN,Sigma=cov,group_parameters=0,joint_parameters = 2)

# a-b has prior mean 0 variance 40 sd 6.325
# evaluate this prior in 0

test_that("bain default", {expect_equal(y$fit$Com_eq[1], dnorm(0,0,6.325), tolerance = .001)})

# a-b has posterior mean -4 variance 2 sd 1.414
test_that("bain default", {expect_equal(y$fit$Fit_eq[1], dnorm(0,-4,1.414), tolerance = .001)})

# sampelen uit de verdeling van a=b is voor de prior sampelen uit N(0,number) en
# dat geeft inderdaad c=.50

# a=b voor de fit is N(2,.707) namelijk de var[(a+b)/2] = 1/4 * var(a+b) = 1/4 * 2 = .5
# de sd is dan .707

x<-rnorm(100000,2,.707)
for (i in 1:100000){
  if (x[i] > 0){x[i]=1} else {x[i]<-0}
}
test_that("bain default", {expect_equal(y$fit$Fit_in[1], mean(x), tolerance = .01)})
test_that("bain default", {expect_equal(y$fit$Com_in[1], .5, tolerance = .01)})

#========================================================================================")
# in a clearcut example inspired by the Marielle Sabine Dorret and Tineke compute fit ")
# and complexity for three hypotheses using Bain, R, and mentally.")
#========================================================================================")



estimate <- c(0,0,0,0,0,0)
names(estimate)<-c("a", "b","c", "d", "e", "f")
sampN<- 100
cov <- matrix(c(1,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,1),nrow=6,ncol=6)

set.seed(100)
y<-bain(estimate,"a=0 & b=0 & c=0 & d=0 & e=0 & f=0; a<0 & b=0 & c<0 & d=0 & e<0 & f=0;a<0 & b>0 & c<0 & d>0 & e<0 & f>0",n=sampN,Sigma=cov,group_parameters=0,joint_parameters = 6)

# evaluate the Fit_eq for the first and second hypothesis

sigmax <- matrix(c(1,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,1),nrow=6,ncol=6)
x <- c(0,0,0,0,0,0)
meanx <- c(0,0,0,0,0,0)

sigmaz <- matrix(c(1,0,0,0,1,0,0,0,1),nrow=3,ncol=3)
z <- c(0,0,0)
meanz <- c(0,0,0)

test_that("bain default", {expect_equal(y$fit$Fit_eq[1:4], c(0.004031442,0.06349364,1,NA))})
test_that("bain default", {expect_equal(y$fit$Fit_in[1:4], c(1,.125,.015625,NA))})
test_that("bain default", {expect_equal(y$fit$Com_in[1:4], c(1,.125,.015625,NA))})

#========================================================================================")
# Compute fit of 0 and complexity of 1/6 for an hypothesis that is really wrong")
#========================================================================================")



estimate <- c(-1,0,1)
names(estimate)<-c("a", "b","c")
sampN<- 40
cov <- matrix(c(.1,0,0,0,.1,0,0,0,.1), nrow=3,ncol=3)

set.seed(100)
y<-bain(estimate,"a > b & b > c",n=sampN,Sigma=cov,group_parameters=0,joint_parameters = 3)

test_that("bain default", {expect_equal(y$fit$Fit[1], 0, tolerance = .01)})
test_that("bain default", {expect_equal(y$fit$Com[1], .167, tolerance = .01)})

#========================================================================================")
# in a clearcut example with redundant constraints obtain fit and complexity of .125")
# the same example without redundant constraints renders similar results")
#========================================================================================")



estimate <- c(0, 0, 0)
names(estimate)<-c("a", "b","c")
sampN<- 40
cov <- matrix(c(1,0,0,0,1,0,0,0,1), nrow=3,ncol=3)

set.seed(10)
y<-bain(estimate,"a > b & b > 0 & a > 0; a > b & b > 0",n=sampN,Sigma=cov,group_parameters=0,joint_parameters = 3)

test_that("bain default", {expect_equal(y$fit$Fit[1:3], c(.125,.125,NA),tolerance = .01)})
test_that("bain default", {expect_equal(y$fit$Com[1:3], c(.125,.125,NA),tolerance = .01)})

#========================================================================================")
# a test of the t_test using bain default shows that b per group is correctly")
# used to compute the prior covariance matrix")
#========================================================================================")



estimate <- c(.2,0)
names(estimate)<-c("a", "b")
sampN<- c(20,40)
cov1<-matrix(c(.1),1,1)
cov2<-matrix(c(.1),1,1)
covariance<-list(cov1,cov2)

set.seed(10)
y<-bain(estimate,"a =b; a>b; a<b",n=sampN,Sigma=covariance,group_parameters=1,joint_parameters = 0)

test_that("bain default", {expect_equal(y$b, c(.025, .0125))})
test_that("bain default", {expect_equal(as.vector(y$prior), c(4,0,0,8))})

#========================================================================================")
#  using an ancova to test the reconstruction of the posterior covariance matrix")
#========================================================================================")



# select the appropriate columns from the data file sesame.txt and center the covariates

regrdata<-c(sesamesim$site,sesamesim$prenumb,sesamesim$peabody,sesamesim$postnumb)
dim(regrdata)<-c(240,4)
colnames(regrdata)<-c("site","prenumb","peabody","postnumb")
regrdata <- as.data.frame(regrdata)

# center the two covariates
regrdata$prenumb = regrdata$prenumb - mean(regrdata$prenumb)
regrdata$peabody = regrdata$peabody - mean(regrdata$peabody)
regrdata$site <- factor(regrdata$site)

anal <-  lm(postnumb ~ site + prenumb + peabody -1, data=regrdata)

set.seed(100)
y<-bain(anal, "site1=site2=site3=site4=site5")

# the reconstructed covariance matrix is the same as the matrix rendered by vcov(anal)

test_that("bain default", {expect_equal(as.vector(y$posterior), as.vector(vcov(anal)))  })

#========================================================================================")
# using a stylized counterpart of the previous ancova to test the reconstruction")
# of the prior covariance matrix")
#========================================================================================")



estimate<-c(0,0,0,0,0,0,0)
names(estimate) <- c("a", "b", "c", "d", "e", "c1", "c2")

cov1 <- matrix(c(3,0,0,
                 0,3,0,
                 0,0,3), nrow=3, ncol=3)
cov2 <- matrix(c(3,0,0,
                 0,3,0,
                 0,0,3), nrow=3, ncol=3)
cov3 <- matrix(c(3,0,0,
                 0,3,0,
                 0,0,3), nrow=3, ncol=3)
cov4 <- matrix(c(3,0,0,
                 0,3,0,
                 0,0,3), nrow=3, ncol=3)
cov5 <- matrix(c(3,0,0,
                 0,3,0,
                 0,0,3), nrow=3, ncol=3)

#sample size
sampN<-c(20,20,20,20,20)

#list of covariance matrix
covariance<-list(cov1,cov2,cov3,cov4,cov5)

set.seed(10)
y<-bain(estimate,"a=b=c=d=e",n=sampN,Sigma=covariance,group_parameters=1,joint_parameters = 2)

test_that("bain default", {expect_equal(y$b,c(.04,.04, .04, .04, .04))  })

# invert the covariance matrices per group divided by b
in1 <- solve(cov1/y$b[1])
in2 <- solve(cov2/y$b[2])
in3 <- solve(cov3/y$b[3])
in4 <- solve(cov4/y$b[4])
in5 <- solve(cov5/y$b[5])

# invert the prior covariance matrix
invcov <- solve(y$prior)

# all 1,1 elements of in1 ... in5 correspond with the corresponding elements in invcov
test_that("bain default", {expect_equal(invcov[1,1], in1[1,1])})
test_that("bain default", {expect_equal(invcov[2,2], in2[1,1])})
test_that("bain default", {expect_equal(invcov[3,3], in3[1,1])})
test_that("bain default", {expect_equal(invcov[4,4], in4[1,1])})
test_that("bain default", {expect_equal(invcov[5,5], in5[1,1])})

invcov77 <- in1[3,3] + in2[3,3] + in3[3,3] + in4[3,3] + in5[3,3]
invcov67 <- in1[2,3] + in2[2,3] + in3[2,3] + in4[2,3] + in5[2,3]
invcov57 <- in5[1,3]

test_that("bain default", {expect_equal(invcov[7,7], invcov77)})
test_that("bain default", {expect_equal(invcov[6,7], invcov67)})
test_that("bain default", {expect_equal(invcov[5,7], invcov57)})

#========================================================================================")
# SAME AS ABOVE BUT NOW DIFFERENT N AND NONDIAGONAL COVS")
#========================================================================================")



estimate<-c(0,0,0,0,0,0,0)
names(estimate) <- c("a", "b", "c", "d", "e", "c1", "c2")

cov1 <- matrix(c(3,.5,0,
                 .5,3,0,
                 0,0,3), nrow=3, ncol=3)
cov2 <- matrix(c(1,.6,.7,
                 .6,1,.5,
                 .7,.5,1), nrow=3, ncol=3)
cov3 <- matrix(c(3,0,.2,
                 0,3,0,
                 .2,0,3), nrow=3, ncol=3)
cov4 <- matrix(c(3,0,0,
                 0,3,0,
                 0,0,3), nrow=3, ncol=3)
cov5 <- matrix(c(6,0,0,
                 0,5,0,
                 0,0,1), nrow=3, ncol=3)

#sample size
sampN<-c(100,80,60,40,20)

#list of covariance matrix
covariance<-list(cov1,cov2,cov3,cov4,cov5)

set.seed(10)
y<-bain(estimate,"a=b=c=d=e",n=sampN,Sigma=covariance,group_parameters=1,joint_parameters = 2)

# the reconstructed covariance matrix is the same as the matrix rendered by vcov(anal)

test_that("bain default", {expect_equal(y$b,c(.008,.01, 4/300, .02, .04))  })

# invert the covariance matrices per group divided by b
in1 <- solve(cov1/y$b[1])
in2 <- solve(cov2/y$b[2])
in3 <- solve(cov3/y$b[3])
in4 <- solve(cov4/y$b[4])
in5 <- solve(cov5/y$b[5])

# invert the prior covariance matrix
invcov <- solve(y$prior)

# all 1,1 elements of in1 ... in5 correspond with the corresponding elements in invcov
test_that("bain default", {expect_equal(invcov[1,1], in1[1,1])})
test_that("bain default", {expect_equal(invcov[2,2], in2[1,1])})
test_that("bain default", {expect_equal(invcov[3,3], in3[1,1])})
test_that("bain default", {expect_equal(invcov[4,4], in4[1,1])})
test_that("bain default", {expect_equal(invcov[5,5], in5[1,1])})

invcov77 <- in1[3,3] + in2[3,3] + in3[3,3] + in4[3,3] + in5[3,3]
invcov67 <- in1[2,3] + in2[2,3] + in3[2,3] + in4[2,3] + in5[2,3]
invcov57 <- in5[1,3]

test_that("bain default", {expect_equal(invcov[7,7], invcov77)})
test_that("bain default", {expect_equal(invcov[6,7], invcov67)})
test_that("bain default", {expect_equal(invcov[5,7], invcov57)})







#========================================================================================")
# using stylized tests")
#========================================================================================")



estimate<-c(0,0,0)
names(estimate) <- c("a", "b", "c")
sampN <- 100
covariance <- matrix(c(1,0,0,0,1,0,0,0,1),nrow=3,ncol=3)

set.seed(10)
y<-bain(estimate,"a>0 & b>0 & c>0; a>b>c;a>b & b>0; a=b=c=0",n=sampN,Sigma=covariance,group_parameters=0,joint_parameters = 3)

# check fit ERr4 via dnorm(0,0,1)*dnorm(0,0,1)*dnorm(0,0,1)
test_that("bain default", {expect_equal(y$fit$Fit[1:5], c(.125,.166,.125,dnorm(0,0,1)*dnorm(0,0,1)*dnorm(0,0,1),NA), tolerance = .01)})
test_that("bain default", {expect_equal(y$fit$Com[1:5], c(.125,.166,.125,dnorm(0,0,5.77)*dnorm(0,0,5.77)*dnorm(0,0,5.77),NA),tolerance = .01)})

# tweede check elke par gelijk aan nul

set.seed(10)
z<-bain(estimate,"a=0;b=0;c=0",n=sampN,Sigma=covariance,group_parameters=0,joint_parameters = 3)
test_that("bain default", {expect_equal(z$fit$Fit[1:4], c(dnorm(0,0,1),dnorm(0,0,1),dnorm(0,0,1),NA), tolerance = .001)})
test_that("bain default", {expect_equal(z$fit$Com[1:4], c(dnorm(0,0,5.77),dnorm(0,0,5.77),dnorm(0,0,5.77),NA), tolerance = .001)})

# tweede check met elke par gelijk aan nul en non-diagonal covariance matrix

covariance = matrix(c(1,0.95,0.95,0.95,1,0.95,0.95,0.95,1),nrow=3,ncol=3)
set.seed(10)
x<-bain(estimate,"a=0&b=0&c=0",n=sampN,Sigma=covariance,group_parameters=0,joint_parameters = 3)
sigma <- matrix(c(1,.95, .95, .95, 1, .95, .95, .95, 1), ncol=3)
mean <- c(0,0,0)
test_that("bain default", {expect_equal(x$fit$Fit[1:2], c(0.7456949,NA),tolerance = .001)})
sigma2 <- x$prior
test_that("bain default", {expect_equal(x$fit$Com[1:2], c(0.003874745,NA),tolerance = .001)})
#========================================================================================")
# using stylized tests to check the use of scalar multiplyers and additive constants")
#========================================================================================")



estimate<-c(0,1,2)
names(estimate) <- c("a", "b", "c")
sampN <- 100
covariance <- matrix(c(1,0,0,0,1,0,0,0,1),nrow=3,ncol=3)

set.seed(199)
y<-bain(estimate,"3*a +1 > 2*b > c -2",n=sampN,Sigma=covariance,group_parameters=0,joint_parameters = 3)

a <- rnorm(100000,0,1)
b <- rnorm(100000,1,1)
c <- rnorm(100000,2,1)
propf <- 0
for (i in 1:100000){
  if (3 * a[i] + 1 > 2 * b[i] & 2 * b[i] > c[i]-2) {propf <- propf + 1/100000}
}
test_that("bain default", {expect_equal(y$fit$Fit[1], propf,tolerance = .01)})

a <- rnorm(100000,-1/3,50)
b <- rnorm(100000,0,50)
c <- rnorm(100000,2,50)
propc <- 0
for (i in 1:100000){
  if (3 * a[i] + 1 > 2 * b[i] & 2 * b[i] > c[i]-2) {propc <- propc + 1/100000}
}
test_that("bain default", {expect_equal(y$fit$Com[1], propc,tolerance = .01)})

#========================================================================================")
# using stylized tests to check the use of scalar multiplyers and additive constants")
# same as the previous test but now constants split in two parts")
#========================================================================================")

estimate<-c(0,1,2)
names(estimate) <- c("a", "b", "c")
sampN <- 100
covariance <- matrix(c(1,0,0,0,1,0,0,0,1),nrow=3,ncol=3)
set.seed(199)
y<-bain(estimate,"3a + .5 + .5 > 2b -1 + 1> c -1.5 -.5",n=sampN,Sigma=covariance,group_parameters=0,joint_parameters = 3)
a <- rnorm(100000,0,1)
b <- rnorm(100000,1,1)
c <- rnorm(100000,2,1)
propf <- 0
for (i in 1:100000){
  if (3 * a[i] + 1 > 2 * b[i] & 2 * b[i] > c[i]-2) {propf <- propf + 1/100000}
}
test_that("bain default", {expect_equal(y$fit$Fit[1], propf,tolerance = .01)})
a <- rnorm(100000,-1/3,50)
b <- rnorm(100000,0,50)
c <- rnorm(100000,2,50)
propc <- 0
for (i in 1:100000){
  if (3 * a[i] + 1 > 2 * b[i] & 2 * b[i] > c[i]-2) {propc <- propc + 1/100000}
}
test_that("bain default", {expect_equal(y$fit$Com[1], propc,tolerance = .01)})

#===========================================
# END OF TESTS
#===========================================

