import os


api_keys = {
    'serp_api' : os.getenv('serp_api_key'),
    'zenodo_api': os.getenv('ZENODO_API_KEY'),
    'core_api': os.getenv('core_api_key')
}
