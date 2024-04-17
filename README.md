# kuberentes-class
Pre-requsites for infrastructure : 
Master node : Ubuntu 22.04 - 2 vCPU, 4 GB RAM, 80 GB Hard disk 
Slave node1 : Ubuntu 22.04 - 1 vCPU, 1 GB RAM, 60 GB Hard disk 
Slave node2 : Ubuntu 22.04 - 1 vCPU, 1 GB RAM, 60 GB Hard disk 

Pre-requsites - setup hostname on all 3 nodes
Login to to master node and set hostname using hostnamectl command,
sudo hostnamectl set-hostname "s1master.cloudenabled.net"

exec bash

On the worker nodes, run
sudo hostnamectl set-hostname "s1worker1.cloudenabled.net"   // 1st worker node
sudo hostnamectl set-hostname "s1worker2.cloudenabled.net"   // 2nd worker node
exec bash

Add the following entries in /etc/hosts file on each node
172.17.22.5   s1master.cloudenabled.net s1master
172.17.22.6  s1worker1.cloudenabled.net s1worker1
172.17.22.7   s1worker2.cloudenabled.net s1worker2

###### Step 1 ===========
Login to master node -SSH as ubuntu user ( dont switch to root)

git clone https://github.com/anilbidari/kuberentes-class.git  && cd kuberentes-class && sudo chmod a+x master.sh && ./master.sh

sudo kubeadm token create --print-join-command ( copy the output fo this command and keep it note pad - u need kubeadm join command later on your nodes)


###### Step 2 ===========
Login to Slave node1 -SSH as ubuntu user ( dont switch to root)

git clone https://github.com/anilbidari/kuberentes-class.git  && cd kuberentes-class && sudo chmod a+x node.sh && ./node.sh

sudo kubeadm join (command you copied in your master node deployment at the end of step 1 completetion)

###### Step 3 ===========
Login to Slave node3 -SSH as ubuntu user ( dont switch to root)

git clone https://github.com/anilbidari/kuberentes-class.git  && cd kuberentes-class && sudo chmod a+x node.sh && ./node.sh

sudo kubeadm join (command you copied in your master node deployment at the end of step 1 completetion)

###### Step 4 ===========
Login to Master node -SSH as ubuntu user ( dont switch to root)
kubectl get nodes 
# all nodes shoudl be ready ( wait for 4 mins) and your nodes will be ready state

###### Step 5 ===========
Enjoy the kubernetes deployment start playing with PODS


