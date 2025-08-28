Action can be: `+` `-` `*` `/`

## no argument commands:
- sort - sorts the list.
- exit - exists from the program.
- clear - clears the terminal.
- round - rounds all numbers.
- <double action> - grabs pairs in list and applies action to both of them.
- <triple action> - applies action to all numbers in list at once and shows the result.

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
