
rule all:
    input:
        "test.done"

rule test_rule:
    input:
        "data/test{num}.txt"
    output:
        "results/test{num}.txt"
    group:
        "batch1"
    shell:
        "cp {input} {output}"

rule test_rule2:
    input:
        "results/test{num}.txt"
    output:
        "results/other{num}.txt"
    group:
        "batch2"
    shell:
        "cp {input} {output}"

rule aggregate:
    input:
        [f"results/other{num}.txt" for num in range(1, 101)]
    output:
        "test.done"
    shell:
        "touch test.done"