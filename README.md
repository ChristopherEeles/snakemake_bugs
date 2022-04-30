# Bug Reprex

Running:
```
python -m pdb -m snakemake --cores 10 --groups test_rule=batch1 test_rule2=batch2 --group-components batch1=10 --cluster "slurm" --jobs 202
```

Breakpoint at snakemake:workflow.py:851 for 6.15.5 to inspect `dag` object
after call to `dag.preprocess`.