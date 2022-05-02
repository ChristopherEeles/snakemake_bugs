import pandas as pd



rule all:
    input:
        "test.done"

rule create_rule:
    output:
        "data/test{num}.txt"
    shell:
        "touch {output}"

checkpoint getExistingTestFiles:
    output:
        "testFilesExisting.csv"
    shell:
        """
        #! /bin/bash
        set +u;
        module load CCEnv  nixpkgs/16.09 gcc/8.3.0 r/4.0.0

        Rscript readFilesAndWriteTable.R
        """

def getFirstStageOutput(wildcards):
    with checkpoints.getFirstStageToRun.get(**wildcards).output[0].open() as f:
        master_table  = pd.read_csv(f, header=None)
        # pd.read_csv("/cluster/projects/bhklab/Projects/Tissue_Biomarker_Meta/runlist_files/geneExpressionMasterToRunList.txt", header=None)
        fst = master_table.drop_duplicates([1,2,3])[[1,2,3]]
        first_stage_ids = ['signature_{PSet}_{Drug}_{Tissue}.rds'.format(PSet = x[3], Tissue = x[1], Drug = x[2]) for (row,x) in fst.iterrows()]
        first_stage_ids = cUFL(first_stage_ids)
        first_stage_ids = [signature_dir + "/" + x for x in first_stage_ids]
        fst['ids'] = first_stage_ids
        fst = fst.set_index("ids")
        return(first_stage_ids)


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
