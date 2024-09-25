import yaml

from .database import scoped_session
from .deployment import create_deployment


def upload_results(system_info_filename, jitter_results_filename):
    """Read LiCoRICE benchmark results frome file and upload to database.

    Args:
        system_info_filename (str): Filename of YAML file containing LiCoRICE
            system information.
        jitter_results_filename (str): Filename of CSV file containing LiCoRICE
            jitter benchmark results

    Returns:
        None
    """

    # read system info
    with open(system_info_filename, "r") as f:
        try:
            system_info = yaml.safe_load(f)
        except yaml.YAMLError as e:
            raise ValueError(f"Invalid system info YAML file: {e}")
    print(system_info)

    # read jitter results CSV. assume last line is most recent result
    with open(jitter_results_filename, "r") as f:
        jitter_results = f.read().strip().split("\n")[-1].split(",")
    jitter_results = {
        "mean": jitter_results[0],
        "std_dev": jitter_results[1],
        "min_val": jitter_results[2],
        "max_val": jitter_results[3],
    }
    print(jitter_results)

    create_deployment(
        {"system_info": system_info, "jitter_results": jitter_results}
    )
