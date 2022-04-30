
rule all:
    input:
        "test.done"

rule create_rule:
    output:
        "data/test{num}.txt"
    shell:
        "touch {output}"

rule test_rule:
    input:
        "data/test{num}.txt"
    output:
        "results/test{num}.txt"
    group:
        "batch1"
    shell:
        "cp {input} {output}"

checkpoint test_rule2:
    input:
        [f"results/test{num}.txt" for num in range(1, 1001)]
    output:
        "results/other{num}.txt"
    group:
        "batch2"
    shell:
        "cp {input} {output}"

rule aggregate:
    input:
       [f"results/other{num}.txt" for num in range(1, 1001)]
    output:
        "test.done"
    shell:
        "touch test.done"
