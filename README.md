Install and Setup:-

`bundle install`
`rails server`

and access the app at `localhost:3000`

### Solution And Assumptions:-

Player model is not defined, so there is only one player who is playing, hence no session. Player is defined by constant PLAYER.

Used AASM state machine for defining rules for the game.

#### TODOS:-
1. Test Cases
2. Code Refactoring.
3. Query Optimisations.

