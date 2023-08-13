This project was to simulate the gameplay of a simple monopoly game.

## ERD and Schema

The entity relationship diagram (ERD) represents the structure of a database by visually illustrating the relationships between entities and their attributes. The central entity is "Players," which is connected to various other entities like "Token," "Property," "Location," "Bonus," and "Audit." The ERD also includes relationships between these entities, depicting their associations and cardinalities.
![image](https://github.com/aali21/Data-Projects-Portfolio/assets/29689235/f778867d-e6c2-4b94-97cc-ba4c88df3419)

**Central Placement of Players Entity:** The "Players" entity is placed at the center of the diagram to aid in easier design and visualization. This emphasizes the significance of players in the context of the system.

**Token and Player Relationship:** Each player must select one token, and each token belongs to one player. This relationship is represented accurately using appropriate notation.

**Property and Location Relationship:** A property is associated with one location, and a location can have at most one property. The diagram reflects this constraint, ensuring that only one property can be connected to a location.

**Bonus and Player Relationship:** A player can use multiple bonuses, but a bonus can be used by multiple players. This many-to-many relationship is conveyed using appropriate notation. Additionally, a player can have at most one bonus at any given time.

**Foreign Key Connections:** Foreign keys are connected to their respective primary keys, reinforcing the relationships between entities. This clarity aids in understanding the relationships and data flow.

**Handling Line Crossings:** In cases where lines intersect, a "line jump" technique is used to enhance readability and prevent confusion.

**Textual Annotations:** Textual annotations are added to the lines to provide further context and understanding of the relationships between entities.

The relational database schema:
![image](https://github.com/aali21/Data-Projects-Portfolio/assets/29689235/7ea70f8a-dc97-471d-b606-cbc8e6e289df)

### Ambiguities 

- Property Ownership -  The data specification mentions that a property can have either one owner or no owner. Players are the owners. The relationship between property and players is depicted as 0 or 1. It's assumed that players can own multiple properties.

- Audit Trail Entity - An "Audit" entity is included to store game-related data like player ID, location, bank balance, and round number. The "Turn Taken" attribute is chosen as the primary key to uniquely identify audit instances since other attributes can't guarantee uniqueness.

- Audit Trail Relationships - The relationships between players, location, and audit instances are established to maintain data integrity and ensure that each player's actions are tracked accurately.



## Creating tables and data insertion

SQL commands for initial population of my tables – it is wrapped in a stored procedure called ‘initial_tables()’ which allows me to drop and re-populate all my tables if needed by just calling the procedure. This is to make it easier to troubleshoot and modify rules/gamesteps as I'm creating them.

## Queries
To emulate gameplay rounds, I created stored procedures which complete certain steps (e.g calculates new balance/ new location) and updates the required tables. The stored procedures take the player name and dice roll as parameters and updates the tables for each step of a gameplay round. The procedures need to be called manually (triggers were not implemented, althogh they could have been).

Finally, a view of the final state of the gameplay round was displayed by joining some tables and creating a SQL view.
## Results

A 'gameview' after round 1 of the game. A round consists of 4 players rolling dice.
<img width="427" alt="image" src="https://github.com/aali21/Data-Projects-Portfolio/assets/29689235/0d9e9e3d-82b0-4b30-8f17-5a83aa2959d0">

'gameview' after round 2 of the game
<img width="431" alt="image" src="https://github.com/aali21/Data-Projects-Portfolio/assets/29689235/513b5ffd-fb2b-4240-9c2e-b23d84c66258">


