
# DjangoOnKubernetes (K8s)

## A step by step guide to build a Django app to Kubernetes (Multipass, MicroK8s, Kubernetes, Helm)

- Build a basic Django App
  - Use a Windows-friendly waitress WSGI server to serve our app locally and in K8s
  - Utilize whitenoise to server static files from Django
  - Validate admin site functions
- Use MicroK8s as our Kubernetes testing platform (or MiniKube)
- Learn HELM to deploy our application to K8s

## Why did I build this?

As a Windows user, there aren't a lot of guides to using Kubernetes on your laptop for development in Django and Kubernetes.   I wanted to understand how to move my Django project over to Kubernetes, so I thought what better way than to do a step by step tutorial for me and others.  I hope you enjoy!

## Requirements  

- Knowledge of django (I don't explain django here)
- Helpful - Docker knowledge
- Helpful - A basic understanding of K8s objects

### Step 1 - Basic Django 2.x app running (Branch-1)

This section we'll setup a basic Django app, just like the beggining of the tutorial.  Very straight forward

- setup virtual environment for Django
- install required libraries (pip install -r requirements.txt)
```
Django==2.2.8
psycopg2-binary==2.8.4
pytz==2019.3
sqlparse==0.3.0
waitress==1.3.1
whitenoise==4.1.4
```
- start django project called djangoonk8s
```
django-admin startproject djangoonk8s
```
- setup DB
```
python manage.py migrate
```
- Create superuser (admin, admin@example.com, admin)
```
python manage.py createsuperuser
```
- Run the server to test everything out  
```
python manage.py runserver
```
- Validate that you can login into https://127.0.0.1:8000/admin
  
### Stage 2 - Using waitress-serve as our WSGI server and using Whitenoise for static files 

- Try using waitress-serve to server out the Admin interface  
  - waitress-serve --listen:127.0.0.1:8000  django_k8s.wsgi:application  
- Validate that Django admin still works (127.0.0.1:8000/admin) with all the images / css / fonts

postgresql.postgresqlPostgresPassword: thisisthepassword