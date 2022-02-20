FROM python:3.8-slim

# New for Pipenv - Credit to https://jonathanmeier.io/using-pipenv-with-docker/
RUN pip install pipenv
ENV PROJECT_DIR /usr/src/app
WORKDIR ${PROJECT_DIR}
COPY Pipfile Pipfile.lock ${PROJECT_DIR}/
RUN pipenv install --system --deploy --verbose

COPY mysite/ ${PROJECT_DIR}/

RUN python manage.py collectstatic --no-input

ENTRYPOINT ["waitress-serve"]
CMD ["--host=0.0.0.0", "--port=80", "mysite.wsgi:application"]