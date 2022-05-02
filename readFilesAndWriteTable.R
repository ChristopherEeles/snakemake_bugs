
myfn <- paste0("data/test", seq_len(100), ".txt")
write.csv(sort(myfn), "createOutput.csv")

