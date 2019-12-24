FROM python
WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENTRYPOINT ["waitress-serve"]
CMD ["--host=0.0.0.0", "--port=80", "django_k8s.wsgi:application"]