# 1.0 RFdiffusion


## Workflow

```mermaid
graph TD
    A[RFdiffusion] --> B[Input Files Preparation]
    B --> C[Edit Diffusion Scripts]
    C --> D[Run RFdiffusion]
    D --> E[Visualize Results in PyMOL]
```

## 1.1 Additional file building
RFdiffusion needs additional files to interpret the geometry and topology of the target protein, guiding the structure generation/design around it.
You will need to run the following:

```bash
module load Miniconda3/24.7.1-0
cd workshop/binding-protein/input/
python /data1/projects/pi-vriesendorpb/shared/RFdiffusion_forked/helper_scripts/make_secstruc_adj.py --input_pdb 2qud.pdb --out_dir ./
```

This will generate two different files:
- `*adj.pt`: the adjacency matrix (as a PyTorch tensor), encoding spatial proximity of residues.
- `*ss.pt`: the secondary structure annotations, often derived from DSSP.

## 1.2 Updating the running script
Run the following to view the script we'll run for the RFdiffusion for a binder-protein for our target protein:

```bash
cat rfdiffusion_hp1.sh
```

Change the scripts to match with the potential hotspots, you can run:

```bash
sed -i 's/placeholder/A5,A9,A10,A11,A12/g' rfdiffusion_hp1.sh
sed -i 's/placeholder/B5,B8,B9,B10,B11/g' rfdiffusion_hp2.sh
```
> [!NOTE]
> I already have identified some hotspots of the protein we're currently working on, [2QUD](https://www.rcsb.org/structure/2QUD), PP7 bacteriophage coat protein in complex, a part of [1DWN](https://www.rcsb.org/structure/1DWN):
> ![identified hotpots of 2QUD](assets/hotspot_2qud_2.png)
> Identified hotspots of 2QUD
> - purple and light blue: 2QUD as homodimer.
> - pink: hotspot 1, residues: A5,A9,A10,A11,A12.
> - yellow: hotspot 2, residues: B5,B8,B9,B10,B11.

> [!IMPORTANT]
> As the creators of this tools say "RFdiffusion is an extremely powerful binder design tool but it is not magic. In this section we will walk through some common pitfalls in RFdiffusion binder design and offer advice on how to get the most out of this method."

### Selecting a target site
Not all sites on a target protein are suitable for binder design. Binding sites should have at least three hydrophobic residues to interact with. Binding to charged polar sites is still quite difficult. Binding to sites with nearby glycans is also difficult because they frequently become ordered during binding, incurring an energetic cost.

### Picking Hotspots
Hotspots are a feature added to RFdiffusion to allow for control over the site on the target with which the binder will interact. In their paper, they defined a hotspot as a residue on the target protein that is within 10A Cbeta distance of the binding site. Of all the hotspots identified on the target, 0-20% are actually provided to the model, while the remainder are masked. This is critical for understanding how you should select hotspots during inference time.; the model anticipates having to make more contacts than you specify. We usually recommend between 3 and 6 hotspots.
> [!NOTE]
> What is Cbeta distance?
> It is the spatial distance between the Cβ (c(carbon)beta) atoms of two amino acid residues.

## Back to the workshop, Updating the running script
To visualise the change we just made in the script, you can run to following to confirm the changes:

```bash
cat rfdiffusion_hp1.sh
```
*Can you spot the difference?*

## 1.3 Running RFdiffusion
Now we are all set to run the diffusion script. This step will take around 6 minutes to generate a binding-protein.

```bash
sbatch rfdiffusion_hp1.sh
sbatch rfdiffusion_hp2.sh
```

You can view the progress by running: `squeue --me`.

## 1.4 Visualisation of the binding-protein
After running RFdiffusion you can now visualise the `pdb` files using PyMOL.

```bash
cd ../output
```

Now on the left of the screen you can see the files, dubble click the pdb files. the file will open in PyMOL.
- How does it look?
- Did it generate a binding-protein near the hotspot?
- Is there a difference between the hp1 and hp2?
- When viewing the protein sequence (click on the `seq` button in the right bottom corner), what do you notice about the sequence of the binding-protein, compared to the target protein?

> [!TIP]
> You may have noticed that RFdiffusion-designed binders produce a poly-Glycine sequence. This isn't a bug. Because RFdiffusion is a backbone-generation model, it does not generate sequence for the designed region; thus, another method must be used to assign a sequence to the binding sites. To design sequences, I used ProteinMPNN in this pipeline, as described in the paper on which it was based. Intersted, click [here to find some more information](https://github.com/dauparas/ProteinMPNN).

**After this you can close pymol.**

-----

# 2.0 AlphaFold3
I've provided you with the fasta files and json files to run AlphaFold3. You can either copy and paste the sequences into the [webserver of alphafold3](https://alphafoldserver.com/) or you can run them on the HPC (high preformance computer) ALICE. The locally installed requires another type of input that I have provided in the [input folder](binding-protein/alphafold3/) and is called `alphafold3input.json`.

![AlphaFold3_prediction](assets/af3_combined.png)
AlphaFold3 prediction of a target protein and de novo generated binding-protein with interaction prediction.
- Blue: target protein
- Purple: de novo binding-protein
- Light blue and pink: predicted interacting residues.

## Workflow
```mermaid
graph TD
    A[Start AlphaFold3 Workflow] --> B[Choose Run Method: Online or HPC]
    B --> C[Prepare Input Files, FASTA or JSON]
    C --> D[Run AlphaFold3 Prediction]
    D --> E[View Output Files .pdb]
    E --> F[Visualize & Evaluate Predicted Complex]
    F --> G[End]
```
## 2.1 Running online 
- Copy the fasta sequences of `2qud.fasta`, `binder_hp1.fasta` and, `binder_hp2.fasta` in the alphafold3 folder.
- Paste the sequence for 2qud and one of the two binding-proteins.
- Run en preview the job.
	- Repeat step 2 for the other binding-protein.
- Review the complex:
	- What do you see?
	- Did AF3 predict the bindingsite like in the first part of the workshop?

> [!NOTE]
> Do you want to learn more about alphafold3 and what you can do with it dont hesitate to ask, there is also a more detailed workshop given "Using AlphaFold on local HPC ALICE for upscaling and better predictions".

## 2.2 Running on HPC
First move to the right folder (directory) using the command `cd`. Using `ls` you can look in the directory youre currently in.

```bash
ls
cd ../../alphafold3
```
### 2.3 JSON generation
View the `.json` files.

```bash
cat *.json
```
This is the format AF3 wants to have the sequences inputted.

### 2.4 Running RFdiffusion
Now we are ready to run the AF3 prediction.
```bash
sbatch afprediction_hp1.sh
sbatch afprediction_hp2.sh
```
This will take around 10-45mins to complete, hence I have prepared the output for you.

### 2.5 Visualisation
Now move to the output folder
```bash
cd output
ls
```
There are two folders each containing all the run details and files of each prediction, you can use the left side of MobaXterm to double click and open de folders and also the `.pdb` files.
- What do you see?
- Did AF3 predict the bindingsite like in the first part of the workshop?

*You can close pymol again*

