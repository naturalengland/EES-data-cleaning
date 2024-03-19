# EES-data-cleaning
Scripts to clean Sweet data

This repository contains the scripts used to clean data which comes out of sweet. 
There is one script file per feature, and each file contains code to clean both properties data and related tables data.
The cleaning process includes:
          - Removing dummy data
          - Removing test data
          - Removing QA data

A version of cleaned data is available as a feature layer on AGOL. This was uploaded in January 2024, and therefore is out of date.
A new version needs to be created shortly (tbc when) with a few minor changes:
    - Stands data needs to include 'surface' within 'roundrats'
    - Code needs to be looked through and QA'd to make sure no mistakes (I've found a couple since January upload)
