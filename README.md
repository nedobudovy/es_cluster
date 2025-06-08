# ElasticSearch 3-node cluster deploy script with usage of Vagrant and Ansible

# About project

The main goal of this project is provide automatic creation (Vagrant) and configuration (Ansible) for the given virtual infrastructure:

- 3-nodes master-data ElasticSearch cluster 
- 1 node for Kibana


# Deploying

All you have to do to deploy it: 
- clone this repo:
```
git clone https://github.com/nedobudovy/es_cluster/tree/master
```
- install dependencies:
    - Ansible
    - Vagrant (virtualbox under hood)
    - maybe smth else if i forgot to mention :)

P.S. This should be added to the deployment script of course. I'll do it soon.

- start the deployment script
```
./deploy.sh
```


