import pandas as pd


rule all:
    input:
        "test.done"

rule create_rule:
    output:
        touch("data/test{num}.txt")


checkpoint getCreateExpectedFiles:
    output:
        "createOutput.csv"
    script:
        "readFilesAndWriteTable.R"



def getCreateOutput(wildcards):
    with checkpoints.getCreateExpectedFiles.get(**wildcards).output[0].open() as f:
        master_table = pd.read_csv(f)
        fst = list(master_table["x"])
        print(fst)
        return(fst)


checkpoint getResultExpectedFiles:
    input: getCreateOutput
    output:
        "resultsOutput.csv"
    script:
        "readFilesAndWriteTable2.R"



def getResultsOutput(wildcards):
    with checkpoints.getResultExpectedFiles.get(**wildcards).output[0].open() as f:
        master_table = pd.read_csv(f)
        fst = list(master_table["x"])
        # print(fst)
        return(fst)


rule test_rule:
    # input: "data/test{num}.txt"
    output:
        "results/test{num}.txt"
    group:
        "batch1"
    shell:
        "cp data/test{wildcards.num}.txt {output}"


rule aggregate:
    input: getResultsOutput
    output:
        touch("test.done")
