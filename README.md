![Grabber](https://i.imgur.com/JHoKyFN.png)

# Analysis and Prediction of Successful Kickstarter Projects

***Team***

<ul>
  <li><strong>Samuel Guo</strong></li>
  <li><strong>Joanna Kim</strong></li>
  <li><strong>Spencer Zou</strong></li>
  <li><strong>Brandon Lee</strong></li>
</ul>

***Abstract***

This project is aimed at the following questions:
<ol>
   <li>What are the overarching similarities and key features of successful Kickstarter projects?</li>
   <li>How accurately can one predict project success or failure, given the characteristics of a new project?</li>
</ol>
As follows, the purpose of this project is to gain insight on what truly makes up a successul Kickstarter campaign, and whether or not that success can be replicated. The importance of having the regression analysis in addition to the machine learning model is to highlight the reasons and concepts behind an accurate prediction. Just as essential as the ability to have a ML program predict project success is the understanding of the underlying forces and factors that guide the prediction, and as such we have made it a priority of this project to draw real, conversable conclusions for data scientists and casual readers alike.<br /><br />

On the technical side, the project is done in **R** and **Python**, as is standard. Notable R packages include **dplyr**, **ggplot**, and **Shiny**, while the bulk of the Python work is done with the assistance of the essential machine learning library **sklearn**. An honorable mention to **Microsoft Excel** for many of the graphs and visuals.<br /><br />

***Premise and Motivation***

Kickstarter has been one of the premiere crowdfunding platforms since its launch in 2009. It is now home to over 445,000 successfully backed projects. While crowdfunding remains a great resource for any aspiring product designers and entrepreneurs, taking care of a campaign still requires a decently significant amount of time and money, with no guarantee or indicator of success. This project attempts to provide potential campaign managers with information and insight that can be used to maximize the probability of success for a certain project, as well as provide areas of interest that can later be researched further by the project manager.<br /><br />

***Table of Contents***

* [Prepping Data](#prepping-data)
* [Exploratory Insight](#exploratory-insight)
* [Statistical Models and Analysis](#statistical-models-and-analysis)
* [Machine Learning](#machine-learning)
* [Relevant Conclusions and Applications](#relevant-conclusions-and-applications)
* [Next Steps](#next-steps)<br /><br />

## Prepping Data

The raw data for this project comes from Kaggle: https://www.kaggle.com/yashkantharia/kickstarter-campaigns/data. It's a 32 MB dataset with 170731 unique projects, along with the following variables:

<ul>
  <li>ID</li>
  <li>Name</li>
  <li>Currency</li>
  <li>Main Category</li>
  <li>Subcategory</li>
  <li>Launch Time</li>
  <li>Deadline</li>
  <li>Duration</li>
  <li>Goal in USD</li>
  <li>City</li>
  <li>State</li>
  <li>Country</li>
  <li>Blurb Length</li>
  <li>Name Length</li>
  <li>Start Month</li>
  <li>End Month</li>
  <li>Start Quarter</li>
  <li>End Quarter</li>
  <li>Status (Successful/Failed)</li>
  <li>Amount Pledged in USD</li>
</ul>

Which looks like this pixelated mess in the R Data Viewer:

![](https://imgur.com/FIocTP0.png)

Duplicate rows were removed and time-and-date formats for Launch Time and Deadline were converted to simple numbers in Excel. Somehow, there were no missing values for any of the 170,731 projects. With the dataset cleaned, we then moved on to narrowing down the variables.

Many of the variables were easy to identify as being correlated with other variables. For example, Launch Time had a direct relationship with Deadline through the Duration variable (and the same for Start Month and End Month, which also happened to be closely related to Start Quarter and End Quarter). Similarly, City, State, Currency, and Country also shared a relationship, and Currency was an obvious choice for removal. City and State were also ultimately removed due to the lack of data within most of the levels. More on that in the next section.

To confirm our suspicions, we simply had to check the correlation between the variables in question. Using the previous example, because we believed that Deadline and Launch Time were not both necessary to the project because they were closely linked, we ran the following:

```R
> cor(data$launched_at, data$deadline)
[1] 0.9998613
```

A correlation of almost 1 meant that these variables were far too correlated to be both included in the model, so we decided to drop Deadline from the starting model. But just because Launch Time and Deadline were correlated through Duration did not mean that Duration was necessarily a bad variable. So we tested the correlation between Launch Time and Deadline:

```R
> cor(data$launched_at, data$duration)
[1] -0.05183889
```
We were correct. Deadline was (mostly) independent of Launch Time, so it was allowed to stay in the model. So on and so forth until we were sure that all of our variables were independent and useful on their own, each bringing something different to the party.

Some variables were simply not helpful for the project, such as ID and Name. Other variables were counterproductive, such as Amount Pledged, which defeated the purpose of trying to predict success before the project finished its campaign. Amount Pledged was ultimately replaced with another variable: Percentage Funded. More on that in the next section as well. 

After removing multicollinearity and irrelevant variables, we were left with the following model to start with:

<ul>
  <li><strong>Main Category</strong></li>
  <li><strong>Launch Time</strong></li>
  <li><strong>Duration</strong></li>
  <li><strong>Goal in USD</strong></li>
  <li><strong>Country</strong></li>
  <li><strong>Blurb Length</strong></li>
  <li><strong>Name Length</strong></li>
  <li><strong>Start Month</strong></li>
  <li><strong>Status (Successful/Failed)</strong></li>
</ul>

One final issue that would come up eventually was the discrepancy in success to failure ratio between our sample data and the population, which would lead to some trouble down the road in the Machine Learning section.

![](https://imgur.com/dBcs6q5.png)

But leaving that foreshadowing for now, we pressed on into looking for initial trends in Exploratory Insight.

## Exploratory Insight

Using Excel, we created visuals that would help us to gauge which variables would be the most helpful or interesting in the scope of this project.

![](https://imgur.com/LRb0vv0.png)

The top five countries that had the most successes were either countries from Asia or Europe. This finding could indicate that citizens of each country may be more inclined to support kickstarters, European or Asian- based kickstarters could be more popular with the public, kickstarter-funding methods could be more popular in Asia or Europe, or there could be no correlation. 

![](https://imgur.com/agodkO1.png)

The categories with the highest amount of successes are (1) music, (2) film & video, and (3) publishing, all categories that pertain more to artistic ventures. The categories with the highest amount of failures are (1) technology, (2) food, and (3) film & video. Technology and food are distinct in terms of categorization. Based on this data, it is possible that artistic kickstarters will be more likely to be successful and kickstarters that pertain to technology or food may be more likely to fail. However, because film & video is also the top third failure, this may show that the factor in high successes or failures may depend on the number of the kickstarters in each category, which means a higher success or failure count. This muddles the clarity of what category may lead to a more succesful kickstarter.

![](https://imgur.com/dQrWwa8.png)

The percentage of success and failure will be more indicative of what leads to a successful kickstarter. Although music, film & video, and publishing had the highest success count, (1) comics, (2) dance, (3) publishing have the highest percentage of success. The kickstarters with the highest percentage of failure are (1) food, (2) journalism, (3) technology. There are some similarities with the percentage of success and failure versus the literal count of success and failure. Comics have the highest percentage of success while food has the highest percentage of failure. 

![](https://imgur.com/h1uukuy.png)

The measures of central tendency for the kickstarter goals may indicate that a higher goal leads to a decreased likelihood of success, based on the median goal, mean goal, and trimmed mean goal of failed kickstarters being significantly higher than that of successful kickstarters. Interestingly, however, the mode goal of successful and failed kickstarters were both the same at $5000.

![](https://imgur.com/s4Zj6dG.png)

Based on the means of name length and blurb length, there seems to be little to no correlation between name length and success or blurb length and success, as the means of name length and blurb length for successes and the means of name length and blurb length for failures are quite similar.

![](https://imgur.com/gAV8ptM.png)

This graph displaying the relationship between starting month and success/failure seems to indicate that the starting month of a kickstarter project may be influential in determining its success, as the the proportions of success for each month varies considerably. The starting months that seem to have the lowest proportions of success are (1) December, (2) July, and (3) August. It is also worth noting that in general less kickstarters seem to be started during the period of December to February.

...and that's about as pretty as the graphs get. In the next section we dive deep into R, with a lot more statistics and less aesthetically pleasing visuals.

## Statistical Models and Analysis

Running multilinear regression on a binary response variable usually leads to muddled and not-too-impressive results, so the next question for us was: how can you quantify success or failure?

To answer that question, we replaced the Status variable with Percentage Funded, which was just Amount Pledged divided by Goal in USD. Having a numerical response variable would give us more insight into how the variables actually influenced the progress of each project rather than just a 1 or 0.

We began by generating scatter matrixes and heatmaps to give us an idea of which variables were most likely to prove useful in the model. And because we were careless, we realized that we forgot to remove Launch Time because it was heavily intertwined with Start Month, as shown below in the scatter matrix.

![](https://imgur.com/ONWAYQR.png)
![](https://imgur.com/6KLe9v2.png)

## Machine Learning

## Relevant Conclusions and Applications

## Next Steps

In conclusion, our regression models and random forest machine learning do a mediocre job at predicting. There are no strong correlations that point to any solid conclusions and the machine learning predictions have a couple of false postives and false negatives. In the future, we will learn how to use different models to derive more evidence towards concrete results. To make the significance of our project outcome more convincing, we are planning to learn how to analyze our statistical models in greater depth, allowing us to better communicate any conclusions we are able to deduce. 
