from refgenconf import RefGenConf
from pathlib import Path

def assert_refgenie_asset_exists(
    genome, asset, tag=None, seek_key=None, refgenie_config=None
):
    # instantiate RefGenConf object
    rgc = RefGenConf(filepath=refgenie_config)

    # get tag of interest, provided vs. default
    tag = tag if tag is not None else rgc.get_default_tag(genome=genome, asset=asset)

    # list assets available locally
    list_result = rgc.list()

    # check whether the asset of interest is missing
    if genome not in list_result.keys() or asset not in list_result[genome]:
        # pull asset if missing
        print(f"{genome}/{asset}:{tag} not found, pulling...")
        try:
            rgc.pull(genome=genome, asset=asset, tag=tag)
        except Exception as e:
            print(f"Pull failed")
            raise

    # get the local path to the asset of interest
    rgc.seek(genome=genome, asset=asset, tag=tag, seek_key=seek_key)


Path(snakemake.output[0]).touch()

assert_refgenie_asset_exists(
    genome ="hg38",
    asset ="salmon_sa_index",
    refgenie_config = snakemake.output[0]
)

Path(snakemake.output[1]).touch()

