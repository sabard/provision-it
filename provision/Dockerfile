FROM python:3.10.14 as base

RUN groupadd -g 999 appuser && \
    useradd -r -u 999 -g appuser appuser
RUN mkdir -p /usr/src/app
RUN chown appuser /usr/src/app
WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app/
COPY cloud-sql-proxy /usr/src/app/
RUN pip --no-cache-dir install -r requirements.txt

USER appuser
COPY provision /usr/src/app/provision

COPY run.sh /usr/src/app/

ENV PYTHONUNBUFFERED=0
EXPOSE 5000
CMD ["./run.sh", "--host 0.0.0.0"]
