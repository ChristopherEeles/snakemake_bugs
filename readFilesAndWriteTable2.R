myfn <- paste0("results/test", seq_len(100), ".txt")
write.csv(sort(myfn), "resultsOutput.csv")