import logging
import os

import azure.functions as func
from azure.storage.filedatalake import FileSystemClient


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    input_dl_key = os.environ.get("input_dl_key")
    input_dl_name = os.environ.get("input_dl_name")
    input_dl_fs_name = os.environ.get("input_dlfs_name")
    file_system_client = FileSystemClient(account_url=f"https://{input_dl_name}.dfs.core.windows.net", file_system_name=input_dl_fs_name, credential=input_dl_key)

    test_file = file_system_client.create_file("test.txt")

    chunk_size_in_bytes = 1024*1024
    number_of_chunks = 128
    for i in range(number_of_chunks):
        random_bytes = os.urandom(chunk_size_in_bytes)
        test_file.append_data(data=random_bytes, offset=i*chunk_size_in_bytes)
        logging.info(f'Appended {i}-th chunk of data')

    test_file.flush_data(offset=chunk_size_in_bytes*number_of_chunks)
    logging.info('Flushed the data')

    return func.HttpResponse(
        f"Sucessfully created a {chunk_size_in_bytes*number_of_chunks}-bytes file",
        status_code=200
    )
