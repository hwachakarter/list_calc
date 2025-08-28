Action can be: `+` `-` `*` `/`

## no argument commands:
- sort - sorts the list.
- exit - exists from the program.
- clear - clears the terminal.

## one argument commands:
- <action> <value> - does this action with value to every number in list.
- add <value> - appends a value to the end of the list.
- del <pos> - deletes a number on that pos.

## two argument commands:
- insert <pos> <value> - inserts a new value at pos, pushing all other to the right.
- replace <pos> <value> - replaces the value at pos.

## three argument commands:
- show <pos> <action> <value> - shows the result of applying action with value to the number at pos.
- do <pos> <action> <value> - applies action with value to the number at pos.
