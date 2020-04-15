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


