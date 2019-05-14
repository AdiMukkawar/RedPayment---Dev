<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Access_Code_to_Control_Sheet</fullName>
        <description>Send Access Code to Control Sheet</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ControlSheetAccessCode</template>
    </alerts>
    <rules>
        <fullName>Send Access Code to Control Sheet User</fullName>
        <actions>
            <name>Send_Access_Code_to_Control_Sheet</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Access_Code__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
