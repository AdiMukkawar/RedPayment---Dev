<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DialSource__Sample_DialSource_Email_Alert</fullName>
        <description>SAMPLE DialSource Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DialSource__Managed_Package_Sample_Email_Template/DialSource__Sample_Temp</template>
    </alerts>
    <alerts>
        <fullName>No_Answer_Email_1</fullName>
        <description>No Answer Email 1</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Lead_Email_1</template>
    </alerts>
    <alerts>
        <fullName>No_Answer_Email_4</fullName>
        <description>No Answer Email 4</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Lead_Email_4</template>
    </alerts>
    <alerts>
        <fullName>No_Answer_Email_7</fullName>
        <description>No Answer Email 7</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Lead_Email_7</template>
    </alerts>
    <fieldUpdates>
        <fullName>Add_Opener_name_to_Lead_record</fullName>
        <field>Opener_Name__c</field>
        <formula>Owner:User.FirstName +&apos; &apos; +Owner:User.LastName</formula>
        <name>Add Opener name to Lead record</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Attempted_Contact_Lead_Stage_Date_Update</fullName>
        <field>Attempted_Contact_Lead_Stage_Date__c</field>
        <formula>TODAY()</formula>
        <name>Attempted Contact Lead Stage Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Attempted_Contact_Lead_Status_Update</fullName>
        <field>Status</field>
        <literalValue>Attempted Contact</literalValue>
        <name>Attempted Contact Lead Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Lead_Sub_Status</fullName>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>Change Lead Sub Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_status_to_Reenage</fullName>
        <field>Lead_Status__c</field>
        <literalValue>Reengage</literalValue>
        <name>Change status to Reenage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DNQ_Lead_Stage_Date_Update</fullName>
        <field>DNQ_Lead_Stage_Date__c</field>
        <formula>TODAY()</formula>
        <name>DNQ Lead Stage Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DNQ_Lead_Status_Update</fullName>
        <field>Status</field>
        <literalValue>DNQ</literalValue>
        <name>DNQ Lead Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Dead_Lead_Stage_Date_Update</fullName>
        <field>Dead_Lead_Stage_Date__c</field>
        <formula>TODAY()</formula>
        <name>Dead Lead Stage Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Dead_Lead_Status_Update</fullName>
        <field>Status</field>
        <literalValue>Dead</literalValue>
        <name>Dead Lead Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Path_Status_to_New</fullName>
        <description>When Hot Lead through Conversica  is true</description>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>Lead Status to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Lead_Stage_Date_Update</fullName>
        <field>New_Lead_Stage_Date__c</field>
        <formula>TODAY()</formula>
        <name>New Lead Stage Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Lead_Status_Path_Update</fullName>
        <field>Lead_Status__c</field>
        <literalValue>New</literalValue>
        <name>New Lead Status Path Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Lead_Status_Update</fullName>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>New Lead Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Not_Interested_Lead_Stage_Date_Update</fullName>
        <field>Not_Interested_Lead_Stage_Date__c</field>
        <formula>TODAY()</formula>
        <name>Not Interested Lead Stage Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Not_Interested_Lead_Status_Update</fullName>
        <field>Status</field>
        <literalValue>Not Interested</literalValue>
        <name>Not Interested Lead Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unconverted_Leads_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Maple_Unconverted_Leads</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Unconverted Leads Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Owner_to_Agent</fullName>
        <field>OwnerId</field>
        <lookupValue>shah.h@maple.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Lead Owner to Agent</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Working_Contacted_Lead_Stage_Date_Update</fullName>
        <field>Working_Contacted_Lead_Stage_Date__c</field>
        <formula>TODAY()</formula>
        <name>Working Contacted Lead Stage Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Working_Contacted_Lead_Status_Update</fullName>
        <field>Status</field>
        <literalValue>Working - Contacted</literalValue>
        <name>Working Contacted Lead Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Add an Opener name</fullName>
        <actions>
            <name>Add_Opener_name_to_Lead_record</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Owner_Profile_Name__c ==&apos;Cash Advance Sales Agent OffShore&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Attempted Contact Lead Status Update</fullName>
        <actions>
            <name>Attempted_Contact_Lead_Stage_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Attempted_Contact_Lead_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Lead_Status__c ) &amp;&amp; 
ISPICKVAL( Status ,&apos;New&apos;)  &amp;&amp;
( 
ISPICKVAL( Lead_Status__c , &apos;No Answer&apos;) || 
ISPICKVAL( Lead_Status__c , &apos;Busy Signal&apos;) || 
ISPICKVAL( Lead_Status__c , &apos;Fax Machine&apos;) || 
ISPICKVAL( Lead_Status__c , &apos;Dropped Call&apos;) ||
ISPICKVAL( Lead_Status__c, &apos;Bad Number&apos;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DNQ Lead Status Update</fullName>
        <actions>
            <name>DNQ_Lead_Stage_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DNQ_Lead_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Lead_Status__c ) &amp;&amp; 
( 
ISPICKVAL( Lead_Status__c , &apos;DNQ - TIB&apos;) || 
ISPICKVAL( Lead_Status__c , &apos;DNQ - Low Volume&apos;) || 
ISPICKVAL( Lead_Status__c , &apos;DNQ - No Bank Acct&apos;) ||
ISPICKVAL( Lead_Status__c , &apos;DNQ - BK/Taxes/CRA&apos;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Dead Lead Status Update</fullName>
        <actions>
            <name>Dead_Lead_Stage_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Dead_Lead_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Lead_Status__c ) &amp;&amp; 
( 
ISPICKVAL( Lead_Status__c , &apos;Wrong Person/Wrong Number&apos;) || 
ISPICKVAL( Lead_Status__c , &apos;DNC&apos;) || 
ISPICKVAL( Lead_Status__c , &apos;Language Barrier&apos;) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Sub Status Changed to New</fullName>
        <actions>
            <name>Change_Lead_Sub_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Status , &apos;New&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Lead Status Path Update</fullName>
        <actions>
            <name>New_Lead_Status_Path_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Status, &apos;New&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Lead Status Update</fullName>
        <actions>
            <name>New_Lead_Stage_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>New_Lead_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Lead_Status__c , &apos;New&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Not Interested Lead Status Update</fullName>
        <actions>
            <name>Not_Interested_Lead_Stage_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Not_Interested_Lead_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Lead_Status__c ) &amp;&amp; 
( 
ISPICKVAL( Lead_Status__c , &apos;Not Interested - Not Ready&apos;) || 
ISPICKVAL( Lead_Status__c , &apos;Not Interested - High Rates&apos;) || 
ISPICKVAL( Lead_Status__c , &apos;Not Interested - Bad Ratings&apos;) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Offshore Lead Re-assignment</fullName>
        <actions>
            <name>Update_Lead_Owner_to_Agent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Is_Application_Checklist_Completed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Owner_Profile_Name__c</field>
            <operation>equals</operation>
            <value>Cash Advance Sales Agent Offshore</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Unconverted Leads Queue</fullName>
        <active>true</active>
        <description>Change owner to Unconverted Leads Queue</description>
        <formula>NOT(Unconverted_Lead_ByPass__c) &amp;&amp; BEGINS(OwnerId, &quot;005&quot;) &amp;&amp; NOT(ISBLANK(New_Lead_Stage_Date__c)) &amp;&amp; NOT(ISPICKVAL(Status, &quot;Converted&quot;)) &amp;&amp; ( ISPICKVAL(Lead_Status__c, &quot;New&quot;) || ISPICKVAL(Lead_Status__c, &quot;Follow Up&quot;) || ISPICKVAL(Lead_Status__c, &quot;Contacted: Follow Up&quot;) || ISPICKVAL(Lead_Status__c, &quot;Contacted: Needs More Info&quot;) || ISPICKVAL(Lead_Status__c, &quot;No Answer / Busy / Dropped&quot;) || ISPICKVAL(Lead_Status__c, &quot;Reengage&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Unconverted_Leads_Queue</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Lead.New_Lead_Stage_Date__c</offsetFromField>
            <timeLength>15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update status to Reengage when Hot Lead Came in</fullName>
        <actions>
            <name>Change_status_to_Reenage</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Path_Status_to_New</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.AVA__AVAAI_hot_lead__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update status to Reengage when Hot Lead Came in</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Working Contacted Lead Status Update</fullName>
        <actions>
            <name>Working_Contacted_Lead_Stage_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Working_Contacted_Lead_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Lead_Status__c ) &amp;&amp; 
( 
ISPICKVAL( Lead_Status__c , &apos;Contacted: Follow up&apos;) || 
ISPICKVAL( Lead_Status__c , &apos;Contacted: Needs More Info&apos;) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
