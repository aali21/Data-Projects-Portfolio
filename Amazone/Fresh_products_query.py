from pymongo import MongoClient
import pprint
import pandas as pd

conn_str = "mongodb+srv://aali:foYGINYscfu474A9@cluster0.ykrvjpk.mongodb.net/test"

# Create a MongoClient instance using the connection string, with a timeout of 5 seconds for server selection
client = MongoClient(conn_str, serverSelectionTimeoutMS=5000)
try:
    print(client.server_info())
except Exception:
    print("Unable to connect to the server.")

CONNECTION_STRING = "mongodb+srv://aali:foYGINYscfu474A9@cluster0.ykrvjpk.mongodb.net/test"
 
# Create a connection using MongoClient. You can import MongoClient or use pymongo.MongoClient
myClient= MongoClient(CONNECTION_STRING)

# Getting the database
myDB= myClient["Amazone"]
customersCollection = myDB["customers"]

# Connecting to products collection
productsCollection = myDB["products"]


# Suppliers collection
suppliersCollection = myDB["suppliers"]
fresh_product_details= suppliersCollection.aggregate([
# search for the nearest stores within 2000m of the customers (C1) address
# 'distanceFromYou' field was created to show the customer how far the store is from
them (in metres)
{
"$geoNear":{
"near":{
"type":"Point",
"coordinates":[
53.4702888668,
-2.26459207339
]
},
"distanceField":"distanceFromYou",
"maxDistance":2000
}
},
# Filter by all suppliers which are Morrisons (as only these stock the fresh
products)
{
"$match":{
"name":{
'$regex' : '.*' + 'Morrisons' + '.*'
}
}
},
# Inventory data for products is in an array of embedded documents so we need to
unwind
{
"$unwind":"$realtime_inventory"
},
# Filter for all quantities greater or equal to 1 (indicating its available)
{
"$match":{
"realtime_inventory.quantity":{
"$gte":1
}
}
},
# Get the products collection using $lookup
{
"$lookup":{
"from":"products",
"localField":"realtime_inventory.product_id",
"foreignField":"_id",
"as":"availableProducts"
}
},
{
"$unwind":"$availableProducts"
},
# Sort the documents using 'distanceFromYou', to show closest stores first
{
"$sort":{
"distanceFromYou":1
}
},
# Group the items back together on supplier id. availableProducts field is created
which holds info
# from products collection
{
"$group":{
"_id":"$_id",
'name' : { '$first': '$name' },
'address' : { '$first': '$address' },
# Outputting the distance from the customer and rounding it to 2 decimal places
'distanceFromYou' : { '$first': {'$round': [ '$distanceFromYou', 2 ] }} ,
"availableProducts":{
"$push":"$availableProducts"
}
}
},
# Project (display) the useful fields to the customer
{
"$project":{
"name":1,
"address":1,
"distanceFromYou":1,
"availableProducts._id":1,
"availableProducts.name":1,
"availableProducts.short_desc":1,
"availableProducts.dimensions":1,
"availableProducts.avg_ratings":1,
"availableProducts.std_price":1
}
}
])
for i in fresh_product_details:
pprint.pprint(i)
