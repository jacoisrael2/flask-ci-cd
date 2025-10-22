FROM python:3.11-slim

# Instalar ferramentas do sistema + Helm + kubectl
RUN apt-get update && apt-get install -y curl tar ca-certificates && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    curl -L https://get.helm.sh/helm-v3.14.0-linux-amd64.tar.gz -o /tmp/helm.tar.gz && \
    tar -zxvf /tmp/helm.tar.gz -C /tmp && \
    mv /tmp/linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]

