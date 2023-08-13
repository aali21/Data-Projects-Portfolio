## The project was to design and implement a demonstration database in NoSQL for Amazone's collaboration with Morrison grocery stores
Amazone has opted for an operational expansion, now venturing into the domain of delivering fresh groceries. To provide a seamless same-day and immediate grocery delivery experience, the 
company has forged a strategic alliance with Morrison, a prominent UK groceries retailer. This collaboration will empower Amazone to facilitate swift and fresh
grocery deliveries within the same day. By initiating a trial phase in Manchester, Amazone is delving into the realms of immediate grocery delivery. 
This pilot program involves the selection of six Morrison grocery outlets, designated for rapid pickup and delivery, to be executed by delivery drivers operating in partnership with Amazone.

## This project is split into different parts
- Data modelling and designing of the NoSQL schema
  Understanding the data requirements and how different entities relate to each other
- Data insertion
- Querying of the database (using

## NoSQL schema (customers and past orders collections)
<img width="191" alt="image" src="https://github.com/aali21/Data-Projects-Portfolio/assets/29689235/65a2e71f-27c3-45f8-967c-f931770beaa3"/>
<img width="320" alt="image" src="https://github.com/aali21/Data-Projects-Portfolio/assets/29689235/26416ce8-126f-478b-8ea7-b38165e26dc7"/>

Current orders was embedded within the customers collection as we made the assumption that the current orders collection won’t increase by a large amount and we know that this kind of document will require regular querying. Past orders were separated and put into its own collection - this is because these orders are seldom requested and the number of orders can get quite large. 

## Data inserted
MongoDB compass allows for easy querying and aggregating as well as analyzing data in a visual environment. 
- A cluster is deployed and connected to through Mongo Atlas
- The appropriate IP address (the current one) is inputted into the projects IP access list. (This allows access to the database with the current IP address).

Here is the collections structure and some example data (in MongoDB Compass) 
<img width="935" alt="image" src="https://github.com/aali21/Data-Projects-Portfolio/assets/29689235/0486e997-7352-4f0d-bcdf-4acd0305feb0">

  ## Some queries I implemented
  
- Query indicating a user searching for available fresh products and displaying them based on
the user's location.
I decided we should create an index on the location field within the suppliers collection as it was needed to be able to perform find queries to get the nearby locations based off another collections location coordinates. The type of index was a 2dsphere as this index is normally used in MongoDB to query geographic data.

Here is an example output of the query:

<img width="251" alt="image" src="https://github.com/aali21/Data-Projects-Portfolio/assets/29689235/33bb8ebd-908e-440e-8a38-ce65a0cb4a3a"/>

- Query to find trends in product category ratings
This query grouped products by category and calculated its average rating.

<img width="660" alt="image" src="https://github.com/aali21/Data-Projects-Portfolio/assets/29689235/959d06c5-9834-4b19-b908-f0524e58a845">


I could have improved on the project by displaying the query outputs in a suitable UI for customers to view. Additionally, for the first query, it was hardcoded to search for customer C1 (just 1 customer), in reality (i.e in production) it should take the customer's coordinates and input it into the "coordinates" field of $geoNear operator.

## Challenges
What was challenging was the way the requirements were abstract and we had to make a lot of assumptions which required a lot of back and forth tweaking. Additionally, creating the sample data and inputting it into MongoDB was very time consuming. 

## Expansion considerations
We consider the scaling requirements for when the company decides to scale to various EU countries. Since the operations are expanding to other EU countries and another data center will be set up in Europe, a multi-leader replication strategy would be suitable. If single-leader is used, the users from the European countries will send requests (e.g place an order) to the leader in the UK based data centre. This will increase latency and defeat the original purpose of setting up the Europe data centre. With multiple leaders, each in its own data centre, users in Europe can do many writes/reads to the leader in the EU data centre and not have to worry about the server response time being slow plus have lower latency. 

There may be write conflicts whilst users are using the website (for e.g 2 users selected the same product of which there’s only 1 in stock). In this case, Amazone can ‘hold’ the product in the customers basket for a certain amount of time before releasing it so the other customer can place an order.
![image](https://github.com/aali21/Data-Projects-Portfolio/assets/29689235/b1814043-9dd3-41e6-af86-26b6a7fd51ed)

### Partitioning
Partitioning allows us to disseminate data so that it is distributed across many nodes. We also want to make sure the data is allocated equally across the nodes. A good partitioning strategy should avoid hot spots – that is, when 1 node takes more (or all) of the load whilst the other nodes stay idle. 

A request routing strategy can be used for allocation of data to partitions. More specifically, a customer could send a request for say, a fresh product, and a routing tier checks the location of the customer and then routes them to the partition that’s relevant to the location. E.g a customer in Paris opens Amazone and searches for bananas, but then gets routed to the France website, where data about fresh produce stores are displayed.

![image](https://github.com/aali21/Data-Projects-Portfolio/assets/29689235/9efd2cde-557d-42e1-91a0-8d46f3c878ee)
This strategy is very effective as all requests get sent to a routing tier and this knows where every node is so can send partitioned data to its respective nodes. Partitioning in this way also allows Amazon to follow data sovereignty laws and regulations that may vary between EU countries and the UK.




