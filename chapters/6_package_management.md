# Package Management and Virtual Enviroments in Python

## Introduction 


## Pip and Pipenv 

Install pipenv `brew install pipenv`

To create a virtual enviroment using pipenv

uses global version of python
```
pipenv install 
```

If you want a particular version 
```
pipenv install --python 3.11.7
```

>This creates a virtual enviroment 

Activate a venv

```
pipenv shell
```

Leave the venv

```
exit 
```

Installing packages in venv
```
pipenv install pandas
```

Checking packages
```
pip freeze
```

Uninstall a package in venv
```
pipenv uninstall pandas
```

Delete the venv
```
pipenv --rm 
```

___

Alternatively, we can create our basic virtual environment if you want your own name in the working dir.  

```
python3 -m venv --prompt coolname .venv
```
This creates a venv with a name `coolname`

Then run the following to create Pipfile and Pipfile.lock
```
pipenv install 
```

Open the virtual enviroment 
```
pipenv shell
```

### Why pipenv install over pip install?

To be fair, _Pipenv_ performs just like pip when it comes to installing all the required sub-dependencies for your packages. But once you’ve solved the issue, _Pipfile.lock_ keeps track of all of your application’s interdependencies, including their versions, for each environment so you can basically forget about interdependencies.

In practice, this means you can continue working in development until you’ve got a set of packages/versions that work for you. Now you can simply issue `pipenv lock` and _Pipenv_ will lock all the dependencies/interdependencies your project requires, pinning their versions and hashing the results so you can deterministically replicate your build in production.

At the end, my suggestion would be **Stop pip installing into your virtual environments and start pipenv installing.** You won’t regret it, trust me.

Source: https://medium.com/analytics-vidhya/why-pipenv-over-venv-for-python-projects-a51fb6e4f31e 

## Conda Environments

Conda enviroments are easier to use. A complete comprehensive [guide](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#activating-an-environment) tells about the management of the conda env, but here are the basics to start off. 

Create conda environments local to the folder to ensure that you can name the convention .venv 

> use .venv to hide the file.   
> venv and .venv are the conventions


### How to create a conda enviroment in a specific location

```bash
conda create --prefix ./.venvs jupyterlab biopython 
```

### How to delete conda enviroment

```bash
conda remove --name myenv --all
```

where the 'myenv' is the enviroment name


When downloading miniconda, it sets the Conda environments to base automatically. To deactivate it use the following code. 

```bash
conda config --set auto_activate_base false
```

You can read more on Conda Env vs Virtual Env [here](https://notes.aquiles.me/difference_conda_environment_and_virtual_environment_in_pyhon/).

[Back to Main Page](../README.md)