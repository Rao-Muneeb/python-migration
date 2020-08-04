## Repo Give-away
This repo provides script in order to create python 2 or python 3 environment on the basis of requirements.txt file (only for a specific case)... This repo also possesses some python 2 and python 3 compatible libraries and these are,

- cef (0.5)
- pyes (0.99.6)
- kafka (0.9.1)
- djangotoolbox (1.8.0)
- django-uuidfield (from git repo : https://github.com/dcramer/django-uuidfield)
- django-digest (from git repo : https://github.com/dimagi/django-digest)
- Django-nonrel (1.6.11) (from git repo : https://github.com/django-nonrel/django + with python 3.8 compatible - fixed python 3.8 issues)
  - This can be cloned from repo : https://github.com/Rao-Muneeb/django-nonrel


## HOW TO RUN THE SCRIPT?

`env_setup.sh` script can be executed as follows,
```
./env_setup.sh -v <python_version> -p <virtualenv_path/name>
```

For instance,
```
./env_setup.sh -v python2.7 -p ~/venvs/py2_env
```

Above command will create a virtual environment named as `py2_env` at ~/venv location. Similarly, for Python 3 based environment,
```
./env_setup.sh -v python3 -p ~/venvs/py3_env
```

If there are multiple Python3 versions available in a machine then you have to specify the version as follows,
```
./env_setup.sh -v python3.7 -p ~/venvs/py3_env
```

By default, the script will use `py2_requirements.txt` and `py3_requirements.txt` for Python2 and Python3 respectively.
In order to provide other requirement file, you need to specify it as follows,
```
./env_setup.sh -v <python_version> -p <virtualenv_path/name> -f <requirement_file_full_path>
```

For instance,
```
./env_setup.sh -v python3 -p ~/venvs/py3_env2 -f /Users/raomuneeb_khalil/codePracitce/py3_requirements.txt.latest
```

If you don't want to install Forked Dependencies, use `--no-fork-dep` option,
```
./env_setup.sh -v python3.7 -p ~/venvs/py3_env --no-fork-dep
```

`py3_requirements.txt` contains version specific packages list except some of them while in `py3_requirements.txt.latest` versions are not specified, so that all latest version packages will be installed.


