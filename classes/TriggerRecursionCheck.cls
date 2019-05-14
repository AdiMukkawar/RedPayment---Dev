/*********************************************************************************
* Author: Techila Global Services Pvt Ltd. (Gaurav Agrawal)
* Class Name: TriggerRecursionCheck
* Created Date: 20-August-2018
* Description: Class for handling Recursion of Trigger
**********************************************************************************
* Updates
* Author            | Date          | Description
* 
**********************************************************************************/

public class TriggerRecursionCheck{
    
    public static Map<String,Boolean> mapRunOnce;
    
    public static boolean RunOnce(String triggerName){    
        if(mapRunOnce == null){
            mapRunOnce = new Map<String,Boolean>();
        }
        
        if(mapRunOnce.get(triggerName) != null){
            mapRunOnce.put(triggerName,false);
        }else{
            mapRunOnce.put(triggerName,true);
        }
        return mapRunOnce.get(triggerName);
    }
}