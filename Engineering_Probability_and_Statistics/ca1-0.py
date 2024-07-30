import numpy as np
import matplotlib.pyplot as plt
import scipy.stats

class distribution:
    def get_outcomes(self):
        return self.outcomes
class Binomial(distribution):
    def __init__(self, n, m, p=0):
        self.n_repetition=n
        self.m_samples=m
        self.outcomes=np.random.binomial(n,p,m)

    def sample_bernoulli(self,p):
        self.bernoulli_outcomes = np.random.choice(2, self.n_repetition*self.m_samples, p=[1-p, p])
        self.bernoulli_outcomes = self.bernoulli_outcomes.reshape(self.m_samples, self.n_repetition)
        self.sum_of_outcomes = np.array(np.sum(self.bernoulli_outcomes, axis=1))
        self.probability_of_outcomes = np.zeros(self.n_repetition+1)
        for i in self.sum_of_outcomes:
            self.probability_of_outcomes[i] += 1/self.sum_of_outcomes.size

    def get_theoretical_mean(self,p):
        self.sample_bernoulli(p)
        return self.n_repetition*p
    def get_practical_mean(self,p):
        self.sample_bernoulli(p)
        return self.sum_of_outcomes.mean()
    def get_theoretical_var(self,p):
        self.sample_bernoulli(p)
        return self.n_repetition*p*(1-p)
    def get_practical_var(self,p):
        self.sample_bernoulli(p)
        return self.sum_of_outcomes.var()
    
    def plot_mean_outcomes(self):
        plt.subplot(1,2,1)
        xpoints=np.arange(0,101,1)
        ypoints = np.array([self.get_theoretical_mean(p) for p in xpoints/100])
        plt.plot(xpoints, ypoints, color="black",linewidth=2, label="Theoretical")
        ypoints = np.array([self.get_practical_mean(p) for p in xpoints/100])
        plt.scatter(xpoints, ypoints, c=np.random.rand(101), label="Practical")
        plt.ylabel("Mean")
        plt.xlabel("Probability")
        plt.title("Question 1")
        plt.legend()

    def plot_var_outcomes(self):
        plt.subplot(1,2,2)
        xpoints = np.arange(0, 101, 1)
        ypoints = np.array([self.get_theoretical_var(p) for p in xpoints/100])
        plt.plot(xpoints, ypoints, color="black", linewidth=2, label="Theoretical")
        ypoints = np.array([self.get_practical_var(p) for p in xpoints/100])
        plt.scatter(xpoints, ypoints, c=np.random.rand(101), label="Practical")
        plt.ylabel("Variance")
        plt.xlabel("Probability")
        plt.title("Question 1")
        plt.legend()

    def plot_pmf(self, p):
        xpoints = np.arange(self.n_repetition+1)
        ypoints = scipy.stats.binom.pmf(xpoints, self.n_repetition, p)
        plt.plot(xpoints, ypoints, linewidth=1, label="Binomial", color="indianred")

    def plot_bernoulli_outcomes(self, p):
        self.sample_bernoulli(p)
        xpoints = np.arange(self.n_repetition+1)
        ypoints = np.array([self.probability_of_outcomes[i]for i in xpoints])
        plt.scatter(xpoints, ypoints, linewidth=1, label="Binomial",
                    c=np.random.rand(self.n_repetition+1))

class Poisson(distribution):
    def __init__(self, n, mu, m=0):
        self.mu_mean=mu
        self.n_repetition = n
        self.outcomes = np.random.poisson(mu,m)

    def plot_pmf(self):
        xpoints = np.arange(self.n_repetition+1)
        ypoints = scipy.stats.poisson.pmf(xpoints, self.mu_mean)
        plt.plot(xpoints, ypoints, linewidth=1, label="Poisson", color="mediumspringgreen")
        
class Uniform(distribution):
    def __init__(self, n, m):
        self.n_repetition = n
        self.outcomes=np.random.uniform(0, n+1, m)

class Exponential(distribution):
    def __init__(self, n, mu,m):
        self.n_repetition = n
        self.outcomes=np.random.exponential(mu,m)

class Normal(distribution):
    def __init__(self, mu, var, n=0,m=0):
        self.n_repetition = n
        self.stdev=np.sqrt(var)
        self.mu_mean=mu
        self.outcomes=np.random.normal(mu,self.stdev,m)

    def print_isf(self,q):
        isf = scipy.stats.norm.isf(q,self.mu_mean,self.stdev)
        print(isf)

    def print_ppf(self,q):
        ppf = scipy.stats.norm.ppf(q,self.mu_mean,self.stdev)
        print(ppf)

    def print_probability(self,start,end):
        probability = scipy.stats.norm.cdf(end, self.mu_mean, self.stdev)
        probability -= scipy.stats.norm.cdf(start, self.mu_mean, self.stdev)
        print(probability)

    def plot_pdf(self):
        xpoints = np.arange(self.n_repetition+1)
        ypoints = scipy.stats.norm.pdf(xpoints, self.mu_mean, self.stdev)
        plt.plot(xpoints, ypoints, linewidth=1, label="Normal", color="sienna")

#1
""" n1=500
m1=5000
bin1=Binomial(n1,m1)
bin1.plot_mean_outcomes()
bin1.plot_var_outcomes()
plt.show()"""

# 2
"""n2=250
m2=10000
p2=0.008
mu2=n2*p2
var2=n2*p2*(1-p2)
poi2 = Poisson(n2, mu2)
poi2.plot_pmf()
nor2=Normal(mu2,var2,n=n2)
nor2.plot_pdf()
bin2=Binomial(n2,m2,p2)
bin2.plot_pmf(p2)
plt.title("Question 2")
plt.xlabel("Number of Deaths")
plt.ylabel("Probability Function")
plt.xlim(0,10)
plt.legend()
plt.show()"""

#3
"""mu3=80
var3=12*12
q3=0.1
nor3 = Normal(mu3, var3) """

#3-1
"""nor3.print_isf(q3)"""

#3-2
""" q3=0.50
nor3.print_isf(q3)
q3=0.75
nor3.print_ppf(q3) """

#3-3
""" start3=80
end3=90
nor3.print_probability(start3, end3) """

#3-4
"""n3=20
m3=250
mu3=15
uni3 = Uniform(n3,m3)
m3=150
mu3=17
exp3 = Exponential(n3,mu3,m3)
m3=200
mu3=16
poi3 = Poisson(n3,mu3,m3)
xpoints = np.arange(n3+1)
ypoints = np.concatenate((uni3.get_outcomes(),poi3.get_outcomes() , \
    exp3.get_outcomes()))
plt.hist(ypoints, bins=50, edgecolor='black', density=True,
         alpha=0.7, label="Scores distribution")
nor3 = Normal(np.mean(ypoints), np.var(ypoints), m=m3)
plt.hist(nor3.get_outcomes(), bins=50, edgecolor='black',density=True, alpha=0.7, label="Normal distribution")
plt.title("Question 3")
plt.xlabel("Score")
plt.ylabel("Probability")
plt.legend()
plt.show() """

#4
""" n4 = 7072
m4 = 10000
p4 = 0.45
mu4 = n4*p4
var4 = n4*p4*(1-p4)
bin4=Binomial(n4,m4)
bin4.plot_bernoulli_outcomes(p4)
poi4 = Poisson(n4, mu4)
poi4.plot_pmf()
nor4=Normal(mu4,var4,n=n4)
nor4.plot_pdf()
plt.title("Question 4")
plt.xlabel("Number of Deaths")
plt.ylabel("Probability Function")
plt.legend()
plt.xlim(mu4-4*np.sqrt(var4), mu4+4*np.sqrt(var4))
plt.show() """