FROM python:3.8

WORKDIR /usr/src/app

COPY requirements.txt ./

RUN pip install -r requirements.txt

COPY mysite/ ./

ENTRYPOINT ["waitress-serve"]
CMD ["--host=0.0.0.0", "--port=80", "mysite.wsgi:application"]