---
title: 'Quack Up Your Data Projects with DuckDB'
date: 2024-07-11T13:48:14+02:00
summary: 'Flying Through Data with the Speed and Grace of a Mallard'
tags:
- data
- innovation
categories: 
- data
image: 'duckDB2.webp'
author: Dorian Finel
---

There are dozens and dozens of data analysis engines, each claiming to be the fastest, the lightest, or the most flexible. But in this ocean of contenders, where some turn out to be ugly ducklings, lies a hidden gem: DuckDB. Still young and growing, this little duck has, in my opinion, a particularly interesting place in the vast pond of data analysis.
  
## Quack is DuckDB ?

According to the DuckDB documentation: "DuckDB is a simple RDBMS, portable, fast, and extensible." Let’s dive into the details:

**Simple RDBMS**: DuckDB operates on the same principles as SQLite. It's a SQL-based engine adhering to ACID principles, where the entire database is stored in a single file. This simplicity makes it highly accessible and easy to use for various applications.

**Portable**:Written in C++, DuckDB is designed to be *compiled and executed everywhere*, with a footprint of around 25MB.

**Fast** : Utilizing a columnar storage format and vectorized execution, Benchs are cool. Having tested it extensively, I found the performance to be genuinely remarkable.

**Extensible** : DuckDB supports easy integration of extensions and connectors. For instance, I have used extensions for interfacing with Iceberg, Delta Lake, and HTTPFS ... 

In essence, DuckDB is a single-file database that runs in memory, allowing for efficient SQL-based analytical processing. However, it’s important to note that DuckDB is not a traditional distributed database with persistent storage. Instead, it’s designed as an in-memory OLAP (Online Analytical Processing) system, on a single machine, ideal for fast, interactive data analysis.

In order to better understand the positioning and advantages of this "duck," let's situate this technology within the current ecosystem.

## Where is the Duck ? 

I appreciate the caricature of the data analysis engines landscape presented in the first reference: {{< youtube 6xBBbqn0CZQ >}}.

On one side, we have the "JVM data engineers" working with Spark, Flink, and Beam. To build their data pipelines and perform analyses, they need to be Java experts, familiar with the 27 types of JVMs. Ultimately, at a small/medium scale, it becomes incomprehensible, quickly unusable due to maintenance challenges, high costs, and less-than-stellar performance.

On the other side, there are the "SQL data engineers" using tools like Snowflake, Druid, Clickhouse, and Samza to do practical things.

Finally, we have the "data scientists" who often use dataframe engines like Pandas.

So, for example, to help situate everything, nowadays we have:
Polars, a powerful Rust engine working with dataframes, serves as a bridge between data scientists and the Spark ecosystem.
In this context, DuckDB can be seen as a bridge between the world of JVM data engineers and SQL data engineers because it allows users to quacks SQL on your own warehouse.

For those interested in a deeper comparison between DuckDB and Polars, you can read more in this [2]

Now that we've paddled through DuckDB's place in the current ecosystem, let's dive into what makes DuckDB so cool and why it's a quacking good choice for data analysis.

## Why it's cool ? 

Well, for several reasons:

### SQL Is Life

What encapsulates the principle of what we often call the "modern data stack" is the concept of replacing complicated code with SQL. SQL is code that everyone understands, easy to produce, easy to maintain, and therefore significantly less expensive.

You've probably already grasped my opinion on this topic, but I'll reiterate: SQL is, in my view, vital in data analysis, especially for projects of reasonable scale.

This leads to a question: who really works on data projects at an enormous scale?

**Spoiler**: not so many.

### BigData is Dead

{{< youtube lisIQ9ohU8g >}}


There is a well-known conference and blog by Jordan Tigani, one of the founders of BigQuery, on this topic [3]. I’ve included the conference video above, but I'll try to summarize the key points to support my words:
 

#### We want smaller ones

We often see the big data curve showing the exponential growth of global world data volumes. Looking at this curve, one might quickly feel overwhelmed and think, "Ahhh, I need more compute power, always more!" But in reality, this curve doesn't concern most people.

To temper this daunting curve, let's play the curve game ourselves and introduce a few of our own. Note that these curves come from the above-mentioned conference and are based on feedback from BigQuery users.

The first curve shows that MongoDB, the most popular NoSQL database, is actually on the decline and never really reached the popularity of MySQL/PostgreSQL databases.
The second curve demonstrates that a large majority of users don't have massive amounts of data. To give you an idea, the vast majority of customers have less than 1TB of data, and the median is around 100GB.

![IMAGE ALTERNATIVE TEXT](smaller_ones.png#center)

Even though some clients still have a lot of data, it doesn't often translate to huge queries.

This leads us to the next question: who really needs big querying?

#### Who needs big querying 

One of the major advancements in modern data architectures is the decoupling of storage and compute. Increasing storage capacity by tenfold rarely means you need to increase compute capacity by tenfold as well.

Among BigQuery customers who paid more than $1,000 per year, 90% of queries were under 100MB, and 99% were under 10GB. Additionally, observations show that clients with moderate data sizes occasionally run large queries, whereas clients with enormous data volumes rarely perform large queries.

This indicates that with good analytical practices, there's almost never a need to query enormous volumes of data. Large queries often come from less data-driven organizations that panic and generate reports at the last minute, querying a week or even a month's worth of data.

![IMAGE ALTERNATIVE TEXT](big_querying.png#center)

All these points are usage observations that suggest that, based on the experience of recent years, almost no one needs to query on the order of several terabytes. However, there are also technical reasons why big data is dead.

#### Yesterday big data is no longer big data

In 2006, at the beginning of AWS EC2, the only available instance was a single core with 2GB of RAM. Today, 18 years later, a standard instance typically has 64 cores and 256GB of RAM. You can even get monster machines with 24TB of RAM and 445 cores.

![IMAGE ALTERNATIVE TEXT](yesterday_data.png#center)

One of the definitions of big data is "data processing that cannot fit on a single machine." So yes, in 2006, big data meant handling just a few gigabytes of data. But today, with the advancement of hardware, the threshold for big data has significantly moved. Who really needs multiple machines for computation today?

So, why would we still use multiple machines?

### So why not scale up ?

For this section, I was inspired by a blog [4] that compares the performance of Dremel (the distributed engine that is the ancestor of BigQuery) and a single instance.

The result is that in 2008, with Dremel, it took 3,000 standard nodes to handle an 87TB dataset. Today, 15 years later, it is possible to achieve similar performance without the magic of distributed computing on a single instance costing $11 per hour.

![IMAGE ALTERNATIVE TEXT](dremel.png#center)

Of course, this may be less applicable for on-premises setups where you need to manage resilience yourself, but the overall point remains clear.

However, the data ecosystem still faces the prejudice that if you don't know how to do distributed computing, you're a clown. So now you will be able to respond "no, my friend, I am a duck" because the fact is, it is becoming unnecessary to complicate things with distributed systems. Just because it's more complex doesn't mean it's better.

I would add an authoritative argument I read online from Joshua Patterson, the CEO of Voltron Data, a very active company in the data ecosystem and one of the main contributors to Apache Arrow [5]:
![IMAGE ALTERNATIVE TEXT](joshua.png#center)

Given these insights, it becomes evident that we no longer need to rely on distributed systems for most of our data processing needs, because you can just put a duck on a single instance. But let's take this a step further: if one instance is sufficient for the majority of use cases, why not harness the full power of our workstations directly?

### You have the power

With the diminishing necessity for distributed computing, it's important to realize that the machines we work on today are already powerhouses. They can meet the majority of compute requirements effectively and efficiently.

Pour appuyer mes propoes je vais me baser sur un blog du CEO de fivetran George Fraser qui s'amuse à comparer les performanes de duckDB sur sa machine avec un datawarehouse standard d'un cloud provider. 



#### WASM
BUILDING
### Conclusion
 BUILDING
### Contacts

- dorian.finelbacha.e@thalesdigitale.io

### References

- 1 duckDB intro : https://www.youtube.com/watch?v=6xBBbqn0CZQ&t=651s
- 2 duckDB vs Polars : https://motherduck.com/blog/duckdb-versus-pandas-versus-polars/
- 3 BigData is dead : https://motherduck.com/blog/big-data-is-dead/
- 4 scaling up : https://motherduck.com/blog/the-simple-joys-of-scaling-up/
- 5 voltron data : https://www.theregister.com/2024/03/19/voltron_data_arrow/
- 6 fivetran : https://www.fivetran.com/blog/how-fast-is-duckdb-really

