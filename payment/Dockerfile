FROM python:3.12-slim
ENV INSTANA_AUTO_PROFILE=true
ENV INSTANA_SERVICE_NAME=payment
WORKDIR /app
COPY requirements.txt /app
COPY . /app
RUN apt-get update && \
    apt-get install -y gcc && \
    pip install --no-cache-dir -r requirements.txt && \
    apt-get remove -y gcc && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
CMD ["uwsgi", "--ini", "payment.ini"]
