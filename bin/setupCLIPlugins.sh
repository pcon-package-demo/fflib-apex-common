#!/bin/bash
# 
# bin/setupCLIPlugins.sh
# 

# exit script when any command fails
set -e 

# install the @dx-cli-toolbox/sfdx-toolbox-package-utils plugin
#   for more information, see https://www.npmjs.com/package/@dx-cli-toolbox/sfdx-toolbox-package-utils
# echo y | sfdx plugins install @dx-cli-toolbox/sfdx-toolbox-package-utils
echo y | sf plugins install @dx-cli-toolbox/sfdx-toolbox-package-utils

# install the @dx-cli-toolbox/sfdx-toolbox-utils plugin
#   for more information, see https://www.npmjs.com/package/@dx-cli-toolbox/sfdx-toolbox-utils
# echo y | sfdx plugins install @dx-cli-toolbox/sfdx-toolbox-utils
echo y | sf plugins install @dx-cli-toolbox/sfdx-toolbox-utils

# install the Salesforce Data Migration Utility CLI plugin
#   for more information, see https://www.npmjs.com/package/sfdmu
# echo y | sfdx plugins install sfdmu
echo y | sf plugins install sfdmu
