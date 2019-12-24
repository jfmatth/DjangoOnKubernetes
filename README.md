
# DjangoOnKubernetes (K8s)

## A step by step guide to build a Django app to Kubernetes (Multipass, MicroK8s, Kubernetes, Helm)

- Build a basic Django App
  - Use a Windows-friendly waitress WSGI server to serve our app locally and in K8s
  - Utilize whitenoise to server static files from Django
  - Validate admin site functions
- Use Docker Desktop for Windows to help us build our images
- Use MicroK8s as our Kubernetes testing platform (or MiniKube)
- Learn HELM to deploy our application to K8s

## Why did I build this?

As a Django Windows user, there aren't a lot of guides to using Kubernetes on your laptop for development.  Minikube is a great resource and provides so many great K8s features, but i'm going to use MicroK8s in this example.   I wanted to understand how to move my Django project over to Kubernetes, so I thought what better way than to do a step by step tutorial for me and others.  I hope you enjoy!

## Requirements  

- Knowledge of django (I don't explain django here)
- A desktop virtual environment (I use Hyper-V on Windows 10)
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

### Stage 3 - Install Docker for Windows, Multipass, kubectl and Helm

**Docker for Windows**  
Docker makes a really nice product here, called Docker Desktop for Windows.  This is a simple install, that figures out what virtualization environment you have, installs the necessary VM's, installs the docker deamon and just works.  It's not too invasive and has some nice options.  

Install Docker for Windows per the installation instructions here https://docs.docker.com/docker-for-windows/  

Once Docker is installed, run a quick test to make sure it's working for your environment
```
docker run hello-world
```
**Multipass**  
Canoical makes Ubuntu, but they also make a really nice VM Manager called Multipass.  We will use Multipass to help us install an Ubuntu VM locally, and then install MicroK8s on it.  

Install Multipass per the installation instructions here https://multipass.run/docs/installing-on-windows

Multipass just reached v1.0 and has some nice features, like Ctrl-Alt-U to open up the "Primary" VM for Multipass.  After Multipass is installed and running, try hitting Ctrl+Alt+U and a window will open and start the Primary VM with the latest Ubuntu in it - Very cool!  

**MicroK8s**  
Canoical also makes a very nice single-node (or more) install of Kubernetes.  It installs super-quick, has some really nice built in functionallity, and best of all, can be used locally or in production.  Sometimes you just need a single-node Kubernetes cluster running on Linode to help get your application running.  

We will follow the MicroK8s tutorial for windows here https://tutorials.ubuntu.com/tutorial/install-microk8s-on-windows#0 to get a full understanding of installing MicroK8s on an Ubuntu VM.

The MicroK8s tutorial spins up a vm called microk8s-vm, but for the repo, we'll be using the Primary VM, since it's tied to the Ctrl+Alt+U shortcut.

Install MicroK8s on the Primary VM:
1. Ctrl+Alt+U
2. ``` snap install microk8s --classic```
3. ```usrmod -a -G microk8s ubuntu```
4. exit the window
5. Ctrl+Alt+U again
6. ``` microk8s.enable dns dashboard ```


