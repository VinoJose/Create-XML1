# this is where the document will be saved:
$Path = "$env:temp\inventory2.xml"
 
# get an XMLTextWriter to create the XML
$XmlWriter = New-Object System.XMl.XmlTextWriter($Path,$Null)
 
# choose a pretty formatting:
$xmlWriter.Formatting = 'Indented'
$xmlWriter.Indentation = 1
$XmlWriter.IndentChar = "`t"
 
function Add-ResourceGroup {
    # adding child element called 'resourceGroup' to 'resourceGroups'
    $xmlWriter.WriteStartElement('resourceGroup')

        # add three pieces of information:
        $xmlWriter.WriteElementString('Name','XWDEVA0211')
        $xmlWriter.WriteElementString('vmPrefix','XWDEVA021')
        $xmlWriter.WriteElementString('environment','Dev')
        $xmlWriter.WriteElementString('layer','App Layer')

            # adding child element called 'network' to 'resourceGroup'
            $xmlWriter.WriteStartElement('network')
                # add pieces of information:
                $xmlWriter.WriteElementString('name','EUR_VMNetwork_Nestle_DEV-Apps_VLAN-160')
                $xmlWriter.WriteElementString('networkType','Private')
            # close the 'network' node:
            $xmlWriter.WriteEndElement()
            $XmlWriter.WriteStartElement('secondaryNetwork')
            $xmlWriter.WriteEndElement()

            # adding child element called 'template' to 'resourceGroup'
            $xmlWriter.WriteStartElement('template')
                # add pieces of information:
                $xmlWriter.WriteElementString('templateId','nst-ctr-1/b379db14-ca56-4568-83ba-bc370d11648a')
                $xmlWriter.WriteElementString('templateName','WoNCare-Med.HighMem-4CPU.16GB-NP')
            # close the 'template' node:
            $xmlWriter.WriteEndElement()

            $xmlWriter.WriteElementString('noOfVms','1')
            $XmlWriter.WriteStartElement('bootDisks')
            $xmlWriter.WriteEndElement()
            $XmlWriter.WriteStartElement('additionalVMDisks')
            $xmlWriter.WriteEndElement()

            # adding child element called 'attributeDefinitions' to 'resourceGroup'
            $xmlWriter.WriteStartElement('attributeDefinitions')

                # adding child element called 'attributeDefinition' to 'attributeDefinitions'
                Add-AttributeDefinition -Name "Memory" -Value "16384"
                Add-AttributeDefinition -Name "Processors" -Value "4.0"
                Add-AttributeDefinition -Name "Instance Size" -Value "XLar.LowMem"
                
            # close the 'attributeDefinitions' node:
            $xmlWriter.WriteEndElement()
            
    # close the 'resourceGroup' node:
    $xmlWriter.WriteEndElement()
}
function Add-Service {
    # adding child element called 'service' to 'services'
    $xmlWriter.WriteStartElement('service')

        # add three pieces of information:
        $xmlWriter.WriteElementString('fromCatalogService','Standard Storage Non-Prod')
        $xmlWriter.WriteElementString('serviceId','CM-PRIV-SRV_STOR_NPS1')
        $xmlWriter.WriteElementString('serviceInstanceName','XWDEVA0231_S1')
        $xmlWriter.WriteElementString('deployOnResourceGroup','XWDEVA023')
        $xmlWriter.WriteElementString('providerId','CM-PRIV')

        # adding child element called 'attributeGroup' to 'service'
        $xmlWriter.WriteStartElement('attributeGroup')
            # add pieces of information:
            $xmlWriter.WriteElementString('name','CM-PRIV-SRV_STOR_NPS1')
            
            # adding child element called 'attributeGroup' to 'service'
            $xmlWriter.WriteStartElement('attributeDefinitions')
                foreach ($Item in $Attributes){
                   Add-AttributeDefinition -Name $Item.name -Value $Item.value 
                }
            # close the 'attributeDefinitions' node:
            $xmlWriter.WriteEndElement()
        # close the 'attributeGroup' node:
        $xmlWriter.WriteEndElement()
            
            
    # close the 'service' node:
    $xmlWriter.WriteEndElement()
}
function Add-AttributeDefinition {
    Param (
        $Name,
        $Value
    )
    # adding child element called 'attributeDefinition'
    $xmlWriter.WriteStartElement('attributeDefinition')
        $xmlWriter.WriteElementString('name',"$Name")
        $xmlWriter.WriteElementString('value',"$Value")
    # close the 'attributeDefinition' node:
    $xmlWriter.WriteEndElement()
}
# write the header
$xmlWriter.WriteStartDocument()

# create root element 'VDC' and add some attributes to it
$xmlWriter.WriteStartElement('vdc')
    $xmlWriter.WriteElementString('providerId','CM-PRIV')
    $xmlWriter.WriteElementString('cloudInstanceId','CM-PRIV-CTR-SITE1')
    $xmlWriter.WriteElementString('vdcServiceDefinition','CM-PRIV_PAY_AS_YOU_GO-VDC')
    $xmlWriter.WriteElementString('vdcNamespace','')
    $xmlWriter.WriteElementString('cloudMatrixVersion','V17.1-003')        

    # adding child element called 'resourceGroups' to vdc
    $xmlWriter.WriteStartElement('resourceGroups')        
        # adding child element called 'resourceGroup' to 'resourceGroups'
        Add-ResourceGroup
        Add-ResourceGroup
    # close the 'resourceGroups' node:
    $xmlWriter.WriteEndElement()

    $xmlWriter.WriteElementString('managedGroups','')

    # adding child element called 'services' to vdc
    $xmlWriter.WriteStartElement('resourceGroups')        
        # adding child element called 'service' to 'services'
        Add-Service
        Add-Service
    # close the 'services' node:
    $xmlWriter.WriteEndElement()

# close the 'VDC' node:
$xmlWriter.WriteEndElement()


# finalize the document:
$xmlWriter.WriteEndDocument()
$xmlWriter.Flush()
$xmlWriter.Close()
 
notepad $path
