"""
Database and output locations for the pipeline
"""

### OUTPUT DIRECTORY
if config['DBDIR'] is None:
  DBDIR = '/hpcfs/users/a1667917/Reference_Rat_Transcriptome/'
else:
  DBDIR = config['DBDIR']

### OUTPUT DIRECTORY
if config['Output'] is None:
  OUTPUT = 'rna_seq_out'
else:
  OUTPUT = config['Output']

# needs to be created before fastqc is run
if not os.path.exists(OUTPUT):
  os.makedirs(OUTPUT)

### OUTPUT DIRs
RESULTS = os.path.join(OUTPUT, 'RESULTS')
QC = os.path.join(OUTPUT, 'QC')
BAM_STATS = os.path.join(QC, 'BAM_STATS')
FLAGS = os.path.join(OUTPUT, 'FLAGS')
WORKDIR = os.path.join(OUTPUT, 'PROCESSING')
TMP = os.path.join(WORKDIR, 'TMP')
R_OBJECTS = os.path.join(WORKDIR, 'R_OBJECTS')
LOGS = os.path.join(OUTPUT, 'LOGS')




# # needs to be created before fastqc is run
# if not os.path.exists(RESULTS):
#   os.makedirs(RESULTS)

# # needs to be created for fastqc 
# if not os.path.exists(TMP):
#   os.makedirs(TMP)
