FROM quay.io/astronomer/astro-runtime:12.4.0

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget unzip && \
    wget -q https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip && \
    unzip terraform_1.9.8_linux_amd64.zip -d /usr/local/bin && \
    rm terraform_1.9.8_linux_amd64.zip && \
    apt-get remove --purge -y wget unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

#  Azur CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Databricks CLI
RUN pip install --upgrade --no-cache-dir databricks-cli

# DBT Databricks Adapter   
USER astro

# Install dbt-databricks in a virtual environment to avoid conflicts
RUN python -m venv dbt_venv && \
    . dbt_venv/bin/activate && \
    pip install --no-cache-dir dbt-databricks && \
    deactivate
