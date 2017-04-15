mkdir deleteme
cd deleteme
wget https://repo.continuum.io/archive/Anaconda2-4.3.1-Linux-x86_64.sh
chmod 755 Anaconda2-4.3.1-Linux-x86_64.sh
bash -b -p /root/anaconda -f Anaconda2-4.3.1-Linux-x86_64.sh
echo "export=/usr/anaconda:$PATH" >> ~/.bashrc
source ~/.bashrc
conda create -y -n py27
source activate py27
conda install -y python=2.7.11
##Make sure that the requirements files is present
for req in $(cat ../requirements.txt); do conda install -y $req; done

##Make sure JAVA_HOME is set, or else this will fail
pip install pydoop

##Install tensorflow
conda install -c conda-forge tensorflow

##Clean up
#cd ..
#rm -rf deleteme
