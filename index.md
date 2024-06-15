# Exploring Developmental Plasticity in Spadefoot Toads

**Welcome to my Master's Thesis project page!** 
Here, I document my journey in exploring the developmental plasticity of Spadefoot Toads using RNA sequencing (RNAseq). This project aims to uncover the genetic underpinnings of how these amphibians adapt and evolve.

## Summary 
Phenotypic plasticity allows organisms to alter gene expression and phenotype in response to environmental changes. Recent evidence highlights environmentally induced changes in gene regulation, revealing the environment as both a selective agent and a phenotypic inducer. Genetic accommodation, where the degree of plasticity is modulated in response to persistent environmental conditions, suggests an evolutionary mechanism driven by plasticity, though its underlying mechanisms remain largely unknown. To fully understand the mechanisms behind phenotypic plasticity and genetic accommodation, exploring these processes at finer geographical and temporal scales than speciation is crucial. We investigated adaptive developmental plasticity in _Pelobates cultripes_, a highly plastic spadefoot toad species spread in the Iberian peninsula, responsive to environmental stressors like pond drying. Using a transcriptomic RNA-seq approach, we compared gene expression profiles of _P. cultripes_ tadpoles from Central and Southern Spain populations exposed to different water levels. Here, we seek to identify differentially expressed genes (DEGs) involved in these tadpoles larval development acceleration under desiccation stress. Our results indicate that Southern Spain populations exhibit a higher number of DEGs in response to low water levels compared to Central Spain populations, possibly accounting for the different plasticity levels of populations and developmental rates. By examining gene expression patterns across diverse populations and environmental conditions, we underscore the importance of comprehensive studies on genetic accommodation, contributing to a broader understanding of how organisms adapt to rapidly changing environments.


## The RNAseq Workflow

![Workflow](/assets/workflow.jpg)

0. **Exprimental Design and Data Obtention**
   ![Sequence Quality Control](/assets/sequence-quality-control.jpg)  
   [More about Sequence Quality Control](/Experimental_Design.Rmd)

1. **Sequence Quality Control**
   ![Sequence Quality Control](/assets/sequence-quality-control.jpg)  
   [More about Sequence Quality Control](/Quality_Control.Rmd)

2. **Contaminants Removal** (rRNA removal, bbsplit)
   [More about Removing Contaminants with bbsplit](/rmd_for_github/Contaminants_Removal_bbsplit.md)
   [More about Removing ribosomal RNA with Ribodetector](/rmd_for_github/ribodetector.md)

4. **Quasi-Mapping and Quantification** (Salmon)
   [More about Alignment and Mapping](/rmd_for_github/Salmon.Rmd)

5. **Differential Expression Analysis**
   [More about Differential Expression Analysis](/DESeq2.Rmd)

6. **Functional Enrichment Analysis**
   [More about Functional Enrichment Analysis](/Enrichment.Rmd)

### About The Research Group
Learn more about the research group in the following web [Eco-Evo-Devo Lab](/https://www.eco-evo-devo.com/).



