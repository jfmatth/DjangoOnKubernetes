
# DjangoOnKubernetes (K8s)

## A step by step guide to build a Django app to Kubernetes (Multipass, MicroK8s, Kubernetes, Helm)

- Build a basic Django App
  - Use a Windows-friendly waitress WSGI server to serve our app locally and in K8s
  - Utilize whitenoise to server static files from Django
  - Validate admin site functions
- Use MicroK8s as our Kubernetes testing platform (or MiniKube)
- Learn HELM to deploy our application to K8s

## Why did I build this?

As a Django Windows user, there aren't a lot of guides to using Kubernetes on your laptop for development.  Minikube is a great resource and provides so many great K8s features, but i'm going to use MicroK8s in this example.   I wanted to understand how to move my Django project over to Kubernetes, so I thought what better way than to do a step by step tutorial for me and others.  I hope you enjoy!

## Requirements  

- Knowledge of django (I don't explain django here)
- Helpful - Docker knowledge
- Helpful - A basic understanding of K8s objects

## Lets Go!
The master branch has all steps already done, but I've broken each phase out into branches, which you can checkout if you like.  I've listed the branch name in parenthasis () on each step.  

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

Waitress is a WSGI server from the pylons project, is pure-python and runs nicely on Windows (as well as in a container). Whitenoise takes the pain out of serving static files from django in production, without setting up NGINX, Apache or a CDN.  

- Add Whitenoise to Django per their documentation (http://whitenoise.evans.io/en/stable/django.html)
    ```
    MIDDLEWARE = [
    # 'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',
    # ...
    ]
    ```
- Adjust DEBUG and ALLOWED_HOSTS in settings.py
    ```
    DEBUG = False
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
    waitress-serve --listen=127.0.0.1:8000  djangoonk8s.wsgi:application
    ```
- Validate that Django admin still works (127.0.0.1:8000/admin) with all the images / css / fonts
