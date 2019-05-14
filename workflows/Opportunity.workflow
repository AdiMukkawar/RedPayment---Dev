<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Application_In_Missing_Info_Email_Alert</fullName>
        <description>Application In Missing Info Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Application_In_Missing_Info</template>
    </alerts>
    <alerts>
        <fullName>Application_Sent_1_10</fullName>
        <description>Application Sent 1, 10</description>
        <protected>false</protected>
        <recipients>
            <field>Cloufi__Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Application_Sent_1_10</template>
    </alerts>
    <alerts>
        <fullName>Application_Sent_4_13</fullName>
        <description>Application Sent 4, 13</description>
        <protected>false</protected>
        <recipients>
            <field>Cloufi__Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Application_Sent_4_13_Custom</template>
    </alerts>
    <alerts>
        <fullName>Application_Sent_7_16</fullName>
        <description>Application Sent 7, 16</description>
        <protected>false</protected>
        <recipients>
            <field>Cloufi__Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Application_Sent_7_16</template>
    </alerts>
    <alerts>
        <fullName>Approval_Emails_1_10</fullName>
        <description>Approval Emails 1,10</description>
        <protected>false</protected>
        <recipients>
            <field>Cloufi__Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Approval_Emails_1_10</template>
    </alerts>
    <alerts>
        <fullName>Approval_Emails_4_13</fullName>
        <description>Approval Emails 4,13</description>
        <protected>false</protected>
        <recipients>
            <field>Cloufi__Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Approval_Emails_4_13</template>
    </alerts>
    <alerts>
        <fullName>Approval_Emails_7_16</fullName>
        <description>Approval Emails 7, 16</description>
        <protected>false</protected>
        <recipients>
            <field>Cloufi__Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Approval_Emails</template>
    </alerts>
    <alerts>
        <fullName>Contract_Sent_1_10</fullName>
        <description>Contract Sent 1,10</description>
        <protected>false</protected>
        <recipients>
            <field>Cloufi__Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Contract_Sent_1_10</template>
    </alerts>
    <alerts>
        <fullName>Contract_Sent_4_13</fullName>
        <description>Contract Sent 4,13</description>
        <protected>false</protected>
        <recipients>
            <field>Cloufi__Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Contract_Sent_4_13</template>
    </alerts>
    <alerts>
        <fullName>Contract_Sent_7_16</fullName>
        <description>Contract Sent 7,16</description>
        <protected>false</protected>
        <recipients>
            <field>Cloufi__Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Contract_Sent_7_16</template>
    </alerts>
    <alerts>
        <fullName>Funded_email_to_Sales_Rep_External</fullName>
        <description>Funded email to Sales Rep External</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Funded_for_Sales_Rep_Internal</template>
    </alerts>
    <alerts>
        <fullName>Funded_email_to_Sales_Support_when_funded_internally</fullName>
        <description>Funded email to Sales Support when funded internally</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Funded_for_Sales_Rep_Internal</template>
    </alerts>
    <alerts>
        <fullName>Funded_for_Sales_Support</fullName>
        <description>Funded for Sales Support</description>
        <protected>false</protected>
        <recipients>
            <field>Sales_Support_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Funded_for_Sales_Support</template>
    </alerts>
    <alerts>
        <fullName>Re_assignment_of_Revived_Opportunity</fullName>
        <description>Re-assignment of Revived Opportunity</description>
        <protected>false</protected>
        <recipients>
            <recipient>g@techila.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jerry@maple.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Revived_Opportunity_Email_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Alert_to_Sales_Rep</fullName>
        <description>Send Alert to Sales Rep</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Application_In_Missing_Info</template>
    </alerts>
    <alerts>
        <fullName>Send_Alert_to_Sales_Support</fullName>
        <description>Send Alert to Sales Support</description>
        <protected>false</protected>
        <recipients>
            <field>Sales_Support_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Application_In_Missing_Info</template>
    </alerts>
    <fieldUpdates>
        <fullName>Blank_out_App_In_Missing_Stage_date</fullName>
        <field>App_In_Missing_Info_Stage_Date__c</field>
        <formula>null</formula>
        <name>Blank out App In Missing Stage date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cloufi__Daily_Payback_Amount_field_Update</fullName>
        <field>Cloufi__Daily_Payback_Amt__c</field>
        <formula>IF(AND(Cloufi__Payback_Amount__c &lt;&gt;0,Cloufi__Loan_Term__c &lt;&gt;0), Cloufi__Payback_Amount__c /Cloufi__Loan_Term__c, null)</formula>
        <name>Daily Payback Amount field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cloufi__Factor_Rate</fullName>
        <description>Calculate Factor Rate</description>
        <field>Cloufi__Factor_Rate__c</field>
        <formula>IF(ISCHANGED(Cloufi__Payback_Amount__c ),Cloufi__Payback_Amount__c / Amount, Cloufi__Factor_Rate__c )</formula>
        <name>Factor Rate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cloufi__OppStageUpdate</fullName>
        <field>StageName</field>
        <literalValue>Syndication</literalValue>
        <name>OppStageUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cloufi__Payback_Amount</fullName>
        <field>Cloufi__Payback_Amount__c</field>
        <formula>Amount * Cloufi__Factor_Rate__c</formula>
        <name>Payback Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_App_In_Missing_Info_Stage_Date</fullName>
        <field>App_In_Missing_Info_Stage_Date__c</field>
        <name>Nullify App In Missing Info Stage Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_App_In_Missing_Stage_Date_Time</fullName>
        <field>App_In_Missing_Info_Stage_Date_Time__c</field>
        <name>Nullify App In Missing Stage Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_App_Sent_Stage_Date</fullName>
        <field>App_Sent_Stage_Date__c</field>
        <name>Nullify App Sent Stage Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_App_Sent_Stage_Date_Time</fullName>
        <field>App_Sent_Stage_Date_Time__c</field>
        <name>Nullify App Sent Stage Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_Approved_Stage_Date</fullName>
        <field>Approved_Stage_Date__c</field>
        <name>Nullify Approved Stage Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_Approved_Stage_Date_Time</fullName>
        <field>Approved_Stage_Date_Time__c</field>
        <name>Nullify Approved Stage Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_Contract_Receive_Stage_Date_Time</fullName>
        <field>Contract_Received_Stage_Date_Time__c</field>
        <name>Nullify Contract Receive Stage Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_Contract_Received_Stage_Date</fullName>
        <field>Contract_Received_Stage_Date__c</field>
        <name>Nullify Contract Received Stage Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_Contract_Request_Stage_Date_Time</fullName>
        <field>Contract_Requested_Stage_Date_Time__c</field>
        <name>Nullify Contract Request Stage Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_Contract_Requested_Stage_Date</fullName>
        <field>Contract_Requested_Stage_Date__c</field>
        <name>Nullify Contract Requested Stage Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_Contract_Sent_Stage_Date</fullName>
        <field>Contract_Sent_Stage_Date__c</field>
        <name>Nullify Contract Sent Stage Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_Contract_Signed_Stage_Date</fullName>
        <field>Contract_Signed_Partial_Stage_Date__c</field>
        <name>Nullify Contract Signed Stage Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_Contract_Signed_Stage_Date_Time</fullName>
        <field>Contract_Signed_Partial_Stage_Date_Time__c</field>
        <name>Nullify Contract Signed Stage Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_Final_UW_Stage_Date</fullName>
        <field>Final_UW_Stage_Date__c</field>
        <name>Nullify Final UW Stage Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_Final_UW_Stage_Date_Time</fullName>
        <field>Final_UW_Stage_Date_Time__c</field>
        <name>Nullify Final UW Stage Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_Funded_Stage_Date</fullName>
        <field>Funded_Stage_Date__c</field>
        <name>Nullify Funded Stage Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_Funded_Stage_Date_Time</fullName>
        <field>Funded_Stage_Date_Time__c</field>
        <name>Nullify Funded Stage Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_UW_Stage_Date</fullName>
        <field>UW_Stage_Date__c</field>
        <name>Nullify UW Stage Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_UW_Stage_Date_Time</fullName>
        <field>UW_Stage_Date_Time__c</field>
        <name>Nullify UW Stage Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Sales_Support_Email</fullName>
        <field>Sales_Support_Email__c</field>
        <formula>Owner.Sales_Support_Email__c</formula>
        <name>Populate Sales Support Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Credit_Score</fullName>
        <field>Cloufi__Credit_Score__c</field>
        <formula>IF( Owner_1_Credit_Score__c &gt;=  Owner_2_Credit_Score__c , Owner_1_Credit_Score__c , Owner_2_Credit_Score__c )</formula>
        <name>Update Credit Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Funding_Date</fullName>
        <field>CloufiServicing__Funding_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Funding Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Application Signed alert to Sales Rep</fullName>
        <actions>
            <name>Send_Alert_to_Sales_Rep</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>App In Missing Info</value>
        </criteriaItems>
        <description>Once Signed Application uploaded send Email alert to Sales Rep/Agent</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Application Signed alert to Sales Support</fullName>
        <actions>
            <name>Send_Alert_to_Sales_Support</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>App In Missing Info</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Sales_Support_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Cloufi__Calculate Factor Rate</fullName>
        <actions>
            <name>Cloufi__Factor_Rate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Cloufi__Payback_Amount__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Calculation of Factor Rate</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Cloufi__Calculate Payback Amount</fullName>
        <actions>
            <name>Cloufi__Payback_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Cloufi__Factor_Rate__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Calculation of Payback Amount</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Cloufi__Daily Payback Amt Calculation</fullName>
        <actions>
            <name>Cloufi__Daily_Payback_Amount_field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Cloufi__Loan_Term__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Cloufi__Payback_Amount__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Cloufi__Opportunity Stage update to Syndication</fullName>
        <actions>
            <name>Cloufi__OppStageUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Cloufi__Total_Number_Of_Syndicator__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <description>Once a Syndicator record is created, make Opportunity stage to Syndication.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Funded email to Sales Rep External</fullName>
        <actions>
            <name>Funded_email_to_Sales_Rep_External</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send an email to Sales Rep when deal get funded externally means deal wont be having payment processor defined.</description>
        <formula>ISCHANGED(StageName) &amp;&amp; 
ISPICKVAL(StageName, &apos;Funded&apos;) &amp;&amp; 
(ISNULL( TEXT(Cloufi__Payment_Processor__c)) || 
ISBLANK( TEXT(Cloufi__Payment_Processor__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Funded for Sales Rep Internal</fullName>
        <actions>
            <name>Funded_email_to_Sales_Support_when_funded_internally</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send an email to Sales Rep when deal get funded internally means deal will be having payment processor defined.</description>
        <formula>ISCHANGED(StageName) &amp;&amp;   ISPICKVAL(StageName, &apos;Funded&apos;) &amp;&amp;   NOT(ISNULL( TEXT(Cloufi__Payment_Processor__c) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity is Funded</fullName>
        <actions>
            <name>Update_Funding_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When Opportunity is moved to Stage &quot;Funded&quot;, populate the Funding Date</description>
        <formula>ISPICKVAL(StageName, &apos;Funded&apos;)  &amp;&amp;  NOT(ISPICKVAL(PRIORVALUE(StageName), &apos;Funded&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity is Revived - Stage Dates</fullName>
        <actions>
            <name>Nullify_App_In_Missing_Info_Stage_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Nullify_App_Sent_Stage_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Nullify_Approved_Stage_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Nullify_Contract_Received_Stage_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Nullify_Contract_Requested_Stage_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Nullify_Contract_Sent_Stage_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Nullify_Contract_Signed_Stage_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Nullify_Final_UW_Stage_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Nullify_Funded_Stage_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Nullify_UW_Stage_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Revived</value>
        </criteriaItems>
        <description>Updates all Stage Dates</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Credit Score</fullName>
        <actions>
            <name>Update_Credit_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW()  ||  ISCHANGED( Owner_1_Credit_Score__c ) ||  ISCHANGED( Owner_2_Credit_Score__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Sales Support Email</fullName>
        <actions>
            <name>Populate_Sales_Support_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate Sales Support Email when Opportunity owner changed</description>
        <formula>ISCHANGED(OwnerId)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Reviving Opportunity Workflow</fullName>
        <actions>
            <name>Blank_out_App_In_Missing_Stage_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Revived</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
