# BOSH real --dry-run

This tool allows running a real dry-run (without side effects) for a given deployment.
After running the tool it will print a diff of all outstanding configs changes,
as well as changes to the deployment manfiest.

## Installation

Make sure the following cli's are installed on your system:
- [bosh](https://bosh.io/docs/cli-v2-install/)
- [jq](https://stedolan.github.io/jq/download/)
- [spruce](https://github.com/geofffranks/spruce#how-do-i-get-started)

```
git clone http://github.com/starkandwayne/bosh-real-dry-run
cd bosh-real-dry-run
./diff.sh {deployment_name} {new_deployment_manifest}.yml
```

Sample output:

```
❯ ./diff.sh empty-deployment manifest.yml

  addons:
+ - include:
+     stemcell:
+     - os: ubuntu-trusty
+     - os: ubuntu-xenial
+     - os: ubuntu-bionic
+   jobs: []
+   name: nothing

  instance_groups:
  - name: empty-instance
-   instances: 1
+   instances: 2
```

# Motivation for creating this tool
Currently `bosh deploy --dry-run` has side effects.

As @mrosecrance puts it [here](https://github.com/cloudfoundry/bosh/issues/2274#issuecomment-692179611):
```
This is an unfortunate known issue, --dry-run has side effects that need a deploy to resolve.
Our current expectations around use is that it's used to validate what will happen and then a changed manifest is deployed.
```

Related issues:
- https://github.com/cloudfoundry/bosh/issues/1966
- https://github.com/cloudfoundry/bosh/issues/2226
- https://github.com/cloudfoundry/bosh/issues/2274
