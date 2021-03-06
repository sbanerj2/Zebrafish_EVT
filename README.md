# Zebrafish_EVT
Codes for Zebrafish model using EVT

1. svmtrain_pareto_mh.m/svmtrain_pareto_random.m: This is the Metropolis-Hastings sampling/ random sampling example with pareto distribution for control data.
Olfactory data uses normal distribution. It just trains the SVM model and generates accuracy on the 20% data held out for testing (Experiment 3).
Uses Matlab 2017B.

2. normal_vs_weibull.m: This is the example for showing the difference with normal distribution 
and extreme value distribution (Experiment 1). Prints the difference as curves. Uses Matlab 2017B.

3. mh_pareto.m: This is the weibull fit curve for olfactory(normal distribution) and 
control(generalized Pareto distribution) with M-H sampling algorithm (Experiment 2). Uses Matlab 2017B.

4. random_pareto.m: This is the weibull fit curve for olfactory(normal distribution) 
and control(generalized Pareto distribution) with random sampling (Experiment 2). Uses Matlab 2017B.

5. zebra_ann.py: Python program (Experiment 3) to train on samples generated through MH sampling, a variant of MCMC sampling (via program,svmtrain_pareto_mh.m).
Dependencies: Python 2.7, scikit-learn, pandas, numpy.

6. JPhysio05review_control5.xlsx : Original data collected from wet-bench experiment for RGC responses without olfactory signal.

7. JPhysio05review_olfactory.xlsx: Original data collected from wet-bench experiment for RGC responses with olfactory signal.

8. RGC_responses.csv: sample file for training MLP classifier.

If you find this work useful in your research and publication, please cite our work:

@article{banerjee2018extreme,
  title={An Extreme Value Theory Model of Cross-Modal Sensory Information Integration in Modulation of Vertebrate Visual System Functions},
  author={Banerjee, Sreya and Scheirer, Walter J and Li, Lei},
  journal={bioRxiv},
  pages={423038},
  year={2018},
  publisher={Cold Spring Harbor Laboratory}
}
