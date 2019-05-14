<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Access_Code</fullName>
        <description>Send Access Code</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Syndication_Portal_Access_Code</template>
    </alerts>
    <rules>
        <fullName>Send Access Code to Syndication Portal</fullName>
        <actions>
            <name>Send_Access_Code</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Access_Code__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
