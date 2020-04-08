#!/bin/bash

# Activate the virtual environment, given path of virtual enviroment directory
activate_env() {
	local env_path="bin/activate"

	echo "[Info] Activating environment..."

	source $env_path > /dev/null 2>&1 
	
	if [ "$?" != 0 ]; then
		echo "[Error] Wrong Path is given: $env_path"
		exit 1
	fi
}

# Below function creates virtual environment using 'virtualenv' script
create_env() {
	local dir="$(cd $(dirname "$0"); pwd)"

	if [ "$1" = "python2" ]; then
		local python=$( which python )
		if [ -n "$3" ]; then
			local requirement_file=$3
		else
			local requirement_file="$dir/py2_requirements.txt" 
		fi
	else
		local python=$( which python3 )
		if [ -n "$3" ]; then
			local requirement_file=$3
		else
			local requirement_file="$dir/py3_requirements.txt" 
		fi
	fi
	
	echo "[Info] Creating environment..."
	echo "[Info] virtualenv -p $python $2"

	virtualenv -p $python $2 > /dev/null 2>&1

	if [ "$?" != 0 ]; then
		echo "[Error] Not able to find python executable... Exiting..."
		exit 1	
	fi

	cd $2
	activate_env
	echo "[Info] Activation Done..."
	add_elastica_packages_path
	install_pypi_dependencies $requirement_file
	install_fork_dependencies $1

}

install_fork_dependencies() {
	mkdir src/; cd src/

	echo "[Info] Cloning 'django-digest'..."
	git clone https://github.com/dimagi/django-digest.git
	cd django-digest; python setup.py install; cd ..

	echo "[Info] Cloning 'django-permission-backend-nonrel'..."
        git clone https://github.com/django-nonrel/django-permission-backend-nonrel.git
        cd django-permission-backend-nonrel; python setup.py install; cd ..

        echo "[Info] Cloning 'django-tastypie-nonrel'"
        git clone https://github.com/andresdouglas/django-tastypie-nonrel.git
        cd django-tastypie-nonrel; python setup.py install; cd ..

	if [ "$#" -gt 0 ] && [ "$1" = "python2" ]; then
	#	echo "[Info] Cloning 'django'..."
	#	git clone https://github.com/django-nonrel/django.git
	#	cd django; python setup.py install; cd ..

		echo "[Info] Cloning 'djangotoolbox'..."
		git clone https://github.com/django-nonrel/djangotoolbox.git
		cd djangotoolbox; python setup.py install; cd ..

		echo "[Info] Cloning 'mongodb-engine'..."
		git clone https://github.com/django-nonrel/mongodb-engine.git
		cd mongodb-engine; python setup.py install; cd ..

	fi
	cd ..
} 

install_pypi_dependencies() {
	echo "[Info] Installing PyPi Dependencies..."
	pip install -r $1

	if [ "$?" -eq 1 ]; then
		exit 1
	fi
}

add_elastica_packages_path() {
	echo "[Info] Adding Elastica Packages Paths..."

	local python_ver=$( python -c 'import sys; version=sys.version_info[:2]; print("{0}.{1}".format(*version))' )
	local file_path="$( pwd )/lib/python$python_ver/site-packages/el_packages_path.pth"

	if [ -n "$USER" ]; then

cat > $file_path << END_TEXT
/Users/$USER/milkyway/common/auth_2fa
/Users/$USER/milkyway/common/hadoop
/Users/$USER/milkyway/common/emailservice
/Users/$USER/milkyway/common/pyElastica
/Users/$USER/milkyway/discovery/common/python/
/Users/$USER/milkyway/discovery/common/python/core
/Users/$USER/milkyway/connectors
/Users/$USER/milkyway/apiserver
END_TEXT

	else
cat > $file_path << END_TEXT
/home/madmin/milkyway/common/auth_2fa
/home/madmin/milkyway/common/hadoop
/home/madmin/milkyway/common/emailservice
/home/madmin/milkyway/common/pyElastica
/home/madmin/milkyway/discovery/common/python/
/home/madmin/milkyway/discovery/common/python/core
/home/madmin/milkyway/connectors
/home/madmin/milkyway/apiserver
END_TEXT
	
	fi
}


while [ "$#" -gt 0 ]; do
	key=$1

	case $key in
		-v|--version)
			PYTHON_VER=$2
			shift; shift
			;;
		-p|--path)
			VIR_ENV_PATH=$2
			shift; shift
			;;
		-f|--file)
			DEP_REQ_FILE=$2
			shift; shift
			;;
		*)
			echo "[Error] Invalid Arguments given..."
			echo "-----------------------------------------------------------------------------"
			echo "Arguments the script supports,"
			echo "-----------------------------------------------------------------------------"
			echo "-v | --version : Python version either 'python2' or 'python3'    (Required)"
			echo "-p | --path    : Name/Path for Python Virtual Environment        (Required)"
			echo "-f | --file    : Path for PyPi Dependencies requirement file     (Optional)"
			echo "-----------------------------------------------------------------------------"
			echo "Way to run a script"
			echo "-----------------------------------------------------------------------------"
			echo "1- ./env_setup.sh -v <python_version> -p <virtual_env_path/name>"
			echo "2- ./env_setup.sh -v <python_version> -p <virtual_env_path/name> -f <requirement_file_full_path>"
			echo "-----------------------------------------------------------------------------"
			exit 1	
	esac
done


if [ -z "$PYTHON_VER" ] && [ -z "$VIR_ENV_PATH" ]; then
	echo "[Error] -v (--version) or -p (--path) options not given..."
elif [[ "$PYTHON_VER" = "python2" || "$PYTHON_VER" = "python3" ]] && [[ -n "$VIR_ENV_PATH" ]]; then
	if [ -n "$DEP_REQ_FILE" ]; then
		echo "create_env $PYTHON_VER $VIR_ENV_PATH $DEP_REQ_FILE"
		create_env $PYTHON_VER $VIR_ENV_PATH $DEP_REQ_FILE
	else
		echo "create_env $PYTHON_VER $VIR_ENV_PATH"
		create_env $PYTHON_VER $VIR_ENV_PATH
	fi

	echo "*********************************"
	echo "Hurrayyy!!! Setup Completed!!"
	echo "*********************************"
else
	if [ -z "$VIR_ENV_PATH" ]; then
		echo "[Error] Virtual environment path/name not specified..."
	else
		echo "[Error] Wrong Python version specified..."
	fi
fi


