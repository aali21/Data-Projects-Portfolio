This project was to simulate the gameplay of a simple monopoly game.

## ERD and Schema

The entity-relationship diagram:
![image](https://github.com/aali21/Data-Projects-Portfolio/assets/29689235/f778867d-e6c2-4b94-97cc-ba4c88df3419)

The relational database schema:
![image](https://github.com/aali21/Data-Projects-Portfolio/assets/29689235/7ea70f8a-dc97-471d-b606-cbc8e6e289df)


## Creating tables and data insertion

## Queries
To emulate gameplay rounds, I created stored procedures which complete certain steps (e.g calculates new balance/ new location) and updates the required tables. The stored procedures take the player name and dice roll as parameters and updates the tables for each step of a gameplay round. The procedures need to be called manually (triggers were not implemented, althogh they could have been).

Finally, a view of the final state of the gameplay round was displayed by joining some tables and creating a SQL view.
## Results

A 'gameview' after round 1 of the game. A round consists of 4 players rolling dice.
<img width="427" alt="image" src="https://github.com/aali21/Data-Projects-Portfolio/assets/29689235/0d9e9e3d-82b0-4b30-8f17-5a83aa2959d0">

'gameview' after round 2 of the game
<img width="431" alt="image" src="https://github.com/aali21/Data-Projects-Portfolio/assets/29689235/513b5ffd-fb2b-4240-9c2e-b23d84c66258">


