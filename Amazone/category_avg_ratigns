# Grouping products by category and calculating their average ratings
category_ratings = pd.DataFrame(productsCollection.aggregate(
[
{
'$group':
{
'_id': "$category",
'avgRating': { '$avg': "$avg_ratings" }
}
},
# Outputting the average ratings to 2 decimal places
{'$project':{'averageRating': { '$round': [ "$avgRating", 2 ] }}}
]
))
category_ratings
ax = sns.barplot(data=category_ratings, x="_id", y="averageRating")
#Specfiy axis labels
ax.set(xlabel='Product category',
ylabel='Average rating',
title='Average rating for each product category')
plt.show()
