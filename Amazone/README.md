## The project was to design and implment a demonstration database in NoSQL for Amazone's collaboration with Morrison grocery stores
Amazone has opted for an operational expansion, now venturing into the domain of delivering fresh groceries. To provide a seamless same-day and immediate grocery delivery experience, the 
company has forged a strategic alliance with Morrison, a prominent UK groceries retailer. This collaboration will empower Amazone to facilitate swift and fresh
grocery deliveries within the same day. By initiating a trial phase in Manchester, Amazone is delving into the realms of immediate grocery delivery. 
This pilot program involves the selection of six Morrison grocery outlets, designated for rapid pickup and delivery, to be executed by delivery drivers operating in partnership with Amazone.

## This project is split into different parts
- Data modelling and designing of the NoSQL schema
  
- Data insertion
- Querying of the database (using 

  ## Some queries I implemented
  
- Query indicating a user searching for available fresh products and displaying them based on
the user's location.
I decided we should create an index on the location field within the suppliers collection as it was needed to be able to perform find queries to get the nearby locations based off another collections location coordinates. The type of index was a 2dsphere as this index is normally used in MongoDB to query geographic data.

- Query to find trends in product category ratings
This query grouped products by category and calculated its average rating
