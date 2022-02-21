"""
Database and output locations for the pipeline
"""


DBDIR = 'Databases'

### OUTPUT DIRECTORY
if config['Output'] is None:
  OUTPUT = 'rna_seq_out'
else:
  OUTPUT = config['Output']


### OUTPUT DIRs
RESULTS = os.path.join(OUTPUT, 'RESULTS')
QC = os.path.join(OUTPUT, 'QC')
FLAGS = os.path.join(OUTPUT, 'FLAGS')
WORKDIR = os.path.join(OUTPUT, 'PROCESSING')
TMP = os.path.join(WORKDIR, 'TMP')
LOGS = os.path.join(OUTPUT, 'LOGS')




# # needs to be created before fastqc is run
# if not os.path.exists(RESULTS):
#   os.makedirs(RESULTS)

# # needs to be created for fastqc 
# if not os.path.exists(TMP):
#   os.makedirs(TMP)
