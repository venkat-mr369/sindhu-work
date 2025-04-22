Based on the image, you’ve been asked to do the following tasks related to Google Cloud Run, VPC connectors, and Internal Load Balancing (ILB):

---

### **Tasks Breakdown & Steps**

#### **Create Cloud Run (admin portal UI and backend) in central and east**
**Goal:** Deploy two Cloud Run services (UI and backend) in `us-central1` and `us-east1`, each associated with a **new serverless VPC connector**.

---

#### **Step-by-step instructions:**

##### **Step 1: Create Serverless VPC Connectors**
Do this for both regions (`us-central1` and `us-east1`):

```bash
# Example for us-central1
gcloud compute networks vpc-access connectors create central-vpc-connector \
  --region=us-central1 \
  --network=default \
  --range=10.8.0.0/28

# Example for us-east1
gcloud compute networks vpc-access connectors create east-vpc-connector \
  --region=us-east1 \
  --network=default \
  --range=10.8.0.16/28
```

> Adjust `--network` and `--range` as needed.

---

##### **Step 2: Deploy Cloud Run services**
Assuming you have two services (`admin-ui` and `admin-backend`), deploy them like this:

```bash
# Deploy UI in central
gcloud run deploy admin-ui \
  --image=gcr.io/YOUR_PROJECT_ID/admin-ui-image \
  --region=us-central1 \
  --vpc-connector=central-vpc-connector \
  --allow-unauthenticated

# Deploy Backend in east
gcloud run deploy admin-backend \
  --image=gcr.io/YOUR_PROJECT_ID/admin-backend-image \
  --region=us-east1 \
  --vpc-connector=east-vpc-connector \
  --allow-unauthenticated
```

Replace `YOUR_PROJECT_ID` and image names accordingly.

---

#### **3) Create new ILB in claims IVR VPC**
**Goal:** Create an **Internal Load Balancer** that uses **Cloud Run services** as **serverless NEG backends**.

---

##### **Step 3.1: Create a serverless NEG for each Cloud Run**
```bash
# UI NEG in central
gcloud compute network-endpoint-groups create ui-neg-central \
  --region=us-central1 \
  --network-endpoint-type=serverless \
  --cloud-run-service=admin-ui

# Backend NEG in east
gcloud compute network-endpoint-groups create backend-neg-east \
  --region=us-east1 \
  --network-endpoint-type=serverless \
  --cloud-run-service=admin-backend
```

---

##### **Step 3.2: Create backend services and attach NEGs**
```bash
gcloud compute backend-services create cloudrun-ilb-backend \
  --load-balancing-scheme=internal \
  --protocol=HTTP \
  --region=us-central1

gcloud compute backend-services add-backend cloudrun-ilb-backend \
  --region=us-central1 \
  --network-endpoint-group=ui-neg-central \
  --network-endpoint-group-region=us-central1

gcloud compute backend-services add-backend cloudrun-ilb-backend \
  --region=us-central1 \
  --network-endpoint-group=backend-neg-east \
  --network-endpoint-group-region=us-east1
```

---

##### **Step 3.3: Create URL map and forwarding rule**
```bash
gcloud compute url-maps create ilb-url-map \
  --default-service=cloudrun-ilb-backend

gcloud compute target-http-proxies create ilb-proxy \
  --url-map=ilb-url-map

gcloud compute forwarding-rules create ilb-rule \
  --load-balancing-scheme=internal \
  --address=YOUR_INTERNAL_IP \
  --ports=80 \
  --region=us-central1 \
  --subnet=YOUR_SUBNET \
  --target-http-proxy=ilb-proxy \
  --network=YOUR_VPC_NAME
```

Replace:
- `YOUR_INTERNAL_IP` with a reserved internal IP.
- `YOUR_SUBNET` with subnet in IVR VPC.
- `YOUR_VPC_NAME` with actual VPC name (e.g., `claims-ivr-vpc`).

---

