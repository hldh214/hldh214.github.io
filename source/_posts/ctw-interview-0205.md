---
title: 對呀對呀！……回字有四樣寫法，你知道麼？
date: 2022-02-07 16:02:50
tags: Interview
---

{% asset_img hackerrank.png hackerrank %}

<!-- more -->

# 引子

又是一年过去了, 博客继续长草, 几乎没有写作的欲望了

> 华服艳舞、仙乐飘飘，花团锦簇，迤逦排开，稍纵即逝……观众愈是看到屏幕里的华丽镜像，愈是感觉到它与现实生活的落差。

那么今天照例还是跟大家介绍最近遇到的面试题, 因为公司后端主要技术栈是 Java, 故本篇题目均是 Java 背景的, 不喜勿喷

# 题目

## Q1. SpringBootConfigurationStyles

其实我是最近才知道 hackerrank 这个网站的, 在之前我都一直以为像 “牛客网” 之流是天朝特色, 那么本次的面试题均来自此网站
劈头盖脸的就是一道框架应用相关的题, 因为限定两小时, 我判断了下估计查资料时间不太够, 就没做这道题, 其实有点可惜后面想想, 认真查查其实并不难, 这里补上聊以自慰
https://github.com/hldh214/SpringBootConfigurationStyles

## Q2. Find the Sequence Sum

```java
/**
 * 2.  Find the Sequence Sum
 * Find the sum of a sequence using a given formula.
 * Given three integers, i, j, and k,
 * a sequence sum to be the value of
 * i + (i + 1) + (i + 2) + (i + 3) + … + j + (j − 1) + (j − 2) + (j − 3) + … + k
 * (increment from iuntil it equals j,then decrement from juntil it equals k).
 * Given values i, j, and k, calculate the sequence sum as described.
 * Example i = 5 j = 9 k = 6
 * Sum all the values from i to j and back to k: 5 + 6 + 7 + 8 + 9 + 8 + 7 + 6 = 56.
 * Function Description
 * Complete the function getSequenceSum in the editor below.
 * getSequenceSum has the following parameter(s): int i, int j, int k: three integers
 * Return
 * long: the value of the sequence sum
 * Constraints
 * -10^8 ≤ i, j, k ≤ 10^8
 * i, k ≤ j
 */
public class Q2 {
    // Complete the getSequenceSum function below.
    static long getSequenceSum(int i, int j, int k) {
        long sum = 0;

        // phase1
        for (int x = 0; x < j - i; x++) {
            sum += x + i;
        }

        // phase2
        sum += j;

        // phase3
        for (int x = 1; x <= j - k; x++) {
            sum += j - x;
        }

        return sum;
    }

    public static void main(String[] args) {
        System.out.println(getSequenceSum(1, 5, 2));
        System.out.println(getSequenceSum(5, 9, 6));
    }
}
```

简单到不能再简单的题了, 在国内都算不上 “算法题”, 也没规定复杂度, 随便写写得了, 也没多考虑各种奇妙的数学解法, 各位看官有兴趣可以研究研究

## Q3. Write a query

```sql
/*
 Write a query to print the names of professors with the names of the courses they teach (or have taught) outside of their department. Each row in the results must be distinct (i.e., a professor teaching the same course over multiple semesters should only appear once), but the results can be in any order. Output should contain two columns:PROFESSOR.NAME, COURSE.NAME.
 */

/*
Enter your query here.
Please append a semicolon ";" at the end of the query
*/

select p.Name, c.Name
from `PROFESSOR` as p
         inner join `SCHEDULE` as s on s.PROFESSOR_ID = p.id
         inner join `COURSE` as c on c.id = s.COURSE_ID
where p.DEPARTMENT_ID <> c.DEPARTMENT_ID
group by 1, 2
;
```

第三题居然是一道 SQL 题, 说实话作为一个 CURD boy, 写写 SQL 还是不在话下的, 三下五除二搞定, 这里都懒得把原题抄下来, 反正大家看看答案也能猜出来题目个大概了..

## Q4. REST API

```java
import sun.net.www.http.HttpClient;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.util.List;
import java.util.Map;

/**
 * A restaurant ratingapplication collects ratings orvotes from its users and stores them in a database. They want to allow users to retrieve the total vote count for restaurants in a city. Implement a function,getVoteCount.Given a city name and the estimated cost for the outlet, make a GET request to the API athttps://jsonmock.hackerrank.com/api/food_outlets?city=cityNameestimated_cost=estimatedCost where cityName and estimatedCost arethe parameters passed to the function.
 * <p>
 * The response is a JSON object with the following 5 fields:
 * page: The current page of the results.(Number)
 * per_page: The maximum number of results returned per page.(Number)
 * total: The total number of results.(Number)
 * total_pages: The total number of pages with results.(Number)
 * data: Either an empty array or anarray with a singleobjectthat containsthe food outlets'records.
 * <p>
 * In data, each food outlet has the following schema:
 * id - outlet id(Number)
 * name: The name of the outlet (String)
 * city - The city in which the outlet is located (String)
 * estimated_cost: The estimated cost of the food in the particular outlet (Number).
 * user_rating: An object containing the user ratings for the outlet. The object has the following schema: average_rating: The average user rating for the outlet (Number) votes: The number of people who voted the outlet (Number)
 * <p>
 * If there are no matching records returned, the data array will be empty. In that case, the getVoteCountfunction should return -1.
 * <p>
 * An example of a food outletrecord is as follows: { "city": "Seattle", "name": "Cafe Juanita", "estimated_cost": 160, "user_rating": { "average_rating": 4.9, "votes": 16203 }, "id": 41 }
 * <p>
 * Use the votes property of each outlet to calculate the total vote count of all the matching outlets.
 * <p>
 * Function Description
 * Complete the getVoteCount function in the editor below.
 * getVoteCount has the following parameters:
 * string cityName:the city to query
 * int estimatedCost:the cost to query
 * <p>
 * Returns
 * int:the sum of votes for matching outlets or -1
 * <p>
 * Constraints
 * No query will return more than 10 records.
 */
public class Q4 {
    private static final String API_URL = "https://jsonmock.hackerrank.com/api/food_outlets";

    public static int getVoteCount(String cityName, int estimatedCost) {
        return -1;
    }

    public static void main(String[] args) throws IOException {
        System.out.println(getVoteCount("New York", 100));
    }
}
```

这题一上来给我整懵了, 我寻思这跟 rest api 一点关系也妹有啊, 而且也没说明是否允许第三方扩展
如果不允许的话是准备让我手写一个 http 客户端 + json 解析器吗
最后综合考虑下就没做这题, 原因也跟第一题一样, 不熟悉 Java, 现学时间可能不够, 简单用注释说明了一下思路, 希望有幸能被面试官看到吧

## Q5. OnlineAccount

```java
import java.io.*;
import java.util.*;
import java.text.*;
import java.math.*;
import java.util.regex.*;

/**
 * Given an interface named "OnlineAccount" that models the account of popular online video streaming platforms, perform the operations listed below.
 * The interface "OnlineAccount" consists of the basePrice, regularMoviePrice, and exclusiveMoviePrice.
 * <p>
 * In order to complete this challenge, you need to implement an incomplete class named "Account" which implements the "OnlineAccount" interface as well as the "ComparableAccount" interface.
 * <p>
 * Class Account has two attributes to keep track of the number of movies watched:
 * Integer noOfRegularMovies
 * Integer noOfExclusiveMovies
 * String ownerName
 * <p>
 * Methods to complete for class Account:
 * 1. Add a parameterized constructor that initializes the attributes ownerName,numberOfRegularMovies, and numberOfExclusiveMovies.
 * 2. Int monthlyCost() => This method returns the monthly cost for the account. [Monthly Cost = base price +noOfRegularMovies*regularMoviePrice +noOfExclusiveMovies*exclusiveMoviePrice]
 * 3. Override the compareTo method of the Comparable interface such that two accounts can be compared based on their monthly cost.
 * 4. String toString() which returns => "Owner is[ownerName] and monthly cost is [monthlyCost] USD."
 */
interface OnlineAccount {
    int basePrice = 120;
    int regularMoviePrice = 45;
    int exclusiveMoviePrice = 80;
}

class Account implements OnlineAccount, Comparable<Account> {
    int noOfRegularMovies, noOfExclusiveMovies;
    String ownerName;

    // 1) Add a parameterized constructor that initializes the attributes noOfRegularMovies and noOfExclusiveMovies.
    public Account(String ownerName, int noOfRegularMovies, int noOfExclusiveMovies) {
        this.ownerName = ownerName;
        this.noOfExclusiveMovies = noOfExclusiveMovies;
        this.noOfRegularMovies = noOfRegularMovies;
    }

    // 2. This method returns the monthly cost for the account.
    public int monthlyCost() {
        return basePrice + noOfRegularMovies * regularMoviePrice + noOfExclusiveMovies * exclusiveMoviePrice;
    }

    // 3. Override the compareTo method of the Comparable interface such that two accounts can be compared based on their monthly cost.
    public int compareTo(Account account) {
        return this.monthlyCost() - account.monthlyCost();
    }

    // 4. Returns "Owner is [ownerName] and monthly cost is [monthlyCost] USD."
    public String toString() {
        return "Owner is " + ownerName + " and monthly cost is " + monthlyCost() + " USD.";
    }
}

public class Q5 {
    public static void main(String[] args) throws Exception {
        /* Enter your code here. Read input from STDIN. Print output to STDOUT */

        Scanner sc = new Scanner(System.in);
        String sub = sc.nextLine();

        int t = Integer.parseInt(sub);

        ArrayList<Account> list = new ArrayList<Account>();

        for (int i = 0; i < t; i++) {
            String[] input = sc.nextLine().split(" ");
            list.add(new Account(input[0],
                    Integer.parseInt(input[1]),
                    Integer.parseInt(input[2])));
        }

        Collections.sort(list);

        System.out.println("Most valuable account details:");
        System.out.println(list.get(list.size() - 1));
    }
}
```

这题倒没什么槽点, 一股浓浓的学校作业的风格, 前因后果写的非常清楚, 每个方法也有详尽的注释提示你该怎么写
只可惜现在都 2022 年了, GitHub Copilot 正式上线几个月了, 无脑 tab 就完事了

# 后记

作为 Java web 的岗位, 个人认为选题还是挺不错的, 涉猎范围广, 至少比某些公司上来就是两道 leetcode hard 题要强不少
只可惜在做题之前没怎么复习 Java 相关知识, 愧对了大家对我的期待
