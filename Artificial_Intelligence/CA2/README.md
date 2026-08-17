# Spoken Digit & Speaker Recognition with Hidden Markov Models

A speech recognition system that classifies spoken digits (0–9) and identifies the speaker from short audio recordings, built as the second assignment for an Artificial Intelligence course. Two independent HMM implementations are compared head-to-head: one built with the `hmmlearn` library, and one implemented from scratch (forward-backward algorithm, Expectation-Maximization / Baum-Welch re-estimation).

**Institution:** University of Tehran, School of Electrical and Computer Engineering
**Course:** Artificial Intelligence
**Author:** Babak Hosseini Mohtasham
**Assignment specification:** [`AI-A2.pdf`](./AI-A2.pdf)

---

## Overview

The dataset consists of `.wav` recordings from 6 speakers, each pronouncing every digit (0–9) 50 times (the [Free Spoken Digit Dataset](https://github.com/Jakobovski/free-spoken-digit-dataset)). Each recording is converted into a sequence of MFCC (Mel-Frequency Cepstral Coefficient) feature vectors, and a separate HMM is trained per class — either one HMM per digit (ignoring speaker) or one HMM per speaker (ignoring digit). At inference time, an unseen recording is classified by scoring it against every trained HMM and picking the model with the highest log-likelihood.

**Objectives:**

1. Explore and justify a suitable audio feature representation (waveform, spectral centroid/bandwidth, spectrogram, zero-crossing rate, RMS energy, chroma, mel-spectrogram, MFCCs) for digit/speaker discrimination, and select MFCC configuration (14 coefficients, liftering) based on experimentation.
2. Train Gaussian HMMs per class using the `hmmlearn` library as a reference implementation.
3. Implement an HMM from scratch — including the forward-backward algorithm for likelihood computation and the Expectation-Maximization (Baum-Welch) procedure for parameter re-estimation — without relying on any HMM library.
4. Evaluate and compare both implementations on two independent tasks (digit classification and speaker identification) using a full multi-class evaluation suite (confusion matrix, per-class precision, macro-averaged precision/F1, accuracy), and analyze why the two implementations diverge in performance.

## Methodology

| Component | Description |
|---|---|
| **Dataset** | Free Spoken Digit Dataset: 6 speakers × 10 digits × 50 recordings = 3,000 `.wav` files, sampled at 11,025 Hz |
| **Feature extraction** | 14 MFCCs per frame (via `librosa`, with liftering coefficient 90, tuned empirically), used as the observation sequence for each HMM |
| **Task 1 — Digit classification** | One HMM per digit (10 classes), trained on MFCC sequences pooled across all speakers |
| **Task 2 — Speaker identification** | One HMM per speaker (6 classes), trained on MFCC sequences pooled across all digits |
| **Library implementation** | `hmmlearn.hmm.GaussianHMM`, 6 hidden states (digit task) / 10 hidden states (speaker task), 10 EM iterations |
| **From-scratch implementation** | Custom `HMM` class implementing the forward and backward algorithms, an EM-based re-estimation step for the initial/transition/emission parameters, and per-sequence log-likelihood scoring for classification |
| **Evaluation** | 80/20 train/test split per class; classification by maximum-likelihood scoring against all trained models; confusion matrix, accuracy, per-class precision, macro-averaged precision and F1 computed for each of the four resulting models |

## Repository Structure

| Path | Description |
|---|---|
| [`AI-A2.ipynb`](./AI-A2.ipynb) | Full implementation: feature exploration, both HMM implementations, evaluation, and written answers to the assignment's conceptual questions |
| [`AI-A2.pdf`](./AI-A2.pdf) | Original assignment specification (a separate Bayes Nets theory section, plus the HMM/speech specification) |

> **Note on data:** per the assignment's submission rules, the audio dataset itself is not included in this repository. The notebook expects a `recordings/` directory (files named `{digit}_{speaker}_{index}.wav`) in the working directory to reproduce results from scratch; see [Reproducing the Results](#reproducing-the-results).

## Key Results

**The `hmmlearn` models substantially outperformed the from-scratch implementation on both tasks:**

| Task | Model | Accuracy | Macro Avg. Precision | Macro Avg. F1 |
|---|---|---|---|---|
| Digit classification (10 classes) | hmmlearn | **91.8%** | 92.2% | 91.8% |
| Digit classification (10 classes) | From scratch | 74.3% | 76.4% | 72.5% |
| Speaker identification (6 classes) | hmmlearn | **98.8%** | 98.8% | 98.8% |
| Speaker identification (6 classes) | From scratch | 85.5% | 87.1% | 85.7% |

**Speaker identification was substantially easier than digit classification for both implementations** — consistent with speaker identification being a 6-class problem with more training data per class (400 recordings/speaker vs. 240/digit) and speaker-distinguishing acoustic cues (pitch, timbre) tending to be more consistent than digit-distinguishing phonetic cues across a 10-class vocabulary.

**The gap between implementations is attributed to modeling detail, not the underlying algorithm.** The from-scratch model keeps emission covariances fixed rather than re-estimating them during EM, and exposes fewer tunable hyperparameters than `hmmlearn`'s more mature implementation — both plausible contributors to its consistently lower precision across nearly every class in both tasks.

**A small out-of-distribution test (the author's own voice) caused both models to fail** (~10–30% accuracy), attributed to a training set of only 6 speakers, a `.ogg`-vs-`.wav` format mismatch, and higher recording noise — illustrating the models' sensitivity to distribution shift. (This test's recordings are not included in the dataset per the assignment's instructions, so the corresponding notebook cells are commented out.)

*(Full discussion of audio feature selection, MFCC robustness, HMM theory — including a comparison of first-order HMMs, higher-order HMMs, and alternative sequence models such as MEMMs and linear-chain CRFs — and the evaluation-metric derivations are in the notebook.)*

## Reproducing the Results

1. Install dependencies: `pip install numpy librosa matplotlib seaborn scipy hmmlearn`.
2. Download the [Free Spoken Digit Dataset](https://github.com/Jakobovski/free-spoken-digit-dataset) recordings into a `recordings/` directory alongside the notebook, with filenames in the form `{digit}_{speaker}_{index}.wav` (speakers: `george`, `jackson`, `lucas`, `nicolas`, `theo`, `yweweler`; 50 recordings per speaker per digit).
3. Open [`AI-A2.ipynb`](./AI-A2.ipynb) and run all cells. The notebook loads all recordings, extracts MFCC features, trains both the `hmmlearn`-based and from-scratch HMMs for the digit and speaker tasks, and produces confusion matrices and evaluation metrics for each.

## Notes on Scope

- The assignment PDF also includes an unrelated theory section on Bayes Nets (probabilistic inference, Variable Elimination) for the same course module; this README and repository cover only the HMM speech-recognition portion.
- The from-scratch `HMM` class implements a first-order, discrete-time Gaussian-emission HMM; it does not implement all the refinements found in `hmmlearn` (e.g. covariance re-estimation during EM), which is the primary hypothesized cause of its lower accuracy relative to the library implementation.
- The 91.8% / 98.8% accuracy figures above refer specifically to the `hmmlearn`-based models on the digit and speaker tasks respectively; the from-scratch implementation's accuracy on the same tasks is reported alongside for direct comparison.
