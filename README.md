# PokeApp
Pokedex

# NOTES
- The filter by pokemon name is having issues because I couldn't finish de cancel pokemon data on cell reuse therefore when you filter the cell it can load the info from a previous pokemon URL.

- Some code looks repeated, my way of thinking was, I prefer to have similar code than creating early abstractions:  for example, the API calls, and the API ERRORS are pretty similar,  I did this on purpose because it is easier to abstract this later when you have the full picture of what the app is doing than doing it on the go.
