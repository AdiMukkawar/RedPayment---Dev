<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_an_alert_to_Lead_Owner_on_Incoming_Message</fullName>
        <description>Send an alert to Lead Owner on Incoming Message</description>
        <protected>false</protected>
        <recipients>
            <type>campaignMemberDerivedOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Incoming_Message_for_Lead</template>
    </alerts>
    <alerts>
        <fullName>Send_an_alert_to_Opportunity_Owner_on_Incoming_Message</fullName>
        <description>Send an alert to Opportunity Owner on Incoming Message</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Incoming_Message_for_Opportunity</template>
    </alerts>
</Workflow>
