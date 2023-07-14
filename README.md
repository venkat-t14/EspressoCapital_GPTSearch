# Template for deploying Jupyter Notebook REST API

## SECRET values to be provided by Tapu on request:

- `<SERVICE_ACCOUNT_EMAIL>`: Service Account Email with necessary permissions for deployment.

## Prerequisite libraries/softwares

- Required for Deployment:
  - [google-cloud-sdk](https://cloud.google.com/sdk/docs/install)
  - docker (or Docker Desktop)
- Required for local testing:
  - jupyter_kernel_gateway
  - libraries in `requirements.txt`

## Command for local testing:

From the `notebooks` directory, start the notebook API Server at `http://127.0.0.1:9090` using command below:

```
jupyter kernelgateway --api='kernel_gateway.notebook_http' --seed_uri='main.ipynb' --port 9090
```

## Authorize Docker to push images to Google Cloud Registry

After installing both `google-cloud-sdk` & `docker`:

1. [Authorize Google Cloud SDK](https://cloud.google.com/sdk/docs/authorizing) using your obv.ai User email.

## Folder structure Requirements:

- There must be only 1 notebook per Project/Service. Rename it to `main.ipynb`.
- Always keep `main.ipynb` in `notebooks` folder, including any files imported by `main.ipynb`.
- If your notebook requires libraries other than the ones included in `requirements.txt`, add them to `requirements.txt`.

## Terminal Command for listing deployed Notebook API Services:

```
gcloud run services list --region us-central1 --impersonate-service-account=<SERVICE_ACCOUNT_EMAIL>
```

## Terminal Command for deleting deployed Notebook API Service:

```
gcloud run services delete <UNIQUE_PROJECT_NAME> --region us-central1 --impersonate-service-account=<SERVICE_ACCOUNT_EMAIL>
```

## Instructions for deployment:

Use `build_run.sh` to deploy Notebook API Server as a microservice to **Google Cloud Run**.
This script requires 2 argument values:

- `--name`: A unique name for this Jupyter Notebook API Service. Otherwise, this will **OVERRIDE** existing Service with the same name. Use terminal command above to confirm your Service name is unique.
- `--svc-acc-email`: Service Account Email `<SERVICE_ACCOUNT_EMAIL>`. Will be provided by Tapu on request

```
# If running for first time:
chmod +x build_run.sh
# Start deployment
./build_run.sh --name <UNIQUE_PROJECT_NAME> --svc-acc-email <SERVICE_ACCOUNT_EMAIL>
```

After successful execution, deployed Notebook API endpoint(s) will be accessible via the **Service URL**. This URL is included in the Cloud Build logs; below is an example snippet of the output:

```
latest: digest: sha256:50a2e4693dbea7b37a4dd65ca2d9045e9b889cf3d4948118562e861617cc407f size: 4069
Deploying container to Cloud Run service [notebook-server] in project [xx-xxx-xxxx] region [us-central1]
✓ Deploying new service... Done.
  ✓ Creating Revision... Creating Service.
  ✓ Routing traffic...
  ✓ Setting IAM Policy...
Done.
Service [notebook-server] revision [notebook-server-00001-toj] has been deployed and is serving 100 percent of traffic.
Service URL: https://notebook-server-xl3243gfga-uc.a.run.app
```
