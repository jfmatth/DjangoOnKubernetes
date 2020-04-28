# DjangoOnKubernetes

## A step by step guide to build a Django app to Kubernetes (Multipass, K3s, and  Helm)

- Build a basic Django App
  - Use a Windows-friendly waitress WSGI server to serve our app locally and in K8s
  - Utilize whitenoise to server static files from Django
  - Validate admin site functions
- Use Docker Desktop for Windows to help us build our images
- Use K3s as our Kubernetes testing platform
- Learn HELM to deploy our application to Kubernetes

## Why did I build this?

As a Django Windows user, there aren't a lot of guides to using Kubernetes on your laptop for development.  Minikube is a great resource and provides so many great K8s features, but i'm going to use MicroK8s in this example.   I wanted to understand how to move my Django project over to Kubernetes, so I thought what better way than to do a step by step tutorial for me and others.  I hope you enjoy!

## Requirements  

- Knowledge of django (I don't explain django here)
- A desktop virtual environment (I use Hyper-V on Windows 10)
- Helpful - Docker knowledge
- Helpful - A basic understanding of K8s objects

## Lets Go!
The master branch has all steps already done, but I've broken each phase out into branches, which you can checkout if you like.  I've listed the branch name in parenthasis () on each step.  

### Step 1 - Basic Django 2.x app running 

This section we'll setup a basic Django app, just like the beggining of the tutorial.  Very straight forward

- setup virtual environment for Django
- install required libraries (pip install -r requirements.txt)
    ```
    Django>=2.2.10,< 3.0
    psycopg2-binary==2.8.4
    pytz==2019.3
    sqlparse==0.3.0
    waitress
    whitenoise
    ```
- start django project called djangoonk8s
    ```
    django-admin startproject mysite
    cd mysite
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
    You should see the default Django "The installed worked sucessfully! Cogratulations" message.  If not, you'll have to troubleshoot

### Step 2 - Using waitress-serve as our WSGI server and using Whitenoise for static files 

Waitress is a WSGI server from the pylons project, is pure-python and runs nicely on Windows (as well as in a container). Whitenoise takes the pain out of serving static files from django in production, without setting up NGINX, Apache or a CDN.  

- Add Whitenoise to Django per their documentation (http://whitenoise.evans.io/en/stable/django.html)
    ```
    MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',
    # ...
    ]
    ```
- ALLOWED_HOSTS in settings.py
    ```
    ALLOWED_HOSTS = ['*']
    ```
- Add a STATIC_ROOT in settings.py for Whitenoise
    ```
    STATIC_ROOT = os.path.join(BASE_DIR, 'assets')
    ```
- Run Collectstatic to build the assets that Whitenoise will use
    ```
    python manage.py collectstatic
    ```

- Try using waitress-serve to server out the Admin interface
    ```
    waitress-serve --listen=127.0.0.1:8000  mysite.wsgi:application
    ```
- Validate that Django admin still works (127.0.0.1:8000/admin) with all the images / css / fonts


At this point, we have Django running without any apps, in DEBUG mode, serving WSGI via Waitress.  If we turn off DEBUG, the site will fail due to no routing in the urls.py file.  For this example, we'll leave DEBUG on and move onto getting this working with Kubernetes.

## Dockerizing mysite

### Build the Dockerfile

We need to put our entire Djano app into a docker container, luckily this is pretty simple

Create  the following Dockerfile
```
FROM python

WORKDIR /usr/src/app

COPY requirements.txt ./

RUN pip install -r requirements.txt

COPY mysite/ ./

ENTRYPOINT ["waitress-serve"]
CMD ["--host=0.0.0.0", "--port=80", "mysite.wsgi:application"]
```

### Test the Dockerfile

```
docker run -p 8080:80 mysite
```

Browse to the 8080 port of the docker host and you should see the same debug Django screen as before.  If not, you'll have to troubleshoot why, sorry.

### Push the docker image to dockerhub

Until now, we've called our image mysite, but we need to prefix that with our accountname, in my case it's jfmatth.  So I would need to push to jfmatth/mysite.

If you don't have a dockerhub account, get one their free.  If you have another docker location, you can use that, but this tutorial uses dockerhub.

For example
```
docker build . -t jfmatth/mysite
docker push jfmatth/mysite
```

## Kubernetes

### Setup Kubernetes Cluster

### Get access and test

### Parts we'll be using

- Ingress
- Pods
- Postgres 


## HELM

### Install Helm

### Create Helm Chart

### Install Chart onto cluster


## Github

### github action

### secrets

### Helm install to match

### what is timestamp?

