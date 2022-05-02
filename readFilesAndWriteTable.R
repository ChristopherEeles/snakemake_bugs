
myfn <- list.files(path="results", pattern="test*", full.names = TRUE)
write.csv(sort(myfn), "testFilesExisting.csv")