install.packages("rjson")

library("rjson")

result <- fromJSON(file = "test2.json")

result2 <- fromJSON(file = "freeb.json")

# Print the result.
print(result2)

result$businesses[[10]]$id
