# HR Data Pipeline with Azure Databricks and dbt

This project implements an **end-to-end HR data pipeline** on Azure, combining **Terraform**, **Airflow**, **Azure Databricks**, **dbt**, **Synapse**, and **Power BI**.

The goal is to automate infrastructure provisioning, data ingestion, transformation, and analytics to deliver HR insights in real time.

---

## 🧱 Architecture

<img width="1920" height="1080" alt="architecture" src="https://github.com/user-attachments/assets/e24f5669-38f3-4546-8d4c-87438f1fee8a" />

The architecture leverages Azure components such as:
- **Azure Databricks** for processing and analytics  
- **Azure Storage** for raw and curated layers (Bronze/Silver/Gold)  
- **Azure Synapse Studio** for serving and querying data  
- **Azure Key Vault** for secure credential management  
- **Airflow** to orchestrate the pipeline with **Terraform** and **dbt**

---

## ⚙️ Project Flow

### 1. Run Airflow DAGs
Execute Airflow DAGs to:
- Provision Azure infrastructure (Resource Group, Storage Account, etc.)
- Upload HR raw data into the **Bronze** container

<img width="702" height="425" alt="image" src="https://github.com/user-attachments/assets/b06317ef-6c8e-4712-93b5-5c18e78c27f2" />



---

### 2. Verify Azure Resource Group
Check in the Azure portal that all resources were successfully created.

<img width="1278" height="690" alt="image" src="https://github.com/user-attachments/assets/aadd0a7e-8051-4fb1-9f26-1a193c846440" />


---

### 3. Check Azure Storage
Ensure the required containers are present:
- **marlin-bronze**
- **marlin-silver**
- **marlin-gold**
<img width="1266" height="500" alt="image" src="https://github.com/user-attachments/assets/58cb7a35-b8c7-4ee8-940e-17b5ccf3859d" />


---

### 4. Verify Bronze Container
Open the Bronze container to confirm HR CSV files are uploaded correctly.

<img width="1045" height="421" alt="image" src="https://github.com/user-attachments/assets/cc0863a1-b3e4-4106-b8ca-b93a1f1c403d" />

---

### 5. Secure Access Keys with Key Vault
Use Azure **Key Vault** to store sensitive credentials like Storage Account keys.

<img width="1272" height="340" alt="image" src="https://github.com/user-attachments/assets/bee1b66c-9b3b-4ca7-ab9d-e0266a700b5d" />




---

### 6. Create Azure Databricks Workspace
Create and open a Databricks workspace for transformation and analytics.

---

### 7. Create Secret Scope in Databricks
Set up an **adbSecretScope** linked to the Key Vault for secure access.

<img width="1276" height="568" alt="image" src="https://github.com/user-attachments/assets/1be385d6-b432-43e8-a0fc-42352b5ce855" />

---

### 8. Mount Storage Containers in Databricks
Mount the **bronze**, **silver**, and **gold** containers into Databricks notebooks.

<img width="1044" height="1200" alt="image" src="https://github.com/user-attachments/assets/b65c0f44-44b1-4f3a-9792-579d2d3b6cc2" />


---

### 9. Create Database and Tables in Databricks
Create a database (e.g. `HumanResourceSD`) and external tables from the CSVs.

<img width="713" height="867" alt="image" src="https://github.com/user-attachments/assets/0c1c7e7b-6197-487e-b8a4-be1e27d8b36b" />


### 10. Connect Databricks to dbt
Use `databricks-cli` and generate a Personal Access Token (PAT) to integrate dbt with Databricks.

---

### 11. Define dbt Sources
Create `sources.yml` to declare Bronze-layer tables as dbt sources.

<img width="1198" height="487" alt="image" src="https://github.com/user-attachments/assets/4eb7202b-444e-47f5-8e83-c3b5a76bfcf0" />

---

---

### 12. Snapshot Raw Data (Silver)
Run dbt snapshots to track historical changes and store them in the **Silver** layer.

<img width="828" height="356" alt="image" src="https://github.com/user-attachments/assets/e4801735-8f69-4f79-bee6-075ffa2cbd5d" />

<img width="1032" height="581" alt="image" src="https://github.com/user-attachments/assets/77b6174d-cf22-4a4b-93df-5988972f65c9" />


---

### 13. Create Analytical Models (Gold)
Run dbt models to build dimensional and fact tables for analytics.

<img width="820" height="751" alt="image" src="https://github.com/user-attachments/assets/522f918d-6027-4063-9dd6-d7eef59cd96f" />

<img width="1023" height="755" alt="image" src="https://github.com/user-attachments/assets/155f270c-1c5a-43f8-b7ee-3215106c82ee" />


---

### 14. Run dbt Tests
Execute dbt tests to validate data integrity and relationships.

<img width="821" height="482" alt="image" src="https://github.com/user-attachments/assets/a609a3fd-8d63-4b45-b8e1-30a10fe442bb" />

---

### 15. Verify Data in Databricks Catalog
Use **Catalog Explorer** in Databricks to inspect tables and schemas.

<img width="724" height="700" alt="image" src="https://github.com/user-attachments/assets/b208e51f-cb99-42f7-8d69-57734a20ce8d" />



---

### 16. Set Up Synapse Studio
Create a Lake Database and link the Gold Delta tables via Serverless SQL.

<img width="2219" height="1183" alt="image" src="https://github.com/user-attachments/assets/dc68b5b1-ad4f-4512-b42a-15c681fd6c37" />


---

### 17. Integrate with Power BI
Connect Power BI Desktop to Synapse Serverless or Databricks SQL endpoint to build dashboards.

<img width="699" height="351" alt="image" src="https://github.com/user-attachments/assets/e18228d8-ba5b-465c-8ede-b7ab292414d2" />

[![Uploading image.png…]()](https://github.com/user-attachments/assets/3916238d-be8e-4dde-8c79-cb7dec1554fb)

---


## 🧩 Prerequisites

1. **Azure Subscription** (Contributor access)
2. **Airflow Environment** (Local or Astronomer)
3. **Azure CLI** (`az login`)
4. **Terraform ≥ v1.5**
5. **Databricks CLI**
6. **dbt-core + dbt-databricks**
7. **Power BI Desktop**














