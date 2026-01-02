# MALCA — Toy Demonstration (RF-RFE + Random Forest)

## Direct carbapenemase typing from disc diffusion antibiograms with MALCA  
**MAchine Learning CArbapenemase**

**Cécile EMERAUD**<sup>1,2,3</sup>, **Yahia BENZERARA**<sup>4</sup>, **Hippolyte DE SWARDT**<sup>2</sup>,  
**Alexandra AUBRY**<sup>5,6</sup>, **Nicolas VEZIRIS**<sup>4</sup>, **Agnès B. JOUSSET**<sup>1,2,3</sup>,  
**Inès REZZOUG**<sup>1,2,3</sup>, **Léna LATOUR**<sup>2</sup>, **Alice PAGÈS**<sup>2</sup>,  
**Sarah RONSIN**<sup>2</sup>, **Corentin POIGNON**<sup>5,6</sup>, **Rémy A. BONNIN**<sup>1,2,3</sup>,  
**Mariette MATONDO**<sup>7</sup>, **Quentin GIAI GIANETTO**<sup>7,8</sup>, **Laurent DORTET**<sup>1,2,3</sup>,  
**Alexandre GODMER**<sup>4,5,6,7</sup>\*

\*Corresponding author

---

## Affiliations

1. Bacteriology–Hygiene Unit, Bicêtre Hospital, AP-HP (Assistance Publique–Hôpitaux de Paris), Le Kremlin-Bicêtre, France  
2. Team “Resist”, UMR1184 *Immunology of Viral, Auto-Immune, Hematological and Bacterial Diseases (IMVA-HB)*,  
   INSERM, Université Paris-Saclay, CEA, Le Kremlin-Bicêtre, France  
3. Associated French National Reference Center for Antibiotic Resistance:  
   Carbapenemase-Producing Enterobacterales, Le Kremlin-Bicêtre, France  
4. Department of Bacteriology, Saint-Antoine Hospital, AP-HP, Sorbonne Université, Paris, France  
5. Sorbonne Université, INSERM, U1135, Centre d’Immunologie et des Maladies Infectieuses (Cimi-Paris), Paris, France  
6. AP-HP, Sorbonne Université, Pitié-Salpêtrière Hospital,  
   National Reference Center for Mycobacteria and Mycobacterial Drug Resistance, Paris, France  
7. Institut Pasteur, Université Paris Cité, Proteomics Platform,  
   Mass Spectrometry for Biology Unit, CNRS UAR 2024, Paris, France  
8. Institut Pasteur, Université Paris Cité, Bioinformatics and Biostatistics Hub, Paris, France  

---

## Repository content

This GitHub repository provides a **minimal, single-file R demonstration** of a MALCA-like workflow, including:

- generation of **synthetic** disk diffusion diameter data,
- **Random Forest–based Recursive Feature Elimination (RF-RFE)**,
- training of a **Random Forest** classifier,
- evaluation on a held-out test set,
- computation of a simple **confidence score**, defined as the **maximum predicted class probability**.

> **Important**  
> This repository uses **synthetic data only** and is intended **solely for methodological demonstration and tutorial purposes**.

---

## Requirements

- R ≥ 4.0 (a recent version is recommended)
- R packages:
  - `caret`
  - `randomForest`
  - `pROC`

### Install dependencies

From within R:

```r
install.packages(c("caret", "randomForest", "pROC"))
## Run the demo
## From the repository root, run:
Rscript malca_demo.R
```

The script outputs:

- selected variables from RF-RFE,

- model summary,

- confusion matrix on the held-out test set,

- performance on a high-confidence prediction subset,

- a one-vs-rest AUC example (OXA-48 vs. others),

- sessionInfo() for reproducibility.


## License, intellectual property, and patent notice

This repository is distributed under the **MALCA Software License — Evaluation and Non-Commercial Research Only**  
(see the `LICENSE` file for full terms).

### Permitted use
- Internal evaluation  
- Non-commercial academic research  

### Prohibited use
- Clinical or diagnostic use  
- Regulatory use  
- Any commercial deployment  

### Redistribution
Redistribution, sublicensing, or making the Software available to third parties is **not permitted** without prior written authorization from the rightsholder(s).

### Patent notice
No patent rights are granted under this license.  
This includes, but is not limited to, **FR2415430** and related patent applications.

For any use of MALCA in a product, clinical workflow, or commercial setting, please contact the rightsholder institution(s) to discuss a separate licensing agreement.

---

## Notes on transparency

This public repository is a **toy implementation** designed to illustrate the **methodological structure**  
(RF-RFE + Random Forest) without releasing clinical isolate-level data or the full patented implementation.

In the associated study, model development and validation were conducted on clinical collections under applicable data governance, ethical, and intellectual property constraints.

For scientific evaluation requests (e.g., reviewers or editors), please contact the corresponding author to discuss controlled access to additional materials, subject to institutional policies and IP agreements.
