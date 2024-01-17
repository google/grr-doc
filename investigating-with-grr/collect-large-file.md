Collect Large File
==================

Collect large file flow is used to upload a potentially large file to the Google Cloud Storage. A [signed URL](https://cloud.google.com/storage/docs/access-control/signed-urls) needs to be provided, to which the file will be uploaded.
The flow returns a [session URL](https://cloud.google.com/storage/docs/resumable-uploads#session-uris) which can be used to monitor or [cancel](https://cloud.google.com/storage/docs/performing-resumable-uploads#cancel-upload) the upload.


Decrypting the file
-------------------

The uploaded file is encrypted and can be decrypted using the Python API:
```python
from grr_api_client import api

grrapi.Client("C.ABCDEF0123456789").Flow("0123456789ABCDEF").Get().DecryptLargeFile(
        input_path="encrypted_file", output_path="decrypted_file")
```

or the [command line API shell](https://github.com/google/grr/tree/master/api_client/python#using-command-line-api-shell):
```bash
gsutil cat gs://bucket/encrypted_file | \
grr_api_shell --basic_auth_username "user" --basic_auth_password "pwd" \
    --exec_code 'grrapi.Client("C.1234567890ABCDEF").Flow("F:BB628B23").Get().DecryptLargeFile()' \
    http://localhost:1234 > decrypted_file
```

Note
----
This flow cannot run as fleet collection.
